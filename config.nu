# config.nu (Cross-Platform: Linux & Windows)

$env.config.buffer_editor = "nvim"
alias n = nvim
alias c = clear 
alias l = ls 
alias lg = lazygit

$env.config.show_banner = false
$env.config.shell_integration.osc133 = false

----------------------------------------------------------------------
# 1. CROSS-PLATFORM PATHS & DIRECTORIES
----------------------------------------------------------------------
# 1. Determine the correct Repo path based on the OS
let repo_path = if ($nu.os-info.name == "windows") {
    ($env.USERPROFILE | path join "Source" "Repo")
} else {
    "~/Source/Repo"
}

# Notice the '--env' flag here!
def --env tr [subfolder?: string] {
    if ($subfolder == null) {
        cd $repo_path
    } else {
        cd ($repo_path | path join $subfolder)
    }
}

let nvim_path = if ($nu.os-info.name == "windows") {
    ($env.LOCALAPPDATA | path join "nvim")
} else {
    "~/.config/nvim"
}

# Notice the '--env' flag here too!
def --env tn [subfolder?: string] {
    if ($subfolder == null) {
        cd $nvim_path
    } else {
        cd ($nvim_path | path join $subfolder)
    }
}

----------------------------------------------------------------------
# 2. PROMPT & STARSHIP SETUP
----------------------------------------------------------------------
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

$env.STARSHIP_SHELL = "nu"

----------------------------------------------------------------------
# 3. ENVIRONMENT SOURCES (CROSS-PLATFORM SAFE)
----------------------------------------------------------------------
# let is_windows = $nu.os-info.name == "windows"
#
# # Since `source` requires a parse-time constant or literal string, 
# # we use try/catch blocks which gracefully skip if the file doesn't exist.
# if $is_windows {
#     try { source ("~/.cargo/env.nu" | path expand) }
# } else {
#     try { source ~/.cargo/env.nu }
# }

----------------------------------------------------------------------
# 4. CUSTOM COMMANDS
----------------------------------------------------------------------
def fps [] {
  print 'git fetch pull status'
  git fetch -a 
  git pull 
  git status
}

def mrClean [] {
  git reset --hard
  git clean -fd
  print 'all clean :)'
}

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "

