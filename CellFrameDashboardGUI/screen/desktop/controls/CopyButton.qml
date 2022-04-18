import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import QtQuick.Layouts 1.3

Item
{
    width: 170 * pt
    height: 180 * pt

    signal copyClicked()

    Image
    {
        id:networkAddressCopyButtonImage
        width: parent.width
        height: parent.height
        source: "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            popup.open()
            copyClicked()
        }
    }

    Popup
    {
        id: popup
        width: 300 * pt
        height: 200 * pt

        parent: Overlay.overlay
        x: (parent.width - width) * 0.5
        y: (parent.height - height) * 0.5

        modal: true

        background: Rectangle
        {
            border.width: 0
            radius: 16 * pt
            color: currTheme.backgroundElements
        }
        focus: true

        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: 10 * pt

            Text {
                id: dapContentTitle
                Layout.fillWidth: true
                Layout.leftMargin: 5
                Layout.rightMargin: 5
                Layout.topMargin: 5
                font: mainFont.dapFont.medium16
                color: currTheme.textColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: "Address copied"
            }

            Image
            {
                Layout.preferredWidth: 40 * pt
                Layout.preferredHeight: 40 * pt
                Layout.alignment: Qt.AlignCenter
                source: "qrc:/resources/icons/" + pathTheme + "/check_icon.png"
            }
        }
    }
}
