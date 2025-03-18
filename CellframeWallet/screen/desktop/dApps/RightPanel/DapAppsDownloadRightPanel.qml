import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../controls"


DapRectangleLitAndShaded {

    id: root

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight
    property alias canceledButton: canceledDownload
    property alias reloadButton: reloadDownload
    property alias closeButton: buttonClose

    property alias progress_text: bar_progress
    property alias progress_bar: bar_progress

    property alias name: _name.text
    property alias total: _total.text
    property alias download: _download.text
    property alias speed: _speed.text
    property alias time: _time.text
    property alias errors: _errors

    property bool isOpen: false

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }
    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        //Name right panel
        Item {

            Layout.fillWidth: true
            height: 68 
            Layout.alignment: Qt.AlignTop
            Layout.bottomMargin: 0

            RowLayout
            {
                id: rowHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 42 

                HeaderButtonForRightPanels{
                    Layout.topMargin: 9 
                    Layout.bottomMargin: 8 
                    Layout.leftMargin: 24 

                    id: buttonClose
                    height: 20 
                    width: 20 
                    heightImage: 20 
                    widthImage: 20 

                    normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                    hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
                }

                Text
                {
                    Layout.topMargin: 12 
                    Layout.bottomMargin: 8 
//                        Layout.leftMargin: 13 

                    id: textHeader
                    text: qsTr("Activating dApp")
                    verticalAlignment: Qt.AlignLeft
                    font: mainFont.dapFont.bold14
                    color: currTheme.white
                }
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }

            // Header dApp
            Rectangle
            {
                anchors.top: rowHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                color: currTheme.mainBackground
                height: 30 

                Text
                {
                    id: _name
                    color: currTheme.white
                    text: qsTr("dApp")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                }
            }
        }

        DapProgressBar
        {
            id: bar_progress
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.topMargin: 41 
        }

        Text{

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: 5 

            id:_errors
            color: currTheme.lightGreen
            font: mainFont.dapFont.regular14
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter

            text: ""
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.topMargin: 47 

            Item {
                Layout.preferredHeight: 80 
                Layout.preferredWidth: 150 
                Layout.leftMargin: 27 
                //Total
                Text{

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    id:_total


                    color: currTheme.white;
                    font: mainFont.dapFont.medium20
                    horizontalAlignment: Text.AlignHCenter
                }
                Text{

                    anchors.top: _total.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 7 

                    text: qsTr("TOTAL")

                    color: currTheme.gray
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Item
            {
                Layout.preferredHeight: 80 
                Layout.preferredWidth: 150 
                Layout.rightMargin: 25 

                //Speed
                Text{

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    id:_speed

                    color: currTheme.white;
                    font: mainFont.dapFont.medium20
                    horizontalAlignment: Text.AlignHCenter
                }
                Text{

                    anchors.top: _speed.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 7 
                    anchors.rightMargin: 6 

                    text: qsTr("SPEED")

                    color: currTheme.gray
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true

            Item
            {
                Layout.preferredHeight: 80 
                Layout.preferredWidth: 150 
                Layout.leftMargin: 25 
                //Download
                Text{

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    id:_download

                    color: currTheme.white;
                    font: mainFont.dapFont.medium20
                    horizontalAlignment: Text.AlignHCenter
                }
                Text{

                    anchors.top: _download.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 7 

                    text: qsTr("DOWNLOAD")

                    color: currTheme.gray
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Item
            {
                Layout.preferredHeight: 80 
                Layout.preferredWidth: 150 
                Layout.rightMargin: 25 
                //Time remain
                Text{

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    id:_time

                    color: currTheme.white;
                    font: mainFont.dapFont.medium20
                    horizontalAlignment: Text.AlignHCenter
                }
                Text{

                    anchors.top: _time.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 7 
                    anchors.rightMargin: 4 


                    text: qsTr("TIME REMAIN")

                    color: currTheme.gray
                    font: mainFont.dapFont.regular12
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        RowLayout
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 66 
            Layout.leftMargin: 2 
            Layout.bottomMargin: 108 
            spacing: 17 

            DapButton
            {
                Layout.preferredHeight: 36 
                Layout.preferredWidth: 132 
                Layout.leftMargin: 35 

                implicitHeight: 36 
                implicitWidth: 132 
//                radius: currTheme.frameRadius

                id:reloadDownload
                textButton: qsTr("Reload")
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter
            }

            DapButton
            {
                Layout.preferredHeight: 36 
                Layout.preferredWidth: 132 

                implicitHeight: 36 
                implicitWidth: 132 
//                radius: currTheme.frameRadius

                id: canceledDownload
                textButton: qsTr("Cancel")
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter
            }

        }
    }

    Component.onCompleted:
    {
        dAppsLogic.clearData()
    }

}   //root



