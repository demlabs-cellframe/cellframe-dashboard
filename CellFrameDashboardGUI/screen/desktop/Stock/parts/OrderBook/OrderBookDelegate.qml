import QtQuick 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    id: delegateRectangle
    height: 32
    width: parent.width

    property bool isSell: true

    color: "transparent"

    Rectangle
    {
        anchors.right: parent.right
        width: isSell ? parent.width*modelData.total/stockDataWorker.sellMaxTotal :
                        parent.width*modelData.total/stockDataWorker.buyMaxTotal
        height: parent.height

        color: isSell? sellHistogramColor : buyHistogramColor

//        Component.onCompleted:
//        {
//            print("isSell", isSell,
//                  "modelData.total", modelData.total,
//                  "stockDataWorker.sellMaxTotal", stockDataWorker.sellMaxTotal,
//                  "stockDataWorker.buyMaxTotal", stockDataWorker.buyMaxTotal)
//        }
    }

    ColumnLayout
    {
        anchors.fill: parent

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: 5

            Text
            {
                Layout.minimumWidth: 100
                color: isSell? currTheme.textColorRed : currTheme.textColorGreen
                font: mainFont.dapFont.regular13
                text: modelData.price.toFixed(5)
            }

            Text
            {
                Layout.fillWidth: true
                color: currTheme.textColor
                font: mainFont.dapFont.regular13
                text: modelData.amount.toFixed(4)
            }

            Text
            {
                horizontalAlignment: Qt.AlignRight
                color: currTheme.textColor
                font: mainFont.dapFont.regular13
                text: modelData.total.toFixed(4)
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            visible: isSell? index !== 0 : index <
                delegateRectangle.ListView.view.model.length-1

            color: currTheme.lineSeparatorColor
        }
    }
}
