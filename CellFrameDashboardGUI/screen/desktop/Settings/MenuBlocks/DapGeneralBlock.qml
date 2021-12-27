import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../SettingsWallet.js" as SettingsWallet

ColumnLayout
{
    id:control
    anchors.fill: parent

    property alias dapWalletsButtons : buttonGroup
    property int dapCurrentWallet: SettingsWallet.currentIndex

    Item
    {
        Layout.fillWidth: true
        Layout.preferredHeight: 38 * pt

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 15 * pt
            anchors.topMargin: 15 * pt
            anchors.bottomMargin:  5 * pt
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("General settings")
        }
    }
    Rectangle
    {
        Layout.fillWidth: true
        Layout.preferredHeight: 30 * pt
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

    ButtonGroup
    {
        id: buttonGroup
    }
    ListView
    {
        id:listWallet
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: contentHeight
        model:dapModelWallets
        clip: true
        delegate: delegateList

    }

    Component{
        id:delegateList

        ColumnLayout
        {
            id:columnWallets
            anchors.left: parent.left
            anchors.right: parent.right
            onHeightChanged: listWallet.contentHeight = height

            Item {
                Layout.preferredHeight: 50 * pt
                Layout.fillWidth: true

                RowLayout
                {
                    anchors.fill: parent
                    anchors.topMargin: 10 * pt
                    anchors.bottomMargin: 15 * pt

                    Text
                    {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        height: 26*pt
                        Layout.fillWidth: true
                        Layout.leftMargin: 15 * pt

                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                        color: currTheme.textColor
                        verticalAlignment: Qt.AlignVCenter
                        text: name
                    }


                    DapRadioButton
                    {
                        id: radioBut

//                        signal setWallet(var index)

                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 26*pt
                        Layout.preferredWidth: 46 * pt
                        Layout.rightMargin: 15 * pt

                        ButtonGroup.group: buttonGroup

                        nameRadioButton: qsTr("")
                        indicatorInnerSize: 46 * pt
                        spaceIndicatorText: 3 * pt
                        fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                        implicitHeight: indicatorInnerSize
                        checked: index === SettingsWallet.currentIndex? true:false

                        onClicked:
                        {
                            if(!checked)
                                checked = true
                            dapCurrentWallet = index
                            SettingsWallet.currentIndex = index
                        }
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
                MouseArea
                {
                    anchors.fill: parent
                    onClicked: radioBut.clicked();
                }
            }
        }
    }
}
