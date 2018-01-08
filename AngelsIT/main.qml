import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import io.clistmodel 1.0

ApplicationWindow {
    property bool isAppendNew : false
    //signal EditCurrent(int idNote)
    // обновление данных из БД
    function refreshDb(listNotes){
        console.log("refreshDb")
        console.log(listNotes.length)
        var myArray = new Array()
        var i = 0
        i = listNotes.length;
        if((i != 0 ) && (i % 5 == 0)){
            for(var j=0; j < i ; j+=5){
                myArray.push(listNotes[j])
                myArray.push(listNotes[j+1])
                myArray.push(listNotes[j+2])
                myArray.push(listNotes[j+3])
                myArray.push(listNotes[j+4])
                console.log(listNotes[j+0])
                console.log(listNotes[j+1])
                console.log(listNotes[j+2])
                console.log(listNotes[j+3])
                console.log(listNotes[j+4])
            }
            listElemID.add(myArray)
        }

    }


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
                text = new Date().toLocaleString(Qt.locale("ru_RU"),
                                                 "dddd d MMMM ,  HH:MM:ss")
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

    LoginDialog {
        id : loginId

    }

    CListModel {
        id: listElemID
    }

    ListView {
        id: view

        anchors.margins: 10
        width: parent.width
        height: parent.height - 50
        spacing: 10
        model: listElemID
        clip: true

        highlight: Rectangle {
            color: "skyblue"
        }
        highlightFollowsCurrentItem: true

        EditItemDialog {
            id: newItemDialog
            isAdmin: loginId.isAdmin
            onEditElem: {
                listElemID.editItem(getDesc() )    //передать параметры в модельное представление
            }
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
                    onDoubleClicked: {

                        listElemID.curItemView(model.index)
                        newItemDialog.isEdit = true
                        newItemDialog.visible = true
                        //

                        newItemDialog.showItem(listElemID.getItem(model.index))
                    }
                }
            }
        }
    }

    footer: Row {
        id: buttonRow
        spacing : 20
        height: 40
        anchors.bottom: parent.bottom

        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: addButton
            text: "Добавить"
            onClicked: {
                newItemDialog.isAdd = true
                newItemDialog.visible = true
                isAppendNew = true; //??
//                listElemID.add(newItemDialog.getDesc())
            }

        }

        Button {
            id: delButton
            objectName: "delButton"
            signal delElem(int idNote)
            text: "Удалить"
            onClicked: {
                delButton.delElem( listElemID.getId(view.currentIndex) )

                listElemID.del(view.currentIndex)
            }
        }
    }
}
