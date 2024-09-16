import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"
import "../../controls"

DapRectangleLitAndShaded
{
    id: root

    property bool multiSigMode: false
    property alias dapModelMultiSig: modelMultiSig
    property alias dapTextHeader: textHeader
    property alias dapButtonClose: itemButtonClose
    property alias dapTextInputNameWallet: textInputNameWallet
    property alias dapComboBoxSignatureTypeWallet: comboBoxSignatureTypeWallet
    property alias dapButtonNext: buttonNext
    property alias dapWalletNameWarning: textWalletNameWarning
    property alias dapSignatureTypeWalletModel: comboBoxSignatureTypeWallet.filteredModel
    property alias dapTextInputPassword: textInputPasswordWallet

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:

        ColumnLayout{

        anchors.fill: parent
        spacing: 0
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
                text: logicWallet.restoreWalletMode ? qsTr("Import wallet") : qsTr("Create new wallet")
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

            Flickable
            {
                id: flickableContent
                contentHeight: column.implicitHeight
                contentWidth: column.implicitWidth
                flickableDirection: Flickable.VerticalFlick

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
                            placeholderText: qsTr("Input name of wallet")
                            font: mainFont.dapFont.regular16
                            horizontalAlignment: Text.AlignLeft
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.topMargin: 16
                            validator: RegExpValidator { regExp: /[0-9A-Za-z\_\-]+/ }
                            bottomLineVisible: true
                            bottomLineSpacing: 7
                            bottomLineLeftRightMargins: 7

                            selectByMouse: true
                            DapContextMenu{}
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
                            text: qsTr("Amount of signatures")
                            font: mainFont.dapFont.medium12
                            horizontalAlignment: Text.AlignLeft
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                        }

                        DapToolTipInfo
                        {
                            text.horizontalAlignment: Qt.AlignLeft
                            anchors.right: parent.right
                            anchors.rightMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            contentText: qsTr("Single Signature Wallet: This wallet requires only one signature to approve transactions.\r\n\r\nMulti Signature Wallet: This wallet requires multiple signatures to approve transactions.")
                        }
                    }

                    Rectangle
                    {
                        height: columnChooseAmountSig.implicitHeight
                        color: "transparent"
                        Layout.fillWidth: true
                        Layout.leftMargin: 23
                        Layout.topMargin: 13
                        Layout.bottomMargin: 9

                        ColumnLayout
                        {
                            id: columnChooseAmountSig
                            spacing: 10
                            anchors.fill: parent

                            DapRadioButton
                            {
                                Layout.fillWidth: true
                                nameRadioButton: qsTr("Single signature")
                                checked: true
                                indicatorInnerSize: 46
                                spaceIndicatorText: 3
                                fontRadioButton: mainFont.dapFont.regular16
                                implicitHeight: indicatorInnerSize
                                onClicked:
                                {
                                    multiSigMode = false
                                }
                            }

                            DapRadioButton
                            {
                                Layout.fillWidth: true
                                nameRadioButton: qsTr("Multi signatures")
                                indicatorInnerSize: 46
                                spaceIndicatorText: 3
                                implicitHeight: indicatorInnerSize
                                fontRadioButton: mainFont.dapFont.regular16
                                onClicked:
                                {
                                    multiSigMode = true
                                }
                            }
                        }
                    }

                    Rectangle
                    {
                        id: frameChooseSignatureType
                        color: currTheme.mainBackground
                        height: 30
                        Layout.fillWidth: true
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

                        DapToolTipInfo
                        {
                            text.horizontalAlignment: Qt.AlignLeft
                            anchors.right: parent.right
                            anchors.rightMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            contentText: qsTr("Select a cryptographic signature method to secure your transactions, including protection against quantum attacks.")
                        }
                    }

                    Rectangle
                    {
                        id: frameSignatureType
                        height: 64
                        color: "transparent"
                        Layout.fillWidth: true
                        visible: !multiSigMode


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

                    ListModel
                    {
                        id: modelMultiSig
                        ListElement
                        {
                            name: ""
                            sign: ""
                        }
                        ListElement
                        {
                            name: ""
                            sign: ""
                        }
                    }

                    Repeater
                    {
                        model: modelMultiSig
                        delegate:
                            DapCertificatesComboBox
                        {
                            Layout.maximumHeight: 42
                            Layout.fillWidth: true
                            Layout.leftMargin: 20
                            Layout.rightMargin: 20
                            Layout.topMargin: index > 0 ? 2 : 11
                            Layout.bottomMargin: index < modelMultiSig.count - 1 ? 0 : 10
                            isRestoreMode: logicWallet.restoreWalletMode
                            visible: multiSigMode
                            isNecessaryToHideCurrentIndex: true

                            onSelectedSignatureChanged:
                            {
                                modelMultiSig.set(index, {"name": displayText, "sign": filteredModel.get(currentIndex)["sign"]})
                            }

                            isHighPopup:
                            {
                                var fullHeight = root.height
                                var contentHeight = delegateHeight * (count - 1)
                                var contentY = flickableContent.contentY
                                return fullHeight - y + contentY < height + contentHeight
                            }
                        }
                    }

                    DapButtonWithImage
                    {
                        Layout.fillWidth: true
                        Layout.leftMargin: 36
                        Layout.rightMargin: 36
                        Layout.bottomMargin: addBtn.visible ? 8 : 0
                        Layout.minimumHeight: 40

                        pathImage: "qrc:/Resources/BlackTheme/icons/other/icon_circle_remove.svg"
                        buttonText: qsTr("Remove signature")
                        visible: multiSigMode && modelMultiSig.count > 2

                        onClicked:
                        {
                            modelMultiSig.remove(modelMultiSig.count-1)
                        }
                    }

                    DapButtonWithImage
                    {
                        id: addBtn
                        Layout.fillWidth: true
                        Layout.leftMargin: 36
                        Layout.rightMargin: 36
                        Layout.minimumHeight: 40

                        pathImage: "qrc:/Resources/BlackTheme/icons/other/icon_circle_add.svg"
                        buttonText: qsTr("Add signature")
                        visible: multiSigMode && modelMultiSig.count < 4

                        onClicked:
                        {
                            modelMultiSig.append({name: ""})
                        }
                    }

                    Rectangle
                    {
                        property int heightItem: 26
                        property int marginsItem: 6
                        property int marginsMainRect: 12

                        id: selectedSigRect
                        implicitHeight: selectedSigRect.marginsMainRect*2 + 2 + resultTextMultiSig.contentHeight + modelMultiSig.count * (selectedSigRect.heightItem + selectedSigRect.marginsItem) + 2
                        color: currTheme.mainBackground
                        Layout.fillWidth: true
                        Layout.leftMargin: 36
                        Layout.rightMargin: 36
                        Layout.topMargin: 20
                        radius: 4
                        visible: multiSigMode

                        Text
                        {
                            id: resultTextMultiSig
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: selectedSigRect.marginsMainRect
                            anchors.leftMargin: selectedSigRect.marginsMainRect
                            anchors.rightMargin: selectedSigRect.marginsMainRect
                            anchors.bottomMargin: 8 - selectedSigRect.marginsItem
                            color: currTheme.white
                            text: qsTr("You have selected a multi-signature\nwallet with the following signature order:")
                            font: mainFont.dapFont.regular13
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignLeft
                        }

                        Item
                        {
                            id: resultsItem
                            height: modelMultiSig.count * 32
                            anchors.top: resultTextMultiSig.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.topMargin: 11
                            anchors.leftMargin: selectedSigRect.marginsMainRect
                            anchors.rightMargin: selectedSigRect.marginsMainRect
                            anchors.bottomMargin: selectedSigRect.marginsMainRect - selectedSigRect.marginsItem

                            Repeater
                            {
                                model: modelMultiSig
                                delegate:
                                    Rectangle
                                {
                                    height: selectedSigRect.heightItem
                                    width: nameSigText.contentWidth + 6 * 2
                                    color: "transparent"
                                    border.width: 1
                                    border.color: currTheme.input
                                    radius: 2
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.topMargin: index * (selectedSigRect.heightItem + selectedSigRect.marginsItem)

                                    Text
                                    {
                                        id: nameSigText
                                        color: currTheme.white
                                        text: (index + 1) + ". " + name
                                        font: mainFont.dapFont.regular13
                                        horizontalAlignment: Text.AlignLeft
                                        anchors.centerIn: parent
                                    }
                                }
                            }
                        }
                    }

                    Rectangle
                    {
                        id: inforMsgRect
                        implicitHeight: 12 + 12 + 6 + infoHeaderText.contentHeight + infoBodyText.contentHeight + 2
                        color: "transparent"
                        radius: 4
                        Layout.fillWidth: true
                        Layout.leftMargin: 36
                        Layout.rightMargin: 36
                        Layout.topMargin: 4
                        Layout.bottomMargin: 20
                        visible: multiSigMode

                        Rectangle
                        {
                            anchors.fill: parent
                            color: currTheme.orange
                            opacity: 0.12
                            radius: 4
                        }

                        Text
                        {
                            id: infoHeaderText
                            width: parent.width - 24
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: 12
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            font: mainFont.dapFont.medium14
                            color: currTheme.orange
                            text: qsTr("Remember the order")
                        }

                        Text
                        {
                            id: infoBodyText
                            width: parent.width - 24
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            anchors.bottomMargin: 12
                            font: mainFont.dapFont.regular13
                            color: currTheme.orange
                            text: qsTr("The order of signatures is crucial. Ensure you remember and record this sequence accurately.")
                            wrapMode: Text.WordWrap
                        }
                    }


                    Rectangle
                    {
                        id: frameTypeWallet
                        color: currTheme.mainBackground
                        height: 30
                        Layout.fillWidth: true
                        Layout.topMargin: 3
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

                        DapToolTipInfo
                        {
                            text.horizontalAlignment: Qt.AlignLeft
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

                        DapToolTipInfo
                        {
                            text.horizontalAlignment: Qt.AlignLeft
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

                            validator: RegExpValidator { regExp: /[^а-яёъьА-ЯЁЪЬ\s]+/}
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
                        // height: columnChooseRecoveryMethod.implicitHeight
                        height: 103
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

                    RowLayout
                    {
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
                            text: qsTr("I understand that if I enter my password incorrectly, I will not be able to restore my wallet")
                            wrapMode: Text.WordWrap
                            MouseArea{
                                anchors.fill: parent
                                onClicked: checkBox.isChecked = !checkBox.isChecked
                            }
                        }
                    }

                    RowLayout
                    {
                        Layout.topMargin: 17
                        Layout.maximumWidth: 291
                        Layout.leftMargin: 23
                        Layout.rightMargin: 36
                        Layout.bottomMargin: 27
                        spacing: 3

                        Image
                        {
                            id: checkBox2
                            Layout.alignment: Qt.AlignTop
                            Layout.topMargin: -10
                            sourceSize.width: 46
                            sourceSize.height: 46
                            property bool isChecked: false
                            source: isChecked ? "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_on.png"
                                              : "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_off.png"

                            MouseArea{
                                anchors.fill: parent
                                onClicked: checkBox2.isChecked = !checkBox2.isChecked
                            }
                        }

                        Text
                        {
                            id: warningText2
                            Layout.fillWidth: true
                            Layout.bottomMargin: 12
                            font: mainFont.dapFont.regular14
                            color: currTheme.white
                            text: logicWallet.restoreWalletMode ? qsTr("I understand that if I enter the signatures in the wrong order, I will not be able to restore my wallet.")
                                                                : qsTr("I understand that if I forget the signature order, I will not be able to recover my wallet.")
                            wrapMode: Text.WordWrap
                            MouseArea{
                                anchors.fill: parent
                                onClicked: checkBox2.isChecked = !checkBox2.isChecked
                            }
                        }
                    }


                    Text
                    {
                        id: textWalletNameWarning
                        Layout.topMargin: 13
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
                        visible: text !== ""
                    }


                    DapButton
                    {
                        id: buttonNext
                        implicitHeight: 36
                        implicitWidth: 132
                        enabled: checkBox.isChecked && checkBox2.isChecked

                        Layout.bottomMargin: 40
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                        textButton: qsTr("Next")
                        horizontalAligmentText: Text.AlignHCenter
                        indentTextRight: 0
                        fontButton: mainFont.dapFont.medium14
                    }

                    Item
                    {
                        id: frameBottom
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Component.onCompleted:{
                        logicWallet.walletRecoveryType = "Words"
                        logicWallet.walletType = "Standart"
                        textInputPasswordWallet.text = ""
                    }
                }
            }
        }
    }
}
