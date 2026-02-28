# Better mv, cp, mkdir
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'

# Improve du, df
alias du='du -h'
alias df='df -h'

# Improve od for hexdump
alias od='od -Ax -tx1z'
alias hexdump='hexdump -C'

# Minimal Neovim
alias nvim='nvim \
    -V0 -n -u NONE --noplugin -S $HOME/.config/nvim/init.vim \
    $( [ ! -e $HOME/.cache/nvim/server.pipe ] && \
      echo "--listen $HOME/.cache/nvim/server.pipe" )'
