import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "../../controls"
import "qrc:/widgets"

Item
{
    property string headerName: ""
    property bool exitToRoot: false

    Layout.fillWidth: true
    height: 42

    signal closePage()

    HeaderButtonForRightPanels
    {
        id: itemButtonClose
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 16

        height: 20
        width: 20
        heightImage: 20
        widthImage: 20

        normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
        hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"

        onClicked:
        {
            closePage()

            if (exitToRoot)
                navigator.popPage()
            else
                root.dapRightPanel.pop()
        }
    }

    Text
    {
        id: textHeader
        text: headerName
        verticalAlignment: Qt.AlignLeft
        anchors.left: itemButtonClose.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10

        font: mainFont.dapFont.bold14
        color: currTheme.white
    }
}
