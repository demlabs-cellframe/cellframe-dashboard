import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/"
import "../../"
import "MenuBlocks"
import "qrc:/widgets"

Page
{
    id: settingScreen

    property alias dapGeneralBlock: generalBlock

    signal createWalletSignal(bool restoreMode)
    signal nodeSettingsSignal()
    signal switchMenuTab(string tag, bool state)
    signal switchAppsTab(string tag, string name, bool state)


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
                spacing: 24

                DapRectangleLitAndShaded
                {
                    property alias dapContent:content
                    visible: true

                    id:generalBlock
                    Layout.fillWidth: true
                    Layout.preferredHeight: content.implicitHeight
                    Layout.maximumHeight: control.height - supportBlock.height - 24
                    color: currTheme.secondaryBackground
                    radius: currTheme.frameRadius
                    shadowColor: currTheme.shadowColor
                    lightColor: currTheme.reflectionLight

                    Layout.minimumHeight: {
                        if(cellframeNodeWrapper.nodeServiceLoaded)
                            return 182
                        return 126
                    }

                    contentData: DapGeneralBlock{id:content}
                }

                DapRectangleLitAndShaded
                {
                    property alias dapContent: content1

                    id: supportBlock
                    Layout.fillWidth: true
                    Layout.preferredHeight: 266
                    color: currTheme.secondaryBackground
                    radius: currTheme.frameRadius
                    shadowColor: currTheme.shadowColor
                    lightColor: currTheme.reflectionLight

                    Layout.minimumHeight: 266

                    contentData: DapSupportBlock{id:content1}
                }
            }
            DapRectangleLitAndShaded
            {
                property alias dapContent:content2

                Layout.fillWidth: true
                Layout.preferredHeight: content2.implicitHeight
                Layout.maximumHeight: control.height

                id: appearanceBlock
                Layout.minimumWidth: 327
                Layout.alignment: Qt.AlignTop
                color: currTheme.secondaryBackground
                radius: currTheme.frameRadius
                shadowColor: currTheme.shadowColor
                lightColor: currTheme.reflectionLight

                contentData: DapAppearanceBlock{id:content2}
            }
        }
    }
}
