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
                Layout.preferredHeight: 38 * pt
                Layout.alignment: Qt.AlignTop

                RowLayout
                {
                    anchors.fill: parent

                    DapButton
                    {
                        Layout.topMargin: 9 * pt
                        Layout.bottomMargin: 9 * pt
                        Layout.leftMargin: 17 * pt

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
                        Layout.topMargin: 11 * pt
                        Layout.bottomMargin: 8 * pt
//                        Layout.leftMargin: 13 * pt

                        id: textHeader
                        text: qsTr("Activated dApp")
                        verticalAlignment: Qt.AlignLeft
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                        color: currTheme.textColor
                    }
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }

            }

            // Header dApp
            Rectangle
            {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                color: currTheme.backgroundMainScreen
                Layout.preferredHeight: 30 * pt

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

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 49 * pt
//                        Layout.preferredHeight: 82 * pt

            }

                DapProgressBar
                {
                    id: bar_progress
                    Layout.alignment: Qt.AlignTop
//                    Layout.preferredWidth: 114 * pt
                    Layout.minimumWidth: 114 * pt
                    Layout.maximumWidth: 114 * pt
//                    Layout.topMargin: 49 * pt
                    Layout.leftMargin: 118 * pt
                    Layout.rightMargin: 118 * pt

                }

                Text{

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.topMargin: 13 * pt

                    id:_errors
                    color: currTheme.placeHolderTextColor
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter

                    text: "sadsadasd"
                }

                RowLayout
                {
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.topMargin: 30 * pt

                    Item {
                        Layout.preferredHeight: 80 * pt
                        Layout.preferredWidth: 150 * pt
                        Layout.leftMargin: 25 * pt
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
                            text: "sadsadasd"

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
                                text: "sadsadasd"

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
                                text: "sadsadasd"

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

                                text: qsTr("TIME REMAIN")

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
                        Layout.topMargin: 98 * pt
                        Layout.bottomMargin: 82 * pt
                        spacing: 17 * pt

                        DapButton
                        {
//                            Layout.alignment: Qt.AlignHCenter
//                            Layout.fillWidth: true
                            Layout.preferredHeight: 36 * pt
                            Layout.preferredWidth: 132 * pt
                            Layout.leftMargin: 35 * pt

                            implicitHeight: 36 * pt
                            implicitWidth: 132 * pt

                            id:reloadDownload
                            textButton: "Reload"
                            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                            horizontalAligmentText: Text.AlignHCenter
                        }

                        DapButton
                        {
//                            Layout.alignment: Qt.AlignHCenter
//                            Layout.fillWidth: true
                            Layout.preferredHeight: 36 * pt
                            Layout.preferredWidth: 132 * pt

                            implicitHeight: 36 * pt
                            implicitWidth: 132 * pt

                            id: canceledDownload
                            textButton: "Cancel"
                            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                            horizontalAligmentText: Text.AlignHCenter
                        }

                    }

//                    Item {
//                        Layout.fillHeight: true
//                        Layout.fillWidth: true

//                    }

                }






}   //root


