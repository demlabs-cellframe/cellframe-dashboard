import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    property int fontSize: 12
//    property string fontFamilies: "Quicksand"
    property string fontFamilies: "Arial"
    property int fontIndent: 3

    property string backgroundColor: currTheme.backgroundElements
    property string gridColor: "#3E4249"
    property string gridTextColor: "#ffffff"

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
            ctx.fillStyle = backgroundColor;
            ctx.fillRect(0, 0, width, height);

            drawGrid(ctx)

            drawChart(ctx, chart1, "#DEF398")
            drawChart(ctx, chart2, "#A361FF")
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
    }

    function drawGrid(ctx)
    {
        var stepX = (maxX - minX)/20
        var stepY = (maxY - minY)/64

        for (var i = 1; i < 64; ++i)
        {
            if(i % 2 === 0)
            {
                drawHorizontalLine(ctx, height*i/20)
                drawVerticalLine(ctx, width*i/64)
            }
            //else
            //{
                //drawHorizontalLineText(ctx, height*i/8,
                  //  "y " + (maxY-stepY*i))
                //drawVerticalLineText(ctx, width*i/8,
                  //  "x " + (minX+stepX*i))
            //}
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

    /*function drawHorizontalLineText(ctx, y, text)
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
    }*/

    function drawVerticalLine(ctx, x, text)
    {
        ctx.lineWidth = gridWidth;
        ctx.strokeStyle = gridColor;
        ctx.beginPath();
        ctx.moveTo(x, height);
        ctx.lineTo(x, 0);
        ctx.stroke();
    }

    /*function drawVerticalLineText(ctx, x, text)
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
    }*/

}
