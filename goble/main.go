package main

import (
	"encoding/binary"
	"fmt"
	"log"
	"math"
	"os"
	"time"

	"tinygo.org/x/bluetooth"
)

var (
	adapter = bluetooth.DefaultAdapter
	address = "EE:C8:36:2C:CB:39"
)

// type Data struct {
// 	T int `struc:"uint16,little"`
// 	H int `struc:"uint16,little"`
// 	C int `struc:"uint16,little"`
// }

func main() {
	arguments := os.Args
	if len(arguments) == 2 {
		address = arguments[1]
	}
	if len(arguments) > 2 {
		log.Fatal("USAGE: ./goble <address>")
	}

	// timeout
	timeout := time.NewTimer(10 * time.Second)
	go func() {
		<-timeout.C
		log.Fatal("Timeout reached!")
	}()

	// enable BLE interface
	must("enable BLE stack", adapter.Enable())

	// Start scanning
	log.Println("scanning...")
	err := adapter.Scan(func(adapter *bluetooth.Adapter, device bluetooth.ScanResult) {
		//fmt.Println("found device:", device.Address.String(), device.RSSI, device.LocalName())
		if device.Address.String() == address {
			//fmt.Println("found device:", device.Address.String(), device.RSSI, device.LocalName())
			//fmt.Printf("device data: %v, %v\n", device.AdvertisementPayload.LocalName(), device.AdvertisementPayload.ManufacturerData())
			for _, value := range device.AdvertisementPayload.ManufacturerData() {
				fmt.Printf("Temperature: %.2f\n", -45+((175.0*float64(uint64(binary.LittleEndian.Uint16(value[4:6]))))/(math.Pow(2, 16)-1)))
				fmt.Printf("Humidity: %.2f\n", (100.0*float64(binary.LittleEndian.Uint16(value[6:8])))/(math.Pow(2, 16)-1))
				fmt.Printf("CO2 ppm: %d\n", binary.LittleEndian.Uint16(value[8:10]))

				// uses "github.com/lunixbochs/struc"
				// reader := bytes.NewReader(value[4:10])
				// data := &Data{}
				// err := struc.Unpack(reader, data)
				// if err != nil {
				// 	fmt.Printf("%v\n", err.Error())
				// }
				// fmt.Printf("%#v\n", data)
			}
			adapter.StopScan()
		}
	})
	must("start scan", err)
}

func must(action string, err error) {
	if err != nil {
		panic("failed to " + action + ": " + err.Error())
	}
}
