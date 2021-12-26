import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/"
import "../../"
import "MenuBlocks"
import "qrc:/widgets"
import "../SettingsWallet.js" as SettingsWallet

DapAbstractScreen
{
    id: settingScreen

    property alias settingsScreen_ : settingScreen
    property alias dapGeneralBlock:generalBlock
//    property alias dapComboboxWallet: walletComboBox

    signal createWalletSignal(bool restoreMode)

    signal switchMenuTab(string name, bool state)

    anchors
    {
        fill: parent
        topMargin: 24 * pt
        rightMargin: 24 * pt
        leftMargin: 24 * pt
        bottomMargin: 20 * pt
    }

    Item
    {
        id: control
        anchors.fill: parent

        RowLayout
        {
            anchors.fill: parent
            spacing: 25 * pt

            ColumnLayout
            {
                Layout.fillHeight: true
                Layout.minimumWidth: 327 * pt
                Layout.alignment: Qt.AlignTop

                DapRectangleLitAndShaded
                {
                    property alias dapContent:content
                    id:generalBlock
                    property int spacing: (72 + 39) * pt
                    Layout.fillWidth: true
                    Layout.preferredHeight: content.implicitHeight
                    Layout.maximumHeight: control.height - spacing

                    color: currTheme.backgroundElements
                    radius: currTheme.radiusRectangle
                    shadowColor: currTheme.shadowColor
                    lightColor: currTheme.reflectionLight
                    contentData: DapGeneralBlock{id:content}
                }

                // Wallet create button
                DapButton
                {
                    id: newWalletButton

                    Layout.minimumWidth: 297 * pt
                    Layout.maximumWidth: 297 * pt
                    Layout.minimumHeight: 36 * pt
                    Layout.maximumHeight: 36 * pt
                    Layout.topMargin: 23 * pt
                    Layout.alignment: Qt.AlignHCenter

                    textButton: "Create a new wallet"

                    implicitHeight: 36 * pt
                    implicitWidth: 297 * pt
                    fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                    horizontalAligmentText: Text.AlignHCenter
                    onClicked: createWalletSignal(false)
                }

                // Restore wallet
                DapButton
                {
                    id: restoreWalletButton

                    Layout.minimumWidth: 297 * pt
                    Layout.maximumWidth: 297 * pt
                    Layout.minimumHeight: 36 * pt
                    Layout.maximumHeight: 36 * pt
                    Layout.topMargin: 16 * pt
                    Layout.alignment: Qt.AlignHCenter

                    textButton: "Import an existing wallet"

                    implicitHeight: 36 * pt
                    implicitWidth: 297 * pt
                    fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                    horizontalAligmentText: Text.AlignHCenter
                    onClicked: createWalletSignal(true)
                }
            }
            DapRectangleLitAndShaded
            {
                id: appearanceBlock
                Layout.fillWidth: true
                Layout.minimumWidth: 327 * pt
                Layout.alignment: Qt.AlignTop
                Layout.preferredHeight: contentData.implicitHeight
                color: currTheme.backgroundElements
                radius: currTheme.radiusRectangle
                shadowColor: currTheme.shadowColor
                lightColor: currTheme.reflectionLight

                contentData: DapAppearanceBlock{}
            }
            DapRectangleLitAndShaded
            {
                Layout.fillWidth: true
                Layout.minimumWidth: 350 * pt
                Layout.alignment: Qt.AlignTop
                height: 300
                color: currTheme.backgroundElements
                radius: currTheme.radiusRectangle
                shadowColor: currTheme.shadowColor
                lightColor: currTheme.reflectionLight
                ListView
                {
                    id: listViewSettingsApps
//                            Layout.fillWidth: true
//                            delegate: testComp
                    clip: true
                }
            }
        }
    }

}
