#!/usr/bin/python3.8
# -*- coding: utf-8 -*-

import sys
import os
import subprocess
from PySide2 import QtGui, QtQml, QtCore
from matplotlib_backend_qtquick.backend_qtquick import (
    NavigationToolbar2QtQuick)
from matplotlib_backend_qtquick.backend_qtquickagg import (
    FigureCanvasQtQuickAgg)
import matplotlib.pyplot as plt
from qml import arduinoUno
import serial.tools.list_ports
plt.style.use("seaborn-darkgrid")

class UnoDataLogger(QtCore.QObject):
    coordinatesChanged = QtCore.Signal(str)

    def __init__(self,win, parent=None):
        super().__init__(parent)
        self.win = win
        self.figure = None
        self.toolbar = None
        self.arduino = None
        self.refresh()
        self._coordinates = ""
        self.canvas = (win.findChild(QtCore.QObject, "figure"))
        self.startButton = self.win.findChild(QtCore.QObject, "startButton")
        self.btn_connect  = self.win.findChild(QtCore.QObject, "btn_connect")
        self.btn_disconnect = self.win.findChild(QtCore.QObject, "btn_disconnect")
        self.titlegraph = "Chart"
        self.titleaxisx = "Time (in ms)"
        self.titleaxisy = "Voltage ( in Volt)"
        self.titlechart1 = "A0"
        self.titlechart2 = "A1"


    def createcanvas(self, canvas):
        self.figure = canvas.figure
        self.toolbar = NavigationToolbar2QtQuick(canvas=canvas)
        self._coordinates = "0,0"
        self.axes = self.figure.add_subplot()
        self.graphParametre()
        canvas.draw()

    @QtCore.Slot()
    def refresh(self):
        com = []
        for p in serial.tools.list_ports.comports():
            if "0000:0000" not in str(p.usb_info()):
                com.append(p[0])

        self.combobox = self.win.findChild(QtCore.QObject, "comboBox")
        self.combobox.setProperty('model', com)

    @QtCore.Slot(str,str,str,str,str)
    def popupGraph(self,titlegraph,titleaxisx,titleaxisy,titlechart1,titlechart2):
        self.titlegraph = titlegraph
        self.titleaxisx = titleaxisx
        self.titleaxisy = titleaxisy
        self.titlechart1 = titlechart1
        self.titlechart2 = titlechart2
        self.redraw()


    def graphParametre(self):
        self.axes.set_title(self.titlegraph)
        self.axes.set_xlabel(self.titleaxisx)
        self.axes.set_ylabel(self.titleaxisy)
        self.axes.ticklabel_format(style='plain')
        self.axes.autoscale(enable=True, axis='both', tight=None)
        self.tight()

    def getCoordinates(self):
        return self._coordinates

    def setCoordinates(self, coordinates):
        self._coordinates = coordinates
        self.coordinatesChanged.emit(self._coordinates)

    coordinates = QtCore.Property(str, getCoordinates, setCoordinates,
                                  notify=coordinatesChanged)


    # The toolbar commands
    @QtCore.Slot()
    def pan(self, *args):
        """Activate the pan tool."""
        self.toolbar.pan(*args)

    @QtCore.Slot()
    def zoom(self, *args):
        """activate zoom tool."""
        self.toolbar.zoom(*args)


    @QtCore.Slot(str , str)
    def runacq(self, nombreDePoints, tempsDechantillonage):
        self.thread = mythread(self,nombreDePoints, tempsDechantillonage, self.arduino )
        self.thread.update.connect(self.tracer)
        self.thread.finished.connect(self.stopThread)
        self.thread.start()

    @QtCore.Slot()
    def stopThread(self):
        global running
        running = False
        self.figure.canvas.mpl_connect('button_press_event', self.onclick)
        if self.arduino is not None:
            self.startButton.setProperty('enabled',True)
        self.tight()

    @QtCore.Slot()
    def savefig(self):
        dirpath = (os.path.expanduser(r'~/Documents'))
        file = (dirpath + '/image.svg')
        self.figure.savefig(file, format='svg', dpi=1200)


    @QtCore.Slot()
    def effacer(self):

        self.figure.clf()
        self.axes = self.figure.add_subplot()
        self.canvas.draw_idle()
        self.figure.canvas.mpl_connect('motion_notify_event', self.on_motion)


    @QtCore.Slot(result=str)
    def arduinoConnect(self):
        self.arduino=arduinoUno.arduino(self.combobox.property('currentValue'))
        if self.combobox.property('currentValue') is not None:

            try:
                self.arduino.ouvrir()
                etat = "Arduino found : " + str(self.arduino.ports)
                self.btn_disconnect.setProperty('enabled', True)
                self.btn_connect.setProperty('enabled', False)
                self.startButton.setProperty('enabled', True)
                self.arduino.flush()
            except:
                etat = "Arduino not found"
                self.btn_disconnect.setProperty('enabled', False)
                self.btn_connect.setProperty('enabled', True)

        else:
            etat = "Arduino not found"

        return etat


    @QtCore.Slot()
    def arduinoDisconnect(self):
        try:
            self.arduino.fermer()
            self.btn_disconnect.setProperty('enabled', False)
            self.btn_connect.setProperty('enabled', True)
            self.arduino = None
        except:
            None

    @QtCore.Slot()
    def home(self, *args):
        #self.toolbar.home(*args)
        self.graphParametre()
        self.canvas.draw_idle()


    @QtCore.Slot()
    def tight(self):
        """Activate the pan tool."""
        try:
            self.figure.tight_layout()
        except:
            None


    @QtCore.Slot()
    def redraw(self, *args):
        self.figure.clf()
        self.axes = self.figure.add_subplot()
        self.graphParametre()
        try:

            self.axes.plot(tableauTemps, tableauDonnee1,'-o',label=self.titlechart1)
        except:
            None
        try:
            self.axes.plot(tableauTemps,tableauDonnee2, '-o', label=self.titlechart2)
        except:
            None
        self.axes.legend()
        self.canvas.draw_idle()
        self.figure.canvas.mpl_connect('motion_notify_event', self.on_motion)


    def on_motion(self, event):
        """
        Update the coordinates on the display
        """
        if event.inaxes == self.axes:
            self.coordinates = (f"({event.xdata:.2f}, {event.ydata:.2f})")
        try:
            if event.inaxes == self.axes2:
                self.coordinates = (f"({event.xdata:.2f}, {event.ydata:.2f})")
        except:
            None

    def onScroll(self, event):
        cur_xlim = self.axes.get_xlim()
        cur_ylim = self.axes.get_ylim()
        cur_xrange = (cur_xlim[1] - cur_xlim[0]) * .5
        cur_yrange = (cur_ylim[1] - cur_ylim[0]) * .5
        xdata = event.xdata  # get event x location
        ydata = event.ydata  # get event y location

        base_scale = 2.
        if event.button == 'up':
            # deal with zoom in
            scale_factor = 1 / base_scale
        elif event.button == 'down':
            # deal with zoom out
            scale_factor = base_scale

        self.axes.set_xlim([xdata - cur_xrange * scale_factor,
                     xdata + cur_xrange * scale_factor])
        self.axes.set_ylim([ydata - cur_yrange * scale_factor,
                     ydata + cur_yrange * scale_factor])

        self.canvas.draw_idle()


    def onclick(self, event):
        if not event.inaxes: return
        if event.dblclick:
            if event.inaxes == self.axes:

                x, y = event.xdata, event.ydata
                xoffset, yoffset = -20, 20
                self.x = x
                self.y = y
                text_template = 'x: %0.2f\ny: %0.2f'
                self.annotation = self.axes.annotate(text_template,
                xy=(self.x, self.y), xytext=(xoffset, yoffset),
                textcoords='offset points', ha='right', va='bottom',
                bbox=dict(boxstyle='round,pad=0.5', fc='yellow', alpha=0.5),
                arrowprops=dict(arrowstyle='->', color='black', connectionstyle='arc3,rad=0')
                )

                self.annotation.xy = self.x, self.y
                self.annotation.set_text(text_template % (self.x, self.y))
                self.annotation.set_visible(True)
                self.annotation.draggable()

                self.canvas.draw_idle()


    def tracer(self):
        self.figure.clf()
        self.axes = self.figure.add_subplot()
        self.graphParametre()
        self.axes.plot(tableauTemps, tableauDonnee1,'-o',label=self.titlechart1)
        self.axes.legend()
        try:
            self.axes.plot(tableauTemps,tableauDonnee2, '-o', label=self.titlechart2)
            self.axes.legend()
        except:
            None
        self.canvas.draw_idle()
        self.figure.canvas.mpl_connect('motion_notify_event', self.on_motion)
        self.figure.canvas.mpl_connect('scroll_event', self.onScroll)


    @QtCore.Slot()
    def quitter(self):
        self.stopThread()
        try:
            self.arduino.fermer()
        except:
            None
        self.win.close()


    @QtCore.Slot()
    def notepad(self):
        if len(tableauDonnee1)==len(tableauDonnee2):
            self.arduino.enregistrerFichierTxt2(tableauTemps,tableauDonnee1,tableauDonnee2)
        else:
            self.arduino.enregistrerFichierTxt(tableauTemps,tableauDonnee1)
        try:
            dirpath = (os.path.expanduser(r'~/Documents'))
            file = (dirpath + '/Arduino.txt')
            subprocess.call(["xdg-open", file])
        except:
            None


    @QtCore.Slot()
    def opensavefig(self):
        dirpath = (os.path.expanduser(r'~/Documents'))
        file = (dirpath + '/image.svg')
        subprocess.call(["xdg-open", file])



