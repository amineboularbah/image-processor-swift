# Image Processing in Swift

This project is a simple and modular **image processing framework** built in Swift. It demonstrates how to apply filters such as **brightness adjustment** and **contrast adjustment** to images programmatically. The project leverages functional programming concepts for defining filters and allows for flexible customization of image processing workflows.

---

## 📚 Features

- **Filter-Based Architecture**:
  - Filters are defined as reusable structures with a customizable formula for pixel manipulation.
  - Includes predefined filters such as `Brightness` and `Contrast`.

- **ImageProcessor**:
  - A modular processor that applies a sequence of filters to an image.
  - Supports chaining multiple filters for complex transformations.

- **RGBA Image Handling**:
  - Works with an RGBA image representation to directly manipulate pixel data.

---

## 🔧 How It Works

### 1. **Defining a Filter**
Filters are defined using a `Filter` struct, which takes a name and a pixel-processing formula:

```
let brightnessFilter = Filter(name: "Brightness") { pixel in
    return adjustBrightness(pixel: pixel, factor: 1.2)
}
```

### 2. **Adjusting Pixel Properties**
Functions like `adjustBrightness` and `adjustContrast` manipulate individual pixel properties (red, green, blue) to achieve the desired effect.

### 3. **Applying Filters**
The `ImageProcessor` applies filters in sequence to an image. Each filter processes every pixel in the image:

```
var processor = ImageProcessor()
processor.addFilter(brightnessFilter)
processor.addFilter(contrastFilter)
let processedImage = processor.applyFilters(to: rgbaImage)
```

---

## 📂 File Structure

- **Filters**: Contains definitions and formulas for individual image filters.
- **ImageProcessor**: A structure to manage and apply filters to an image.
- **Testing**: A demonstration of how to use the framework to apply multiple filters.

---

## 🚀 Getting Started

### Prerequisites
- Xcode installed on macOS.
- A basic understanding of Swift and image processing.

### Running the Project
1. Clone the repository.
2. Add an image named `sample` to your Xcode project's assets.
3. Open the project in Xcode.
4. Build and run to see the filtered output applied to the `sample` image.

---

## 🛠️ Example Usage

```
// Define filters
let brightnessFilter = Filter(name: "Brightness") { pixel in
    return adjustBrightness(pixel: pixel, factor: 1.2)
}

let contrastFilter = Filter(name: "Contrast") { pixel in
    return adjustContrast(pixel: pixel, factor: 1.5)
}

// Apply filters using ImageProcessor
var processor = ImageProcessor()
processor.addFilter(brightnessFilter)
processor.addFilter(contrastFilter)

// Process the image
let processedImage = processor.applyFilters(to: rgbaImage)
```

---

## 🧑‍💻 About Me

I am a **Senior Mobile Developer** with expertise in crafting efficient and scalable applications. With a strong foundation in **native iOS, Android, and cross-platform frameworks like Flutter**, I enjoy tackling challenging problems and building solutions that deliver great user experiences.

This project is a reflection of my interest in exploring **image processing** and advancing my knowledge in functional programming and low-level data manipulation.

Feel free to connect and explore more about my work at [www.amineboularbah.com](https://www.amineboularbah.com).
