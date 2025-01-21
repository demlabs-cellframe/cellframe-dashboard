import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import "qrc:/widgets"
import "../../../"
import "../../controls"
import "../../Settings/NodeSettings"


DapRectangleLitAndShaded
{
    id: root

    property string certificateLogic: "newCertificate"
    property bool isUpload: false
    property var messageRectColor: currTheme.orange

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    Item
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 42

        HeaderButtonForRightPanels
        {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 16

            id: itemButtonClose
            height: 20
            width: 20
            heightImage: 20
            widthImage: 20

            normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
            hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"

            onClicked: dapRightPanel.push(baseMasterNodePanel)
        }

        Text
        {
            id: textHeader
            text: qsTr("Start master node")
            verticalAlignment: Qt.AlignLeft
            anchors.left: itemButtonClose.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10

            font: mainFont.dapFont.bold14
            color: currTheme.white
        }
    }
    contentData:
    ScrollView
    {
        id: scrollView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 42

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        clip: true

        contentData:
            ColumnLayout
        {
//            anchors.fill: parent
            width: scrollView.width
            spacing: 0

            /// Certificate
            Rectangle
            {
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 30
                Text
                {
                    color: currTheme.white
                    text: qsTr("Certificate")
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            ListModel
            {
                id: typeCreateCerificateModel

                ListElement
                {
                    name: qsTr("Create new certificate")
                    techName: "newCertificate"
                }
                ListElement
                {
                    name: qsTr("Upload certificate")
                    techName: "uploadCertificate"
                }
                ListElement
                {
                    name: qsTr("Select existing certificate")
                    techName: "existingCertificate"
                }
            }

            DapCustomComboBox
            {
                id: newCertificateCombobox
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 25
                Layout.topMargin: 8
                Layout.bottomMargin: 8
                height: 40
                font: mainFont.dapFont.regular16
                backgroundColorShow: currTheme.secondaryBackground
                model: typeCreateCerificateModel
                onCurrentIndexChanged:
                {
                    certificateLogic = typeCreateCerificateModel.get(currentIndex).techName
                }
            }

            /// Create new certificate
            Rectangle
            {
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 30
                Text
                {
                    color: currTheme.white
                    text: certificateLogic === "existingCertificate" ? qsTr("Select existing certificate") : qsTr("Create new certificate")
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            Rectangle
            {
                id: newCertRect
                Layout.fillWidth: true
                height: 113
                color: currTheme.secondaryBackground

                visible: certificateLogic === "newCertificate"

                DapTextField
                {
                    id: newCertificateName
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 30
                    anchors.rightMargin: 30
                    anchors.topMargin: 10
                    placeholderText: qsTr("Enter certificate name")
                    height: 30

                    validator: RegExpValidator { regExp: /[0-9A-Za-z\_\:\(\)\?\@\.\-]+/ }
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignLeft

                    bottomLineVisible: true
                    bottomLineSpacing: 5
                    bottomLineLeftRightMargins: 7

                    selectByMouse: true
                    DapContextMenu{}
                }

                DapCertificatesComboBox
                {
                    id: typeCertificateCombobox
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 20
                    anchors.rightMargin: 25
                    anchors.bottomMargin: 10
                    height: 40
                    font: mainFont.dapFont.regular16
                    backgroundColorShow: currTheme.secondaryBackground
                }
                Component.onCompleted:
                {

                }

            }

            Rectangle
            {
                id: uploadCertRect
                Layout.fillWidth: true
                height: 146
                color: currTheme.secondaryBackground
                visible: certificateLogic === "uploadCertificate"
                RowLayout
                {
                    id: certLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 36
                    anchors.rightMargin: 36
                    anchors.topMargin: 20
                    height: 15

                    Text
                    {
                        color: currTheme.gray
                        text: qsTr("Certificate")
                        font: mainFont.dapFont.regular12
                        horizontalAlignment: Text.AlignLeft
                        Layout.alignment: Qt.AlignLeft

                    }

                    Text
                    {
                        id: certificateName
                        color: currTheme.white
                        text: nodeMasterModule.certName
                        font: mainFont.dapFont.regular13
                        horizontalAlignment: Text.AlignRight
                        Layout.alignment: Qt.AlignRight
                    }
                }

                RowLayout
                {
                    id: sigLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: certLayout.bottom
                    anchors.leftMargin: 36
                    anchors.rightMargin: 36
                    height: 15
                    anchors.topMargin: 16

                    Text
                    {
                        color: currTheme.gray
                        text: qsTr("Signature")
                        font: mainFont.dapFont.regular12
                        horizontalAlignment: Text.AlignLeft
                        Layout.alignment: Qt.AlignLeft

                    }

                    Text
                    {
                        id: signatureName
                        color: currTheme.white
                        text: nodeMasterModule.signature
                        font: mainFont.dapFont.regular13
                        horizontalAlignment: Text.AlignRight
                        Layout.alignment: Qt.AlignRight
                    }
                }

                DapButtonWithImage
                {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 36
                    anchors.rightMargin: 36
                    anchors.bottomMargin: 20
                    height: 40
                    pathImage: !isUpload ? "qrc:/Resources/BlackTheme/icons/other/upload_icon.svg" : "qrc:/Resources/BlackTheme/icons/other/detach_icon.svg"
                    buttonText: !isUpload ? qsTr("Upload certificate") : qsTr("Unpin certificate")

                    onClicked:
                    {
                        fileDialog.updateFilter()
                        if(!isUpload)
                        {
                            fileDialog.open()
                        }
                        else
                        {
                            nodeMasterModule.clearCertificate();
                            isUpload = false;
                        }
                        console.log("upload certificate clicked")
                    }
                }
            }

            FileDialog
            {
                id: fileDialog
                folder: shortcuts.home
                onAccepted:
                {
                    console.log("File: ", fileUrl)
                    if(nodeMasterModule.tryGetInfoCertificate(fileUrl)) isUpload = true
                    else isUpload = false
                }

                Component.onCompleted:
                {
                    updateFilter()
                }

                function updateFilter()
                {
                    var filter = "Certifiacates (" + nodeMasterModule.currentNetwork.toLowerCase() + ".*.dcert)"
                    fileDialog.nameFilters = [filter]
                }
            }

            DapCustomComboBox
            {
                id: existCertificateCombobox
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.topMargin: 8
                Layout.bottomMargin: 8
                rightMarginIndicator: 20
                leftMarginDisplayText: 20
                leftMarginPopupContain: 20
                rightMarginPopupContain: 20
                height: 40
                font: mainFont.dapFont.regular16
                backgroundColorShow: currTheme.secondaryBackground
                defaultText: qsTr("Certificates")
                mainTextRole: "completeBaseName"
                visible: certificateLogic === "existingCertificate"
                model: ListModel
                {
                    id: certificatesModel
                }
            }

            /// Wallet
            Rectangle
            {
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 30
                Text
                {
                    color: currTheme.white
                    text: qsTr("Wallet")
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            DapWalletComboBox
            {
                id: comboBoxCurrentWallet

                Layout.fillWidth: true
                Layout.leftMargin: 25
                Layout.rightMargin: 25
                Layout.topMargin: 8
                Layout.bottomMargin: 8
                height: 40
                displayText: walletModule.currentWalletName
                font: mainFont.dapFont.regular16

                model: walletModelList

                enabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_activate.svg"
                disabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_deactivate.svg"
                backgroundColorShow: currTheme.secondaryBackground
                Component.onCompleted:
                {
                    setCurrentIndex(walletModule.currentWalletIndex)
                    displayText = walletModule.currentWalletName
                }

                defaultText: qsTr("Wallets")
            }

            /// Fee value
            Rectangle
            {
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 30
                Text
                {
                    color: currTheme.white
                    text: qsTr("Fee value")
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            Item
            {
                Layout.fillWidth: true
                height: 122

                DapFeeComponent
                {
                    id: feeController
                    anchors.centerIn: parent
                    valueName: nodeMasterModule.mainTokenName
                }
            }

            /// Node IP
            Rectangle
            {
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 0 //30
                visible: false
                Text
                {
                    color: currTheme.white
                    text: qsTr("Node IP")
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            Item
            {
                Layout.fillWidth: true
                Layout.leftMargin: 30
                Layout.rightMargin: 35
                height: 0 //69
                visible: false
                DapTextField
                {
                    id: nodeIpText
                    width: parent.width
                    height: 29
                    anchors.top: parent.top
                    anchors.topMargin: 16

                    validator: RegExpValidator { regExp: /^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$/ }
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignLeft

                    bottomLineVisible: true
                    bottomLineSpacing: 3
                    bottomLineLeftRightMargins: 7
                    text: "127.0.0.1"
                    selectByMouse: true
                    DapContextMenu{}
                }
            }

            /// Node port
            Rectangle
            {
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 0 //30
                visible: false
                Text
                {
                    color: currTheme.white
                    text: qsTr("Node port")
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            Item
            {
                Layout.fillWidth: true
                Layout.leftMargin: 30
                Layout.rightMargin: 35
                height: 0 //69
                visible: false
                DapTextField
                {
                    id: nodePortText
                    width: parent.width
                    height: 29
                    anchors.top: parent.top
                    anchors.topMargin: 16

                    validator: RegExpValidator { regExp: /^(\d{1,5})$/ }
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignLeft

                    bottomLineVisible: true
                    bottomLineSpacing: 3
                    bottomLineLeftRightMargins: 7
                    text: "8079"
                    selectByMouse: true
                    DapContextMenu{}
                }
            }

            /// Stake value
            Rectangle
            {
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 30
                Text
                {
                    id: stakeValueHeaderText
                    color: currTheme.white
                    text: qsTr("Stake value")
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }

                DapBalanceComponent
                {
                    id: textBalance
                    height: 16
                    anchors.left: stakeValueHeaderText.right
                    anchors.top: parent.top
                    anchors.right: stakeInfoIcon.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                    label: qsTr("Balance:")
                    textColor: currTheme.white
                    textFont: mainFont.dapFont.regular11
                    text: walletModule.getTokenBalance(nodeMasterModule.currentNetwork, nodeMasterModule.stakeTokenName, walletModule.currentWalletName)
                }

                Image
                {
                    id: stakeInfoIcon
                    visible: false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    height: 16
                    width: 0 //16
                    mipmap: true
                    source: "qrc:/Resources/BlackTheme/icons/other/ic_infoGray.svg"
                }
            }

            RowLayout
            {
                Layout.fillWidth: true
                Layout.leftMargin: 36
                Layout.rightMargin: 36
                Layout.topMargin: 20
                spacing: 32
                DapTextField
                {
                    property string realAmount: "0.00"
                    property string abtAmount: "0.00"

                    id: textInputStakeValue

                    width: 171
                    Layout.minimumHeight: 40
                    Layout.maximumHeight: 40
                    text: "10.0"
                    validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignRight
                    borderWidth: 1
                    borderRadius: 4
                    selectByMouse: true
                    DapContextMenu{}
                }

                Text
                {
                    id: textInputStakeToken
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    text: nodeMasterModule.stakeTokenName
                    color: currTheme.white
                    font: mainFont.dapFont.regular16

                }
            }

            // Error message
            Item
            {
                id: errorMsgRect
                implicitHeight: textError.implicitHeight + 24
                Layout.fillWidth: true
                Layout.leftMargin: 35
                Layout.rightMargin: 35
                Layout.topMargin: 20
                visible: false
                Rectangle
                {

                    anchors.fill: parent
                    color: "transparent"
                    radius: 4
                    border.width: 1
                    border.color: messageRectColor
                }

                Rectangle
                {
                    anchors.fill: parent
                    color: messageRectColor
                    opacity: 0.12
                    radius: 4
                }

                Text
                {
                    id: textError
                    width: errorMsgRect.width
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 12
                    font: mainFont.dapFont.regular11
                    color: currTheme.orange
                    wrapMode: Text.WordWrap
                    lineHeight: 16
                    lineHeightMode: Text.FixedHeight
                }
            }

            // Button "Start Master Node"
            DapButton
            {
                id: buttonStartMasterNode

                implicitHeight: 36
                Layout.fillWidth: true
                Layout.leftMargin: 93
                Layout.rightMargin: 93
                Layout.topMargin: 40
                Layout.bottomMargin: 40
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                textButton: "Start Master Node"

                onClicked:
                {
                    var certPath = certificateLogic === "existingCertificate" ? certificatesModel.get(existCertificateCombobox.currentIndex)["filePath"] : ""
                    var result = {
                        "certLogic" : certificateLogic,
                        "certPath" : certPath,
                        "isUploadCert" : certificateLogic !== "newCertificate",
                        "certName" : certificateLogic === "newCertificate" ? newCertificateName.text : certificateLogic === "uploadCertificate" ? certificateName.text : existCertificateCombobox.displayText,
                        "sign" : certificateLogic === "newCertificate" ? typeCertificateCombobox.selectedSignature : certificateLogic === "uploadCertificate" ? signatureName.text : "",
                        "walletName" : walletModule.currentWalletName,
                        "walletAddress" : walletModule.getAddressWallet(nodeMasterModule.currentNetwork, walletModule.currentWalletName),
                        "network" : nodeMasterModule.currentNetwork,
                        "fee" : feeController.currentValue,
                        "feeToken" : feeController.valueName,
                        "nodeIP" : nodeIpText.text,
                        "port" : nodePortText.text,
                        "stakeValue" : textInputStakeValue.text,
                        "stakeToken" : textInputStakeToken.text,
                        "stakeFee": walletModule.getFee(nodeMasterModule.currentNetwork).validator_fee
                    }
                    var message = ""
                    var walletBalance = walletModule.getTokenBalance(nodeMasterModule.currentNetwork, nodeMasterModule.stakeTokenName, walletModule.currentWalletName)

                    if(certificateLogic === "existingCertificate" && certPath === "")
                    {
                        message = qsTr("There is no path to the certificate.")
                        updateErrorField(message)
                        return
                    }

                    var diffNeedValue = dexModule.diffNumber(textInputStakeValue.text, "10.0")
                    if (diffNeedValue === 0)
                    {
                        message = qsTr("The specified value is less than the minimum required.")
                        updateErrorField(message)
                        return
                    }

                    diffNeedValue = dexModule.diffNumber(walletBalance, textInputStakeValue.text)
                    if (diffNeedValue === 0)
                    {
                        message = qsTr("There are fewer funds on the balance sheet than indicated.")
                        updateErrorField(message)
                        return
                    }
                  
                    var startInfo = nodeMasterModule.startMasterNode(result)

                    if(startInfo > 0)
                    {

                        switch(startInfo) {
                            case 1:
                                message = qsTr("The previous master node has not been registered yet.")
                                updateErrorField(message)
                                break
                            case 2:
                                message = qsTr("The certificate name is not specified correctly")
                                updateErrorField(message)
                                break
                            case 3:
                                message = qsTr("There is no path to the certificate.")
                                updateErrorField(message)
                                break
                            default:
                                break
                        }
                    }
                }
            }
        }

    }

    Component.onCompleted:
    {
        logicMainApp.requestToService("DapCertificateManagerCommands", 1); // 1 - Get List Certificates
        defaultNewCertificateName()
    }
    
    Component.onDestruction:
    {
        nodeMasterModule.clearCertificate();
    }

    Connections
    {
        target: walletModule

        function onCurrentWalletChanged()
        {
            textBalance.text = walletModule.getTokenBalance(nodeMasterModule.currentNetwork, nodeMasterModule.stakeTokenName, walletModule.currentWalletName)
        }
    }

    Connections
    {
        target: dapServiceController
        function onCertificateManagerOperationResult(rcvData)
        {
            var foundIndex = 0
            var certNameFromStartMasterNode = nodeMasterModule.certNameFromStartMasterNode
            certificatesModel.clear()
            for (var i = 0; i < rcvData.data.length; ++i)
            {
                var item = rcvData.data[i]
                if(item.completeBaseName === certNameFromStartMasterNode) foundIndex = i

                certificatesModel.append(item)
            }
            if(rcvData.data.length > 0)
            {
                existCertificateCombobox.setCurrentIndex(foundIndex)
            }
        }
    }

    function defaultNewCertificateName()
    {
        newCertificateName.text = nodeMasterModule.currentNetwork.toLowerCase() + "."
    }
    
    function updateErrorField(message)
    {
        messageRectColor = currTheme.red
        errorMsgRect.visible = true
        textError.text = message
    }
}



