import QtQuick 2.12
import QtQml 2.12


QtObject
{
//    property alias dataModel: _dataModel
//    property alias candleModel: _candleModel

    property int fontSize: 12
//    property string fontFamilies: "Quicksand"
    property string fontFamilies: "Quicksand"
    property int fontIndent: 3

    property string gridColor: "#a0a0a0"
    property string gridTextColor: "#a0a0a0"
    property string backgroundColor: "#404040"

    property real gridWidth: 0.2
    property real lineWidth: 1

    property real minX: 0
    property real maxX: 0

    property real minY: 0
    property real maxY: 0

    property real coefficientY: 0
    property real coefficientX: 0

    property int maxStepNumberX: 10
    property real roundedStepX: 0
    property real roundedMaxX: 0

    property int maxStepNumberY: 10
    property real roundedStepY: 0
    property real roundedMaxY: 0

    //Variables for setting time.
//    //Year.
//    property int year: 31556926;
//    //Month.
//    property int month: 2629743;
    //Week.
    property int week: 604800;
    //Day.
    property int day: 86400;
    //Hour.
    property int hour: 3600;
    //Minute.
    property int minute: 60;

    property real visibleTime: 1000
    property real rightTime: 0

    property real measurementScaleWidth: 80
    property real measurementScaleHeight: 20
    property real chartWidth: width - measurementScaleWidth
    property real chartHeight: height - measurementScaleHeight

//    ListModel{ id: _dataModel }

//    ListModel{ id: _candleModel }

    function generateData(length)
    {
        var currentData = 10000

        for (var i = 0; i < length; ++i)
        {
            currentData += Math.random()*10 - 5

//            print(currentData)

            dataModel.append({ "y" : currentData, "x" : i })
        }
    }

    function getCandleModel(step)
    {
        var openValue = 0
        var closeValue = 0
        var minValue = 0
        var maxValue = 0

        for (var i = 0; i < dataModel.count; ++i)
        {
            if (i % step === 0)
            {
                openValue = dataModel.get(i).data
                closeValue = dataModel.get(i).data
                minValue = dataModel.get(i).data
                maxValue = dataModel.get(i).data
            }
            else
            {
                if (i % step === step-1)
                    closeValue = dataModel.get(i).data

                if (minValue > dataModel.get(i).data)
                    minValue = dataModel.get(i).data

                if (maxValue < dataModel.get(i).data)
                    maxValue = dataModel.get(i).data
            }

            if (i % step === step-1)
            {
                candleModel.append({
                    "time": i*10 + 1546543400,
                    "minimum": minValue,
                    "maximum": maxValue,
                    "open": openValue,
                    "close": closeValue })
//                print("minimum", minValue,
//                      "maximum", maxValue,
//                      "open", openValue,
//                      "close", closeValue)
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
            minY = maxY = dataModel.get(0).y

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

        maxY += 25
        minY -= 25

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

    function getRoundedStepTime()
    {
        var realStep = (maxX - minX)/maxStepNumberX

//        print("minX", minX, "maxX", maxX)
//        print("maxX - minX", maxX - minX)
//        print("realStep", realStep)

        var digit = 0.0000000001

        while (digit*10 < realStep)
            digit *= 10

//        print("digit", digit)

        roundedStepX = digit

        if (digit*2 > realStep)
            roundedStepX = digit*2
        else
        if (digit*5 > realStep)
            roundedStepX = digit*5
        else
            roundedStepX = digit*10

//        print("roundedStepX", roundedStepX)

        roundedMaxX = maxX - maxX%roundedStepX

//        while (roundedMaxX > minX)
//        {
//            print(roundedMaxX)
//            roundedMaxX -= roundedStepX
//        }
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

        rightTime += (visibleTime - oldVisibleTime)*0.5

        dataAnalysis()

        chartCanvas.requestPaint();
    }

    function shiftTime(step)
    {
        if (step !== 0)
        {
            rightTime -= step / coefficientX

            dataAnalysis()

            chartCanvas.requestPaint();
        }
    }

    function drawAll(ctx)
    {
        ctx.fillStyle = currTheme.backgroundElements;
//        ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
        ctx.fillRect(0, 0, width, height);

        logic.drawGrid(ctx)

        logic.drawChart(ctx, currTheme.textColorGreen)
    }

    function drawGrid(ctx)
    {
//        var stepX = visibleTime/10

/*        for (var i = 1; i < 10; ++i)
        {
//            drawHorizontalLine(ctx, chartHeight*i/8)
            drawVerticalLine(ctx, chartWidth*i/10)

//            drawHorizontalLineText(ctx,
//                chartHeight*i/8,
//                (maxY-stepY*i))
//            drawVerticalLineText(ctx,
//                chartWidth*i/8,
//                (minX+stepX*i))
            drawVerticalLineText(ctx,
                chartWidth*i/10,
                (rightTime - visibleTime + stepX*i))
        }*/

        var currentX = roundedMaxX
        while (currentX > minX)
        {
            drawVerticalLine(ctx,
                (currentX - minX)*coefficientX)

            drawVerticalLineText(ctx,
                (currentX - minX)*coefficientX,
                currentX)

//            print(currentX)
            currentX -= roundedStepX
        }


        var currentY = roundedMaxY
        while (currentY > minY)
        {
            drawHorizontalLine(ctx,
                (maxY - currentY)*coefficientY)

            drawHorizontalLineText(ctx,
                (maxY - currentY)*coefficientY,
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

            drawLine(ctx,
                (dataModel.get(i-1).x - rightTime + visibleTime)*coefficientX,
                (maxY - dataModel.get(i-1).y)*coefficientY,
                (dataModel.get(i).x - rightTime + visibleTime)*coefficientX,
                (maxY - dataModel.get(i).y)*coefficientY,
                color)
        }
    }

    function drawLine(ctx, x1, y1, x2, y2, color)
    {
        ctx.lineWidth = lineWidth;
        ctx.strokeStyle = color
        ctx.beginPath()
        ctx.moveTo(x1, y1)
        ctx.lineTo(x2, y2)
        ctx.stroke()
    }

    function drawHorizontalLine(ctx, y, text)
    {
        ctx.lineWidth = gridWidth;
        ctx.strokeStyle = gridColor;
        ctx.beginPath();
        ctx.moveTo(chartWidth, y);
        ctx.lineTo(0, y);
        ctx.stroke();
    }

    function drawVerticalLine(ctx, x, text)
    {
        ctx.lineWidth = gridWidth;
        ctx.strokeStyle = gridColor;
        ctx.beginPath();
        ctx.moveTo(x, chartHeight);
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
        ctx.fillText(text , x + fontIndent, height - fontIndent);
        ctx.stroke();
    }

}
