import QtQuick 2.0
import QtQuick.Controls 2.2

Dialog {
    id: newItemDialog
    objectName: "newItemDialog"
    property int curState: 0
    property bool isAdd: false
    property bool isEdit: false
    property bool isAdmin: false // 0 - user, 1 - admin
    signal addNewElem(string msgCapt, string msgText, string msgCom, int msgState)

    visible: false
    title: " "
    width: parent.width
    property int textSize : 16
    property int captionSize : 16
    font.pixelSize: captionSize


//    header: Text {
//        text: "Редактирование записи"
//        font.pixelSize: captionSize
//        anchors.horizontalCenter: parent.horizontalCenter
//    }

    contentItem: Column {
        spacing: 2
        Text {
             text: "Название:"
             color: "navy"
             font.pixelSize: captionSize
         }

        Rectangle {
            color: "lightskyblue"
            clip: true
            border {
                color: "black"
                width: 1
            }
            width: parent.width
            height : 20

            TextInput {
                id : newNoteCaption
                text: ""
                cursorVisible: false
                wrapMode: TextInput.WordWrap
                width: parent.width
                height: parent.height
                font.pixelSize: textSize
                onVisibleChanged: {
                    if (visible)
                        newNoteCaption.forceActiveFocus()
                }
                Keys.onPressed: {
                    if (event.key === Qt.Key_Tab) {
                        newNoteVal.forceActiveFocus()
                        event.accepted = true
                    }
                }
                onAccepted: {
                    newNoteVal.forceActiveFocus()
                }

            }
        }
        Text {
             text: "Содержание:"
             color: "navy"
             font.pixelSize: captionSize
         }

        Rectangle {
            color: "lightskyblue"
            clip: true
            border {
                color: "black"
                width: 1
            }
            width: parent.width
            height : 3*40

            TextInput {
                id : newNoteVal
                text: ""
                cursorVisible: false
                wrapMode: TextInput.WordWrap
                width: parent.width
                height: parent.height
                font.pixelSize: textSize
                Keys.onPressed: {
                    if (event.key === Qt.Key_Tab) {
                        newNoteComment.forceActiveFocus()
                        event.accepted = true
                    }
                }
            }
        }
        Text {
             text: "Комментарий:"
             color: "navy"
             font.pixelSize: captionSize
         }

        Rectangle {
            color: "lightskyblue"
            clip: true
            border {
                color: "black"
                width: 1
            }
            width: parent.width
            height : 40

            TextInput {
                id : newNoteComment
                text: ""
                cursorVisible: false
                wrapMode: TextInput.WordWrap
                width: parent.width
                height: parent.height
                font.pixelSize: textSize
            }
        }
        Text {
             text: "Состояние:"
             color: "navy"
             font.pixelSize: captionSize
         }

        ComboBox {
            id : newNoteState
            textRole: "key"
            model: ListModel {
                id : newNoteStateModel
                ListElement {
                    key: "Новая";
                    value: 1
                }
                ListElement {
                    key: "В работе";
                    value: 2
                }
                ListElement {
                    key: "Решена";
                    value: 3
                }
            }
            onVisibleChanged: {
                if (visible && isEdit)
                    newNoteStateModel.clear()
                    newNoteStateModel.append({"key":"В работе","value": 2});
                    newNoteStateModel.append({"key":"Решена","value": 3});
                if (visible && isAdd){
                    newNoteStateModel.clear()
                    newNoteStateModel.append({"key":"Новая","value": 1});
                }
            }
            onCurrentIndexChanged: {

                curState = newNoteState.currentIndex;
            }
        }
    }
    standardButtons: Dialog.Ok | Dialog.Cancel
    function getDesc(){
        var caption, text, comment, state;
        caption = newNoteCaption.getText(0, newNoteCaption.length);
        text = newNoteVal.getText(0, newNoteCaption.length);
        comment = newNoteComment.getText(0, newNoteCaption.length);
        return [caption, text, comment, curState]
    }
    onAccepted: {
        // по нажатию на ОК
        console.log("onAccepted")
        // 1. если добавляли элемент, то добавить его в БД
        // 2. если редактировали элемент, то обновить его в БД
        // по-идее это можно совместить, проверяя по id записи
        if (isAdd){
            // 1 //
            var caption, text, comment, state;
            caption = newNoteCaption.getText(0, newNoteCaption.length);
            text = newNoteVal.getText(0, newNoteCaption.length);
            comment = newNoteComment.getText(0, newNoteCaption.length);
            newItemDialog.addNewElem(caption, text, comment, curState);
            isAdd = false;
        }
        if (isEdit){
            // 2 //
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
        if(visible){
            console.log("visible")
            // отображение элементов управления в соответствии с ролью пользователя
            if(isAdmin){
                console.log("isAdmin")
                newNoteCaption.enabled = false
                newNoteVal.enabled = false
                newNoteComment.enabled = true
                newNoteState.enabled = true
            }else{
                console.log("isUser")
                newNoteCaption.enabled = true
                newNoteVal.enabled = true
                newNoteComment.enabled = true
                newNoteState.enabled = true
           }
            if(isAdd){
                // надо очистить все поля, спрятать статус заявки
                clear();
                newNoteCaption.enabled = true
                newNoteVal.enabled = true
                newNoteState.enabled = false
                newNoteComment.forceActiveFocus()
                newNoteComment.enabled = true

            }
        }
    }
    function clear(){
        newNoteState.enabled = false
        newNoteState.currentIndex = 0
        newNoteCaption.text = ""
        newNoteVal.text = ""
        newNoteComment.text = ""
    }
    //отображение параметров текущего элемента
    function showItem(curElem){
        console.log('showItem')
        console.log(curElem.length)
        if(curElem.length >= 5 && isEdit){
            //скрыть/показать элементы управления
            newNoteCaption.enabled = false
            newNoteVal.enabled = false
            newNoteState.enabled = true
            newNoteComment.forceActiveFocus()
            newNoteComment.enabled = true
            //curElem[0] - id записи
            newNoteCaption.text = curElem[1];
            newNoteVal.text = curElem[2];
            newNoteComment.text = curElem[3];
            newNoteState.currentIndex = curElem[4];
            isEdit = false;
        }else{
            console.log('err length!!!')
        }
    }
}
