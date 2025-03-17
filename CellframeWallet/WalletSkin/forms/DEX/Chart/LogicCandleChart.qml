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

    property real maxDrawPrice: 0
    property real minDrawPrice: 0

    property int maxStepNumberTime: 5
    property real roundedStepTime: 0
    property real roundedMaxTime: 0

    property int maxStepNumberPrice: 8
    property real roundedStepPrice: 0
    property real roundedMaxPrice: 0
    property int gridPricePower: 8

    readonly property real roundedCoefficient: 1

    property real lastCandleOpen: 0
    property real lastCandleClose: 0

    property real measurementScaleWidth: 65
    property real chartTextHeight: 35
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
            selectedCandleNumber = candleChartWorker.lastCandleNumber

        ctx.fillStyle = backgroundColor
//        ctx.fillStyle = Qt.rgba(1, 1, 1, 1)
        ctx.fillRect(0, 0, width, height)

        drawGrid(ctx)

        drawAverageChart(ctx, 0, "#00ffff")
        drawAverageChart(ctx, 1, "#2090cf")
        drawAverageChart(ctx, 2, "#4040af")

//        drawPriceChart(ctx, "yellow")

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
        candleChartWorker.dataAnalysis()

        maxDrawPrice = candleChartWorker.maxPrice
        minDrawPrice = candleChartWorker.minPrice

        if (minDrawPrice > maxDrawPrice*0.99999999999)
        {
            minDrawPrice *= 0.9999
            maxDrawPrice *= 1.0001
        }

        coefficientPrice = chartDrawHeight/
                (maxDrawPrice - minDrawPrice)

        if (candleChartWorker.visibleTime > 0)
            coefficientTime = chartWidth/candleChartWorker.visibleTime

        getRoundedStepPrice()

        getRoundedStepTime()

    }

    function getRoundedStepPrice()
    {
//        print("getRoundedStepPrice")

        var realStep = (maxDrawPrice - minDrawPrice)/
                maxStepNumberPrice

//        print("minY", minY, "maxY", maxY)
//        print("maxY - minY", maxY - minY)
//        print("realStep", realStep)

        var digit = 0.00000000000000000001

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

        roundedMaxPrice = maxDrawPrice -
                maxDrawPrice%roundedStepPrice

        var test = 0.00000000000000000001
        var pow = 20

        while (test < digit)
        {
            test *= 10
            --pow
        }

        gridPricePower = pow+1

        if (gridPricePower < 0)
            gridPricePower = 0

//        print("roundedStepPrice", roundedStepPrice,
//              "roundedMaxPrice", roundedMaxPrice)
//        print("test", test,
//              "pow", pow)

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
        var realStep = (candleChartWorker.maxTime - candleChartWorker.minTime)/
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

        roundedMaxTime = candleChartWorker.maxTime -
                candleChartWorker.maxTime%roundedStepTime

        if (timeStepsIndex > 10)
        {
            roundedMaxTime -= hour*3

//            print("maxX%roundedStepX", maxX%roundedStepX,
//                  "roundedStepX", roundedStepX,
//                  "hour*3", hour*3)

            while (roundedMaxTime < candleChartWorker.maxTime -
                   candleChartWorker.maxTime%roundedStepTime)
                roundedMaxTime += roundedStepTime

//            while (roundedStepTime < hour*3 + candleChartWorker.maxTime%roundedStepTime)
//                roundedMaxTime += roundedStepTime
        }

    }

    function zoomTime(step)
    {
        if (candleChartWorker.zoomTime(step))
        {
            dataAnalysis()

            chartCanvas.requestPaint()
        }
    }

    function shiftTime(step)
    {
        if (step !== 0)
        {
            candleChartWorker.shiftTime(step / coefficientTime)

            dataAnalysis()

            chartCanvas.requestPaint()
        }
    }

    function drawGrid(ctx)
    {
        var currentX = roundedMaxTime
        while (currentX > candleChartWorker.minTime)
        {
            drawVerticalLine(ctx,
                (currentX - candleChartWorker.minTime)*coefficientTime)

//            print(currentX)
            currentX -= roundedStepTime
        }

        var currentY = roundedMaxPrice
        while (currentY > minDrawPrice)
        {
            drawHorizontalLine(ctx,
                (maxDrawPrice - currentY)*coefficientPrice +
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

        while (currentX > candleChartWorker.minTime)
        {
            date = new Date(currentX)

            drawVerticalLineText(ctx,
                (currentX - candleChartWorker.minTime)*coefficientTime,
                date.toLocaleString(Qt.locale("en_EN"), timeMask),
                gridTextColor)

//            print(currentX)
            currentX -= roundedStepTime
        }

        var outText = ""

        if (mouseVisible && mouseX <= chartWidth)
        {
            date = new Date((candleChartWorker.minTime + mouseX/coefficientTime))

            outText = date.toLocaleString(Qt.locale("en_EN"), "MM/dd hh:mm")

//            print("X", outText)

            drawVerticalLineText(ctx,
                mouseX,
                outText,
                "white", true)
        }

        var currentY = roundedMaxPrice
        while (currentY > minDrawPrice)
        {
            outText = currentY
            drawHorizontalLineText(ctx,
                (maxDrawPrice - currentY)*coefficientPrice +
                                   chartCandleBegin,
                outText, gridTextColor, gridPricePower)

//            print(currentY)
            currentY -= roundedStepPrice
        }

        outText = lastCandleClose

        var priceColor = greenCandleColor
        if (lastCandleClose < lastCandleOpen)
            priceColor = redCandleColor

        var priceY = (maxDrawPrice - lastCandleClose)*coefficientPrice +
                chartCandleBegin

        if (priceY > 0 && priceY <= chartFullHeight)
            drawHorizontalLineText(ctx,
                priceY, outText, priceColor, roundPower, true)

        if (mouseVisible && mouseY <= chartFullHeight)
        {
            outText = (maxDrawPrice - (mouseY-chartCandleBegin)/coefficientPrice)

            drawHorizontalLineText(ctx,
                mouseY, outText, "white", roundPower, true)
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

    function drawPriceChart(ctx, color)
    {
        for (var i = 0;
             i < candleChartWorker.priceModelSize-1; ++i)
        {
            var info1 = candleChartWorker.getPriceInfo(i)
            var info2 = candleChartWorker.getPriceInfo(i+1)

//            print("info1", i, info1.time, info1.price,
//                  "info2", i+1, info2.time, info2.price)

            drawChartLine(ctx,
                (info1.time - candleChartWorker.rightTime +
                    candleChartWorker.visibleTime)*coefficientTime,
                (maxDrawPrice - info1.price)*coefficientPrice +
                    chartCandleBegin,
                (info2.time - candleChartWorker.rightTime +
                    candleChartWorker.visibleTime)*coefficientTime,
                (maxDrawPrice - info2.price)*coefficientPrice +
                    chartCandleBegin,
                color)
        }
    }

    function drawAverageChart(ctx, chart, color)
    {
//        print("firstVisibleAverage", candleChartWorker.firstVisibleAverage,
//              "lastVisibleAverage", candleChartWorker.lastVisibleAverage)

        for (var i = candleChartWorker.getFirstVisibleAverage(chart);
             i < candleChartWorker.getLastVisibleAverage(chart); ++i)
        {
            var info1 = candleChartWorker.getAveragedInfo(chart, i)
            var info2 = candleChartWorker.getAveragedInfo(chart, i+1)

//            print("info1", i, info1.time, info1.price,
//                  "info2", i+1, info2.time, info2.price)

            drawChartLine(ctx,
                (info1.time - candleChartWorker.rightTime +
                    candleChartWorker.visibleTime)*coefficientTime,
                (maxDrawPrice - info1.price)*coefficientPrice +
                    chartCandleBegin,
                (info2.time - candleChartWorker.rightTime +
                    candleChartWorker.visibleTime)*coefficientTime,
                (maxDrawPrice - info2.price)*coefficientPrice +
                    chartCandleBegin,
                color)
        }
    }

    function drawCandleChart(ctx)
    {
        var realCandleWidth = candleChartWorker.candleWidth*0.98*coefficientTime - 1
        var mouseCandleWidth = candleChartWorker.candleWidth*coefficientTime

        var selectedChange = false

        if (mouseX > chartWidth)
            selectedCandleNumber = candleChartWorker.lastCandleNumber

        for (var i = candleChartWorker.firstVisibleCandle;
             i <= candleChartWorker.lastVisibleCandle; ++i)
        {
            var candle = candleChartWorker.getCandleInfo(i)

            if (candle.open === undefined)
                continue

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

            var candleX = (candle.time - candleChartWorker.rightTime +
                           candleChartWorker.visibleTime)*coefficientTime

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
                (maxDrawPrice - candle.maximum)*coefficientPrice +
                       chartCandleBegin,
                (maxDrawPrice - up)*coefficientPrice + chartCandleBegin,
                (maxDrawPrice - down)*coefficientPrice + chartCandleBegin,
                (maxDrawPrice - candle.minimum)*coefficientPrice +
                       chartCandleBegin,
                realCandleWidth, color)

            lastCandleOpen = candle.open
            lastCandleClose = candle.close
        }

        if (selectedChange ||
            selectedCandleNumber === candleChartWorker.lastCandleNumber)
        {
//            print("selectedChange", selectedChange,
//                  selectedCandleNumber, candleChartWorker.lastCandleNumber)

            var selCandle = candleChartWorker.getCandleInfo(selectedCandleNumber)

            if (candle.open !== undefined)
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
        var labelX = (candleChartWorker.minPriceTime - candleChartWorker.rightTime +
                       candleChartWorker.visibleTime)*coefficientTime

        var labelY = chartDrawHeight + chartCandleBegin

        if (candleChartWorker.minPrice > minDrawPrice)
            labelY = chartDrawHeight*0.5 + chartCandleBegin

        drawLineAndLabel(ctx, labelX, labelY, candleChartWorker.minPrice)

        labelX = (candleChartWorker.maxPriceTime - candleChartWorker.rightTime +
                       candleChartWorker.visibleTime)*coefficientTime

        labelY = chartCandleBegin

        if (candleChartWorker.maxPrice < maxDrawPrice)
            labelY = chartDrawHeight*0.5 + chartCandleBegin

        drawLineAndLabel(ctx, labelX, labelY, candleChartWorker.maxPrice)
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

        var width = ctx.measureText(text.toFixed(roundPower)).width

        ctx.fillStyle = labelBackgroundColor
        if (toRight)
            ctx.fillRect(x+labelLineLength, y-10,
                     width+fontIndent*2, 18)
        else
            ctx.fillRect(x-labelLineLength-fontIndent*2-width, y-10,
                     width+fontIndent*2, 18)

        ctx.fillStyle = labelColor
        if (toRight)
            ctx.fillText(text.toFixed(roundPower),
                     x+labelLineLength+fontIndent, y + fontSize*0.3)
        else
            ctx.fillText(text.toFixed(roundPower),
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

    function drawHorizontalLineText(ctx, y, text, color, power, border = false)
    {
        ctx.font = "normal "+fontSize+"px "+fontFamilies

        if (border)
        {
            var width = ctx.measureText(text.toFixed(power)).width

            ctx.fillStyle = darkBackgroundColor
            ctx.fillRect(chartWidth, y-10,
                         width+6, 18)
        }

        ctx.fillStyle = color
        ctx.fillText(text.toFixed(power), chartWidth + fontIndent, y + fontSize*0.3)
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

        if (radius < 0.5)
            radius = 0.5

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
