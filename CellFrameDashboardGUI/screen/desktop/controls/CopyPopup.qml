import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.4
import "qrc:/widgets"

Rectangle {
    id: popup

    readonly property int showDelay: 1000
    readonly property int hideDelay: 500

    width: 170 * pt
    height: 40 * pt

    x: (parent.width - width) * 0.5
    y: 10 * pt
    z: 100

    opacity: 1

    Behavior on opacity {
        NumberAnimation {
            duration: hideDelay
        }
    }

    Timer {
        interval: showDelay; running: true; repeat: false
        onTriggered: popup.opacity = 0.0
    }

    Timer {
        interval: showDelay+hideDelay; running: true; repeat: false
        onTriggered: popup.destroy()
    }

    border.width: 1 * pt
    border.color: currTheme.lineSeparatorColor
    radius: 16 * pt
    color: currTheme.backgroundElements

    RowLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 15 * pt
        anchors.rightMargin: 10 * pt
        anchors.topMargin: 8 * pt
        anchors.bottomMargin: 10 * pt

        Text {
            id: dapContentTitle
            Layout.fillWidth: true
            font: mainFont.dapFont.medium14
            color: currTheme.textColor
            verticalAlignment: Qt.AlignTop

            text: qsTr("Address copied")
        }

        DapImageLoader
        {
            innerWidth: 20
            innerHeight: 20
            source: "qrc:/resources/icons/" + pathTheme + "/check_icon.png"
        }

    }

}
