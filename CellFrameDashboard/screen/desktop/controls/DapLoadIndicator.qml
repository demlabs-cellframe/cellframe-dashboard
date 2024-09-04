import QtQuick 2.4
import QtQuick.Controls 2.0

BusyIndicator {

    property var indicatorSize: 16
    property var elementSize: 4
    property var elementRadius: 5
    property var countElements: 5
    property var colorElement: currTheme.lime

    id: control

    contentItem: Item {
        implicitWidth: indicatorSize
        implicitHeight: indicatorSize

        Item {
            id: item
            x: parent.width / 2 - indicatorSize/2
            y: parent.height / 2 - indicatorSize/2
            width: indicatorSize
            height: indicatorSize
            opacity: control.running ? 1 : 0

            Behavior on opacity {
                OpacityAnimator {
                    duration: 250
                }
            }

            RotationAnimator {
                target: item
                running: control.visible/* && control.running*/
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1250
            }

            Repeater {
                id: repeater
                model: countElements

                Rectangle {
                    x: item.width / 2 - width / 2
                    y: item.height / 2 - height / 2
                    implicitWidth: elementSize
                    implicitHeight: elementSize
                    radius: elementRadius
                    color: colorElement
                    transform: [
                        Translate {
                            y: -Math.min(item.width, item.height) * 0.5 + elementSize/2
                        },
                        Rotation {
                            angle: index / repeater.count * 360
                            origin.x: elementSize/2
                            origin.y: elementSize/2
                        }
                    ]
                }
            }
        }
    }
}
