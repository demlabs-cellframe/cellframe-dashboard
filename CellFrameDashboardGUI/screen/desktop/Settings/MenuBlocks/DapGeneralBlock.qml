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
            onHeightChanged: listWallet.contentHeight = height

            Item {
                Layout.preferredHeight: 50 * pt
                Layout.fillWidth: true
                Layout.topMargin: 10 * pt


                RowLayout
                {
                    anchors.fill: parent

                    ColumnLayout
                    {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Layout.leftMargin: 15 * pt

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
                            Layout.bottomMargin: 9 * pt
                            spacing: 0 * pt
                            DapText
                            {
                               id: textMetworkAddress
                               Layout.preferredWidth: 96 * pt

                               fontDapText: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                               color: currTheme.textColorGrayTwo
                               fullText: networksModelGenegal.get(index).address
                               textElide: Text.ElideMiddle
                               horizontalAlignment: Qt.Alignleft

                            }
                            MouseArea
                            {
                                id: networkAddressCopyButton
                                Layout.preferredHeight: 16 * pt
                                Layout.preferredWidth: 16 * pt
                                hoverEnabled: true

                                onClicked: textMetworkAddress.copyFullText()

                                Image
                                {
                                    id: networkAddressCopyButtonImage
                                    anchors.fill: parent
                                    source: parent.containsMouse ? "qrc:/resources/icons/" + pathTheme + "/ic_copy_hover.png" : "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
                                    sourceSize.width: parent.width
                                    sourceSize.height: parent.height

                                }
                            }
                        }
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
