import QtQuick 2.12
import QtQml 2.12


QtObject
{
//    property alias dataModel: _dataModel
//    property alias candleModel: _candleModel

    property int fontSize: 11
//    property string fontFamilies: "Quicksand"
    property string fontFamilies: "Arial"
    property int fontIndent: 3

    property string gridColor: "#a0a0a0"
    property string gridTextColor: "#a0a0a0"
    property string backgroundColor: "#404040"
    property string darkBackgroundColor: "#303030"

    property string redCandleColor: "#80ff0000"
    property string greenCandleColor: "#8000ff00"

    property string sightColor: "#60ffffff"

    property real gridWidth: 0.2
    property real candleLineWidth: 2

    property real mouseX: -10
    property real mouseY: -10
    property bool mouseVisible: false

    property real minX: 0
    property real maxX: 0

    property real minY: 0
    property real maxY: 0

    property real min24h: 0
    property real max24h: 0

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

    property int lastCandleNumber: 0
    property real lastCandleOpen: 0
    property real lastCandleClose: 0

    property real candleWidth: 50000

    property real measurementScaleWidth: 60
    property real chartTextHeight: 20
    property real measurementScaleHeight: 20
    property real chartWidth: width - measurementScaleWidth
    property real chartHeight: height -
        measurementScaleHeight - chartTextHeight

    property int selectedCandleNumber: -1

    property int rightCandleNumber: 0

    readonly property int day: 86400000
    readonly property int hour: 3600000
    readonly property int minute: 60000
    readonly property int second: 1000

    signal chandleSelected( var timeValue,
        var openValue, var highValue, var lowValue, var closeValue)

    signal min24max24Changed( var min24h, var max24h)

//    ListModel{ id: _dataModel }

//    ListModel{ id: _candleModel }

    function drawAll(ctx)
    {
        if (!mouseVisible)
        {
            selectedCandleNumber = lastCandleNumber
        }

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

        resetRightTime()

        dataAnalysis()
    }

    function generateData(length)
    {
        var currentData = 0.245978
        var currentTime = (new Date()).getTime()

        min24h = currentData
        max24h = currentData

        print("currentTime", currentTime)

        for (var i = 0; i < length; ++i)
        {
            currentData += Math.random()*0.0001 - 0.00005
            currentTime -= 5000 + Math.round(Math.random()*3000)

//            print(currentData)
            if (min24h > currentData)
                min24h = currentData
            if (max24h < currentData)
                max24h = currentData

            dataModel.insert(0, { "y" : currentData * roundedCoefficient,
                                 "x" : currentTime })
        }

        min24max24Changed(min24h, max24h)
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
            closeValue = openValue
            minValue = openValue
            maxValue = openValue
        }

        for (var i = 0; i < dataModel.count; ++i)
        {
            var currY = dataModel.get(i).y

            closeValue = currY

            if (minValue > currY)
                minValue = currY

            if (maxValue < currY)
                maxValue = currY

            if (dataModel.get(i).x > candleBegin + candleWidth
                || i === dataModel.count-1)
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

                openValue = currY
                closeValue = currY
                minValue = currY
                maxValue = currY
            }
        }

        if (lastCandleNumber !== candleModel.count-1)
        {
            print("NEW CANDLE", candleModel.count-1)

            var lastTime = candleModel.get(candleModel.count-1).time
            if (rightCandleNumber == lastCandleNumber &&
                (rightTime < lastTime + candleWidth || rightTime > lastTime - candleWidth))
                resetRightTime()

            lastCandleNumber = candleModel.count-1
        }
    }

    function resetRightTime()
    {
//        if (dataModel.count > 0)
//            rightTime = dataModel.get(dataModel.count-1).x
        if (candleModel.count > 0)
            rightTime = candleModel.get(candleModel.count-1).time + candleWidth*0.5
    }

    function generateNewPrice()
    {
        logicStock.tokenPrevPrice = logicStock.tokenPrice
        logicStock.tokenPrice += Math.random()*0.00004 - 0.00002
        var y = logicStock.tokenPrice*roundedCoefficient
        var currentTime = (new Date()).getTime()

        dataModel.append({ "y" : y, "x" : currentTime })
    }


    function updateCurrentTokenPrice()
    {
        if (dataModel.count > 1)
        {
            logicStock.tokenPrevPrice = dataModel.get(dataModel.count-2).y/roundedCoefficient
            logicStock.tokenPrice = dataModel.get(dataModel.count-1).y/roundedCoefficient
        }
    }

