#!/usr/bin/python3

import socket
import time
import datetime
import numpy as np
import os
import cgitb
import cv2 as cv
from http.server import BaseHTTPRequestHandler, HTTPServer

#---SETA VALORES FORNECIDOS E DADOS DO SERVIDOR PYTHON---#

np.set_printoptions(threshold=np.inf)
hline = 50816
hcolu = 3600
gline = 50816
gcolu = 1
hostName = "localhost"
hostPort = 9000
iteration = 15
img_h = 60
img_w = 60

#---(PRE-)SERVER 1 OPERATION---#

# H = np.loadtxt(open("H-1.txt", "rb"), delimiter=",")
# np.save("h_mod", H)

# ---FUNCTIONS TO PERFORM MA/ARR CALCULATIONS ---# USED FLEET CLASS


class fleet():
    # convert txt to mat/arr
    def constitution(file):
        print("Leitura de Arquivo G")
        interm = np.loadtxt(file, delimiter=',')
        print("Variavel G Carregada")
        return interm

    # application of tanspose

    def miranda(mat1):
        return np.transpose(mat1)

    # perform calculations
    def excelsior(file, name_us, first):
        print("Inicializando leitura dos arquivos")
        g = fleet.constitution(file)
        # carga modificada//pre-load npy
        print("Leitura de Arquivo H")
        h = np.load("h_mod.npy")
        # carga original//load converter with txt->npy
        #h = fleet.constitution(file2)
        print("leitura dos arquivos feita")
        ht = fleet.miranda(h)
        f = np.zeros((img_w*img_h,), dtype=np.float64)
        r0 = g - np.matmul(h, f)
        p0 = np.matmul(ht, r0)
        n = 0
        for n in range(iteration):
            alfa = np.dot(fleet.miranda(r0), r0) / \
                np.dot(fleet.miranda(p0), p0)
            f = f + np.dot(alfa, p0)
            rn = r0 - np.matmul(np.dot(alfa, h), p0)
            beta = np.dot(fleet.miranda(rn), rn) / \
                np.dot(fleet.miranda(r0), r0)
            pn = np.matmul(ht, rn) + np.dot(beta, p0)
            p0 = pn
            r0 = rn
            n = n +1
            print(n)
        fleet.oberth(f, name_us, first)

    # convert txt in bmp/png
    def oberth(mat2, name_us, first):
        print("gravacao de imagem inicializada")
        filename = str(name_us)+str(first.month)+str(first.day) + \
            str(first.hour)+str(first.minute)+".png"
        mat2.resize(img_w, img_h)
        cv.normalize(mat2, mat2, alpha=0, beta=255,
                     norm_type=cv.NORM_MINMAX, dtype=cv.CV_64F)
        cv.imwrite(filename, mat2)
        print("gravacao feita")


#---SERVER 2 OPERATION---#

class MyServer(BaseHTTPRequestHandler):

    #	GET is for clients geting the predi
    def do_GET(self):
        self.send_response(200)
        self.wfile.write(bytes("<p>You accessed path: %s</p>" %
                               self.path, "utf-8"))

    #	POST is for submitting data.
    def do_POST(self):
        tipo = self.headers['Content-Type']
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        tipo2 = str(post_data).split("%")
        print("<><><><>")
        print(tipo2[1])
        print("<><><><>")
        print(tipo2[2])
        print("<><><><>")
        if (tipo2[1] == "CONSULTA"):
            print(">consulta")
            try:
                print (tipo2[2] + ".png")
                file = open(tipo2[2] + ".png", "rb")
                print (tipo2[2] + ".png")
                self.send_response(200)
                self.send_header("Content-type", "image/png")
                self.send_header("Content-length", os.path.getsize(tipo2[2] + ".png"))
                self.end_headers()
                print("Teste")
                self.wfile.write(file.read())
                file.close()
            except:
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                now = datetime.datetime.now()
                string_start = "Arquivo não encontrado as:" + \
                    str(now.hour)+":"+str(now.minute)+":" + \
                    str(now.second)+":"+str(now.microsecond)
                self.wfile.write("<p>Arquivo Não Encontrado.</p>".encode())
        elif (tipo2[1] == "IMAGEM"):
            conteudo = tipo2[3].replace("\\r\\n", "\n")
            print(conteudo)
            nome_arquivo = tipo2[2] + ".txt"
            ge = open(nome_arquivo, "w+")
            ge.write(str(conteudo))
            ge.close()
            # chamada de função
            now = datetime.datetime.now()
            string_start = "Compressão iniciada na hora:" + \
                str(now.hour)+":"+str(now.minute)+":" + \
                str(now.second)+":"+str(now.microsecond)
            print(string_start)
            fleet.excelsior(nome_arquivo, tipo2[2], now)
            end = datetime.datetime.now()
            string_end = "Compressão finalizada na hora:" + \
                str(end.hour)+":"+str(end.minute)+":" + \
                str(end.second)+":"+str(now.microsecond)
            print(string_end)
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write("<p>Arquivo Recebido.</p><br>".encode())
            self.wfile.write((string_start + "<br>").encode())
            self.wfile.write((string_end + "<br>").encode())


myServer = HTTPServer((hostName, hostPort), MyServer)
print(time.asctime(), "Server Starts - %s:%s" % (hostName, hostPort))

try:
    myServer.serve_forever()
except KeyboardInterrupt:
    pass

myServer.server_close()
print(time.asctime(), "Server Stops - %s:%s" % (hostName, hostPort))
