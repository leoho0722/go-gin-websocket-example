package websocket

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	websocket "github.com/gorilla/websocket"
)

type WebSocketMessage struct {
	Message string `json:"message"`
}

func WebSocketHandler(c *gin.Context) {
	upGrader := websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
	}

	ws, err := upGrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		panic(err)
	}

	defer func() {
		err := ws.Close()
		if err != nil {
			panic(err)
		}
	}()

	for {
		msgType, msg, err := ws.ReadMessage()
		if err != nil {
			panic(err)
		}

		fmt.Printf("Message Type: %d, Message: %s\n", msgType, string(msg))
		err = ws.WriteJSON(WebSocketMessage{
			Message: "Received: " + string(msg),
		})
		if err != nil {
			panic(err)
		}
	}
}
