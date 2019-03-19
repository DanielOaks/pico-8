// pico-8 demo intro screen png converter
// written by pixienop 2018
// released under CC0

package main

import (
	"fmt"
	"image"
	"image/color"
	"image/png"
	"log"
	"os"

	"github.com/docopt/docopt-go"
)

// PICO8 palette
var PICO8 = color.Palette{
	color.RGBA{0x00, 0x00, 0x00, 0xff},
	color.RGBA{0x1D, 0x2B, 0x53, 0xff},
	color.RGBA{0x7E, 0x25, 0x53, 0xff},
	color.RGBA{0x00, 0x87, 0x51, 0xff},
	color.RGBA{0xAB, 0x52, 0x36, 0xff},
	color.RGBA{0x5F, 0x57, 0x4F, 0xff},
	color.RGBA{0xC2, 0xC3, 0xC7, 0xff},
	color.RGBA{0xFF, 0xF1, 0xE8, 0xff},
	color.RGBA{0xFF, 0x00, 0x4D, 0xff},
	color.RGBA{0xFF, 0xA3, 0x00, 0xff},
	color.RGBA{0xFF, 0xEC, 0x27, 0xff},
	color.RGBA{0x00, 0xE4, 0x36, 0xff},
	color.RGBA{0x29, 0xAD, 0xFF, 0xff},
	color.RGBA{0x83, 0x76, 0x9C, 0xff},
	color.RGBA{0xFF, 0x77, 0xA8, 0xff},
	color.RGBA{0xFF, 0xCC, 0xAA, 0xff},
}

func loadPNGImage(filename string) (*image.Image, error) {
	imgFile, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer imgFile.Close()

	// imgData, imgType, err := image.Decode(imgFile)
	// if err != nil {
	// 	return nil, err
	// }
	// imgFile.Seek(0, 0)

	img, err := png.Decode(imgFile)
	if err != nil {
		return nil, err
	}

	return &img, nil
}

func main() {
	usage := `p8conv.
Usage:
	p8conv <filename-prefix>
	p8conv -h | --help
	p8conv --version
Options:
	-h --help          Show this screen.
	--version          Show version.`

	arguments, _ := docopt.ParseDoc(usage)

	fnPrefix := arguments["<filename-prefix>"].(string)

	// raw
	rawImgFilePointer, err := loadPNGImage(fnPrefix + ".png")
	if err != nil {
		log.Fatalf("Failed to load raw img: %s\n", err.Error())
	}
	rawImg := (*rawImgFilePointer)

	rawImgBounds := rawImg.Bounds()
	if rawImgBounds.Min.X != 0 || rawImgBounds.Min.Y != 0 {
		log.Fatalf("Raw image min bound is not correct: expected 0,0, got %d,%d\n", rawImgBounds.Min.X, rawImgBounds.Min.Y)
	}
	if rawImgBounds.Max.X != 32 || rawImgBounds.Max.Y != 20 {
		log.Fatalf("Raw image min bound is not correct: expected 32,20, got %d,%d\n", rawImgBounds.Max.X, rawImgBounds.Max.Y)
	}

	fmt.Println("Raw:")
	print("  \"")
	for y := 0; y < 20; y++ {
		for x := 0; x < 32; x++ {
			// r, g, b, a := rawImg.At(x, y).RGBA()
			p8ColorIndex := PICO8.Index(rawImg.At(x, y))
			print(fmt.Sprintf("%x", p8ColorIndex))
		}
	}
	fmt.Println("\"")

	// mask
	maskImgFilePointer, err := loadPNGImage(fnPrefix + "-mask.png")
	if err != nil {
		log.Fatalf("Failed to load mask img: %s\n", err.Error())
	}
	maskImg := (*maskImgFilePointer)

	maskImgBounds := maskImg.Bounds()
	if maskImgBounds.Min.X != 0 || maskImgBounds.Min.Y != 0 {
		log.Fatalf("mask image min bound is not correct: expected 0,0, got %d,%d\n", maskImgBounds.Min.X, maskImgBounds.Min.Y)
	}
	if maskImgBounds.Max.X != 32 || maskImgBounds.Max.Y != 20 {
		log.Fatalf("mask image min bound is not correct: expected 32,20, got %d,%d\n", maskImgBounds.Max.X, maskImgBounds.Max.Y)
	}

	fmt.Println("Mask:")
	print("  \"")
	for y := 0; y < 20; y++ {
		for x := 0; x < 32; x++ {
			// r, g, b, a := maskImg.At(x, y).RGBA()
			p8ColorIndex := PICO8.Index(maskImg.At(x, y))
			print(fmt.Sprintf("%x", p8ColorIndex))
		}
	}
	fmt.Println("\"")
}
