import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item
{
    ListModel{ id: dataModel }

    ListModel{ id: candleModel }

    LogicCandleChart { id: logic }

    Component.onCompleted:
    {
        logic.generateData(10001)

        logic.resetRightTime()

//        logic.getCandleModel(rowDataModel, candleModel, 20)

        logic.dataAnalysis()
    }

    Canvas
    {
        id: chartCanvas

        anchors.fill: parent
//        smooth: true
        antialiasing: true

        onPaint:
        {
            var ctx = getContext("2d");

            logic.drawAll(ctx)
        }
    }

    property real mouseStart: 0
    property real mouseShift: 0

    MouseArea
    {
        id:areaCanvas

        anchors.fill: parent

//        hoverEnabled: true

        Timer
        {
            id: moveTimer
            repeat: true
            interval: 30
            onTriggered:
            {
                print("mouseShift", mouseShift)

                logic.shiftTime(mouseShift)

                mouseStart += mouseShift
                mouseShift = 0
            }
        }

        onWheel:
        {
            print("onWheel", wheel.angleDelta.y)

            logic.zoomTime(wheel.angleDelta.y)
        }

        onPressed:
        {
            if(mouse.button === Qt.LeftButton)
            {
//                print("onPressed", mouse.x)

                mouseStart = mouse.x
                mouseShift = 0

                moveTimer.start()
            }
        }

        onPositionChanged:
        {
//            print("onPositionChanged", mouse.x - mouseStart)

            mouseShift = mouse.x - mouseStart

        }

        onReleased:
        {
            moveTimer.stop()
        }
    }

}
