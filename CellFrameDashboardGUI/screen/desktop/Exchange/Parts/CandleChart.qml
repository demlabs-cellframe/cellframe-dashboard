import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../logic"

/************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                    DapChartCandleStick
************************************************************************************************/

Item
{
    Canvas
    {
        id: chartCanvas

        anchors.fill: parent

        LogicCandleChart { id: logic }

//        ///@detalis currentValueTime Data update time for the current price value.
//        property alias currentValueTime: currentTimer.interval
//        ///@detalis timeReloadCanvas Screen refresh time when the graph is shifted.
//        property alias timeReloadCanvas: moveTimer.interval

        Component.onCompleted:
        {
            loadImage(logic.imageCursorPath)

            if (candleModel.count > 0)
                logic.rightTime = candleModel.get(candleModel.count-1).time + 20
            if (rowDataModel.count > 0)
                logic.currentValue = rowDataModel.get(rowDataModel.count-1).data

        }

        onPaint:
        {
            logic.canvasPaint()
        }

        //Price change timer.
        Timer
        {
            id:currentTimer
            repeat: true
            interval: 10000
            onTriggered:
            {
                logic.currentTime = new Date()
                if (isRightTimeCurrent)
                    rightTime = logic.currentTime
                logic.canvasPaint()
            }
        }

        MouseArea
        {
            id:areaCanvas
            anchors.fill: parent

            //Image refresh timer.
            Timer
            {
                id: moveTimer
                repeat: true
                interval: 30
                onTriggered:
                {
                    if(logic.rightTime < logic.currentTime)
                    {
                        logic.rightTime = logic.rightTime + (logic.positionMouseX-areaCanvas.mouseX)*logic.xRealFactor
                        logic.canvasPaint()
                        logic.positionMouseX = areaCanvas.mouseX
                        logic.isRightTimeCurrent = true
                    }
                    else
                    {
                        var tmpRightTime = (logic.positionMouseX-areaCanvas.mouseX)*logic.xRealFactor

                        if(tmpRightTime<0)
                        {
                            logic.rightTime = logic.rightTime + (logic.positionMouseX-areaCanvas.mouseX)*logic.xRealFactor
                            logic.canvasPaint()
                            logic.positionMouseX = areaCanvas.mouseX
                            logic.isRightTimeCurrent = false
                        }
                    }
                }
            }

            onPressed:
            {
                if(mouse.button === Qt.LeftButton)
                {
                    logic.positionMouseX = mouseX
                    moveTimer.start()
                }
            }

            onReleased:
            {
                moveTimer.stop()
                logic.autoSetDisplayCandle()
            }
        }


    }
}
