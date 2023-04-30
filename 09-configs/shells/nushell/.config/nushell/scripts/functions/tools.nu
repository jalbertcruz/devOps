use std log
use std


# ls **/*.mp4  -f                | each { |it| {name: (basename $it.name), path: (dirname $it.name), hash: (sha512sum $it.name | hck -f 1) } } | into sqlite videos.db
# ls **/*.mkv  -f                | each { |it| {name: (basename $it.name), path: (dirname $it.name), hash: (sha512sum $it.name | hck -f 1) } } | into sqlite videos.db
# ls **/*.webm -f                | each { |it| {name: (basename $it.name), path: (dirname $it.name), hash: (sha512sum $it.name | hck -f 1) } } | into sqlite videos.db
# ls **/*.md   -f                | each { |it| {name: (basename $it.name), path: (dirname $it.name)                                        } } | into sqlite mds.db

export def --env cbs [] {
   # ls **/*.epub **/*.pdf **/*.mobi **/*.azw3 **/*.djvu **/*.ps **/*.chm **/*.doc **/*.rar **/*.rtf -f $env.DOCS_HOME       | each { |it| {name: (basename $it.name | str downcase), path: (dirname $it.name), hash: (sha512sum $it.name | hck -f 1) } } | into sqlite ($env.DOCS_HOME ++ '/books.db')
   # ls **/*.epub **/*.pdf **/*.mobi **/*.azw3 **/*.djvu **/*.ps **/*.chm **/*.doc **/*.rar **/*.rtf -f | where type == file | each { |it| {name: (basename $it.name | str downcase), original_name: (basename $it.name), path: (dirname $it.name), hash: (sha512sum $it.name | hck -f 1), size: $it.size } } | into sqlite books.db
   # ls **/*.epub **/*.pdf **/*.mobi **/*.azw3 **/*.djvu **/*.ps **/*.chm **/*.doc **/*.rar **/*.rtf -f                      | each { |it| {name: (basename $it.name | str downcase), path: (dirname $it.name)                                        } } | into sqlite books.db
   cd $env.DOCS_HOME
   ls **/*.epub **/*.pdf **/*.mobi **/*.azw3 **/*.djvu **/*.ps **/*.chm **/*.doc **/*.rar **/*.rtf -f | where type == file | each { |it| try { {name: (basename $it.name | str downcase), path: (dirname $it.name)                                        }} catch { {name: $it.name, path: 'error'} } } | into sqlite ($env.DOCS_HOME ++ "/books.db")
}

export def --env bs [pat?: string] {
   let pattern = if $pat == null {
                     xclip -o -selection clipboard
                 } else {
                     $pat
                 }

    let ridT = open ($env.DOCS_HOME ++ '/books.db') | query db "SELECT cast(rowid as text) as rowid, name from main where name like ?" -p [$"%($pattern)%"]
    if ($ridT | is-not-empty) {
        let rid = $ridT | to json | jq -r '.[]' | jq '"\(.rowid):\(.name)"' | sd '"' '' | fzf | hck -L -d ':' -f 1 -D ':'
        if $rid != "" {
            let path = open ($env.DOCS_HOME ++ '/books.db') | query db "SELECT path from main where rowid = :rowid" -p {rowid: $rid} | get path | to json | jq -r '.[0]'
            echo $path | xclip -sel clip
            $path
        } else {
            log error "Operation cancelled"
        }
    } else {
        log info "No matches found"
    }
}

