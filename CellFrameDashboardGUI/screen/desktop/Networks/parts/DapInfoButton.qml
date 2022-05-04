import QtQuick 2.12
import QtQuick.Window 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item {
    property bool isSynch : false
    property alias textBut: button_caption.text
    property alias button: control

    Button {
        id: control

        anchors.fill: parent

        hoverEnabled: true
        contentItem:
            RowLayout
            {
                anchors.fill: parent
                spacing: 0

                Image {
                    Layout.leftMargin: isSynch ? 23 * pt : 29 * pt
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight:  24 * pt
                    Layout.preferredWidth:  24 * pt
                    height: 24 * pt
                    width: 24 * pt
                    mipmap: true

                    source: isSynch ? "qrc:/resources/icons/Icon_sync_net_hover.svg" : "qrc:/resources/icons/icon_on_off_net_hover.svg"
                }

                Text {
                    id: button_caption
                    Layout.alignment: Qt.AlignVCenter
                    Layout.rightMargin: isSynch ? 22 * pt : 28 * pt
                    font: mainFont.dapFont.medium12
                    color: currTheme.textColor
                    text: isSynch ? qsTr("Sync network") : qsTr("On network")
                }
            }

        background: Rectangle {
            color: currTheme.buttonNetworkColorNoActive
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

    DropShadow {
        anchors.fill: control
        source: control
        color: currTheme.reflection
        horizontalOffset: -1
        verticalOffset: -1
        radius: 0
        samples: 0
        opacity: 1
        fast: true
        cached: true
    }
    DropShadow {
        anchors.fill: control
        source: control
        color: currTheme.shadowColor
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 20
        opacity: 1
    }
}
