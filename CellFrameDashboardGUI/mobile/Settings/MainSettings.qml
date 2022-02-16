import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import qmlclipboard 1.0
import "qrc:/widgets/"
import "../"

Page {
    title: qsTr("Settings")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    QMLClipboard{
        id: clipboard
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.topMargin: 10 * pt

        ListView {
            id: controlList
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20

            clip: true

//            model: tokensModelTest
            model: mainWalletModel

            ScrollBar.vertical: ScrollBar {
                active: true
            }

            delegate:
                Item {
                    width: parent.width
                    height: 86 * pt

                    Item
                    {

                        anchors.fill: parent
                        anchors.topMargin: 13
                        anchors.bottomMargin: 13
                        anchors.leftMargin: 18
                        anchors.rightMargin: 17


                        Rectangle
                        {
                            id: itemRect
                            anchors.fill: parent
                            color: mouseArea.containsMouse ? currTheme.buttonColorNormalPosition0 :"#32363D"
                            radius: 12
                        }

                        InnerShadow {
                            id: shadow
                            anchors.fill: itemRect
                            radius: 5
                            samples: 32
                            cached: true
                            horizontalOffset: 1
                            verticalOffset: 1
                            color: "#515763"
                            source: itemRect
                        }
                        DropShadow {
                            anchors.fill: itemRect
                            radius: 10.0
                            samples: 32
                            cached: true
                            horizontalOffset: 4
                            verticalOffset: 4
                            color: "#252530"
                            source: shadow
                        }

                        RowLayout
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 15 * pt
                            anchors.rightMargin: 15 * pt

                            Label {
                                id: nameWall
                                Layout.fillWidth: true

                                text: name
                                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
                                color: currTheme.textColor
                            }

                            Label {
                                Layout.fillWidth: true
                                Layout.maximumWidth: controlList.width/2.5
                                text: networks.get(currentNetwork).address
                                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
                                color: currTheme.textColor
                                elide: Text.ElideMiddle
                            }

                            DapButton
                            {
                                implicitWidth: 50 * pt
                                implicitHeight: 20 * pt
                                radius: 5 * pt
                                z: 1

                                textButton: qsTr("Copy")

                                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                                horizontalAligmentText: Text.AlignHCenter
                                colorTextButton: "#FFFFFF"

                                customColors: true
                                gradientHover0:"#B9B8D9"
                                gradientNormal0:"#A4A3C0"
                                gradientHover1:"#9392B0"
                                gradientNormal1:"#7D7C96"
                                gradientNoActive:"gray"

                                MouseArea {
                                    z: 2
                                    id:controlCopy
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: clipboard.setText(networks.get(currentNetwork).address)
                                }

                            }
                        }
                    }

                    MouseArea
                    {
                        id:mouseArea
                        z: 1
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:
                        {
                            if(!controlCopy.containsMouse)
                            {
                                if(index !== currentWallet)
                                    controlList.setSelected(index)
                            }
                            else
                            {
                                clipboard.setText(mainWalletModel.get(index).networks.get(currentNetwork).address)
                            }
                        }
                    }
                }

            function setSelected(index)
            {
                currentWallet = index;
                nameWallet.text = walletModel.get(currentWallet).name

                updateNetworkModel()

                updateTokenModel()
            }
        }
        DapButton
        {
            Layout.alignment: Qt.AlignHCenter

            implicitWidth: 210 * pt
            implicitHeight: 36 * pt
            radius: currTheme.radiusButton

            textButton: qsTr("Create new wallet")

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                walletNameLabel.visible = false
                mainStackView.push("qrc:/mobile/Wallet/WalletName.qml")
                headerWindow.background.visible = false
            }

        }

        DapButton
        {
            visible: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10 * pt

            implicitWidth: 210 * pt
            implicitHeight: 36 * pt
            radius: currTheme.radiusButton

            textButton: qsTr("Import an existing wallet")

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                walletNameLabel.visible = false
                mainStackView.push("qrc:/mobile/Wallet/WalletName.qml")
            }


        }

        Item
        {
            Layout.fillHeight: true
        }
    }
}
