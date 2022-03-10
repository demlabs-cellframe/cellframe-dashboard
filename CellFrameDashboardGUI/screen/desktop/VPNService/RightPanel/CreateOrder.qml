import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4

import "qrc:/widgets"
import "../Parts"

Page {

    property alias dapTextInputNameOrder: textInputNameOrder
    property alias dapOrderNameWarning: textOrderNameWarning

    property string dapRegionOrder
    property string dapUnitOrder
    property string dapPriceOrder

    background: Rectangle {
        color: "transparent"
    }

    ListModel {
        id: regionOrder
        ListElement { region: qsTr("Europe, France") }
        ListElement { region: qsTr("123123") }
        ListElement { region: qsTr("123123123") }
    }

    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.leftMargin: 10
            DapButton
            {
                id: buttonClose
                height: 20 * pt
                width: 20 * pt
                heightImageButton: 10 * pt
                widthImageButton: 10 * pt
                activeFrame: false
                normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
                hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"

                onClicked: {
                    navigator.popPage()
                }
            }
            Text
            {
                id: textHeader
                text: qsTr("New order")
                Layout.fillWidth: true
                verticalAlignment: Qt.AlignLeft

                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
            }
        }

        ItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: 30 * pt

            background: Rectangle {
                color: currTheme.backgroundMainScreen
            }

            RowLayout {
                anchors.fill: parent
                Text
                {
                    id: textNameOrder
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: currTheme.textColor
                    text: qsTr("Name")
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                }
            }
        }

        TextField
        {
            id: textInputNameOrder
            Layout.fillWidth: true
            Layout.leftMargin: 10
            placeholderText: qsTr("Title, only you can see")
            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16

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

        ItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: 30 * pt

            background: Rectangle {
                color: currTheme.backgroundMainScreen
            }

            RowLayout {
                anchors.fill: parent
                Text
                {
                    id: textRegion
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: currTheme.textColor
                    text: qsTr("Region")
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                }
            }
        }

        DapComboBoxNew {
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            model: regionOrder
        }

//        DapComboBox {
//            id: comboBoxRegion
//            model: regionOrder

//            Layout.fillWidth: true

//            comboBoxTextRole: ["region"]
//            mainLineText: "all signature"

//            indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
//            indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
//            sidePaddingNormal: 19 * pt
//            sidePaddingActive: 19 * pt
////                    hilightColor: currTheme.buttonColorNormal

//            widthPopupComboBoxNormal: 318 * pt
//            widthPopupComboBoxActive: 318 * pt
//            heightComboBoxNormal: 24 * pt
//            heightComboBoxActive: 42 * pt
//            topEffect: false

//            normalColor: currTheme.backgroundMainScreen
//            normalTopColor: currTheme.backgroundElements
//            hilightTopColor: currTheme.backgroundMainScreen

//            paddingTopItemDelegate: 8 * pt
//            heightListElement: 42 * pt
//            indicatorWidth: 24 * pt
//            indicatorHeight: indicatorWidth
//            colorDropShadow: currTheme.shadowColor
//            roleInterval: 15
//            endRowPadding: 37

//            fontComboBox: [_dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16]
//            colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
////                    colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
////                    alignTextComboBox: [Text.AlignLeft, Text.AlignRight]

