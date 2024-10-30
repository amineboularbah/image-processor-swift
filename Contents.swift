//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!
// Process the image!

// MARK: - Filter Structure
public struct Filter {
    var name: String
    var formula: (Pixel) -> Pixel  // Function that takes a Pixel and returns a modified Pixel
    
    public init(name: String, formula: @escaping (Pixel) -> Pixel) {
        self.name = name
        self.formula = formula
    }
}

func adjustBrightness(pixel: Pixel, factor: Double) -> Pixel {
    var modifiedPixel = pixel
    modifiedPixel.red = UInt8(min(255, Double(pixel.red) * factor))
    modifiedPixel.green = UInt8(min(255, Double(pixel.green) * factor))
    modifiedPixel.blue = UInt8(min(255, Double(pixel.blue) * factor))
    return modifiedPixel
}

func adjustContrast(pixel: Pixel, factor: Double) -> Pixel {
    var modifiedPixel = pixel
    let adjust = { (color: UInt8) -> UInt8 in
        let value = Double(color) - 128.0
        return UInt8(max(0, min(255, 128.0 + value * factor)))
    }
    modifiedPixel.red = adjust(pixel.red)
    modifiedPixel.green = adjust(pixel.green)
    modifiedPixel.blue = adjust(pixel.blue)
    return modifiedPixel
}

let brightnessFilter = Filter(name: "Brightness") { pixel in
    return adjustBrightness(pixel: pixel, factor: 1.2)
}

let contrastFilter = Filter(name: "Contrast") { pixel in
    return adjustContrast(pixel: pixel, factor: 1.5)
}

// MARK: - Image Processor
public struct ImageProcessor {
    public var filters: [Filter] = []
    
    public mutating func addFilter(_ filter: Filter) {
        filters.append(filter)
    }
    
    public func applyFilters(to image: RGBAImage) -> RGBAImage {
        // Use `var` to make `processedImage` mutable
        var processedImage = image
        
        for filter in filters {
            processedImage = apply(filter: filter, to: processedImage)
        }
        
        return processedImage
    }
    
    private func apply(filter: Filter, to image: RGBAImage) -> RGBAImage {
        var modifiedImage = image
        for i in 0..<modifiedImage.pixels.count {
            modifiedImage.pixels[i] = filter.formula(modifiedImage.pixels[i])
        }
        return modifiedImage
    }
}


// MARK: - Testing
if let originalImage = UIImage(named: "sample"),
   var rgbaImage = RGBAImage(image: originalImage) {

    var processor = ImageProcessor()
    
    // Add filters
    processor.addFilter(brightnessFilter)
    processor.addFilter(contrastFilter)
    
    // Apply filters
    var processedImage = processor.applyFilters(to: rgbaImage)  // Use `var` here instead of `let`
    
    // Convert back to UIImage
    let resultUIImage = processedImage.toUIImage()
    // Now, `resultUIImage` should hold the final filtered UIImage if everything else is correct.
}
