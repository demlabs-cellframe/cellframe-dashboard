import QtQuick 2.9
import QtQuick.Controls 2.12

Item {
    property string normalImage
    property string hoverImage

    property alias widthImage: image.sourceSize.width
    property alias heightImage: image.sourceSize.height

    signal clicked()

    Image{
        id: image
        anchors.centerIn: parent
        mipmap: true
        source: area.containsMouse? hoverImage: normalImage
    }

    MouseArea{
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: parent.clicked()
    }
}
