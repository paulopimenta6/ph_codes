from subprocess import Popen, PIPE
class Cmd(object):
   def __init__(self, cmd):
       self.cmd = cmd
   def __call__(self, *args):
       command = '%s %s' %(self.cmd, ' '.join(args))
       result = Popen(command, stdout=PIPE, stderr=PIPE, shell=True)
       return result.communicate()
class Sh(object):
    """Ao ser instanciada, executa um metodo dinamico
    cujo nome serah executado como um comando. Os argumentos
    passados para o metodo serao passados ao comando.

    Retorna uma tupla contendo resultado do comando e saida de erro

    Exemplo:
    shell = Sh()
    shell.ls("/")

    Ver http://www.python.org.br/wiki/PythonNoLugarDeShellScript
    """
    def __getattr__(self, attribute):
        return Cmd(attribute)
