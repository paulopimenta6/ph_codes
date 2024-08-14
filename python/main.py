# -*- coding: utf-8 -*-
"""
Created on Mon Aug 12 16:14:01 2024

@author: paulo.pimenta
"""

import io
import sys
import urllib.request as request

BUFF_SIZE = 1024

def download_length(response, output, length):
    times = length//BUFF_SIZE
    if length % BUFF_SIZE > 0:
        times += 1
    for time in range(times):
        output.write(response.read(BUFF_SIZE))
        print("Donwload %d" %((time*BUFF_SIZE)/length)*100)
        
def download(response, output):
    total_downloaded = 0
    while True:
        data = response.read(BUFF_SIZE)
        total_downloaded += len(data)
        if not data:
            break
        output.write(data)
        print("download {bytes}".format(bytes=total_downloaded))
        
def main():
    response = request.urlopen(sys.argv[1])
    out_file = io.FileIO("out.zip", mode = "w")
    content_length = response.gatheader('Content-Length')
    if content_length:
        length = int(content_length)
        download_length(response, out_file, length)
    else:
        download(response, out_file)
        
    response.close()
    out_file.close()
    print("Finished")

if __name__ == "__main__":
    main()       
        