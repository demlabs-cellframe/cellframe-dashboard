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

    spacing: 0

    Item
    {
        Layout.fillWidth: true
        height: 38 * pt

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 17 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("General settings")
        }
    }
    Rectangle
    {
        Layout.fillWidth: true
//        Layout.topMargin: 1 * pt
//        Layout.bottomMargin: 1 * pt
        height: 30 * pt
        color: currTheme.backgroundMainScreen

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 8 * pt
            anchors.bottomMargin: 8 * pt
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

    ListModel{
        id:networksModelGenegal

        function createModelNetworks()
        {
            for(var i = 0; i < dapModelWallets.count; i++)
            {
                for(var j = 0; j < dapModelWallets.get(i).networks.count; j++)
                {
                    if(dapModelWallets.get(i).networks.get(j).name === "subzero")
                        networksModelGenegal.append({address:dapModelWallets.get(i).networks.get(j).address})
                }
            }
        }
    }


    ListView
    {
        id:listWallet
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: contentHeight
        model:{networksModelGenegal.createModelNetworks(); return dapModelWallets}
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
            height: 50 * pt
            onHeightChanged: listWallet.contentHeight = height

            Item {
//                height: 50 * pt
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout
                {
                    anchors.fill: parent
                    ColumnLayout
                    {
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 15 * pt
//                        Layout.topMargin: 4 * pt
//                        Layout.bottomMargin: 14 * pt

                        Text
                        {

                            height: 26*pt
                            Layout.fillWidth: true

                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                            color: currTheme.textColor
                            verticalAlignment: Qt.AlignVCenter
                            text: name
                        }
                        RowLayout
                        {
                            Layout.preferredHeight: 16 * pt

                            spacing: 0 * pt
                            DapText
                            {
                               id: textMetworkAddress
                               Layout.preferredWidth: 98 * pt

                               fontDapText: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                               color: currTheme.textColorGrayTwo
                               fullText: networksModelGenegal.get(index).address
                               textElide: Text.ElideMiddle
                               horizontalAlignment: Qt.Alignleft

                            }
                            MouseArea
                            {
                                id: networkAddressCopyButton
                                Layout.preferredHeight: 18 * pt
                                Layout.preferredWidth: 17 * pt
                                hoverEnabled: true

                                onClicked: textMetworkAddress.copyFullText()

                                DapImageLoader{
                                    id:networkAddressCopyButtonImage
                                    innerWidth: parent.width
                                    innerHeight: parent.height
                                    source: parent.containsMouse ? "qrc:/resources/icons/" + pathTheme + "/ic_copy_hover.png" : "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
                                }
                            }
                        }
                    }

                    DapRadioButton
                    {
                        id: radioBut

//                        signal setWallet(var index)

                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 46 * pt
                        Layout.preferredWidth: 46 * pt
                        Layout.rightMargin: 15 * pt
//                        Layout.topMargin: 2 * pt
//                        Layout.bottomMargin: 2 * pt

                        ButtonGroup.group: buttonGroup

                        nameRadioButton: qsTr("")
                        indicatorInnerSize: 46 * pt
                        spaceIndicatorText: 3 * pt
                        fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                        implicitHeight: indicatorInnerSize
                        checked: index === SettingsWallet.currentIndex? true:false

                        onClicked:
                        {
//                            if(!checked)
//                                checked = true
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
//                MouseArea
//                {
//                    anchors.fill: parent
//                    onClicked: radioBut.clicked();
//                }
            }
        }
    }
}
