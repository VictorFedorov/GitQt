import QtQuick 2.6
TextInput {
    opacity: 1
    color: "#d3dae3"
    selectionColor: "#5596df"
    Rectangle {
        id: back
        anchors.fill: parent
        color: "#414856"
        opacity: 0.5
    }
    cursorVisible: true
    wrapMode: TextInput.WordWrap
    selectByMouse: true
    MouseArea {
        hoverEnabled: true
             anchors.fill: parent
             onEntered: {
                 back.color = "#7b8292"
             }

             onExited: {
                 back.color = "#414856"
             }
         }

}
