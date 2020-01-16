import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
    dapHeaderData:
        Row
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.rightMargin: 16 * pt
            anchors.topMargin: 12 * pt
            anchors.bottomMargin: 12 * pt
            spacing: 12 * pt

            Item
            {
                id: itemButtonClose
                data: dapButtonClose
                height: dapButtonClose.height
                width: dapButtonClose.width
            }

            Text
            {
                id: textHeader
                text: qsTr("New wallet")
                font.pixelSize: 14 * pt
                color: "#3E3853"
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
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textNameWallet
                    color: "#ffffff"
                    text: qsTr("Name of wallet")
                    font.pixelSize: 12 * pt
                    horizontalAlignment: Text.AlignLeft
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }

            Rectangle
            {
                id: frameInputNameWallet
                height: 68 * pt
                color: "#F8F7FA"
                anchors.top: frameNameWallet.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                TextField
                {
                    id: textInputNameWallet
                    placeholderText: qsTr("Pocket of happiness")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 16 * pt
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    anchors.left: parent.left
                    anchors.leftMargin: 20 * pt
                    anchors.right: parent.right
                    style:
                        TextFieldStyle
                        {
                            textColor: "#070023"
                            placeholderTextColor: "#070023"
                            background:
                                Rectangle
                                {
                                    border.width: 0
                                    color: "transparent"
                                }
                        }
                }
            }

            Rectangle
            {
                id: frameChooseSignatureType
                anchors.top: frameInputNameWallet.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textChooseSignatureType
                    color: "#ffffff"
                    text: qsTr("Choose signature type")
                    font.pixelSize: 12 * pt
                    anchors.leftMargin: 16 * pt
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    font.styleName: "Normal"
                    font.family: "Roboto"
                    font.weight: Font.Normal
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle
            {
                id: frameSignatureType
                height: 68 * pt
                color: "#F8F7FA"
                anchors.top: frameChooseSignatureType.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                DapComboBox
                {
                    property Label fieldBalance: Label {}

                    model:
                        ListModel
                        {
                            id: signatureType
                            ListElement
                            {
                                signatureName: "Dilithium"
                            }
                            ListElement
                            {
                                signatureName: "Bliss"
                            }
                            ListElement
                            {
                                signatureName: "Picnic"
                            }
                            ListElement
                            {
                                signatureName: "Tesla"
                            }
                        }
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 20 * pt
                    anchors.rightMargin: 20 * pt
                    indicatorImageNormal: "qrc:/res/icons/ic_arrow_drop_down_dark.png"
                    indicatorImageActive: "qrc:/res/icons/ic_arrow_drop_up.png"
                    sidePaddingNormal: 0 * pt
                    sidePaddingActive: 0 * pt
                    normalColorText: "#070023"
                    hilightColorText: "#transparent"
                    normalColorTopText: "#070023"
                    hilightColorTopText: "#070023"
                    hilightColor: "#330F54"
                    normalTopColor: "transparent"
                    widthPopupComboBoxNormal: 148 * pt
                    widthPopupComboBoxActive: 180 * pt
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
                    indicatorLeftInterval: 8 * pt
                    colorTopNormalDropShadow: "#00000000"
                    colorDropShadow: "#40ABABAB"
                    fontComboBox.pixelSize: 16 * pt
                    fontComboBox.family: "Roboto"
                }
            }

            Rectangle
            {
                id: frameRecoveryMethod
                anchors.top: frameSignatureType.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textRecoveryMethod
                    color: "#ffffff"
                    text: qsTr("Recovery method")
                    font.pixelSize: 12 * pt
                    anchors.leftMargin: 16 * pt
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    font.styleName: "Normal"
                    font.family: "Roboto"
                    font.weight: Font.Normal
                    anchors.verticalCenter: parent.verticalCenter
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
                        fontRadioButton.pixelSize: 14 * pt
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
                        fontRadioButton.pixelSize: 14 * pt
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
                        fontRadioButton.pixelSize: 14 * pt
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
                        fontRadioButton.pixelSize: 14 * pt
                        indicatorBackgroundColor: "transparent"
                        indicatorBorder.width: 2 * pt
                    }
                }
            }

            DapButton
            {
                id: buttonNext
                height: 44 * pt
                width: 130 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: frameChooseRecoveryMethod.bottom
                anchors.topMargin: 64 * pt
                textButton: qsTr("Next")
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#070023"
                colorButtonTextNormal: "#FFFFFF"
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton.pixelSize: 18 * pt
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
