from tkinter import Tk, Label, RAISED

root = Tk()

labels = [['1', '2', '3'],
          ['4', '6', '7'],
          ['5', '6', '7'],
          ['*', '0', '#']]

for r in range(4):
    for c in range(3):
        label = Label(root,
                       relief = RAISED,
                       padx = 50,
                       text = labels[r][c])
        label.grid(row = r, column = c)        

root.mainloop()        

