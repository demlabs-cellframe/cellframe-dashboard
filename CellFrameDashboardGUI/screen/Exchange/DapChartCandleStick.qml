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
    property int leftTime: 1546500000
    property int rightTime:1547100000

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

    anchors.fill: parent
    anchors.topMargin: 50
    anchors.bottomMargin: 400

    //    Component.onCompleted: {
    //        loadImage(imageCursorPath)
    //    }

    Canvas {
        id: chartCanvas
        anchors.fill: parent
        onPaint: {
            //fieldXMax = chartCanvas.width;
            //fieldYMax = chartCanvas.height;
            var ctx = getContext("2d");
            ctx.beginPath();
            var xTime = timeToXChart(leftTime);
            //verticalLineChart(10,xTime,ctx);

            valuePriceYLineChart(ctx);
          //  horizontalLineChart(50,"1000",ctx);
            candleVisual(ctx,300,300,100,250,150);
            horizontalLineCurrentLevelChart(ctx,100,"txt");
            timeToXLineChart(ctx);
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
        //var sec = a.getSeconds();
        var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min;
        return time;
    }
    //Обновление текущего времени
    function timeNow()
    {

    }
    //Расчет сетки по Х
    function timeToXLineChart(ctx)
    {
        var timeIntervalAll = rightTime - leftTime;
        //задаем дни часы и месяцы
        //    1 минута = 60 секунд
        //    1 час = 3600 секунд
        //    1 день = 86400 секунд
        //    1 неделя = 604800 секунд
        //    1 месяц (30.44 дней) = 2629743 секунд
        //    1 год (365.24 дней) = 31556926 секунд


        var realFactor = timeIntervalAll/(fieldXMax-fieldXMin);

        if(timeIntervalAll<604800 & timeIntervalAll > 86400)
        {
            var maxCount =Math.round(timeIntervalAll/86400) ;
            var intervalTime = timeIntervalAll/maxCount;
            for(var count = 0;count<maxCount;count++)
            {
                var stepFromLeftTime = leftTime+(intervalTime*(count+1));
                var thisTime = Math.round(stepFromLeftTime - Math.round(stepFromLeftTime % 86400)) ;
               // if(leftTime+intervalTime)
                verticalLineChart(ctx,fieldXMin + (thisTime/*intervalTime*//realFactor*count),count)
            }
        }
    }

    //Расчет сетки по Y
    function valuePriceYLineChart(ctx)
    {
        var realInterval = (fieldYMax - fieldYMin)/8;

        var valuePriceIntervalAll = maxValuePrice - minValuePrice;
        var priceInterval = valuePriceIntervalAll/8;
        //Множитель для преобразования
        var realFactor = valuePriceIntervalAll/realInterval;
        for(var count = 0; count<8;count++)
        {
            if(count === 0)
            {
                horizontalLineChart(ctx,fieldYMax,fieldYMax);
            }
            if(count>0 & count<7)
            {
                horizontalLineChart(ctx,fieldYMax-(realInterval*count),fieldYMax);
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
        ctx.fillText(text,x-13,chartCanvas.height);
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
