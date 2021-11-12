import QtQuick 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
//    dapButtonClose.normalImageButton: "qrc:/resources/icons/back_icon.png"
//    dapButtonClose.hoverImageButton: "qrc:/resources/icons/back_icon_hover.png"

    property alias dapButtonAction: actionButton
    property alias dapButtonNext: nextButton

    property alias dapTextMethod: textMethod

    property alias dapWordsGrid: wordsGrid
    property alias dapBackupFileName: backupFileName

    property alias dapTextTopMessage: textTopMessage
    property alias dapTextBottomMessage: textBottomMessage

    dapHeaderData:
        Rectangle
        {
            id: frameHeaderItem
            anchors.fill: parent
            height: parent.height
            color: "transparent"
            Rectangle
            {
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 12 * pt
                color: "transparent"

                Item
                {
                    id: itemButtonBack
                    data: dapButtonClose
                    height: dapButtonClose.height
                    width: dapButtonClose.width
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text
                {
                    id: textHeader
                    text: qsTr("New wallet")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                    color: "#3E3853"
                    anchors.left: itemButtonBack.right
                    anchors.leftMargin: 12 * pt
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle
            {
                id: bottomBorder
                height: 1 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "#757184"
            }
        }

    dapContentItemData:
        ColumnLayout {
            anchors.fill: parent
            spacing: 20 * pt

            Rectangle
            {
                id: frameMethod
                Layout.fillWidth: true
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textMethod
                    color: "#ffffff"
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }

            Text
            {
                id: textTopMessage
                Layout.minimumHeight: 50 * pt
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: parent.width - 50 * pt
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#FF0300"
                wrapMode: Text.WordWrap
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
            }

            Grid {
                id: wordsGrid
                Layout.alignment: Qt.AlignHCenter
                spacing: 8
                columns: 3
                horizontalItemAlignment: Grid.AlignHCenter
                verticalItemAlignment: Grid.AlignVCenter
                flow: Grid.TopToBottom

                Repeater {
                    delegate: Text {
                        text: modelData
//                        font { bold: true; pixelSize: 12 }
                        color: "#070023"
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular16

                    }
                    model: wordsModel
                }
            }

            Text
            {
                id: backupFileName
                Layout.minimumHeight: 50 * pt
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: parent.width - 50 * pt
                color: "#908D9D"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
//                text: "D:\\WORK\\DEMLABS\\cellframe-dashboard\\CellFrameDashboardGUI\\screen\\desktop\\Dashboard\\RightPanel\\DapRecoveryWalletRightPanelForm.ui.qml"
            }


            Text
            {
                id: textBottomMessage
                Layout.minimumHeight: 50 * pt
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: parent.width - 50 * pt
                color: "#6F9F00"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
            }


            RowLayout {
                Layout.alignment: Qt.AlignHCenter

                DapButton
                {
                    id: actionButton
                    heightButton: 44 * pt
                    widthButton: 130 * pt
                    Layout.alignment: Qt.AlignCenter
                    checkable: true
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton.pixelSize: 18 * pt
                    colorBackgroundButton: "#3E3853"
                    colorTextButton: "#FFFFFF"
                }

                DapButton
                {
                    id: nextButton
                    heightButton:  44 * pt
                    widthButton: 130 * pt
                    Layout.alignment: Qt.AlignCenter
                    textButton: qsTr("Next")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton.pixelSize: 18 * pt
                    colorBackgroundButton: "#3E3853"
                    colorTextButton: "#FFFFFF"
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
