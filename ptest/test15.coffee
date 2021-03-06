PDFDocument = require 'pdfkit'
fs = require 'fs'

make = (doc) -> 

  # Register a font name for use later
  doc.registerFont('the-font', 'assets/fira.ttf')

  # Set the font, draw some text
  doc.font('the-font')
     .fontSize(25)
     .text('HTAVATH', 100, 100, {width: false})
                 
  doc.end()


doc = new PDFDocument({compress: no})
doc.pipe(fs.createWriteStream('test15.pdf'))
make doc

doc = new PDFDocument({compress: yes})
doc.pipe(fs.createWriteStream('test15c.pdf'))
make doc

