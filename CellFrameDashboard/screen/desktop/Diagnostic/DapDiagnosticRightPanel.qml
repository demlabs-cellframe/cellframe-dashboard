import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "Parts"

ColumnLayout {
    spacing: 24

    DapRectangleLitAndShaded {
        Layout.fillWidth: true
        Layout.fillHeight: true

        color: currTheme.secondaryBackground
        radius: 12
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData: TrackedNodesBlock{}
    }

    DapRectangleLitAndShaded {
        Layout.fillWidth: true
        Layout.fillHeight: true

        color: currTheme.secondaryBackground
        radius: 12
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData: AllNodesBlock{}
    }
}
