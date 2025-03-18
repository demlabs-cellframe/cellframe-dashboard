import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import "qrc:/widgets"

Page
{

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 24 
                anchors.topMargin: 10 
                anchors.bottomMargin: 10 
                font: mainFont.dapFont.bold14
                color: currTheme.white
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Earned funds")
            }
        }
        Item
        {
            Layout.fillHeight: true
        }
    }
}


