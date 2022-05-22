import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    property int fontSize: 12
//    property string fontFamilies: "Quicksand"
    property string fontFamilies: "Arial"
    property int fontIndent: 3

    property string gridColor: "grey"
    property string gridTextColor: "black"

    property real gridWidth: 1
    property real lineWidth: 2

    property real minX: 0
    property real maxX: 0

    property real minY: 0
    property real maxY: 0

    ListModel{
        id:chart1
        ListElement{x:1546543400;y:10000}
        ListElement{x:1546543500;y:12000}
        ListElement{x:1546543600;y:17000}
        ListElement{x:1546543700;y:11000}
        ListElement{x:1546543800;y:9000}
        ListElement{x:1546543900;y:13000}
        ListElement{x:1546544000;y:14000}
        ListElement{x:1546544100;y:16000}
        ListElement{x:1546544200;y:12000}
        ListElement{x:1546544300;y:11000}
        ListElement{x:1546544400;y:15000}
    }
    ListModel{
        id:chart2
        ListElement{x:1546543400;y:8000}
        ListElement{x:1546543500;y:10000}
        ListElement{x:1546543600;y:11000}
        ListElement{x:1546543700;y:15000}
        ListElement{x:1546543800;y:18000}
        ListElement{x:1546543900;y:16000}
        ListElement{x:1546544000;y:12000}
        ListElement{x:1546544100;y:11000}
        ListElement{x:1546544200;y:9000}
        ListElement{x:1546544300;y:13000}
        ListElement{x:1546544400;y:12000}
    }

    Component.onCompleted:
    {
        dataAnalysis(chart1, true)
        dataAnalysis(chart2, false)

        if (minX == maxX)
        {
            minX -= 1
            maxX += 1
        }
        if (minY == maxY)
        {
            minY -= 1
            maxY += 1
        }
    }

    Canvas
    {
        anchors.fill: parent

        onPaint:
        {
            var ctx = getContext("2d");
            ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
            ctx.fillRect(0, 0, width, height);

//            drawLine(ctx, 0, 0, width, height, "red")
//            drawLine(ctx, width, 0, 0, height, "blue")

/*            drawHorizontalLine(ctx, height*0.125)
            drawHorizontalLineText(ctx, height*0.25, "0.25")
            drawHorizontalLine(ctx, height*0.375)
            drawHorizontalLineText(ctx, height*0.5, "0.5")
            drawHorizontalLine(ctx, height*0.625)
            drawHorizontalLineText(ctx, height*0.75, "0.75")
            drawHorizontalLine(ctx, height*0.875)

            drawVerticalLine(ctx, width*0.25)
            drawVerticalLineText(ctx, width*0.5, "0.5")
            drawVerticalLine(ctx, width*0.75)*/

            drawGrid(ctx)

            drawChart(ctx, chart1, "red")
            drawChart(ctx, chart2, "green")
        }
    }

    function dataAnalysis(model, reset)
    {
        for (var i = 0; i < model.count; ++i)
        {
            if (i === 0 && reset)
            {
                minX = maxX = model.get(i).x
                minY = maxY = model.get(i).y
            }
            else
            {
                if (minX > model.get(i).x)
                    minX = model.get(i).x
                if (maxX < model.get(i).x)
                    maxX = model.get(i).x
                if (minY > model.get(i).y)
                    minY = model.get(i).y
                if (maxY < model.get(i).y)
                    maxY = model.get(i).y
            }
        }

//        print("minX", minX, "minY", minY,
//              "maxX", maxX, "maxY", maxY)
    }

    function drawGrid(ctx)
    {
        var stepX = (maxX - minX)/8
        var stepY = (maxY - minY)/8

        for (var i = 1; i < 8; ++i)
        {
            if(i % 2 === 0)
            {
                drawHorizontalLine(ctx, height*i/8)
                drawVerticalLine(ctx, width*i/8)
            }
            else
            {
                drawHorizontalLineText(ctx, height*i/8,
                    "y " + (maxY-stepY*i))
                drawVerticalLineText(ctx, width*i/8,
                    "x " + (minX+stepX*i))
            }
        }
    }

    function drawChart(ctx, model, color)
    {
        var coeffX = width/(maxX - minX)
        var coeffY = height/(maxY - minY)

        for (var i = 1; i < model.count; ++i)
        {
            drawLine(ctx,
                (model.get(i-1).x - minX)*coeffX,
                (maxY - model.get(i-1).y)*coeffY,
                (model.get(i).x - minX)*coeffX,
                (maxY - model.get(i).y)*coeffY,
                color)
//            print((model.get(i-1).x - minX)*coeffX,
//                  (maxY - model.get(i-1).y)*coeffY,
//                  (model.get(i).x - minX)*coeffX,
//                  (maxY - model.get(i).y)*coeffY)
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
        ctx.moveTo(width, y);
        ctx.lineTo(0, y);
        ctx.stroke();
    }

    function drawHorizontalLineText(ctx, y, text)
    {
        ctx.lineWidth = gridWidth;
        ctx.strokeStyle = gridColor;
        ctx.beginPath();
        ctx.moveTo(width, y);
        ctx.lineTo(0, y);
        ctx.font = "normal "+fontSize+"px "+fontFamilies;
        ctx.fillStyle = gridTextColor;
        ctx.fillText(text, fontIndent, y - fontIndent);
        ctx.stroke();
    }

    function drawVerticalLine(ctx, x, text)
    {
        ctx.lineWidth = gridWidth;
        ctx.strokeStyle = gridColor;
        ctx.beginPath();
        ctx.moveTo(x, height);
        ctx.lineTo(x, 0);
        ctx.stroke();
    }

    function drawVerticalLineText(ctx, x, text)
    {
        ctx.lineWidth = gridWidth;
        ctx.strokeStyle = gridColor;
        ctx.beginPath();
        ctx.moveTo(x, 0);
        ctx.lineTo(x, height);
        ctx.font = "normal "+fontSize+"px "+fontFamilies;
        ctx.fillStyle = gridTextColor;
        ctx.fillText(text, x + fontIndent, height - fontIndent);
        ctx.stroke();
    }

}
