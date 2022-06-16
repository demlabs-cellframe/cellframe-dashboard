import QtQuick 2.4
import QtQuick.Layouts 1.3

RowLayout {
    property alias text1:text1
    property alias text2:text2

    spacing: 3
    Text
    {
        id: text1
        font: mainFont.dapFont.regular13
        color: currTheme.textColorGray
    }
    Text
    {
        id: text2
        font: mainFont.dapFont.regular13
        color: currTheme.textColorGreen
    }
}
