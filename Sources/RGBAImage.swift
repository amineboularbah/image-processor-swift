import UIKit

public struct Pixel {
    public var value: UInt32
    
    public var red: UInt8 {
        get { return UInt8(value & 0xFF) }
        set { value = UInt32(newValue) | (value & 0xFFFFFF00) }
    }
    
    public var green: UInt8 {
        get { return UInt8((value >> 8) & 0xFF) }
        set { value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF) }
    }
    
    public var blue: UInt8 {
        get { return UInt8((value >> 16) & 0xFF) }
        set { value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF) }
    }
    
    public var alpha: UInt8 {
        get { return UInt8((value >> 24) & 0xFF) }
        set { value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF) }
    }
}

// MARK: - RGBAImage Structure
public struct RGBAImage {
    public var pixels: [Pixel]
    public var width: Int
    public var height: Int
    
    public init?(image: UIImage) {
        guard let cgImage = image.cgImage else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        width = Int(image.size.width)
        height = Int(image.size.height)
        let bytesPerRow = width * 4
        
        // Update for latest Swift and Xcode versions:
        // Replaced deprecated `alloc` and `dealloc` methods with `allocate(capacity:)` and `deallocate()`
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        
        // Create context for image processing
        guard let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            imageData.deallocate()
            return nil
        }
        
        // Draw the image into the context to get pixel data
        imageContext.draw(cgImage, in: CGRect(origin: .zero, size: image.size))
        
        // Initialize pixels array from the buffer
        let bufferPointer = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
        pixels = Array(bufferPointer)
        
        // Deallocate the memory allocated for imageData after copying to `pixels`
        imageData.deallocate()
    }
    
    public mutating func toUIImage() -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue

        let bytesPerRow = width * 4

        // Safely access the underlying data of `pixels` with `withUnsafeMutableBytes`
        return pixels.withUnsafeMutableBytes { ptr in
            guard let baseAddress = ptr.baseAddress else { return nil }

            // Create context to turn pixel data back into a UIImage
            guard let imageContext = CGContext(
                data: baseAddress,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
            ) else {
                return nil
            }

            // Generate the final UIImage from context
            guard let cgImage = imageContext.makeImage() else { return nil }
            return UIImage(cgImage: cgImage)
        }
    }

}
