import QtQuick 2.4
import "qrc:/widgets"

DapTopPanel
{
    dapFrame.height: 60 * pt
    dapFrame.color: "transparent"
    anchors.fill: parent

    dapTopPanelBackground:
        Rectangle
        {
            id: headerRoundedBackground
            width: dapFrame.width
            height: dapFrame.height
            color: "#211A3A"
            radius: 8 * pt
        }

    dapTopPanelRectangleBackground:
        Rectangle
        {
            id: headerUnroundedBackground
            width: dapTopPanelBackground.radius
            height: dapTopPanelBackground.height
            color: "#211A3A"
        }

}
