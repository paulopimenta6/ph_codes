qtd_pokebolas = 3
vxb = 1
i = 1

print"Digite o valor da gravidade:"
g = float(raw_input())
while g < 0:
	print"O valor da gravidade deve ser > 0. Digite novamente:"
	g = float(raw_input())

print"Digite a coordenada \"xp\" do pokemon:"
xp = int(raw_input())
while xp < 0:
	print"O valor da coordenada em \"x\" deve ser > 0. Digite novamente:"
	xp = int(raw_input())

print"Digite a coordenada \"yp\" do pokemon:"
yp = int(raw_input())
while yp < 0:
	print"O valor da coordenada em \"y\" deve ser > 0. Digite novamente:"
	yp = int(raw_input())

while i <= 3:
	
	print"Digite a coordenada \"x\" do treinador pokemon:"
	xb = int(raw_input())
	while xb < 0:
		print"O valor da coordenada \"x\" do treinador deve ser > 0. Digite novamente:"
		xb = int(raw_input())

	print"Digite a coordenada \"y\" do treinador pokemon:"
	yb = int(raw_input())
	while yb < 0:
		print"O valor da coordenada \"y\" do treinador deve ser > 0. Digite novamente:"
		yb = int(raw_input())

	print"Digite a componente \"y\" da velocidade da pokebola:"
	vyb = int(raw_input())
	while vyb < 0:
		print"O valor da coordenada em \"y\" da pokebola deve ser > 0. Digite novamente:"
		vyb = int(raw_input())

	j=0
        while (xb != xp and yb != yp) or (yb > 0): 
		xb = xb + 1*j 
		vy = vyb - g*j
		yb = yb + vy*(j) - (g/2)*(j*j)
		print"Pokebola em x: %d" %(xb)  
		print"Pokebola em y: %d" %(yb)
		print"Velocidade da pokebola em y: %d" %(vy)
		print"Tempo: %d" %(j)
		j = j + 1
	
	print"A pokebola nao acertou o pokemon! Tente mais uma vez!" 
	i = i + 1









