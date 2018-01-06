import QtQuick 2.0
import QtQuick.Controls 2.2

Dialog {
    visible: true
    width: parent.width * 0.75
    objectName: "loginId"
    id : loginId
    signal loginSignal(string msg, string msg)
    function loginDb(ok){
        if(ok){
            logonTextInput.text = "Добро пожаловать"
            close()
        }else{
            logonTextInput.text = "Попробуйте еще раз"
        }
        passwdTextInput.text = ""
        console.log("loginDb")
    }
    closePolicy: Popup.NoAutoClose
    modal: true
    x : (parent.width - width) / 2
    y : (parent.height - height) / 2
    //        header: Text {
    //            text: "Вход пользователя"
    //            font.pixelSize: 20
    //            anchors.horizontalCenter: parent.horizontalCenter
    //        }
    contentItem: Column {
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Text {
            text: "Имя пользователя"
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }
        TextInput {
            id: logonTextInput
            selectByMouse: true
            opacity: 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            Rectangle {
                width: parent.width
                height: parent.height
                color: "skyblue"
                border.color: "black"
                border.width: 1
                radius: 3
            }
            text: ""
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            cursorVisible: true
            width: parent.width / 2
            height: 40
            font.pixelSize: 16
            onVisibleChanged: {
                if (visible)
                    logonTextInput.forceActiveFocus()
            }
            Keys.onPressed: {
                if (event.key === Qt.Key_Tab) {
                    passwdTextInput.forceActiveFocus()
                    event.accepted = true
                }
            }
            onAccepted: {
                passwdTextInput.forceActiveFocus()
            }
        }

        Text {
            text: "Пароль"
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }
        TextInput {
            id: passwdTextInput
            selectByMouse: true
            opacity: 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle {
                width: parent.width
                height: parent.height
                color: "skyblue"
                border.color: "black"
                border.width: 1
                radius: 3
            }
            text: ""
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            //cursorVisible: true
            width: logonTextInput.width
            height: logonTextInput.height
            font.pixelSize: 16
            echoMode: TextInput.Password
            color: "black"
            Keys.onPressed: {
                if (event.key === Qt.Key_Tab) {
                    logonTextInput.forceActiveFocus()
                    event.accepted = true
                }
            }
            onAccepted: {
                // go to Logon part
                loginId.loginSignal(logonTextInput.text, passwdTextInput.text)
            }
        }
        Button {
            id: logonButton
            text: "Logon"
            anchors.horizontalCenter: parent.horizontalCenter
            onPressed: {
                // make some logon
                //close();
                loginId.loginSignal(logonTextInput.text, passwdTextInput.text)
            }
        }
    }
}
