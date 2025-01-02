import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import qmlclipboard 1.0

RowLayout {
    id: root

    property alias title: title
    property alias content: content.text
    property alias copyButton: copyButton
    Layout.fillWidth: true
    spacing: 0

    QMLClipboard{
        id: clipboard
    }


    Text {
        id: title
        Layout.alignment: Qt.AlignLeft
        Layout.fillHeight: true
        font: mainFont.dapFont.regular12
        color: currTheme.white
        Layout.maximumWidth: 138
        Layout.minimumWidth: 138
    }



    Text{

        Layout.alignment: Qt.AlignRight
        Layout.fillHeight: true
        Layout.maximumWidth: copyButton.visible ? 158 : 180
        Layout.minimumWidth: copyButton.visible ? 158 : 180
        id: content

        font: mainFont.dapFont.regular13
        color: currTheme.white

        elide: Text.ElideRight

        horizontalAlignment: Qt.AlignRight

        MouseArea{
            id: area
            anchors.fill: parent
            hoverEnabled: true
        }

        ToolTip{
            id: toolTip
            visible: area.containsMouse && content.width < content.implicitWidth
            width: text.implicitWidth + 16
            x: -toolTip.width/2 + 8
            y: -(height + 10)


            contentItem:
            Item{
                anchors.fill: parent
                anchors.margins: 8
                Text
                {
                    id: text
                    anchors.fill: parent
                    color: currTheme.white
                    text: content.text
                    font: content.font
                    horizontalAlignment: Qt.AlignHCenter
                    wrapMode: Text.WordWrap
                    verticalAlignment: Qt.AlignVCenter
                }
            }

            background:Item{
                Rectangle
                {
                    id: backgroundToolTip
                    anchors.fill: parent
                    radius: 4
                    color: currTheme.mainBackground
                }
                DropShadow {
                    anchors.fill: backgroundToolTip
                    source: backgroundToolTip
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
                    anchors.fill: backgroundToolTip
                    source: backgroundToolTip
                    color: currTheme.shadowColor
                    horizontalOffset: 2
                    verticalOffset: 2
                    radius: 10
                    samples: 20
                    opacity: 1
                }
            }
        }
    }

    DapCopyButton{
        id: copyButton
        Layout.leftMargin: 6
        visible: false
        popupText: qsTr("Key sign copied")
        onCopyClicked:
            clipboard.setText(content.text)
    }
}   //
