import QtQuick 1.0

Rectangle {
    width: 25
    height: 25
    border.color: "black"; border.width: 1
    property bool checked: false

    Image
    {
        id: checkmark
        source: "qrc:/gfx/checkmark.png"
        anchors.centerIn: parent
        opacity: checked ? "1" : "0"
    }

    states: [
        State {
            name: "checked"
            PropertyChanges { target: checkmark; opacity: 1 }
        }
    ]
}
