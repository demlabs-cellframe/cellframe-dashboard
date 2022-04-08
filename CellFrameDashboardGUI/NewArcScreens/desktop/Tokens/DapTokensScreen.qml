import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"

DapAbstractScreen {

    id: dapTokenScreen

    property alias delegateComponent: delegateTokenView
    signal selectedIndex(int index)
    signal infoClicked(int index)

   property bool isCurrentIndex:false

    anchors
    {
        top: parent.top
        topMargin: 24 * pt
        right: parent.right
        rightMargin: 44 * pt
        left: parent.left
        leftMargin: 24 * pt
        bottom: parent.bottom
        bottomMargin: 20 * pt
    }

    // Paths to currency emblems
    property string bitCoinImagePath: "qrc:/resources/icons/tkn1_icon_light.png"
    property string ethereumImagePath: "qrc:/resources/icons/tkn2_icon.png"
    property string newGoldImagePath: "qrc:/resources/icons/ng_icon.png"
    property string kelvinImagePath: "qrc:/resources/icons/ic_klvn.png"
    ///@param dapButtonNewPayment Button to create a new payment.
//    property alias dapButtonNewPayment: buttonNewPayment
    property alias dapListViewTokens: listViewTokens
//    property alias dapNameWalletTitle: titleText
//    property alias dapTitleBlock: titleBlock
    property alias dapMainFrameTokens: mainFrameTokens

    Rectangle
    {
        id: mainFrameTokens
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: 16*pt

        // Header
        Item
        {
            id: tokensShowHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
//            width: parent.width
            height: 38 * pt
//            color: currTheme.backgroundElements
//            radius: 16*pt
            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 18 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
//                    anchors.verticalCenter: parent.verticalCenter

                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Tokens")
                font:  _dapQuicksandFonts.dapFont.bold14
                color: currTheme.textColor
            }
        }

        ListView
        {
            id: listViewTokens
//            anchors.fill: parent
            anchors.top: tokensShowHeader.bottom
//            anchors.topMargin: 20 * pt
            anchors.bottom: parent.bottom
//            anchors.leftMargin: 20 *pt
//            anchors.rightMargin: 10 *pt
            anchors.left: parent.left
            anchors.right: parent.right
//            spacing: 5 * pt
            clip: true
            currentIndex: -1

            delegate: delegateTokenView
        }

        Component
        {
            id: delegateTokenView
            Column
            {
                id: delegateToken
                width: parent.width

                Rectangle
                {
                    id: stockNameBlock
                    height: 30 * pt
                    width: parent.width
                    color: currTheme.backgroundMainScreen

                    Text
                    {
                        id: stockNameText
                        anchors.left: parent.left
                        anchors.leftMargin: 16 * pt
                        anchors.verticalCenter: parent.verticalCenter
                        font: _dapQuicksandFonts.dapFont.medium11
                        color: currTheme.textColor
                        verticalAlignment: Qt.AlignVCenter
                        text: name
                    }
                }

                Repeater
                {
                    width: parent.width
                    model: tokens

                    Rectangle
                    {
                        anchors.left: parent.left
                        anchors.leftMargin: 13 * pt
                        anchors.right: parent.right
                        anchors.rightMargin: 16 * pt
                        height: 50 * pt
                        color: currTheme.backgroundElements

                        Rectangle
                        {
                            anchors.top: tokenInfoPlace.bottom
                            width: parent.width
                            height: 1 * pt
                            color: currTheme.lineSeparatorColor
                        }

                        Item
                        {
                            id:tokenInfoPlace
                            anchors.fill: parent
                            anchors.bottomMargin: 1*pt

                            Text
                            {
                                id: currencyName
                                anchors.left: parent.left
                                font: _dapQuicksandFonts.dapFont.regular16
                                color: model.selected ? "#FF0080" : currTheme.textColor
                                text: name + " (" + currencyCode.text + ")"
                                width: 172 * pt
                                horizontalAlignment: Text.AlignLeft
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10*pt

                            }

                            Text
                            {
                                id: currencySum
//                                    Layout.fillWidth: true
                                anchors.right: currencyCode.left
                                anchors.rightMargin: 5 * pt
                                font: _dapQuicksandFonts.dapFont.regular14
                                color: model.selected ? "#FF0080" : currTheme.textColor
                                text: full_balance
                                horizontalAlignment: Text.AlignRight
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10*pt
                            }

                            Text
                            {
                                id: currencyCode
                                anchors.right: parent.right
                                font: _dapQuicksandFonts.dapFont.regular14
                                color: isCurrentIndex ? "#FF0080" : currTheme.textColor
                                text: name
                                horizontalAlignment: Text.AlignRight
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10*pt
                            }
                        }
                        MouseArea{
                            id: delegateClicked
                            width: parent.width
                            height: parent.height
                            onClicked: {
                                listViewTokens.currentIndex = index
                                isCurrentIndex = true
                                selectedIndex(model.index)

                            }

                            onDoubleClicked: {
                                infoClicked(model.index)
                                //root.selectedIndex(model.index)
                            }
                        }

                    }
                    Component.onCompleted:
                    {
                        listViewTokens.currentIndex = -1;
                    }
                }
            }
        }
    }
    InnerShadow {
        id: topLeftSadow
        anchors.fill: mainFrameTokens
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: mainFrameTokens
        visible: mainFrameTokens.visible
    }
    InnerShadow {
        anchors.fill: mainFrameTokens
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
        visible: mainFrameTokens.visible
    }

}
