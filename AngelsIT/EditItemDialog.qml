import QtQuick 2.0
import QtQuick.Controls 2.2

Dialog {
    property int curState: 0


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
                ListElement { key: "Новая"; value: 1 }
                ListElement { key: "В работе"; value: 2 }
                ListElement { key: "Решена"; value: 3 }
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
}
