import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0

Dialog {
    visible: true
    width: parent.width * 0.75
    height: parent.height
    objectName: "loginId"
    id : loginId
    signal loginSignal(string msg, string msg)
    property bool isAdmin: false // 0 - user, 1 - admin
    function loginDb(ok, isAdminRole){
        if(ok){
            logonTextInput.text = "Добро пожаловать"
            isAdmin = isAdminRole
            if(isAdmin){
                console.log("admin role")
            }else{
                console.log("user role")

            }
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
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.verticalCenter: parent.verticalCenter
       topPadding :  45
        anchors.centerIn: parent
        Image {
            id: loginIdname
            source: "qrc:/user.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
//        CText {
//            text: "Имя пользователя"
//            font.pixelSize: 20
//            anchors.horizontalCenter: parent.horizontalCenter
//            //Material.foreground: color("#F44336")
//        }
        TextField {
            id: logonTextInput
            selectByMouse: true
            placeholderText: "имя пользователя"

            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
//            Rectangle {
//                width: parent.width
//                height: parent.height
//                color: "#414856"
//                opacity: 0.5
//                border.color: "black"
//                border.width: 1
//                radius: 5
//                 Material.theme: Material.Dark


//            }
            text: ""
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            cursorVisible: true
            width: parent.width * 2 / 3
            height: 40
            font.pixelSize: 16
            onVisibleChanged: {
               // if (visible)
                    //logonTextInput.forceActiveFocus()
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

//        CText {
//            text: "Пароль"
//            font.pixelSize: 18
//            anchors.horizontalCenter: parent.horizontalCenter
//        }
        TextField {
            id: passwdTextInput

            anchors.horizontalCenter: parent.horizontalCenter
            text: ""
            placeholderText: "пароль"
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            width: logonTextInput.width
            height: logonTextInput.height
            font.pixelSize: 16
            echoMode: TextInput.Password
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
        CButton {
            id: logonButton
            text: "Вход"
             width: logonTextInput.width
            anchors.horizontalCenter: parent.horizontalCenter
            onPressed: {
                // make some login
                loginId.loginSignal(logonTextInput.text, passwdTextInput.text)
            }

        }
    }
}
