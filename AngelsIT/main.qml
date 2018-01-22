import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
//import QtQuick.Controls.Material 2.2
import io.clistmodel 1.0

ApplicationWindow {
    property bool isAppendNew: false
    // обновление данных из БД
    function refreshDb(listNotes) {
        console.log("refreshDb")
        console.log(listNotes.length)
        var myArray = new Array()
        var i = 0
        i = listNotes.length
        if ((i != 0) && (i % 5 == 0)) {
            for (var j = 0; j < i; j += 5) {
                myArray.push(listNotes[j])
                myArray.push(listNotes[j + 1])
                myArray.push(listNotes[j + 2])
                myArray.push(listNotes[j + 3])
                myArray.push(listNotes[j + 4])
                console.log(listNotes[j + 0])
                console.log(listNotes[j + 1])
                console.log(listNotes[j + 2])
                console.log(listNotes[j + 3])
                console.log(listNotes[j + 4])
            }
            listElemID.add(myArray)
        }else{
            if (i === 1){
                if (listNotes[0] === "empty"){
                    console.log("list is empty")
                    listElemID.del(-1)
                }
            }
        }
    }
    function deleteItem(itemId){
        console.log("delete item ")
        console.log(itemId)
        listElemID.delItem(itemId)
    }

    visible: true
    width: 480
    height: 480
    title: qsTr("Notes")

    header: ToolBar {
        Rectangle {
            anchors.fill: parent
            color: "#41454e"
        }
        Label {
            id: dateText
            color: "#d3dae3"

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
        id: loginId
    }

    CListModel {
        id: listElemID
        onStateChanged: {
            console.log("state changed ", id, newState)
            //testAnimId.start()
        }
    }

    ListView {
        id: view
        ScrollBar.vertical: ScrollBar {
            id: vbar
            active: vbar.active
        }

        //анимация при добавлении элемента в список
        add: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity";
                    from: 0
                    to: 1.0;

                    duration: 2000 }
            NumberAnimation {
                property: "x";
                from: view.width/3;
                duration: 1000
                easing.type: Easing.OutCirc;
            }
            NumberAnimation {
                property: "y";
                from: -100;
                duration: 1000
                easing.type: Easing.OutCirc;
            }

            }
         }

        remove: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; to: 0; duration: 2000 }
                NumberAnimation {
                    properties: "x,y";
                    to: view.height;
                    duration: 2000
                    easing.type: Easing.OutCirc;
                }
            }
        }
        populate: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; to: 0; duration: 2000 }
             }
        }
        anchors.margins: 5
        width: parent.width
        height: parent.height
             spacing: 1
             model: listElemID
        clip: true

        highlight: Rectangle {
            id:higlightRectId
            color: "#d3dae3"
            //color: "black"
        }
        highlightFollowsCurrentItem: true
        highlightMoveVelocity : 300
        EditItemDialog {
            id: newItemDialog
            isAdmin: loginId.isAdmin
            onEditElem: {
                listElemID.editItem(getDesc()) //передать параметры в модельное представление
            }

        }

        delegate: Item {
            id: listDelegate
            Behavior on scale
            {
                NumberAnimation
                {
                    duration: 400
                }   // NumberAnimation
            }   // Behavior

            property var view: ListView.view
            property var isCurrent: ListView.isCurrentItem

            width: view.width
            height: 40
            ColorAnimation on color { id: colorID; to: "purple"; duration: 8000 }
            PropertyAnimation{
                id:myAnimation
                property:
            }

            Rectangle {
                id: listDelegateRect
                anchors.margins: 5
                anchors.fill: parent
                radius: 5
                color: model.color
                Text {
                    id:textItemDelegateId
                    anchors.centerIn: parent
                    renderType: Text.NativeRendering
                    //text: "%1%2".arg(model.text).arg(isCurrent ? " *" : "")
                    text: (model.text)
               }

                MouseArea {
                    anchors.fill: parent
                    onClicked: view.currentIndex = model.index
                    hoverEnabled: true
                    onDoubleClicked: {
                        listElemID.curItemView(model.index)
                        newItemDialog.isEdit = true
                        newItemDialog.visible = true
                        newItemDialog.setCurId(listElemID.getId(model.index))
                        newItemDialog.showItem(listElemID.getItem(model.index))
                    }
                    onEntered:{
                        //view.currentIndex = model.index
                        //textItemDelegateId.font.weight = Font.Bold
                        listDelegate.scale = 1.3
                    }
                    onExited:{
                        //textItemDelegateId.font.weight = Font.Thin
                        listDelegate.scale = 1
                    }

                }
            }
        }
    }

    footer: Rectangle {
        height: 50
        color: "#3e3f49"

        id: buttonRow
        Row {
            spacing: (parent.width - addButton.width - delButton.width) / 3
            height: parent.height
            leftPadding: (parent.width - addButton.width - delButton.width) / 3
            rightPadding: 6
            bottomPadding: 10
            CButton {
                id: addButton
                height: parent.height
                width: parent.width/2-5
                contentItem: Image{
                    source: "qrc:/add-event.png"
                    fillMode: Image.PreserveAspectFit
                }

//                Image {
//                    id : iconID
//                     source: "qrc:/add-event.png"
//                 }


                //text: "Добавить"
                visible: !loginId.isAdmin
                onClicked:
                {
                    newItemDialog.isAdd = true
                    isAppendNew = true
                    newItemDialog.opacity = 0.0
                    newItemDialog.open();
                }
            }

            CButton {
                id: delButton
                objectName: "delButton"
                height: parent.height
                width: parent.width/2-5
                contentItem: Image{
                    source: "qrc:/del-event.png"
                    fillMode: Image.PreserveAspectFit
                }
                signal delElem(int idNote)
                text: "Удалить"
                visible: !loginId.isAdmin
                onClicked: {
                    if (view.currentIndex >= 0) {
                        delButton.delElem(listElemID.getId(view.currentIndex))
                        listElemID.del(view.currentIndex)
                    }
                }
            }
            CButton{
                id: refreshButton
                visible: false
                objectName: "refreshButton"
                text: "Обновить"
                signal refreshData()
                onClicked: {
                    refreshButton.refreshData()
                }
            }
        }
    }
}
