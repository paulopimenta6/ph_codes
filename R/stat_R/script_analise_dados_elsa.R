dir_dados="Lucia_Andrade_10_22_CSV.csv"

importaDados=read.csv(dir_dados, sep=';', header = TRUE)

#print(importaDados$IDELSA)
#print(importaDados$IDADEA)
#print(importaDados$IDADEB)
#print(importaDados$IDADEC)

#Analise descritiva das variaveis
idadeNaOnda1<-table(importaDados$IDADEA)
idadeNaOnda2<-table(importaDados$IDADEB)
idadeNaOnda3<-table(importaDados$IDADEC)

idadeNaOnda1DF<-data.frame(importaDados$IDADEA)
idadeNaOnda2DF<-data.frame(importaDados$IDADEB)
idadeNaOnda3DF<-data.frame(importaDados$IDADEC)

pressaoArterialSistolicaMediaOnda1DF<-data.frame(importaDados$A_PSIS)
pressaoArterialSistolicaMediaOnda2DF<-data.frame(importaDados$B_PSIS)
pressaoArterialSistolicaMediaOnda3FG<-data.frame(importaDados$C_PSIS)

pressaoArterialSistolicaMediaOnda1<-table(importaDados$A_PSIS)
pressaoArterialSistolicaMediaOnda2<-table(importaDados$B_PSIS)
pressaoArterialSistolicaMediaOnda3<-table(importaDados$C_PSIS)

#barplot(idadeNaOnda1, main = "Idades na 1a onda", ylab = "Total de pessoas", xlab = "idades")
#barplot(idadeNaOnda2, main = "Idades na 2a onda", ylab = "Total de pessoas", xlab = "idades")
#barplot(idadeNaOnda3, main = "Idades na 3a onda", ylab = "Total de pessoas", xlab = "idades")