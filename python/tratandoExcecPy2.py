import zipfile

try:
	banco_zip=zipfile.ZipFile("saidax.zip")
	banco_zip.extractall(path="/home/paulopimenta/Documentos/meus_codigos/ph_codes/python")
	banco_zip.close()
except IOError as ose:
	print(ose)
	print(ose.filename) 				
	print("Algum problema ao ler o arquivo {}" .format(ose.filename))
