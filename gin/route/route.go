package route

import (
	"github.com/gin-gonic/gin"
	"leoho.io/go-gin-websocket-example/network"
	"leoho.io/go-gin-websocket-example/websocket"
)

type PathRawValue string

const (
	WebSocket PathRawValue = "/ws"
)

func SetupRoute() {
	route := gin.Default()
	route.GET(string(WebSocket), websocket.WebSocketHandler)

	ip := network.GetIP()
	err := route.Run(ip + ":8080")
	if err != nil {
		panic(err)
	}
}
