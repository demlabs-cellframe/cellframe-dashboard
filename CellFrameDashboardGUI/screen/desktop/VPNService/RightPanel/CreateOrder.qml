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
        ListElement { region: "123123" }
        ListElement { region: "123123123" }
    }

    ColumnLayout {

        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10 
                anchors.bottomMargin: 7 
                anchors.leftMargin: 21 
                anchors.rightMargin: 13 

                id: itemButtonClose
                height: 20 
                width: 20 
                heightImage: 20 
                widthImage: 20 

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
                anchors.topMargin: 12 
                anchors.bottomMargin: 8 
                anchors.leftMargin: 52 

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }

        }

        Rectangle
        {
            id:frameNameOrder
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 30 
            Text
            {
                id: textNameOrder
                color: currTheme.white
                text: qsTr("Name of order")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 
                anchors.topMargin: 20 
                anchors.bottomMargin: 5 
            }
        }
        Rectangle
        {
            id: frameInputNameOrder
            height: 60 
            color: "transparent"
            Layout.fillWidth: true
            TextField
            {
                id: textInputNameOrder
                placeholderText: qsTr("Title, only you can see")
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.margins: 10 
                anchors.leftMargin: 29 

                validator: RegExpValidator { regExp: /[0-9A-Za-z\.\-]+/ }
                style:
                    TextFieldStyle
                    {
                        textColor: currTheme.white
                        placeholderTextColor: currTheme.white
                        background:
                            Rectangle
                            {
                                border.width: 0
                                color: currTheme.secondaryBackground
                            }
                    }
            }
        }
        Rectangle
        {
            id: frameRegion
            color: currTheme.mainBackground
            height: 30 
            Layout.fillWidth: true
            Text
            {
                id: textRegion
                color: currTheme.white
                text: qsTr("Region")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 21 
                anchors.topMargin: 16 
                anchors.bottomMargin: 7 
            }
        }
        Rectangle
        {
            id: frameSelectRegion
            height: 60 
    //            width: 350 
            color: "transparent"
            Layout.fillWidth: true

            DapCustomComboBox {
                id: comboBoxRegion
                model: regionOrder

                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 10 
                anchors.leftMargin: 15 

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
            color: currTheme.mainBackground
            height: 30 
            Layout.fillWidth: true
            Text
            {
                id: textUnits
                color: currTheme.white
                text: qsTr("Units")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 22 
                anchors.topMargin: 16 
                anchors.bottomMargin: 7 
            }
        }
        Rectangle
        {
            id: frameSelectUnits
            height: 68 
    //            width: 350 
            color: "transparent"
            Layout.fillWidth: true

            Item
            {
                id:boxUnits
                anchors.right: parent.right
                anchors.rightMargin: 5 
                width: comboBoxUnit.widthPopupComboBoxNormal
                height: parent.height

                DapCustomComboBox {
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
                anchors.margins: 25 
                from: 0
                to: 2147483647
            }

        }
        Rectangle
        {
            id: framePrice
            color: currTheme.mainBackground
            height: 30 
            Layout.fillWidth: true
            Text
            {
                id: textPrice
                color: currTheme.white
                text: qsTr("Price")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 22 
                anchors.topMargin: 16 
                anchors.bottomMargin: 7 
            }
        }
        Rectangle
        {
            id: frameSelectPrice
            height: 68 
    //            width: 350 
            color: "transparent"
            Layout.fillWidth: true

            Item {
                id:boxPrice
                anchors.right: parent.right
                anchors.rightMargin: 5 
                width: comboBoxPrice.widthPopupComboBoxNormal
                height: parent.height

                DapCustomComboBox {
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
                anchors.margins: 25 
                from: 0
                to: 65535.0
                decimals: unitsModel.get(comboBoxPrice.currentIndex).decimals
            }
        }

        DapButton
        {
            id: buttonCreate
            implicitHeight: 36 
            implicitWidth: 132 
            Layout.topMargin: 58 
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
                    logicMainApp.requestToService();
                }
            }
        }

        Text
        {
            id: textOrderNameWarning
            Layout.minimumHeight: 60 
            Layout.maximumHeight: 60 
            Layout.margins: 0 
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: parent.width - 50 
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
