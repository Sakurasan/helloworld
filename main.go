package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
)

var (
	msg string
)

func main() {
	var port string
	if len(os.Args) > 1 {
		port = ":" + os.Args[1]
	}
	mux := http.NewServeMux()
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Query().Get("hello") != "" {
			msg = r.URL.Query().Get("hello")
		}

		fmt.Println(r.RemoteAddr, r.URL.String())
		fmt.Println("Scheme", r.URL.Scheme, "Host", r.URL.Host, "Path", r.URL.Path)
		io.WriteString(w, fmt.Sprintf("hello %s"+"\n", msg))
	})

	if port != "" {
		fmt.Println("当前监听:", port)
		fmt.Println(http.ListenAndServe(port, mux))
	} else {
		fmt.Println("当前监听:80")
		fmt.Println(http.ListenAndServe(":80", mux))

	}

}
