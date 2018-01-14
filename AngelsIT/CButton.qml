import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Styles 1.4
Button {
    text: qsTr("Button")
    id: control

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: "#d3dae3"
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

}
//    background: Rectangle {
////                  implicitWidth: 100
////                  implicitHeight: 25
////                  border.width: control.activeFocus ? 2 : 1
//                  border.color: "#888"
//                  radius: 4
//                  gradient: Gradient {
//                      GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
//                      GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
//                  }
//              }

}
