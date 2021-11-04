import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/"
import "../../"
import "qrc:/widgets"
import "../SettingsWallet.js" as SettingsWallet

DapAbstractScreen
{
    property alias settingsScreen_ : settingScreen
    property alias dapComboboxWallet: walletComboBox

    id:settingScreen
    signal createWalletSignal()

    anchors
    {
        top: parent.top
        topMargin: 24 * pt
        right: parent.right
        rightMargin: 44 * pt
        left: parent.left
        leftMargin: 24 * pt
        bottom: parent.bottom
        bottomMargin: 20 * pt
    }

    Rectangle
    {
        id: settingsFrame
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: 16*pt

        // Header
        Item
        {
            id: settingsHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 38 * pt

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 18 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Settings")
                font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
            }
        }

        ListView
        {
            id: listViewSettings
            anchors.top: settingsHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            model: modelSettings
            clip: true
        }
    }
    InnerShadow {
        id: topLeftSadow
        anchors.fill: settingsFrame
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: settingsFrame
    }
    InnerShadow {
        anchors.fill: settingsFrame
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
    }

    ///@detalis Settings item model.
    VisualItemModel
    {
        id: modelSettings

        // Network settings section
        Rectangle
        {
            id: itemNetwork
            height: networkHeader.height + contentNetwork.height
            width: listViewSettings.width
            color: currTheme.backgroundMainScreen
            radius: 16*pt

            // Header
            Rectangle
            {
                id: networkHeader
                color: "transparent"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30 * pt
                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 18 * pt
                    verticalAlignment: Qt.AlignVCenter
                    text:"Network"
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                    color: currTheme.textColor
                }
            }

            // Content
            Rectangle
            {
                id: contentNetwork
                anchors.top: networkHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 60 * pt
                color: currTheme.backgroundElements
                ComboBox
                {
                    id: comboBoxNetwork
                    width: 150
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 25 * pt
                    anchors.topMargin: 10 * pt
                    anchors.bottomMargin: 10 * pt
                    model: dapNetworkModel
                    onCurrentTextChanged:
                    {
                        dapServiceController.CurrentNetwork = currentText
                        dapServiceController.IndexCurrentNetwork = currentIndex
                    }
                }
            }
        }

        // VPN settings section
        Rectangle
        {
            id: walletSettings
            height: walletHeader.height
            width: listViewSettings.width
            color: currTheme.backgroundMainScreen
            // Header
            Rectangle
            {
                id: walletHeader
                color: "transparent"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30 * pt
                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 18 * pt
                    verticalAlignment: Qt.AlignVCenter
                    text: "Wallet"
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                    color: currTheme.textColor
                }
            }
        }
        Rectangle
        {
            color: currTheme.backgroundElements
            height: 80 * pt
            width: 200 * pt
            DapComboBox
            {
                id:walletComboBox
                anchors.fill: parent
                anchors.topMargin: 25 * pt
                anchors.leftMargin: 25 * pt
                comboBoxTextRole: ["name"]
                mainLineText: "private"
                indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                sidePaddingNormal: 19 * pt
                sidePaddingActive: 19 * pt
                widthPopupComboBoxNormal: 125 * pt
                widthPopupComboBoxActive: 125 * pt
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 42 * pt
                topEffect: false
                x: sidePaddingNormal
                normalColor: currTheme.backgroundMainScreen
                hilightTopColor: currTheme.backgroundMainScreen
                hilightColor: currTheme.buttonColorNormal
                normalTopColor: currTheme.backgroundMainScreen
                paddingTopItemDelegate: 8 * pt
                heightListElement: 42 * pt
                indicatorWidth: 24 * pt
                indicatorHeight: indicatorWidth
                colorDropShadow: currTheme.shadowColor
                roleInterval: 15
                endRowPadding: 37
                fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
                colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
                model: dapModelWallets
                currentIndex: SettingsWallet.currentIndex
                onCurrentIndexChanged:
                {
                    SettingsWallet.currentIndex = dapComboboxWallet.currentIndex
                }
            }
            // Wallet create button
            DapButton
            {
                id: newWalletButton
                textButton: "New wallet"
                anchors.left: walletComboBox.right
                anchors.leftMargin: 50 * pt
                anchors.verticalCenter: walletComboBox.verticalCenter
                implicitHeight: 36 * pt
                implicitWidth: 163 * pt
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter
                onClicked: createWalletSignal()
            }
        }
    }
}
