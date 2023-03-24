@echo off

SET GOARCH=amd64

SET GOOS=linux
go build -o ./dist/axieDistributor.amd64.run main.go

SET GOOS=windows
go build -o ./dist/axieDistributor.amd64.exe main.go

set GOOS=darwin
go build -o ./dist/axieDistributor.amd64.app main.go

set GOARCH=arm64
go build -o ./dist/axieDistributor.arm64.app main.go