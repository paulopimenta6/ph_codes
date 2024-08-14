from tkinter import Tk, Button
from time import strftime, localtime
from tkinter.messagebox import showinfo

def cliked():
    time = strftime('Dia: %d %b %Y \nHora: %H:%M:%S %p\n',
                    localtime())
    
    showinfo(message = time)

root = Tk()
root.geometry("400x300") 

button = Button(root,
                text = 'Click here',
                command = cliked,
                width = 20,
                height = 3)

button.pack()
root.mainloop()
