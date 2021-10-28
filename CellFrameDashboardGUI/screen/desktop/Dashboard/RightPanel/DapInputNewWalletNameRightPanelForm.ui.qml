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
                anchors.leftMargin: 29 * pt
                anchors.rightMargin: 35 * pt
                anchors.topMargin: 5 * pt
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
                anchors.leftMargin: 22 * pt
                anchors.rightMargin: 35 * pt
//                anchors.topMargin: 4 * pt
                height: 46 * pt

                nameCheckbox: qsTr("Use exsisting wallet")
                fontCheckbox: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                nameTextColor: currTheme.textColor

                checkboxOn:"qrc:/resources/icons/" + pathTheme + "/ic_checkbox_on.png"
                checkboxOff:"qrc:/resources/icons/" + pathTheme + "/ic_checkbox_off.png"

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
                anchors.top: frameChooseSignatureType.bottom
                anchors.topMargin: 12 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 18 * pt
                anchors.rightMargin: 19 * pt
                height: 42 * pt
                width: 350 * pt
                color: currTheme.backgroundElements
                DapComboBox
                {
                    id: comboBoxSignatureTypeWallet
                    model: signatureTypeWallet

                    anchors.centerIn: parent
                    anchors.fill: parent
//                    anchors.rightMargin: 10 * pt

                    comboBoxTextRole: ["name"]
                    mainLineText: "all signature"

                    indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                    indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                    sidePaddingNormal: 19 * pt
                    sidePaddingActive: 19 * pt
                    hilightColor: currTheme.buttonColorNormal

                    widthPopupComboBoxNormal: 318 * pt
                    widthPopupComboBoxActive: 318 * pt
                    heightComboBoxNormal: 24 * pt
                    heightComboBoxActive: 42 * pt
                    topEffect: false

                    normalColor: currTheme.backgroundMainScreen
                    normalTopColor: currTheme.backgroundElements
                    hilightTopColor: currTheme.backgroundMainScreen

                    paddingTopItemDelegate: 8 * pt
                    heightListElement: 42 * pt
                    indicatorWidth: 24 * pt
                    indicatorHeight: indicatorWidth
                    colorDropShadow: currTheme.shadowColor
                    roleInterval: 15
                    endRowPadding: 37

                    fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
                    colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                    colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                    alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
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
                anchors.topMargin: 19 * pt
                anchors.left: parent.left
                anchors.leftMargin: 21 * pt
                anchors.right: parent.right
                height: columnChooseRecoveryMethod.implicitHeight
                color: "transparent"

                ColumnLayout
                {
                    id: columnChooseRecoveryMethod
                    spacing: 6 * pt
                    anchors.fill: parent

                    DapRadioButton
                    {
                        id: buttonSelectionWords
                        nameRadioButton: qsTr("24 words")
                        checked: true
                        indicatorInnerSize: 46 * pt
                        spaceIndicatorText: 3 * pt
                        fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                        implicitHeight: indicatorInnerSize
                    }

                    DapRadioButton
                    {
                        id: buttonSelectionQRcode
                        nameRadioButton: qsTr("QR code")
                        indicatorInnerSize: 46 * pt
                        spaceIndicatorText: 3 * pt
                        implicitHeight: indicatorInnerSize
                        fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    }

                    DapRadioButton
                    {
                        id: buttonSelectionExportToFile
                        nameRadioButton: qsTr("Export to file")
                        indicatorInnerSize: 46 * pt
                        spaceIndicatorText: 3 * pt
                        implicitHeight: indicatorInnerSize
                        fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    }

                    DapRadioButton
                    {
                        id: buttonSelectionNothing
                        nameRadioButton: qsTr("Nothing")
                        indicatorInnerSize: 46 * pt
                        spaceIndicatorText: 3 * pt
                        implicitHeight: indicatorInnerSize
                        fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    }
                }
            }

            DapButton
            {
                id: buttonNext
                implicitHeight: 36 * pt
                implicitWidth: 132 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: frameChooseRecoveryMethod.bottom
                anchors.topMargin: 45 * pt
                textButton: qsTr("Next")
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#3E3853"
                colorButtonTextNormal: "#FFFFFF"
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }
            Rectangle
            {
                width: 320*pt
                height: 69 * pt
                color: "transparent"
                anchors.top: buttonNext.bottom
//                anchors.topMargin: 10 * pt
                anchors.left: parent.left
                anchors.right: parent.right

                Text
                {
                    id: textWalletNameWarning
                    anchors.fill: parent
                    anchors.leftMargin: 10 * pt
                    anchors.rightMargin: 10 * pt
                    color: "#79FFFA"
                    text: qsTr("Enter the wallet name using Latin letters, dotes, dashes and / or numbers.")
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    visible: false
                    anchors.bottomMargin: 10 * pt
                }
            }
        }
}