class mythread(QtCore.QThread):
    update = QtCore.Signal()
    def __init__(self, parent,nombreDePoints, tempsDechantillonage, arduino):
        super(mythread, self).__init__(parent)
        self.nombreDePoints = nombreDePoints
        self.tempsDechantillonage = tempsDechantillonage
        self.arduino = arduino

    def run(self):
        try:
            self.arduino.flush()
        except:
            None

        global running
        running = True
        self.arduino.ecrire(self.tempsDechantillonage)

        self.arduino.flush()

        global tableauTemps
        tableauTemps = []
        global tableauDonnee1
        tableauDonnee1 = []
        global tableauDonnee2
        tableauDonnee2 = []
        nombreDePoints = int(self.nombreDePoints)
        debut = 0
        fin = 0
        from datetime import datetime
        chrono = datetime.now()

        for i in range(nombreDePoints):
            if not running:
                break
            try:
                a = self.arduino.lire()
                tableauTemps.append(round(float(a[0])))
                tableauDonnee1.append(float(a[1]))
                try:
                    tableauDonnee2.append(float(a[2]))
                except:
                    None

            except:
                None

            delta = datetime.now()-chrono
            if (int(delta.total_seconds() * 1000))>500:
                self.update.emit()
                chrono = datetime.now()

        self.arduino.enregistrerFichierTxt(tableauTemps,tableauDonnee1)
        self.update.emit()
        self.arduino.ecrire('0')


if __name__ == "__main__":
    os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"
    app=QtGui.QGuiApplication.instance()
    if not app:
        app =  QtGui.QGuiApplication(sys.argv)
    engine = QtQml.QQmlApplicationEngine()
    QtQml.qmlRegisterType(FigureCanvasQtQuickAgg, "Backend", 1, 0, "FigureCanvas")
    context = engine.rootContext()
    try:
        basePath = sys._MEIPASS
    except :
        basePath = os.path.realpath(__file__)
        basePath = basePath.replace('UnoDataLogger.py','')

    engine.load(basePath+"/qml/main.qml")
    win = engine.rootObjects()[0]
    unoDataLogger = UnoDataLogger(win)
    context.setContextProperty("unoDataLogger", unoDataLogger)
    win.show()
    unoDataLogger.createcanvas(win.findChild(QtCore.QObject, "figure"))
    app.exec_()

