import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../"

DapRightPanel {

    property alias dapTextInputNameOrder: textInputNameOrder
    property alias dapComboBoxRegion: comboBoxRegion
    property alias dapComboBoxUnit: comboBoxUnit
    property alias dapComboBoxPrice: comboBoxPrice
    property alias dapButtonCreate: buttonCreate
    property alias dapOrderNameWarning: textOrderNameWarning


    dapNextRightPanel: doneOrder
    dapPreviousRightPanel: earnedFundsOrder

    // TODO откуда брать список регионов
    ListModel {
        id: regionOrder
        ListElement { region: qsTr("Europe, France") }
        ListElement { region: qsTr("123123") }
        ListElement { region: qsTr("123123123") }
    }


    dapHeaderData:
        Item
        {
            anchors.fill: parent
            Item
            {
                id: itemButtonClose
                data: dapButtonClose
                height: dapButtonClose.height
                width: dapButtonClose.width
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 11 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 22 * pt
                anchors.rightMargin: 13 * pt
            }

            Text
            {
                id: textHeader
                text: qsTr("New order")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 50 * pt

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
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
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textNameOrder
                    color: currTheme.textColor
                    text: qsTr("Name")
                    font: dapMainFonts.dapFont.dapFontRobotoRegular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }
            Rectangle
            {
                id: frameInputNameOrder
                height: 41 * pt
                color: "transparent"
                anchors.top: frameNameOrder.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 29 * pt
                anchors.rightMargin: 35 * pt
                anchors.topMargin: 5 * pt
                TextField
                {
                    id: textInputNameOrder
                    placeholderText: qsTr("Title, only you can see")
                    anchors.verticalCenter: parent.verticalCenter
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignLeft
                    anchors.left: parent.left
                    anchors.right: parent.right

                    validator: RegExpValidator { regExp: /[0-9A-Za-z\.\-]+/ }
                    style:
                        TextFieldStyle
                        {
                            textColor: currTheme.textColor
                            placeholderTextColor: currTheme.textColor
                            background:
                                Rectangle
                                {
                                    border.width: 0
                                    color: currTheme.backgroundElements
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
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textRegion
                    color: currTheme.textColor
                    text: qsTr("Region")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                }
            }
            Rectangle
            {
                id: frameSelectRegion
                color: currTheme.backgroundElements
                anchors.top: frameRegion.bottom
                anchors.topMargin: 12 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 18 * pt
                anchors.rightMargin: 19 * pt
                height: 42 * pt
                width: 350 * pt

                DapComboBox {
                    id: comboBoxRegion
                    model: regionOrder

                    anchors.centerIn: parent
                    anchors.fill: parent

                    comboBoxTextRole: ["region"]
                    mainLineText: "all signature"

                    indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                    indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                    sidePaddingNormal: 19 * pt
                    sidePaddingActive: 19 * pt
//                    hilightColor: currTheme.buttonColorNormal

                    widthPopupComboBoxNormal: 318 * pt
                    widthPopupComboBoxActive: 318 * pt
                    heightComboBoxNormal: 24 * pt
                    heightComboBoxActive: 42 * pt
                    topEffect: false

                    normalColor: currTheme.backgroundMainScreen
                    normalTopColor: currTheme.backgroundElements
                    hilightTopColor: currTheme.backgroundMainScreen

                    paddingTopItemDelegate: 8 * pt
                    heightListElement: 42 * pt
                    indicatorWidth: 24 * pt
                    indicatorHeight: indicatorWidth
                    colorDropShadow: currTheme.shadowColor
                    roleInterval: 15
                    endRowPadding: 37

                    fontComboBox: [mainFont.dapFont.regular14]
                    colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                    colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                    alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
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
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textUnits
                    color: currTheme.textColor
                    text: qsTr("Units")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
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

                Item
                {
                    id:boxUnits
                    anchors.right: parent.right
                    anchors.rightMargin: 5 * pt
                    width: comboBoxUnit.widthPopupComboBoxNormal
                    height: parent.height

                    DapComboBox {
                        id: comboBoxUnit

                        // TODO откуда брать список
                        model: ListModel {
                            ListElement { unit: qsTr("hours") }
                            ListElement { unit: qsTr("days") }
                            ListElement { unit: qsTr("seconds") }
                        }

                        comboBoxTextRole: ["unit"]
                        anchors.centerIn: parent
                        indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                        indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                        sidePaddingNormal: 19 * pt
                        sidePaddingActive: 19 * pt
                        widthPopupComboBoxNormal: 119 * pt
                        widthPopupComboBoxActive: 119 * pt
                        heightComboBoxNormal: 24 * pt
                        heightComboBoxActive: 42 * pt
                        topEffect: false
                        x: sidePaddingNormal
                        normalColor: currTheme.backgroundMainScreen
                        normalTopColor: currTheme.backgroundElements
                        hilightTopColor: currTheme.backgroundMainScreen
//                        hilightColor: currTheme.buttonColorNormal

                        paddingTopItemDelegate: 8 * pt
                        heightListElement: 42 * pt
                        indicatorWidth: 24 * pt
                        indicatorHeight: indicatorWidth
                        colorDropShadow: currTheme.shadowColor
                        roleInterval: 15
                        endRowPadding: 37
                        fontComboBox: [mainFont.dapFont.regular14]
                        colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                        colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                        alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
                    }
                }
                DapSpinBox {
                    id: spinBoxUnit

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: boxUnits.left
                    anchors.left: parent.left
                    anchors.margins: 25 * pt
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
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textPrice
                    color: currTheme.textColor
                    text: qsTr("Price")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
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
                    anchors.rightMargin: 5 * pt
                    width: comboBoxPrice.widthPopupComboBoxNormal
                    height: parent.height

                    DapComboBox {
                        id: comboBoxPrice

                        // TODO откуда брать список
                        model: ListModel {
                            id: unitsModel

                            ListElement { token: "KLVN"; decimals: 7 }
                            ListElement { token: "BTC"; decimals: 2 }
                            ListElement { token: "ETH"; decimals: 4 }
                        }

                        comboBoxTextRole: ["token"]
                        anchors.centerIn: parent
                        indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                        indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                        sidePaddingNormal: 19 * pt
                        sidePaddingActive: 19 * pt
                        widthPopupComboBoxNormal: 119 * pt
                        widthPopupComboBoxActive: 119 * pt
                        heightComboBoxNormal: 24 * pt
                        heightComboBoxActive: 42 * pt
                        topEffect: false
                        x: sidePaddingNormal
                        normalColor: currTheme.backgroundMainScreen
                        normalTopColor: currTheme.backgroundElements
                        hilightTopColor: currTheme.backgroundMainScreen
//                        hilightColor: currTheme.buttonColorNormal

                        paddingTopItemDelegate: 8 * pt
                        heightListElement: 42 * pt
                        indicatorWidth: 24 * pt
                        indicatorHeight: indicatorWidth
                        colorDropShadow: currTheme.shadowColor
                        roleInterval: 15
                        endRowPadding: 37
                        fontComboBox: [mainFont.dapFont.regular14]
                        colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                        colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                        alignTextComboBox: [Text.AlignLeft, Text.AlignRight]


                    }
                }
                DapDoubleSpinBox {
                    id: spinBoxPrice

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: boxPrice.left
                    anchors.left: parent.left
                    anchors.margins: 25 * pt
                    font: mainFont.dapFont.medium12
                    from: 0
                    to: 99999999.0
//                    value: 0.0
                    decimals: unitsModel.get(comboBoxPrice.currentIndex)
                }
            }

            DapButton
            {
                id: buttonCreate
                implicitHeight: 36 * pt
                implicitWidth: 132 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: frameSelectPrice.bottom
                anchors.topMargin: 45 * pt
                textButton: qsTr("Create")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular16
            }
            Rectangle
            {
                width: 320*pt
                height: 69 * pt
                color: "transparent"
                anchors.top: buttonCreate.bottom
//                anchors.topMargin: 10 * pt
                anchors.left: parent.left
                anchors.right: parent.right

                Text
                {
                    id: textOrderNameWarning
                    anchors.fill: parent
                    anchors.leftMargin: 10 * pt
                    anchors.rightMargin: 10 * pt
                    color: "#79FFFA"
                    text: qsTr("Enter the order name using Latin letters, dotes, dashes and / or numbers.")
                    font: mainFont.dapFont.regular14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    visible: false
                    anchors.bottomMargin: 10 * pt
                }
            }

        }
}
