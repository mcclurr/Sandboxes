package main

import (
	"fmt"

	"github.com/mcclurr/Sandboxes/Golang/mapreduce/master/utils"
)

func main() {
	fmt.Println("Hello, Master!")
	utils.ReadConfig("hello")
}
