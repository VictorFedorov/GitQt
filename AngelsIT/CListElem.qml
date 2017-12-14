import QtQuick 2.0
ListView {

    ListElement {
        id: reqListElem
        property string caption
        property string text
        property int    state
        property color  stateColor

        caption: "Banana"
        text : "asd"
        state : 1
        stateColor: "#00ff00"
    }

}
