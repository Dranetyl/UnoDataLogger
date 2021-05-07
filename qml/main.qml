import QtQuick 2.7
import QtQuick.Controls 2.7
import QtQuick.Window 2.7
import QtQuick.Layouts 1.10
import QtQuick.Controls.Material 2.0


ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1000
    height: 600
    minimumWidth: 1000
    minimumHeight: 600
    title: qsTr("UnoDataLogger")
    Material.theme: Material.Light
    Material.accent: Material.Cyan


    onWidthChanged: {
        unoDataLogger.tight()
    }

    onHeightChanged: {
        unoDataLogger.tight()
    }
    FontLoader {
        id: roboto
        source: "Roboto-Regular.ttf"
    }
    font.family: roboto.name


    menuBar:
        MenuBar {
        id : menubar
        Material.theme: Material.Dark
        Material.background : "#646464"
        /*
       MenuBarItem
              {
             id: menuBarItem
             contentItem:
                      Image{
                        //anchors.fill:parent
                        //height: menubar.height
                        source: "home.png"
                        MouseArea{
                            anchors.fill:parent
                            onClicked: drawer.open()
                        }

                  }

              }
        */
        Menu {
            width: {
                var result = 0;
                var padding = 0;
                for (var i = 0; i < count; ++i) {
                    var item = itemAt(i);
                    result = Math.max(item.contentItem.implicitWidth, result);
                    padding = Math.max(item.padding, padding);
                }
                return result + padding * 2;
            }
            title: qsTr("Menu")

            MenuItem {
                text: qsTr("  Quit       ")
                onTriggered: unoDataLogger.quitter()
            }
        }
        Menu {
            width: {
                var result = 0;
                var padding = 0;
                for (var i = 0; i < count; ++i) {
                    var item = itemAt(i);
                    result = Math.max(item.contentItem.implicitWidth, result);
                    padding = Math.max(item.padding, padding);
                }
                return result + padding * 2;
            }

            title: qsTr("Option")
            id : menuOption

            MenuItem {
                text: qsTr("Save Text Result in \Documents")
                onTriggered: unoDataLogger.notepad()

            }
            MenuItem {
                text: qsTr("Save figure in \Documents")
                onTriggered: unoDataLogger.savefig()
            }
        }

        Menu {

            title: qsTr("Chart option")
            id : menuOption2

            MenuItem {
                text: qsTr("Title")
                onTriggered: popup2.open()
            }

            MenuItem {
                text: qsTr("Clean chart")
                onTriggered: unoDataLogger.effacer()
            }

            MenuItem {
                text: qsTr("Redraw")
                onTriggered: unoDataLogger.redraw()
            }

        }
        Menu {
            title: qsTr("Help")
            MenuItem {
                text: qsTr("About")
                onTriggered: popup.open()
            }
        }
    }

    Item {
        id: frame
        anchors.fill: parent
        GroupBox {
            id: groupboxgraph
            width: 675
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 324
            anchors.bottomMargin: 0
            anchors.topMargin: 8
            background: Rectangle {
                border.color: "transparent"
                radius: 2
            }

            Frame {
                id: item4
                anchors.fill: parent
                anchors.leftMargin: -18
                anchors.topMargin: -17
                anchors.rightMargin: -7
                anchors.bottomMargin: 51
                font.family: "Courier"
                font.capitalization: Font.AllLowercase
                background: Rectangle {
                    border.color: "transparent"
                    radius: 2
                }
                Loader {
                    source: "chart.qml"
                    anchors.leftMargin: -12
                    anchors.rightMargin: -12
                    anchors.bottomMargin: -12
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: -12
                    anchors.top: parent.top
                }

            }
            RowLayout {
                id:barrematplotlib
                anchors.bottom: parent.bottom
                spacing: 8
                anchors.bottomMargin: 0
                Rectangle {
                    color: "#ffffff"
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                Button {
                    text: qsTr("")
                    Material.background: Material.White
                    icon.source: "home.png"
                    ToolTip.delay: 1000
                    ToolTip.timeout: 3000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("AutoScale")
                    onClicked: {
                        unoDataLogger.home();
                    }
                }


                Button {
                    text: qsTr("Redraw")
                    Material.background: Material.White
                    onClicked: {
                        unoDataLogger.redraw();
                    }
                }


                ToolSeparator{}
                Button {
                    id: pan
                    text: qsTr("")
                    icon.source: "move.png"
                    Material.background: Material.White
                    checkable: true
                    onClicked: {
                        if (zoom.checked) {
                            zoom.checked = false;
                        }
                        unoDataLogger.pan();
                    }
                }

                Button {
                    id: zoom
                    text: qsTr("")
                    icon.source: "zoom.png"
                    Material.background: Material.White
                    checkable: true
                    onClicked: {
                        if (pan.checked) {
                            // toggle pan off
                            pan.checked = false;
                        }
                        unoDataLogger.zoom();
                    }
                }
                ToolSeparator {}
                TextInput {
                    id: location
                    readOnly: true
                    text: { try {
                            unoDataLogger.coordinates
                        }
                        catch (error) {
                            ""
                        }

                    }}

            }

        }

        GroupBox {
            id: groupBox_Acquisition
            width: 318
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 219
            anchors.bottomMargin: 14
            anchors.leftMargin: 0
            contentHeight: -2
            z: 1
            title: qsTr("")

            Button {
                y: 180
                width: 197
                height: 48
                text: qsTr("Start ")
                display: AbstractButton.TextOnly
                id: btnstart
                enabled: false
                objectName: "startButton"
                z: 1
                focusPolicy: Qt.StrongFocus
                anchors.left: parent.left
                anchors.leftMargin: 55
                Layout.fillWidth: false
                Layout.fillHeight: false
                Layout.columnSpan: 2
                Material.background: Material.Cyan
                onClicked: {
                    btnstart.enabled = false
                    unoDataLogger.runacq(nombreDePoints.text, tempsDechantillonge.text)
                }
            }

            Label {
                x: 5
                y: 87
                width: 124
                height: 40
                text: qsTr("sampling time in ms")
            }

            TextInput {
                id: nombreDePoints
                x: 180
                y: 28
                width: 110
                height: 33
                text: "120"
                topPadding: 0
                passwordCharacter: ""
                transformOrigin: Item.Center
                echoMode: TextInput.Normal
                horizontalAlignment: Text.AlignLeft
                focus: true
                Layout.fillWidth: true
                Material.background: "#FFFFFF"
                validator: IntValidator {
                    bottom: 1
                    top: 9999
                }

                Rectangle {
                    color: "#ffffff"
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0
                    z: -1
                    anchors.fill: parent
                }
            }

            Label {
                x: 5
                y: 28
                width: 124
                height: 40
                text: qsTr("Number of points")
            }

            TextInput {
                id: tempsDechantillonge
                x: 180
                y: 87
                width: 110
                height: 35
                text: "50"
                horizontalAlignment: Text.AlignLeft
                Layout.fillWidth: true
                validator: IntValidator {
                    bottom: 1
                    top: 9999999
                }

                Rectangle {

                    color: "#ffffff"
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0
                    z: -1
                    anchors.fill: parent
                }
                onAccepted: {if (tempsDechantillonge.text<5000)
                    {   nombreDePoints.text = 150
                    }
                }
            }


            Button {
                id: btnstop
                y: 244
                width: 196
                height: 48
                text: qsTr("Stop")

                Material.background: Material.Red
                font.family: "Times New Roman"
                anchors.left: parent.left
                anchors.leftMargin: 56
                onClicked: {

                    unoDataLogger.stopThread()

                }
            }


            Label {
                id: label1
                x: 5
                y: 133
                width: 124
                height: 27
                text: qsTr("Total time in s:")
            }


            Label {
                id: totaltime
                x: 180
                y: 133
                width: 69
                height: 27
                text: ((parseInt(nombreDePoints.text)-1) * parseInt(tempsDechantillonge.text))/1000
            }
            Rectangle {
                color: "#999999"
                anchors.rightMargin: -12
                anchors.leftMargin: -12
                anchors.bottomMargin: -12
                anchors.topMargin: -12
                z: -1
                anchors.fill: parent
            }
        }
        GroupBox {
            id: groupBox_Arduino
            x: -6
            y: 0
            width: 318
            height: 182
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            contentHeight: -2
            z: 1
            title: qsTr("")

            Label {
                id: label
                x: 0
                y: -7
                width: 215
                height: 23
                text: qsTr("Select serial port:")
            }

            ComboBox {
                id: comboBox
                objectName: "comboBox"
                x: 0
                y: 24
                width: 182
                height: 41
            }
            Button {
                id: button
                x: 194
                y: 25
                height: 41
                text: qsTr("refresh")
                onClicked:   unoDataLogger.refresh()

            }

            Rectangle {
                id: rectangle_acquisition
                color: "#999999"
                anchors.rightMargin: -12
                anchors.leftMargin: -12
                anchors.bottomMargin: -12
                anchors.topMargin: -12
                z: -1
                anchors.fill: parent
            }

            Button {
                id: button_arduinoDisconnect
                x: 172
                y: 36
                text: qsTr("disconnect")
                objectName: "btn_disconnect"
                enabled: false
                anchors.right: parent.right
                anchors.verticalCenterOffset: 33
                anchors.rightMargin: 22
                anchors.verticalCenter: parent.verticalCenter
                Material.background: Material.White
                onClicked: {
                    unoDataLogger.arduinoDisconnect()
                    label4.text = " "
                    btnstart.enabled = false
                }
            }

            Button {
                id: button_arduinoConnect
                y: 36
                text: qsTr("connect")
                objectName: "btn_connect"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.verticalCenterOffset: 33
                anchors.leftMargin: 7
                onClicked: {
                    label4.text = unoDataLogger.arduinoConnect()
                }
            }

            Label {
                id: label4
                x: 7
                y: 138
                width: 280
                height: 32
                text: qsTr("Arduino state:")
            }


        }

        Popup {
            id: popup
            anchors.centerIn: parent
            width: 500
            height: 300
            modal: true
            focus: true
            Loader {
                id: myLoader
                anchors.fill: parent
                source: "Screen01.qml"
            }
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        }

        Popup {
            id: popup2
            anchors.centerIn: parent
            width: 500
            height: 300
            modal: true
            focus: true
            Loader {
                id: myLoader2
                anchors.fill: parent
                source: "Popup_graph.qml"
            }
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        }
    }

}
























































