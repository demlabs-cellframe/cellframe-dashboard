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

    property string gridColor: currTheme.borderColor
    property string gridTextColor: currTheme.textColorGray
    property string backgroundColor: currTheme.backgroundElements

    property string redCandleColor: currTheme.textColorRed
    property string greenCandleColor: currTheme.textColorGreen

    property string sightColor: "#80ffff00"

    property real gridWidth: 0.2
    property real candleLineWidth: 2

    property real mouseX: -10
    property real mouseY: -10
    property bool mouseVisible: false

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

    readonly property real roundedCoefficient: 10000000000000

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

    property int selectedCandle: -1

    readonly property int day: 86400000
    readonly property int hour: 3600000
    readonly property int minute: 60000
    readonly property int second: 1000

    signal chandleSelected( var timeValue,
        var openValue, var highValue, var lowValue, var closeValue)

//    ListModel{ id: _dataModel }

//    ListModel{ id: _candleModel }

    function drawAll(ctx)
    {
        ctx.fillStyle = backgroundColor;
//        ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
        ctx.fillRect(0, 0, width, height);

        drawGrid(ctx)

//        drawChart(ctx, "blue")

        drawCandleChart(ctx)

        drawGridText(ctx)

        if (mouseVisible)
            drawSight(ctx)

//        drawCandle(ctx, 200, 50, 60, 180, 205, 50, "red")
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
        var currentData = 0.245978
        var currentTime = (new Date()).getTime()

        print("currentTime", currentTime)

        for (var i = 0; i < length; ++i)
        {
            currentData += Math.random()*0.001 - 0.0005
            currentTime -= 5000 + Math.round(Math.random()*3000)

//            print(currentData)

            dataModel.insert(0, { "y" : currentData * roundedCoefficient,
                                 "x" : currentTime })
        }

/*        logicCandleChart.generateDataModel(1000)

        print("logicCandleChart.DataModel.count",
              logicCandleChart.DataModel.length)

        for (var j = 0; j < logicCandleChart.DataModel.length; ++j)
//        for (var j = 0; j < 1000; ++j)
        {
//            print("wordsModel",
//                  logicCandleChart.DataModel[j]["x"],
//                  logicCandleChart.DataModel[j]["y"])
//            print("wordsModel", j)
        }

        print("logicCandleChart.DataModel end")*/
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

    /*function getRoundedStepY()
    {
        var realStep = (maxY - minY)/maxStepNumberY

//        print("minY", minY, "maxY", maxY)
//        print("maxY - minY", maxY - minY)
//        print("realStep", realStep)

        var digit = 0.00000000001

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
    }*/

    function getRoundedStepY()
    {
        var realStep = (maxY - minY)/maxStepNumberY

//        print("minY", minY, "maxY", maxY)
//        print("maxY - minY", maxY - minY)
//        print("realStep", realStep)

        var digit = 1

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


        roundedMaxY = maxY - maxY%roundedStepY

//        print("roundedStepY", roundedStepY, "roundedMaxY", roundedMaxY)

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

//            print(currentX)
            currentX -= roundedStepX
        }

        var currentY = roundedMaxY
        while (currentY > minY)
        {
            drawHorizontalLine(ctx,
                (maxY - currentY)*coefficientY + chartTextHeight)

//            print(currentY)
            currentY -= roundedStepY
        }

    }

    function drawGridText(ctx)
    {
        ctx.fillStyle = backgroundColor;
        ctx.fillRect(width-measurementScaleWidth, 0,
                     measurementScaleWidth, height);
        ctx.fillRect(0, height-measurementScaleHeight,
                     width, height);

        var currentX = roundedMaxX
        while (currentX > minX)
        {
            var date = new Date(currentX)

            drawVerticalLineText(ctx,
                (currentX - minX)*coefficientX,
                date.toLocaleString(Qt.locale("en_EN"), timeMask))

//            print(currentX)
            currentX -= roundedStepX
        }

//        print("roundedStepY", roundedStepY)

        var currentY = roundedMaxY
        while (currentY > minY)
        {
            var outText = currentY/roundedCoefficient
            drawHorizontalLineText(ctx,
                (maxY - currentY)*coefficientY + chartTextHeight,
                outText)

//            print(currentY)
            currentY -= roundedStepY
        }

    }

    function drawSight(ctx)
    {
        ctx.strokeStyle = sightColor
        ctx.lineWidth = 2;

        if(mouseY <= chartHeight + chartTextHeight)
        {
            ctx.beginPath();
            ctx.moveTo(chartWidth, mouseY);
            ctx.lineTo(0, mouseY);
            ctx.stroke();
        }

        if(mouseX <= chartWidth)
        {
            ctx.beginPath();
            ctx.moveTo(mouseX, chartHeight + chartTextHeight);
            ctx.lineTo(mouseX, 0);
            ctx.stroke();
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
        var realCandleWidth = candleWidth*0.98*coefficientX - 1
        var mouseCandleWidth = candleWidth*coefficientX

        for (var i = 0; i < candleModel.count; ++i)
        {
            if (candleModel.get(i).time + candleWidth*0.5 < rightTime - visibleTime)
                continue

            if (candleModel.get(i).time - candleWidth*0.5 > rightTime)
                break

            var redCandle = true

            if (candleModel.get(i).open < candleModel.get(i).close)
                redCandle = false

            var color = redCandleColor
            var up = candleModel.get(i).open
            var down = candleModel.get(i).close

            if (!redCandle)
            {
                color = greenCandleColor
                up = candleModel.get(i).close
                down = candleModel.get(i).open
            }

            var candleX = (candleModel.get(i).time - rightTime + visibleTime)*coefficientX

            if (candleX > mouseX - mouseCandleWidth*0.5 &&
                candleX < mouseX + mouseCandleWidth*0.5)
            {
                if (!redCandle)
                    color = "#B1FF00"
                else
                    color = "#FF3232"
//                    color = "#FF9797"

                if (selectedCandle !== i)
                {
                    selectedCandle = i
                    print("selectedCandle", selectedCandle)

                    chandleSelected(
                        candleModel.get(i).time,
                        candleModel.get(i).open/roundedCoefficient,
                        candleModel.get(i).maximum/roundedCoefficient,
                        candleModel.get(i).minimum/roundedCoefficient,
                        candleModel.get(i).close/roundedCoefficient)
                }

            }

            drawCandle(ctx,
                candleX,
                (maxY - candleModel.get(i).maximum)*coefficientY + chartTextHeight,
                (maxY - up)*coefficientY + chartTextHeight,
                (maxY - down)*coefficientY + chartTextHeight,
                (maxY - candleModel.get(i).minimum)*coefficientY + chartTextHeight,
                realCandleWidth, color)
        }

        ctx.restore()
        ctx.beginPath()
        ctx.closePath()
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
        ctx.lineWidth = candleLineWidth;
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
        ctx.lineWidth = radius*2;
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
            ctx.lineWidth = rw;
            ctx.beginPath()
                ctx.moveTo(rx+rw*0.5, ry+radius)
                ctx.lineTo(rx+rw*0.5, ry+rh-radius)
            ctx.stroke()
        }
    }

}
