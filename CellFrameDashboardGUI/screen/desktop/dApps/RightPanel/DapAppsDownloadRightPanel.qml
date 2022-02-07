import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "qrc:/widgets"


DapRectangleLitAndShaded {

    id: root

    color: currTheme.backgroundElements
    radius: currTheme.radiusRectangle
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
            height: 68 * pt
            Layout.alignment: Qt.AlignTop
            Layout.bottomMargin: 0

            RowLayout
            {
                id: rowHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 38 * pt

                DapButton
                {
                    Layout.topMargin: 9 * pt
                    Layout.bottomMargin: 8 * pt
                    Layout.leftMargin: 24 * pt

                    id: buttonClose
                    Layout.preferredHeight: 20 * pt
                    Layout.preferredWidth: 20 * pt
                    heightImageButton: 10 * pt
                    widthImageButton: 10 * pt
                    activeFrame: false
                    normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
                    hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"
                }

                Text
                {
                    Layout.topMargin: 12 * pt
                    Layout.bottomMargin: 8 * pt
//                        Layout.leftMargin: 13 * pt

                    id: textHeader
                    text: qsTr("Activating dApp")
                    verticalAlignment: Qt.AlignLeft
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                    color: currTheme.textColor
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

                color: currTheme.backgroundMainScreen
                height: 30 * pt

                Text
                {
                    id: _name
                    color: currTheme.textColor
                    text: qsTr("dApp")
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
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
            Layout.topMargin: 41 * pt
        }

        Text{

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: 5 * pt

            id:_errors
            color: currTheme.placeHolderTextColor
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter

            text: ""
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.topMargin: 47 * pt

            Item {
                Layout.preferredHeight: 80 * pt
                Layout.preferredWidth: 150 * pt
                Layout.leftMargin: 27 * pt
                //Total
                Text{

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    id:_total


                    color: currTheme.textColor;
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium20
                    horizontalAlignment: Text.AlignHCenter
                }
                Text{

                    anchors.top: _total.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 7 * pt

                    text: qsTr("TOTAL")

                    color: currTheme.placeHolderTextColor
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Item
            {
                Layout.preferredHeight: 80 * pt
                Layout.preferredWidth: 150 * pt
                Layout.rightMargin: 25 * pt

                //Speed
                Text{

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    id:_speed

                    color: currTheme.textColor;
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium20
                    horizontalAlignment: Text.AlignHCenter
                }
                Text{

                    anchors.top: _speed.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 7 * pt
                    anchors.rightMargin: 6 * pt

                    text: qsTr("SPEED")

                    color: currTheme.placeHolderTextColor
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
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
                Layout.preferredHeight: 80 * pt
                Layout.preferredWidth: 150 * pt
                Layout.leftMargin: 25 * pt
                //Download
                Text{

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    id:_download

                    color: currTheme.textColor;
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium20
                    horizontalAlignment: Text.AlignHCenter
                }
                Text{

                    anchors.top: _download.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 7 * pt

                    text: qsTr("DOWNLOAD")

                    color: currTheme.placeHolderTextColor
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Item
            {
                Layout.preferredHeight: 80 * pt
                Layout.preferredWidth: 150 * pt
                Layout.rightMargin: 25 * pt
                //Time remain
                Text{

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    id:_time

                    color: currTheme.textColor;
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium20
                    horizontalAlignment: Text.AlignHCenter
                }
                Text{

                    anchors.top: _time.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 7 * pt
                    anchors.rightMargin: 4 * pt


                    text: qsTr("TIME REMAIN")

                    color: currTheme.placeHolderTextColor
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        RowLayout
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 66 * pt
            Layout.leftMargin: 2 * pt
            Layout.bottomMargin: 108 * pt
            spacing: 17 * pt

            DapButton
            {
                Layout.preferredHeight: 36 * pt
                Layout.preferredWidth: 132 * pt
                Layout.leftMargin: 35 * pt

                implicitHeight: 36 * pt
                implicitWidth: 132 * pt
//                radius: currTheme.radiusRectangle

                id:reloadDownload
                textButton: "Reload"
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter
            }

            DapButton
            {
                Layout.preferredHeight: 36 * pt
                Layout.preferredWidth: 132 * pt

                implicitHeight: 36 * pt
                implicitWidth: 132 * pt
//                radius: currTheme.radiusRectangle

                id: canceledDownload
                textButton: "Cancel"
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter
            }

        }
    }

}   //root



