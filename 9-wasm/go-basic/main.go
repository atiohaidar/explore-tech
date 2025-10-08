package main

import (
	"syscall/js"
)

func main() {
	// Ekspor fungsi ke JavaScript
	js.Global().Set("helloWasm", js.FuncOf(func(this js.Value, args []js.Value) interface{} {
		println("Hello from WASM!")
		// Ubah elemen HTML jika ada
		document := js.Global().Get("document")
		element := document.Call("getElementById", "output")
		if !element.IsUndefined() {
			element.Set("innerHTML", "Hello from WebAssembly!")
		}
		return nil
	}))

	// Biarkan program berjalan
	select {}
}