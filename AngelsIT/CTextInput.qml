import QtQuick 2.6
TextInput {
    property string colorActive: "#7e7f83" // свойство для хранения цвета
    property string colorNotActive: "#414856"
    id : textID
    opacity: 1
    color: "#d3dae3"
    selectionColor: colorActive
    Rectangle {
        id: back
        anchors.fill: parent
        //color: "#414856"

        states: [
            State {
                name: "StateNotActive"
                PropertyChanges {
                    target: back
                    color: colorNotActive
                }
            },
            State {
                name: "StateActive"
                PropertyChanges {
                    target: back
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
                    target: back
                    duration: 500
                }
            },
            Transition {
                to: "StateNotActive"
                from: "StateActive"
                // Новый текст
                ColorAnimation {
                    target: back
                    duration: 500
                }
            }
        ]

        opacity: 0.5
    }
//    cursorVisible: true
    wrapMode: TextInput.WordWrap
    selectByMouse: true
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            back.state = "StateActive"
            textID.forceActiveFocus();
        }
        onExited: {
            back.state = "StateNotActive"
        }
        onDoubleClicked: {
            textID.selectAll()
        }
    }
    onVisibleChanged: {
        if(visible === true){
            back.state = "StateNotActive"
        }
    }
}
