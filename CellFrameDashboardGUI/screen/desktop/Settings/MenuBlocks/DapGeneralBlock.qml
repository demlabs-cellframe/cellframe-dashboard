import QtQuick 2.4
import QtQuick.Controls 2.5
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
            text: qsTr("Window scale")
        }
    }

    Item {
        height: 40 * pt
        Layout.fillWidth: true

        RowLayout
        {
            anchors.fill: parent
            anchors.topMargin: 13 * pt
            anchors.bottomMargin: 16 * pt
            anchors.leftMargin: 10 * pt
            anchors.rightMargin: 10 * pt

            Text
            {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredHeight: 25 * pt
                Layout.fillWidth: true
                Layout.leftMargin: 13 * pt

                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                color: currTheme.textColor
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Scale value")
            }

            DapDoubleSpinBox
            {
                id: scaleSpinbox

                width: 80 * pt

                Layout.minimumHeight: 18 * pt
                Layout.maximumHeight: 18 * pt

                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12

                realFrom: minWindowScale
                realTo: maxWindowScale
                realStep: 0.05
                decimals: 2

                //defaultValue: mainWindowScale

                value: Math.round(mainWindowScale*100)
            }
        }
    }

    property real newScale: 1.0

    Popup {
        id: restartDialog

        width: 300 * pt
        height: 180 * pt

        parent: Overlay.overlay

//        anchors.centerIn: parent
        x: (parent.width - width) * 0.5
        y: (parent.height - height) * 0.5

        modal: true

        scale: mainWindow.scale

        background: Rectangle
        {
            border.width: 0
            color: currTheme.backgroundElements
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: 10 * pt

            Text {
                Layout.fillWidth: true
                Layout.margins: 10 * pt
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                color: currTheme.textColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: qsTr("You must restart the application to apply the new scale. Do you want to restart now? ")
            }

            RowLayout
            {
                Layout.margins: 10 * pt
                Layout.bottomMargin: 20 * pt
//                Layout.leftMargin: 10 * pt
//                Layout.rightMargin: 10 * pt
                spacing: 10 * pt

                DapButton
                {
                    id: restartButton
                    Layout.fillWidth: true

                    Layout.minimumHeight: 36 * pt
                    Layout.maximumHeight: 36 * pt

                    textButton: qsTr("Restart")

                    implicitHeight: 36 * pt
                    fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                    horizontalAligmentText: Text.AlignHCenter

                    onClicked: {
                        print("Restart")

                        restartDialog.close()

                        window.setNewScale(newScale)
                    }
                }

                DapButton
                {
                    Layout.fillWidth: true

                    Layout.minimumHeight: 36 * pt
                    Layout.maximumHeight: 36 * pt

                    textButton: qsTr("Cancel")

                    implicitHeight: 36 * pt
                    fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                    horizontalAligmentText: Text.AlignHCenter

                    onClicked: {
                        print("Cancel")

                        restartDialog.close()
                    }
                }
            }
        }
    }

    Item {
        height: 60 * pt
        Layout.fillWidth: true

        RowLayout
        {
            anchors.fill: parent
            anchors.topMargin: 13 * pt
            anchors.bottomMargin: 16 * pt
            anchors.leftMargin: 10 * pt
            anchors.rightMargin: 10 * pt
            spacing: 10 * pt

            DapButton
            {
                id: resetScale

                focus: false

                Layout.fillWidth: true

                Layout.minimumHeight: 36 * pt
                Layout.maximumHeight: 36 * pt

                textButton: qsTr("Reset scale")

                implicitHeight: 36 * pt
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked: {
                    print("Reset scale")

                    newScale = 1.0

                    restartDialog.open()
                }
            }

            DapButton
            {
                id: applyScale

                focus: false

                Layout.fillWidth: true

                Layout.minimumHeight: 36 * pt
                Layout.maximumHeight: 36 * pt

                textButton: qsTr("Apply scale")

                implicitHeight: 36 * pt
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked: {
                    print("Apply scale")

                    newScale = scaleSpinbox.realValue

                    restartDialog.open()
                }
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
                               fullText: networksModelGenegal.get(index).address
                               textElide: Text.ElideMiddle
                               horizontalAlignment: Qt.Alignleft

                            }
                            MouseArea
                            {
                                id: networkAddressCopyButton
//                                Layout.leftMargin: 3 * pt
                                Layout.preferredHeight: 18 * pt
                                Layout.preferredWidth: 17 * pt
                                hoverEnabled: true

                                onClicked: textMetworkAddress.copyFullText()

                                Image{
                                    id:networkAddressCopyButtonImage
                                    width: parent.width
                                    height: parent.height
                                    mipmap: true
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
