import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import "qrc:/widgets"
import "../../../"
import "../../controls"

DapRectangleLitAndShaded
{
//    dapButtonClose.normalImageButton: "qrc:/resources/icons/" + pathTheme + "/back_icon.png"
//    dapButtonClose.hoverImageButton: "qrc:/resources/icons/" + pathTheme + "/back_icon_hover.png"

//    dapButtonClose.heightImageButton: 14 
//    dapButtonClose.widthImageButton: 13 

    property alias dapButtonClose: itemButtonClose

    property alias dapButtonAction: actionButton
    property alias dapButtonNext: nextButton

    property alias dapTextMethod: textMethod

    property alias dapWordsGrid: wordsGrid
    property alias dapBackupFileName: backupFileName

    property alias dapTextTopMessage: textTopMessage
    property alias dapTextBottomMessage: textBottomMessage
    color: currTheme.backgroundElements
    radius: currTheme.radiusRectangle
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        //Header
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

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/back.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/back_hover.svg"
            }

            Text
            {

                id: textHeader
                text: qsTr("New wallet")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

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
            height: 30 
            Text
            {
                id: textMethod
                color: currTheme.textColor
                text: qsTr("Recovery method: 24 words")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        Item {
            Layout.preferredHeight: 48
            Layout.preferredWidth: 255
            Layout.topMargin: 20
            Layout.alignment: Qt.AlignHCenter
//            Layout.leftMargin: 48
//            Layout.rightMargin: 34

            Text
            {
                id: textTopMessage
                anchors.fill: parent

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#E4E111"
                wrapMode: Text.WordWrap
                font: mainFont.dapFont.regular12
            }
        }

        Grid {
            id: wordsGrid

            Layout.topMargin: 40
            Layout.minimumHeight: 151
            Layout.maximumHeight: 151
            Layout.alignment: Qt.AlignHCenter

            columns: 2

            columnSpacing: 50
//            rowSpacing: 5

            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter
            flow: Grid.TopToBottom

            Repeater {
                delegate: Text {
                    text: modelData
                    color: currTheme.textColor
                    font: mainFont.dapFont.regular12

                }
                model: wordsModel
            }
        }

        Text
        {
            id: backupFileName
            Layout.minimumHeight: 100 
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 36
            Layout.maximumWidth: parent.width - 50
            color: "#B4B1BD"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font: mainFont.dapFont.regular14
        }

        Rectangle
        {
            id: frameBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }

        Text
        {
            id: textBottomMessage
            Layout.minimumHeight: 48
            Layout.maximumWidth: 244
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.bottomMargin: 30
            color: "#BEFF00"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font: mainFont.dapFont.regular12
        }


        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            spacing: 14
            Layout.bottomMargin: 40

            DapButton
            {
                id: nextButton
                implicitHeight: 36 
                implicitWidth: 132 
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
                implicitHeight: 36 
                implicitWidth: 132 
                Layout.alignment: Qt.AlignCenter
                checkable: true
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular16
            }
        }
    }
}
