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
        print("CandleChart", "Component.onCompleted", "BEGIN")
        logic.backgroundColor = currTheme.backgroundElements
        logic.redCandleColor = currTheme.textColorRed
        logic.greenCandleColor = currTheme.textColorGreen

//        dataWorker.generatePriceData(1000000)
        dataWorker.generatePriceData(1000000)

        dataWorker.getMinimumMaximum24h()

        dataWorker.setNewCandleWidth(logic.minute)

        updateTokenPrice()

        logic.dataAnalysis()

        updateTimer.start()

        generateTimer.start()

        print("CandleChart", "Component.onCompleted", "END")
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
            dataWorker.setNewCandleWidth(logic.minute)
            break
        case 1:
            dataWorker.setNewCandleWidth(logic.minute*2)
            break
        case 2:
            dataWorker.setNewCandleWidth(logic.minute*5)
            break
        case 3:
            dataWorker.setNewCandleWidth(logic.minute*15)
            break
        case 4:
            dataWorker.setNewCandleWidth(logic.minute*30)
            break
        case 5:
            dataWorker.setNewCandleWidth(logic.hour)
            break
        case 6:
            dataWorker.setNewCandleWidth(logic.hour*4)
            break
        case 7:
            dataWorker.setNewCandleWidth(logic.hour*12)
            break
        case 8:
            dataWorker.setNewCandleWidth(logic.day)
            break
        case 9:
            dataWorker.setNewCandleWidth(logic.day*3)
            break
        case 10:
            dataWorker.setNewCandleWidth(logic.day*7)
            break
        case 11:
            dataWorker.setNewCandleWidth(logic.day*14)
            break
        case 12:
            dataWorker.setNewCandleWidth(logic.day*30)
            break
        }

        logic.dataAnalysis()

        chartCanvas.requestPaint()
    }

}
