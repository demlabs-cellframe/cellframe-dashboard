import QtQuick 2.12
import QtQuick.Window 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Button {
    property bool isSynch : false

    id: control

    contentItem:
        RowLayout
        {
            anchors.fill: parent
            spacing: 0

            DapImageLoader {
                Layout.leftMargin: isSynch ? 23 * pt : 29 * pt
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight:  24 * pt
                Layout.preferredWidth:  24 * pt
                innerHeight: 24 * pt
                innerWidth: 24 * pt

                source: isSynch ? "qrc:/resources/icons/Icon_sync_net_hover.svg" : "qrc:/resources/icons/icon_on_off_net_hover.svg"
            }

            Text {
                id: button_caption
                Layout.alignment: Qt.AlignVCenter
                Layout.rightMargin: isSynch ? 22 * pt : 28 * pt
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
                color: currTheme.textColor
                text: isSynch ? qsTr("Sync Network") : qsTr("On network")
            }
        }

    background: Rectangle {
//        color: "transparent"
        LinearGradient
        {
            anchors.fill: parent
            source: parent
            start: Qt.point(0,parent.height/2)
            end: Qt.point(parent.width,parent.height/2)
            gradient:
                Gradient {
                    GradientStop
                    {
                        position: 0;
                        color: control.hovered ? currTheme.buttonColorNormalPosition0 :
                                                 currTheme.buttonNetworkColorNoActive
                    }
                    GradientStop
                    {
                        position: 1;
                        color: control.hovered ? currTheme.buttonColorNormalPosition1 :
                                                 currTheme.buttonNetworkColorNoActive
                    }
                }
        }
    }


}
