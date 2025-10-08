package main

import (
	"syscall/js"
)

var board [3][3]string
var currentPlayer = "X"

func makeMove(this js.Value, args []js.Value) interface{} {
	row := args[0].Int()
	col := args[1].Int()
	if board[row][col] == "" {
		board[row][col] = currentPlayer
		if currentPlayer == "X" {
			currentPlayer = "O"
		} else {
			currentPlayer = "X"
		}
		return board[row][col]
	}
	return ""
}

func checkWinner(this js.Value, args []js.Value) interface{} {
	// Cek baris
	for i := 0; i < 3; i++ {
		if board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != "" {
			return board[i][0]
		}
	}
	// Cek kolom
	for i := 0; i < 3; i++ {
		if board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != "" {
			return board[0][i]
		}
	}
	// Cek diagonal
	if board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != "" {
		return board[0][0]
	}
	if board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != "" {
		return board[0][2]
	}
	return ""
}

func resetGame(this js.Value, args []js.Value) interface{} {
	board = [3][3]string{}
	currentPlayer = "X"
	return nil
}

func main() {
	js.Global().Set("makeMove", js.FuncOf(makeMove))
	js.Global().Set("checkWinner", js.FuncOf(checkWinner))
	js.Global().Set("resetGame", js.FuncOf(resetGame))
	select {}
}