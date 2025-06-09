# Global variables
# --------------------------------------

# Path
export PATH="$HOME/.zsh/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"

# FZF configuration
# Make Tab accept the selection (Enter still works too)
export FZF_DEFAULT_OPTS="--bind=tab:accept"

# Optional: If you want Tab to ONLY accept and disable the default Tab behavior (toggle selection)
# export FZF_DEFAULT_OPTS="--bind=tab:accept,shift-tab:toggle"

# Apply the same binding to specific fzf commands
export FZF_CTRL_T_OPTS="--bind=tab:accept" # File search (Ctrl+T)
export FZF_CTRL_R_OPTS="--bind=tab:accept" # History search (Ctrl+R)
export FZF_ALT_C_OPTS="--bind=tab:accept"  # Directory search (Alt+C)
