library(EBImage)
library(tidyverse)
library(magick)
library(tesseract)
library(gWidgets)
library(gWidgetstcltk)

#GUI
win <- gwindow("PDF Interpreter")
grp_inputtype <- ggroup(container = win)
label_input <- glabel("Input: ", container = grp_inputtype)
inputType <- gradio(c("Single File", "Folder"), container = grp_inputtype)
inputFile <- gfilebrowse(text = "Select a file", quote = FALSE, type = "open", container = grp_inputtype)
inputFolder <- gfilebrowse(text = "Select a folder", quote = FALSE, type = "selectdir", container = grp_inputtype)
add(grp_inputtype, inputFile)
delete(grp_inputtype, inputFolder)
addHandlerChanged(inputType, handler = function(h, ...){
  if(svalue(inputType) == "Single File")
  {
    delete(grp_inputtype, inputFolder)
    add(grp_inputtype, inputFile)
  } else {
    delete(grp_inputtype, inputFile)
    add(grp_inputtype, inputFolder)
  }
})
grp_input <- ggroup(container = grp_inputtype)

#TODO: allow user to set output destination

#TODO: update this handler function to handle a file or a folder respectively
btnRunOCR <- gbutton("Run OCR", container = win, handler = function(h, ...) {
  
  if(svalue(inputType) == "Single File")
  {
    files <- c(svalue(inputFile))
  }else 
  {
    files <- list.files(path=svalue(inputFolder), pattern = "*.tiff", full.names=TRUE, recursive=FALSE)
  }
  
  sink("/Users/bandg/OneDrive/Documents/flashdrivestuff/Masters/Thesis/tempimages/1/page-3Text.txt")
  lapply(files, function(x) {
    
    color.image <- readImage(x)
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
    #print(text1)
    cat(text1)
  })
  print("done")
  sink()
})
#TODO: Save text to PDF