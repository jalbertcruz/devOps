# download video with description and metadata
function dv
    set url (xclip -o -selection clipboard)
    #   yt-dlp "$url" --write-description --no-clean-info-json --write-info-json --write-playlist-metafiles --embed-metadata --embed-chapters --write-auto-subs --sub-format "srt/best"
    #   yt-dlp "$url" --write-description --no-clean-info-json --write-info-json --write-playlist-metafiles --embed-metadata --embed-chapters

    if test -e cookies.txt
        yt-dlp "$url" --cookies cookies.txt --embed-metadata --embed-chapters --remote-components ejs:github
         # [youtube] [jsc:deno] Downloading challenge solver lib script from  https://github.com/yt-dlp/ejs/releases/download/0.8.0/yt.solver.lib.min.js
    else
        yt-dlp "$url" --embed-metadata --embed-chapters
    end
end

function gen-file-from-clipboard
    set file_name cookies.txt
    if test (count $argv) -ge 1
        set file_name $argv[1]
    end
    set content (xclip -o -selection clipboard)
    printf "%s\n" $content >$file_name
end

function dvl
    set url (xclip -o -selection clipboard)
    if test -e cookies.txt
        yt-dlp -F "$url" --cookies cookies.txt --remote-components ejs:github
    else
        yt-dlp -F "$url"
    end
end

function dvc
    set url (xclip -o -selection clipboard)
    #yt-dlp -f $argv[1] "$url" --write-description --no-clean-info-json --write-info-json --write-playlist-metafiles --embed-metadata --embed-chapters --write-subs --write-auto-subs
    if test -e cookies.txt
        yt-dlp -f $argv[1] "$url" --write-description --no-clean-info-json --write-info-json --write-playlist-metafiles --embed-metadata --embed-chapters --cookies cookies.txt --remote-components ejs:github
    else
        yt-dlp -f $argv[1] "$url" --write-description --no-clean-info-json --write-info-json --write-playlist-metafiles --embed-metadata --embed-chapters
    end
end

function get-media-codecs
    # Get the video resolution video codec and audio codec of a media file:
    echo "Video:"
    ffprobe -v error -select_streams v:0 -show_entries stream=width,height,codec_name -of default=noprint_wrappers=1 "$argv[1]"
    echo ""
    echo "Audio:"
    ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1 "$argv[1]"
end
