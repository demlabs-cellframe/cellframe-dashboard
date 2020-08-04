import QtQuick 2.5
import QtQuick.Controls 2.12
import "qrc:/widgets"
import QtGraphicalEffects 1.0

ListView
{
    id: root
    delegate: delegateComponent
    spacing: 13 * pt
    clip: true

    ScrollBar.vertical: ScrollBar
    {
        id: scrollBar
        anchors.right: parent.right
        width: 6
        background: Rectangle {
            anchors.fill: parent
            color: "#E2E1E6"
        }

        // A reduced scrollBar indicator was written in the layout,
        // but unfortunately qml at this point breaks down and does not change the size of the element,
        // unless you use a large number of elements
        contentItem: Rectangle {
            width: 5
            height: 15
            radius: 2
            color: "#B0AEB9"
            implicitHeight: height
            implicitWidth: width
        }
    }

    Component {
        id: delegateComponent
        Item {
            width: root.width - scrollBar.width
            height: (componentHeader.height + (headerMessageTitle.visible ? headerMessageTitle.height : 0) + unitsSection.height * 4) * pt

            Rectangle{
                id: componentHeader
                width: parent.width
                height: 30*pt
                color: "#3E3853"

                Text {
                    id: vpnOrdersTitleText
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.medium12
                    color: "#FFFFFF"
                    text: name
                }

                Rectangle {
                    id: headerSwitch

                    property bool status: false

                    onStatusChanged:
                    {
                        switchHandle.x = !headerSwitch.status ? 3 : headerSwitch.width - switchHandle.width - 3
                    }

                    width: 43 * pt
                    height: 20 * pt
                    anchors.verticalCenter: parent.verticalCenter
                    x: (parent.width - width - 5) * pt
                    color: "transparent"
                    border.color: headerSwitch.status ? "#FFFFFF" : "#757184"
                    border.width: 1 * pt
                    radius: 10 * pt

                    Component.onCompleted:
                    {
                        behaviorOnX.enabled = false
                        headerSwitch.status = switchedOn
                        behaviorOnX.enabled = true
                    }

                    Rectangle
                    {
                        id: switchHandle
                        width: 14 * pt
                        height: 14 * pt
                        radius: width / 2
                        anchors.verticalCenter: parent.verticalCenter
                        color: headerSwitch.status ? "#FFFFFF" : "#757184"
                        x: 3
                        Behavior on x {
                            id: behaviorOnX
                            enabled: false
                            NumberAnimation{duration: 150}
                        }
                    }

                    MouseArea
                    {
                        id: headerSwitchArea
                        anchors.fill: parent
                        onClicked:
                        {
                            headerSwitch.status = !headerSwitch.status
                            switchedOn = headerSwitch.status
                        }

                    }

                }
            }
            Rectangle{
                id: headerMessageTitle
                anchors.top: componentHeader.bottom
                width: parent.width
                height: 20 * pt
                color: "#ECECEC"
                visible: unsafe || speedLimit >= 0
                Text {
                    id: unsafeMessageText
                    visible: unsafe
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.medium10
                    color: "#FF0000"
                    text: qsTr("Potentially unsafe connection for your personal data")
                }
                Text {
                    id: speedLimitMessageText
                    visible: !unsafe && speedLimit >= 0
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.medium10
                    color: "#79AD02"
                    text: qsTr("Promo with speed limit " + speedLimit + " Mb")
                }
            }
            Rectangle{
                id: unitsSection
                anchors.top: headerMessageTitle.visible ? headerMessageTitle.bottom : componentHeader.bottom
                width: root.width
                height: 30*pt
                color: "transparent"

                Text {
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#757184"
                    text: "Units"
                }

                Text {
                    x: (parent.width - width - 15) * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#211A3A"
                    text: units
                }
            }
            Rectangle{
                id: unitsTypeSection
                anchors.top: unitsSection.bottom
                width: root.width
                height: 30*pt
                color: "transparent"

                Text {
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#757184"
                    text: "Units Type"
                }

                Text {
                    x: (parent.width - width - 15) * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#211A3A"
                    text:
                    {
                        switch (unitsType)
                        {
                        case 0: return "seconds"
                        case 1: return "minutes"
                        case 2: return "hours"
                        case 3: return "days"
                        case 4: return "kilobyte"
                        case 5: return "megabyte"
                        case 6: return "gigabyte"
                        }

                    }
                }
            }
            Rectangle{
                id: valueSection
                anchors.top: unitsTypeSection.bottom
                width: root.width
                height: 30*pt
                color: "transparent"

                Text {
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#757184"
                    text: "Value"
                }

                Text {
                    x: (parent.width - width - 15) * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#211A3A"
                    text: value
                }
            }
            Rectangle{
                id: tokenSection
                anchors.top: valueSection.bottom
                width: root.width
                height: 30*pt
                color: "transparent"

                Text {
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#757184"
                    text: "Token"
                }

                Text {
                    x: (parent.width - width - 15) * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#211A3A"
                    text: token
                }
            }
        }
    }

}
