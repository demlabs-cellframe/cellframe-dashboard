import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
//import qmlclipboard 1.0
import "qrc:/widgets/"

Page {
    title: qsTr("Wallet")
    background: Rectangle {color: currTheme.backgroundMainScreen }

/*    QMLClipboard{
        id: clipboard
    }*/

    ColumnLayout
    {
        anchors.fill: parent

        spacing: 10

        ListView {
            clip: true
            orientation: ListView.Horizontal
            Layout.fillWidth: true
            height: 50 * pt

            model: mainNetworkModel


            delegate:
            ColumnLayout
            {
                spacing: 5 * pt

                Label {
                    Layout.topMargin: 5 * pt
                    Layout.leftMargin: 15 * pt
                    Layout.rightMargin: 15 * pt
                    text: name
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
                    horizontalAlignment: Text.AlignHCenter
                    color: index === currentNetwork ? currTheme.buttonColorHover : currTheme.textColor
                }

                Rectangle
                {
                    Layout.alignment: Qt.AlignCenter
                    width: 20 * pt
                    height: 3 * pt
                    color: index === currentNetwork ? currTheme.buttonColorHover : currTheme.textColor
                }

                MouseArea
                {
                    width: parent.width
                    height: parent.height

                    onClicked:
                    {
                        currentNetwork = index
                        window.updateTokenModel()
                    }
                }
            }
        }

        /*RowLayout
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.leftMargin: 30 * pt
            Layout.rightMargin: 30 * pt
            Layout.topMargin: 5 * pt

            Text {
                color: currTheme.textColor
                font.family: "Quicksand"
                font.pixelSize: 16 * pt
                font.bold: true
                text: qsTr("Address: ")
            }

            Text {
                id:textAddr
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideMiddle

                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                text: mainWalletModel.get(currentWallet).networks.get(currentNetwork).address

            }

            DapButton
            {
                implicitWidth: 50 * pt
                implicitHeight: 20 * pt
                radius: 5 * pt

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

                onClicked: clipboard.setText(textAddr.text)

            }
        }*/



        ListView {
            id: tokenView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 5 * pt
            spacing: 20

            clip: true

            model: tokenModel

            ScrollBar.vertical: ScrollBar {
                active: true
            }

            delegate:
            Item {
                width: tokenView.width - 30 * pt
                x: 15 * pt
                height: 40 * pt

                Rectangle {
                    id: itemRect
                    anchors.fill: parent
                    color: mouseArea.containsMouse ? currTheme.buttonColorNormalPosition0 :"#32363D"
                    radius: 10
                }
                InnerShadow {
                    id: shadow
                    anchors.fill: itemRect
                    radius: 10.0
                    samples: 10
                    cached: true
                    horizontalOffset: 2
                    verticalOffset: 2
                    color: "#505050"
                    source: itemRect
                }
                DropShadow {
                    anchors.fill: itemRect
                    radius: 10.0
                    samples: 10
                    cached: true
                    horizontalOffset: 2
                    verticalOffset: 2
                    color: "#252525"
                    source: shadow
                }

                RowLayout
                {
                    anchors.fill: parent
                    anchors.leftMargin: 15 * pt
                    anchors.rightMargin: 15 * pt

                    Label {
                        Layout.fillWidth: true

                        text: name
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
                        color: currTheme.textColor
                    }

                    Label {
                        text: balance
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
                        color: currTheme.textColor
                    }
                }

                MouseArea
                {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        currentToken = index
                        mainStackView.push("qrc:/mobile/Wallet/Payment/TokenOverview.qml")
                        headerWindow.background.visible = false
                        walletNameLabel.visible = false
                    }
                }
            }
        }
    }
}
