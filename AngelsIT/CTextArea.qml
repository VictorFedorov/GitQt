import QtQuick 2.0
import QtQuick.Controls 2.1
TextArea {
    background: Rectangle {
        color: "#414856"
        border.color: parent.enabled ? "#transparent" : "transparent"
    }
    color: "#d3dae3"
    textFormat: TextEdit.RichText
    cursorVisible: true
    wrapMode: TextInput.WordWrap
    leftPadding: 6
    rightPadding: 6
    topPadding: 0
    bottomPadding: 0
    selectByMouse: true
    selectionColor: "#5596df"
        Rectangle {
            anchors.fill: parent
            color: "#414856"
            opacity: 0.5
    }

}
