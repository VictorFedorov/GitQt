import QtQuick 2.0
import QtQuick.Controls 2.2

Dialog {
    id: newItemDialog
    objectName: "newItemDialog"
    property int curState: 0
    property int curId: 0
    property bool isAdd: false
    property bool isEdit: false
    property bool isAdmin: false // 0 - user, 1 - admin
    signal addNewElem(string msgCapt, string msgText, string msgCom, int msgState)
    signal editElem(int curId, string msgCapt, string msgText, string msgCom, int msgState)

    visible: false
    title: " "
    width: parent.width
    property int textSize: 16
    property int captionSize: 16
    font.pixelSize: captionSize
    opacity: 0
    //установить id текущей записи
    function setCurId(newCurId){
        curId = newCurId
    }
    function animShow(){
        visible = true;
    }
    //    header: Text {
    //        text: "Редактирование записи"
    //        font.pixelSize: captionSize
    //        anchors.horizontalCenter: parent.horizontalCenter
    //    }
    PropertyAnimation {
        id: animHideId
        target: newItemDialog;
        property: "opacity";
        to: 0
        duration: 500
        easing: Easing.InQuint
    }
    PropertyAnimation {
        id: animShowId
        target: newItemDialog;
        property: "opacity";
        easing: Easing.Linear
        from: 0
        to: 100
        duration: 5000
    }
    contentItem: Column {
        spacing: 2
        CText {
            text: "Название:"
            font.pixelSize: captionSize
        }

        Rectangle {
            clip: true
            border {
                color: "black"
                width: 1
            }
            width: parent.width
            height: 20
            color: "#414856"
            Flickable {
                clip: true
                interactive: true
                anchors.fill: parent

                TextArea.flickable: CTextArea  {
                id: newNoteCaption
                text: ""
                width: parent.width
                height: parent.height
                font.pixelSize: textSize
                    Keys.onPressed: {
                        if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Tab) {
                            newNoteVal.forceActiveFocus()
                            event.accepted = true
                        }

                    }
                }
            }
        }
        CText {
            text: "Содержание:"
            //color: "navy"
            font.pixelSize: captionSize
        }

        Rectangle {
            //color: "lightskyblue"
            border {
                color: "black"
                width: 1
            }
            width: parent.width
            height: 3 * 40

            Flickable {
                id: flick
                clip: true
                interactive: true
                anchors.fill: parent

                ScrollBar.vertical: ScrollBar {
                    id: vbar
                    active: vbar.active
                }
                TextArea.flickable: CTextArea {
                    id: newNoteVal
                    text: ""
                    Keys.onPressed: {
                        if (event.key === Qt.Key_Tab) {
                            newNoteComment.forceActiveFocus()
                            event.accepted = true
                        }
                    }
                }
            }
        }
        CText {
            text: "Комментарий:"
            //color: "navy"
            font.pixelSize: captionSize
        }

        Rectangle {
            //color: "lightskyblue"
            clip: true
//            border {
//                color: "black"
//                width: 1
//            }
            width: parent.width
            height: 40
            Flickable {
                id: commentFlick
                clip: true
                interactive: true
                anchors.fill: parent

                ScrollBar.vertical: ScrollBar {
                    id: commentVbar
                    active: vbar.active
                }

                TextArea.flickable: CTextArea  {
                id: newNoteComment
                text: ""
                width: parent.width
                height: parent.height
                font.pixelSize: textSize
            }

            }
        }
        CText {
            text: "Состояние:"
            //color: "navy"
            font.pixelSize: captionSize
        }

        ComboBox {
            id: newNoteState
            textRole: "key"
            model: ListModel {
                id: newNoteStateModel
                ListElement {
                    key: "Новая"
                    value: 1
                }
                ListElement {
                    key: "В работе"
                    value: 2
                }
                ListElement {
                    key: "Решена"
                    value: 3
                }
            }
            onCurrentIndexChanged: {
                if(newNoteStateModel.count > 0){
                    curState = newNoteStateModel.get(newNoteState.currentIndex).value
                }
            }
        }
    }
    standardButtons: Dialog.Ok | Dialog.Cancel
    function getDesc() {
        var caption, text, comment, state
        caption = newNoteCaption.getText(0, newNoteCaption.length)
        text = newNoteVal.getText(0, newNoteVal.length)
        comment = newNoteComment.getText(0, newNoteComment.length)
        return [curId, caption, text, comment, curState]
    }
    onAccepted: {
        // по нажатию на ОК
        console.log("onAccepted")
         animHide.start();
        // 1. если добавляли элемент, то добавить его в БД
        // 2. если редактировали элемент, то обновить его в БД
        // по-идее это можно совместить, проверяя по id записи
        var caption, text, comment, state
        if (isAdd) {
            // 1 //
            console.log("onAccepted - ADD")
            caption = newNoteCaption.getText(0, newNoteCaption.length)
            text = newNoteVal.getText(0, newNoteVal.length)
            comment = newNoteComment.getText(0, newNoteComment.length)
            newItemDialog.addNewElem(caption, text, comment, curState)
            isAdd = false
        }
        if (isEdit) {
            // 2 //
            console.log("onAccepted - EDIT")
            caption = newNoteCaption.getText(0, newNoteCaption.length)
            text = newNoteVal.getText(0, newNoteVal.length)
            comment = newNoteComment.getText(0, newNoteComment.length)
            newItemDialog.editElem(curId, caption, text, comment, curState)
            isEdit = false
        }
    }
    onRejected: {
        // по нажатию ОТМЕНА или закрытию окна
        isAdd = false
        isEdit = false
        console.log("onRejected")
    }
    onVisibleChanged: {
        if (visible) {
            console.log("visible")
            // отображение элементов управления в соответствии с ролью пользователя
            if (isAdmin) {
                console.log("isAdmin")
                newNoteCaption.enabled = false
                newNoteVal.readOnly = true
                newNoteComment.enabled = true
                newNoteState.enabled = true
            } else {
                console.log("isUser")
                newNoteCaption.enabled = true
                newNoteVal.readOnly = false
                newNoteComment.enabled = true
                newNoteState.enabled = true
            }
            if (isAdd) {
                // надо очистить все поля, спрятать статус заявки
                clear()
                newNoteCaption.enabled = true
                newNoteVal.readOnly = false
                newNoteState.enabled = false
                newNoteCaption.forceActiveFocus()
                newNoteComment.enabled = true
                newNoteCaption.cursorVisible = true
                newNoteVal.cursorVisible = true
            }else{
                newNoteVal.readOnly = true
                newNoteCaption.cursorVisible = false
                newNoteVal.cursorVisible = false
            }
            if (isEdit){
                newNoteStateModel.clear()
                newNoteStateModel.append({
                                         key: "В работе",
                                         value: 2
                                     })
                newNoteStateModel.append({
                                         key: "Решена",
                                         value: 3
                                     })
            }
            if (isAdd) {
                newNoteStateModel.clear()
                newNoteStateModel.append({
                                             key: "Новая",
                                             value: 1
                                         })
                newNoteState.currentIndex = 0
            }
         }
    }
    onAboutToShow: {
        console.log("onAboutToShow")
        opacity = 0;
        animShowId.start();
    }
    function clear() {
        newNoteState.enabled = false
        newNoteState.currentIndex = 0
        newNoteCaption.text = ""
        newNoteVal.text = ""
        newNoteComment.text = ""
    }
    //отображение параметров текущего элемента
    function showItem(curElem) {
        console.log('showItem')
        console.log(curElem.length)
        if (curElem.length >= 5 && isEdit) {
            //скрыть/показать элементы управления
            newNoteCaption.enabled = false
            newNoteVal.readOnly = true
            newNoteState.enabled = true
            newNoteComment.forceActiveFocus()
            newNoteComment.enabled = true
            //curElem[0] - id записи
            newNoteCaption.text = curElem[1]
            newNoteVal.text = curElem[2]
            newNoteComment.text = curElem[3]
            newNoteState.currentIndex = getModelIndex(curElem[4])


        } else {
            console.log('showItem - err curElem.length')
        }
    }
    function getModelIndex(curKey){
        var i
        for(i=0; i < newNoteStateModel.count; i++){
            if (newNoteStateModel.get(i).value == curKey){
                return i
            }
        }
        console.log('getModelIndex, err find index form key')
        return 0
    }
}
