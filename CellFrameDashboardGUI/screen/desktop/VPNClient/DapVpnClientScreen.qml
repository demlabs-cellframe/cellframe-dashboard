import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "Parts"
import "../../"

Page {
    id: dapVpnClientScreen

    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
    }

    ColumnLayout
    {
        anchors.fill: parent
//        anchors.margins: 10

        spacing: 20 * pt

        ConnectPanel
        {
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true

            spacing: 20 * pt

            CurrentUsagePanel
            {
                id: currentUsage
                Layout.fillWidth: true

                dapTopUpButton.onClicked:
                {
                    rightStackView.setItem(topUpPage)
                    //rightStackView.setInitialItem(topUpPage)
                }
                dapRefundButton.onClicked:
                {
                    rightStackView.setItem(refundPage)
                    //rightStackView.setInitialItem(refundPage)
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
            radius: currTheme.radiusRectangle
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
