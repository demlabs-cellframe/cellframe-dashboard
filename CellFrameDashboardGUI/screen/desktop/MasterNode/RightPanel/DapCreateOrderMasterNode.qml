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
        }

        DapCustomComboBox
        {
            id: comboboxCert
            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.leftMargin: 36
            Layout.rightMargin: 36
            leftMarginDisplayText: 0
            rightMarginIndicator: 0
            popupBorderWidth: 1
            changingRound: true
            isSingleColor: true
            isInnerShadow: false
            isNecessaryToHideCurrentIndex: true
            displayTextPopupColor: currTheme.white
            implicitHeight: 24
            backgroundColorShow: currTheme.secondaryBackground
            backgroundColorNormal: currTheme.secondaryBackground
            font: mainFont.dapFont.regular16
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
            for (var i = 0; i < result.data.length; ++i)
            {
                var item = result.data[i]
                var nameCert = item.completeBaseName
                var networkCurr = nodeMasterModule.currentNetwork
                if(item.accessKeyType !== 0 && !item.completeBaseName.startsWith(networkCurr))
                    continue
                certificatesModel.append(item)
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


