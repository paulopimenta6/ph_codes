def raiz_quadrada(x):
    b=x
    diferenca=1
    while diferenca > 0.0000000001:
        p = (0.5)*(b + (x/b))
        diferenca=(p-b)         
        b=p
    return p

def distancia_pontos(x_1, y_1, x_2, y_2):
    termo_x = (x_2 - x_1)**2 
    termo_y = (y_2 - y_1)**2
    valor = termo_x + termo_y
    raio = raiz_quadrada(valor)
    return raio

x_1 = 2.0 
y_1 = 3.0
x_2 = 4.0
y_2 = 5.0

print(distancia_pontos(x_1, y_1, x_2, y_2))
