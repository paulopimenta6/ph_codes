from pylab import plot, arange, show

x = arange(0, 4, 0.5)
y = 2*x

y1 = 6*x
y2 = x**2

plot(x, y, 'x:g')
plot(x, y1, '|--r') 
plot(x, y2, 'h-k')
show()