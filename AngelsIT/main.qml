import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0

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

    RowLayout {
        id: mainLayout
        anchors.fill: parent
        layer.enabled: true
        Rectangle {
            id:mainLayoutBackground
            anchors.fill: parent
            color:  Material.color(Material.BlueGrey)

        }
        ColumnLayout {
            id: leftSide
            anchors.fill: parent
            spacing: 10
//            ListView {
//                id: reqListView
//                anchors.fill: parent
//                spacing: 10
//                delegate: Item {
//                     width: 80
//                    height: 40
//                    Row {
//                        id: row1
//                        spacing: 10
//                        Rectangle {
//                            width: 40
//                            height: 40
//                            color: colorCode
//                        }
//                        Text {
//                            text: caption
//                            anchors.verticalCenter: parent.verticalCenter
//                            font.bold: true
//                            font.pixelSize: 15
//                        }
//                    }
//                }
//                model: ListModel {
//                    id : reqListModel
//                    CListElem{


//                    }
//                }
//            }

             RowLayout {
                id: btnContainer
                Layout.minimumWidth: parent.width

                Rectangle {
                    anchors.fill: parent
                    color:  Material.color(Material.Indigo)

                }
                anchors.bottom: parent.bottom

                //anchors.fill: parent
                Button {
                    id: addButton
                    //width: container.width / 4
                    text: qsTr("+")
                    //onClicked: model.submit()
                    anchors.centerIn: AnchorLine
                }
                Button {
                    id: delButton
                    //width: container.width / 4
                    text: qsTr("-")
                    //onClicked: model.submit()
                }
                Button {
                    id: modifyButton
                    //width: container.width / 4
                    text: qsTr("Modify")
                    //onClicked: model.submit()
                }
                Button {
                    id: setupButton
                    //width: container.width / 4
                    text: qsTr("SetUp")
                    //onClicked: model.submit()
                }
            }
        }
    }


 }
