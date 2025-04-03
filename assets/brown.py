from PIL import Image, ImageOps

# Load the image
image = Image.open(r"C:\Users\bhart\Downloads\Coding\flutter\flutter_app_2\assets\building.png")  # Replace with your file path

# Convert to grayscale
gray_image = ImageOps.grayscale(image)

# Apply a brown tint
brown_tint = ImageOps.colorize(gray_image, black="#795548", white="#FFFFFF")  # White background, brown building

# Save the modified image
brown_tint.save(r'C:\Users\bhart\Downloads\Coding\flutter\flutter_app_2\assets\building_brown.png')

# Display the modified image
brown_tint.show()
