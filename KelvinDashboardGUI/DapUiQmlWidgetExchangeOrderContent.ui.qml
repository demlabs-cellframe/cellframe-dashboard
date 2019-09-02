import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    property string contentFont: ""
    width: childrenRect.width
    height: childrenRect.height

    ColumnLayout {
        spacing: 16 * pt

        Repeater {
            model: [qsTr("Ammount"), qsTr("Price"), qsTr("Total"), qsTr("Fee (0.2%)"), qsTr("Total+Fee")]
            RowLayout {
                spacing: 0
                Rectangle {
                    height: childrenRect.height
                    width: 120 * pt

                    Text {
                        text: modelData
                        color: "#ACACAF"
                        font.family: contentFont
                        font.pixelSize: 12 * pt
                    }
                }


                Rectangle {
                    width: 130 * pt
                    height: 22 * pt
                    border.width: 1 * pt
                    border.color: "#B0B1B5"

                    TextInput {
                        id: currencyTextInput
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: textCurrency.left
                        anchors.leftMargin: 6 * pt
                        anchors.rightMargin: 6 * pt
                        color: readOnly ? "#ACACAF" : "#737880"
                        font.family: contentFont
                        font.pixelSize: 12 * pt
                        verticalAlignment: Qt.AlignVCenter
                        validator: RegExpValidator{ regExp: /\d+/ }
                        clip: true
                        readOnly: index === 3 || index === 4
                        text: readOnly ? "0" : ""
                    }

                    Text {
                        id: textCurrency
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 6 * pt
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: currencyTextInput.readOnly ? "#ACACAF" : "#737880"
                        font.family: fontExchange.name
                        font.pixelSize: 12 * pt
                        text: index === 0 ? currencyName : "USD"
                    }
                }
            }
        }
    }

}
