import QtQuick 2.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"


DapRightPanel
{
    id: rightPanel

    property DapButton dapButtonClose: 
        DapButton
        {
            id: buttonClose
            height: 20 * pt
            width: 20 * pt
            heightImageButton: 10 * pt
            widthImageButton: 10 * pt
            colorBackgroundNormal: currTheme.backgroundElements
            colorBackgroundHover: currTheme.backgroundElements
            normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
            hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"
        }
    
    dapHeader.height: 36 * pt

}
