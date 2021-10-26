import QtQuick 2.4
import QtQuick.Layouts 1.3
import "qrc:/"
import "../"
import "qrc:/widgets"

DapTab {
    id :testPageTab
    color: currTheme.backgroundMainScreen

    dapTopPanel:
        DapTopPanel
        {   anchors.leftMargin: 4*pt
            radius: currTheme.radiusRectangle
            color: currTheme.backgroundPanel
        }

    dapScreen:
        DapAbstractScreen
        {}
    dapRightPanel:
        DapAbstractRightPanel
        {
            dapHeaderData:
                RowLayout{
//                Layout.fillWidth: true
                    width: 350*pt
                    Text
                    {
//                        anchors.fill: parent
//                        anchors.leftMargin: 24 * pt
                        Layout.fillWidth: true
                        Layout.leftMargin: 20 * pt
                        Layout.topMargin: 20 * pt
                        text: qsTr("Test panel")
                        verticalAlignment: Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                        color: currTheme.textColor

                    }
            }
            dapContentItemData:
                ColumnLayout{
                    Layout.fillWidth: true
//                    width: 350*pt
                    DapButton
                    {
                        id: buttonSend
                        radius: currTheme.radiusButton
                        implicitHeight: 36 * pt
                        implicitWidth: 350 * pt
                        Layout.alignment: Qt.AlignCenter
                        Layout.topMargin: 50 * pt
                        textButton: qsTr("Send")
                        colorBackgroundHover: currTheme.buttonColorHover
                        colorBackgroundNormal: currTheme.buttonColorNormal
                        colorButtonTextNormal: currTheme.textColor
                        colorButtonTextHover: currTheme.textColor
                        horizontalAligmentText: Text.AlignHCenter
                        indentTextRight: 0
                        fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16


                    }
            }
        }
}
