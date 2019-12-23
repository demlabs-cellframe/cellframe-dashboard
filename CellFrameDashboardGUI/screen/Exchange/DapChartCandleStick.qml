//Создать ось Х в зависимости от значения левого и правого времени на экране 6 полос
//создать ось У в зависимости от пределов значения прайс на экране 8 полос нижняя без значения верхняя не отображается
//задать функции для изменения пределов значения осей для последующей перерисовки графика и смены значения
//функция преобразования времени
//функция преобразования валюты и времени в координаты
//Обратная функция предыдущей для отклика от пользователя
//функция заполнения данных из модели

import QtQuick 2.0

    Canvas {
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

        property string lineColorArea: "#C7C6CE"
        property int lineWidthArea: 1

        property string candleColorUp:"#6F9F00"
        property string candleColorDown:"#EB4D4B"
        property int candleWidthLine: 1 * pt
        property int candleWidth: 5 * pt

        property string imageCursorPath:"qrc:/res/icons/ic_flag.png"
        property int imageCursorWidth: 44 * pt
        property int imageCursorHeight: 16 * pt
        property string colorCursorLine:"#070023"// "#757184"
        property string colorCursorFont: "#FFFFFF"
        property int fontSizeCursor: 10*pt

        property int currentValue: 10236

        property int stepTime:thisProperty.hour


        property int fieldXMin: 0
        property int fieldXMax: 100
        property int fieldYMin: 0
        property int fieldYMax: 100

        //Количество свечей за пределами экрана с права и слева
        property int cashCandle: 5

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

            property var canvasCTX: ctx

            property int positionMouseX:0

            property int modelCountMin: 0
            property int modelCountMax: candleModel.count
            property int modelCountDisplay: candleModel.count

        }

        id: chartCanvas

        Component.onCompleted: {
            loadImage(imageCursorPath);
            //moveTimer.stop();
        }
        onPaint: {
            canvasPaint();
        }
        MouseArea{
            id:areaCanvas
            anchors.fill: parent

            Timer{
                id:moveTimer
               // running: true
                repeat: true
                interval: 10
                onTriggered: {
                    rightTime = rightTime + (thisProperty.positionMouseX-areaCanvas.mouseX)*thisProperty.xRealFactor;
                    canvasPaint();
                    thisProperty.positionMouseX = areaCanvas.mouseX
                }
            }
            onPressed: {
                if(mouse.button === Qt.LeftButton) {

                        thisProperty.positionMouseX = mouseX;
                        moveTimer.start();
                }
            }
            onReleased: {
                moveTimer.stop();
                autoSetDisplayCandle();
            }
        }

        function canvasPaint()
        {
            autoSetWidthPrice()
            init();
            var ctx = getContext("2d");
            ctx.clearRect(0,0,parent.width,parent.height)
            thisProperty.canvasCTX = ctx;
            timeToXLineChart(ctx);
            valuePriceYLineChart(ctx);
            fillCandle(ctx);
        //    ct.stroke();

            chartCanvas.requestPaint();
        }

        function autoSetDisplayCandle()
        {
            var valueActualTime = stepTime*maxXLine;
            var minTime = rightTime - valueActualTime;
            var isFirst = false;
            var isEnded = false;
            var firstCandle = 0;
            var endedCandle = thisProperty.modelCountMax;
            for (var count = thisProperty.modelCountMin;count<thisProperty.modelCountMax;count++)
            {
                if(!isFirst | minTime > candleModel.get(count).time)
                    {
                        isFirst = true;
                        if(count>10)thisProperty.modelCountMin = count-cashCandle;
                        else thisProperty.modelCountMin = 0;
                    }
                if(!isEnded | rightTime>candleModel.get(count).time)
                    {
                        isEnded = true;
                        if(count < candleModel.count-10)thisProperty.modelCountMax = count+cashCandle;
                        else thisProperty.modelCountMax = candleModel.count;
                    }
            }
        }

///Авто подбор нижнего и верхнего предела
        function autoSetWidthPrice()
        {
            autoSetDisplayCandle();
            var minPrice = candleModel.get(thisProperty.modelCountMin).minimum;
            var maxPrice = candleModel.get(thisProperty.modelCountMin).maximum;

            for(var count = thisProperty.modelCountMin; count < thisProperty.modelCountMax; count++)
            {

                if(minPrice > candleModel.get(count).minimum) minPrice = candleModel.get(count).minimum;
                if(maxPrice < candleModel.get(count).maximum) maxPrice = candleModel.get(count).maximum;
            }
            maxValuePrice = maxPrice;
            minValuePrice = minPrice;
        }

        ///Initiation property
        function init(){
            fieldXMax = chartCanvas.width - rightTextField - marginHorizontalLineToYAxisText;
            fieldYMax = chartCanvas.height - fontSizeArea - topMarginXAxisText - bottomOutLine;
            thisProperty.yRealField = fieldYMax - fieldYMin;
            thisProperty.intervalPrice = maxValuePrice - minValuePrice;
            thisProperty.yRealFactor = thisProperty.intervalPrice / thisProperty.yRealField;
            thisProperty.xRealFactor = (stepTime*maxXLine)/(fieldXMax-fieldXMin);
        }

        //Преобразование времени в координаты
        function timeToXChart(TimeX)
        {
            var a = new Date(TimeX * 1000);
            var hour = a.getHours();
            if(hour<10)hour = '0'+hour;
            var min = a.getMinutes();
            if(min<10)min='0'+min;
            var time = hour + ':' + min;
            return time;
        }

        //Расчет сетки по Х
        function timeToXLineChart(ctx)
        {
            for(var count = 0; count < maxXLine; count++)
            {
                var timeRound = rightTime%stepTime
                var timeLine = rightTime - (stepTime*count)-timeRound;
                var timeXAxis = ((stepTime*count)+timeRound)/thisProperty.xRealFactor;
                verticalLineChart(ctx,fieldXMax - timeXAxis,timeToXChart(timeLine));
            }
        }

        //Расчет сетки по Y
        function valuePriceYLineChart(ctx)
        {
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

        function fillCandle(ctx)
        {

            for(var count = thisProperty.modelCountMin; count< thisProperty.modelCountMax ; count++)
            {

              candleVisual(ctx,candleModel.get(count).time,candleModel.get(count).minimum,
                           candleModel.get(count).maximum,candleModel.get(count).open,candleModel.get(count).close);
            }
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

            if(fieldXMax>timeXAxis)
            {
            ctx.beginPath()
    //      ctx.save();
            ctx.lineWidth = candleWidthLine;
            if(open < close)
            {
            ctx.strokeStyle = candleColorUp;
            ctx.fillStyle = candleColorUp;
            }else
            {
            ctx.strokeStyle = candleColorDown;
            ctx.fillStyle = candleColorDown;
            }

            ctx.moveTo(timeXAxis,getYValue(minimum));
            ctx.lineTo(timeXAxis, getYValue(maximum));
            ctx.moveTo(timeXAxis-(candleWidth/2), getYValue(open));
            ctx.lineTo(timeXAxis-(candleWidth/2), getYValue(close));
            ctx.lineTo(timeXAxis+(candleWidth/2), getYValue(close));
            ctx.lineTo(timeXAxis+(candleWidth/2), getYValue(open));
            ctx.lineTo(timeXAxis-(candleWidth/2), getYValue(open));
            ctx.stroke();
            ctx.fill();
            }
            //ctx.restore();
        }
        function getYValue(value)
        {
            return fieldYMax - (value-minValuePrice)/thisProperty.yRealFactor;
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
