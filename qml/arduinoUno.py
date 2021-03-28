import serial
import time
import serial.tools.list_ports
import os
import matplotlib.pyplot as plt
import pyperclip

class arduino():
    def __init__(self, ports):
        self.ports = ports


    def ouvrir(self):
        arduino = serial.Serial(self.ports, 115200)
        self.arduino = arduino
        time.sleep(2)
        self.arduino.setDTR(True)

    def ports(self):
        for p in serial.tools.list_ports.comports():

            if 'Arduino' or 'CH340' or 'Bossa' in p[1]:
                ports = p[0]
        x = self.ports
        return x


    def ecrire(self,tpsech):
        try:
            x = str(tpsech)
            self.arduino.write(x.encode())
        except:
            None

    def read2(self):
        try:
            donneesArduino = self.arduino.readline()
            donneesArduino = donneesArduino.decode("utf-8")
            donneesArduino = donneesArduino.replace('\r\n', '')

        except:
            print('')

        return  donneesArduino


    def lire(self):
        try:
            a= []
            donneesArduino = self.arduino.readline()
            donneesArduino = donneesArduino.decode("utf-8")
            donneesArduino = donneesArduino.replace('\r\n', '')
            a= donneesArduino.split(';')


        except:
            self.flush()
            a=[0,0]
        return a

    def enregistrerFichierTxt(self,t,x):

        try:
            dirpath = (os.path.expanduser(r'~/Documents'))

            with open(dirpath + '/Arduino.txt', 'w') as filehandle:
                filehandle.write('time' + '\t' +'value' + '\n')

                for i in range(len(t)):
                    filehandle.write(str(t[i])+'\t' + str(x[i])+'\n')



        except:
            None

    def enregistrerFichierTxt2(self,t,x,y):

        try:
            dirpath = (os.path.expanduser(r'~/Documents'))

            with open(dirpath + '/Arduino.txt', 'w') as filehandle:
                filehandle.write('time' + '\t' +'value' + '\t' + 'value2' +  '\n')

                for i in range(len(t)):
                    filehandle.write(str(t[i])+'\t' + str(x[i])+ '\t' + str(y[i])+'\n')

        except:
            None


    def flush(self):
        self.arduino.flushInput()
        self.arduino.flush()
        self.arduino.flushOutput()

    def fermer(self):
        self.arduino.close()
