import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"
import "../../controls"

DapRectangleLitAndShaded
{
    property alias dapTextHeader: textHeader
    property alias dapButtonClose: itemButtonClose
    property alias dapTextInputNameWallet: textInputNameWallet
    property alias dapComboBoxSignatureTypeWallet: comboBoxSignatureTypeWallet
    property alias dapButtonNext: buttonNext
    property alias dapWalletNameWarning: textWalletNameWarning
    property alias dapSignatureTypeWalletModel: signatureTypeWallet
    property alias dapTextInputPassword: textInputPasswordWallet

    color: currTheme.backgroundElements
    radius: currTheme.radiusRectangle
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight


    ListModel
    {
        id: signatureTypeWallet
        ListElement
        {
            name: "Dilithium"
            sign: "sig_dil"
            secondname: "Recommended"
        }
        ListElement
        {
            name: "Bliss"
            sign: "sig_bliss"
            secondname: ""
        }
        ListElement
        {
            name: "Picnic"
            sign: " sig_picnic"
            secondname: ""
        }
    }

    contentData:

    ColumnLayout{

        anchors.fill: parent

        Item
        {
            Layout.fillWidth: true
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
                text: qsTr("Create new wallet")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }

        ScrollView
        {
            id: scrollView

            Layout.fillHeight: true
            Layout.fillWidth: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
//            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            clip: true

            contentData:
            ColumnLayout
            {
                id: column
                width: Math.max(implicitWidth, scrollView.availableWidth)
                spacing: 0



                Rectangle
                {
                    id: frameNameWallet
                    color: currTheme.backgroundMainScreen
                    Layout.fillWidth: true
                    height: 30
                    Text
                    {
                        id: textNameWallet
                        color: currTheme.textColor
                        text: qsTr("Name of wallet")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 28
                    Layout.rightMargin: 28
                    height: 69
                    color: "transparent"

                    DapTextField
                    {
                        id: textInputNameWallet
                        anchors.verticalCenter: parent.verticalCenter
                        placeholderText: qsTr("Input name of wallet")
                        font: mainFont.dapFont.regular16
                        horizontalAlignment: Text.AlignLeft
                        anchors.fill: parent
                        anchors.topMargin: 20
                        anchors.bottomMargin: 20

//                        validator: RegExpValidator { regExp: /[0-9A-Za-z\_\:\(\)\?\@\s*]+/ }
                        validator: RegExpValidator { regExp: /[0-9A-Za-z\_\-*]+/ }
                        bottomLineVisible: true
                        bottomLineSpacing: 6
                        bottomLineLeftRightMargins: 7
                    }
                }

                Rectangle
                {
                    id: frameChooseSignatureType
                    color: currTheme.backgroundMainScreen
                    height: 30
                    Layout.fillWidth: true
        //            Layout.topMargin: 20
                    Text
                    {
                        id: textChooseSignatureType
                        color: currTheme.textColor
                        text: qsTr("Choose signature type")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }
                }

                Rectangle
                {
                    id: frameSignatureType
                    height: 60
        //            width: 350
                    color: "transparent"
                    Layout.fillWidth: true
                    DapCustomComboBox
                    {
                        id: comboBoxSignatureTypeWallet
                        model: signatureTypeWallet

                        anchors.centerIn: parent
                        anchors.fill: parent
                        anchors.margins: 10
                        anchors.leftMargin: 22
                        anchors.rightMargin: 18

                        font: mainFont.dapFont.regular16

                        defaultText: qsTr("all signature")
                    }
                }

                Rectangle
                {
                    id: frameTypeWallet
                    color: currTheme.backgroundMainScreen
                    height: 30
                    Layout.fillWidth: true
                    Text
                    {
                        id: textTypeWallet
                        color: currTheme.textColor
                        text: qsTr("Type of wallet")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }

                    DapToolTipInfo{
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        contentText: qsTr("A protected wallet differs from a standard wallet by having a password to access the wallet.")
                    }
                }

                Rectangle
                {
                    id: frameChooseTypeWallet
                    height: columnChooseTypeWallet.implicitHeight
                    color: "transparent"
                    Layout.fillWidth: true
                    Layout.leftMargin: 23
                    Layout.topMargin: 13

                    ColumnLayout
                    {
                        id: columnChooseTypeWallet
                        spacing: 10
                        anchors.fill: parent

                        DapRadioButton
                        {
                            id: buttonSelectionStandart
                            Layout.fillWidth: true
                            nameRadioButton: qsTr("Standard")
                            checked: true
                            indicatorInnerSize: 46
                            spaceIndicatorText: 3
                            fontRadioButton: mainFont.dapFont.regular16
                            implicitHeight: indicatorInnerSize
                            onClicked:
                            {
                                logicMainApp.walletType = "Standard"
                                frameWalletPassword.visible = false
                            }
                        }

                        DapRadioButton
                        {
                            id: buttonSelectionProtected
                            Layout.fillWidth: true
                            nameRadioButton: qsTr("Protected")
                            indicatorInnerSize: 46
                            spaceIndicatorText: 3
                            implicitHeight: indicatorInnerSize
                            fontRadioButton: mainFont.dapFont.regular16
                            onClicked:{
                                logicMainApp.walletType = "Protected"
                                frameWalletPassword.visible = true
                            }
                        }
                    }
                }

                Rectangle
                {
                    id: frameWalletPassword
                    color: currTheme.backgroundMainScreen
                    height: 30
                    Layout.fillWidth: true
                    visible: false
                    Layout.topMargin: 13
                    Text
                    {
                        id: textWalletPassword
                        color: currTheme.textColor
                        text: qsTr("Wallet password")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }

                    DapToolTipInfo{
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        contentText: !logicMainApp.restoreWalletMode? qsTr("Remember the password for further activation of the wallet"):
                                    qsTr("If you enter the password incorrectly, a new wallet will be created. To gain access to a protected wallet, you must enter the correct password")

                    }
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 28
                    Layout.rightMargin: 28
                    height: 69
                    color: "transparent"
                    visible: frameWalletPassword.visible

                    DapTextField
                    {
                        id: textInputPasswordWallet

                        echoMode: indicator.isActive ? TextInput.Normal : TextInput.Password


                        anchors.verticalCenter: parent.verticalCenter
                        placeholderText: qsTr("Password")
                        font: mainFont.dapFont.regular16
                        horizontalAlignment: Text.AlignLeft
                        anchors.fill: parent
                        anchors.leftMargin: echoMode === TextInput.Password && length ? 6 : 0
                        anchors.topMargin: 20
                        anchors.bottomMargin: 20
                        anchors.rightMargin: 24

                        validator: RegExpValidator { regExp: /[^а-яёъьА-ЯЁЪЬ\s\-]+/}
//                        validator: RegExpValidator { regExp: /[0-9A-Za-z\_\:\(\)\?\@\{\}\%\<\>\,\.\*\;\:\'\"\[\]\/\?\"\|\\\^\&\*\!\$\#]+/ }
                        bottomLineVisible: true
                        bottomLineSpacing: 6

                        bottomLine.anchors.leftMargin: echoMode === TextInput.Password && length ? 1 : 7
                        bottomLine.anchors.rightMargin: -24
                        indicator.anchors.rightMargin: -24

                        indicatorVisible: true
                        indicatorSourceDisabled: "qrc:/Resources/BlackTheme/icons/other/icon_eyeHide.svg"
                        indicatorSourceEnabled: "qrc:/Resources/BlackTheme/icons/other/icon_eyeShow.svg"
                        indicatorSourceDisabledHover: "qrc:/Resources/BlackTheme/icons/other/icon_eyeHideHover.svg"
                        indicatorSourceEnabledHover: "qrc:/Resources/BlackTheme/icons/other/icon_eyeShowHover.svg"
                    }
                }

                Rectangle
                {
                    id: frameRecoveryMethod
                    color: currTheme.backgroundMainScreen
                    height: 30
                    Layout.topMargin: frameWalletPassword.visible ? 0 : 13
                    Layout.fillWidth: true
                    Text
                    {
                        id: textRecoveryMethod
                        color: currTheme.textColor
                        text: qsTr("Recovery method")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }
                }

                Rectangle
                {
                    id: frameChooseRecoveryMethod
                    height: columnChooseRecoveryMethod.implicitHeight
                    color: "transparent"
                    Layout.fillWidth: true
        //            Layout.margins: 15
                    Layout.leftMargin: 23
                    Layout.topMargin: 13

                    ColumnLayout
                    {
                        id: columnChooseRecoveryMethod
                        spacing: 10
                        anchors.fill: parent

                        DapRadioButton
                        {
                            id: buttonSelectionWords
                            Layout.fillWidth: true
                            nameRadioButton: qsTr("24 words")
                            checked: true
                            indicatorInnerSize: 46
                            spaceIndicatorText: 3
                            fontRadioButton: mainFont.dapFont.regular16
                            implicitHeight: indicatorInnerSize
                            onClicked: logicMainApp.walletRecoveryType = "Words"
                        }

                        DapRadioButton
                        {
                            id: buttonSelectionExportToFile
                            Layout.fillWidth: true
                            nameRadioButton: logicMainApp.restoreWalletMode ? qsTr("Import from file") : qsTr("Export to file")
                            indicatorInnerSize: 46
                            spaceIndicatorText: 3
                            implicitHeight: indicatorInnerSize
                            fontRadioButton: mainFont.dapFont.regular16
                            onClicked: logicMainApp.walletRecoveryType = "File"
                        }
                        Item {
                            Layout.fillHeight: true
                        }
                    }
                }

                Item
                {
                    id: frameBottom
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Text
                {
                    id: textWalletNameWarning

                    Layout.minimumHeight: 40
                    Layout.maximumHeight: 40
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Layout.bottomMargin: 12
                    Layout.maximumWidth: 281
                    color: "#79FFFA"
                    text: ""
                    font: mainFont.dapFont.regular14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    visible: true
                }

                DapButton
                {
                    id: buttonNext
                    implicitHeight: 36
                    implicitWidth: 132

                    Layout.bottomMargin: 40
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    textButton: qsTr("Next")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14
                }

                Component.onCompleted:{
                    logicMainApp.walletRecoveryType = "Words"
                    logicMainApp.walletType = "Standart"
                    textInputPasswordWallet.text = ""
                }
            }
        }
    }
}
