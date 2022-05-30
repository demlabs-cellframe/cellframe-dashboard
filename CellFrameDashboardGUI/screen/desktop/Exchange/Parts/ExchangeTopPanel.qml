import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../"

Rectangle
{

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
//    anchors.leftMargin: 12 * pt
//    anchors.topMargin: 12 * pt
//    anchors.rightMargin: 12 * pt
    height: 50 * pt

    color: currTheme.backgroundMainScreen

    RowLayout
    {
        anchors.fill: parent
        anchors.topMargin: 5 * pt
        anchors.bottomMargin: 5 * pt
        anchors.leftMargin: 12 * pt
        anchors.rightMargin: 12 * pt

        spacing: 0

        Item {
            id: leftComboBox
            width: 140 * pt
            height: parent.height

            DapComboBox
            {
                model: conversionList

                mainTextRole: "text"
/*                comboBoxTextRole: ["text"]
                indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                sidePaddingNormal: 10 * pt
                sidePaddingActive: 10 * pt

                widthPopupComboBoxNormal: 140 * pt
                widthPopupComboBoxActive: 140 * pt
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 42 * pt
                topEffect: false

                normalColor: currTheme.backgroundMainScreen
                normalTopColor: currTheme.backgroundMainScreen
                hilightTopColor: currTheme.backgroundMainScreen


                paddingTopItemDelegate: 8 * pt
                heightListElement: 42 * pt
                indicatorWidth: 24 * pt
                indicatorHeight: indicatorWidth
                colorDropShadow: currTheme.shadowColor
                roleInterval: 15
                endRowPadding: 37

                fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
                colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                alignTextComboBox: [Text.AlignLeft, Text.AlignRight]*/
            }
        }

        ///Time ComboBox
        Item
        {
            id: rightComboBox
            Layout.leftMargin: 40

            width: 140 * pt
            height: parent.height

            DapComboBox
            {
                model:timeModel

                mainTextRole: "text"
/*                comboBoxTextRole: ["text"]
                indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                sidePaddingNormal: 10 * pt
                sidePaddingActive: 10 * pt

                widthPopupComboBoxNormal: 140 * pt
                widthPopupComboBoxActive: 140 * pt
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 42 * pt
                topEffect: false

                normalColor: currTheme.backgroundMainScreen
                normalTopColor: currTheme.backgroundMainScreen
                hilightTopColor: currTheme.backgroundMainScreen


                paddingTopItemDelegate: 8 * pt
                heightListElement: 42 * pt
                indicatorWidth: 24 * pt
                indicatorHeight: indicatorWidth
                colorDropShadow: currTheme.shadowColor
                roleInterval: 15
                endRowPadding: 37

                fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
                colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                alignTextComboBox: [Text.AlignLeft, Text.AlignRight]*/
            }
        }

        Item {
            Layout.fillWidth: true
        }

        ///Value Last price
        Item
        {
            id: lastPrice
            height: parent.height
            width: 150 * pt
            Layout.alignment: Qt.AlignTop
            Layout.rightMargin: 40

            Text
            {
                anchors.left: lastPrice.left
                anchors.bottom: value_lastPrice.top
                anchors.bottomMargin: 6 * pt
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                text: qsTr("Last price")
            }
            Text
            {
                id: value_lastPrice
                anchors.left: lastPrice.left
                anchors.bottom: lastPrice.bottom
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                text: qsTr("$ 10 807.35 NGD")
            }
            Text
            {
                anchors.left: value_lastPrice.right
                anchors.bottom: lastPrice.bottom
                anchors.leftMargin: 6 * pt
                color: "#6F9F00"
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                text: qsTr("+3.59%")
            }
        }
        ///Value 24h volume
        Item
        {
            id: volume24
            height: parent.height
            width: 75 * pt

            Text
            {
                anchors.right: volume24.right
                anchors.bottom: value_valume24.top
                anchors.bottomMargin: 6 * pt
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                text: qsTr("24h volume")
            }
            Text
            {
                id: value_valume24
                anchors.right: volume24.right
                anchors.bottom: volume24.bottom
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                text: qsTr("9 800 TKN1")
            }
        }
    }
}
