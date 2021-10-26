import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

DapRightPanel
{
    property alias dapTextInputNameWallet: textInputNameWallet
    property alias dapComboBoxSignatureTypeWallet: comboBoxSignatureTypeWallet
    property alias dapButtonNext: buttonNext
    property alias dapWalletNameWarning: textWalletNameWarning
    property alias dapSignatureTypeWalletModel: signatureTypeWallet

    dapNextRightPanel: doneWallet
    dapPreviousRightPanel: lastActionsWallet

    width: 400 * pt

    ListModel
    {
        id: signatureTypeWallet
        ListElement
        {
            name: "Dilithium"
            sign: "sig_dil"
        }
        ListElement
        {
            name: "Bliss"
            sign: "sig_bliss"
        }
        ListElement
        {
            name: "Picnic"
            sign: " sig_picnic"
        }
        ListElement
        {
            name: "Tesla"
            sign: " sig_tesla"
        }
    }

    dapHeaderData:
        Item
        {
            anchors.fill: parent
            Item
            {
                id: itemButtonClose
                data: dapButtonClose
                height: dapButtonClose.height
                width: dapButtonClose.width
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 11 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 22 * pt
                anchors.rightMargin: 13 * pt
            }

            Text
            {
                id: textHeader
                text: qsTr("New wallet")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 50 * pt

                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
            }
        }

    dapContentItemData:
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"

            Rectangle
            {
                id: frameNameWallet
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textNameWallet
                    color: "#ffffff"
                    text: qsTr("Name of wallet")
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                }
            }

            Rectangle
            {
                id: frameInputNameWallet
                height: 41 * pt
                color: "transparent"
                anchors.top: frameNameWallet.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 35 * pt
                anchors.rightMargin: 35 * pt
                TextField
                {
                    id: textInputNameWallet
                    placeholderText: qsTr("Input name of wallet")
                    anchors.verticalCenter: parent.verticalCenter
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    horizontalAlignment: Text.AlignLeft
                    anchors.left: parent.left
                    anchors.right: parent.right

                    validator: RegExpValidator { regExp: /[0-9A-Za-z\.\-]+/ }
                    style:
                        TextFieldStyle
                        {
                            textColor: currTheme.textColor
                            placeholderTextColor: currTheme.textColor
                            background:
                                Rectangle
                                {
                                    border.width: 0
                                    color: currTheme.backgroundElements
                                }
                        }
                }


            }
            DapCheckBox
            {
                id: buttonUseExestingWallet
                anchors.top: frameInputNameWallet.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 28 * pt
                anchors.rightMargin: 35 * pt
                anchors.topMargin: 4 * pt
                height: 46 * pt

                nameCheckbox: qsTr("Use exsisting wallet")
                fontCheckbox: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                nameTextColor: currTheme.textColor

                checkboxOn:"qrc:/resources/icons/BlackTheme/ic_checkbox_on.png"
                checkboxOff:"qrc:/resources/icons/BlackTheme/ic_checkbox_off.png"

                indicatorInnerSize: 46 * pt
            }


            Rectangle
            {
                id: frameChooseSignatureType
                anchors.top: buttonUseExestingWallet.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textChooseSignatureType
                    color: currTheme.textColor
                    text: qsTr("Choose signature type")
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                }
            }

            Rectangle
            {
                id: frameSignatureType
                height: 68 * pt
                color: "transparent"
                anchors.top: frameChooseSignatureType.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                DapComboBox
                {
                    id: comboBoxSignatureTypeWallet
                    model: signatureTypeWallet
                    comboBoxTextRole: ["name"]
                    mainLineText: "all signature"
                    anchors.centerIn: parent
                    indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark.png"
                    indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up.png"
                    sidePaddingNormal: 0 * pt
                    sidePaddingActive: 20 * pt
                    normalColorText: "#070023"
                    hilightColorText: "#FFFFFF"
                    normalColorTopText: "#070023"
                    hilightColorTopText: "#070023"
                    hilightColor: "#330F54"
                    normalTopColor: "transparent"
                    widthPopupComboBoxNormal: 328 * pt
                    widthPopupComboBoxActive: 368 * pt
                    heightComboBoxNormal: 24 * pt
                    heightComboBoxActive: 44 * pt
                    bottomIntervalListElement: 8 * pt
                    topEffect: false
                    x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
                    normalColor: "#FFFFFF"
                    hilightTopColor: normalColor
                    paddingTopItemDelegate: 8 * pt
                    heightListElement: 32 * pt
                    intervalListElement: 10 * pt
                    indicatorWidth: 20 * pt
                    indicatorHeight: indicatorWidth
                    indicatorLeftInterval: 20 * pt
                    colorTopNormalDropShadow: "#00000000"
                    colorDropShadow: "#40ABABAB"
                    fontComboBox: [dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14]
                    colorMainTextComboBox: [["#070023", "#070023"]]
                    colorTextComboBox: [["#070023", "#FFFFFF"]]
                }
            }

            Rectangle
            {
                id: frameRecoveryMethod
                anchors.top: frameSignatureType.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textRecoveryMethod
                    color: currTheme.textColor
                    text: qsTr("Recovery method")
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                }
            }

            Rectangle
            {
                id: frameChooseRecoveryMethod
                anchors.top: frameRecoveryMethod.bottom
                anchors.topMargin: 32 * pt
                anchors.left: parent.left
                anchors.leftMargin: 16 * pt
                anchors.right: parent.right
                height: columnChooseRecoveryMethod.implicitHeight
                color: "transparent"

                ColumnLayout
                {
                    id: columnChooseRecoveryMethod
                    spacing: 32 * pt
                    anchors.fill: parent
                    anchors.leftMargin: 16 * pt

                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                    DapRadioButton
                    {
                        id: buttonSelectionWords
                        nameRadioButton: qsTr("24 words")
                        checked: true
                        indicatorSize: 20 * pt
                        indicatorInnerSize: 10 * pt
                        spaceIndicatorText: 16 * pt
                        fontRadioButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                        indicatorBackgroundColor: "transparent"
                        indicatorBorder.width: 2 * pt
                    }

                    DapRadioButton
                    {
                        id: buttonSelectionQRcode
                        nameRadioButton: qsTr("QR code")
                        indicatorSize: 20 * pt
                        indicatorInnerSize: 10 * pt
                        spaceIndicatorText: 16 * pt
                        fontRadioButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                        indicatorBackgroundColor: "transparent"
                        indicatorBorder.width: 2 * pt
                    }

                    DapRadioButton
                    {
                        id: buttonSelectionExportToFile
                        nameRadioButton: qsTr("Export to file")
                        indicatorSize: 20 * pt
                        indicatorInnerSize: 10 * pt
                        spaceIndicatorText: 16 * pt
                        fontRadioButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                        indicatorBackgroundColor: "transparent"
                        indicatorBorder.width: 2 * pt
                    }

                    DapRadioButton
                    {
                        id: buttonSelectionNothing
                        nameRadioButton: qsTr("Nothing")
                        indicatorSize: 20 * pt
                        indicatorInnerSize: 10 * pt
                        spaceIndicatorText: 16 * pt
                        fontRadioButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                        indicatorBackgroundColor: "transparent"
                        indicatorBorder.width: 2 * pt
                    }
                }
            }

            DapButton
            {
                id: buttonNext
                implicitHeight: 44 * pt
                implicitWidth: 130 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: frameChooseRecoveryMethod.bottom
                anchors.topMargin: 40 * pt
                textButton: qsTr("Next")
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#3E3853"
                colorButtonTextNormal: "#FFFFFF"
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular18
            }

            Text
            {
                id: textWalletNameWarning
                anchors.top: buttonNext.bottom
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16 * pt
                anchors.right: parent.right
                anchors.rightMargin: 16 * pt
                anchors.topMargin: 20 * pt
                width: parent.width - 32 * pt
                color: "#ff2020"
                text: qsTr("Enter the wallet name using Latin letters, dotes, dashes and / or numbers.")
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                visible: false
            }

            Rectangle
            {
                id: frameBottom
                height: 124 * pt
                anchors.top: buttonNext.bottom
                anchors.topMargin: 24 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "transparent"
            }
        }
}
