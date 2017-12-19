import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import io.clistmodel 1.0



ApplicationWindow {
    visible: true
    width: 480
    height: 480
    title: qsTr("Notes")

    Material.theme: Material.Light
    Material.primary: Material.BlueGray
    Material.accent: Material.Teal

    header: ToolBar {
        Label {
            id: dateText
            function set() {
                text = new Date().toLocaleString(Qt.locale("ru_RU"), "dddd d MMMM ,  HH:MM:ss")
            }
            font.pixelSize: 20
            anchors.centerIn: parent
        }
        Timer {
            id: dateTimer
            interval: 1000
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: dateText.set()
        }
    }


    LoginDialog{
        id : loginId
    }

    CListModel{
        id : listElemID
    }


    ListView {
        id: view

        anchors.margins: 10
        width : parent.width
        height : parent.height - 50
        spacing: 10
        model: listElemID
        clip: true

        highlight: Rectangle {
            color: "skyblue"
        }
        highlightFollowsCurrentItem: true

        EditItemDialog{
            id : newItemDialog
        }


        delegate: Item {
            id: listDelegate

            property var view: ListView.view
            property var isCurrent: ListView.isCurrentItem

            width: view.width
            height: 40

            Rectangle {
                anchors.margins: 5
                anchors.fill: parent
               // radius: height / 2
                color: model.color
                border {
                    color: "black"
                    width: 1
                }

                Text {
                    anchors.centerIn: parent
                    renderType: Text.NativeRendering
                    text: "%1%2".arg(model.text).arg(isCurrent ? " *" : "")
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: view.currentIndex = model.index
                    onDoubleClicked:{

                        listElemID.curItemView(model.index)
                        newItemDialog.visible = true
                    }
                 }
            }
        }
    }

    footer :
        Row{
        id : buttonRow
        height: 40
         anchors.bottom: parent.bottom
         anchors.horizontalCenter: parent.horizontalCenter

         Button{
             id: addButton
             text: "Add"
             onClicked: listElemID.add({ color: "skyblue", text: "new" })
         }

         Button{
             id: delButton
             text: "Del"
             onClicked: listElemID.del(view.currentIndex);
         }

    }


 }
