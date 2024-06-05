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
            spacing: 16

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

            DapCustomComboBox
            {
                id: newCertificateCombobox
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                height: 42
                font: mainFont.dapFont.regular14
                backgroundColorShow: currTheme.secondaryBackground
                //            meodel: dexTokenModel

                //            mainTextRole: "tokenName"

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

            DapTextField
            {
                id: newCertificateName
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                height: 42

                validator: RegExpValidator { regExp: /[0-9A-Za-z]+/ }
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft

                bottomLineVisible: true
                bottomLineSpacing: 6
                bottomLineLeftRightMargins: 7

                selectByMouse: true
                DapContextMenu{}
            }

            DapCustomComboBox{
                id: typeCertificateCombobox
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                height: 42
                font: mainFont.dapFont.regular14
                backgroundColorShow: currTheme.secondaryBackground

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
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                height: 42
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


            /// Stake value
            Rectangle
            {
                Layout.fillWidth: true
                color: currTheme.mainBackground
                height: 30
                Text
                {
                    color: currTheme.white
                    text: qsTr("Stake value")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                }
            }

            RowLayout
            {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                DapTextField
                {
                    property string realAmount: "0.00"
                    property string abtAmount: "0.00"

                    id: textInputStakeValue
                    Layout.fillWidth: true
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

                Rectangle
                {
                    id: frameSenderWalletToken
                    color: "transparent"
                    height: 42
                    width: 125
                    Layout.leftMargin: 5
                    Layout.rightMargin: 0
                    Text
                    {
                        id: comboboxToken
                        anchors.fill: parent
                        text: "-"

                        font: mainFont.dapFont.regular16

                    }
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

                Text
                {

                }
            }
        }


    }
}



