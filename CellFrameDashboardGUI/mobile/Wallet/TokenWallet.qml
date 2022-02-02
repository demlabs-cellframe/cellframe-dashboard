import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets/"

Page {
    title: qsTr("Wallet")
    background: Rectangle {color: currTheme.backgroundMainScreen }

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

            ScrollBar.horizontal: ScrollBar {
                active: true
            }

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

        ListView {
            id: tokenView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20

            clip: true

            model: mainTokenModel

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
                        text: balance_text
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
                    }
                }
            }
        }
    }
}
