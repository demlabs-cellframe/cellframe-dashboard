import QtQuick 2.12
import QtQml 2.12


QtObject
{
    property int fontSize: 11
    property string fontFamilies: "Quicksand"
    property int fontIndent: 3

    property string gridColor: "#a0a0a0"
    property string gridTextColor: "#a0a0a0"
    property string backgroundColor: "#404040"
    property string darkBackgroundColor: "#303030"

    property string labelColor: "#ffffff"
    property string labelBackgroundColor: "#40303030"
    property string labelLineColor: "#40ffffff"
    property real labelLineLength: 30

    property string redCandleColor: "#80ff0000"
    property string greenCandleColor: "#8000ff00"

    property string sightColor: "#60ffffff"

    property real gridWidth: 0.2
    property real candleLineWidth: 2

    property real mouseX: -10
    property real mouseY: -10
    property bool mouseVisible: false

    property real coefficientTime: 0
    property real coefficientPrice: 0

    property int maxStepNumberTime: 8
    property real roundedStepTime: 0
    property real roundedMaxTime: 0

    property int maxStepNumberPrice: 8
    property real roundedStepPrice: 0
    property real roundedMaxPrice: 0

    readonly property real roundedCoefficient: 1

    property real lastCandleOpen: 0
    property real lastCandleClose: 0

    property real measurementScaleWidth: 60
    property real chartTextHeight: 20
    property real chartBorderHeight: 10
    property real measurementScaleHeight: 20
    property real chartWidth: width - measurementScaleWidth
    property real chartDrawHeight: height -
        measurementScaleHeight - chartTextHeight - chartBorderHeight*2
    property real chartFullHeight: height -
        measurementScaleHeight
    property real chartCandleBegin: chartTextHeight + chartBorderHeight

    property int selectedCandleNumber: -1

//    property int rightCandleNumber: 0

    readonly property int day: 86400000
    readonly property int hour: 3600000
    readonly property int minute: 60000
    readonly property int second: 1000

    signal chandleSelected( var timeValue,
        var openValue, var highValue, var lowValue, var closeValue)

    function drawAll(ctx)
    {
        if (!mouseVisible)
            selectedCandleNumber = dataWorker.lastCandleNumber

        ctx.fillStyle = backgroundColor
//        ctx.fillStyle = Qt.rgba(1, 1, 1, 1)
        ctx.fillRect(0, 0, width, height)

        drawGrid(ctx)

        drawChart(ctx, 0, "#00ffff")
        drawChart(ctx, 1, "#2090cf")
        drawChart(ctx, 2, "#4040af")

        drawCandleChart(ctx)

        drawMinMax(ctx)

        drawGridText(ctx)

//        drawLineAndLabel(ctx, 200, 100, 123432423.345623948)

//        drawLineAndLabel(ctx, 500, 100, 123432423.345623948)

        if (mouseVisible)
            drawSight(ctx)

//        drawCandle(ctx, 200, 50, 60, 180, 205, 50, "red")
    }

    function dataAnalysis()
    {
        dataWorker.dataAnalysis()

        if (dataWorker.maxPrice > dataWorker.minPrice)
            coefficientPrice = chartDrawHeight/
                    (dataWorker.maxPrice - dataWorker.minPrice)
        if (dataWorker.visibleTime > 0)
            coefficientTime = chartWidth/dataWorker.visibleTime

        getRoundedStepPrice()

        getRoundedStepTime()

    }

    function getRoundedStepPrice()
    {
        var realStep = (dataWorker.maxPrice - dataWorker.minPrice)/
                maxStepNumberPrice

//        print("minY", minY, "maxY", maxY)
//        print("maxY - minY", maxY - minY)
//        print("realStep", realStep)

        var digit = 0.000000000000000001

        while (digit*10 < realStep)
            digit *= 10

//        print("digit", digit)

        roundedStepPrice = digit

        if (digit*2 > realStep)
            roundedStepPrice = digit*2
        else
        if (digit*5 > realStep)
            roundedStepPrice = digit*5
        else
            roundedStepPrice = digit*10

        roundedMaxPrice = dataWorker.maxPrice -
                dataWorker.maxPrice%roundedStepPrice

//        print("roundedStepPrice", roundedStepPrice,
//              "roundedMaxPrice", roundedMaxPrice)

//        while (roundedMaxY > minY)
//        {
//            print(roundedMaxY)
//            roundedMaxY -= roundedStepY
//        }
    }

    property var timeSteps:
        ( new Uint32Array(
             [1,
              2,
              5,
              10,
              20,
              1*minute/second,
              2*minute/second,
              5*minute/second,
              10*minute/second,
              20*minute/second,
              30*minute/second,
              1*hour/second,
              2*hour/second,
              4*hour/second,
              6*hour/second,
              12*hour/second,
              1*day/second,
              2*day/second,
              5*day/second,
              7*day/second,
              10*day/second,
              15*day/second,
              30*day/second,
              45*day/second,
              60*day/second,
              90*day/second,
              150*day/second,
              200*day/second,
              300*day/second]))

    property string timeMask: "yyyy-MM-dd hh:mm:ss"

    property int timeStepsIndex: 0

    function getRoundedStepTime()
    {
        var realStep = (dataWorker.maxTime - dataWorker.minTime)/
                maxStepNumberTime

        timeStepsIndex = 0
        roundedStepTime = timeSteps[timeStepsIndex]*second

        while (timeSteps[timeStepsIndex]*second < realStep &&
               timeStepsIndex < timeSteps.length-1)
        {
            ++timeStepsIndex
            roundedStepTime = timeSteps[timeStepsIndex]*second
        }

//        print("timeStepsIndex", timeStepsIndex,
//              "roundedStepTime", roundedStepTime)

        if (timeStepsIndex < 5)
            timeMask = "hh:mm:ss"
        else
        if (timeStepsIndex < 12)
            timeMask = "hh:mm"
        else
        if (timeStepsIndex < 15)
            timeMask = "MM/dd hh:mm"
        else
        if (timeStepsIndex < 22)
            timeMask = "MM/dd"
        else
            timeMask = "yy/MM/dd"

//        print("step", realStep, "roundedStep", roundedStepTime)

        roundedMaxTime = dataWorker.maxTime -
                dataWorker.maxTime%roundedStepTime

        if (timeStepsIndex > 10)
        {
            roundedMaxTime -= hour*3

//            print("maxX%roundedStepX", maxX%roundedStepX,
//                  "roundedStepX", roundedStepX,
//                  "hour*3", hour*3)

            while (roundedMaxTime < dataWorker.maxTime -
                   dataWorker.maxTime%roundedStepTime)
                roundedMaxTime += roundedStepTime

//            while (roundedStepTime < hour*3 + dataWorker.maxTime%roundedStepTime)
//                roundedMaxTime += roundedStepTime
        }

    }

    function zoomTime(step)
    {
        if (dataWorker.zoomTime(step))
        {
            dataAnalysis()

            chartCanvas.requestPaint()
        }
    }

    function shiftTime(step)
    {
        if (step !== 0)
        {
            dataWorker.shiftTime(step / coefficientTime)

            dataAnalysis()

            chartCanvas.requestPaint()
        }
    }

    function drawGrid(ctx)
    {
        var currentX = roundedMaxTime
        while (currentX > dataWorker.minTime)
        {
            drawVerticalLine(ctx,
                (currentX - dataWorker.minTime)*coefficientTime)

//            print(currentX)
            currentX -= roundedStepTime
        }

        var currentY = roundedMaxPrice
        while (currentY > dataWorker.minPrice)
        {
            drawHorizontalLine(ctx,
                (dataWorker.maxPrice - currentY)*coefficientPrice +
                               chartCandleBegin)

//            print(currentY)
            currentY -= roundedStepPrice
        }

    }

    function drawGridText(ctx)
    {
        ctx.fillStyle = backgroundColor
        ctx.fillRect(width-measurementScaleWidth, 0,
                     measurementScaleWidth, height)
        ctx.fillRect(0, height-measurementScaleHeight,
                     width, height)

        var date
        var currentX = roundedMaxTime

        while (currentX > dataWorker.minTime)
        {
            date = new Date(currentX)

            drawVerticalLineText(ctx,
                (currentX - dataWorker.minTime)*coefficientTime,
                date.toLocaleString(Qt.locale("en_EN"), timeMask),
                gridTextColor)

//            print(currentX)
            currentX -= roundedStepTime
        }

        var outText = ""

        if (mouseVisible && mouseX <= chartWidth)
        {
            date = new Date((dataWorker.minTime + mouseX/coefficientTime))

            outText = date.toLocaleString(Qt.locale("en_EN"), "MM/dd hh:mm")

//            print("X", outText)

            drawVerticalLineText(ctx,
                mouseX,
                outText,
                "white", true)
        }

        var currentY = roundedMaxPrice
        while (currentY > dataWorker.minPrice)
        {
            outText = currentY
            drawHorizontalLineText(ctx,
                (dataWorker.maxPrice - currentY)*coefficientPrice +
                                   chartCandleBegin,
                outText, gridTextColor)

//            print(currentY)
            currentY -= roundedStepPrice
        }

        outText = lastCandleClose

        var priceColor = greenCandleColor
        if (lastCandleClose < lastCandleOpen)
            priceColor = redCandleColor

        var priceY = (dataWorker.maxPrice - lastCandleClose)*coefficientPrice +
                chartCandleBegin

        if (priceY > 0 && priceY <= chartFullHeight)
            drawHorizontalLineText(ctx,
                priceY,
                outText,
                priceColor, true)

        if (mouseVisible && mouseY <= chartFullHeight)
        {
            outText = (dataWorker.maxPrice - (mouseY-chartCandleBegin)/coefficientPrice)

            drawHorizontalLineText(ctx,
                mouseY,
                outText,
                "white", true)
        }
    }

    function drawSight(ctx)
    {
        ctx.strokeStyle = sightColor
        ctx.setLineDash([4, 2])
        ctx.lineWidth = 2

        if(mouseY <= chartFullHeight)
        {
            ctx.beginPath()
            ctx.moveTo(chartWidth, mouseY)
            ctx.lineTo(0, mouseY)
            ctx.stroke()
        }

        if(mouseX <= chartWidth)
        {
            ctx.beginPath()
            ctx.moveTo(mouseX, chartFullHeight)
            ctx.lineTo(mouseX, 0)
            ctx.stroke()
        }
        ctx.setLineDash([])
    }

    function drawChart(ctx, chart, color)
    {
//        print("firstVisibleAverage", dataWorker.firstVisibleAverage,
//              "lastVisibleAverage", dataWorker.lastVisibleAverage)

        for (var i = dataWorker.getFirstVisibleAverage(chart);
             i < dataWorker.getLastVisibleAverage(chart); ++i)
        {
            var info1 = dataWorker.getAveragedInfo(chart, i)
            var info2 = dataWorker.getAveragedInfo(chart, i+1)

//            print("info1", i, info1.time, info1.price,
//                  "info2", i+1, info2.time, info2.price)

            drawChartLine(ctx,
                (info1.time - dataWorker.rightTime +
                    dataWorker.visibleTime)*coefficientTime,
                (dataWorker.maxPrice - info1.price)*coefficientPrice +
                    chartCandleBegin,
                (info2.time - dataWorker.rightTime +
                    dataWorker.visibleTime)*coefficientTime,
                (dataWorker.maxPrice - info2.price)*coefficientPrice +
                    chartCandleBegin,
                color)
        }
    }

    function drawCandleChart(ctx)
    {
        var realCandleWidth = dataWorker.candleWidth*0.98*coefficientTime - 1
        var mouseCandleWidth = dataWorker.candleWidth*coefficientTime

        var selectedChange = false

        if (mouseX > chartWidth)
            selectedCandleNumber = dataWorker.lastCandleNumber

        for (var i = dataWorker.firstVisibleCandle;
             i <= dataWorker.lastVisibleCandle; ++i)
        {
            var candle = dataWorker.getCandleInfo(i)

            var redCandle = true

            if (candle.open < candle.close)
                redCandle = false

            var color = redCandleColor
            var up = candle.open
            var down = candle.close

            if (!redCandle)
            {
                color = greenCandleColor
                up = candle.close
                down = candle.open
            }

            var candleX = (candle.time - dataWorker.rightTime +
                           dataWorker.visibleTime)*coefficientTime

            if (mouseVisible &&
                candleX > mouseX - mouseCandleWidth*0.5 &&
                candleX < mouseX + mouseCandleWidth*0.5)
            {
                if (selectedCandleNumber !== i)
                {
                    selectedCandleNumber = i

                    selectedChange = true
//                    print("selectedCandle", selectedCandle)
                }

            }

            if (selectedCandleNumber === i)
            {
                if (!redCandle)
                    color = "#B1FF00"
                else
                    color = "#FF3232"
//                    color = "#FF9797"
            }

            drawCandle(ctx,
                candleX,
                (dataWorker.maxPrice - candle.maximum)*coefficientPrice +
                       chartCandleBegin,
                (dataWorker.maxPrice - up)*coefficientPrice + chartCandleBegin,
                (dataWorker.maxPrice - down)*coefficientPrice + chartCandleBegin,
                (dataWorker.maxPrice - candle.minimum)*coefficientPrice +
                       chartCandleBegin,
                realCandleWidth, color)

            lastCandleOpen = candle.open
            lastCandleClose = candle.close
        }

        if (selectedChange ||
            selectedCandleNumber === dataWorker.lastCandleNumber)
        {
//            print("selectedChange", selectedChange,
//                  selectedCandleNumber, dataWorker.lastCandleNumber)

            var selCandle = dataWorker.getCandleInfo(selectedCandleNumber)

            chandleSelected(
                        selCandle.time,
                        selCandle.open,
                        selCandle.maximum,
                        selCandle.minimum,
                        selCandle.close)
        }

        ctx.lineCap = "butt"
        ctx.restore()
        ctx.beginPath()
        ctx.closePath()
    }

    function drawMinMax(ctx)
    {
        var labelX = (dataWorker.minPriceTime - dataWorker.rightTime +
                       dataWorker.visibleTime)*coefficientTime

        var labelY = chartDrawHeight + chartCandleBegin

        drawLineAndLabel(ctx, labelX, labelY, dataWorker.minPrice)

        labelX = (dataWorker.maxPriceTime - dataWorker.rightTime +
                       dataWorker.visibleTime)*coefficientTime

        labelY = chartCandleBegin

        drawLineAndLabel(ctx, labelX, labelY, dataWorker.maxPrice)
    }

    function drawLineAndLabel(ctx, x, y, text)
    {
//        print("drawLineAndLabel", x, y, text)

        var toRight = true

        if (x > chartWidth*0.5)
            toRight = false

        ctx.lineWidth = 2
        ctx.strokeStyle = labelLineColor
        ctx.beginPath()
        ctx.moveTo(x, y)
        if (toRight)
            ctx.lineTo(x+labelLineLength, y)
        else
            ctx.lineTo(x-labelLineLength, y)
        ctx.stroke()

        ctx.beginPath()
        ctx.stroke()

        ctx.font = "normal "+fontSize+"px "+fontFamilies

        var width = ctx.measureText(text.toFixed(6)).width

        ctx.fillStyle = labelBackgroundColor
        if (toRight)
            ctx.fillRect(x+labelLineLength, y-10,
                     width+fontIndent*2, 18)
        else
            ctx.fillRect(x-labelLineLength-fontIndent*2-width, y-10,
                     width+fontIndent*2, 18)

        ctx.fillStyle = labelColor
        if (toRight)
            ctx.fillText(text.toFixed(6),
                     x+labelLineLength+fontIndent, y + fontSize*0.3)
        else
            ctx.fillText(text.toFixed(6),
                     x-labelLineLength-fontIndent-width, y + fontSize*0.3)

        ctx.stroke()
    }

    function drawHorizontalLine(ctx, y)
    {
        ctx.lineWidth = gridWidth
        ctx.strokeStyle = gridColor
        ctx.beginPath()
        ctx.moveTo(chartWidth, y)
        ctx.lineTo(0, y)
        ctx.stroke()
    }

    function drawVerticalLine(ctx, x)
    {
        ctx.lineWidth = gridWidth
        ctx.strokeStyle = gridColor
        ctx.beginPath()
        ctx.moveTo(x, chartFullHeight)
        ctx.lineTo(x, 0)
        ctx.stroke()
    }

    function drawHorizontalLineText(ctx, y, text, color, border = false)
    {
        ctx.font = "normal "+fontSize+"px "+fontFamilies

        if (border)
        {
            var width = ctx.measureText(text.toFixed(6)).width

            ctx.fillStyle = darkBackgroundColor
            ctx.fillRect(chartWidth, y-10,
                         width+6, 18)
        }

        ctx.fillStyle = color
        ctx.fillText(text.toFixed(6), chartWidth + fontIndent, y + fontSize*0.3)
        ctx.stroke()
    }

    function drawVerticalLineText(ctx, x, text, color, border = false)
    {
        ctx.font = "normal "+fontSize+"px "+fontFamilies

        if (border)
        {
            var width = ctx.measureText(text).width

            ctx.fillStyle = darkBackgroundColor
            ctx.fillRect(x-fontIndent, chartFullHeight,
                         width+fontIndent*2, measurementScaleHeight)
        }

        ctx.fillStyle = color
        ctx.fillText(text, x,
            chartFullHeight + fontIndent + fontSize)
        ctx.stroke()
    }

    function drawChartLine(ctx, x1, y1, x2, y2, color)
    {
//        print("drawChartLine", x1, y1, x2, y2)

        ctx.lineWidth = 1
        ctx.strokeStyle = color
        ctx.beginPath()
        ctx.moveTo(x1, y1)
        ctx.lineTo(x2, y2)
        ctx.stroke()
    }

    function drawCandle(ctx, x, y0, y1, y2, y3, w, color)
    {
        ctx.strokeStyle = color
        ctx.lineWidth = candleLineWidth
        ctx.beginPath()
            ctx.moveTo(x, y0)
            ctx.lineTo(x, y3)
        ctx.stroke()

        roundedRect(ctx, x-w*0.5, y1, w, y2-y1, w*0.2, color)
    }

    function roundedRect(ctx, rx, ry, rw, rh, radius, color)
    {
        var secondRadius = rh*0.5

        if (radius > secondRadius)
            radius = secondRadius

        if (radius < 1)
            radius = 1

        ctx.strokeStyle = color
        ctx.lineCap = "round"
        ctx.lineWidth = radius*2
        ctx.beginPath()
            ctx.moveTo(rx+radius, ry+radius)
            ctx.lineTo(rx+rw-radius, ry+radius)
        ctx.stroke()
        ctx.beginPath()
            ctx.moveTo(rx+radius, ry+rh-radius)
            ctx.lineTo(rx+rw-radius, ry+rh-radius)
        ctx.stroke()

        if(rh - radius*2 > 1)
        {
            ctx.strokeStyle = color
            ctx.lineCap = "butt"
            ctx.lineWidth = rw
            ctx.beginPath()
                ctx.moveTo(rx+rw*0.5, ry+radius)
                ctx.lineTo(rx+rw*0.5, ry+rh-radius)
            ctx.stroke()
        }
    }

}
