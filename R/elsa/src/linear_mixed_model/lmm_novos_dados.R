################################################################################
### Uso dos novos dados para o modelo linear de efeito misto ###################
################################################################################
#---------------------------------------------
#A_SOMADIAS: Soma dos dias de atividade física
#A_MINMODERADO:Tempo de atividade física moderada por semana (minutos)
#A_MINFRACO: Tempo de caminhada por semana (minutos)
#A_MINFORTE: Atividade física forte por semana (minutos)
#A_MET:Soma ponderada do tempo de atividade física por semana (minutos)
#A_CONSDIAFASTFOOD:Consumo diário de fast food
#A_CONSDIAVERDURAS: Consumo diário de verduras e legumes
#A_CONSDIAFRUTAS:Consumo diário de frutas
#---------------------------------------------
#Terceira onda da taxa de filtração glomerular
#A_K_TOT -> exceção de potássio urinário
#A_CONSDIAFRUTAS: Consumo diário de frutas
################################################################################
# Carregar o pacote
library(readxl)

# Ler o arquivo
dados_elsa_novos1 <- read_excel("./dados_elsa/novos_dados_elsa/dados_novos_elsa_parte1.xlsx")
dados_elsa_novos2 <- read_excel("./dados_elsa/novos_dados_elsa/dados_novos_elsa_parte2.xlsx")
# Visualizar os dados
head(dados_elsa_novos1)
head(dados_elsa_novos2)