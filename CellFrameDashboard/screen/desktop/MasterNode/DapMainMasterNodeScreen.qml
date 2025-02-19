import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"
import "qrc:/"

Item
{
    property string headerText: qsTr("What is needed to set up a master node?")
    property string variableText: qsTr("At least 10000 $%1 ready for staking or at least 10 %2 (received for prior stakes in total of at least 10000 $%1)")

    anchors.margins: 16

    ListModel
    {
        id: textBlocks

        ListElement
        {
            head: qsTr("— A machine that will stay running 24/7")
            body: qsTr("A home PC, a VPS or a Raspberry Pi will be suitable.
A mechanism has been developed to track the participation of master nodes in the consensus, which takes into account inaccessible nodes at the time of voting. Despite this, your node must be online 24/7, otherwise it will not earn validators fees.")
        }

        ListElement
        {
            head: qsTr("— A public IP address")
            body: qsTr("While it is possible to use a private IP address, this will complicate the maintenance process. In the case of a private one, tracking of IP address changes will be required, as well as timely updates to the public node list. Otherwise, the node will not participate in consensus and will not earn validators fees.")
        }

        ListElement
        {
            head: qsTr("— IPv4 protocol")
            body: qsTr("The option to use an IP address with IPv6 protocol will be implemented in the future.")
        }

        ListElement
        {
            head: qsTr("— Your wallet balance must have")
            body: ""
        }
    }

    Text
    {
        id: header
        width: parent.width
        anchors.left: parent.left
        anchors.top: parent.top
        text: headerText
        font: mainFont.dapFont.medium14
        color: currTheme.white
        wrapMode: Text.WordWrap
    }

    ListView
    {
        width: parent.width
        anchors.left: parent.left
        anchors.top: header.bottom
        anchors.bottom: startMasterNode.top
        anchors.topMargin: 16
        anchors.bottomMargin: 16
        clip: true
        model: textBlocks
        spacing: 16

        delegate:
            Item
        {
            width: parent.width
            height: headText.contentHeight + 8 + bodyText.contentHeight

            Text
            {
                id: headText
                width: parent.width
                anchors.top: parent.top
                anchors.left: parent.left
                text: head
                font: mainFont.dapFont.medium12
                color: currTheme.white
                wrapMode: Text.WordWrap
            }

            Text
            {
                id: bodyText
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                text: body
                font: mainFont.dapFont.regular12
                color: currTheme.white
                wrapMode: Text.WordWrap
            }
        }
    }

    DapButton
    {
        id: startMasterNode
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        implicitHeight: 36
        textButton: qsTr("Start Master Node")
        horizontalAligmentText: Text.AlignHCenter
        indentTextRight: 0
        fontButton: mainFont.dapFont.medium14
        enabled: !nodeMasterModule.isRegistrationNode
        onClicked:
        {
            dapRightPanel.push(startMasterNodePanel)
        }
    }

    function updateText()
    {
        var currentNetwork = nodeMasterModule.currentNetwork

        if(currentNetwork === "KelVPN")
            variableText = qsTr("At least 100000 $%1 ready for staking or at least 100 %2 (received for prior stakes in total of at least 100000 $%1)")
        else
            variableText = qsTr("At least 10000 $%1 ready for staking or at least 10 %2 (received for prior stakes in total of at least 10000 $%1)")

        textBlocks.get(textBlocks.count-1).body = variableText.arg(currentMainToken).arg(currentStakeToken)
    }
}
