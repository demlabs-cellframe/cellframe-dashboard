import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import QtQuick.Layouts 1.3

Item
{
    id: root
    width: 17 * pt
    height: 18 * pt

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
        width: 120 * pt
        height: 60 * pt

        parent: root.parent
        x: root.x + root.width + 5 * pt
        y: root.y + root.height * 0.5 - height * 0.5

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
            anchors.margins: 2 * pt

            Text {
                id: dapContentTitle
                Layout.fillWidth: true
                Layout.leftMargin: 2
                Layout.rightMargin: 2
                //Layout.topMargin: 2
                font: mainFont.dapFont.medium12
                color: currTheme.textColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: "Address copied"
            }

            Image
            {
                Layout.preferredWidth: 20 * pt
                Layout.preferredHeight: 20 * pt
                Layout.alignment: Qt.AlignCenter
                source: "qrc:/resources/icons/" + pathTheme + "/check_icon.png"
            }
        }
    }
}
