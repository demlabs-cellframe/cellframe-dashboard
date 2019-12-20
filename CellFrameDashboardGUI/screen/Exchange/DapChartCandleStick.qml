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
    property int rightTime: 1546560000
    property int maxXLine: 6
    property int maxYLine: 10
    property int heightNoLine: 40*pt

    property string fontColorArea: "#757184"
    property int fontSizeArea: 10 * pt

    property string lineColorArea: "#C7C6CE"
    property int lineWidthArea: 1

    property string candleColorUp:"#6F9F00"
    property string candleColorDown:"#EB4D4B"

    property string imageCursorPath:"qrc:/res/icons/ic_flag.png"
    property int imageCursorWidth: 44 * pt
    property int imageCursorHeight: 16 * pt
    property string colorCursorLine: "#757184"
    property string colorCursorFont: "#FFFFFF"
    property int fontSizeCursor: 10*pt



    property int fieldXMin: 30
    property int fieldXMax: dapChart.width
    property int fieldYMin: 30
    property int fieldYMax: dapChart.height

    //    Component.onCompleted: {
    //        loadImage(imageCursorPath)
    //    }
    QtObject {
        id: thisProperty
        property int year: 31556926;
        property int month: 2629743;
        property int week: 604800;
        property int day: 86400;
        property int hour: 3600;
        property int minute: 60;


    }
    Canvas {
        id: chartCanvas
        anchors.fill: parent
        onPaint: {
            //fieldXMax = chartCanvas.width;
            //fieldYMax = chartCanvas.height;
            var ctx = getContext("2d");
            ctx.beginPath();
            var xTime = timeToXChart(leftTime);
            horizontalLineCurrentLevelChart(ctx,100,"txt");
            timeToXLineChart(ctx,thisProperty.hour);
            valuePriceYLineChart(ctx);
            candleVisual(ctx,300,300,100,250,150);

            ctx.stroke();
        }

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
        var time = hour + '.' + min;//date + ' ' + month + ' ' + year + ' ' + hour + ':' + min;
        return time;
    }
    //Обновление текущего времени
    function timeNow()
    {

    }

    //Расчет сетки по Х
    function timeToXLineChart(ctx,stepTime)
    {
        var timeIntervalAll = rightTime - leftTime;
        var realFactor = (stepTime*maxXLine)/(fieldXMax-fieldXMin);

        for(var count = maxXLine; count > 0; count--)
        {
            var timeMoment = leftTime+(stepTime*count);
            var moveTime = 6*thisProperty.minute;
            var timeXAxis = (stepTime*count - moveTime - timeMoment % stepTime)/realFactor;
            verticalLineChart(ctx,fieldXMin + timeXAxis,timeToXChart(timeMoment - moveTime));
        }
    }

    //Расчет сетки по Y
    function valuePriceYLineChart(ctx)
    {
        var realField = fieldYMax - fieldYMin;
        var valuePriceIntervalAll = maxValuePrice - minValuePrice;
        var realFactor = valuePriceIntervalAll/realField;

        var realInterval = (fieldYMax - fieldYMin)/maxYLine;

        var priceInterval = valuePriceIntervalAll/maxYLine;
        var stepPrise = 10;

        for(var scanStep = 1; scanStep < 100000;scanStep*=10)
        {
            if(valuePriceIntervalAll/scanStep <= maxYLine) {stepPrise = scanStep; break;}
            if(valuePriceIntervalAll/(scanStep*5) <= maxYLine) {stepPrise = scanStep*5;break;}
        }

        //Множитель для преобразования
//        var realFactor = valuePriceIntervalAll/realInterval;
        for(var count = 0; count<maxYLine;count++)
        {
            if(count === 0)
            {
                horizontalLineChart(ctx,fieldYMax,"");
            }
            else
            if(fieldYMax-((stepPrise*count/realFactor))>heightNoLine)
            {
                horizontalLineChart(ctx,fieldYMax-((stepPrise*count/realFactor)),minValuePrice+stepPrise*count);
            }
        }
    }

    function verticalLineChart(ctx,x,text)
    {
        ctx.beginPath()
        ctx.save();
        ctx.lineWidth = lineWidthArea;
        ctx.strokeStyle = lineColorArea;
        ctx.moveTo(x, chartCanvas.height-15);
        ctx.lineTo(x, 0);
        //ctx.closePath();
        ctx.font = "normal "+fontSizeArea+ "px Roboto";
        ctx.fillStyle = fontColorArea;
        ctx.fillText(text,x-13,chartCanvas.height-2);
        ctx.stroke();
        ctx.restore();
    }

    function horizontalLineChart(ctx,y,text)
    {
        ctx.beginPath();
        ctx.save();
        ctx.lineWidth = lineWidthArea;
        ctx.strokeStyle = lineColorArea;
        ctx.moveTo(chartCanvas.width-50, y);
        ctx.lineTo(0, y);
        ctx.font = "normal "+fontSizeArea+ "px Roboto";
        ctx.fillStyle = fontColorArea;
        ctx.fillText(text,chartCanvas.width-45,y+3);
        ctx.stroke();
        ctx.restore();
    }

    function candleVisual(ctx,pointTime,minimum,maximum,open,close)
    {
        ctx.beginPath()
        ctx.save();
        ctx.lineWidth = candleColorUp;
        ctx.strokeStyle = candleColorUp;
        ctx.moveTo(pointTime,minimum);
        ctx.lineTo(pointTime, maximum);
        ctx.moveTo(pointTime-2, open);
        ctx.lineTo(pointTime-2, close);
        ctx.lineTo(pointTime+2, close);
        ctx.lineTo(pointTime+2, open);
        ctx.stroke();
        ctx.restore();
    }

    function horizontalLineCurrentLevelChart(ctx,y,text)
    {
        ctx.lineWidth = lineWidthArea;
        ctx.strokeStyle = lineColorArea;
        ctx.beginPath()
        ctx.save();
        ctx.moveTo(0, y);
        ctx.lineTo(chartCanvas.width-70, y);
        ctx.drawImage(imageCursorPath, chartCanvas.width-70, y-imageCursorHeight/2,imageCursorWidth,imageCursorHeight);
        ctx.font = "normal " +fontSizeCursor+ "px Roboto";
        ctx.fillStyle = colorCursorFont;
        ctx.fillText(text,chartCanvas.width-60,y-imageCursorHeight/4);
        ctx.stroke();
        ctx.closePath();
        ctx.restore();
    }

}
