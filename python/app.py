import re
##############################################
# python/app.py                             ##  
# no meu notebook esta em ~/Documents/python##
# no orange pi esta em ~/python_alura       ## 
##############################################
def cadastrar(nomes):
    print 'Digite: o nome:'
    nome = raw_input()
    nomes.append(nome)

def remove(nomes):
    print "Qual nome deseja remover?"
    nome=raw_input()
    nomes.remove(nome)

def altera(nomes):
    print 'Qual nome vc gostaria de alterar?'
    nome_a_alterar=raw_input()
    verificacao=(nome_a_alterar in nomes) 
    if(verificacao):
        idx_nome=nomes.index(nome_a_alterar)
        print "Digite o nome novo: "
        nome_novo=raw_input()
        nomes[idx_nome]=nome_novo
    else:
        print "Nome nao consta na lista."    

def listar(nomes):
    print 'Listando nomes'
    for nome in nomes:
        print nome

def procura(nomes):
    print 'Digite nome a procurar:'
    nome_a_procurar=raw_input()
    if(nome_a_procurar in nomes):
        print "O nome existe e esta na lista de usuarios cadastrados"
    else:
        print "O nome nao consta na lista de usuarios cadastrados"      

def procurar_regex(nomes):
    print "Digite um nome ou algum identificador: "
    regex=raw_input()
    todos_nomes=" ".join(nomes)
    resultado=re.findall(regex, todos_nomes)
    print(resultado)

def menu():
    nomes = [] #nao podemos esquecer de inicializar a lista
    escolha = ''
    while(escolha != '0'):    
        print 'Digite: 1 para cadastrar, 2 para listar os nomes, 3 para remover, 4 para alterar, 5 para procurar um usuario, 6 para procurar um usuario e 0 para terminar'
        escolha = raw_input()
        if(escolha=='1'):
            cadastrar(nomes)
        if(escolha=='2'):
            listar(nomes)  
        if(escolha=='3'):
            remove(nomes)  
        if(escolha=='4'):
            altera(nomes)
        if(escolha=='5'):
            procura(nomes)  
        if(escolha=='6'):
            procurar_regex(nomes)

menu()
