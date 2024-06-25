import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"
import "../../controls"
import "../../Settings/NodeSettings"


DapRectangleLitAndShaded
{
    id: root

    property string certificateLogic: "newCertificate"
    property bool isUpload: false

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

        HeaderButtonForRightPanels{
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
            spacing: 20

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
                    font: mainFont.dapFont.medium12
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
            }

            DapCustomComboBox
            {
                id: newCertificateCombobox
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 25
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
                    text: qsTr("Create new certificate")
                    font: mainFont.dapFont.medium12
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
                height: 90
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
                    height: 30

                    validator: RegExpValidator { regExp: /[0-9a-z\_\:\(\)\?\@\.\s*]+/ }
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignLeft

                    bottomLineVisible: true
                    bottomLineSpacing: 6
                    bottomLineLeftRightMargins: 7

                    selectByMouse: true
                    DapContextMenu{}
                }

                DapCertificatesComboBox{
                    id: typeCertificateCombobox
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: newCertificateName.bottom
                    anchors.leftMargin: 20
                    anchors.rightMargin: 25
                    anchors.topMargin: 20
                    height: 40
                    font: mainFont.dapFont.regular16
                    backgroundColorShow: currTheme.secondaryBackground
                }
            }

            Rectangle
            {
                id: uploadCertRect
                Layout.fillWidth: true
                height: 110
                color: currTheme.secondaryBackground
                visible: certificateLogic !== "newCertificate"
                RowLayout
                {
                    id: certLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 36
                    anchors.rightMargin: 36
                    height: 15
                    anchors.topMargin: 0

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
                        text: "-"
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
                    anchors.topMargin: 20

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
                        text: "-"
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
                    height: 40
                    pathImage: !isUpload ? "qrc:/Resources/BlackTheme/icons/other/upload_icon.svg" : "qrc:/Resources/BlackTheme/icons/other/detach_icon.svg"
                    buttonText: !isUpload ? qsTr("Upload certificate") : qsTr("Unpin certificate")

                    onClicked:
                    {
                        isUpload = !isUpload
                        console.log("upload certificate clicked")
                    }
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
                    font: mainFont.dapFont.medium12
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
                height: 40
                displayText: walletModule.currentWalletName
                font: mainFont.dapFont.regular14

                model: walletModelList

                enabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_activate.svg"
                disabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_deactivate.svg"
                backgroundColorShow: currTheme.secondaryBackground
                Component.onCompleted:
                {

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
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            DapFeeComponent
            {
                id: feeController

                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
            }

            /// Node IP
            Rectangle
            {
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 30
                Text
                {
                    color: currTheme.white
                    text: qsTr("Node IP")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            DapTextField
            {
                id: nodeIpText
                Layout.fillWidth: true
                Layout.leftMargin: 30
                Layout.rightMargin: 35
                Layout.bottomMargin: 4
                height: 29

                validator: RegExpValidator { regExp: /^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$/ }
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft

                bottomLineVisible: true
                bottomLineSpacing: 6
                bottomLineLeftRightMargins: 7
                text: "127.0.0.1"
                selectByMouse: true
                DapContextMenu{}
            }

            /// Node port
            Rectangle
            {
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 30
                Text
                {
                    color: currTheme.white
                    text: qsTr("Node port")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            DapTextField
            {
                id: nodePortText
                Layout.fillWidth: true
                Layout.leftMargin: 30
                Layout.rightMargin: 35
                Layout.bottomMargin: 4
                height: 29

                validator: RegExpValidator { regExp: /^(\d{1,5})$/ }
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft

                bottomLineVisible: true
                bottomLineSpacing: 6
                bottomLineLeftRightMargins: 7
                text: "8079"
                selectByMouse: true
                DapContextMenu{}
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
                    font: mainFont.dapFont.medium12
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
                    text: walletModule.getBalanceDEX(dexModule.token1)
                }

                Image
                {
                    id: stakeInfoIcon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    height: 16
                    width: 16
                    mipmap: true
                    source: "qrc:/Resources/BlackTheme/icons/other/ic_infoGray.svg"
                }
            }

            RowLayout
            {
                Layout.fillWidth: true
                Layout.leftMargin: 36
                Layout.rightMargin: 36
                spacing: 32
                DapTextField
                {
                    property string realAmount: "0.00"
                    property string abtAmount: "0.00"

                    id: textInputStakeValue

                    width: 171
                    Layout.minimumHeight: 40
                    Layout.maximumHeight: 40
                    placeholderText: "0.0"
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
                    text: "-"
                    color: currTheme.white
                    font: mainFont.dapFont.regular16

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

                Layout.bottomMargin: 40
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                textButton: "Start Master Node"

                onClicked:
                {
                    var result = {
                        "isUploadCert" : false, //certificateLogic !== "newCertificate",
                        "certName" : nodeMasterModule.currentNetwork +".test11",// certificateLogic !== "newCertificate" ? certificateName.text : newCertificateName.text,
                        "sign" : "sig_dil",//certificateLogic !== "newCertificate" ? signatureName.text : typeCertificateCombobox.displayText,
                        "walletName" : walletModule.currentWalletName,
                        "walletAddress" : walletModule.getAddressWallet(nodeMasterModule.currentNetwork, walletModule.currentWalletName),
                        "network" : nodeMasterModule.currentNetwork,
                        "fee" : feeController.currentValue,
                        "feeToken" : feeController.valueName,
                        "nodeIP" : nodeIpText.text,
                        "port" : nodePortText.text,
                        "stakeValue" : "10.0",//textInputStakeValue.text,
                        "stakeToken" : textInputStakeToken.text,
                        "stakeFee": walletModule.getFee(nodeMasterModule.currentNetwork).validator_fee
                    }

                    nodeMasterModule.startMasterNode(result)
                    dapRightPanel.push(loaderMasterNodePanel)
                }
            }
        }

    }

    Component.onCompleted:
    {
        walletModule.startUpdateFee()
    }
    Component.onDestruction:
    {
        walletModule.stopUpdateFee()
    }
}



