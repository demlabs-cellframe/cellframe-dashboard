import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../controls"

Item
{
    property var modelData

    Page
    {
        id: page

        y: dapMainWindow.height + height
        width: parent.width
        hoverEnabled: true

        Behavior on y{
            NumberAnimation{
                duration: 200
            }
        }

        onVisibleChanged:
        {
            if (visible)
                y = dapMainWindow.height - height
            else
                y = dapMainWindow.height + height
        }

        height: 570

        background: Rectangle {
            color: currTheme.mainBackground
            radius: 30
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                color: currTheme.mainBackground
            }
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: currTheme.mainBackground
            }
        }

        Text
        {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16

            horizontalAlignment: Text.AlignHCenter

            font: mainFont.dapFont.bold14
            color: currTheme.white

            text: qsTr("Order overview")
        }

        Image {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 16
            z: 1

            source: area.containsMouse? "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross_hover.svg" :
                                        "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross.svg"
            mipmap: true

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    dapBottomPopup.hide()
                }
            }
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.topMargin: 35
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 0

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Side:")
                text: modelData !== undefined ? modelData.side : ""
                textColor: modelData !== undefined &&
                           modelData.side === "Buy" ?
                               currTheme.green :
                               currTheme.red
                textFont: mainFont.dapFont.regular14
            }

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Pair:")
                text: modelData !== undefined ?
                          modelData.token1+"/"+modelData.token2 : ""
                textColor: currTheme.white
                textFont: mainFont.dapFont.regular14
            }

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Type:")
                text: modelData !== undefined ? modelData.type : ""
                textColor: currTheme.white
                textFont: mainFont.dapFont.regular14
            }

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Price:")
                text: modelData !== undefined ? modelData.price : ""
                textColor: currTheme.white
                textFont: mainFont.dapFont.regular14
            }

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Amount:")
                text: modelData !== undefined ? modelData.amount : ""
                textColor: currTheme.white
                textFont: mainFont.dapFont.regular14
            }

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Total:")
                text: modelData !== undefined ? modelData.total : ""
                textColor: currTheme.white
                textFont: mainFont.dapFont.regular14
            }

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Trigger condition:")
                text: modelData !== undefined ? modelData.condition : ""
                textColor: currTheme.white
                textFont: mainFont.dapFont.regular14
            }

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Expires in:")
                text: modelData !== undefined ? modelData.expires : ""
                textColor: currTheme.white
                textFont: mainFont.dapFont.regular14
            }

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Filled:")
                text: modelData !== undefined ? modelData.filled+"%" : ""
                textColor: currTheme.white
                textFont: mainFont.dapFont.regular14
            }

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Date:")
                text: modelData !== undefined ? modelData.date : ""
                textColor: currTheme.white
                textFont: mainFont.dapFont.regular14
            }

            TwoTextBlocksStretch
            {
                Layout.fillWidth: true
                Layout.maximumHeight: 35
                label: qsTr("Status:")
                text: modelData !== undefined ? modelData.status : ""
                textColor: modelData !== undefined &&
                           modelData.status === "Filled" ?
                           "#70E6E3" :
                           "#FAC638"
                textFont: mainFont.dapFont.regular14
            }

            Item
            {
                Layout.fillHeight: true
            }
        }

    }

}

