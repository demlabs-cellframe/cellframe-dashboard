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
    property alias dapSignatureTypeWalletModel: comboBoxSignatureTypeWallet.filteredModel
    property alias dapTextInputPassword: textInputPasswordWallet
    property alias dapTextInputPasswordConfirmWallet: textInputPasswordConfirmWallet

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

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
                text: logicWallet.restoreWalletMode ? qsTr("Restore wallet") : qsTr("Create new wallet")
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

            Layout.fillHeight: true
            Layout.fillWidth: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
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
                    color: currTheme.mainBackground
                    Layout.fillWidth: true
                    height: 30
                    Text
                    {
                        id: textNameWallet
                        color: currTheme.white
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
                        validator: RegExpValidator { regExp: /[0-9A-Za-z\_\-]+/ }
                        bottomLineVisible: true
                        bottomLineSpacing: 6
                        bottomLineLeftRightMargins: 7

                        selectByMouse: true
                        DapContextMenu{}
                    }
                }

                Rectangle
                {
                    id: frameChooseSignatureType
                    color: currTheme.mainBackground
                    height: 30
                    Layout.fillWidth: true
        //            Layout.topMargin: 20
                    Text
                    {
                        id: textChooseSignatureType
                        color: currTheme.white
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

                    DapCertificatesComboBox
                    {
                        id: comboBoxSignatureTypeWallet
                        anchors.fill: parent
                        anchors.margins: 10
                        anchors.leftMargin: 22
                        anchors.rightMargin: 18
                        isRestoreMode: logicWallet.restoreWalletMode
                    }
                }

                Rectangle
                {
                    id: frameTypeWallet
                    color: currTheme.mainBackground
                    height: 30
                    Layout.fillWidth: true
                    Text
                    {
                        id: textTypeWallet
                        color: currTheme.white
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
                                logicWallet.walletType = "Standard"
                                frameWalletPassword.visible = false
                                textInputPasswordWallet.text = ""
                                textInputPasswordConfirmWallet.text = ""
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
                                logicWallet.walletType = "Protected"
                                frameWalletPassword.visible = true
                            }
                        }
                    }
                }

                Rectangle
                {
                    id: frameWalletPassword
                    color: currTheme.mainBackground
                    height: 30
                    Layout.fillWidth: true
                    visible: false
                    Layout.topMargin: 13
                    Text
                    {
                        id: textWalletPassword
                        color: currTheme.white
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
                        contentText: !logicWallet.restoreWalletMode? qsTr("Remember the password for further activation of the wallet"):
                                    qsTr("If you enter the password incorrectly, a new wallet will be created. To gain access to a protected wallet, you must enter the correct password")

                    }
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 28
                    Layout.rightMargin: 36
                    height: 55
                    color: "transparent"
                    visible: frameWalletPassword.visible

                    DapTextField
                    {
                        id: textInputPasswordWallet
                        placeholderText: qsTr("Password")

                        font: mainFont.dapFont.regular16
                        horizontalAlignment: Text.AlignLeft
                        validator: RegExpValidator { regExp: /[^а-яёъьА-ЯЁЪЬ\s]+/}
                        echoMode: indicator.isActive ? TextInput.Normal : TextInput.Password
                        passwordChar: "•"
                        height: 26
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: 17
                        bottomLineVisible: true
                        bottomLineSpacing: 5
                        bottomLine.anchors.leftMargin: 8
                        bottomLine.anchors.rightMargin: 0
                        indicatorTopMargin: 2
                        indicatorVisible: true
                        indicatorSourceDisabled: "qrc:/Resources/BlackTheme/icons/other/icon_eyeHide.svg"
                        indicatorSourceEnabled: "qrc:/Resources/BlackTheme/icons/other/icon_eyeShow.svg"
                        indicatorSourceDisabledHover: "qrc:/Resources/BlackTheme/icons/other/icon_eyeHideHover.svg"
                        indicatorSourceEnabledHover: "qrc:/Resources/BlackTheme/icons/other/icon_eyeShowHover.svg"
                        selectByMouse: true
                        DapContextMenu{isActiveCopy: false}
                    }
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 28
                    Layout.rightMargin: 36
                    height: 64
                    color: "transparent"
                    visible: frameWalletPassword.visible

                    DapTextField
                    {
                        id: textInputPasswordConfirmWallet
                        placeholderText: qsTr("Password (Confirmation)")
                        font: mainFont.dapFont.regular16
                        horizontalAlignment: Text.AlignLeft
                        validator: RegExpValidator { regExp: /[^а-яёъьА-ЯЁЪЬ\s]+/}
                        echoMode: indicator.isActive ? TextInput.Normal : TextInput.Password
                        passwordChar: "•"
                        height: 26
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: 11
                        bottomLineVisible: true
                        bottomLineSpacing: 5
                        bottomLine.anchors.leftMargin: 8
                        bottomLine.anchors.rightMargin: 0
                        indicatorTopMargin: 2
                        indicatorVisible: true
                        indicatorSourceDisabled: "qrc:/Resources/BlackTheme/icons/other/icon_eyeHide.svg"
                        indicatorSourceEnabled: "qrc:/Resources/BlackTheme/icons/other/icon_eyeShow.svg"
                        indicatorSourceDisabledHover: "qrc:/Resources/BlackTheme/icons/other/icon_eyeHideHover.svg"
                        indicatorSourceEnabledHover: "qrc:/Resources/BlackTheme/icons/other/icon_eyeShowHover.svg"
                        selectByMouse: true
                        DapContextMenu{isActiveCopy: false}
                    }
                }

                Rectangle
                {
                    id: frameRecoveryMethod
                    color: currTheme.mainBackground
                    height: 30
                    Layout.topMargin: frameWalletPassword.visible ? 0 : 13
                    Layout.fillWidth: true
                    Text
                    {
                        id: textRecoveryMethod
                        color: currTheme.white
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
                            onClicked: logicWallet.walletRecoveryType = "Words"
                        }

                        DapRadioButton
                        {
                            id: buttonSelectionExportToFile
                            Layout.fillWidth: true
                            nameRadioButton: logicWallet.restoreWalletMode ? qsTr("Import from file") : qsTr("Export to file")
                            indicatorInnerSize: 46
                            spaceIndicatorText: 3
                            implicitHeight: indicatorInnerSize
                            fontRadioButton: mainFont.dapFont.regular16
                            onClicked: logicWallet.walletRecoveryType = "File"
                        }
                        Item {
                            Layout.fillHeight: true
                        }
                    }
                }

                Rectangle
                {
                    color: currTheme.mainBackground
                    height: 30
                    Layout.topMargin: 13
                    Layout.fillWidth: true
                    Text
                    {
                        color: currTheme.white
                        text: qsTr("Reminder")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }
                }

                RowLayout{
                    Layout.topMargin: 23
                    Layout.maximumWidth: 291
                    Layout.leftMargin: 23
                    Layout.rightMargin: 36
                    spacing: 3

                    Image
                    {
                        id: checkBox
                        Layout.alignment: Qt.AlignTop
                        Layout.topMargin: -10
                        sourceSize.width: 46
                        sourceSize.height: 46
                        property bool isChecked: false
                        source: isChecked ? "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_on.png"
                                          : "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_off.png"

                        MouseArea{
                            anchors.fill: parent
                            onClicked: checkBox.isChecked = !checkBox.isChecked
                        }
                    }

                    Text
                    {
                        id: warningText
                        Layout.fillWidth: true
                        font: mainFont.dapFont.regular14
                        color: currTheme.white
                        text: logicWallet.restoreWalletMode ? qsTr("I understand that if I enter my\npassword incorrectly, I will not be\nable to restore my wallet")
                                                            : qsTr("I understand that if I lose my\npassword, I will not be able to restore \nmy wallet")
                        wrapMode: Text.WordWrap
                        MouseArea{
                            anchors.fill: parent
                            onClicked: checkBox.isChecked = !checkBox.isChecked
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

                    Layout.minimumHeight: 64
                    Layout.maximumHeight: 64
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Layout.bottomMargin: 12
                    Layout.maximumWidth: 281
                    color: currTheme.neon
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
                    enabled: checkBox.isChecked

                    Layout.bottomMargin: 40
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    textButton: qsTr("Next")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14
                }

                Component.onCompleted:{
                    logicWallet.walletRecoveryType = "Words"
                    logicWallet.walletType = "Standart"
                    textInputPasswordWallet.text = ""
                    textInputPasswordConfirmWallet.text = ""
                }
            }
        }
    }
}
