import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0

Popup {
    id: networkInfoPupup
    y: footer.y-height
    width: 300
    height: 150
    padding: 1
    focus: true
    closePolicy: Popup.CloseOnEscape
    visible: false

    property variant networkState
    property variant error
    property variant targetState
    property variant linksCount
    property variant linksFrom
    property variant address

    background: Rectangle {
        color: "#070023"
        border.color: "grey"
    }

    RowLayout {
        spacing: 0
        Button {
            id: buttonSync
            Layout.preferredWidth: parent.parent.width / 2

            contentItem: Text {
                text: "Sync Network"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            background: Rectangle {
                color: buttonSync.hovered ? "#D51F5D" : "#070023"
                border.width: 1
                border.color: "grey"
            }
//            onClicked:
        }


        Button {
            id: buttonOn
            Layout.preferredWidth: parent.parent.width / 2

            contentItem: Text {
                text: "On network"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            background: Rectangle {
                color: buttonOn.hovered ? "#D51F5D" : "#070023"
                border.width: 1
                border.color: "grey"
            }
//            onClicked:
        }
    }

    Text {
        anchors.centerIn: parent

        text:   '<font color="white"><b>State: </b>' + networkState + '<br />' +
                '<font color="red">' + error + '</font><br />' +
                '<b>Target state: </b>' + targetState + '<br />' +
                '<b>Active links: </b>' + linksCount + ' from ' + linksFrom + '<br />' +
                '<b>Address: </b>' + address + '</font>'
    }
}
