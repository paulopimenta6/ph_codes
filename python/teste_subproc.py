import subprocess

################################################

tut=subprocess.call('ls', shell = True)
print(tut)

#################################################

output = subprocess.check_output(['ls', '-1'])
print 'Have %d bytes in output' % len(output)
print output

#################################################
