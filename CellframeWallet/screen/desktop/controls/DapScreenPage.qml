import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Page {
    id: root
    property alias data: root.data
    property alias frame: back

    background: DapRectangleLitAndShaded {
        id: back

        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight
    }
}