export def merge-video-files [] {
  # ffmpeg -i a.mp4 -i a.webm -c:v libx264 -c:a libmp3lame output.mp4
  # ffmpeg -i a.mp4 -i a.webm -c copy output.mkv
  # audio codecs: libvorbis mp3 aac
  rm --force files.db
  (
  ls ytv/audio/* -f | each { |it|
                     echo $it.name | path parse | insert kind "audio"
                  }
  ) | append (
  ls ytv/video/* -f | each { |it|
                     echo $it.name | path parse | insert kind "video"
                  }
  ) | into sqlite files.db
  open files.db | query db "SELECT stem FROM main WHERE kind = 'video'" | each { |it|
        let vals = open files.db | query db "SELECT parent, stem, extension FROM main WHERE stem = :stem" -p {stem: $it.stem}
        let v1 = $vals | get 0
        let v2 = $vals | get 1
        let audio_file = ($v1.parent + "/" + $v1.stem + "." + $v1.extension)
        let video_file = ($v2.parent + "/" + $v2.stem + "." + $v2.extension)
        ffmpeg -i $audio_file -i $video_file -c copy ("./videos/" + $v1.stem + ".mkv")
        rm --force $audio_file
        rm --force $video_file
  }

  rm --force files.db
  #log info $"($x)"
  #return 0
}

#match $g {
# {exts: ["mp4", "webm"]} => {
#   ffmpeg -i ($g.parent + $g.stem + ".mp4") -i ($g.parent + $g.stem + ".webm") -c:v copy -c:a mp3 ($g.stem + ".mkv")
# }
#}

export def extract_name_tag_and_sha_from_m4a [] {
    # https://mutagen.readthedocs.io/en/latest/man/mutagen-inspect.html
    let db_name = "dailies.db"

    ls *.m4a | each {
        |it|
        let name = $it.name
        { name: $name, tag: (run-external "mutagen-inspect" $name | rg 'nam' | str substring 6..), hash: (sha512sum $it.name | hck -f 1) }
    } | into sqlite $db_name

}

export def remove_repeated_m4a [] {
    let db_name = "dailies.db"

    let sql1 = "
            SELECT hash, COUNT(*) as c
            FROM main
            GROUP BY hash
            HAVING count(*) > 1
            order by c desc;
    "
    let ridT = open $db_name | query db $sql1
    #$ridT | each {
    #$ridT | slice 0..0 | each {
    if ($ridT | is-not-empty) {
        let rid = $ridT | to json
        $ridT | each {
            |it|
            let hash = $it.hash
            let ridT2 = open $db_name | query db "SELECT name FROM main WHERE hash = :hash" -p {hash: $hash}
            $ridT2 | slice 0..(-2) | each {
                |it2|
                let name = $it2.name
                log info $"Removing ($name)"
                rm $"($name)"
                #echo $"Removing ($name)"
            }
        }
    }
} # | wc -l

export def _apply_tag [tag: string, album: string] {
    # https://github.com/nicfit/eyeD3
    ls *.mp3 | each {
        |it|
        # let title = echo $it | str substring 4..-5
        let title = $it.name | str substring ..-5
        eyeD3 -A $album -t $"($title)" -n 2 $it.name -a $tag
    }
}

export def --env apply_tag [] {
    # https://github.com/nicfit/eyeD3
    # tag: string, album: string
    # $env.GUM_INPUT_HEADER = "Enter Album: "
    # let album = nu -c $"gum input --placeholder 'Historia'"
    # $env.GUM_INPUT_HEADER = "Enter Author: "
    # let tag = nu -c $"gum input --placeholder 'artista'"

    $env.GUM_INPUT_HEADER = "Enter tag: "
    let tag = nu -c $"gum input --placeholder 'tag'"

    _apply_tag $tag $tag
}

export def convert_to_mp3_from_m4a [] {
    ls *.m4a | each {
        |it|
        # let title = $it.name | str substring ..-5
        let title = $it.name
        ffmpeg -i $it.name -c:a libmp3lame -q:a 8 $"($title).mp3"
        #rm $it.name
    }
}

export def convert_to_mp3_from_mp4 [] {
    #mkdir mp4
    ls *.mp4 | each {
        |it|
        # let title = $it.name | str substring ..-5
        let title = $it.name
        ffmpeg -i $it.name -c:a libmp3lame -q:a 8 $"($title).mp3"
        #mv $it.name mp4/
    }
}

export def convert_to_mp3 [] {
    ls *.webm | each {
        |it|
        let title = $it.name | str substring ..-6
        ffmpeg -i $it.name -c:a libmp3lame -q:a 8 $"($title).mp3"
        #rm $it.name
    }
}

export def convert_to_mp3_from_mkv [] {
    ls *.mkv | each {
        |it|
        let title = $it.name | str substring ..-6
        ffmpeg -i $it.name -c:a libmp3lame -q:a 8 $"($title).mp3"
        #rm $it.name
    }
}

export def convert_all_to_mp3 [] {
    do -i { convert_to_mp3 }
    do -i { convert_to_mp3_from_m4a }
    do -i { convert_to_mp3_from_mp4 }
    do -i { convert_to_mp3_from_mkv }
}

export def pproxy [] {
  let x = procs --json | from json | each { |it|
      $"($it.PID)\#($it.Command)"
  }
  let pid = echo $x | fzf | hck --delimiter '\#' -f1 | tr -d " "
  if ($pid | is-not-empty) {
      log info $"Running mitmweb --mode local:($pid)"
      mitmweb --mode "local:$pid"
  }
}
