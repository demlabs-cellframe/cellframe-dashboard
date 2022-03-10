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
            anchors.leftMargin: 14 * pt
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
            text: qsTr("Networks")
        }
    }

    Item {
        height: 60 * pt
        Layout.fillWidth: true

        DapComboBox
        {
            id: comboBoxCurrentNetwork
            model: dapNetworkModel

            anchors.centerIn: parent
            anchors.fill: parent
            anchors.margins: 10 * pt
            anchors.leftMargin: 15 * pt

            comboBoxTextRole: ["name"]
            mainLineText: dapNetworkModel.get(SettingsWallet.currentNetwork).name

            indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
            indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
            sidePaddingNormal: 10 * pt
            sidePaddingActive: 10 * pt

            widthPopupComboBoxNormal: 318 * pt
            widthPopupComboBoxActive: 318 * pt
            heightComboBoxNormal: 24 * pt
            heightComboBoxActive: 42 * pt
            topEffect: false

            normalColor: currTheme.backgroundMainScreen
            normalTopColor: currTheme.backgroundElements
            hilightTopColor: currTheme.backgroundMainScreen

            paddingTopItemDelegate: 8 * pt
            heightListElement: 42 * pt
            indicatorWidth: 24 * pt
            indicatorHeight: indicatorWidth
            roleInterval: 15
            endRowPadding: 37

            fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
            colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
            alignTextComboBox: [Text.AlignLeft, Text.AlignRight]

            currentIndex: SettingsWallet.currentNetwork

            onCurrentIndexChanged:
            {
                dapServiceController.setCurrentNetwork(dapNetworkModel.get(currentIndex).name);
                dapServiceController.setIndexCurrentNetwork(currentIndex);
                SettingsWallet.currentNetwork = currentIndex
            }
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

    ListView
    {
        id:listWallet
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: contentHeight
        model: dapModelWallets
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
                        spacing: 0

                        Text
                        {

                            height: 26*pt
                            Layout.fillWidth: true

                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular11
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
                               Layout.preferredWidth: 101 * pt

                               fontDapText: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                               color: currTheme.textColorGrayTwo
                               fullText: networks.get(dapServiceController.IndexCurrentNetwork).address

                               textElide: Text.ElideMiddle
                               horizontalAlignment: Qt.Alignleft

                               Connections
                               {
                                   target:dapServiceController
                                   onIndexCurrentNetworkChanged:
                                   {
                                       textMetworkAddress.fullText = networks.get(dapServiceController.IndexCurrentNetwork).address
                                       textMetworkAddress.checkTextElide()
                                       textMetworkAddress.update()
                                   }
                               }


                            }
                            MouseArea
                            {
                                id: networkAddressCopyButton
//                                Layout.leftMargin: 3 * pt
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
                        Layout.rightMargin: 17 * pt
                        Layout.topMargin: 2 * pt

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

                            textMetworkAddress.checkTextElide()
                            textMetworkAddress.update()
                        }
                    }
                }
                Rectangle
                {
//                    visible: index === listWallet.count - 1? false : true
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
