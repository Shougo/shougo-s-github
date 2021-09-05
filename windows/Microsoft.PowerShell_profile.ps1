# Functions
function ..() { cd ../ }


# Change prompt
function prompt {
  $isRoot = (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
  $color  = if ($isRoot) {"Red"} else {"Green"}
  $marker = if ($isRoot) {"#"}   else {"$"}

  Write-Host "$env:USERNAME " -ForegroundColor $color -NoNewline
    Write-Host "$pwd " -ForegroundColor Magenta -NoNewline
    Write-Host $marker -ForegroundColor $color -NoNewline
    return " "
}


# Keymappings
Set-PSReadLineOption -EditMode Emacs -BellStyle None
Set-PSReadLineKeyHandler -Key Ctrl+i -Function Complete
Set-PSReadLineKeyHandler -Key Ctrl+j -Function AcceptLine
Set-PSReadLineKeyHandler -Key Ctrl+y -Function Paste
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadLineOption -PredictionSource History
