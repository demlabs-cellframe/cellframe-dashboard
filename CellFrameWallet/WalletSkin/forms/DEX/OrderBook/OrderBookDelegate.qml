import QtQuick 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    id: delegateRectangle
    height: delegateHeight
    width: parent.width

    property bool isSell: true

    property bool shortView: true

    property bool shortSell: shortView && isSell

    color: "transparent"

    Rectangle
    {
        anchors.verticalCenter: parent.verticalCenter
        width: isSell ?
            parent.width*modelData.total/orderBookWorker.sellMaxTotal :
            parent.width*modelData.total/orderBookWorker.buyMaxTotal
        height: delegateHeight - 3

        x: !shortSell ? 0 : parent.width - width

        color: isSell? sellHistogramColor : buyHistogramColor
    }

    ColumnLayout
    {
        anchors.fill: parent

        RowLayout
        {
            Layout.fillWidth: true

            Text
            {
                visible: shortSell
                Layout.fillWidth: true
                color: currTheme.white
                font: mainFont.dapFont.regular13
                text: modelData.amount.toFixed(4)
            }

            Text
            {
                visible: shortSell
                Layout.minimumWidth: 100
                color: isSell? currTheme.red
                             : currTheme.green
                font: mainFont.dapFont.regular13
//                text: modelData.price.toFixed(5)
                horizontalAlignment: Qt.AlignRight
                text: roundDoubleValue(modelData.price,
                    orderBookWorker.bookRoundPower)
            }

            Text
            {
                visible: !shortSell
                Layout.minimumWidth: 100
                color: isSell? currTheme.red
                             : currTheme.green
                font: mainFont.dapFont.regular13
//                text: modelData.price.toFixed(5)
                text: roundDoubleValue(modelData.price,
                    orderBookWorker.bookRoundPower)
            }

            Text
            {
                visible: !shortSell
                Layout.fillWidth: true
                color: currTheme.white
                horizontalAlignment: shortView ? Qt.AlignRight : Qt.AlignLeft
                font: mainFont.dapFont.regular13
                text: modelData.amount.toFixed(4)
            }

            Text
            {
                visible: !shortView
                horizontalAlignment: Qt.AlignRight
                color: currTheme.white
                font: mainFont.dapFont.regular13
                text: modelData.total.toFixed(4)
            }
        }
    }

    function roundDoubleValue(value, round)
    {
//        print("roundDoubleValue", value, round)

        if (round >= 0)
        {
            return value.toFixed(round)
        }
        else
        {
            var pow = Math.pow(10, -round)
            value /= pow
            value = value.toFixed(0)
            value *= pow
            return value.toFixed(0)
        }
    }
}

