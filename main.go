package main

import (
	"embed"
	"fmt"
	"github.com/labstack/echo/v4"
	"io/fs"
	"net/http"
	"os"
	"os/exec"
	"os/signal"
	"runtime"
	"syscall"
)

//go:embed index.html
var index embed.FS

func main() {
	// Initialize Echo
	e := echo.New()
	e.HideBanner = true
	e.HidePort = true

	// Serve the bundled index.html file
	e.GET("/", func(c echo.Context) error {
		file, err := index.Open("index.html")
		if err != nil {
			return err
		}
		defer func(file fs.File) {
			err = file.Close()
			if err != nil {
				panic(err)
			}
		}(file)

		_, err = file.Stat()
		if err != nil {
			return err
		}

		content, err := fs.ReadFile(index, "index.html")
		if err != nil {
			return err
		}

		return c.Blob(http.StatusOK, "text/html", content)
	})

	// Start the web server
	go func() {
		if err := e.Start(":8080"); err != nil {
			e.Logger.Fatal(err)
		}
		println("hi")
	}()

	// Open browser
	url := "http://localhost:8080"
	switch runtime.GOOS {
	case "darwin":
		_ = exec.Command("open", url).Start()
	case "linux":
		_ = exec.Command("xdg-open", url).Start()
	case "windows":
		_ = exec.Command("cmd", "/c", "start", url).Start()
	default:
		fmt.Printf("Please open a browser and navigate to %s", url)
	}

	println("Welcome to: Saigon Axie Distributor!")
	println("Please wait for the browser to open...")
	println("If the browser does not open, please open a browser and navigate to http://localhost:8080")

	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, os.Interrupt, syscall.SIGTERM)

	for {
		select {
		case <-interrupt:
			fmt.Println("\nReceived interrupt signal, shutting down...")
			return
		}
	}
}
