def barra(n):
    i=1
    for i in range(n):
        print(n*"* # ")    
        print()
        
def main():
    n = int(input("Digite um Valor: \n"))
    y = n*1
    print(barra(y))
    
