import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../controls"

DapRectangleLitAndShaded
{
    id: mainItem

    property string parameterName: ""
    property alias parameterValue: textInput.text

    property bool node: true
    property string networkName: ""
    property string groupName: ""
    property string valueName: ""

    signal confirm()

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
            headerName: parameterName + qsTr(" to listen on")
        }

        HeaderItem
        {
            headerName: qsTr("Input ") + parameterName.toLowerCase()
        }

        DapTextField
        {
            id: textInput
            Layout.fillWidth: true
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            Layout.topMargin: 16
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            font: mainFont.dapFont.regular16
            horizontalAlignment: Text.AlignRight

            validator: RegExpValidator { regExp: /[0-9\.]+/ }

            borderWidth: 1
            borderRadius: 3
            selectByMouse: true
            DapContextMenu{}
        }

        Item
        {
            Layout.fillHeight: true
        }

        DapButton
        {
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 10
            Layout.bottomMargin: 40
            implicitHeight: 36
            implicitWidth: 162

            textButton: qsTr("Confirm")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14

            onClicked:
            {
                if (node)
                    configWorker.writeNodeValue(
                        groupName, valueName, textInput.text)
                else
                    configWorker.writeConfigValue(networkName,
                        groupName, valueName, textInput.text)

                root.dapRightPanel.pop()

                mainItem.confirm()
            }
        }

    }

}
