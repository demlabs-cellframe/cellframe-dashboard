import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "qrc:/widgets"

Item
{
    height: 36+32

    CreateOrderLogic
    {
        id: createLogic
    }

//    property alias createLogic: createOrderLogic

    CreateOrderItem
    {
        id: createItem
        visible: false
    }

    RowLayout
    {
        anchors.fill: parent
        anchors.margins: 16

        spacing: 16

        DapButton
        {
            Layout.fillWidth: true

            Layout.minimumHeight: 36
            Layout.maximumHeight: 36

            textButton: qsTr("Buy")

            implicitHeight: 36
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            defaultColorNormal0: currTheme.green
            defaultColorNormal1: currTheme.green
            defaultColorHovered0: currTheme.greenHover
            defaultColorHovered1: currTheme.greenHover

            onClicked:
            {
                createItem.isSell = false
                dapBottomPopup.show(createItem)
            }
        }

        DapButton
        {
            Layout.fillWidth: true

            Layout.minimumHeight: 36
            Layout.maximumHeight: 36

            textButton: qsTr("Sell")

            implicitHeight: 36
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            defaultColorNormal0: currTheme.red
            defaultColorNormal1: currTheme.red
            defaultColorHovered0: currTheme.redHover
            defaultColorHovered1: currTheme.redHover

            onClicked:
            {
                createItem.isSell = true
                dapBottomPopup.show(createItem)
            }
        }
    }
}
