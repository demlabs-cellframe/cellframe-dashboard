import QtQuick 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

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
        width:  parent.width * orderBookWorker.getfilledForPrice(isSell, modelData.price)
        height: parent.height

        color: isSell? sellHistogramColor : buyHistogramColor
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

            Item
            {
                Layout.minimumWidth: 105
                Layout.fillHeight: true

                DapBigText
                {
                    anchors.fill: parent
                    textFont: mainFont.dapFont.regular13
                    textColor: isSell? currTheme.red : currTheme.green
                    fullText: modelData.price

                }
            }

            Item
            {
                Layout.minimumWidth: 105
                Layout.fillHeight: true

                DapBigText
                {
                    //horizontalAlign: Qt.AlignHCenter
                    anchors.fill: parent
                    textColor: currTheme.white
                    textFont: mainFont.dapFont.regular13
                    fullText: modelData.amount

                }
            }

            Item
            {
                Layout.minimumWidth: 105
                Layout.fillHeight: true

                DapBigText
                {

                    anchors.fill: parent
                    //horizontalAlign: Qt.AlignRight
                    textColor: currTheme.white
                    textFont: mainFont.dapFont.regular13
                    fullText: modelData.total

                }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            visible: isSell? index !== 0 : index <
                delegateRectangle.ListView.view.model.length-1

            color: currTheme.mainBackground
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

