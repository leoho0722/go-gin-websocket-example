package websocket

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	websocket "github.com/gorilla/websocket"
)

type Message struct {
	Message string `json:"message"`
}

func Handler(c *gin.Context) {
	upGrader := websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
	}

	ws, err := upGrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Fatalf("Error upgrading connection: %v", err)
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
			log.Fatalf("Error reading message: %v", err)
		}

		fmt.Printf("Message Type: %d\n, Message: %s\n", msgType, string(msg))
		err = ws.WriteJSON(Message{
			Message: "Success",
		})
		if err != nil {
			log.Fatalf("Error writing message: %v", err)
		}
	}
}
