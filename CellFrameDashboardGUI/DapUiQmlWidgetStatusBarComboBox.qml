import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

ComboBox {
    width: 100 * pt

//    id: comboboxWallet
//    anchors.left: parent.left
//    anchors.top: parent.top
//    anchors.bottom: parent.bottom
//    anchors.leftMargin: 30 * pt
//    anchors.topMargin: 10 * pt
//    anchors.bottomMargin: 10 * pt
//    width: 100 * pt
//    model: dapChainWalletsModel
//    textRole: "name"


//    delegate: ItemDelegate {
//        width: parent.width
//        highlighted: parent.highlightedIndex === index
//    }

    indicator: Image {
        source: parent.popup.visible ? "qrc:/Resources/Icons/ic_arrow_drop_up.png" : "qrc:/Resources/Icons/ic_arrow_drop_down.png"
        width: 24 * pt
        height: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10 * pt
    }

    background: Rectangle {
        anchors.fill: parent
        color: parent.popup.visible ? "#FFFFFF" : "transparent"
    }

    contentItem: Text {
        text: parent.displayText
        font.family: "Regular"
        font.pixelSize: 14 * pt
        color: "#A7A7A7"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
