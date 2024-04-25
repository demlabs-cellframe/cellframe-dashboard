import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../Chart"
import "../../../controls"

Page
{

    background: Rectangle{color:"transparent"}
    id: createForm

    property string currentOrder: "Limit"

    Component.onCompleted:
    {
        walletModule.startUpdateFee()
    }

    Component.onDestruction:
    {
        walletModule.stopUpdateFee()
    }

    Connections
    {
        target: dapServiceController


    }

    ListModel
    {
        id: ordersRateType

        ListElement
        {
            name: qsTr("Limit")
            techName: "Limit"
        }
        ListElement
        {
            name: qsTr("Market")
            techName: "Market"
        }
    }

    ColumnLayout
    {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 42
        spacing: 12

        ListView
        {
            id: tabsView
            Layout.fillWidth: true

            orientation: ListView.Horizontal
            model: ordersRateType
            interactive: false
            height: 42
            currentIndex: 0
            onCurrentIndexChanged:
            {
                logicOrders.currentTabName = tabsModel.get(currentIndex).name
                logicOrders.currentTabTechName = tabsModel.get(currentIndex).techName
                ordersModule.currentTab = currentIndex
                navigator.clear()
            }

            delegate:
                Item{
                property int textWidth: tabName.implicitWidth
                property int spacing: 24
                height: 42
                width: textWidth + spacing*2

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: tabsView.currentIndex = index
                }

                Text{
                    id: tabName
                    anchors.centerIn: parent
                    height: parent.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    color: tabsView.currentIndex === index ? currTheme.white : currTheme.gray
                    font:  mainFont.dapFont.medium14
                    text: name

                    Behavior on color {ColorAnimation{duration: 200}}
                }
            }

            Rectangle
            {
                anchors.top: parent.bottom
                anchors.topMargin: -3
                width: tabsView.currentItem.width
                height: 2

                radius: 8
                x: tabsView.currentItem.x
                color: currTheme.lime

                Behavior on x {NumberAnimation{duration: 200}}
                Behavior on width {NumberAnimation{duration: 200}}
            }
        }

        Item
        {
            Layout.fillWidth: parent
            Layout.rightMargin: 15
            Layout.leftMargin: 15
            height: 166


            // "You pay" field
            Rectangle
            {
                height: 76
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                color: currTheme.mainBackground
                radius: 4
                border.color: currTheme.input
                border.width: 1

                Item
                {
                    id: payItem
                    anchors.fill: parent
                    anchors.margins: 12
                    Text
                    {
                        id: youPayText
                        height: 16
                        anchors.left: parent.left
                        anchors.top: parent.top
                        text: qsTr("You pay")
                        font: mainFont.dapFont.regular11
                        color: currTheme.lightGray
                    }

                    DapBalanceComponent
                    {
                        id: textBalance
                        height: 16
                        anchors.left: youPayText.right
                        anchors.top: parent.top
                        anchors.right: maxBtn.left
                        anchors.leftMargin: 4
                        anchors.rightMargin: 4
                        label: qsTr("Balance:")
                        textColor: currTheme.white
                        textFont: mainFont.dapFont.regular11
                        text: "10.5658979879879687698778"

                        Component.onCompleted:
                        {

                        }
                    }


                    Rectangle
                    {
                        id: maxBtn
                        anchors.right: parent.right
                        anchors.top: parent.top
                        color: currTheme.darkGreen
                        height: 16
                        width: 32
                        radius: 4
                        Text {
                            anchors.fill: parent
                            text: qsTr("MAX")
                            font: mainFont.dapFont.regular12
                            color: currTheme.lime
                            horizontalAlignment: Qt.AlignHCenter
                        }
                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {

                            }
                        }
                    }

                    Item
                    {
                        id: tokenPay
                        anchors.bottom: parent.bottom
                        anchors.left:  parent.left
                        width: textTokenName.width + imageArrow.width
                        height: 24
                        Text
                        {
                            id: textTokenName
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            font: mainFont.dapFont.medium20
                            text: qsTr("USDT")
                            color: currTheme.white
                            verticalAlignment: Qt.AlignBottom
                        }
                        Image
                        {
                            id: imageArrow
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 24
                            height: 24
                            source: "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_down_rect.svg"
                        }
                    }

                    Item
                    {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.left: tokenPay.right
                        height: 24

                        DapBigText
                        {
                            anchors.fill: parent
                            textElement.horizontalAlignment: Qt.AlignRight
                            textElement.verticalAlignment: Qt.AlignBottom
                            textFont: mainFont.dapFont.medium20
                            textColor: currTheme.white
                            fullText: "88.241234534545345345345345345345344"
                        }

                    }
                }

            }
            // You receive
            Rectangle
            {
                height: 76
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: currTheme.mainBackground
                radius: 4
                border.color: currTheme.input
                border.width: 1

                Item
                {
                    anchors.fill: parent
                    anchors.margins: 12
                    Text
                    {
                        id: youReceiveText
                        height: 16
                        anchors.left: parent.left
                        anchors.top: parent.top
                        text: qsTr("You pay")
                        font: mainFont.dapFont.regular11
                        color: currTheme.lightGray
                    }

                    DapBalanceComponent
                    {
                        id: textBalance2
                        height: 16
                        anchors.left: youReceiveText.right
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.leftMargin: 4
                        anchors.rightMargin: 4
                        label: qsTr("Balance:")
                        textColor: currTheme.white
                        textFont: mainFont.dapFont.regular11
                        text: "10.56589798"

                        Component.onCompleted:
                        {

                        }
                    }



                    Item
                    {
                        id: tokenReceive
                        anchors.bottom: parent.bottom
                        anchors.left:  parent.left
                        width: textToken2Name.width + imageArrow2.width
                        height: 24
                        Text
                        {
                            id: textToken2Name
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            font: mainFont.dapFont.medium20
                            text: qsTr("CELL")
                            color: currTheme.white
                            verticalAlignment: Qt.AlignBottom
                        }
                        Image
                        {
                            id: imageArrow2
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 24
                            height: 24
                            source: "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_down_rect.svg"
                        }
                    }

                    Item
                    {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.left: tokenReceive.right
                        height: 24

                        DapBigText
                        {
                            anchors.fill: parent
                            textElement.horizontalAlignment: Qt.AlignRight
                            textElement.verticalAlignment: Qt.AlignBottom
                            textFont: mainFont.dapFont.medium20
                            textColor: currTheme.white
                            fullText: "88.245344"
                        }
                    }
                }
            }

            Image{
                anchors.centerIn: parent
                source: "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_button.svg"
                width: 32
                height: 32
            }
        }

        Rectangle
        {
            height: 76
            Layout.fillWidth: parent
            Layout.rightMargin: 16
            Layout.leftMargin: 16
            color: currTheme.mainBackground
            radius: 4
            border.color: currTheme.input
            border.width: 1

        }

        Rectangle
        {
            height: 76
            Layout.fillWidth: parent
            Layout.rightMargin: 16
            Layout.leftMargin: 16
            color: currTheme.mainBackground
            radius: 4
            border.color: currTheme.input
            border.width: 1
        }

        Rectangle
        {
            height: 40
            Layout.fillWidth: parent
            Layout.rightMargin: 16
            Layout.leftMargin: 16
            color: currTheme.mainBackground
        }

        // CREATE BUTTON
        DapButton
        {
            id: createButton
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 12
            implicitHeight: 36
            implicitWidth: 132
            textButton: qsTr("Create")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            enabled: false
            onClicked: {console.log("create order")}
        }
    }
}

