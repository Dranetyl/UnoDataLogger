import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Window 2.7
import QtQuick.Layouts 1.10





Rectangle {
    id: rectangle
    width: 500
    height: 300

    Button {
        id: button1
        x: 358
        y: 260
        text: qsTr("Save and Close")

        anchors.right: parent.right
        anchors.rightMargin: 42
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        onClicked: {
            unoDataLogger.popupGraph(textField.text,textField1.text,textField2.text, textField3.text,textField4.text)
            popup2.close()
        }

    }


    ColumnLayout {
        id: columnLayout
        x: 15
        y: 8
        width: 133
        height: 225
        spacing: 7.4

        Text {
            id: element
            height: 35
            text: qsTr("Graph title:")

            font.pixelSize: 12
            Layout.fillWidth: true
        }

        Text {
            id: element2
            height: 35
            text: qsTr("Axis X title:")

            font.pixelSize: 12
        }

        Text {
            id: element1
            height: 35
            text: qsTr("Axis Y title:")

            font.pixelSize: 12
        }

        Text {
            id: element3
            height: 35
            text: qsTr("Chart 1 title:")

            font.pixelSize: 12
        }

        Text {
            id: element4
            height: 35
            text: qsTr("Chart 2 title:")

            font.pixelSize: 12
        }
    }

    ColumnLayout {
        id: columnLayout1
        x: 175
        y: 8
        width: 307
        height: 225
        spacing: 3



        TextField {
            id: textField
            width: 300
            text: qsTr("Chart")
            Layout.fillWidth: true
        }
        TextField {
            id: textField1
            width: 300
            text: qsTr("Time (in ms)")
            Layout.fillWidth: true
        }

        TextField {
            id: textField2
            text: qsTr("Voltage ( in Volt)")
            Layout.fillWidth: true
        }

        TextField {
            id: textField3
            text: qsTr("A0")
            Layout.fillWidth: true
        }
        TextField {
            id: textField4
            text: qsTr("A1")
            Layout.fillWidth: true
        }
    }


}
















































