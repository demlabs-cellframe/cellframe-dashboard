import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/walletSkin/"
import "../../"
import "MenuBlocks"
import "qrc:/widgets"

Page
{
    id: settingScreen

    property alias dapGeneralBlock: generalBlock

    signal createWalletSignal(bool restoreMode)
    signal switchMenuTab(string tag, bool state)
    signal switchAppsTab(string tag, string name, bool state)
    hoverEnabled: true


    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    Item
    {
        id: control
        anchors.fill: parent

        RowLayout
        {
            anchors.fill: parent
            spacing: 24

            ColumnLayout
            {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumWidth: 327
                Layout.alignment: Qt.AlignTop
                spacing: 0

                DapRectangleLitAndShaded
                {
                    property alias dapContent:content
                    property int spacing: (72 + 39)

                    id:generalBlock
                    Layout.fillWidth: true
                    Layout.preferredHeight: content.implicitHeight
                    Layout.maximumHeight: control.height - spacing
                    color: currTheme.secondaryBackground
                    radius: currTheme.radiusRectangle
                    shadowColor: currTheme.shadowColor
                    lightColor: currTheme.reflectionLight

                    Layout.minimumHeight: 240

                    contentData: DapGeneralBlock{id:content}
                }

                // Wallet create button
                DapButton
                {
                    id: newWalletButton

                    Layout.minimumWidth: 297
                    Layout.maximumWidth: 297
                    Layout.minimumHeight: 36
                    Layout.maximumHeight: 36
                    Layout.topMargin: 23
                    Layout.alignment: Qt.AlignHCenter

                    textButton: qsTr("Create a new wallet")

                    implicitHeight: 36
                    implicitWidth: 297
                    fontButton: mainFont.dapFont.medium14
                    horizontalAligmentText: Text.AlignHCenter
                    onClicked: createWalletSignal(false)
                }

                // Restore wallet
                DapButton
                {
                    id: restoreWalletButton

                    Layout.minimumWidth: 297
                    Layout.maximumWidth: 297
                    Layout.minimumHeight: 36
                    Layout.maximumHeight: 36
                    Layout.topMargin: 16
                    Layout.alignment: Qt.AlignHCenter

                    textButton: qsTr("Import an existing wallet")

                    implicitHeight: 36
                    implicitWidth: 297
                    fontButton: mainFont.dapFont.medium14
                    horizontalAligmentText: Text.AlignHCenter
                    onClicked: createWalletSignal(true)
                }
            }
/*            DapRectangleLitAndShaded
            {
                property alias dapContent:content1

                Layout.fillWidth: true
                Layout.preferredHeight: content1.implicitHeight
                Layout.maximumHeight: control.height

                id: appearanceBlock
                Layout.minimumWidth: 327
                Layout.alignment: Qt.AlignTop
                color: currTheme.backgroundElements
                radius: currTheme.radiusRectangle
                shadowColor: currTheme.shadowColor
                lightColor: currTheme.reflectionLight

                contentData: DapAppearanceBlock{id:content1}
            }*/
        }
    }

/*    Component.onCompleted: {
//        if(!dapNetworkModel.count)
//            dapServiceController.requestToService("DapGetListNetworksCommand")
    }*/
}
