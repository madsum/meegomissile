import QtQuick 1.0

Rectangle
{
    width: 200; height: 20;
    color: "white"; border.color: "black"; radius: 4
    smooth: true
    property alias text: field.text
    property alias ffocus: field.focus

    Item
    {
        //invisible padding
        id: padding
        width: 4
        height: 10
    }

    TextInput
    {
        y: 2
        id: field
        anchors.left: padding.right
        anchors.right: parent.right
        maximumLength: 13
        text: "default"; font.pixelSize: 12
        color: focus ? "black" : "gray"
    }
}
