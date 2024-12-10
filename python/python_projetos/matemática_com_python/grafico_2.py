from pylab import plot, arange, show

x = arange(0, 4, 0.5)
y = 2*x

y1 = 6*x
y2 = x**2

plot(x, y, x, y1, x, y2)
show()