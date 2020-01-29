import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"


DapRightPanel
{
    id: rightPanel

    property DapButton dapButtonClose: 
        DapButton
        {
            id: buttonClose
            height: 16 * pt
            width: 16 * pt
            heightImageButton: 16 * pt
            widthImageButton: 16 * pt
            colorBackgroundNormal: "#F8F7FA"
            colorBackgroundHover: "#F8F7FA"
            normalImageButton: "qrc:/res/icons/close_icon.png"
            hoverImageButton: "qrc:/res/icons/close_icon_hover.png"
        }
    
    dapHeader.height: 36 * pt
    color: "#F8F7FA"
}
