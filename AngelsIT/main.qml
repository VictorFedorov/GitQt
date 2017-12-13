import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0

ApplicationWindow {
    visible: true
    width: 640
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
        ColumnLayout {
            id: leftSide
            anchors.left: AnchorLine
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: parent.height
            Layout.minimumWidth: parent.width / 2

            Rectangle {
                anchors.fill: parent
                color: "red"
            }
            Text {
                id: tmpId
                text: qsTr("sdf sg dfgf")
                //anchors.centerIn: leftSide
                anchors.top: AnchorLine
            }
            RowLayout {
                id: container
                Layout.minimumWidth: parent.width

                Rectangle {
                    anchors.fill: parent
                    color: "blue"
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
        ColumnLayout {
            id: rightSide
            anchors.right: AnchorLine
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: parent.height
            Layout.minimumWidth: parent.width / 2
            Rectangle {
                anchors.fill: parent
                color: "green"
            }
            Text {

                text: qsTr("Caption")
                anchors.centerIn: parent
            }
        }
    }

 }
