import os
from pdf2image import convert_from_path
import pytesseract
from googletrans import Translator
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from PIL import Image

# ========= CONFIG =========
pdf_in = "manual_star_fox_super_famicom.pdf"  # arquivo original
pdf_out = "manual_star_fox_super_famicom_pt.pdf"  # saída traduzida
tesseract_cmd = r"/usr/bin/tesseract"  # caminho do tesseract OCR (ajuste se necessário)
# ==========================

# Definir caminho do Tesseract
pytesseract.pytesseract.tesseract_cmd = tesseract_cmd

# Converter PDF em imagens (uma por página)
pages = convert_from_path(pdf_in, dpi=300)

# Tradutor
translator = Translator()

# Criar PDF final
c = canvas.Canvas(pdf_out, pagesize=A4)
width, height = A4

for i, page in enumerate(pages):
    # OCR da página
    text = pytesseract.image_to_string(page, lang="eng+jpn")  # japonês + inglês
    
    # Traduzir para português
    translated = translator.translate(text, src="auto", dest="pt").text
    
    # Salvar imagem temporária da página
    img_path = f"page_{i}.jpg"
    page.save(img_path, "JPEG")
    
    # Colocar imagem de fundo no PDF
    c.drawImage(img_path, 0, 0, width, height)
    
    # Escrever texto traduzido sobre a página
    c.setFont("Helvetica", 10)
    y = height - 40
    for line in translated.split("\n"):
        c.drawString(40, y, line.strip())
        y -= 12
    
    c.showPage()
    os.remove(img_path)

c.save()
print(f"PDF traduzido gerado: {pdf_out}")

