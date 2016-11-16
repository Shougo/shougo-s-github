# Suppress the intro messages
function fish_greeting
end

function cd
  builtin cd $argv
  ls
end
