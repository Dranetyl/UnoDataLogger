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
       x: 392
       y: 252
       text: qsTr("Close")
       anchors.right: parent.right
       anchors.rightMargin: 8
       anchors.bottom: parent.bottom
       anchors.bottomMargin: 8
       onClicked: popup.close()

   }

   Label {
       id: label
       height: 149
       text: qsTr("Data logger software for arduino \n Version 1.0 \n Developper: dranetyl \n E-mail: dranetyl@gmail.com")
       anchors.right: parent.right
       anchors.rightMargin: 0
       anchors.left: parent.left
       anchors.leftMargin: 0
       anchors.top: parent.top
       anchors.topMargin: 0
       font.pointSize: 11
       lineHeight: 1.6
       verticalAlignment: Text.AlignVCenter
       horizontalAlignment: Text.AlignHCenter
   }

   Text {
       id: link_Text
       x: 0
       y: 177
       width: 500
       height: 74
       text: '<html><style type="text/css"></style><a href="https://github.com/Dranetyl/UnoDataLogger">https://github.com/Dranetyl/UnoDataLogger</a></html>'
       font.pointSize: 11
       horizontalAlignment: Text.AlignHCenter
       onLinkActivated: Qt.openUrlExternally(link)
   }
}


























