import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1

import "../../"
import "../"

DapUiQmlScreen {
    property alias nextButton: nextButton
    property bool isWordsRecoveryMethodChecked: selectionWords.checked
    property bool isQRCodeRecoveryMethodChecked: selectionQRcode.checked
    property bool isExportToFileRecoveryMethodChecked: selectionExportToFile.checked

    id: addWalletMenu
    color: "#EDEFF2"

    Rectangle {
        id: nameWalletTextArea
        height: 30
        color: "#757184"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        Text {
            id: nameWalletText
            color: "#ffffff"
            text: qsTr("Name of wallet")
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 12
            horizontalAlignment: Text.AlignLeft
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
        }
    }

    Rectangle {
        id: inputNameWalletArea
        height: 68
        color: "#EDEFF2"
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.right: parent.right
        anchors.top: nameWalletTextArea.bottom

        TextInput {
            id: textInputNameWallet
            text: qsTr("Pocket of happiness")
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            font.pointSize: 16
            color: "#070023"
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
        }
    }

    Rectangle {
        id: chooseSignatureTypeTextArea
        height: 30
        color: "#757184"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: inputNameWalletArea.bottom

        Text {
            id: chooseSignatureTypeText
            color: "#ffffff"
            text: qsTr("Choose signature type")
            font.pointSize: 12
            anchors.leftMargin: 16
            horizontalAlignment: Text.AlignLeft
            font.styleName: "Normal"
            font.family: "Roboto"
            font.weight: Font.Normal
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
        }
    }

    Rectangle {
        id: chooseSignatureTypeArea
        height: 68 * pt
        color: "#EDEFF2"
        anchors.leftMargin: 1 * pt
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: chooseSignatureTypeTextArea.bottom

        ///ComboBox right panel
        Rectangle{
            id:areaDapComboBoxRightPanel
            anchors.fill: parent
            anchors.leftMargin:  16*pt
            anchors.rightMargin: 16*pt
            anchors.topMargin:12*pt
            anchors.bottomMargin: 12*pt
            color: parent.color

            DapComboBox{
                property Label fieldBalance: Label {}

                model: ListModel {
                    id: signatureType
                    ListElement {signatureName: "Dilithium"}
                    ListElement {signatureName: "Bliss"}
                    ListElement {signatureName: "Picnic"}
                    ListElement {signatureName: "Tesla"}
                }
                normalColorText: "#070023"
                hilightColorText: "#FFFFFF"
                fontSizeComboBox: 16 * pt
                hilightColor: "#330F54"
                sidePaddingNormal: 20*pt
                indicatorWidth:20 * pt
            }

        }
    }

    Rectangle {
        id: recoveryMethodTextArea
        height: 30
        color: "#757184"
        anchors.leftMargin: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: chooseSignatureTypeArea.bottom

        Text {
            id: recoveryMethodText
            color: "#ffffff"
            text: qsTr("Recovery method")
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            anchors.left: parent.left
            font.pointSize: 12
            horizontalAlignment: Text.AlignLeft
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    ColumnLayout {
        id: chooseRecoveryMethod
        height: 272
        anchors.leftMargin: 1
        spacing: 32
        anchors.top: recoveryMethodTextArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        RadioButton {
            id: selectionWords
            text: qsTr("24 words")
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.topMargin: 32
            checked: true
            spacing: 16
            autoExclusive: true
            display: AbstractButton.TextBesideIcon
            font.pointSize: 14
            font.wordSpacing: 0
            font.family: "Roboto"
            Layout.leftMargin: 16
        }

        RadioButton {
            id: selectionQRcode
            y: 120
            text: qsTr("QR code")
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.topMargin: 0
            Layout.leftMargin: 16
            spacing: 16
            font.pointSize: 14
            font.family: "Roboto"
        }

        RadioButton {
            id: selectionExportToFile
            text: qsTr("Export to file")
            spacing: 16
            font.pointSize: 14
            font.family: "Roboto"
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.topMargin: 0
            Layout.leftMargin: 16
        }

        RadioButton {
            id: selectionNothing
            y: 235
            text: qsTr("Nothing")
            spacing: 16
            checked: false
            font.family: "Roboto"
            font.pointSize: 14
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.topMargin: 0
            Layout.leftMargin: 16
        }
    }

    Button {
        id: nextButton
        height: 44
        width: 130
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: chooseRecoveryMethod.bottom
        anchors.topMargin: 32
        hoverEnabled: true

        contentItem: Text {
            id: nextButtonText
            text: qsTr("Next")
            anchors.fill: parent
            color: "#ffffff"
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            font.pointSize: 18
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }


        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            color: parent.hovered ? "#D51F5D" : "#070023"
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
