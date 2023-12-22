package route

import (
	"log"
	"net/http"

	"leoho.io/go-gorilla-websocket-example/network"
	"leoho.io/go-gorilla-websocket-example/websocket"
)

type PathRawValue string

const (
	WebSocket PathRawValue = "/ws"
)

func SetupRoute() {
	http.HandleFunc(string(WebSocket), websocket.Handler)

	ip := network.GetIP()
	err := http.ListenAndServe(ip+":8080", nil)
	if err != nil {
		log.Fatalf("Error - ListenAndServe: %v", err)
	}
}
