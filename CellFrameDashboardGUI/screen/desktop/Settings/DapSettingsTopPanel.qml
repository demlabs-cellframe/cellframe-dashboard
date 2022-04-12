import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "../controls" as Controls
import "qrc:/widgets" as Widgets

Controls.DapTopPanel
{
    Text {
        id: vesion
        anchors
        {
            right: parent.right
            top: parent.top
            rightMargin: 24 * pt
            topMargin: 23 * pt
        }

        text: qsTr( "Version " + dapServiceController.Version)
        font: mainFont.dapFont.regular12
        color: currTheme.textColor

    }


    RowLayout {
        anchors
        {
            right: vesion.left
            top: parent.top
            rightMargin: 24 * pt
            topMargin: 23 * pt
        }

        Text {
            id: notifyStateText

            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true

            text: qsTr( "Node connection status " )
            font: mainFont.dapFont.regular12
            color: currTheme.textColor
            elide: Text.ElideMiddle
        }

        Widgets.DapImageLoader {
            id: notifyState
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: 8 * pt
            Layout.preferredWidth: 8 * pt
            innerWidth: 8 * pt
            innerHeight: 8 * pt

            source: logicMainApp.stateNotify? "qrc:/resources/icons/" + pathTheme + "/indicator_online.png":
                                 "qrc:/resources/icons/" + pathTheme + "/indicator_error.png"

        }
    }
}
