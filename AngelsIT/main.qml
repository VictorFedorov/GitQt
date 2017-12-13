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
            text: qsTr("App")
            font.pixelSize: 20
            anchors.centerIn: parent
        }
    }
    /*
    Grid {
        id:userGroup
         columns: 2
         spacing: 2
         Text
         {
             id:userNameText
             text: qsTr("Login as:")
          }
         Text
         {
             id:userName
             text: qsTr("User Name")
         }

     }

*/
    ListView {
        anchors.fill: parent
        model: myListModel
        /*       delegate: Row {
            Text { text: "Name is: " + name  + ", "}
            Text { text: "Number : $" + number }
        }
        */
    }

    ListModel {
        id: myListModel
        ListElement {
            name: "Bill Smith"
            number: "555 3264"
        }
        ListElement {
            name: "John Brown"
            number: "555 8426"
        }
        ListElement {
            name: "Sam Wise"
            number: "555 0473"
        }
    }

    footer: RowLayout {
        id: container

        Button {
            id: addButton
            //width: container.width / 4

            text: qsTr("+")
            //onClicked: model.submit()

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
