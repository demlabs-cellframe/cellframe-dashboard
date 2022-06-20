import QtQuick 2.12
import QtQml 2.12


QtObject
{
//    property alias dataModel: _dataModel
//    property alias candleModel: _candleModel

    property int fontSize: 11
    property string fontFamilies: "Quicksand"
//    property string fontFamilies: "Arial"
    property int fontIndent: 3

    property string gridColor: "#a0a0a0"
    property string gridTextColor: "#a0a0a0"
    property string backgroundColor: "#404040"

    property string redCandleColor: "#80ff0000"
    property string greenCandleColor: "#8000ff00"

    property real gridWidth: 0.2
    property real lineWidth: 2

    property real minX: 0
    property real maxX: 0

    property real minY: 0
    property real maxY: 0

    property real coefficientY: 0
    property real coefficientX: 0

    property int maxStepNumberX: 8
    property real roundedStepX: 0
    property real roundedMaxX: 0

    property int maxStepNumberY: 8
    property real roundedStepY: 0
    property real roundedMaxY: 0

    property real visibleTime: 1000000
    property real maxZoom: 3.0
    property real minZoom: 0.2
    property real visibleDefaultCandles: 40
    property real rightTime: 0
    property real beginTime: 0
    property real endTime: 0

    property real candleWidth: 50000

    property real measurementScaleWidth: 60
    property real chartTextHeight: 20
    property real measurementScaleHeight: 20
    property real chartWidth: width - measurementScaleWidth
    property real chartHeight: height -
        measurementScaleHeight - chartTextHeight

    readonly property int day: 86400000
    readonly property int hour: 3600000
    readonly property int minute: 60000
    readonly property int second: 1000

//    ListModel{ id: _dataModel }

//    ListModel{ id: _candleModel }

    function drawAll(ctx)
    {
        ctx.fillStyle = backgroundColor;
//        ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
        ctx.fillRect(0, 0, width, height);

        drawGrid(ctx)

//        drawChart(ctx, "blue")

//        drawCandle(ctx, 100, 50, 60, 80, 105, 20, "red")

        drawCandleChart(ctx)
    }

    function setCandleWidth(newWidth)
    {
        candleWidth = newWidth

        getCandleModel(candleWidth)

        visibleTime = candleWidth * visibleDefaultCandles

        dataAnalysis()
    }

    function generateData(length)
    {
        var currentData = 10000
        var currentTime = 1655420000000

        for (var i = 0; i < length; ++i)
        {
            currentData += Math.random()*10 - 5
            currentTime += 5000 + Math.round(Math.random()*3000)

//            print(currentData)

            dataModel.append({ "y" : currentData, "x" : currentTime })
        }
    }

    function getCandleModel()
    {
        var openValue = 0
        var closeValue = 0
        var minValue = 0
        var maxValue = 0
        var candleBegin = 0

        candleModel.clear()

        if (dataModel.count > 0)
        {
            candleBegin = dataModel.get(0).x

            openValue = dataModel.get(0).y
            closeValue = dataModel.get(0).y
            minValue = dataModel.get(0).y
            maxValue = dataModel.get(0).y
        }

        for (var i = 0; i < dataModel.count; ++i)
        {
            if (dataModel.get(i).x > candleBegin + candleWidth)
            {
                candleModel.append({
                    time: candleBegin + candleWidth*0.5,
                    minimum: minValue,
                    maximum: maxValue,
                    open: openValue,
                    close: closeValue })

//                print("time", candleBegin + candleWidth*0.5,
//                      "minimum", minValue,
//                      "maximum", maxValue,
//                      "open", openValue,
//                      "close", closeValue)

                candleBegin += candleWidth

                openValue = dataModel.get(i).y
                closeValue = dataModel.get(i).y
                minValue = dataModel.get(i).y
                maxValue = dataModel.get(i).y
            }
            else
            {
                closeValue = dataModel.get(i).y

                if (minValue > dataModel.get(i).y)
                    minValue = dataModel.get(i).y

                if (maxValue < dataModel.get(i).y)
                    maxValue = dataModel.get(i).y
            }
        }
    }

    function resetRightTime()
    {
        if (dataModel.count > 0)
            rightTime = dataModel.get(dataModel.count-1).x
    }

    function dataAnalysis()
    {
        var reset = true

        maxX = rightTime

        minX = rightTime - visibleTime

        if (dataModel.count > 0)
        {
            minY = maxY = dataModel.get(0).y
            beginTime = dataModel.get(0).x
            endTime = dataModel.get(dataModel.count-1).x
        }

//        minY -= 1000
//        maxY += 1000

        for (var i = 0; i < dataModel.count; ++i)
        {
            if (dataModel.get(i).x < rightTime - visibleTime)
                continue

            if (dataModel.get(i).x > rightTime)
                break

            if (reset)
            {
                minY = maxY = dataModel.get(i).y

                reset = false
            }
            else
            {
                if (minY > dataModel.get(i).y)
                    minY = dataModel.get(i).y
                if (maxY < dataModel.get(i).y)
                    maxY = dataModel.get(i).y
            }
        }

        if (minX === maxX)
        {
            minX -= 0.00000000001
            maxX += 0.00000000001
        }
        if (minY === maxY)
        {
            minY -= 0.00000000001
            maxY += 0.00000000001
        }

        if (maxY > minY)
            coefficientY = chartHeight/(maxY - minY)
        if (visibleTime > 0)
            coefficientX = chartWidth/visibleTime

        getRoundedStepY()

        getRoundedStepTime()

//        print("minX", minX, "minY", minY,
//              "maxX", maxX, "maxY", maxY)
    }

    function getRoundedStepY()
    {
        var realStep = (maxY - minY)/maxStepNumberY

//        print("minY", minY, "maxY", maxY)
//        print("maxY - minY", maxY - minY)
//        print("realStep", realStep)

        var digit = 0.0000000001

        while (digit*10 < realStep)
            digit *= 10

//        print("digit", digit)

        roundedStepY = digit

        if (digit*2 > realStep)
            roundedStepY = digit*2
        else
        if (digit*5 > realStep)
            roundedStepY = digit*5
        else
            roundedStepY = digit*10

//        print("roundedStepY", roundedStepY)

        roundedMaxY = maxY - maxY%roundedStepY

//        while (roundedMaxY > minY)
//        {
//            print(roundedMaxY)
//            roundedMaxY -= roundedStepY
//        }
    }

    property var timeSteps:
        ( new Uint32Array(
             [1*second,
              2*second,
              5*second,
              10*second,
              20*second,
              1*minute,
              2*minute,
              5*minute,
              10*minute,
              20*minute,
              1*hour,
              2*hour,
              4*hour,
              6*hour,
              12*hour,
              1*day,
              2*day,
              5*day,
              7*day,
              10*day,
              15*day,
              30*day,
              45*day,
              60*day,
              90*day]))

    property string timeMask: "yyyy-MM-dd hh:mm:ss"

    function getRoundedStepTime()
    {
        var realStep = (maxX - minX)/maxStepNumberX

        var date1 = new Date(minX)
        var date2 = new Date(maxX)

//        print("date1", date1.toLocaleString(
//                   Qt.locale("en_EN"), "yyyy-MM-dd hh:mm:ss"))
//        print("date2", date2.toLocaleString(
//                   Qt.locale("en_EN"), "yyyy-MM-dd hh:mm:ss"))

        var timeStepsIndex = 0
        roundedStepX = timeSteps[timeStepsIndex]

        while (timeSteps[timeStepsIndex] < realStep &&
               timeStepsIndex < timeSteps.length-1)
        {
            ++timeStepsIndex
            roundedStepX = timeSteps[timeStepsIndex]
        }

        if (timeStepsIndex < 5)
            timeMask = "hh:mm:ss"
        else
        if (timeStepsIndex < 10)
            timeMask = "hh:mm"
        else
        if (timeStepsIndex < 15)
            timeMask = "MM/dd hh:mm"
        else
            timeMask = "MM/dd"

//        print("step", realStep, "roundedStep", roundedStepX)

        roundedMaxX = maxX - maxX%roundedStepX

        if (timeStepsIndex > 10)
        {
            roundedMaxX -= hour*3

//            print("maxX%roundedStepX", maxX%roundedStepX,
//                  "roundedStepX", roundedStepX,
//                  "hour*3", hour*3)

            if (roundedStepX < hour*3 + maxX%roundedStepX)
                roundedMaxX += roundedStepX
        }

    }

    function zoomTime(step)
    {
        var oldVisibleTime = visibleTime

        if (step > 0)
        {
            visibleTime *= 1.2
        }
        else
        {
            visibleTime /= 1.2
        }

        if (visibleTime > candleWidth * visibleDefaultCandles * maxZoom ||
            visibleTime < candleWidth * visibleDefaultCandles * minZoom)
        {
            visibleTime = oldVisibleTime
        }
        else
        {
            rightTime += (visibleTime - oldVisibleTime)*0.5

            dataAnalysis()

            chartCanvas.requestPaint()
        }
    }

    function shiftTime(step)
    {
        if (step !== 0)
        {
            rightTime -= step / coefficientX

            if (rightTime > endTime + visibleTime*0.5)
                rightTime = endTime + visibleTime*0.5

            if (rightTime < beginTime + visibleTime*0.5)
                rightTime = beginTime + visibleTime*0.5

            dataAnalysis()

            chartCanvas.requestPaint()
        }
    }

    function drawGrid(ctx)
    {
        var currentX = roundedMaxX
        while (currentX > minX)
        {
            drawVerticalLine(ctx,
                (currentX - minX)*coefficientX)

            var date = new Date(currentX)

            drawVerticalLineText(ctx,
                (currentX - minX)*coefficientX,
                date.toLocaleString(Qt.locale("en_EN"), timeMask))

//            print(currentX)
            currentX -= roundedStepX
        }

        var currentY = roundedMaxY
        while (currentY > minY)
        {
            drawHorizontalLine(ctx,
                (maxY - currentY)*coefficientY + chartTextHeight)

            drawHorizontalLineText(ctx,
                (maxY - currentY)*coefficientY + chartTextHeight,
                currentY)

//            print(currentY)
            currentY -= roundedStepY
        }

    }

    function drawChart(ctx, color)
    {
        for (var i = 1; i < dataModel.count; ++i)
        {
            if (dataModel.get(i-1).x < rightTime - visibleTime)
                continue

            if (dataModel.get(i).x > rightTime)
                break

            drawChartLine(ctx,
                (dataModel.get(i-1).x - rightTime + visibleTime)*coefficientX,
                (maxY - dataModel.get(i-1).y)*coefficientY + chartTextHeight,
                (dataModel.get(i).x - rightTime + visibleTime)*coefficientX,
                (maxY - dataModel.get(i).y)*coefficientY + chartTextHeight,
                color)
        }
    }

    function drawCandleChart(ctx)
    {
        for (var i = 1; i < candleModel.count; ++i)
        {
            if (candleModel.get(i).time - candleWidth*0.5 < rightTime - visibleTime)
                continue

            if (candleModel.get(i).time - candleWidth*0.5 > rightTime)
                break

            var color = redCandleColor
            var up = candleModel.get(i-1).open
            var down = candleModel.get(i-1).close

            if (candleModel.get(i-1).open < candleModel.get(i-1).close)
            {
                color = greenCandleColor
                up = candleModel.get(i-1).close
                down = candleModel.get(i-1).open
            }

            if ((up - down)*coefficientY < 1.0)
            {
                var step = 1.0 - (up - down)*coefficientY
                up += step*0.5*coefficientY
                down -= step*0.5*coefficientY
            }

            drawCandle(ctx,
                (candleModel.get(i-1).time - rightTime + visibleTime)*coefficientX,
                (maxY - candleModel.get(i-1).maximum)*coefficientY + chartTextHeight,
                (maxY - up)*coefficientY + chartTextHeight,
                (maxY - down)*coefficientY + chartTextHeight,
                (maxY - candleModel.get(i-1).minimum)*coefficientY + chartTextHeight,
                candleWidth*0.95*coefficientX, color)
        }
    }

    function drawChartLine(ctx, x1, y1, x2, y2, color)
    {
        ctx.lineWidth = 1;
        ctx.strokeStyle = color
        ctx.beginPath()
        ctx.moveTo(x1, y1)
        ctx.lineTo(x2, y2)
        ctx.stroke()
    }

    function drawHorizontalLine(ctx, y)
    {
        ctx.lineWidth = gridWidth;
        ctx.strokeStyle = gridColor;
        ctx.beginPath();
        ctx.moveTo(chartWidth, y);
        ctx.lineTo(0, y);
        ctx.stroke();
    }

    function drawVerticalLine(ctx, x)
    {
        ctx.lineWidth = gridWidth;
        ctx.strokeStyle = gridColor;
        ctx.beginPath();
        ctx.moveTo(x, chartHeight + chartTextHeight);
        ctx.lineTo(x, 0);
        ctx.stroke();
    }

    function drawHorizontalLineText(ctx, y, text)
    {
        ctx.font = "normal "+fontSize+"px "+fontFamilies;
        ctx.fillStyle = gridTextColor;
        ctx.fillText(text, chartWidth + fontIndent, y + fontSize*0.3);
        ctx.stroke();
    }

    function drawVerticalLineText(ctx, x, text)
    {
        ctx.font = "normal "+fontSize+"px "+fontFamilies;
        ctx.fillStyle = gridTextColor;
        ctx.fillText(text, x,
            chartHeight + chartTextHeight + fontIndent + fontSize);
        ctx.stroke();
    }

    function drawCandle(ctx, x, y0, y1, y2, y3, w, color)
    {
        ctx.strokeStyle = color
        ctx.lineWidth = lineWidth;
        ctx.beginPath()
            ctx.moveTo(x, y0)
            ctx.lineTo(x, y1)
        ctx.stroke()
        ctx.lineWidth = w;
        ctx.beginPath()
            ctx.moveTo(x, y1)
            ctx.lineTo(x, y2)
        ctx.stroke()
        ctx.lineWidth = lineWidth;
        ctx.beginPath()
            ctx.moveTo(x, y2)
            ctx.lineTo(x, y3)
        ctx.stroke()
    }

}
