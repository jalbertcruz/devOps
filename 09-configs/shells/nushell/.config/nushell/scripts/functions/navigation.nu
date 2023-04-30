use std log
use std

export def --env rgf [pattern] {
    let res = nu -c $"
        rg ($pattern) o+e> (std null-device); rg ($pattern) --json | ripgrep_to_fzf_filter --rb 3 --lc 6
        | fzf --delimiter : --preview 'bat --color=always {1} --line-range {4}:+{5} --highlight-line {2} --wrap=character --terminal-width=80'
        | hck -L -d ':' -f 1,2,3 -D ':'
    "
    if $res != "" {
      $env.CMD = $res
      task spawn {
         run-external "code" "--reuse-window" "--goto" $"($env.CMD)"
      }
    } else {
        log error "No destination provided"
    }
}

# dirs-navigator
# senv
export def --env ch [] {
    let dest = nu -c '_choose-destination'
    if $dest != "" {
        log info $"Changing to ($dest)"
        cd $dest
    } else {
        log error "No destination provided"
    }
}

export def __chnvim [] {
    if ($env.HOME ++ '/.config/nvim-vscode' | path type) == dir {
        log info "Changing to vscode nvim"

        mv ($env.HOME ++ '/.config/nvim') ($env.HOME ++ '/.config/nvim-n')
        mv ($env.HOME ++ '/.config/nvim-vscode') ($env.HOME ++ '/.config/nvim')

        mv ($env.HOME ++ '/.local/share/nvim') ($env.HOME ++ '/.local/share/nvim-n')
        mv ($env.HOME ++ '/.local/share/nvim-vscode') ($env.HOME ++ '/.local/share/nvim')

        mv ($env.HOME ++ '/.local/state/nvim') ($env.HOME ++ '/.local/state/nvim-n')
        mv ($env.HOME ++ '/.local/state/nvim-vscode') ($env.HOME ++ '/.local/state/nvim')

    } else {
        log info "Changing to native nvim"

        mv ($env.HOME ++ '/.config/nvim') ($env.HOME ++ '/.config/nvim-vscode')
        mv ($env.HOME ++ '/.config/nvim-n') ($env.HOME ++ '/.config/nvim')

        mv ($env.HOME ++ '/.local/share/nvim') ($env.HOME ++ '/.local/share/nvim-vscode')
        mv ($env.HOME ++ '/.local/share/nvim-n') ($env.HOME ++ '/.local/share/nvim')

        mv ($env.HOME ++ '/.local/state/nvim') ($env.HOME ++ '/.local/state/nvim-vscode')
        mv ($env.HOME ++ '/.local/state/nvim-n') ($env.HOME ++ '/.local/state/nvim')
    }
}

export def setnvim [config?: string = 'vscode'] {
   let vimsetup = $env.HOME ++ '/.vimsetup'
   let current = open $vimsetup

   let configPath = '/.config/nvim'
   let localSharePath = '/.local/share/nvim'
   let localStatePath = '/.local/state/nvim'

   mv ($env.HOME ++ $configPath)      ($env.HOME ++ $"($configPath)-($current)")
   mv ($env.HOME ++ $localSharePath)  ($env.HOME ++ $"($localSharePath)-($current)")
   mv ($env.HOME ++ $localStatePath)  ($env.HOME ++ $"($localStatePath)-($current)")

   log info $"Setting nvim to ($config)"
   echo $config o> $vimsetup

   mv ($env.HOME ++ $"($configPath)-($config)")      ($env.HOME ++ $configPath)
   mv ($env.HOME ++ $"($localSharePath)-($config)")  ($env.HOME ++ $localSharePath)
   mv ($env.HOME ++ $"($localStatePath)-($config)")  ($env.HOME ++ $localStatePath)
}
