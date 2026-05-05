#-*- coding:utf-8 -*-

#Constantes
GRAVIDADE = 9.81
EPSILON = 0.01
DELTA_T = 0.01
PI = 3.14159265358979323846

#calculo do fatorial
def fatorial(numero): 
    n=0
    fatoriaal=1
    if numero == 0:    
        return 1
    if numero == 1:
        return 1
    else:
	while n<numero:
	    fatoriaal = fatoriaal*(numero-n)
	    n = n + 1
	return fatoriaal     

#calculo do sin
def seno(numero):
    termo=1
    i=0
    soma=0
    n=1
    while termo > 0.0000000001: 
        fat=float(fatorial(n))
        print("Fatorial: %f" %fat)
        numerador=(numero**n)
        print("Numerador: %f" %numerador)
        termo=(numerador/fat)
        print("Termo: %f" %termo)
        soma = soma + ((-1)**i)*termo 
        print("Seno: %f" %soma)
        i=i+1
        n=n+2
    return soma       

#Calculo da funcao cos:
def cosseno(numero):
    termo=1
    i=0
    soma=0
    n=0
    while termo > 0.0000000001: 
        fat=float(fatorial(n))
        print("Fatorial: %f" %fat)
        numerador=(numero**n)
        print("Numerador: %f" %numerador)
        termo=(numerador/fat)
        print("Termo: %f" %termo)
        soma = soma + ((-1)**i)*termo 
        print("Seno: %f" %soma)
        i=i+1
        n=n+2
    return soma

def raiz_quadrada(x):
    b=x
    diferenca=1
    while abs(diferenca) > 0.0000000001:
        p = (0.5)*(b + (x/b))
        diferenca=(p-b)         
        b=p
    print abs(p)

def atualiza_posicao(x,y,vx,vy):
    xb = xb + 1*DELTA_T 
    yb = yb + vy*(DELTA_T) - (GRAVIDADE/2)*(DELTA_T**2)
    return xb, yb

def atualiza_velocidade(vx,vy):
    vy = vy - GRAVIDADE*DELTA_T
    vx = vx   
    return vx, vy 
   
def distancia_pontos (x_1, y_1, x_2, y_2):
    termo_x = (x_2**2 - x_1**2) 
    termo_y = (y_2**2 - y_1**2)
    distancia_x = raiz_quadrada(termo_x)
    distancia_y = raiz_quadrada(termo_y)    
    valor = (distancia_x**2 + distancia_y**2)
    raio = raiz_quadrada(valor)
    return raio

def ha_colisao(x_pokebola, y_pokebola, x_pokemon, y_pokemon, r):
    if distancia_pontos(x_pokebola, x_pokemon, y_pokebola, y_pokemon) =< r:
        return True
    else:
        return False    
      
def simula_lancamento (x_pokebola, y_pokebola, v_lancamento, angulo_lancamento, x_pokemon, y_pokemon, r):    
    vx = v_lancamento*cosseno(angulo_lancamento)
    vy = v_lancamento*seno(angulo_lancamento)
    x_pokebola, y_pokebola = atualiza_posicao(x_pokebola, y_pokebola, vx, vy)
    
    while ha_colisao(x_pokebola, y_pokebola, x_pokemon, y_pokemon, r) == False:
        vx, vy = atualiza_velocidade(vx,vy)
        x_pokebola, y_pokebola = atualiza_posicao(x_pokebola, y_pokebola, vx, vy)
        if y_pokebola < EPSILON = 0.01:
            print"A bola caiu no chao e nao atingiu o pokemon"
            break #Significa que não adianta mais laco, pois a bola atingiu o solo!    
    print"Atingiu o Pokemon!" 


####Captura de Pokemons

def inicio():
    print"Digite a coordenada \"xp\" do pokemon:"
    xp = int(raw_input())
    while xp < 0:
        print"O valor da coordenada em \"x\" deve ser > 0. Digite novamente:"
        xp = int(raw_input())

    print"Digite a coordenada \"yp\" do pokemon:"
    yp = int(raw_input())
    while yp < 0:
        print"O valor da coordenada em \"yp\" deve ser > 0. Digite novamente:"
        yp = int(raw_input())

    print"Digite o raio do \"rp\" do pokemon:"
    rp = int(raw_input())
    while rp < 0:
        print"O valor da coordenada em \"rp\" deve ser > 0. Digite novamente:"
        rp = int(raw_input())


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

        print"Digite a componente \"v\" da velocidade da pokebola:"
        v = int(raw_input())
        while v < 0:
            print"O valor de \"v\" deve ser > 0. Digite novamente:"
            v = int(raw_input())

        print"Digite o angulo de lancamento, em graus, da pokebola:"
        ang = float(raw_input())
        while ang < 0:
            print"O valor do angulo deve ser > 0. Digite novamente:"
            ang = int(raw_input())

        ang=ang*(PI/180)

        simula_lancamento (xb, yb, v, ang, xp, yp, rp)
    
    i = i + 1

inicio()


