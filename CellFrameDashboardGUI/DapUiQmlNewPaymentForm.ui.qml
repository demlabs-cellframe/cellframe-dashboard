import QtQuick 2.12
import QtQuick.Controls 2.2
import CellFrameDashboard 1.0

Rectangle {
    id: newPayment
    width: 640
    height: 800
    border.color: "#B5B5B5"
    border.width: 1 * pt
    color: "#FFFFFF"

    anchors {
        top: parent.top
        right: parent.right
        bottom: parent.bottom
    }

    Rectangle {
        id: newPaymentTextArea
        height: 56
        color: "#FFFFFF"
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: newPaymentText
            text: qsTr("New payment")
            font.pointSize: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 13
            anchors.top: parent.top
            anchors.topMargin: 13
            anchors.left: buttonCloseNewPayment.right
            anchors.leftMargin: 12
            color: "#505559"
        }

        Button {
            id: buttonCloseNewPayment
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            anchors.left: newPaymentTextArea.left
            anchors.horizontalCenter: newPaymentTextArea.Center
            background: Image {
                source: mouseAreaCloseNewPayment.containsMouse ? "qrc:/Resources/Icons/ic_close_hover.png" : "qrc:/Resources/Icons/ic_close.png"
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: mouseAreaCloseNewPayment
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }

    Rectangle {
        id: titleFromTextArea
        height: 30
        color: "#DFE3E6"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: newPaymentTextArea.bottom
        anchors.topMargin: 0

        Text {
            id: titleFromText
            color: "#505559"
            text: qsTr("From")
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 12
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
        }
    }

    Rectangle {
        id: chooseCurrencyTypeArea
        height: 115
        color: "#FFFFFF"
        anchors.leftMargin: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleFromTextArea.bottom

        DapUiQmlWidgetSignatureTypeComboBox {
            id: comboBoxChooseCurrencyType
            height: 20 * pt
            anchors.top: parent.top
            anchors.topMargin: 26
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 34
                rightMargin: 36
            }

            model: ListModel {
                id: currencyType
                ListElement {
                    signatureName: "Kelvin"
                }
                ListElement {
                    signatureName: "Token1"
                }
                ListElement {
                    signatureName: "Token2"
                }
                ListElement {
                    signatureName: "New Gold"
                }
            }

            ToolSeparator {
                id: currencySeparator
                anchors.top: comboBoxChooseCurrencyType.bottom
                anchors.topMargin: 20 * pt
                anchors.left: comboBoxChooseCurrencyType.left
                anchors.right: comboBoxChooseCurrencyType.right
                orientation: Qt.Horizontal
                horizontal: Qt.Horizontal
            }

            Text {
                id: walletName
                color: "#B5B5B5"
                text: qsTr("brz89EWFKlkmfwk392i32300503493")
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.top: currencySeparator.bottom
                anchors.topMargin: 36
                anchors.left: currencySeparator.right
                anchors.right: currencySeparator.left
                font {
                    pointSize: 16 * pt
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:16;anchors_x:131;anchors_y:36}
}
##^##*/