//            onCurrentIndexChanged:
//            {
//                dapRegionOrder = dapComboBoxRegion.currentIndex.toString()
//            }
//        }

        ItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: 30 * pt

            background: Rectangle {
                color: currTheme.backgroundMainScreen
            }

            RowLayout {
                anchors.fill: parent
                Text
                {
                    id: textUnits
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: currTheme.textColor
                    text: qsTr("Units")
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 10
            DapSpinBox {
                id: spinBoxUnit
                Layout.fillWidth: true
                from: 0
                to: 2147483647
            }

            DapComboBoxNew {
                id: comboBoxUnit
                Layout.fillWidth: true
                // TODO откуда брать список
                model: ListModel {
                    ListElement { unit: qsTr("hours") }
                    ListElement { unit: qsTr("days") }
                    ListElement { unit: qsTr("seconds") }
                }
                onCurrentIndexChanged: {
                    dapUnitOrder = dapComboBoxUnit.currentIndex.toString()
                }
            }

//            DapComboBox {
//                id: comboBoxUnit
//                Layout.fillWidth: true

//                // TODO откуда брать список
//                model: ListModel {
//                    ListElement { unit: qsTr("hours") }
//                    ListElement { unit: qsTr("days") }
//                    ListElement { unit: qsTr("seconds") }
//                }

//                comboBoxTextRole: ["unit"]
//                indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
//                indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
//                sidePaddingNormal: 19 * pt
//                sidePaddingActive: 19 * pt
//                widthPopupComboBoxNormal: 119 * pt
//                widthPopupComboBoxActive: 119 * pt
//                heightComboBoxNormal: 24 * pt
//                heightComboBoxActive: 42 * pt
//                topEffect: false
//                x: sidePaddingNormal
//                normalColor: currTheme.backgroundMainScreen
//                normalTopColor: currTheme.backgroundElements
//                hilightTopColor: currTheme.backgroundMainScreen
////                        hilightColor: currTheme.buttonColorNormal

//                paddingTopItemDelegate: 8 * pt
//                heightListElement: 42 * pt
//                indicatorWidth: 24 * pt
//                indicatorHeight: indicatorWidth
//                colorDropShadow: currTheme.shadowColor
//                roleInterval: 15
//                endRowPadding: 37
//                fontComboBox: [_dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16]
//                colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
//                onCurrentIndexChanged:
//                {
//                    dapUnitOrder = dapComboBoxUnit.currentIndex.toString()
//                }
//            }
        }

        ItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: 30 * pt

            background: Rectangle {
                color: currTheme.backgroundMainScreen
            }

            RowLayout {
                anchors.fill: parent
                Text
                {
                    id: textPrice
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: currTheme.textColor
                    text: qsTr("Price")
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 10
            spacing: 5
            DapDoubleSpinBox {
                id: spinBoxPrice

                Layout.fillWidth: true

                from: 0
                to: 65535.0
                decimals: unitsModel.get(comboBoxPrice.currentIndex).decimals
            }

            DapComboBoxNew {
                id: comboBoxPrice
                Layout.fillWidth: true
                // TODO откуда брать список
                model: ListModel {
                    id: unitsModel

                    ListElement { token: "KLVN"; decimals: 7 }
                    ListElement { token: "BTC"; decimals: 2 }
                    ListElement { token: "ETH"; decimals: 4 }
                }

                onCurrentIndexChanged:
                {
                    dapPriceOrder = dapComboBoxPrice.currentIndex.toString()
                }
            }

//            DapComboBox {
//                id: comboBoxPrice

//                Layout.fillWidth: true

//                // TODO откуда брать список
//                model: ListModel {
//                    id: unitsModel

//                    ListElement { token: "KLVN"; decimals: 7 }
//                    ListElement { token: "BTC"; decimals: 2 }
//                    ListElement { token: "ETH"; decimals: 4 }
//                }

//                comboBoxTextRole: ["token"]
//                anchors.centerIn: parent
//                indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
//                indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
//                sidePaddingNormal: 19 * pt
//                sidePaddingActive: 19 * pt
//                widthPopupComboBoxNormal: 119 * pt
//                widthPopupComboBoxActive: 119 * pt
//                heightComboBoxNormal: 24 * pt
//                heightComboBoxActive: 42 * pt
//                topEffect: false
//                x: sidePaddingNormal
//                normalColor: currTheme.backgroundMainScreen
//                normalTopColor: currTheme.backgroundElements
//                hilightTopColor: currTheme.backgroundMainScreen
////                        hilightColor: currTheme.buttonColorNormal

//                paddingTopItemDelegate: 8 * pt
//                heightListElement: 42 * pt
//                indicatorWidth: 24 * pt
//                indicatorHeight: indicatorWidth
//                colorDropShadow: currTheme.shadowColor
//                roleInterval: 15
//                endRowPadding: 37
//                fontComboBox: [_dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16]
//                colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]

//                onCurrentIndexChanged:
//                {
//                    dapPriceOrder = dapComboBoxPrice.currentIndex.toString()
//                }


//            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 5

            Item {
                Layout.fillWidth: true
            }

            DapButton
            {
                id: buttonCreate
                Layout.preferredHeight: 36 * pt
                Layout.preferredWidth: 132 * pt

                textButton: qsTr("Create")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16

                onClicked:
                {
                    if (dapTextInputNameOrder.text == "")
                    {
                        dapOrderNameWarning.visible = true
                        console.warn("Empty order name")
                    }
                    else
                    {
                        dapOrderNameWarning.visible = false
                        console.log("Create new order "+dapTextInputNameOrder.text);
                        console.log("Region "+dapRegionOrder);
                        console.log("Unit "+dapUnitOrder);
                        console.log("Price "+dapPriceOrder);
                        console.log("Network "+dapServiceController.CurrentNetwork)
                        dapServiceController.requestToService();
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Text
        {
            id: textOrderNameWarning
            Layout.fillWidth: true
            Layout.margins: 20
            color: "#79FFFA"
            text: qsTr("Enter the order name using Latin letters, dotes, dashes and / or numbers.")
            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            visible: false
            anchors.bottomMargin: 10 * pt
        }

        Item {
            id: spacer
            Layout.fillHeight: true
        }

    }
}
