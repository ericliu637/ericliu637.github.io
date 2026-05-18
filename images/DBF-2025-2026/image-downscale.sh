#!/bin/bash

# Check if imagemagick is installed
if ! command -v magick &> /dev/null && ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed. Please install it first."
    exit 1
fi

# Determine which command to use (ImageMagick v7 uses 'magick', v6 uses 'convert')
if command -v magick &> /dev/null; then
    CMD="magick"
else
    CMD="convert"
fi

# Counter for processed images
count=0

# Loop through .jpg, .JPG, and .png files (case-insensitive via extended globbing)
# We use shopt nullglob so the script doesn't error if no files are found
shopt -s nullglob
shopt -s nocaseglob

for img in *.jpg *.png *.HEIC; do
    echo "Processing: $img"

    # Create a temporary filename to avoid overwriting while reading
    temp_file="temp_$img"

    # Resize to 50% of original dimensions
    $CMD "$img" -resize 50% "$temp_file"

    # If the conversion was successful, replace the original
    if [ $? -eq 0 ]; then
        mv "$temp_file" "$img"
        echo "Successfully resized $img"
        ((count++))
    else
        echo "Error processing $img. Skipping."
        rm -f "$temp_file"
    fi
done

shopt -u nocaseglob
shopt -u nullglob

echo "---------------------------------------"
echo "Done! Total images resized: $count"
