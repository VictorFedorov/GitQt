import QtQuick 2.7
import QtQuick.Controls 2.1

TextArea {
    id: textAreaID
    property string colorActive: "#7e7f83" // свойство для хранения цвета
    property string colorNotActive: "#414856"
    background: Rectangle {
        color: "#414856"
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
        id: backID
        anchors.fill: parent
        color: "red" //"#414856"
        opacity: 0.5
        states: [
            State {
                name: "StateNotActive"
                PropertyChanges {
                    target: backID
                    color: colorNotActive
                }
            },
            State {
                name: "StateActive"
                PropertyChanges {
                    target: backID
                    color: colorActive
                }
            }
        ]
        transitions: [
            Transition {
                from: "StateNotActive"
                to: "StateActive"
                // Новый текст
                ColorAnimation {
                    target: backID
                    duration: 500
                }
            },
            Transition {
                to: "StateNotActive"
                from: "StateActive"
                // Новый текст
                ColorAnimation {
                    target: backID
                    duration: 500
                }
            }
        ]
}

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            property int selStart:0
            property int selEnd:0
            property bool isSelected: false
            onEntered: {
                backID.state = "StateActive"
            }
            onExited: {
                 backID.state = "StateNotActive"
            }
            onDoubleClicked: {
                parent.selectAll()
            }
            onVisibleChanged: {
                if(visible === true){
                    backID.state = "StateNotActive"
                }
            }
            onClicked:  {
                //parent.cursorPosition = parent.positionAt(mouseX, mouseY)
            }

            onPressed:  {
                isSelected = true
                selStart = parent.positionAt(mouseX, mouseY)
            }
            onReleased:  {
                selEnd = parent.positionAt(mouseX, mouseY)
                parent.select(selStart, selEnd)
                isSelected = false
            }
            onMouseXChanged: {
                if(isSelected){
                    selEnd = parent.positionAt(mouseX, mouseY)
                    parent.select(selStart, selEnd)
                }
            }
        }
    //}
}
