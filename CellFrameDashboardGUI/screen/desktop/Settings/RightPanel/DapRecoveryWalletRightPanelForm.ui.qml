import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import "qrc:/widgets"
import "../../../"
import "../../controls"

Page
{
//    dapButtonClose.normalImageButton: "qrc:/resources/icons/" + pathTheme + "/back_icon.png"
//    dapButtonClose.hoverImageButton: "qrc:/resources/icons/" + pathTheme + "/back_icon_hover.png"

//    dapButtonClose.heightImageButton: 14 * pt
//    dapButtonClose.widthImageButton: 13 * pt

    property alias dapButtonClose: itemButtonClose

    property alias dapButtonAction: actionButton
    property alias dapButtonNext: nextButton

    property alias dapTextMethod: textMethod

    property alias dapWordsGrid: wordsGrid
    property alias dapBackupFileName: backupFileName

    property alias dapTextTopMessage: textTopMessage
    property alias dapTextBottomMessage: textBottomMessage

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        //Header
        Item
        {
            Layout.fillWidth: true
            height: 38 * pt

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 7 * pt
                anchors.leftMargin: 24 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImage: 20 * pt
                widthImage: 20 * pt

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/back.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/back_hover.svg"
            }

            Text
            {

                id: textHeader
                text: qsTr("New wallet")
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
        //Body
        Rectangle
        {
            id: frameMethod
            Layout.fillWidth: true
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Text
            {
                id: textMethod
                color: currTheme.textColor
                text: qsTr("Recovery method: 24 words")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        Item {
            Layout.preferredHeight: 69 * pt
            Layout.preferredWidth: 278 * pt
            Layout.topMargin: 24 * pt
            Layout.leftMargin: 38 * pt
            Layout.rightMargin: 34 * pt

            Text
            {
                id: textTopMessage
                anchors.fill: parent

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#79FFFA"
                wrapMode: Text.WordWrap
                font: mainFont.dapFont.regular14
            }
        }

        Grid {
            id: wordsGrid

            Layout.topMargin: 24 * pt
            Layout.minimumHeight: 255 * pt
            Layout.maximumHeight: 255 * pt
            Layout.alignment: Qt.AlignHCenter

            columns: 2

            columnSpacing: 50 * pt

            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter
            flow: Grid.TopToBottom

            Repeater {
                delegate: Text {
                    text: modelData
//                        font { bold: true; pixelSize: 12 }
                    color: currTheme.textColor
                    font: mainFont.dapFont.regular16

                }
                model: wordsModel
            }
        }

        Text
        {
            id: backupFileName
            Layout.minimumHeight: 100 * pt
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: parent.width - 50 * pt
            color: "#908D9D"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font: mainFont.dapFont.regular14
        }

        Text
        {
            id: textBottomMessage
            Layout.minimumHeight: 100 * pt
            Layout.maximumWidth: parent.width - 50 * pt
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 15 * pt
            color: "#B3FF00"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font: mainFont.dapFont.regular14
        }


        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 17 * pt
            Layout.topMargin: 17 * pt

            DapButton
            {
                id: nextButton
                implicitHeight: 36 * pt
                implicitWidth: 132 * pt
                Layout.alignment: Qt.AlignCenter
                textButton: qsTr("Next")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular16
                visible: false
            }

            DapButton
            {
                id: actionButton
                implicitHeight: 36 * pt
                implicitWidth: 132 * pt
                Layout.alignment: Qt.AlignCenter
                checkable: true
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular16
            }

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
