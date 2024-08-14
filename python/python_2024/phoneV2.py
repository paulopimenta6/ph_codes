from tkinter import Tk, Label, RAISED, Button

def button_clicked(value):
    display_label.config(text = "Button " + value + " clicked")

root = Tk()

buttons = [['1', '2', '3'],
          ['4', '6', '7'],
          ['5', '6', '8'],
          ['*', '0', '#']]

display_label = Label(root, text="Clique em um botão", pady=20)
display_label.grid(columnspan=3)

for r in range(4):
    for c in range(3):
        button = Button(root,
                       relief = RAISED,
                       padx = 50,
                       text = buttons[r][c],
                       command = lambda value = buttons[r][c]: button_clicked(value))
        button.grid(row = r + 1, column = c)        

root.mainloop()        

