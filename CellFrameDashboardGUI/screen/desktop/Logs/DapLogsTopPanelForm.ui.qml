import QtQuick 2.4
import QtQuick.Controls 2.0
import "../../"
import "qrc:/widgets"

DapAbstractTopPanel
{
    id:topLogsPanel

    property alias buttonNormalColor: exportLogButton.colorBackgroundNormal

    //Export log button
    DapButton
    {
        id: exportLogButton
        textButton: "Export log"
        anchors.right: parent.right
        anchors.rightMargin: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        normalImageButton: "qrc:/resources/icons/icon_export.png"
        hoverImageButton: "qrc:/resources/icons/icon_export.png"
        height: 36 * pt
        width: 120 * pt
        widthImageButton: 28 * pt
        heightImageButton: 28 * pt
        indentImageLeftButton: 10 * pt
        colorBackgroundNormal:"#070023"
        colorBackgroundHover: "#D2145D"
        colorButtonTextNormal: "#FFFFFF"
        colorButtonTextHover: "#FFFFFF"
        indentTextRight: 10 * pt
        borderColorButton: "#000000"
        borderWidthButton: 0
        fontButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
        horizontalAligmentText:Qt.AlignRight
        colorTextButton: "#FFFFFF"
    }

    ///Handler for clicking the button exportLogButton
    Connections
    {
        target: exportLogButton
        onClicked:
        {
            grub();
            exportLogButton.colorBackgroundNormal = "#D2145D"
            saveWindow.sourceComponent = saveFile;
        }
    }

}

