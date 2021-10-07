import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../"

DapAbstractRightPanel {

    property alias dapTextInputNameOrder: textInputNameOrder
    property alias dapComboBoxRegion: comboBoxRegion
    property alias dapComboBoxUnit: comboBoxUnit
    property alias dapComboBoxPrice: comboBoxPrice
    property alias dapButtonCreate: buttonCreate
    property alias dapOrderNameWarning: textOrderNameWarning


    dapNextRightPanel: doneOrder
    dapPreviousRightPanel: earnedFundsOrder

    width: 400 * pt

    dapHeaderData:
        Row
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.rightMargin: 16 * pt
            anchors.topMargin: 12 * pt
            anchors.bottomMargin: 12 * pt
            spacing: 12 * pt

            Item
            {
                id: itemButtonClose
                data: dapButtonClose
                height: dapButtonClose.height
                width: dapButtonClose.width
            }

            Text
            {
                id: textHeader
                text: qsTr("Create VPN Order")
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                color: "#3E3853"
            }
        }
    dapContentItemData:
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"
            Rectangle
            {
                id:frameNameOrder
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textNameOrder
                    color: "#ffffff"
                    text: qsTr("Name")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }
            Rectangle
            {
                id: frameInputNameOrder
                height: 68 * pt
                color: "transparent"
                anchors.top: frameNameOrder.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                TextField
                {
                    id: textInputNameOrder
                    placeholderText: qsTr("Title, only you can see")
                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.horizontalCenter: parent.horizontalCenter
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular16
                    horizontalAlignment: Text.AlignLeft
                    anchors.left: parent.left
                    anchors.leftMargin: 38 * pt
                    anchors.right: parent.right
                    validator: RegExpValidator { regExp: /[0-9A-Za-z\.\-]+/ }
                    style:
                        TextFieldStyle
                        {
                            textColor: "#070023"
                            placeholderTextColor: "#C7C6CE"
                            background:
                                Rectangle
                                {
                                    border.width: 0
                                    color: "transparent"
                                }
                        }
                }
            }
            Rectangle
            {
                id: frameRegion
                anchors.top: frameInputNameOrder.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textRegion
                    color: "#ffffff"
                    text: qsTr("Region")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }
            Rectangle
            {
                id: frameSelectRegion
                height: 68 * pt
                color: "transparent"
                anchors.top: frameRegion.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt

                DapComboBox {
                    id: comboBoxRegion

                    comboBoxTextRole: ["region"]
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
                    widthPopupComboBoxNormal: 278 * pt
                    widthPopupComboBoxActive: 318 * pt
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
                    fontComboBox: [ dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18]
                    colorMainTextComboBox: [["#070023", "#070023"]]
                    colorTextComboBox: [["#070023", "#FFFFFF"]]

                    // TODO откуда брать список регионов
                    model: ListModel {
                        ListElement { region: qsTr("Europe, France") }
                        ListElement { region: qsTr("123123") }
                        ListElement { region: qsTr("123123123") }
                    }
                }
            }
            Rectangle
            {
                id: frameUnits
                anchors.top: frameSelectRegion.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textUnits
                    color: "#ffffff"
                    text: qsTr("Units")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }
            Rectangle
            {
                id: frameSelectUnits
                height: 68 * pt
                color: "transparent"
                anchors.top: frameUnits.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt



                Item {
                    id:boxUnits
                    anchors.right: parent.right
                    width: comboBoxUnit.widthPopupComboBoxNormal
                    height: parent.height

                    DapComboBox {
                        id: comboBoxUnit

                        comboBoxTextRole: ["unit"]
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
                        widthPopupComboBoxNormal: 94 * pt
                        widthPopupComboBoxActive: 134 * pt
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
                        fontComboBox: [ dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18]
                        colorMainTextComboBox: [["#070023", "#070023"]]
                        colorTextComboBox: [["#070023", "#FFFFFF"]]

                        // TODO откуда брать список
                        model: ListModel {
                            ListElement { unit: qsTr("hours") }
                            ListElement { unit: qsTr("days") }
                            ListElement { unit: qsTr("seconds") }
                        }
                    }
                }
                DapSpinBox {
                    id: spinBoxUnit

                    anchors.verticalCenter: parent.verticalCenter
//                    height: Math.min(implicitHeight, parent.height)
                    anchors.right: boxUnits.left
                    anchors.left: parent.left
                    anchors.margins: 45
                    from: 0
                    to: 2147483647
                }
            }
            Rectangle
            {
                id: framePrice
                anchors.top: frameSelectUnits.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textPrice
                    color: "#ffffff"
                    text: qsTr("Price")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }
            Rectangle
            {
                id: frameSelectPrice
                height: 68 * pt
                color: "transparent"
                anchors.top: framePrice.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt

                Item {
                    id:boxPrice
                    anchors.right: parent.right
                    width: comboBoxPrice.widthPopupComboBoxNormal
                    height: parent.height

                    DapComboBox {
                        id: comboBoxPrice

                        comboBoxTextRole: ["token"]
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
                        widthPopupComboBoxNormal: 94 * pt
                        widthPopupComboBoxActive: 134 * pt
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
                        fontComboBox: [ dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18]
                        colorMainTextComboBox: [["#070023", "#070023"]]
                        colorTextComboBox: [["#070023", "#FFFFFF"]]

                        // TODO откуда брать список
                        model: ListModel {
                            id: unitsModel

                            ListElement { token: "KLVN"; decimals: 7 }
                            ListElement { token: "BTC"; decimals: 2 }
                            ListElement { token: "ETH"; decimals: 4 }
                        }
                    }
                }
                DapDoubleSpinBox {
                    id: spinBoxPrice

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: boxPrice.left
                    anchors.left: parent.left
                    anchors.margins: 45
                    from: 0
                    to: 9999999999
                    decimals: unitsModel.get(comboBoxPrice.currentIndex).decimals
                }
            }

            DapButton
            {
                id: buttonCreate
                implicitHeight: 44 * pt
                implicitWidth: 130 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: frameSelectPrice.bottom
                anchors.topMargin: 40 * pt
                textButton: qsTr("Create")
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#3E3853"
                colorButtonTextNormal: "#FFFFFF"
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular18
            }

            Text
            {
                id: textOrderNameWarning
                anchors.top: buttonCreate.bottom
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16 * pt
                anchors.right: parent.right
                anchors.rightMargin: 16 * pt
                anchors.topMargin: 20 * pt
                width: parent.width - 32 * pt
                color: "#ff2020"
                text: qsTr("Enter the order name using Latin letters, dotes, dashes and / or numbers.")
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                visible: false
            }

            Rectangle
            {
                id: frameBottom
                height: 124 * pt
                anchors.top: buttonCreate.bottom
                anchors.topMargin: 24 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "transparent"
            }
        }
}
