# Set execution policy for this process
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install required packages
choco install jdk8 -y
choco install maven -y
choco install googlechrome -y
choco install git -y

# Create Jenkins directory
New-Item -ItemType Directory -Path "C:\jenkins" -Force
