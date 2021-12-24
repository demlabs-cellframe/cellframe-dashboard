import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

ColumnLayout
{
    Item
    {
        Layout.fillWidth: true
        height: 38 * pt

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 15 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin:  10 * pt
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("General settings")
        }
    }
    Rectangle
    {
        Layout.fillWidth: true
        height: 30 * pt
        color: currTheme.backgroundMainScreen

        Text
        {
            anchors.left: parent.left
            anchors.leftMargin: 17 * pt
            anchors.verticalCenter: parent.verticalCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Choose a wallet")
        }
    }

    Repeater
    {
        model: dapModelWallets.count
        Item {
            Layout.preferredHeight: 50 * pt
            Layout.preferredWidth: 327 * pt

            RowLayout
            {
                anchors.fill: parent

                Text
                {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.leftMargin: 15 * pt

                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                    color: currTheme.textColor
                    verticalAlignment: Qt.AlignVCenter
                    text: dapModelWallets.get(index).name
                }


                DapRadioButton
                {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.rightMargin: 15 * pt
                    Layout.preferredHeight: 26*pt
                    Layout.preferredWidth: 46 * pt

                    nameRadioButton: qsTr("")
                    indicatorInnerSize: 46 * pt
                    spaceIndicatorText: 3 * pt
                    fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    implicitHeight: indicatorInnerSize

                }
            }
            Rectangle
            {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1 * pt
                color: currTheme.lineSeparatorColor

            }
        }
    }


}
