import QtQuick 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"

DapRightPanel
{
    dapButtonClose.normalImageButton: "qrc:/resources/icons/" + pathTheme + "/back_icon.png"
    dapButtonClose.hoverImageButton: "qrc:/resources/icons/" + pathTheme + "/back_icon_hover.png"

    dapButtonClose.heightImageButton: 14 * pt
    dapButtonClose.widthImageButton: 13 * pt

    property alias dapButtonAction: actionButton
    property alias dapButtonNext: nextButton

    property alias dapTextMethod: textMethod

    property alias dapWordsGrid: wordsGrid
    property alias dapBackupFileName: backupFileName

    property alias dapTextTopMessage: textTopMessage
    property alias dapTextBottomMessage: textBottomMessage

    dapHeaderData:
        Item
        {
            anchors.fill: parent
            Item
            {
                id: itemButtonClose
                data: dapButtonClose
                height: dapButtonClose.height
                width: dapButtonClose.width
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 9 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 24 * pt
                anchors.rightMargin: 13 * pt

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

                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
            }
        }

    dapContentItemData:
        ColumnLayout {
            anchors.fill: parent
            spacing: 0 * pt

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
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
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
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
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
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16

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
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
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
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
            }


            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 17 * pt
                Layout.topMargin: 17 * pt

                DapButton
                {
                    id: actionButton
                    implicitHeight: 36 * pt
                    implicitWidth: 132 * pt
                    Layout.alignment: Qt.AlignCenter
                    checkable: true
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                }

                DapButton
                {
                    id: nextButton
                    implicitHeight: 36 * pt
                    implicitWidth: 132 * pt
                    Layout.alignment: Qt.AlignCenter
                    textButton: qsTr("Next")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    visible: false
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
