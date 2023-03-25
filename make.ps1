if (Test-Path "./dist") {
    Write-Host "Removing old dist folder"
    Remove-Item -Recurse -Force dist
}

Write-Host "Creating new dist folder"

Write-Host "Setting GOARCH to amd64"
$env:GOARCH = 'amd64'

Write-Host "Setting GOOS to linux"
$env:GOOS = 'linux'
Write-Host "Building linux binary for amd64 to ./dist/axieDistributor.amd64.run"
go build -o ./dist/axieDistributor.amd64.run main.go

Write-Host "Setting GOOS to windows"
$env:GOOS = 'windows'
Write-Host "Building windows binary for amd64 to ./dist/axieDistributor.amd64.exe"
go build -o ./dist/axieDistributor.amd64.exe main.go

Write-Host "Setting GOOS to darwin"
$env:GOOS = 'darwin'
Write-Host "Building darwin binary for amd64 to ./dist/axieDistributor.amd64.app"
go build -o ./dist/axieDistributor.amd64.app main.go

Write-Host "Setting GOARCH to arm64"
$env:GOARCH = 'arm64'
Write-Host "Building linux binary for arm64 to ./dist/axieDistributor.arm64.run"
go build -o ./dist/axieDistributor.arm64.app main.go

Set-Location dist

Write-Host "Compressing files"

Get-ChildItem -Path . | ForEach-Object {
    $zipFileName = "$($_.Name).zip"
    $zipFileFullPath = Join-Path -Path . -ChildPath $zipFileName
    Compress-Archive -Path $_.FullName -DestinationPath $zipFileFullPath
}

Set-Location ..

Write-Host "Done!"
