package websocket

import (
	"fmt"
	"log"
	"net/http"

	websocket "github.com/gorilla/websocket"
)

type Message struct {
	Message string `json:"message"`
}

func Handler(w http.ResponseWriter, r *http.Request) {
	upGrader := websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
	}

	ws, err := upGrader.Upgrade(w, r, nil)
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
		_, msg, err := ws.ReadMessage()
		if err != nil {
			log.Fatalln("Error reading message: ", err)
		}
		fmt.Printf("Received Message: %s\n", string(msg))

		err = ws.WriteJSON(Message{
			Message: "Received: " + string(msg),
		})
		if err != nil {
			log.Fatalf("Error writing json: %s", err)
		}
	}
}
