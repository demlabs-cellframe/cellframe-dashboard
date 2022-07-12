import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../parts"
import "../../controls"

Page {
    id: root
    property alias closeButton: itemButtonClose

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 15 * pt

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

        ListModel
        {
            id: certificateInfoModel

            ListElement
            {
                key: "Amount of signatures"
                value: "5"
            }

            ListElement
            {
                key: "Hashes of signatures"
                value: "84ed78436ab128c654ee87643acd453b3a384ed78436ab128c654ee87643acd4\n\n84ed78436ab128c654ee87643acd453b3a384ed78436ab128c654ee87643acd4\n\n84ed78436ab128c654ee87643acd453b3a384ed78436ab128c654ee87643acd4\n\n84ed78436ab128c654ee87643acd453b3a384ed78436ab128c654ee87643acd4"
            }

            ListElement
            {
                key: "Minimum amount of signatures for emission"
                value: "2"
            }
        }


        ListView {
            id: certificateDataListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 22 * pt
            clip: true
            model: certificateInfoModel

            delegate: TitleTextView {
                x: 18 * pt
                title.text: model.key
                content.text: model.value
                title.color: currTheme.textColorGray
            }
        }
    }

    DapButton
    {
        implicitWidth: 165 * pt
        implicitHeight: 36 * pt
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24 * pt
        textButton: qsTr("Emission")
        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText:Qt.AlignCenter
        onClicked: navigator.emission()
    }
}



