# -*- coding: utf-8 -*-
#Author: Paulo Pimenta
#IDE: Spyder (From Anaconda)
#Language Programming: Python

def array123(nums):
  count = 0
  
  arr = [1, 2, 3]  
  arrFinal = []
  
  #In first loop get the index of arr array
  #and evaluate if arr values are in nums (the array passed through the function parameter)
  #in final append in a final array 
  #remembering in this case numbers don't repeat, so, if we have 1,1,1 we just have 1 in arrFinal
  
  for idxArr in range(len(arr)):
      if arr[idxArr] in nums:
          arrFinal.append(arr[idxArr])        
            
  if len(arrFinal) == 3:
      return True
  else:
      return False               
#-------------------------------------------------------------------------------
array1 = ([1, 1, 2, 3, 1]) 
array2 = ([1, 1, 2, 4, 1]) 
array3 = ([1, 1, 2, 1, 2, 3])

print(array123(array1))
print(array123(array2))
print(array123(array3))


    