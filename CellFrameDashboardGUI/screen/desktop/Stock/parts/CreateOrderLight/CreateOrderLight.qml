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

    state: "Limit"
    states: [
        State {
            name: "Limit"
        },
        State {
            name: "Market"
        }
    ]

    ListView
    {
        id: tabsView
        height: 42
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        orientation: ListView.Horizontal
        model: ordersRateType
        interactive: false

        currentIndex: 0
        onCurrentIndexChanged:
        {
            createForm.state = model.get(currentIndex).techName
            logicOrders.currentTabName = model.get(currentIndex).name
            logicOrders.currentTabTechName = model.get(currentIndex).techName
            ordersModule.currentTab = currentIndex
            navigator.clear()
        }

        delegate:
            Item
        {
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

    // "You pay" and "Receive" block
    Item
    {
        id: payReceiveItem
        height: payRect.height + receiveRect.height + 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: tabsView.bottom
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.topMargin: 20

        Rectangle
        {
            id: payRect
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
                    text: "10.565897987987"
                }

                Rectangle
                {
                    id: maxBtn
                    anchors.right: parent.right
                    anchors.rightMargin: 3
                    anchors.top: parent.top
                    color: maxBtnMouseArea.containsMouse ? currTheme.lightGreen2 : currTheme.darkGreen
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
                        id: maxBtnMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
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
                    anchors.leftMargin: 4
                    height: 24

                    DapBigText
                    {
                        anchors.fill: parent
                        horizontalAlign: Qt.AlignRight
                        verticalAlign: Qt.AlignBottom
                        textFont: mainFont.dapFont.medium20
                        textElement.elide: Text.ElideRight
                        fullText: "88.24"
                    }
                }
            }
        }

        // arrow between

        Item
        {
            width: 24
            height: 24
            anchors.centerIn: parent
            z: parent.z + 1

            Image
            {
                width: 32
                height: 32
                anchors.centerIn: parent
                source: arrowMouseArea.containsMouse ? "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_button_hover.svg" : "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_button.svg"
                rotation: arrowMouseArea.containsMouse ? -180 : 0

                Behavior on rotation {NumberAnimation{duration: 100}}
            }

            MouseArea
            {
                id: arrowMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    console.log("arrow clicked")
                }
            }
        }

        // "You receive" field
        Rectangle
        {
            id: receiveRect
            height: 76
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: payRect.bottom
            anchors.topMargin: 12
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
                    text: qsTr("You receive")
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
                    anchors.rightMargin: 3
                    label: qsTr("Balance:")
                    textColor: currTheme.white
                    textFont: mainFont.dapFont.regular11
                    text: "10.5658979000000"

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
                        horizontalAlign: Qt.AlignRight
                        verticalAlign: Qt.AlignBottom
                        textFont: mainFont.dapFont.medium20
                        textElement.elide: Text.ElideRight
                        fullText: "88.245344283967287387587482736496958"
                    }
                }
            }
        }
    }

    // rectangles for limit
    Item
    {
        id: limitRectanglesItem
        height: payRateRect.height + expiresRect.height + 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: payReceiveItem.bottom
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.topMargin: 12
        visible: createForm.state === "Limit"

        // "Pay at rate" field
        Rectangle
        {
            id: payRateRect
            height: 76
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
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
                    height: 16
                    anchors.left: parent.left
                    anchors.top: parent.top
                    text: qsTr("Pay ") + textTokenName.text + qsTr(" at rate")
                    font: mainFont.dapFont.regular11
                    color: currTheme.lightGray
                }
                Text
                {
                    height: 16
                    anchors.right: parent.right
                    anchors.top: parent.top
                    text: qsTr("Set to market")
                    font: mainFont.dapFont.regular11
                    color: currTheme.lime
                }
                Text
                {
                    id: payRateText
                    height: 24
                    anchors.bottom: parent.bottom
                    anchors.left:  parent.left
                    anchors.right: switchButton.left
                    font: mainFont.dapFont.medium20
                    text: "1.1213435235264344"
                    color: currTheme.white
                    verticalAlignment: Qt.AlignBottom
                }
                Rectangle
                {
                    id: switchButton
                    width: tokenSwitch.contentWidth + imageArrows.width + 6
                    height: 16
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 4
                    anchors.rightMargin: 2
                    color:  payRateMouseArea.containsMouse ? currTheme.tokenChangeButtonHover : currTheme.tokenChangeButton
                    radius: 4
                    Text
                    {
                        id: tokenSwitch
                        height: parent.height
                        text: textToken2Name.text
                        anchors.left: parent.left
                        anchors.leftMargin: 3
                        font: mainFont.dapFont.medium12
                        color: currTheme.inputActive
                        verticalAlignment: Text.AlignVCenter
                    }
                    Image
                    {
                        id: imageArrows
                        width: 16
                        height: 16
                        anchors.right: parent.right
                        anchors.rightMargin: 3
                        source: "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_left_right.svg"
                    }
                    MouseArea
                    {
                        id: payRateMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:
                        {
                            console.log("change tokens clicked")
                        }
                    }
                }
            }
        }

        // "Expires" field
        Rectangle
        {
            id: expiresRect
            height: 76
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: payRateRect.bottom
            anchors.topMargin: 12
            color: currTheme.mainBackground
            radius: 4
            border.color: currTheme.input
            border.width: 1
            opacity: 0.4

            Item
            {
                anchors.fill: parent
                anchors.margins: 12
                Text
                {
                    id: expiresLabelText
                    height: 16
                    anchors.left: parent.left
                    anchors.top: parent.top
                    text: qsTr("Expires in")
                    font: mainFont.dapFont.regular11
                    color: currTheme.lightGray
                }
                Item {
                    width: 16
                    height: 16
                    anchors.left: expiresLabelText.right
                    anchors.leftMargin: 2
                    anchors.top: parent.top

                    Image
                    {
                        anchors.fill: parent
                        mipmap: true
                        source: "qrc:/Resources/"+ pathTheme +"/icons/other/ic_info_small.svg"
                    }

                    DapCustomToolTip
                    {
                        contentText: qsTr("Come back later")
                        visible: i_tooltipMouseArea.containsMouse
                    }

                    MouseArea
                    {
                        id: i_tooltipMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                Item
                {
                    height: 24
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    Text {
                        text: qsTr("7 Days")
                        anchors.left: parent.left
                        anchors.right: imageArrow3.left
                        anchors.rightMargin: 4
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font: mainFont.dapFont.medium20
                        color: currTheme.white
                        horizontalAlignment: Text.AlignLeft
                    }
                    Image
                    {
                        id: imageArrow3
                        width: 24
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        height: 24
                        source: "qrc:/Resources/"+ pathTheme +"/icons/other/arrow_down_rect.svg"
                    }
                    MouseArea
                    {
                        id: expiresMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:
                        {
                            console.log("select expires clicked")
                        }
                    }
                }
            }
        }
    }

    Rectangle
    {
        id: priceRect
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: limitRectanglesItem.visible ? limitRectanglesItem.bottom : payReceiveItem.bottom
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.topMargin: 12
        color: currTheme.mainBackground
        radius: 4

        Text
        {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            text: "1 USDT = 1,11 CELL"
            font: mainFont.dapFont.medium14
            color: currTheme.white
        }
    }

    // CREATE BUTTON
    DapButton
    {
        id: createButton
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.bottomMargin: 40
        anchors.topMargin: 12
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

