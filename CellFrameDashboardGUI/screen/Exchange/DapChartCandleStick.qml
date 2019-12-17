import QtQuick 2.0
Item{

    property int minVoluePrice: 10000
    property int maxVoluePtice: 10800
    property int leftTime:100
    property int rightTime:500

    property string fontColorArea: "#757184"
    property int fontSizeArea: 10 * pt

    property string lineColorArea: "#C7C6CE"
    property int lineWidthArea: 1

    property string candleColorUp:"#6F9F00"
    property string candleColorDown:"#EB4D4B"


    anchors.fill: parent
    anchors.topMargin: 50
    anchors.bottomMargin: 400
Canvas {
    id: chartCanvas
    anchors.fill: parent
    onPaint: {
        var ctx = getContext("2d");
       ctx.beginPath();
       verticalLineChart(10,"10.50",ctx);
       horizontalLineChart(50,"1000",ctx);
       candleVisual(ctx,300,300,100,250,150);
//        ctx.fillStyle = Qt.rgba(1, 0, 0, 1);
//        ctx.fillRect(0, 0, width, height);
//        ctx.beginPath();
//        ctx.arc(75,75,50,0,Math.PI*2,true); // Outer circle
//        ctx.moveTo(110,75);
//        ctx.arc(75,75,35,0,Math.PI,false);   // Mouth
//        ctx.moveTo(65,65);
//        ctx.arc(60,65,5,0,Math.PI*2,true);  // Left eye
//        ctx.moveTo(95,65);
//        ctx.arc(90,65,5,0,Math.PI*2,true);  // Right eye
        ctx.stroke();
    }

}

function verticalLineChart(x,text,ctx)
{
    ctx.lineWidth = lineWidthArea;
    ctx.strokeStyle = lineColorArea;
    ctx.moveTo(x, chartCanvas.height-15);
    ctx.lineTo(x, 0);
    ctx.closePath();
    ctx.font = "normal "+fontSizeArea+ "px Roboto";
    ctx.fillStyle = fontColorArea;
    ctx.fillText(text,x-13,chartCanvas.height);
      ctx.stroke();
}

function horizontalLineChart(y,text,ctx)
{
    ctx.lineWidth = lineWidthArea;
    ctx.strokeStyle = lineColorArea;
    ctx.moveTo(chartCanvas.width-50, y);
    ctx.lineTo(0, y);
    ctx.closePath();
    ctx.font = "normal "+fontSizeArea+ "px Roboto";
    ctx.fillStyle = fontColorArea;
    ctx.fillText(text,chartCanvas.width-45,y+3);
      ctx.stroke();
}

function candleVisual(ctx,pointTime,minimum,maximum,open,close)
{
    ctx.lineWidth = candleColorUp;
    ctx.strokeStyle = candleColorUp;
    ctx.moveTo(pointTime,minimum);
    ctx.lineTo(pointTime, maximum);
    ctx.moveTo(pointTime-2, open);
    ctx.lineTo(pointTime-2, close);
    ctx.lineTo(pointTime+2, close);
    ctx.lineTo(pointTime+2, open);
  ctx.stroke();
    //ctx.fillRect(pointTime-2, open, pointTime+2, close)
}


}
