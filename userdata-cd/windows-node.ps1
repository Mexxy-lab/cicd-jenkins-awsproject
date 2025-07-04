# Set execution policy for this process
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolatey (if not already installed)
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Refresh environment to make choco immediately available
$env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"

# Install required packages
choco install temurin17 -y         # Java 17 from Eclipse Temurin (recommended)
choco install maven -y
choco install googlechrome104 -y    # Need chrome version 104. Might need to install manually
choco install git -y

# Set JAVA_HOME and update PATH
$jdkPath = Get-ChildItem "C:\Program Files\Eclipse Adoptium" | Where-Object { $_.Name -like "jdk-17*" } | Select-Object -First 1
if ($jdkPath) {
    [System.Environment]::SetEnvironmentVariable("JAVA_HOME", "$($jdkPath.FullName)", "Machine")
    [System.Environment]::SetEnvironmentVariable("Path", "$($jdkPath.FullName)\bin;$env:Path", "Machine")
}

if ($jdkPath) {
    [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath.FullName, "Machine")
    [System.Environment]::SetEnvironmentVariable("Path", "$($jdkPath.FullName)\bin;$env:Path", "Machine")
}

# Set MAVEN_HOME and update PATH
$mvnPath = "C:\ProgramData\chocolatey\lib\maven"
if (Test-Path $mvnPath) {
    $mvnDir = Get-ChildItem "$mvnPath\apache-maven-*\" | Where-Object { Test-Path "$($_.FullName)\bin\mvn.cmd" } | Select-Object -First 1
    if ($mvnDir) {
        [System.Environment]::SetEnvironmentVariable("MAVEN_HOME", $mvnDir.FullName, "Machine")
        [System.Environment]::SetEnvironmentVariable("Path", "$($mvnDir.FullName)\bin;$env:Path", "Machine")
    }
}

# Create Jenkins workspace directory
New-Item -ItemType Directory -Path "C:\jenkins" -Force

