from pylab import plot, arange, legend, show

x = arange(0, 4, 0.5)
y = 2*x

y1 = 6*x
y2 = x**2

plot(x, y, 'o--g', label = 'Linha 1')
plot(x, y1, '+--r', label = 'Linha 2') 
plot(x, y2, 's-b', label = 'Linha 3')
legend(loc = 2)
show()