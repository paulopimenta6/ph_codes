import matplotlib
matplotlib.use('TkAgg')   # Para sistemas com Tkinter
import matplotlib.pyplot as plt
import cv2
import numpy as np

single_image = cv2.imread("/home/paulo/Imagens/aluno_1.png")
print(single_image)

#plt.imshow(single_image)
#plt.show()

print(single_image.shape)
single_image_resize = cv2.resize(single_image, (200, 350))

#plt.imshow(single_image_resize)
#plt.show()

single_image_resize_gray = cv2.cvtColor(single_image_resize, cv2.COLOR_BGR2GRAY)
#print(single_image_resize_gray.shape)
#plt.imshow(single_image_resize_gray)
#plt.show()

flipped_image = np.fliplr(single_image_resize_gray)
print(flipped_image.shape)
print(type(flipped_image))
plt.imshow(flipped_image)
plt.show()