import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

DapRightPanel
{
    property alias dapComboBoxOperation: comboBoxOperation
    property alias dapTextInputNameWallet: textInputNameWallet
    property alias dapComboBoxSignatureTypeWallet: comboBoxSignatureTypeWallet
    property alias dapButtonNext: buttonNext
    property alias dapWalletNameWarning: textWalletNameWarning
    property alias dapSignatureTypeWalletModel: signatureTypeWallet

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
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0 * pt

        Rectangle
        {
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt
            Text
            {
                color: currTheme.textColor
                text: qsTr("Operation")
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
            id: frameOperation
            height: 60 * pt
            color: "transparent"
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            DapComboBox
            {
                id: comboBoxOperation
                model: operationModel

                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 10 * pt
                anchors.leftMargin: 15 * pt

                comboBoxTextRole: ["name"]

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
            id: frameNameWallet
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt
            Text
            {
                id: textNameWallet
                color: currTheme.textColor
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
            height: 60 * pt
            color: "transparent"
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
//            Layout.maximumWidth: parent.width - 50 * pt
            TextField
            {
                id: textInputNameWallet
                placeholderText: qsTr("Input name of wallet")
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.margins: 10 * pt
                anchors.leftMargin: 25 * pt

                validator: RegExpValidator { regExp: /[0-9A-Za-z\.\-]+/ }
                style:
                    TextFieldStyle
                    {
                        textColor: currTheme.textColor
                        placeholderTextColor: currTheme.textColorGray
                        background:
                            Rectangle
                            {
                                border.width: 0
                                color: currTheme.backgroundElements
                            }
                    }
            }


        }

        Rectangle
        {
            id: frameChooseSignatureType
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Layout.fillWidth: true
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
            height: 60 * pt
//            width: 350 * pt
            color: "transparent"
            Layout.fillWidth: true
            DapComboBox
            {
                id: comboBoxSignatureTypeWallet
                model: signatureTypeWallet

                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 10 * pt
                anchors.leftMargin: 15 * pt

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
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Layout.fillWidth: true
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
            height: columnChooseRecoveryMethod.implicitHeight
            color: "transparent"
            Layout.fillWidth: true
            Layout.margins: 15 * pt

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
                    onClicked: walletRecoveryType = "Words"
                }

//                    DapRadioButton
//                    {
//                        id: buttonSelectionQRcode
//                        nameRadioButton: qsTr("QR code")
//                        indicatorInnerSize: 46 * pt
//                        spaceIndicatorText: 3 * pt
//                        implicitHeight: indicatorInnerSize
//                        fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
//                        onClicked: walletRecoveryType = "QRcode"
//                    }
                DapRadioButton
                {
                    id: buttonSelectionExportToFile
                    nameRadioButton: qsTr("Export to file")
                    indicatorInnerSize: 46 * pt
                    spaceIndicatorText: 3 * pt
                    implicitHeight: indicatorInnerSize
                    fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    onClicked: walletRecoveryType = "File"
                }

                DapRadioButton
                {
                    id: buttonSelectionNothing
                    nameRadioButton: qsTr("Nothing")
                    indicatorInnerSize: 46 * pt
                    spaceIndicatorText: 3 * pt
                    implicitHeight: indicatorInnerSize
                    fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    onClicked: walletRecoveryType = "Nothing"
                }
            }
        }

        DapButton
        {
            id: buttonNext
            implicitHeight: 36 * pt
            Layout.maximumWidth: parent.width - 200 * pt
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            textButton: qsTr("Next")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
        }

        Text
        {
            id: textWalletNameWarning
            Layout.minimumHeight: 60 * pt
            Layout.maximumHeight: 60 * pt
            Layout.margins: 0 * pt
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: parent.width - 50 * pt
            color: "#79FFFA"
            text: ""
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            visible: true
        }

        Rectangle
        {
            id: frameBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }
        Component.onCompleted:
            walletRecoveryType = "Words"
    }
}
