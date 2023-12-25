package main

import (
	"encoding/binary"
	"log"
	"math"

	"tinygo.org/x/bluetooth"
)

var adapter = bluetooth.DefaultAdapter

// type Data struct {
// 	T int `struc:"uint16,little"`
// 	H int `struc:"uint16,little"`
// 	C int `struc:"uint16,little"`
// }

func main() {
	// Enable BLE interface.
	must("enable BLE stack", adapter.Enable())

	// Start scanning.
	log.Println("scanning...")
	err := adapter.Scan(func(adapter *bluetooth.Adapter, device bluetooth.ScanResult) {
		//log.Println("found device:", device.Address.String(), device.RSSI, device.LocalName())
		if device.Address.String() == "EE:C8:36:2C:CB:39" {
			//log.Println("found device:", device.Address.String(), device.RSSI, device.LocalName())
			//log.Printf("device data: %v, %v\n", device.AdvertisementPayload.LocalName(), device.AdvertisementPayload.ManufacturerData())
			for _, value := range device.AdvertisementPayload.ManufacturerData() {
				log.Printf("Temp: %.2f", -45+((175.0*float64(uint64(binary.LittleEndian.Uint16(value[4:6]))))/(math.Pow(2, 16)-1)))
				log.Printf("Hum: %.2f", (100.0*float64(binary.LittleEndian.Uint16(value[6:8])))/(math.Pow(2, 16)-1))
				log.Printf("CO2: %d", binary.LittleEndian.Uint16(value[8:10]))

				// uses "github.com/lunixbochs/struc"
				// reader := bytes.NewReader(value[4:10])
				// data := &Data{}
				// err := struc.Unpack(reader, data)
				// if err != nil {
				// 	log.Printf("%v", err.Error())
				// }
				// log.Printf("%#v", data)
			}
		}
	})
	must("start scan", err)
}

func must(action string, err error) {
	if err != nil {
		panic("failed to " + action + ": " + err.Error())
	}
}
