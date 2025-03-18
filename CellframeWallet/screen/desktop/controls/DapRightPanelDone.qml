import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.4
import "qrc:/widgets"

DapRectangleLitAndShaded {
    property alias headerText: textHeader.text
    property alias messageText: textMessage.text
    property alias doneButton: buttonDone
    property alias messageImage: imageMessage.source

    property string iconOk:"qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png"
    property string iconBad:"qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png"

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 34
        anchors.rightMargin: 34
        spacing: 12

        DapImageLoader
        {
            id: imageMessage
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.topMargin: 140
            innerWidth: 53
            innerHeight: 53
        }

        Text
        {
            id: textHeader
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            color: currTheme.white
            font: mainFont.dapFont.medium24
        }

        Text
        {
            id: textMessage
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: currTheme.gray
            font: mainFont.dapFont.regular16
        }

        Item
        {
            Layout.fillHeight: true
        }

        DapButton
        {
            id: buttonDone
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.bottomMargin: 40
            implicitHeight: 36
            implicitWidth: 132
            textButton: qsTr("Done")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
        }
    }
}
