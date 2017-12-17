import QtQuick 2.0

Rectangle {
    width: 360
    height: 360

    ListModel {
        id: dataModel

        Component.onCompleted: {
            append({ color: "orange" })
            append({ text: "another old" })
        }
    }
    Column {
        anchors.margins: 10
        anchors.fill: parent
        spacing: 10

        ListView {
            id: view

            width: parent.width
            height: parent.height - button.height - parent.spacing - 50
            spacing: 10
            model: dataModel
            clip: true

            delegate: Rectangle {
                width: view.width
                height: 40
                color: model.color || "lightgray"
                Text {
                    anchors.centerIn: parent
                    renderType: Text.NativeRendering
                    text: model.text || "old"
                }
            }
        }

        Rectangle {
            id: button

            width: 100
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter
            border {
                color: "black"
                width: 1
            }

            Text {
                anchors.centerIn: parent
                renderType: Text.NativeRendering
                text: "Add"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: dataModel.append({ color: "skyblue", text: "new" })
            }
        }
    }
}
