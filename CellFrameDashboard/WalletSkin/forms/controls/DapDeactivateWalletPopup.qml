import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

DapBottomScreen{

    property string nameWallet:""

    heightForm: 330
    header.text: qsTr("Deactivate ") + "'" + nameWallet + "'" + qsTr(" wallet")

    id: popup

    dataItem:
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 16
        anchors.bottomMargin: 0
        spacing: 0

        Text{
            Layout.topMargin: -6
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Are you sure?")
            font: mainFont.dapFont.medium14
            color: currTheme.white
        }

        DapImageLoader
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            innerWidth: 120
            innerHeight: 120
            source: "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/icon_deactivate.svg"
        }

        Text{
            id: textError
            visible: false
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 14
            color: currTheme.red
            text: qsTr("")
            font: mainFont.dapFont.regular12
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        DapButton
        {
            id: buttonLock
            Layout.fillWidth: true
            Layout.leftMargin: 118
            Layout.rightMargin: 118
            Layout.bottomMargin: 48
            implicitHeight: 36
            textButton: qsTr("Deactivate")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            onClicked:
            {
                walletModule.activateOrDeactivateWallet(nameWallet,"deactivate")
            }
        }
    }

    function hide(){
        visible = false
        dapBottomPopup.hide()
    }

    function show(name_wallet){
        textError.visible = false
        visible = true
        nameWallet = name_wallet
    }

    Component.onCompleted:
        show(nameWall)

    Connections{
        target: dapServiceController
        function onRcvActivateOrDeactivateReply(rcvData){
            var jsonDoc = JSON.parse(rcvData)
            if(jsonDoc && jsonDoc.result.cmd === "deactivate" && jsonDoc.result.success)
            {
                textError.visible = false
                deactivatingSignal(nameWallet, true)

                dapMainWindow.infoItem.showInfo(
                            191,0,
                            qsTr("Wallet deactivated"),
                            "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/icon_walletLocked.svg")

                hide()
            }else{
                textError.visible = true
                deactivatingSignal(nameWallet, false)
            }
        }
    }
}


