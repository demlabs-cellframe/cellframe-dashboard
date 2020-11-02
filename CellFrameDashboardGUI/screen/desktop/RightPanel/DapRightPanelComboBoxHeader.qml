import QtQuick 2.7
import "qrc:/widgets"

Item {
    property alias caption: text.text
    property alias comboBox: _comboBox

    Text {
        id: text

        anchors.verticalCenter: parent.verticalCenter
        width: Math.min(implicitWidth, parent.width - _comboBox.x)

        elide: Text.ElideRight
        font: quicksandFonts.bold14
        color: "#3E3853"
    }

    Item {
        anchors.right: parent.right
        anchors.rightMargin: 16 * pt
        width: _comboBox.widthPopupComboBoxNormal
        height: parent.height

        DapComboBox {
            id: _comboBox

            anchors.centerIn: parent
            indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark.png"
            indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up.png"
            sidePaddingNormal: 0 * pt
            sidePaddingActive: 20 * pt
            normalColorText: "#070023"
            hilightColorText: "#FFFFFF"
            normalColorTopText: "#070023"
            hilightColorTopText: "#070023"
            hilightColor: "#330F54"
            normalTopColor: "transparent"
            widthPopupComboBoxNormal: 100 * pt
            widthPopupComboBoxActive: 144 * pt
            heightComboBoxNormal: 24 * pt
            heightComboBoxActive: 44 * pt
            bottomIntervalListElement: 8 * pt
            topEffect: false
            normalColor: "#FFFFFF"
            hilightTopColor: normalColor
            paddingTopItemDelegate: 8 * pt
            heightListElement: 32 * pt
            intervalListElement: 10 * pt
            indicatorWidth: 20 * pt
            indicatorHeight: indicatorWidth
            indicatorLeftInterval: 20 * pt
            colorTopNormalDropShadow: "#00000000"
            colorDropShadow: "#40ABABAB"
            fontComboBox: [quicksandFonts.medium14]
            colorMainTextComboBox: [["#070023", "#070023"]]
            colorTextComboBox: [["#070023", "#FFFFFF"]]
        }
    }
}
