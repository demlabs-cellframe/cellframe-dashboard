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
        width: isSell ? parent.width*total/logicStock.sellMaxTotal :
                        parent.width*total/logicStock.buyMaxTotal
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

            Text
            {
                Layout.minimumWidth: 100
                color: isSell? currTheme.textColorRed : currTheme.textColorGreen
                font: mainFont.dapFont.regular13
                text: price.toFixed(5)
            }

            Text
            {
                Layout.fillWidth: true
                color: currTheme.textColor
                font: mainFont.dapFont.regular13
                text: amount.toFixed(2)
            }

            Text
            {
                horizontalAlignment: Qt.AlignRight
                color: currTheme.textColor
                font: mainFont.dapFont.regular13
                text: total.toFixed(4)
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            visible: isSell? index !== 0 : index <
                delegateRectangle.ListView.view.model.count-1

            color: currTheme.lineSeparatorColor
        }
    }
}

