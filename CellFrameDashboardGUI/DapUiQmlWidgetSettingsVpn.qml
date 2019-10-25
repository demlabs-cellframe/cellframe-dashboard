import QtQuick 2.4

DapUiQmlWidgetSettingsVpnForm {
    Column {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 15 * pt
        anchors.topMargin: 13 * pt
        spacing: 15 * pt

        DapUiQmlWidgetSettingsVpnComboBox {
            id: comboBoxBand
            width: 150 * pt
            height: 32 * pt
            textRole: "band"
            model: ListModel {
                ListElement {band: "100 Mbit" }
                ListElement {band: "200 Mbit" }
            }
        }

        DapUiQmlWidgetSettingsVpnComboBox {
            id: comboBoxUptime
            width: 150 * pt
            height: 32 * pt
            textRole: "uptime"
            model: ListModel {
                ListElement {uptime: "30 minutes" }
                ListElement {uptime: "3 hours" }
            }
        }

        DapUiQmlWidgetSettingsVpnComboBox {
            id: comboBoxEncription
            width: 150 * pt
            height: 32 * pt
            textRole: "encription"
            model: ListModel {
                ListElement {encription: "RSA-2048" }
                ListElement {encription: "AES-256" }
            }
        }

        DapUiQmlWidgetSettingsVpnComboBox {
            id: comboBoxBalance
            width: 150 * pt
            height: 32 * pt
            textRole: "balance"
            model: ListModel {
                ListElement {balance: "320 RUB" }
                ListElement {balance: "500 RUB" }
            }
        }

        DapUiQmlWidgetSettingsVpnComboBox {
            id: comboBoxLanguage
            width: 150 * pt
            height: 32 * pt
            textRole: "language"
            model: ListModel {
                ListElement {language: "RUS" }
                ListElement {language: "ENG" }
            }
        }
    }

}
