import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "../../controls"
import "qrc:/widgets"
import "../parts"


DapRectangleLitAndShaded {
    id: root

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
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
                onClicked:
                {
                    logicTokens.unselectToken()
                    navigator.clear()
                }
            }

            Text
            {
                id: textHeader
                text: qsTr("Info about token")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
//            Layout.topMargin: 12
//            Layout.leftMargin: 16
            clip: true

//            ScrollBar.vertical.policy: ScrollBar.AlwaysOn


            contentData:
            ColumnLayout
            {
                spacing: 16
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.leftMargin: 16

                DetailsText {
                    title.text: qsTr("Name")
                    content: detailsModel.get(0).name
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Auth signs")
                    content: detailsModel.get(0).auth_signs
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Type")
                    content: detailsModel.get(0).type
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Flags")
                    content: detailsModel.get(0).flags
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Decimals")
                    content: detailsModel.get(0).decimals
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Current supply")
                    content: mathWorker.balanceToCoins(detailsModel.get(0).current_supply)
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Total supply")
                    content: mathWorker.balanceToCoins(detailsModel.get(0).total_supply)
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Total emissions")
                    content: detailsModel.get(0).total_emissions
                    title.color: currTheme.gray
                }

                DetailsText {
                    visible: detailsModel.get(0).tsd.tsd_ticker_from !== ""
                    title.text: qsTr("Ticker from")
                    content: detailsModel.get(0).tsd.tsd_ticker_from
                    title.color: currTheme.gray
                }
                DetailsText {
                    visible: detailsModel.get(0).tsd.tsd_rate !== ""
                    title.text: qsTr("Ticker rate")
                    content: detailsModel.get(0).tsd.tsd_rate
                    title.color: currTheme.gray
                }

                Rectangle{
                    Layout.leftMargin: -16
                    Layout.rightMargin: -16
                    Layout.fillWidth: true
                    height: 30
                    color: currTheme.mainBackground

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 16
//                        Layout.leftMargin: 16
//                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font: mainFont.dapFont.medium12
                        color: currTheme.white
                        text: qsTr("Signatures")
                    }
                }


                //signs
                Repeater{
                    model: detailsModel.get(0).signatures

                    ColumnLayout{
                        spacing: 16

                        DetailsText {
                            title.text: qsTr("KEY")
                            content: model.sign_key
                            title.color: currTheme.gray
                            copyButton.visible: true
                        }
                        DetailsText {
                            title.text: qsTr("TYPE")
                            content: model.sign_type
                            title.color: currTheme.gray
                        }
                        DetailsText {
                            title.text: qsTr("Size")
                            content: model.sign_size
                            title.color: currTheme.gray
                        }
                        Rectangle{
                            Layout.leftMargin: -16
                            Layout.rightMargin: -16
                            Layout.fillWidth: true
                            height: 1
                            color: currTheme.mainBackground
                        }
                    }
                }


                Item{
                    height: 10
                }
            }
        }
        DapButton
        {
            enabled: false
            implicitWidth: 163
            implicitHeight: 36
            Layout.bottomMargin: 40
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            textButton: qsTr("Emission")
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText:Qt.AlignCenter
            onClicked: navigator.emission()
        }
    }
}



