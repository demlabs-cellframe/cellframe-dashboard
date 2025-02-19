import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets"
import "../controls"
import "logic"

DapBottomScreen{
    property var model: selectedTX.get(0)

    heightForm: 492
    header.text: qsTr("Transaction details")

    LogicTxExplorer
    {
        id: logicExplorer
    }

    dataItem:
    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 16
        anchors.bottomMargin: 0

        spacing: 20

        TextDetailsTx {
            Layout.topMargin: 16
            title.text: qsTr("Network")
            content.text: model.network
            title.color: currTheme.gray
        }
        TextDetailsTx {
            title.text: qsTr("Hash")
            content.text: model.tx_hash
            title.color: currTheme.gray
            copyButton.visible: true
            copyButton.popupText: qsTr("Hash copied")
        }
        TextDetailsTx {

            title.text: qsTr("State")
            title.color: currTheme.gray
            content.text: logicExplorer.getTxStatusName(model.tx_status)
            content.color: logicExplorer.getTxStatusColor(model.tx_status)
//            content.text: model.tx_status
//            content.color: model.tx_status === "DECLINED" ?
//                                   currTheme.textColorRed :
//                                   currTheme.textColorLightGreen
        }
        TextDetailsTx {
            title.text: qsTr("Value")
            content.text: model.value + " " + model.token
            title.color: currTheme.gray
        }
        TextDetailsTx {
            visible: model.fee !== ""
            title.text: qsTr("Fee")
            content.text: model.fee + " " + model.fee_token
            title.color: currTheme.gray
        }

        TextDetailsTx {
            title.text: qsTr("From")
            content.text: model.direction === "to" ? model.wallet_name : model.address
            title.color: currTheme.gray
            copyButton.visible: model.direction === "to" ? false : model.address.length === 104 ? true : false
        }
        TextDetailsTx {
            title.text: qsTr("To")
            content.text: model.direction === "to" ? model.address : model.wallet_name
            title.color: currTheme.gray
            copyButton.visible: model.direction === "to" ? true : false
        }
        TextDetailsTx {
            title.text: qsTr("Date")
            content.text: model.date
            title.color: currTheme.gray
        }
        TextDetailsTx {
            title.text: qsTr("Status")
            title.color: currTheme.gray
            content.text:
                logicExplorer.getStatusName(model.tx_status, model.status)
            content.color:
                logicExplorer.getStatusColor(model.tx_status, model.status)

        }
        TextDetailsTx {
            visible: model.atom !== ""
            title.text: qsTr("Atom")
            content.text: model.atom
            title.color: currTheme.gray
            copyButton.visible: true
            copyButton.popupText: qsTr("Atom copied")
        }


        Item{Layout.fillHeight: true}
    }
}
