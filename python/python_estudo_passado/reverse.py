#def reverse_number(num):
#  # Reverse the number
#  reverse = int(str(num)[::-1])
#  # Return the number
#  return reverse
#
### Example usage:
##print(reverse_number(1223)) # Output: 3221
##print(reverse_number(987654321)) # Output: 123456789
#
#a = reverse_number(123)
#print(a)



def reverse_number(num):
    reverse = int(str(num)[::-1]) ### Here is necessary to do a cast because the notation [::-1] of slicing is used in string. After the reverse... 
                                  ###  ...the num become again a int to be returned                                              
    return reverse

final_num_reversed = reverse_number(123)
print(final_num_reversed)