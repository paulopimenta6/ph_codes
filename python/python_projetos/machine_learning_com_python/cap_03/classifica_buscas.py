### from dados import carregar_buscas
### X,Y = carregar_buscas()
### 
### print(X)

#from pylab import plot, show
import pandas as pd

df = pd.read_csv('buscas.csv')
print(df)
#plot(df.home)