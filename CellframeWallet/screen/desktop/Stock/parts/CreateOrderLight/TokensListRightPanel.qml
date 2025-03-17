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

    Item
    {
        id: headerItem
        height: 42
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        HeaderButtonForRightPanels
        {
            id: itemButtonClose
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 16

            height: 20
            width: 20
            heightImage: 20
            widthImage: 20
            normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
            hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
            onClicked:
            {
                goToRightHome()
            }
        }

        Text
        {
            id: textHeader
            text: qsTr("Select a token")
            horizontalAlignment: Qt.AlignLeft
            anchors.left: itemButtonClose.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
        }
    }

    Item
    {
        id: searchItem
        height: 24
        anchors.top: headerItem.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 12
        anchors.topMargin: 10

        Image
        {
            id: searchIcon
            width: 20
            height: 20
            anchors.left: parent.left
            anchors.top: parent.top
            source: "qrc:/Resources/"+ pathTheme +"/icons/other/search.svg"
            mipmap: true
        }

        DapTextField
        {
            id: searchBox
            height: 20
            anchors.left: parent.left
            anchors.leftMargin: 26
            anchors.top: parent.top
            anchors.right: parent.right
            backgroundColor: "transparent"
            validator: RegExpValidator { regExp:  /[0-9A-Za-z\-\_\:\.\,\(\)\?\@\\\/\s*]+/ }
            placeholderText: qsTr("Search by name")
            placeholderColor: currTheme.input
            font: mainFont.dapFont.regular14
            bottomLineVisible: false

            onTextChanged:
            {
                modelTokensList.searchQuery(text)
            }

            Keys.onReturnPressed: focus = true

            Component.onCompleted: forceActiveFocus()
        }

        Rectangle
        {
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: currTheme.input
        }
    }

    ListView
    {
        id: tokensListView
        anchors.top: searchItem.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 10
        clip: true
        ScrollBar.vertical: ScrollBar { active: true }
        model: modelTokensList

        delegate:
            Item
        {
            id: tokenDelegate
            width: tokensListView.width
            height: 48

            Rectangle
            {
                anchors.fill: parent
                color: area.containsMouse ? currTheme.rowHover : currTheme.secondaryBackground

                Text
                {
                    id: tokenName
                    height: 18
                    width: 60
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    font: mainFont.dapFont.medium14
                    text: displayText
                    color: currTheme.white
                }

                DapBigText
                {
                    id: rateText
                    height: 18
                    anchors.left: tokenName.right
                    anchors.right: tokenText.left
                    anchors.leftMargin: 10
                    anchors.rightMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlign: Text.AlignRight
                    textElement.elide: Text.ElideRight
                    textFont: mainFont.dapFont.medium14
                    fullText: rate
                }

                Text
                {
                    id: tokenText
                    height: 18
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    color: currTheme.white
                    font: mainFont.dapFont.medium14
                    text: token
                }

                Rectangle
                {
                    height: 1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    color: currTheme.mainBackground
                }

                MouseArea
                {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:
                    {
                         goToRightHome()
                        if(type === "sell")
                        {
                            dexModule.setCurrentTokenSell(displayText)
                        }
                        else
                        {
                            dexModule.setCurrentTokenBuy(displayText)
                        }

                    }
                }
            }
        }

        Rectangle
        {
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            color: currTheme.mainBackground
        }
    }
}

