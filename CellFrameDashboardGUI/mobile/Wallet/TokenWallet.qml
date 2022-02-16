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
        anchors.topMargin: 23
//        anchors.leftMargin: 17

        spacing: 0

        ListView {
            clip: true
            orientation: ListView.Horizontal
            Layout.fillWidth: true
            Layout.leftMargin: 17
            height: 31 * pt

            model: mainNetworkModel
            spacing: 39


            delegate:
            ColumnLayout
            {
                spacing: 0

                Label {
//                    Layout.topMargin: 5 * pt
//                    Layout.leftMargin: 15 * pt
//                    Layout.rightMargin: 15 * pt
                    text: name
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium13
                    horizontalAlignment: Text.AlignHCenter
                    color: index === currentNetwork ? currTheme.hilightColorComboBox : currTheme.textColor
                }

                Rectangle
                {
                    Layout.topMargin: 12 * pt
                    Layout.alignment: Qt.AlignCenter
                    width: 20 * pt
                    height: 3 * pt
                    radius: 100
                    color: index === currentNetwork ? currTheme.hilightColorComboBox : currTheme.textColor
                }

                MouseArea
                {
                    width: parent.width
                    height: parent.height

                    onClicked:
                    {
                        if(currentNetwork != index)
                        {
                            currentNetwork = index
                            window.updateTokenModel()

                        }
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
            Layout.topMargin: 21 * pt
            spacing: 0

            clip: true

            model: tokenModel

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
                        samples: 10
                        cached: true
                        horizontalOffset: 1
                        verticalOffset: 1
                        color: "#515763"
                        source: itemRect
                    }
                    DropShadow {
                        anchors.fill: itemRect
                        radius: 10.0
                        samples: 10
                        cached: true
                        horizontalOffset: 4
                        verticalOffset: 4
                        color: "#252530"
                        source: shadow
                    }

                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 22 * pt
                        anchors.rightMargin: 22 * pt

                        Text {
                            Layout.fillWidth: true

                            text: name
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
                            color: currTheme.textColor
                        }

                        Text {
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
}
