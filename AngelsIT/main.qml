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

    Material.theme: Material.BlueGray
    Material.primary: Material.BlueGray
    Material.accent: Material.Teal
//    Material.background: Material.LightGreen


    header: ToolBar {
        Rectangle{
            anchors.fill: parent
            color: 'steelblue'
        }
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
        ScrollBar.vertical: ScrollBar {
            id: vbar
            active: vbar.active
        }

        anchors.margins: 10
        width: parent.width
        height: parent.height
        spacing: 6
        model: listElemID
        clip: true

        highlight: Rectangle {
            color: "steelblue"
        }
        highlightFollowsCurrentItem: true

        EditItemDialog {
            id: newItemDialog
            isAdmin: loginId.isAdmin
            onEditElem: {
                listElemID.editItem(getDesc() )    //передать параметры в модельное представление
            }
            onVisibleChanged: {
                if (visible === false){
                  listElemID.repaintElement()
                }
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
                radius: height / 2
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
                        newItemDialog.setCurId(listElemID.getId(model.index))
                        newItemDialog.showItem(listElemID.getItem(model.index))
                    }
                }
            }
        }
    }

    footer: Rectangle {
        height: 40
        color: "steelblue"

        id: buttonRow
Row{


        spacing : (parent.width - addButton.width - delButton.width)/3
        height: 40
        leftPadding: (parent.width - addButton.width - delButton.width)/3
        rightPadding: 6
        bottomPadding: 10
        //anchors.bottom: parent.bottom
        //anchors.horizontalCenter: parent.horizontalCenter
        visible: !loginId.isAdmin
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
                if(view.currentIndex >=0){
                    delButton.delElem( listElemID.getId(view.currentIndex) )
                    listElemID.del(view.currentIndex)
                }
            }
        }
    }}
}
