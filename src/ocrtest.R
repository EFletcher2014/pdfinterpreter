library(EBImage)
library(tidyverse)
library(magick)
library(tesseract)

color.image <- readImage("/Users/bandg/OneDrive/Documents/flashdrivestuff/Masters/Thesis/tempimages/1/Page-3.tiff")
bw.image <- channel(color.image, "gray")
writeImage(bw.image, file = "/Users/bandg/OneDrive/Documents/flashdrivestuff/Masters/Thesis/tempimages/1/Page-3bw.png")
image1 <- image_read("/Users/bandg/OneDrive/Documents/flashdrivestuff/Masters/Thesis/tempimages/1/Page-3bw.png")

image_bearb1 <- image1 %>% 
  image_scale("x2000") %>%                        # rescale
  image_background("white", flatten = TRUE) %>%   # set background to white
  image_trim() %>%                                # Trim edges that are the background color from the image.
  image_noise() %>%                               # Reduce noise in image using a noise peak elimination filter
  image_enhance() %>%                             # Enhance image (minimize noise)
  image_normalize() %>%                           # Normalize image (increase contrast by normalizing the pixel values to span the full range of color values).
  image_contrast(sharpen = 1) %>%                 # increase contrast
  image_deskew(threshold = 40)

image_write(image_bearb1, path = "/Users/bandg/OneDrive/Documents/flashdrivestuff/Masters/Thesis/tempimages/1/Page-3Final.png", format = "png")
text1 <- ocr("/Users/bandg/OneDrive/Documents/flashdrivestuff/Masters/Thesis/tempimages/1/Page-3Final.png")
print(text1)
sink("/Users/bandg/OneDrive/Documents/flashdrivestuff/Masters/Thesis/tempimages/1/page-3Text.txt")
cat(text1)
sink()
#TODO: Save text to PDF