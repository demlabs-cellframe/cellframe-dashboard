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
                source: networkState === "ONLINE" ?  "qrc:/resources/icons/" + pathTheme + "/indicator_online.png" :
                        networkState === "ERROR"   ?  "qrc:/resources/icons/" + pathTheme + "/indicator_error.png":
                                                    "qrc:/resources/icons/" + pathTheme + "/indicator_offline.png"
                Layout.preferredWidth: 10
                Layout.preferredHeight: 10
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                Layout.leftMargin: 5 * pt
                Layout.fillWidth: true
                text: name
                font: _dapQuicksandFonts.dapFont.regular16
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
                font: _dapQuicksandFonts.dapFont.bold12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                Layout.fillWidth: true
                font: _dapQuicksandFonts.dapFont.regular12
                text: networkState
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "Target state:"
                font: _dapQuicksandFonts.dapFont.bold12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                Layout.fillWidth: true
                text: targetState
                font: _dapQuicksandFonts.dapFont.regular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "Active links:"
                font: _dapQuicksandFonts.dapFont.bold12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                Layout.fillWidth: true
                text: activeLinksCount + " from " + linksCount
                font: _dapQuicksandFonts.dapFont.regular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "Address:"
                font: _dapQuicksandFonts.dapFont.bold12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.textColor
            }

            Text {
                text: nodeAddress
                Layout.maximumWidth: deleagte.width/2.5
                font: _dapQuicksandFonts.dapFont.regular12
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
//                transColor: true
                activeFrame: false
                onClicked:
                {
                    clipboard.setText(address)
                }
            }
        }
    }
}
