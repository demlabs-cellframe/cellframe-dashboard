import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4

import "qrc:/widgets"
import "../Parts"
import "../../controls"

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
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 * pt

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 7 * pt
                anchors.leftMargin: 21 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImage: 20 * pt
                widthImage: 20 * pt

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
                onClicked: pop()
            }

            Text
            {
                id: textHeader
                text: qsTr("Create new order")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 52 * pt

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }

        }

        Rectangle
        {
            id:frameNameOrder
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt
            Text
            {
                id: textNameOrder
                color: currTheme.textColor
                text: qsTr("Name of order")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }
        Rectangle
        {
            id: frameInputNameOrder
            height: 60 * pt
            color: "transparent"
            Layout.fillWidth: true
            TextField
            {
                id: textInputNameOrder
                placeholderText: qsTr("Title, only you can see")
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.margins: 10 * pt
                anchors.leftMargin: 29 * pt

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
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Layout.fillWidth: true
            Text
            {
                id: textRegion
                color: currTheme.textColor
                text: qsTr("Region")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 21 * pt
                anchors.topMargin: 16 * pt
                anchors.bottomMargin: 7 * pt
            }
        }
        Rectangle
        {
            id: frameSelectRegion
            height: 60 * pt
    //            width: 350 * pt
            color: "transparent"
            Layout.fillWidth: true

            DapComboBox {
                id: comboBoxRegion
                model: regionOrder

                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 10 * pt
                anchors.leftMargin: 15 * pt

                font: mainFont.dapFont.regular16

                defaultText: qsTr("all signature")

                mainTextRole: "region"

                onCurrentIndexChanged:
                {
                    dapRegionOrder = comboBoxRegion.currentIndex.toString()
                }
            }
        }
        Rectangle
        {
            id: frameUnits
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Layout.fillWidth: true
            Text
            {
                id: textUnits
                color: currTheme.textColor
                text: qsTr("Units")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 22 * pt
                anchors.topMargin: 16 * pt
                anchors.bottomMargin: 7 * pt
            }
        }
        Rectangle
        {
            id: frameSelectUnits
            height: 68 * pt
    //            width: 350 * pt
            color: "transparent"
            Layout.fillWidth: true

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

                    x: sidePaddingNormal

                    font: mainFont.dapFont.regular16

                    mainTextRole: "unit"

                    onCurrentIndexChanged:
                    {
                        dapUnitOrder = comboBoxUnit.currentIndex.toString()
                    }
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
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Layout.fillWidth: true
            Text
            {
                id: textPrice
                color: currTheme.textColor
                text: qsTr("Price")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 22 * pt
                anchors.topMargin: 16 * pt
                anchors.bottomMargin: 7 * pt
            }
        }
        Rectangle
        {
            id: frameSelectPrice
            height: 68 * pt
    //            width: 350 * pt
            color: "transparent"
            Layout.fillWidth: true

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

                    x: sidePaddingNormal
                    anchors.centerIn: parent

                    font: mainFont.dapFont.regular16

                    mainTextRole: "token"

                    onCurrentIndexChanged:
                    {
                        dapPriceOrder = comboBoxPrice.currentIndex.toString()
                    }


                }
            }
            DapDoubleSpinBox {
                id: spinBoxPrice

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: boxPrice.left
                anchors.left: parent.left
                anchors.margins: 25 * pt
                from: 0
                to: 65535.0
                decimals: unitsModel.get(comboBoxPrice.currentIndex).decimals
            }
        }

        DapButton
        {
            id: buttonCreate
            implicitHeight: 36 * pt
            implicitWidth: 132 * pt
            Layout.topMargin: 58 * pt
            Layout.alignment: Qt.AlignHCenter
            textButton: qsTr("Create")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular16

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

        Text
        {
            id: textOrderNameWarning
            Layout.minimumHeight: 60 * pt
            Layout.maximumHeight: 60 * pt
            Layout.margins: 0 * pt
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: parent.width - 50 * pt
            color: "#79FFFA"
            text: qsTr("Enter the order name using Latin letters, dotes, dashes and / or numbers.")
            font: mainFont.dapFont.regular14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            visible: false
        }
        Rectangle
        {
            id: frameBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }
    }
}
