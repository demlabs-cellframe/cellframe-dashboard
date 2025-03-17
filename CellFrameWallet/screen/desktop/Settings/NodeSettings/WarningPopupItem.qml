import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../controls"

DapRectangleLitAndShaded
{
    id: mainItem

    signal closed()
    signal save()
    signal reset()

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
//        anchors.leftMargin: 34
//        anchors.rightMargin: 34
        spacing: 0

        PageHeaderItem
        {
            headerName: qsTr("Are you sure?")
        }

        Text
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20

            text: qsTr(
"Are you sure you want to change the node settings? After saving the settings, the node will be rebooted.")
            color: currTheme.gray
            font: mainFont.dapFont.regular15

            wrapMode: Text.WordWrap

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        DapButton
        {
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 10
            Layout.bottomMargin: 40
            implicitHeight: 36
            implicitWidth: 162

            textButton: qsTr("Save changes")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14

            onClicked:
            {
                root.dapRightPanel.pop()
                mainItem.save()
            }
        }

    }

}

