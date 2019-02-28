# -*- coding: utf-8 -*- 

print"Digite \"(\" ou \")\" seguindo uma ordem"
parenteses=list(str(raw_input()))

print"A sequencia apresenta e: %s" %(parenteses)

while True:
    while len(parenteses)>0:
        parenteses_direita=parenteses.pop(-1)
        parenteses_esquerda=parenteses.pop(0)
        if parenteses_direita==")" and parenteses_esquerda=="(":
            sinal=False
            
        else:
           print"Sequencia apresenta erro! Nao e \"(\" e \")\"."
           print"A sequencia apresentada e: %s e %s" %(parenteses_esquerda, parenteses_direita)
           sinal=True
           break
    
    if(sinal):
        break

    else:
        print"A sequencia e igual a 0 e deu certo! Nao ha mais o que avaliar!"
        break


print"Fim do programa"        
