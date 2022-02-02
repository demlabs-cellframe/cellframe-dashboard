import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets/"

Item {
    id: deleagte
//    width: 231 * pt
    width: parent.width
    height: 140 * pt

    QMLClipboard{
        id: clipboard
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 10
        anchors.topMargin: 15

        RowLayout {
            Layout.fillWidth: true

            Image {
                source: "qrc:/mobile/Icons/indicator_online.png"
                Layout.preferredWidth: 10
                Layout.preferredHeight: 10
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                Layout.leftMargin: 5 * pt
                Layout.fillWidth: true
                text: name
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            DapButton
            {
                Layout.preferredWidth: 25 * pt
                Layout.preferredHeight: 25 * pt
                Layout.alignment: Qt.AlignHCenter

                normalImageButton: "qrc:/resources/icons/Icon_sync_net_hover.svg"
                hoverImageButton: "qrc:/resources/icons/Icon_sync_net_hover.svg"
                widthImageButton: 25 * pt
                heightImageButton: 25 * pt
                indentImageLeftButton: 0 * pt
                enabled: false
            }

            DapButton
            {
                Layout.preferredWidth: 25 * pt
                Layout.preferredHeight: 25 * pt
                Layout.alignment: Qt.AlignHCenter

                normalImageButton: "qrc:/resources/icons/icon_on_off_net_hover.svg"
                hoverImageButton: "qrc:/resources/icons/icon_on_off_net_hover.svg"
                widthImageButton: 25 * pt
                heightImageButton: 25 * pt
                indentImageLeftButton: 0 * pt
                enabled: false
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "State:"
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                Layout.fillWidth: true
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                text: curr_state
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
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                Layout.fillWidth: true
                text: target_state
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
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                Layout.fillWidth: true
                text: active_links + " from 2"
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
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                text: address
                Layout.maximumWidth: deleagte.width/2.5
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
                elide: Text.ElideMiddle
            }

            DapButton
            {
                Layout.preferredWidth: 20 * pt
                Layout.preferredHeight: 20 * pt
                Layout.alignment: Qt.AlignHCenter

                normalImageButton: "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
                hoverImageButton: "qrc:/resources/icons/" + pathTheme + "/ic_copy_hover.png"
                widthImageButton: 20 * pt
                heightImageButton: 20 * pt
                indentImageLeftButton: 0 * pt
                transColor: true
                onClicked:
                {
                    clipboard.setText(address)
                }
            }
        }
    }
}
