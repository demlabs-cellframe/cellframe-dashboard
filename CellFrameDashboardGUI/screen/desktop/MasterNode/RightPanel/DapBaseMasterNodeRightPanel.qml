import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"
import "../../controls"
import "../../Settings/NodeSettings"

Rectangle
{
    property bool isMasterNode: nodeMasterModule.isMasterNode

    id: root

    color: currTheme.mainBackground

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Text
        {
            Layout.fillWidth: true
            font: mainFont.dapFont.medium14
            color: currTheme.white
            text: qsTr("Actions")
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            Layout.topMargin: 4
            textButton: qsTr("Import an existing wallet")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular14
            onClicked:
            {
            }
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            textButton: qsTr("Import certificate")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular14
            onClicked:
            {
            }
        }


        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            textButton: qsTr("Add service")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular14
            visible: isMasterNode
            onClicked:
            {
            }
        }

        Text
        {
            Layout.fillWidth: true
            Layout.topMargin: 12
            font: mainFont.dapFont.medium14
            color: currTheme.white
            text: qsTr("Validator Actions")
            visible: isMasterNode
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            Layout.topMargin: 4
            textButton: qsTr("Last Actions")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular14
            visible: isMasterNode
            onClicked:
            {
            }
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            textButton: qsTr("Orders")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular14
            visible: isMasterNode
            onClicked:
            {
            }
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            textButton: qsTr("Blocks")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular14
            visible: isMasterNode
            onClicked:
            {
            }
        }

        DapButton
        {
            implicitHeight: 36
            Layout.fillWidth: true
            textButton: qsTr("Config")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular14
            visible: isMasterNode
            onClicked:
            {
            }
        }

        Item { Layout.fillHeight: true }

    }

    Component.onCompleted:
    {

    }

    Component.onDestruction:
    {

    }
}



