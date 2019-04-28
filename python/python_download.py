#!/usr/bin/env python3
#-*- coding:utf-8 -*-

import io
import sys
import urllib.request as request

BUFF_SIZE=1024

####O primeiro metodo considera o tamanho do arquivo passado pelo site/servidor acessado
####A partir do tamanho do buffer de dados este baixo faz o download

def download_length(response, output, length): 
    times=length//BUFF_SIZE ####Quantidade de tempos que serao necessarios para se pegar uma parte do pacote do programa
    if length%BUFF_SIZE>0: ####Se o resto for maior que zero significa que existe "um pedaço" do programa que precisa ser baixado
        times=times+1
    for time in range(times):
        output.write(response.read(BUFF_SIZE))
        print("Downloaded %d" %(((time*BUFF_SIZE)/length)*100))

####O segundo metodo realiza download ignorando a resposta do servidor quanto ao tamanho do arquivo

def download(response, output):
    total_downloaded=0
    while True:
        data.response.read(BUFF.SIZE)
        total_downloaded=total_downloaded+len(data)
        if not data: ####Ou seja, caso o arquivo nao exista ou tenha tamanho 0
            break
        output.write(data)
        print("Downloaded {bytes}" .format(bytes=total_downloaded))

def main():
    response=request.urlopen(sys.argv[1])
    out_file=io.FileIO("saida.zip", mode="w")

    content_length=response.getheader("Content-Length")
    if content_length:
        length=int(content_length)
        download_length(response, out_file, length)
    else:
         download(response, out_file)

    response.close()
    out_file.close()
    print("Finished")

if __name__=="__main__":
    main()
