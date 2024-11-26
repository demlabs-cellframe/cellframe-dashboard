import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "../../controls"
import "qrc:/widgets"

import "qrc:/screen"

ColumnLayout
{
    id:control
    anchors.fill: parent

    spacing: 0


    Item
    {
        Layout.fillWidth: true
        height: 42

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Support")
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        height: 30
        color: currTheme.mainBackground

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Telegram channel")
        }
    }

    Item {
        id: tgFrame
        property string tgLink: "https://t.me/cellframetechsupport"
        Layout.fillWidth: true
        height: 50

        RowLayout
        {
            anchors.fill: parent

            Text
            {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.leftMargin: 24

                font: mainFont.dapFont.regular16
                color: area.containsMouse ? currTheme.lime
                                          : currTheme.white
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Cellframe support")
            }

            Image
            {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.rightMargin: 24

                source: area.containsMouse ? "qrc:/Resources/BlackTheme/icons/other/icon_linkHover.svg"
                                           : "qrc:/Resources/BlackTheme/icons/other/icon_link.svg"
                mipmap: true
            }
        }

        DapCustomToolTip{
            contentText: tgFrame.tgLink
        }

        MouseArea{
            id: area
            anchors.fill: parent
            hoverEnabled: true
            onClicked: Qt.openUrlExternally(tgFrame.tgLink)
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        height: 30
        color: currTheme.mainBackground

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Contact form")
        }
    }

    ColumnLayout{
        property string bugreportLink: "https://cellframe.net/feedback-form/"
        id: bugreportBlock
        Layout.fillWidth: true
        spacing: 12

        Text
        {
            Layout.topMargin: 22
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.leftMargin: 24

            font: mainFont.dapFont.regular16
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Have a question/found a bug?")
        }

        DapButton{
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            Layout.bottomMargin: 22
            Layout.minimumHeight: 26
            Layout.maximumHeight: 26

            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter
            textButton: qsTr("Contact us")

            onClicked: Qt.openUrlExternally(bugreportBlock.bugreportLink)

            DapCustomToolTip{
                contentText: qsTr("Contact us")
            }
        }
    }
}
