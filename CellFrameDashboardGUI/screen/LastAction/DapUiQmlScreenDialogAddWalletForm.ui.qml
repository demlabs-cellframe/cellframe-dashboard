import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1
import "../"

DapUiQmlScreen {
    property alias nextButton: nextButton
    property bool isWordsRecoveryMethodChecked: selectionWords.checked
    property bool isQRCodeRecoveryMethodChecked: selectionQRcode.checked
    property bool isExportToFileRecoveryMethodChecked: selectionExportToFile.checked

    id: addWalletMenu
    color: "#F8F7FA"
    border.width: 1 * pt
    border.color: "#E3E2E6"

    Rectangle {
        id: nameWalletTextArea
        height: 30 * pt
        color: "#757184"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        Text {
            id: nameWalletText
            color: "#ffffff"
            text: qsTr("Name of wallet")
            anchors.left: parent.left
            anchors.leftMargin: 16 * pt
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12 * pt
            horizontalAlignment: Text.AlignLeft
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
        }
    }

    Rectangle {
        id: inputNameWalletArea
        height: 68 * pt
        color: "#F8F7FA"
        anchors.left: parent.left
        anchors.leftMargin: 1 * pt
        anchors.right: parent.right
        anchors.top: nameWalletTextArea.bottom

        TextInput {
            id: textInputNameWallet
            text: qsTr("Pocket of happiness")
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20 * pt
            font.pixelSize: 16 * pt
            color: "#070023"
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
        }
    }

    Rectangle {
        id: chooseSignatureTypeTextArea
        height: 30 * pt
        color: "#757184"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 1 * pt
        anchors.top: inputNameWalletArea.bottom

        Text {
            id: chooseSignatureTypeText
            color: "#ffffff"
            text: qsTr("Choose signature type")
            font.pixelSize: 12 * pt
            anchors.leftMargin: 16 * pt
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
        color: "#F8F7FA"
        anchors.leftMargin: 1 * pt
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: chooseSignatureTypeTextArea.bottom
    }

    Rectangle {
        id: recoveryMethodTextArea
        height: 30 * pt
        color: "#757184"
        anchors.leftMargin: 1 * pt
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
            font.pixelSize: 12 * pt
            horizontalAlignment: Text.AlignLeft
            anchors.leftMargin: 16 * pt
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    ColumnLayout {
        id: chooseRecoveryMethod
        height: 272 * pt
        spacing: 32 * pt
        anchors.top: recoveryMethodTextArea.bottom
        anchors.topMargin: 32 * pt
        anchors.left: parent.left
        anchors.leftMargin: 16 * pt
        anchors.right: parent.right
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop

        DapRadioButton {
            id: selectionWords
            textButton: qsTr("24 words")
            checked: true
        }

        DapRadioButton {
            id: selectionQRcode
            textButton: qsTr("QR code")
        }

        DapRadioButton {
            id: selectionExportToFile
            textButton: qsTr("Export to file")
        }

        DapRadioButton {
            id: selectionNothing
            textButton: qsTr("Nothing")
        }
    }

    Button {
        id: nextButton
        height: 44 * pt
        width: 130 * pt
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: chooseRecoveryMethod.bottom
        anchors.topMargin: 32 * pt
        hoverEnabled: true

        contentItem: Text {
            id: nextButtonText
            text: qsTr("Next")
            anchors.fill: parent
            color: "#ffffff"
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            font.pixelSize: 18 * pt
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

