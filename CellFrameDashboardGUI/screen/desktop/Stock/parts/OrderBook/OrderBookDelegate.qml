import QtQuick 2.4
import QtQuick.Layouts 1.3

ColumnLayout
{
    property bool isSell: true
    height: 32
    width: parent.width

    RowLayout
    {
        Layout.fillWidth: true
        Layout.leftMargin: 16
        Layout.rightMargin: 16

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
                                       parent.ListView.view.model.count-1

        color: currTheme.lineSeparatorColor
    }
}
