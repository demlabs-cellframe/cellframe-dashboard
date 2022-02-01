import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Item {
    id: deleagte
    width: 231 * pt
    height: 140 * pt
//    property string networkName: "name"

//    contentItem:
    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 10
        anchors.topMargin: 15

        RowLayout {
            Layout.fillWidth: true

            Image {
                source: modelData.icon
                Layout.preferredWidth: 10
                Layout.preferredHeight: 10
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                Layout.leftMargin: 12 * pt
                Layout.fillWidth: true
                text: modelData.nameNet
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Button {
                Layout.preferredWidth: 25
                Layout.preferredHeight: 25
                Layout.alignment: Qt.AlignHCenter

                contentItem:
                    Image {
                        anchors.fill: parent
                        source: "qrc:/mobile/Icons/Reload.png"
                        fillMode: Image.PreserveAspectFit
                    }
            }
            Button {
                Layout.preferredWidth: 25
                Layout.preferredHeight: 25

                contentItem:
                    Image {
                        anchors.fill: parent
                        source: "qrc:/mobile/Icons/Reload.png"
                        fillMode: Image.PreserveAspectFit
                    }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "State:"
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
//                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                Layout.fillWidth: true
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                text: modelData.stateNet
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "Target state:"
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
//                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                Layout.fillWidth: true
                text: modelData.targetState
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "Active links:"
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
//                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                Layout.fillWidth: true
                text: modelData.activeLinks
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "Address:"
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
//                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                text: modelData.addressNet
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Button {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20

                contentItem:
                    Image {
                        anchors.fill: parent
                        source: "qrc:/mobile/Icons/Copy.png"
                        fillMode: Image.PreserveAspectFit
                    }
            }
        }

    }

}
