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
        logic.backgroundColor = currTheme.backgroundElements
        logic.redCandleColor = currTheme.textColorRed
        logic.greenCandleColor = currTheme.textColorGreen

        logic.generateData(10001)

        logic.setCandleWidth(logic.minute)
//        logic.getCandleModel(10000)

        logic.resetRightTime()

//        logic.getCandleModel(rowDataModel, candleModel, 20)

//        logic.dataAnalysis()
    }

    property bool analysisNeeded: false

    Canvas
    {
        id: chartCanvas

        anchors.fill: parent
//        smooth: true
        antialiasing: true

        onPaint:
        {
            if (analysisNeeded)
            {
                analysisNeeded = false

                logic.dataAnalysis()
            }

            var ctx = getContext("2d");

            logic.drawAll(ctx)
        }

        onWidthChanged:
        {
            analysisNeeded = true

            requestPaint()
        }

        onHeightChanged:
        {
            analysisNeeded = true

            requestPaint()
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
//                print("mouseShift", mouseShift)

                logic.shiftTime(mouseShift)

                mouseStart += mouseShift
                mouseShift = 0
            }
        }

        onWheel:
        {
//            print("onWheel", wheel.angleDelta.y)

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

    function setCandleSize(index)
    {
        logic.resetRightTime()

        switch (index)
        {
        default:
            logic.setCandleWidth(logic.minute)
            break
        case 1:
            logic.setCandleWidth(logic.minute*2)
            break
        case 2:
            logic.setCandleWidth(logic.minute*5)
            break
        case 3:
            logic.setCandleWidth(logic.minute*15)
            break
        case 4:
            logic.setCandleWidth(logic.minute*30)
            break
        case 5:
            logic.setCandleWidth(logic.hour)
            break
        case 6:
            logic.setCandleWidth(logic.hour*4)
            break
        case 7:
            logic.setCandleWidth(logic.hour*12)
            break
        case 8:
            logic.setCandleWidth(logic.day)
            break
        case 9:
            logic.setCandleWidth(logic.day*3)
            break
        case 10:
            logic.setCandleWidth(logic.day*7)
            break
        case 11:
            logic.setCandleWidth(logic.day*14)
            break
        case 12:
            logic.setCandleWidth(logic.day*30)
            break
        }

        chartCanvas.requestPaint()
    }

}
