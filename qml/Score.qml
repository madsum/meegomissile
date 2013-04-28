import QtQuick 1.0

Item
{
    id: root
    width: 40
    height: parent.height
    property int local: 0
    property int remote: 0

    Text
    {
        //local score
        id: loc
        font.pixelSize: 24
        style: Text.Outline
        styleColor: "black"
        color: "white"
        anchors.bottom: parent.bottom
        text: root.local
    }

    Text
    {
        //remote score
        id: rem
        font.pixelSize: 24
        style: Text.Outline
        styleColor: "black"
        color: "white"
        anchors.top: parent.top
        text: root.remote
    }
}
