package main

import (
	"io/ioutil"
	"strings"
	//"bytes"
	"fmt"
	"os"
)

func main() {
	// read whole the file
	b, err := ioutil.ReadFile("Dockerfile_temp")
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(b), "\n")
	fmt.Println(lines)

	var flag int
	flag = 0
	//var buffer bytes.Buffer
	f, err := os.Create("Dockerfile")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	// n2, err := f.Write(d2)

	for i := 0; i < len(lines); i++ {
		if strings.Contains(lines[i], "RUN") {

			if flag == 0 {

				lines[i] = lines[i] + " && \\"
				flag = 1
			} else {
				if strings.Contains(lines[i+1], "RUN") {
					lines[i] = "   " + lines[i][3:] + " && \\"
				} else {
					lines[i] = "   " + lines[i][3:]
				}
			}

		} else {
			flag = 0 // reset the flag when run is absent 
		}
	}
	fmt.Println(lines)

	for i := 0; i < len(lines); i++ {
		_, err = f.WriteString(lines[i] + "\n")
		if err != nil {
			panic(err)
		}

	}

}
