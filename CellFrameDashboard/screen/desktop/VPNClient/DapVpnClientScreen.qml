import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"
import "Parts"

Page {
    id: dapVpnClientScreen

    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 24 * pt

        Item
        {
            Layout.fillWidth: true
            height: 52

            Item
            {
                anchors.fill: parent

                Text {
                    id: connectedText
                    font: mainFont.dapFont.regular16
                    color: currTheme.textColor

                    text: qsTr("Connected to:")
                }

                Text {
                    font: mainFont.dapFont.medium18
                    color: currTheme.textColor
                    y: connectedText.height + 10 * pt

                    text: qsTr("42.112.14.73 (San Juan, Puerto Rico)")
                }
            }

            DapButton
            {
                y: parent.height * 0.5 - height * 0.5 + 3 * pt
                x: parent.width - width
                width: 170 * pt
                height: 38 * pt
                horizontalAligmentText: Text.AlignHCenter
                fontButton: mainFont.dapFont.regular14
                textButton: qsTr("Disconnect")
            }
        }

        RowLayout {
            Layout.fillWidth: true

            spacing: 24 * pt

            CurrentUsagePanel
            {
                id: currentUsage
                Layout.fillWidth: true

                onTopUpClicked:
                {
                    vpnClientNavigator.openTopUpItem()
                }
                onRefoundClicked:
                {
                    vpnClientNavigator.openRefoundItem()
                }
            }

            StatisticsPanel
            {
                Layout.fillWidth: true
            }
        }

        DapRectangleLitAndShaded
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            color: currTheme.backgroundElements
            radius: currTheme.frameRadius
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:
                ColumnLayout
                {
                    anchors.fill: parent
                    anchors.margins: 20 * pt
                    spacing: 5 * pt

                    ChartPanel
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    CheckersPanel
                    {
                        Layout.fillWidth: true
                    }
                }
        }
    }
}
