import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
//import "../../"
import "../Parts"

Page {

    //property alias dapOrderIndex: textTotalUsers
    property alias buttonClose: itemButtonClose
    property alias textHeader: textHeader

    property var modelValue

    background: Rectangle {
        color: "transparent"
    }


    Item
    {
        id: header
        width: parent.width
        height: 38 * pt
        DapButton
        {
            anchors.left: parent.left
            anchors.right: textHeader.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 9 * pt
            anchors.bottomMargin: 8 * pt
            anchors.leftMargin: 24 * pt
            anchors.rightMargin: 13 * pt

            id: itemButtonClose
            height: 20 * pt
            width: 20 * pt
            heightImageButton: 10 * pt
            widthImageButton: 10 * pt
            activeFrame: false
            normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
            hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"

            onClicked: navigator.popPage()

        }

        Text
        {
            id: textHeader
            text: qsTr("Order details")
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

    property var listModel:
        [{ key: "Location", propValue: modelValue.Location},
        { key: "Chain Net", propValue: modelValue.ChainNet},
        { key: "Name", propValue: modelValue.Name},
        { key: "Address", propValue: modelValue.Address},
        { key: "Port", propValue: modelValue.Port},
        { key: "Ext", propValue: modelValue.Ext},
        { key: "Price", propValue: modelValue.Price},
        { key: "Price Units", propValue: modelValue.PriceUnits},
        { key: "Price Token", propValue: modelValue.PriceToken},
        { key: "Node Address", propValue: modelValue.NodeAddress},
        { key: "State", propValue: modelValue.State}]


        ListView
        {
            width: parent.width - x * 2
            height: parent.height - y
            y: header.y + header.height + 20 * pt
            x: 16 * pt
            model: listModel
            clip: true

            delegate: Item
            {
                width: parent.width
                height: 70 * pt
                Text
                {
                    id: titleText1
                    font: mainFont.dapFont.regular12
                    color: currTheme.textColor
                    text: modelData.key
                }

                Text
                {
                    id: valueText1
                    y: titleText1.height + 10 * pt
                    font: mainFont.dapFont.regular14
                    color: currTheme.textColor
                    text: modelData.propValue
                }
            }
        }


        Item {
            Layout.fillHeight: true
        }
}
