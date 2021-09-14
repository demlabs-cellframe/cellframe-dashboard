import QtQuick 2.0


//fixed define button fo module certificate


ToolButton {
    id: root
    x: 14 * pt
    y: 6 * pt
    height: 28 * pt
    width: height

    image.anchors {
        right: root.right
        rightMargin: 14 * pt
    }
    image.source: isHovered ? "qrc:/resources/icons/Certificates/close_icon_hover.svg"
                            : "qrc:/resources/icons/Certificates/close_icon.svg"
    image.width: 20 * pt
    image.height: 20 * pt
}  //
