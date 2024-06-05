import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"
import "qrc:/"

Page
{
    id: dapMasterNodeScreen

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    DapRectangleLitAndShaded
    {
        id: consoleRectangle
        anchors.fill: parent
        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
        Item
        {
            anchors.fill: parent

            InnerShadow {
                anchors.fill: suggestionsBox
                horizontalOffset: 1
                verticalOffset: 1
                samples: 4
                cached: true
                opacity: 1.0
                color: currTheme.reflection
                source: suggestionsBox
                visible: suggestionsBox.visible
                z: 4 + 100
            }

            DropShadow {
                    anchors.fill: suggestionsBox
                    horizontalOffset: 6
                    verticalOffset: 6
                    radius: 8.0
                    samples: 17
                    opacity: 0.7
                    color: "#80000000"
                    source: suggestionsBox
                    visible: suggestionsBox.visible
                    z: 4
                }
        }
    }
}
