import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5 as Controls
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"
import "../../controls"

Controls.Page
{
    property alias dapTextHeader: textHeader
    property alias dapButtonClose: itemButtonClose
    property alias dapTextInputNameWallet: textInputNameWallet
    property alias dapComboBoxSignatureTypeWallet: comboBoxSignatureTypeWallet
    property alias dapButtonNext: buttonNext
    property alias dapWalletNameWarning: textWalletNameWarning
    property alias dapSignatureTypeWalletModel: signatureTypeWallet
    property alias dapButtonSelectionNothing: buttonSelectionNothing

    background: Rectangle {
        color: "transparent"
    }

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

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 38 * pt

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 7 * pt
                anchors.leftMargin: 24 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImage: 20 * pt
                widthImage: 20 * pt

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
            }

            Text
            {
                id: textHeader
                text: qsTr("Create new wallet")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 52 * pt

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
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
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        Rectangle
        {
            id: frameInputNameWallet
            height: 60 * pt
            color: "transparent"
            Layout.fillWidth: true
//            Layout.topMargin: 21 * pt
//            Layout.maximumWidth: parent.width - 50 * pt
            TextField
            {
                id: textInputNameWallet
                placeholderText: qsTr("Input name of wallet")
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.margins: 10 * pt
                anchors.leftMargin: 29 * pt
//                anchors.topMargin: 17 * pt


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
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 21 * pt
                anchors.topMargin: 16 * pt
                anchors.bottomMargin: 7 * pt
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

                font: mainFont.dapFont.regular16

                defaultText: qsTr("all signature")
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
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 22 * pt
                anchors.topMargin: 16 * pt
                anchors.bottomMargin: 7 * pt
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
                    Layout.fillWidth: true
                    nameRadioButton: qsTr("24 words")
                    checked: true
                    indicatorInnerSize: 46 * pt
                    spaceIndicatorText: 3 * pt
                    fontRadioButton: mainFont.dapFont.regular16
                    implicitHeight: indicatorInnerSize
                    onClicked: logicMainApp.walletRecoveryType = "Words"
                }

//                    DapRadioButton
//                    {
//                        id: buttonSelectionQRcode
//                        nameRadioButton: qsTr("QR code")
//                        indicatorInnerSize: 46 * pt
//                        spaceIndicatorText: 3 * pt
//                        implicitHeight: indicatorInnerSize
//                        fontRadioButton: mainFont.dapFont.regular16
//                        onClicked: walletRecoveryType = "QRcode"
//                    }
                DapRadioButton
                {
                    id: buttonSelectionExportToFile
                    Layout.fillWidth: true
                    nameRadioButton: qsTr("Export to file")
                    indicatorInnerSize: 46 * pt
                    spaceIndicatorText: 3 * pt
                    implicitHeight: indicatorInnerSize
                    fontRadioButton: mainFont.dapFont.regular16
                    onClicked: logicMainApp.walletRecoveryType = "File"
                }

                DapRadioButton
                {
                    id: buttonSelectionNothing
                    Layout.fillWidth: true
                    nameRadioButton: qsTr("Nothing")
                    indicatorInnerSize: 46 * pt
                    spaceIndicatorText: 3 * pt
                    implicitHeight: indicatorInnerSize
                    fontRadioButton: mainFont.dapFont.regular16
                    onClicked: logicMainApp.walletRecoveryType = "Nothing"
                }
                Item {
                    Layout.fillHeight: true
                }
            }
        }

        DapButton
        {
            id: buttonNext
            implicitHeight: 36 * pt
            implicitWidth: 132 * pt
            Layout.topMargin: 58 * pt
//            Layout.maximumWidth: parent.width - 200 * pt
//            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            textButton: qsTr("Next")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular16
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
            font: mainFont.dapFont.regular14
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
            logicMainApp.walletRecoveryType = "Words"
    }
}
