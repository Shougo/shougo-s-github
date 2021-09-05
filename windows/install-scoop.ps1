##################################################
# Install Scoop script
##################################################

# Check
try {
  get-command scoop -ErrorAction Stop
} catch [Exception] {
  Set-ExecutionPolicy RemoteSigned -scope CurrentUser
  Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

# Install basic modules
scoop install aria2
scoop install git
scoop install sudo

# Add buckets
scoop bucket add extras
scoop bucket add versions

# Root directory
$SCOOP_ROOT = if ($env:SCOOP) {$env:SCOOP} else {"$home\scoop"}
