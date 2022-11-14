import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item
{
    ListModel{ id: dataModel }

    ListModel{ id: candleModel }

    LogicCandleChart { id: logic }

    property alias candleLogic: logic

    property alias chartCanvas: chartCanvas

    Component.onCompleted:
    {
//        print("CandleChart", "Component.onCompleted", "BEGIN")
        logic.backgroundColor = currTheme.backgroundElements
        logic.redCandleColor = currTheme.textColorRed
        logic.greenCandleColor = currTheme.textColorGreen

//        candleChartWorker.generatePriceData(1000000)
//        candleChartWorker.generatePriceData(100000)

        if (logicMainApp.simulationStock)
            candleChartWorker.setNewCandleWidth(logic.minute*0.25)
        else
            candleChartWorker.setNewCandleWidth(logic.minute)

        updateTokenPrice()

        logic.dataAnalysis()

        updateTimer.start()

//        print("CandleChart", "Component.onCompleted", "END")
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
//                print("mouseShift", mouseShift)
            if (mousePressed)
            {
                logic.shiftTime(mouseShift)

                mouseStart += mouseShift
                mouseShift = 0
            }

            if (mouseMoved)
            {
                mouseMoved = false

                chartCanvas.requestPaint()
            }

            if (mouseVisibleChanged)
            {
                mouseVisibleChanged = false

                chartCanvas.requestPaint()
            }
        }
    }

    MouseArea
    {
        id:areaCanvas

        anchors.fill: parent

        hoverEnabled: true

        onWheel:
        {
//            print("CandleChart", "onWheel", "BEGIN")

//            logic.zoomTime(wheel.angleDelta.y)
            logic.zoomTime(wheel.angleDelta.y)

//            print("CandleChart", "onWheel", "END")
        }

        onPressed:
        {
            if(mouse.button === Qt.LeftButton)
            {
//                print("onPressed")

                mousePressed = true

                mouseStart = mouse.x
                mouseShift = 0
            }
        }

        onPositionChanged:
        {
//            print("onPositionChanged", mouse.x, mouse.y)
            logic.mouseX = mouse.x
            logic.mouseY = mouse.y

            if (mousePressed)
                mouseShift = mouse.x - mouseStart

            mouseMoved = true
        }

        onReleased:
        {
//            print("onReleased")

            mousePressed = false
        }

        onEntered:
        {
//            print("onEntered")

            mouseVisibleChanged = true

            logic.mouseX = mouseX
            logic.mouseY = mouseY
            logic.mouseVisible = true
        }

        onExited:
        {
//            print("onExited")

            mouseVisibleChanged = true

            logic.mouseVisible = false
        }
    }

    function setCandleSize(index)
    {
        switch (index)
        {
        default:
            if (logicMainApp.simulationStock)
                candleChartWorker.setNewCandleWidth(logic.minute*0.25)
            else
                candleChartWorker.setNewCandleWidth(logic.minute)
            break
        case 1:
            candleChartWorker.setNewCandleWidth(logic.minute*2)
            break
        case 2:
            candleChartWorker.setNewCandleWidth(logic.minute*5)
            break
        case 3:
            candleChartWorker.setNewCandleWidth(logic.minute*15)
            break
        case 4:
            candleChartWorker.setNewCandleWidth(logic.minute*30)
            break
        case 5:
            candleChartWorker.setNewCandleWidth(logic.hour)
            break
        case 6:
            candleChartWorker.setNewCandleWidth(logic.hour*4)
            break
        case 7:
            candleChartWorker.setNewCandleWidth(logic.hour*12)
            break
        case 8:
            candleChartWorker.setNewCandleWidth(logic.day)
            break
        case 9:
            candleChartWorker.setNewCandleWidth(logic.day*7)
            break
        case 10:
            candleChartWorker.setNewCandleWidth(logic.day*14)
            break
        case 11:
            candleChartWorker.setNewCandleWidth(logic.day*30)
            break
        }

        logic.dataAnalysis()

        chartCanvas.requestPaint()
    }

}
