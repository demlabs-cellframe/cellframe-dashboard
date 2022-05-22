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

        spacing: 10 * pt

        ConnectPanel
        {
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true

            spacing: 10 * pt

            CurrentUsagePanel
            {
                id: currentUsage
                Layout.fillWidth: true

                dapTopUpButton.onClicked:
                {
                    rightStackView.setInitialItem(topUpPage)
                }
                dapRefundButton.onClicked:
                {
                    rightStackView.setInitialItem(refundPage)
                }

            }

            StatisticsPanel
            {
                Layout.fillWidth: true

            }

        }

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

//    RowLayout
//    {
//        anchors.fill: parent
//        anchors.margins: 10

//        spacing: 10


//    }

}
