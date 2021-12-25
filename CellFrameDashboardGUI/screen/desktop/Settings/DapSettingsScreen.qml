import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/"
import "../../"
import "MenuBlocks"
import "qrc:/widgets"
import "../SettingsWallet.js" as SettingsWallet

DapAbstractScreen
{
    property alias settingsScreen_ : settingScreen
    property alias dapComboboxWallet: walletComboBox

    id:settingScreen
    signal createWalletSignal(bool restoreMode)

    anchors
    {
        fill: parent
        topMargin: 24 * pt
        rightMargin: 24 * pt
        leftMargin: 24 * pt
        bottomMargin: 20 * pt
    }

    Item
    {
        id: control
        anchors.fill: parent
//        color: currTheme.backgroundElements
//        radius: currTheme.radiusRectangle
//        shadowColor: currTheme.shadowColor
//        lightColor: currTheme.reflectionLight

//        contentData:
//            Item
//            {
//                anchors.fill: parent
//                // Header
//                Item
//                {
//                    id: settingsHeader
//                    anchors.top: parent.top
//                    anchors.left: parent.left
//                    anchors.right: parent.right
//                    height: 38 * pt

//                    Text
//                    {
//                        anchors.fill: parent
//                        anchors.leftMargin: 18 * pt
//                        anchors.topMargin: 10 * pt
//                        anchors.bottomMargin: 10 * pt
//                        verticalAlignment: Qt.AlignVCenter
//                        text: qsTr("Settings")
//                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
//                        color: currTheme.textColor
//                    }
//                }

//                ListView
//                {
//                    id: listViewSettings
//                    visible: false
////                    anchors.top: settingsHeader.bottom
////                    anchors.bottom: parent.bottom
////                    anchors.left: parent.left
////                    anchors.right: parent.right
////                    model: modelSettings
////                    clip: true
//                }

                RowLayout
                {
                    anchors.fill: parent
                    spacing: 25 * pt

                    ColumnLayout
                    {
                        Layout.fillHeight: true
                        Layout.minimumWidth: 327 * pt
                        Layout.alignment: Qt.AlignTop

                        DapRectangleLitAndShaded
                        {
                            property int spacing: (72 + 39) * pt
                            Layout.fillWidth: true
                            Layout.preferredHeight: contentData.implicitHeight
                            Layout.maximumHeight: control.height - spacing

//                            Layout.minimumWidth: 327 * pt

//                            height: 300
                            color: currTheme.backgroundElements
                            radius: currTheme.radiusRectangle
                            shadowColor: currTheme.shadowColor
                            lightColor: currTheme.reflectionLight
                            contentData: DapGeneralBlock{}
                        }

                        // Wallet create button
                        DapButton
                        {
                            id: newWalletButton

                            Layout.minimumWidth: 297 * pt
                            Layout.maximumWidth: 297 * pt
                            Layout.minimumHeight: 36 * pt
                            Layout.maximumHeight: 36 * pt
                            Layout.topMargin: 23 * pt
                            Layout.alignment: Qt.AlignHCenter

                            textButton: "Create a new wallet"

                            implicitHeight: 36 * pt
                            implicitWidth: 297 * pt
                            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                            horizontalAligmentText: Text.AlignHCenter
                            onClicked: createWalletSignal(false)
                        }

                        // Restore wallet
                        DapButton
                        {
                            id: restoreWalletButton

                            Layout.minimumWidth: 297 * pt
                            Layout.maximumWidth: 297 * pt
                            Layout.minimumHeight: 36 * pt
                            Layout.maximumHeight: 36 * pt
                            Layout.topMargin: 16 * pt
                            Layout.alignment: Qt.AlignHCenter

                            textButton: "Import an existing wallet"

                            implicitHeight: 36 * pt
                            implicitWidth: 297 * pt
                            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                            horizontalAligmentText: Text.AlignHCenter
                            onClicked: createWalletSignal(true)
                        }
                    }
                    DapRectangleLitAndShaded
                    {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 327 * pt
                        Layout.alignment: Qt.AlignTop
                        Layout.preferredHeight: contentData.implicitHeight
                        color: currTheme.backgroundElements
                        radius: currTheme.radiusRectangle
                        shadowColor: currTheme.shadowColor
                        lightColor: currTheme.reflectionLight

                        contentData: DapAppearanceBlock{}
                    }
                    DapRectangleLitAndShaded
                    {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 350 * pt
                        Layout.alignment: Qt.AlignTop
                        height: 300
                        color: currTheme.backgroundElements
                        radius: currTheme.radiusRectangle
                        shadowColor: currTheme.shadowColor
                        lightColor: currTheme.reflectionLight
                        ListView
                        {
                            id: listViewSettingsApps
//                            Layout.fillWidth: true
//                            delegate: testComp
                            clip: true
                        }
                    }
                }

//                Component
//                {
//                    id:apperanceDelegate
//                    Rectangle
//                    {

//                    }
//                }
            }
//    }






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
//            radius: 16*pt
            z:10

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

                color: currTheme.backgroundElements
                height: 80 * pt

                DapComboBox
                {
                    id:comboBoxNetwork
//                    anchors.fill: parent
//                    anchors.top: parent.top
                    anchors.left: parent.left
//                    anchors.bottom: parent.bottom

                    anchors.topMargin: 25 * pt
                    anchors.leftMargin: 25 * pt
                    comboBoxTextRole: ["name"]
//                    mainLineText: "private"
                    indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                    indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                    sidePaddingNormal: 19 * pt
                    sidePaddingActive: 19 * pt
                    widthPopupComboBoxNormal: 175 * pt
                    widthPopupComboBoxActive: 175 * pt
                    heightComboBoxNormal: 50 * pt
                    heightComboBoxActive: 50 * pt
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
                    model: dapNetworkModel
                    onCurrentIndexChanged:
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
                mainLineText: "all wallets"
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
//            // Wallet create button
//            DapButton
//            {
//                id: newWalletButton
//                textButton: "New wallet"
//                anchors.left: walletComboBox.right
//                anchors.leftMargin: 50 * pt
//                anchors.verticalCenter: walletComboBox.verticalCenter
//                implicitHeight: 36 * pt
//                implicitWidth: 163 * pt
//                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
//                horizontalAligmentText: Text.AlignHCenter
//                onClicked: createWalletSignal()
//            }

        }
        Rectangle
        {
            height: 25 * pt
        }
        Rectangle
        {
            height: pluginsHeader.height
            width: listViewSettings.width
            color: currTheme.backgroundMainScreen
            // Header
            Rectangle
            {
                id: pluginsHeader
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
                    text: "dApps"
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                    color: currTheme.textColor
                }
            }
        }
        Item
        {
            width: listViewSettings.width
            height: 350 * pt

            DapPluginsSettingsScreen
            {

            }
        }
    }
}
