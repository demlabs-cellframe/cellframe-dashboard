//Создать ось Х в зависимости от значения левого и правого времени на экране 6 полос
//создать ось У в зависимости от пределов значения прайс на экране 8 полос нижняя без значения верхняя не отображается
//задать функции для изменения пределов значения осей для последующей перерисовки графика и смены значения
//функция преобразования времени
//функция преобразования валюты и времени в координаты
//Обратная функция предыдущей для отклика от пользователя
//функция заполнения данных из модели

import QtQuick 2.0

Item{
    id:dapChart
    property int minValuePrice: 10000
    property int maxValuePrice: 10800
    property int leftTime: 1546540000
    property int rightTime: 1546564800
    property int maxXLine: 6
    property int maxYLine: 10
    property int heightNoLine: 40*pt
    property int marginHorizontalLineToYAxisText:14 * pt
    property int rightTextField: 31 * pt
    property int bottomOutLine: 4 * pt

    property string fontColorArea: "#757184"
    property int fontSizeArea: 10 * pt
    property int topMarginXAxisText: 8 * pt
    property int candleWidth: 5 * pt

    property string lineColorArea: "#C7C6CE"
    property int lineWidthArea: 1

    property string candleColorUp:"#6F9F00"
    property string candleColorDown:"#EB4D4B"

    property string imageCursorPath:"qrc:/res/icons/ic_flag.png"
    property int imageCursorWidth: 44 * pt
    property int imageCursorHeight: 16 * pt
    property string colorCursorLine:"#070023"// "#757184"
    property string colorCursorFont: "#FFFFFF"
    property int fontSizeCursor: 10*pt

    property int currentValue: 10236

    property int stepTime:thisProperty.hour


    property int fieldXMin: 0
    property int fieldXMax: dapChart.width
    property int fieldYMin: 0
    property int fieldYMax: dapChart.height



    QtObject {
        id: thisProperty
        property int year: 31556926;
        property int month: 2629743;
        property int week: 604800;
        property int day: 86400;
        property int hour: 3600;
        property int minute: 60;

        property var yRealInterval: 0.0
        property var xRealInterval: 0.0
        property var yRealFactor: 0.0
        property var xRealFactor: 0.0
        property var yRealField: 0.0
        property var intervalPrice: 0.0

    }
    Canvas {
        id: chartCanvas
        anchors.fill: parent
        Component.onCompleted: {
            loadImage(imageCursorPath);
        }
        onPaint: {
            init();
            var ctx = getContext("2d");
          //  ctx.beginPath();
            var xTime = timeToXChart(leftTime);

            timeToXLineChart(ctx);
            valuePriceYLineChart(ctx);
            candleVisual(ctx,1546555000,300,150,250,150);
            ctx.stroke();
        }
    }

    ///Initiation property
    function init(){
        fieldXMax = chartCanvas.width - rightTextField - marginHorizontalLineToYAxisText;
        fieldYMax = chartCanvas.height - fontSizeArea - topMarginXAxisText - bottomOutLine;
        thisProperty.yRealField = fieldYMax - fieldYMin;
        thisProperty.intervalPrice = maxValuePrice - minValuePrice;
        thisProperty.yRealFactor = thisProperty.intervalPrice / thisProperty.yRealField;
        thisProperty.xRealFactor = (stepTime*maxXLine)/(fieldXMax-fieldXMin);
//        var realInterval = (fieldYMax - fieldYMin) / maxYLine;

//        var priceInterval = thisProperty.intervalPrice / maxYLine;
    }

    //Преобразование времени в координаты
    function timeToXChart(TimeX)
    {
        var a = new Date(TimeX * 1000);
        var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        var year = a.getFullYear();
        var month = months[a.getMonth()];
        var date = a.getDate();
        var hour = a.getHours();
        var min = a.getMinutes();
        var time = hour + ':' + min;//date + ' ' + month + ' ' + year + ' ' + hour + ':' + min;
        return time;
    }

    //Расчет сетки по Х
    function timeToXLineChart(ctx)
    {
        //var timeIntervalAll = rightTime - leftTime;
        //var realFactor = (stepTime*maxXLine)/(fieldXMax-fieldXMin);

        for(var count = 1; count <= maxXLine; count++)
        {
            var timeMoment = rightTime-(stepTime*count);
            //var moveTime = 6*thisProperty.minute;
            var timeXAxis = (stepTime*count /*- moveTime*/ - timeMoment % stepTime)/thisProperty.xRealFactor;
            verticalLineChart(ctx,fieldXMax - timeXAxis,timeToXChart(timeMoment/* - moveTime*/));
        }
    }

    //Расчет сетки по Y
    function valuePriceYLineChart(ctx)
    {
       // var realField = fieldYMax - fieldYMin;
      //  var valuePriceIntervalAll = maxValuePrice - minValuePrice;
        //var realFactor = valuePriceIntervalAll/realField;

        var realInterval = (fieldYMax - fieldYMin)/maxYLine;

        var priceInterval = thisProperty.intervalPrice / maxYLine;
        var stepPrise = 10;

        for(var scanStep = 1; scanStep < 100000;scanStep*=10)
        {
            if(thisProperty.intervalPrice /scanStep <= maxYLine) {stepPrise = scanStep; break;}
            if(thisProperty.intervalPrice /(scanStep*5) <= maxYLine) {stepPrise = scanStep*5;break;}
        }
        for(var count = 0; count<maxYLine;count++)
        {
            if(count === 0)
            {
                horizontalLineChart(ctx,fieldYMax,"");
            }
            else
            if(fieldYMax-((stepPrise*count/thisProperty.yRealFactor))>heightNoLine)
            {
                horizontalLineChart(ctx,fieldYMax-((stepPrise*count/thisProperty.yRealFactor)),minValuePrice+stepPrise*count);
            }
        }
            horizontalLineCurrentLevelChart(ctx,fieldYMax - (currentValue - minValuePrice)/thisProperty.yRealFactor,currentValue);
    }

    function verticalLineChart(ctx,x,text)
    {

        ctx.beginPath()
        //ctx.save();
        ctx.lineWidth = lineWidthArea;
        ctx.strokeStyle = lineColorArea;
        ctx.moveTo(x, chartCanvas.height-fontSizeArea-topMarginXAxisText);
        ctx.lineTo(x, 0);
        //ctx.closePath();
        ctx.font = "normal "+fontSizeArea+ "px Roboto";
        ctx.fillStyle = fontColorArea;
        ctx.fillText(text,x-13,chartCanvas.height);
        ctx.stroke();
    }

    function horizontalLineChart(ctx,y,text)
    {
        ctx.beginPath();
        //ctx.save();
        ctx.lineWidth = lineWidthArea;
        ctx.strokeStyle = lineColorArea;
        ctx.moveTo(fieldXMax, y);
        ctx.lineTo(0, y);
        ctx.font = "normal "+fontSizeArea+ "px Roboto";
        ctx.fillStyle = fontColorArea;
        ctx.fillText(text,chartCanvas.width - rightTextField,y+3);
        ctx.stroke();
    }

    function candleVisual(ctx,pointTime,minimum,maximum,open,close)
    {
        var timeXAxis = fieldXMax-(rightTime-pointTime)/thisProperty.xRealFactor;

        ctx.beginPath()
//      ctx.save();
        ctx.lineWidth = candleColorUp;
        ctx.strokeStyle = candleColorUp;
        ctx.fillStyle = candleColorUp;
        ctx.moveTo(timeXAxis,minimum);
        ctx.lineTo(timeXAxis, maximum);
        ctx.moveTo(timeXAxis-(candleWidth/2), open);
        ctx.lineTo(timeXAxis-(candleWidth/2), close);
        ctx.lineTo(timeXAxis+(candleWidth/2), close);
        ctx.lineTo(timeXAxis+(candleWidth/2), open);
        ctx.lineTo(timeXAxis-(candleWidth/2), open);
        ctx.stroke();
        ctx.fill();

        //ctx.restore();
    }

    function horizontalLineCurrentLevelChart(ctx,y,text)
    {
        ctx.beginPath()
        ctx.lineWidth = lineWidthArea;
        ctx.strokeStyle = colorCursorLine;

        ctx.save();
        ctx.moveTo(0, y);
        ctx.lineTo(chartCanvas.width - imageCursorWidth + 4, y);

        ctx.drawImage(imageCursorPath, chartCanvas.width-imageCursorWidth, y-imageCursorHeight/2,imageCursorWidth,imageCursorHeight);

        ctx.font = "normal " +fontSizeCursor+ "px Roboto";
        ctx.fillStyle = colorCursorFont;
        ctx.fillText(text,chartCanvas.width - rightTextField - (5*pt),y+imageCursorHeight/5);
        ctx.stroke();
        chartCanvas.requestPaint();
     //   ctx.closePath();
     //   ctx.restore();
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
