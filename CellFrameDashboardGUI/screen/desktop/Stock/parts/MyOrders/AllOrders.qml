import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "parts"
import "qrc:/widgets"

Item
{
    property var layoutCoeff:
        ( new Map
         ([
            ["Price", 80],
            ["Available", 80],
            ["Limit", 80],
            ["Button", 50]
          ])
        )

//    property string currentSide: "buy"

    anchors.fill: parent

    Component.onCompleted:
    {
        print("AllOrders currentSide", myOrdersTab.currentSide)
    }

    // Header
    Item
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 42

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.topMargin: 10
            anchors.bottomMargin: 10

            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Orders")
            font:  mainFont.dapFont.bold14
            color: currTheme.textColor
        }
    }

    ListView
    {
        id: list
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true
        model: allOrdersModel

        highlight:
            Rectangle
            {
                color: currTheme.placeHolderTextColor
                opacity: 0.12
            }
        highlightMoveDuration: 0

        headerPositioning:
            ListView.OverlayHeader
        header:
            Rectangle
            {
                width:parent.width
                height: 30
                color: currTheme.backgroundMainScreen
                z: 10

                RowLayout{
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 10

    //                Rectangle {
    //                    Layout.preferredWidth: layoutCoeff.get("Price")
    //                    Layout.fillWidth: true
    //                    height: 10
    //                    color: "blue"
    //                }

                    HeaderLabel{
                        Layout.preferredWidth: layoutCoeff.get("Price")
                        label.text: qsTr("Price")
                    }

                    HeaderLabel{
                        Layout.preferredWidth: layoutCoeff.get("Available")
                        label.text: qsTr("Available")
                    }
                    HeaderLabel{
                        Layout.preferredWidth: layoutCoeff.get("Limit")
                        label.text: qsTr("Limit")
                    }
    //                Rectangle {
    //                    Layout.preferredWidth: layoutCoeff.get("Button")
    //                    Layout.fillWidth: true
    //                    height: 10
    //                    color: "red"
    //                }
                    Item {
                        Layout.preferredWidth: layoutCoeff.get("Button")
                        Layout.fillWidth: true
                        height: 10
                    }
                }
            }
        delegate: allOrdersDelegate

        Component.onCompleted:
            currentIndex = -1
    }

    Component
    {
        id: allOrdersDelegate

        Item
        {
            id: delegate
            visible: side === myOrdersTab.currentSide
            anchors.left: parent.left
            anchors.right: parent.right
            height: visible ? 50 : 0

            Component.onCompleted:
            {
                print("allOrdersDelegate",
                      side, price, available, limit, tokenSell, tokenBuy)
            }

/*            MouseArea
            {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    list.currentIndex = index
                    frameDelegate.color = "transparent"
                    print("MouseArea", list.model.get(index).price)
                    logic.openBuySellDialog(list.model.get(index))
                }
                onEntered:
                    if(list.currentIndex !== index)
                        frameDelegate.color = currTheme.placeHolderTextColor
                onExited:
                        frameDelegate.color = "transparent"

            }*/

            RowLayout
            {
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                anchors.fill: parent
                spacing: 10

                DapBigNumberText
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: layoutCoeff.get("Price")
                    textFont: mainFont.dapFont.regular13
                    outSymbols: 15
//                    test: available
                    fullNumber: price
                    tokenName: list.model.get(index).side === "buy" ?
                                    list.model.get(index).tokenSell : list.model.get(index).tokenBuy
                    copyButtonVisible: true
                }

                DapBigNumberText
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: layoutCoeff.get("Available")
                    textFont: mainFont.dapFont.regular13
                    outSymbols: 15
                    fullNumber: available
                    tokenName: side === "buy" ?
                                    tokenSell : tokenBuy
                    copyButtonVisible: true
                }

                DapBigNumberText
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: layoutCoeff.get("Limit")
                    textFont: mainFont.dapFont.regular13
                    outSymbols: 15
                    fullNumber: limit
                    tokenName: side === "buy" ?
                                    tokenSell : tokenBuy
                    copyButtonVisible: true
                }

/*                HeaderLabel{
                    Layout.preferredWidth: layoutCoeff.get("Available")
                    label.text: available + " " +
                                (side == "buy" ?
                                     tokenSell : tokenBuy)
                    label.font: mainFont.dapFont.regular13
                }
                HeaderLabel{
                    Layout.preferredWidth: layoutCoeff.get("Limit")
                    label.text: limit + " " +
                                (side == "buy" ?
                                     tokenSell : tokenBuy)
                    label.font: mainFont.dapFont.regular13
                }*/

                Item
                {
                    Layout.preferredWidth: layoutCoeff.get("Button")
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    height: 20
//                    color: "green"

                    DapButton
                    {
                        id: buysellButton
                        anchors.centerIn: parent
                        implicitWidth: 100
                        implicitHeight: 25
                        defaultColorNormal0:
                            side == "buy" ?
                                currTheme.textColorGreen :
                                currTheme.textColorRed
                        defaultColorNormal1:
                            side == "buy" ?
                                currTheme.textColorGreen :
                                currTheme.textColorRed
                        defaultColorHovered0:
                            side == "buy" ?
                                currTheme.textColorGreenHovered :
                                currTheme.textColorRedHovered
                        defaultColorHovered1:
                            side == "buy" ?
                                currTheme.textColorGreenHovered :
                                currTheme.textColorRedHovered
                        textButton:
                            side == "buy" ?
                                qsTr("Buy ") + tokenBuy :
                                qsTr("Sell ") + tokenSell
                        horizontalAligmentText: Text.AlignHCenter
                        indentTextRight: 0
                        fontButton: mainFont.dapFont.medium14

                        onClicked:
                        {
                            list.currentIndex = index
                            frameDelegate.color = "transparent"
                            print("DapButton", list.model.get(index).price)
                            logic.openBuySellDialog(list.model.get(index))
                        }
                    }

                }

/*                HeaderLabel{
                    Layout.preferredWidth: layoutCoeff.get("Button")
//                    label.text: limit
                    label.font: mainFont.dapFont.regular13
                }*/
/*                HeaderLabel{
                    id: cancel
                    Layout.preferredWidth: layoutCoeff.get("Button")
                    Layout.maximumWidth: 69
//                    Layout.minimumWidth: 69
                    label.text: qsTr("Cancel")
                    label.font: mainFont.dapFont.regular13
                    label.color: mouseArea.containsMouse ?
                                     currTheme.textColorRed :
                                     currTheme.hilightColorComboBox
                    MouseArea{
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            logicStock.cancelationOrder(index)
                            logic.initOrdersModels()
                        }
                    }
                }*/
            }

            Rectangle{
                id:frameDelegate
                anchors.fill: parent
                color: "transparent"
                opacity: 0.12
            }

            Rectangle{
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                height: 1
                color: currTheme.lineSeparatorColor
            }
        }
    }

    Connections{
        target: myOrdersTab

        onClosedDetailsSignal:
        {
            list.currentIndex = -1
        }
    }

}
