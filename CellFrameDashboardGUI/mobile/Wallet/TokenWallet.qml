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
                    anchors.fill: parent
                    onClicked:
                    {
                        print("index", index)
                        currentNetwork = index
                        window.updateTokenModel()
                    }
                }
            }


        }

        ListView {
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
//                width: parent.width
                height: 40
//                anchors.margins: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 15 * pt
                anchors.rightMargin: 15 * pt

//                anchors.fill: parent
                Rectangle {
                    id: headerRect
                    anchors.fill: parent
                    color: "#32363D"
                    radius: 10
                }
                InnerShadow {
                    id: id1
                    anchors.fill: headerRect
                    radius: 10.0
                    samples: 10
                    cached: true
                    horizontalOffset: 2
                    verticalOffset: 2
                    color: "#505050"
                    source: headerRect
                }
                DropShadow {
                    anchors.fill: headerRect
                    radius: 10.0
                    samples: 10
                    cached: true
                    horizontalOffset: 2
                    verticalOffset: 2
                    color: "#252525"
                    source: id1
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
            }
        }
    }
}
