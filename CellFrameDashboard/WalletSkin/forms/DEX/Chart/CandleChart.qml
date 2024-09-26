import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item
{
//    ListModel{ id: dataModel }

//    ListModel{ id: candleModel }

    LogicCandleChart { id: logic }

    property alias candleLogic: logic

    property alias chartCanvas: chartCanvas

    Component.onCompleted:
    {
        console.log("CandleChart", "Component.onCompleted", "BEGIN")
        logic.backgroundColor = currTheme.secondaryBackground
        logic.redCandleColor = currTheme.red
        logic.greenCandleColor = currTheme.green

//        candleChartWorker.generatePriceData(1000000)
//        candleChartWorker.generatePriceData(100000)

        if (logicMainApp.simulationStock)
            candleChartWorker.setNewCandleWidth(logic.minute*0.25)
        else
            candleChartWorker.setNewCandleWidth(logic.minute)

//        updateTokenPrice()

        logic.dataAnalysis()

        updateTimer.start()

        console.log("CandleChart", "Component.onCompleted", "END")
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
    property bool mousePressed: false
    property bool mouseMoved: false
    property bool mouseVisibleChanged: false

    Timer
    {
        id: updateTimer
        repeat: true
        interval: 30
        onTriggered:
        {
//            console.log("updateTimer",
//                        "mousePressed", mousePressed,
//                        "mouseMoved", mouseMoved)

            if (mousePressed)
            {
//                console.log("mouseShift", mouseShift)

                logic.shiftTime(mouseShift)

                mouseStart += mouseShift
                mouseShift = 0
            }

            if (mouseMoved)
            {
//                console.log("mouseMoved update")

                mouseMoved = false

                chartCanvas.requestPaint()
            }

            if (mouseVisibleChanged)
            {
                mouseVisibleChanged = false

                chartCanvas.requestPaint()
            }

//            console.log("areaCanvas.containsMouse", areaCanvas.containsMouse)

//            areaCanvas.containsMouse
        }
    }

    MouseArea
    {
        id: areaCanvas

        anchors.fill: parent

        hoverEnabled: true

        onWheel:
        {
//            console.log("CandleChart", "onWheel", "BEGIN")

//            logic.zoomTime(wheel.angleDelta.y)
            logic.zoomTime(wheel.angleDelta.y)

//            console.log("CandleChart", "onWheel", "END")
        }

        onPressed:
        {
            swipeView.interactive = false

            if(mouse.button === Qt.LeftButton)
            {
//                console.log("onPressed")

                mousePressed = true

                mouseStart = mouse.x
                mouseShift = 0
            }
        }

        onPositionChanged:
        {
//            console.log("onPositionChanged", mouse.x, mouse.y)

            logic.mouseX = mouse.x
            logic.mouseY = mouse.y

            if (mousePressed)
                mouseShift = mouse.x - mouseStart

            mouseMoved = true
        }

        onReleased:
        {
//            console.log("onReleased")

            swipeView.interactive = true

            mousePressed = false
        }

        onEntered:
        {
//            console.log("onEntered")

            mouseVisibleChanged = true

            logic.mouseX = mouseX
            logic.mouseY = mouseY
            logic.mouseVisible = true
        }

        onExited:
        {
//            console.log("onExited")

            mouseVisibleChanged = true

            logic.mouseVisible = false
        }
    }

    function setCandleSize(width)
    {
        candleChartWorker.setNewCandleWidth(width)

        logic.dataAnalysis()

        chartCanvas.requestPaint()
    }

}
