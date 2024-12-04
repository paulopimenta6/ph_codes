from pylab import plot, arange, xlabel, ylabel, title, grid, show

x = arange(0, 4, 0.5)
y = 3*x

plot(x, y, '^')
xlabel('Variavel independente x')
ylabel('Funcao y = 3x')
title('Titulo do grafico')
grid(True)
show()