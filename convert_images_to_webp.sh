#!/bin/sh -e

find ./ -type f -name '*.png' -exec sh -c 'cwebp -q 75 $1 -o "${1%.jpg}.webp"' _ {} \;

find . -name '*png.webp' | while read file; do                                        
  mv "$file" "${file%.png.webp}.webp"
done
