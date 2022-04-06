import QtQuick 2.9


/*

  need move to common module

*/


MouseArea {
    property alias image: image
    property bool isHovered: false

    implicitHeight: 50
    implicitWidth: 50
    hoverEnabled: true

    onEntered: {
        isHovered = true
    }

    onExited: {
        isHovered = false
    }

    Image {
        id: image
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: parent.width / 2
        height: parent.height / 2
        verticalAlignment: Image.AlignVCenter
        horizontalAlignment: Image.AlignHCenter
        mipmap: true
    }
}   //
