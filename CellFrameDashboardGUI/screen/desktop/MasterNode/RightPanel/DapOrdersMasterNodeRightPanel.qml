import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"
import "../../controls"
import "../../Settings/NodeSettings"


DapRectangleLitAndShaded
{
    id: root

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    Item
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 42

        HeaderButtonForRightPanels{
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 16

            id: itemButtonClose
            height: 20
            width: 20
            heightImage: 20
            widthImage: 20

            normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
            hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
            
            onClicked: dapRightPanel.push(baseMasterNodePanel)
        }

        Text
        {
            id: textHeader
            text: qsTr("Orders")
            horizontalAlignment: Qt.AlignLeft
            anchors.left: itemButtonClose.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10

            font: mainFont.dapFont.bold14
            color: currTheme.white
        }

        DapCustomComboBox
        {
            id: filterOrders
            height: 42
            width: 126 * pt
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 8
            rightMarginIndicator: 8
            leftMarginDisplayText: 20
            font: mainFont.dapFont.regular14
            mainTextRole: "displayName"
            defaultText: "All"
            backgroundColorShow: "transparent"

            model:
                ListModel {
                ListElement {
                    displayName: qsTr("All")
                    techName: "All"
                }
                ListElement {
                    displayName: qsTr("Personal")
                    techName: "Personal"
                }
            }

            onCurrentIndexChanged:
            {
                var tachName = model.get(currentIndex).techName
                if(tachName === "All")
                {
                    ordersModule.setPkeyFilterText(tachName)
                }
                else
                {
                    ordersModule.setPkeyFilterText(nodeMasterModule.getMasterNodeData("certHash"))
                }
            }
        }
    }

    contentData:
    ScrollView
    {
        id: scrollView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 42
        anchors.bottomMargin: 96

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        clip: true

        contentData:
            ColumnLayout
        {
            width: scrollView.width
            spacing: 20

            ListView
            {
                id: listView
                width: parent.width
                implicitHeight: contentHeight
                Layout.fillWidth: true
                clip: true
                model: modelOrdersProxy
                spacing: 0

                delegate:
                    Item
                {
                    width: listView.width
                    height: 94
                    anchors.left: listView.left

                    Rectangle
                    {
                        width: parent.width
                        height: 30
                        anchors.top: parent.top
                        anchors.left: parent.left
                        color: currTheme.mainBackground

                        Text
                        {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            font: mainFont.dapFont.regular12
                            horizontalAlignment: Text.AlignLeft
                            color: currTheme.white
                            text: created
                        }
                    }

                    Item
                    {
                        width: parent.width
                        height: 64
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left

                        Text
                        {
                            id: priceKeyText
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.topMargin: 12
                            anchors.leftMargin: 16
                            text: qsTr("Price")
                            font: mainFont.dapFont.regular13
                            color: currTheme.gray
                        }

                        DapBigText
                        {
                            id: priceValueText
                            height: 16
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: 12
                            anchors.leftMargin: 79
                            anchors.rightMargin: 16
                            fullText: model.price + " " + model.price_token
                            textFont: mainFont.dapFont.regular13
                            textColor: currTheme.white
                        }

                        Text
                        {
                            id: hashKeyText
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.bottomMargin: 12
                            anchors.leftMargin: 16
                            text: qsTr("Hash")
                            font: mainFont.dapFont.regular13
                            color: currTheme.gray
                        }

                        DapBigText
                        {
                            id: hashValueText
                            width: 80
                            height: 16
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.bottomMargin: 12
                            anchors.leftMargin: 79
                            fullText: model.hash
                            textFont: mainFont.dapFont.regular13
                            textColor: currTheme.white
                        }

                        DapCopyButton
                        {
                            width: 16
                            height: 16
                            onCopyClicked: hashValueText.copyFullText()
                            popupText: qsTr("Address copied")
                            anchors.left: hashValueText.right
                            anchors.verticalCenter: hashValueText.verticalCenter
                            anchors.leftMargin: 6
                        }
                    }
                }
            }
        }
    }

    // Buttons
    Item
    {
        height: 96
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        DapButton
        {
            id: buttonEditOrder

            width: 132
            implicitHeight: 36
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.left: parent.left
            anchors.leftMargin: 36
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            textButton: qsTr("Edit order")
            enabled: false

            onClicked:
            {
                console.log("Edit order clicked!")
            }
        }

        DapButton
        {
            id: buttonCreateOrder

            width: 132
            implicitHeight: 36
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.left: buttonEditOrder.right
            anchors.leftMargin: 14
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14
            textButton: qsTr("Create order")

            onClicked:
            {
                dapRightPanel.push(orderCreateMasterNodePanel)
            }
        }
    }

    Component.onCompleted:
    {
        //logicMainApp.requestToService("DapCertificateManagerCommands", 1)
        //logicMainApp.requestToService("DapGetListTokensCommand","")
        ordersModule.currentTab = 2
        ordersModule.statusProcessing = true

    }

    Component.onDestruction:
    {
        ordersModule.statusProcessing = false
    }
}



