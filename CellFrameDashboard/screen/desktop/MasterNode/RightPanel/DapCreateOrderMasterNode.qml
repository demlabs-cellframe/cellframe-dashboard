import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"
import "../../controls"


DapRectangleLitAndShaded
{
    id: root

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42

            HeaderButtonForRightPanels
            {
                id: itemButtonClose
                height: 20
                width: 20
                heightImage: 20
                widthImage: 20
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16
                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/back.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/back_hover.svg"
                onClicked:
                {
                    dapRightPanel.pop()
                }
            }

            Text
            {
                id: textHeader
                text: qsTr("Create order")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        Rectangle
        {
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 30

            Text
            {
                color: currTheme.white
                text: qsTr("Value fee")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        Item
        {
            height: 122
            Layout.fillWidth: true

            DapFeeComponent
            {
                id: feeController
                anchors.centerIn: parent
                valueName: nodeMasterModule.mainTokenName
            }
        }

        Rectangle
        {
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 30

            Text
            {
                color: currTheme.white
                text: qsTr("Select certificatee")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }

            DapToolTipInfo
            {
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                contentText: qsTr("You must select the certificate that you created when you launched the master node.")
            }
        }

        DapCustomComboBox
        {
            id: comboboxCert
            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            rightMarginIndicator: 20
            leftMarginDisplayText: 20
            leftMarginPopupContain: 20
            rightMarginPopupContain: 20
            height: 40
            font: mainFont.dapFont.regular16
            backgroundColorShow: currTheme.secondaryBackground
            defaultText: qsTr("Certificates")
            mainTextRole: "completeBaseName"
            model: ListModel
            {
                id: certificatesModel
            }
        }

        Item { Layout.fillHeight: true }

        DapButton
        {
            textButton: qsTr("Create order")
            Layout.preferredHeight: 36
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 40
            implicitHeight: 36
            implicitWidth: 132
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            enabled: comboboxCert.displayText !== "" && comboboxCert.displayText !== comboboxCert.defaultText

            onClicked:
            {
                var fee = feeController.currentValue
                var cert = comboboxCert.displayText
                nodeMasterModule.createStakeOrderForMasterNode(fee, cert)
                dapRightPanel.pop()
            }
        }
    }

    Component.onCompleted:
    {
        logicMainApp.requestToService("DapCertificateManagerCommands", 1); // 1 - Get List Certificates
    }

    Connections
    {
        target: dapServiceController
        onCertificateManagerOperationResult:
        {
            var masterNodeCertName = nodeMasterModule.getMasterNodeCertName()
            var foundIndex = -1
            certificatesModel.clear()
            for (var i = 0; i < result.data.length; ++i)
            {
                var item = result.data[i]
                certificatesModel.append(item)
                if(item["completeBaseName"] === masterNodeCertName)
                {
                    foundIndex = i
                }
            }
            if(foundIndex >=0 )
            {
                comboboxCert.setCurrentIndex(foundIndex + 1)
            }
        }
    }

    Connections
    {
        target: nodeMasterModule
        function onCreatedStakeOrder(result)
        {
            var msg = result ? qsTr("Order created") : qsTr("Not created")
            var iconPath = result ? "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png" :
                                    "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png"
            dapMainWindow.infoItem.showInfo(
                                        0,0,
                                        dapMainWindow.width*0.5,
                                        8,
                                        msg,
                                        iconPath)
        }
    }
}


