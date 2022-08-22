import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.4
import "qrc:/widgets"

Page {

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 15

        Item
        {
            implicitHeight: 100
        }

        DapImageLoader
        {
            id: imageMessage
            Layout.alignment: Qt.AlignHCenter
            innerWidth: 52
            innerHeight: 52
//            source: "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png"
        }

        Text
        {
            id: textHeader
            Layout.fillWidth: true
//            text: qsTr("Order created\nsuccessfully!")
            horizontalAlignment: Text.AlignHCenter
            color: currTheme.textColor
            font: mainFont.dapFont.medium24
        }

        Text
        {
            id: textMessage
            Layout.fillWidth: true
//            Layout.leftMargin: 20
//            Layout.rightMargin: 20
            horizontalAlignment: Text.AlignHCenter
//            text: qsTr("Click on «My orders» to view\nthe status of your order")
            wrapMode: Text.WordWrap
            color: currTheme.textColor
            font: mainFont.dapFont.regular16
        }

        Item
        {
            implicitHeight: 100
        }

        DapButton
        {
            id: buttonDone
            Layout.alignment: Qt.AlignHCenter
            implicitHeight: 36
            implicitWidth: 132
            textButton: qsTr("Done")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular16
            onClicked:
            {
                goToRightHome()
            }
        }

        Item
        {
            Layout.fillHeight: true
        }

    }

    Component.onCompleted:
    {
        if (logicStock.resultCreate.success)
//        if (false)
        {
            imageMessage.source = "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png"
            textHeader.text = qsTr("Order created\nsuccessfully!")
            textMessage.text = qsTr("Click on «My orders» to view\nthe status of your order")
        }
        else
        {
            imageMessage.source = "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png"
            textHeader.text = qsTr("Order creation\nerror!")
//            textMessage.text = qsTr("Error message...")
            textMessage.text = qsTr(logicStock.resultCreate.message)
        }
    }
}
