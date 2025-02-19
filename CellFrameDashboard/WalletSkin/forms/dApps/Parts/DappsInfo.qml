import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.0
import "../../controls"
import "../../History"
import "qrc:/widgets"

DapBottomScreen {

    property var model: selectedDapps.get(0)

    heightForm: 330
    header.text: qsTr("dApp info")

    dataItem:
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 16
        anchors.topMargin: 28
        anchors.bottomMargin: 0
        spacing: 20

        TextDetailsTx {
            title.text: qsTr("Name")
            content.text: model.name
            title.color: currTheme.gray
        }
        TextDetailsTx {
            title.text: qsTr("Verified")
            content.text: model.verifed === "0" ? "No" : "Yes"
            title.color: currTheme.gray
        }
        TextDetailsTx {
            title.text: qsTr("Status")
            content.text: model.status === "1" ? "Active" : "Inactive"
            title.color: currTheme.gray
        }
        TextDetailsTx {
            title.text: qsTr("Path")
            content.text: model.urlPath
            title.color: currTheme.gray
            copyButton.visible: true
//            copyButton.popupText: "Path copied"
        }

//        Item{Layout.fillHeight: true}

        RowLayout{
            Layout.topMargin: 50
            Layout.fillWidth: true
            Layout.leftMargin: 31
            Layout.rightMargin: 31
            Layout.bottomMargin: 48
            spacing: 17

            DapButton{
                Layout.fillWidth: true
                Layout.minimumHeight: 36
                Layout.maximumHeight: 36

                enabled: model.urlPath.indexOf("https://")

                textButton: qsTr("Delete dApp")

                defaultColorNormal0: currTheme.red
                defaultColorNormal1: currTheme.red
                defaultColorHovered0: currTheme.redHover
                defaultColorHovered1: currTheme.redHover

                implicitHeight: 36
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:{
                    pluginsController.deletePlugin(model.urlPath)

                    dapMainWindow.infoItem.showInfo(
                                0,0,
                                qsTr("dApp deleted"),
                                "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/check_icon.png")

                    dapBottomPopup.hide()
                }
            }

            DapButton{
                Layout.fillWidth: true
                Layout.minimumHeight: 36
                Layout.maximumHeight: 36

                textButton: model.status === "1" ? qsTr("Deactivate dApp") : qsTr("Activate dApp")

                implicitHeight: 36
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:{
                    if(model.status === "1")
                    {
                        pluginsController.installPlugin(model.name, 0, model.verifed)

                        dapMainWindow.infoItem.showInfo(
                                    185,0,
                                    qsTr("dApp deactivated"),
                                    "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/check_icon.png")

                        dapBottomPopup.hide()
                    }
                    else
                    {

                        dapBottomPopup.push("qrc:/walletSkin/forms/dApps/Parts/InstallDapp.qml")

                        pluginsController.installPlugin(model.name, 1, model.verifed)

//                        dapMainWindow.infoItem.showInfo(
//                                    185,0,
//                                    "dApp deactivated",
//                                    "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/check_icon.png")

//                        dapBottomPopup.hide()


                    }
                }
            }
        }
    }
}