/*    function dataAnalysis()
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

        for (var i = 0; i < dataModel.count; ++i)
        {
            var currX = dataModel.get(i).x
            var currY = dataModel.get(i).y

            if (currX < rightTime - visibleTime)
                continue

            if (currX > rightTime)
                break

            if (reset)
            {
                minY = maxY = currY

                reset = false
            }
            else
            {
                if (minY > currY)
                    minY = currY
                if (maxY < currY)
                    maxY = currY
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
    }*/

    function dataAnalysis()
    {
        var reset = true

        maxX = rightTime

        minX = rightTime - visibleTime

        if (candleModel.count > 0)
        {
            minY = candleModel.get(0).minimum
            maxY = candleModel.get(0).maximum
            beginTime = candleModel.get(0).time - candleWidth*0.5
            endTime = candleModel.get(
                candleModel.count-1).time + candleWidth*0.5
        }

        rightCandleNumber = 0

        for (var i = 0; i < candleModel.count; ++i)
        {
            var currX = candleModel.get(i).time
            var minimum = candleModel.get(i).minimum
            var maximum = candleModel.get(i).maximum

            if (currX + candleWidth*0.5 < rightTime - visibleTime)
                continue

            if (currX - candleWidth*0.5 > rightTime)
                break

            rightCandleNumber = i

            if (reset)
            {
                minY = minimum
                maxY = maximum

                reset = false
            }
            else
            {
                if (minY > minimum)
                    minY = minimum
                if (maxY < maximum)
                    maxY = maximum
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

    property int timeStepsIndex: 0

    function getRoundedStepTime()
    {
        var realStep = (maxX - minX)/maxStepNumberX

        timeStepsIndex = 0
        roundedStepX = timeSteps[timeStepsIndex]

        while (timeSteps[timeStepsIndex] < realStep &&
               timeStepsIndex < timeSteps.length-1)
        {
            ++timeStepsIndex
            roundedStepX = timeSteps[timeStepsIndex]
        }

//        print("timeStepsIndex", timeStepsIndex)

        if (timeStepsIndex < 5)
            timeMask = "hh:mm:ss"
        else
        if (timeStepsIndex < 12)
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

        var date
        var currentX = roundedMaxX

        while (currentX > minX)
        {
            date = new Date(currentX)

            drawVerticalLineText(ctx,
                (currentX - minX)*coefficientX,
                date.toLocaleString(Qt.locale("en_EN"), timeMask),
                gridTextColor)

//            print(currentX)
            currentX -= roundedStepX
        }

        var outText = ""

        if (mouseVisible && mouseX <= chartWidth)
        {
            date = new Date((minX + mouseX/coefficientX))

            outText = date.toLocaleString(Qt.locale("en_EN"), "MM/dd hh:mm")

//            print("X", outText)

            drawVerticalLineText(ctx,
                mouseX,
                outText,
                "white", true)
        }

        var currentY = roundedMaxY
        while (currentY > minY)
        {
            outText = currentY/roundedCoefficient
            drawHorizontalLineText(ctx,
                (maxY - currentY)*coefficientY + chartTextHeight,
                outText, gridTextColor)

//            print(currentY)
            currentY -= roundedStepY
        }

        outText = lastCandleClose/roundedCoefficient

        var priceColor = greenCandleColor
        if (lastCandleClose < lastCandleOpen)
            priceColor = redCandleColor

        var priceY = (maxY - lastCandleClose)*coefficientY + chartTextHeight

        if (priceY > 0 && priceY <= chartHeight + chartTextHeight)
            drawHorizontalLineText(ctx,
                priceY,
                outText.toFixed(roundPower),
                priceColor, true)

        if (mouseVisible && mouseY <= chartHeight + chartTextHeight)
        {
            outText = (maxY - (mouseY-chartTextHeight)/coefficientY)
                    /roundedCoefficient

            drawHorizontalLineText(ctx,
                mouseY,
                outText.toFixed(roundPower),
                "white", true)
        }
    }

    function drawSight(ctx)
    {
        ctx.strokeStyle = sightColor
        ctx.setLineDash([4, 2])
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
        ctx.setLineDash([])
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

        var selectedChange = false

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
                (maxY - candleModel.get(i).maximum)*coefficientY + chartTextHeight,
                (maxY - up)*coefficientY + chartTextHeight,
                (maxY - down)*coefficientY + chartTextHeight,
                (maxY - candleModel.get(i).minimum)*coefficientY + chartTextHeight,
                realCandleWidth, color)

            lastCandleOpen = candleModel.get(i).open
            lastCandleClose = candleModel.get(i).close
        }

        if (selectedChange || selectedCandleNumber === lastCandleNumber)
        {
            print("selectedChange", selectedChange,
                  selectedCandleNumber, lastCandleNumber)

            if (selectedCandleNumber >= 0 &&
                selectedCandleNumber < candleModel.count)
                chandleSelected(
                    candleModel.get(selectedCandleNumber).time,
                    candleModel.get(selectedCandleNumber).open/roundedCoefficient,
                    candleModel.get(selectedCandleNumber).maximum/roundedCoefficient,
                    candleModel.get(selectedCandleNumber).minimum/roundedCoefficient,
                    candleModel.get(selectedCandleNumber).close/roundedCoefficient)
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

    function drawHorizontalLineText(ctx, y, text, color, border = false)
    {
        if (border)
        {
            ctx.fillStyle = darkBackgroundColor;
            ctx.fillRect(chartWidth, y-10,
                         measurementScaleWidth, 18);
        }

        ctx.font = "normal "+fontSize+"px "+fontFamilies;
        ctx.fillStyle = color;
        ctx.fillText(text, chartWidth + fontIndent, y + fontSize*0.3);
        ctx.stroke();
    }

    function drawVerticalLineText(ctx, x, text, color, border = false)
    {
        if (border)
        {
            ctx.fillStyle = darkBackgroundColor;
            ctx.fillRect(x-3, chartHeight + chartTextHeight,
                         62, measurementScaleHeight);
        }

        ctx.font = "normal "+fontSize+"px "+fontFamilies;
        ctx.fillStyle = color;
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
