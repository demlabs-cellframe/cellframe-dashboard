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
        TestScreen
        {}
    dapRightPanel:
        DapAbstractRightPanel
        {
            dapHeaderData:
                RowLayout{
                    Layout.fillWidth: true
                    Text
                    {
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

                }
        }
}
