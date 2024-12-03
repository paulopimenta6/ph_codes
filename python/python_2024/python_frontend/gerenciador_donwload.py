import io
import sys
import requests
import urllib.request as request
from urllib.parse import urlparse, urlunparse
import tkinter as tk
from tkinter import ttk
from tkinter import messagebox
import os

BUFF_SIZE = 1024

def clean_url(url):
    parsed = urlparse(url)
    return urlunparse(parsed._replace(fragment=""))

def get_filename(response,url):
    """obter o nome do arquivo do cabecalho ou da url"""
    content_disposition = response.getheader('Content-Disposition')
    if content_disposition:
        # Extrair o nome do arquivo do cabecalho
        filename = content_disposition.split("filename=")[-1].strip('"')
    else:
        # Obter o nome do arquivo da url
        path = urlparse(url).path
        filename = os.path.basename(path)

    # Usar o nome padrao se nao houver nome valido
    return filename or "downloaded_file"    


def download_length(response, output, length, progress_bar):
    """Baixar com o tamanho conhecido."""
    times = length // BUFF_SIZE
    if length % BUFF_SIZE > 0:
        times += 1
    
    for time in range(times):
        output.write(response.read(BUFF_SIZE))
        progress_bar["value"] = (time * BUFF_SIZE) / length * 100
        progress_bar.update()
        #print("Download %d%%" % ((time * BUFF_SIZE) / length * 100))

def download(response, output, progress_bar):
    total_downloaded = 0
    while True:
        data = response.read(BUFF_SIZE)
        total_downloaded += len(data)
        if not data:
            break
        output.write(data)
        progress_bar["value"] = total_downloaded
        progress_bar.update()
        #print("Downloaded {bytes} bytes".format(bytes=total_downloaded))

def start_download(url, progress_bar):
    url = clean_url(url)
    try:
        response = request.urlopen(url)
        filename = get_filename(response, url)
        with open(filename, mode="wb") as out_file:
            content_length = response.getheader('Contente-Length')
            if content_length:
                length = int(content_length)
                progress_bar["maximum"] = length
                download_length(response, out_file, length, progress_bar)
            else:
                download(response, out_file, progress_bar)

        response.close()
        messagebox.showinfo("Finished", f"Download Complete! File saved as {filename}")
    except Exception as e:
        messagebox.showerror("Error", str(e)) 

def main():
    root = tk.Tk()
    root.title("File Downloader")
    
    tk.Label(root, text="Enter the URL to download:").pack(pady=5)
    
    url_entry = tk.Entry(root, width=50)
    url_entry.pack(pady=5)
    
    progress_bar = ttk.Progressbar(root, length=400, mode='determinate')
    progress_bar.pack(pady=10)
    
    download_button = tk.Button(root, text="Download", command=lambda: start_download(url_entry.get(), progress_bar))
    download_button.pack(pady=10)
    
    root.mainloop()

if __name__ == "__main__":
    main()
