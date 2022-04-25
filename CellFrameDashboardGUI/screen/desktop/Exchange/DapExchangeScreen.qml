import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "qrc:/widgets"
import "../../"


DapExchangeScreenForm
{
/************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                       CandleStick model
************************************************************************************************/
    ListModel{
        id:candleModel
        ListElement{time:1546543400;minimum:10000;maximum:10550;open:10050;close:10100;}
        ListElement{time:1546543700;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546544000;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546544300;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546544600;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546544900;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546545200;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546545500;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546545800;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546546100;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546546400;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546546700;minimum:10300;maximum:10550;open:10450;close:10400;}
        ListElement{time:1546547000;minimum:10200;maximum:10650;open:10350;close:10400;}
        ListElement{time:1546547300;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546547600;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546547900;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546548200;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546548500;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546548800;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546549100;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546549400;minimum:10300;maximum:10650;open:10450;close:10400;}
        ListElement{time:1546549700;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546550000;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546550300;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546550600;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546550900;minimum:10500;maximum:10650;open:10550;close:10580;}
        ListElement{time:1546551200;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546551500;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546551800;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546552100;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546552400;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546552700;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546553000;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546553300;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546553600;minimum:10650;maximum:10950;open:10800;close:10750;}
        ListElement{time:1546553900;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546554200;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546554500;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546554800;minimum:10200;maximum:10450;open:10350;close:10400;}
    }
/************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                      Converson model
************************************************************************************************/

    ListModel
    {
        id: conversionList
        ListElement{text: "TKN1/NGD"}
        ListElement{text: "TKN2/NGD"}
        ListElement{text: "NGD/KLVN"}
        ListElement{text: "KLVN/USD"}
    }
/************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                           Time model
************************************************************************************************/
    ListModel
    {
        id: timeModel
        ListElement{text: "1 minute"}
        ListElement{text: "5 minute"}
        ListElement{text: "15 minute"}
        ListElement{text: "30 minute"}
        ListElement{text: "1 hour"}
        ListElement{text: "4 hour"}
        ListElement{text: "12 hour"}
        ListElement{text: "24 hour"}
    }
    /************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                        Orders model
************************************************************************************************/
    ListModel
    {
        id: orderModel
        ListElement{titleOrder:"Buy"; path:"qrc:/resources/icons/buy_icon.png";currencyName: qsTr("KLVN");tokenName: qsTr("TKN1");balance: 0}
        ListElement{titleOrder:"Sell"; path:"qrc:/resources/icons/sell_icon.png";currencyName: qsTr("KLVN");tokenName: qsTr("TKN1");balance: 0}
    }

    /************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                        History model
************************************************************************************************/

    ListModel
    {
        id: modelExchangeHistory
        ListElement{time:"Jule,11,11:55";status:"Sell";price:10550;token:10.05013112}
        ListElement{time:"Jule,11,11:55";status:"Buy";price:10550;token:1.00502423}
        ListElement{time:"Jule,11,11:55";status:"Sell";price:10550;token:100.502222}
        ListElement{time:"Jule,11,11:55";status:"Buy";price:10550;token:1.00503453}
        ListElement{time:"Jule,11,11:55";status:"Buy";price:10.23423;token:1005.0}
        ListElement{time:"Jule,11,11:55";status:"Sell";price:10550;token:10.050345}
        ListElement{time:"Jule,11,11:55";status:"Sell";price:10550;token:10.05021312}
        ListElement{time:"Jule,11,11:55";status:"Buy";price:150.12;token:1.005034543}
        ListElement{time:"Jule,11,11:55";status:"Sell";price:10550;token:100.5012321}

    }
/************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                    DapChartCandleStick
************************************************************************************************/
    Component
    {
        id:candleChart

        Canvas
        {
            id: chartCanvas

            //@detalis rightTime Indicates the completion time of the graph on the display.
            property var rightTime: 1546564800
            ///@detalis maxXLine Indicates the maximum number of vertical lines.
            property int maxXLine: 6
            ///@detalis maxYLine Indicates the maximum number of horisontal lines.
            property int maxYLine: 10
            ///@detalis heightNoLine Indicates an indentation at the top where horizontal lines are not displayed.
            property int heightNoLine: 40*pt
            ///@detalis marginHorizontalLineToYAxisText Indicates the indent between text and lines.
            property int marginHorizontalLineToYAxisText:14 * pt
            ///@detalis rightTextField Width of the right text box.
            property int rightTextField: 31 * pt
            ///@detalis bottomOutLine The height of the line protrusion below the graph field.
            property int bottomOutLine: 4 * pt
            ///@detalis fontColorArea Axial font color.
            property string fontColorArea: "#757184"
            ///@detalis fontSizeArea Size font.
            property int fontSizeArea: 10 * pt
            ///@detalis topMarginXAxisText Indicates the indent between text and lines.
            property int topMarginXAxisText: 8 * pt
            ///@detalis lineColorArea Line color.
            property string lineColorArea: "#C7C6CE"
            ///@detalis lineWidthArea Width color.
            property int lineWidthArea: 1
            ///@detalis candleColorUp Bull color.
            property string candleColorUp:"#6F9F00"
            ///@detalis candleColorDown Bear candle color
            property string candleColorDown:"#EB4D4B"
            ///@detalis candleWidthLine Width candle.
            property int candleWidthLine: 1 * pt
            ///@detalis candleWidth Width body candle.
            property int candleWidth: 5 * pt
            ///@detalis imageCursorPath Path icon flug current.
            property string imageCursorPath: "qrc:/resources/icons/ic_flag.png"
            ///@detalis imageCursorWidth Width icon.
            property int imageCursorWidth: 44 * pt
            ///@detalis imageCursorHeight Height icon.
            property int imageCursorHeight: 16 * pt
            ///@detalis colorCursorLine Cursor line color.
            property string colorCursorLine:"#070023"
            ///@detalis colorCursorFont Cursor font color.
            property string colorCursorFont: "#FFFFFF"
            ///@detalis fontSizeCursor Cursor font size.
            property int fontSizeCursor: 10*pt
            ///@detalis currentValue Current value price.
            property int currentValue: 10236
            ///@detalis stepTime Time step for vertical line.
            property int stepTime:thisProperty.hour
            ///@detalis cashCandle The number of candles outside the screen from the right and left.
            property int cashCandle: 5
            ///@detalis isRightTimeCurrent Graphic redraw resolution for offset
            property bool isRightTimeCurrent: false
            ///@detalis moveTimeForVisual Time offset for visualization of vertical stripes
            property var moveTimeForVisual: 20*thisProperty.minute
            ///@detalis currentValueTime Data update time for the current price value.
            property alias currentValueTime:currentTimer.interval
            ///@detalis timeReloadCanvas Screen refresh time when the graph is shifted.
            property alias timeReloadCanvas:moveTimer.interval

            //For private values.
            QtObject
            {
                id: thisProperty
                ///@detalis minValuePrice Axis minimum value.
                property int minValuePrice: 10000
                ///@detalis maxValuePrice Axis maximum value.
                property int maxValuePrice: 10800
                //Graphics working field.
                ///@detalis fieldXMin Minimum value x.
                property int fieldXMin: 0
                ///@detalis fieldXMax Maximum value x.
                property int fieldXMax: 100
                ///@detalis fieldYMin Minimum value y.
                property int fieldYMin: 0
                ///@detalis fieldYMax Maximum value y.
                property int fieldYMax: 100
                //Variables for setting time.
                //Year.
                property int year: 31556926;
                //Month.
                property int month: 2629743;
                //Week.
                property int week: 604800;
                //Day.
                property int day: 86400;
                //Hour.
                property int hour: 3600;
                //Minute.
                property int minute: 60;
                ///@detalis yRealFactor Coordinate multiplier y.
                property var yRealFactor: 0.0
                ///@detalis xRealFactor Coordinate multiplier x.
                property var xRealFactor: 0.0
                ///@detalis intervalPrice The gap between the minimum and maximum values on the y axis.
                property var intervalPrice: 0.0
                ///@detalis positionMouseX Temporarily remembers the position of the mouse to calculate the offset.
                property int positionMouseX:0
                ///@detalis modelCountMin The minimum value of the counter for the passage of values (constantly recounted).
                property int modelCountMin: 0
                ///@detalis modelCountMax The maximum value of the counter for the passage of values (constantly recounted).
                property int modelCountMax: candleModel.count
                ///@detalis currentTime Time current.
                property var currentTime: new Date()

            }

            Component.onCompleted:
            {
                loadImage(imageCursorPath);
            }

            onPaint:
            {
                canvasPaint();
            }

            //Price change timer.
            Timer
            {
                id:currentTimer
                repeat: true
                interval: 10000
                onTriggered:
                {
                    thisProperty.currentTime = new Date();
                    if(isRightTimeCurrent)rightTime = thisProperty.currentTime;
                    canvasPaint();
                }
            }

            MouseArea
            {
                id:areaCanvas
                anchors.fill: parent

                //Image refresh timer.
                Timer
                {
                    id:moveTimer
                    repeat: true
                    interval: 30
                    onTriggered:
                    {
                        if(rightTime < thisProperty.currentTime)
                        {
                            rightTime = rightTime + (thisProperty.positionMouseX-areaCanvas.mouseX)*thisProperty.xRealFactor;
                            canvasPaint();
                            thisProperty.positionMouseX = areaCanvas.mouseX
                            isRightTimeCurrent = true;
                        }
                        else
                        { var tmpRightTime = (thisProperty.positionMouseX-areaCanvas.mouseX)*thisProperty.xRealFactor;
                            if(tmpRightTime<0)
                            {
                                rightTime = rightTime + (thisProperty.positionMouseX-areaCanvas.mouseX)*thisProperty.xRealFactor;
                                canvasPaint();
                                thisProperty.positionMouseX = areaCanvas.mouseX
                                isRightTimeCurrent = false;
                            }
                        }
                    }
                }

                onPressed:
                {
                    if(mouse.button === Qt.LeftButton)
                    {
                        thisProperty.positionMouseX = mouseX;
                        moveTimer.start();
                    }
                }

                onReleased:
                {
                    moveTimer.stop();
                    autoSetDisplayCandle();
                }
            }

            //Drawing a graph on the screen.
            function canvasPaint()
            {
                autoSetWidthPrice()
                init();
                var ctx = getContext("2d");
                ctx.clearRect(0,0,parent.width,parent.height)
                timeToXLineChart(ctx);
                valuePriceYLineChart(ctx);
                fillCandle(ctx);
                chartCanvas.requestPaint();
            }

            //Configuring candlestick options for rendering.
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

            ///Auto selection of the lower and upper limit.
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
                if(currentValue>maxPrice)maxPrice=currentValue;
                if(currentValue<minPrice)minPrice=currentValue;
                thisProperty.maxValuePrice = maxPrice;
                thisProperty.minValuePrice = minPrice;
            }

            ///Initiation property.
            function init()
            {
                thisProperty.fieldYMin = imageCursorHeight/2;
                thisProperty.fieldXMax = chartCanvas.width - rightTextField - marginHorizontalLineToYAxisText;
                thisProperty.fieldYMax = chartCanvas.height - fontSizeArea - topMarginXAxisText - bottomOutLine;
                thisProperty.intervalPrice = thisProperty.maxValuePrice - thisProperty.minValuePrice;
                thisProperty.yRealFactor = thisProperty.intervalPrice / (thisProperty.fieldYMax - thisProperty.fieldYMin);
                thisProperty.xRealFactor = (stepTime*maxXLine)/(thisProperty.fieldXMax-thisProperty.fieldXMin);
            }

            //Time conversion.
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

            //X grid calculation and drawing.
            function timeToXLineChart(ctx)
            {
                for(var count = 0; count < maxXLine; count++)
                {
                    var timeRound = rightTime%stepTime
                    var timeLine = rightTime - (stepTime*count)-timeRound;
                    var timeXAxis = ((stepTime * count) + timeRound + moveTimeForVisual)/thisProperty.xRealFactor;
                    verticalLineChart(ctx,thisProperty.fieldXMax - timeXAxis,timeToXChart(timeLine + moveTimeForVisual));
                }
            }

            //Y grid calculation  and drawing.
            function valuePriceYLineChart(ctx)
            {
                var realInterval = (thisProperty.fieldYMax - thisProperty.fieldYMin)/maxYLine;
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
                        horizontalLineChart(ctx,thisProperty.fieldYMax,"");
                    }
                    else
                        if(thisProperty.fieldYMax-((stepPrise*count/thisProperty.yRealFactor))>heightNoLine)
                        {
                            var stepTo = stepPrise*count - thisProperty.minValuePrice%stepPrise;
                            horizontalLineChart(ctx,thisProperty.fieldYMax-((stepTo/thisProperty.yRealFactor)),thisProperty.minValuePrice+stepTo);
                        }
                }
                horizontalLineCurrentLevelChart(ctx,thisProperty.fieldYMax - (currentValue - thisProperty.minValuePrice)/thisProperty.yRealFactor,currentValue);
            }

            //Candle drawing.
            function fillCandle(ctx)
            {

                for(var count = thisProperty.modelCountMin; count< thisProperty.modelCountMax ; count++)
                {

                    candleVisual(ctx,candleModel.get(count).time,candleModel.get(count).minimum,
                                 candleModel.get(count).maximum,candleModel.get(count).open,candleModel.get(count).close);
                }
            }

            //Vertical line draw.
            function verticalLineChart(ctx,x,text)
            {
                ctx.beginPath()
                ctx.lineWidth = lineWidthArea;
                ctx.strokeStyle = lineColorArea;
                ctx.moveTo(x, chartCanvas.height-fontSizeArea-topMarginXAxisText);
                ctx.lineTo(x, thisProperty.fieldYMin);
                ctx.font = "normal "+fontSizeArea+ "px Roboto";
                ctx.fillStyle = fontColorArea;
                ctx.fillText(text,x-13,chartCanvas.height);
                ctx.stroke();
            }

            //horizontal line draw.
            function horizontalLineChart(ctx,y,text)
            {
                ctx.beginPath();
                //ctx.save();
                ctx.lineWidth = lineWidthArea;
                ctx.strokeStyle = lineColorArea;
                ctx.moveTo(thisProperty.fieldXMax, y);
                ctx.lineTo(0, y);
                ctx.font = "normal "+fontSizeArea+ "px Roboto";
                ctx.fillStyle = fontColorArea;
                ctx.fillText(text,chartCanvas.width - rightTextField,y+3);
                ctx.stroke();
            }

            //Candle draw.
            function candleVisual(ctx,pointTime,minimum,maximum,open,close)
            {
                var timeXAxis = thisProperty.fieldXMax-(rightTime-pointTime)/thisProperty.xRealFactor;
                if(thisProperty.fieldXMax>timeXAxis)
                {
                    ctx.beginPath()
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
            }

            //Converting Values to Coordinates.
            function getYValue(value)
            {
                return thisProperty.fieldYMax - (value - thisProperty.minValuePrice)/thisProperty.yRealFactor;
            }

            //Draw a line with the current value.
            function horizontalLineCurrentLevelChart(ctx,y,text)
            {
                ctx.beginPath()
                ctx.lineWidth = lineWidthArea;
                ctx.strokeStyle = colorCursorLine;
                ctx.moveTo(0, y);
                ctx.lineTo(chartCanvas.width - imageCursorWidth + 4, y);
                ctx.drawImage(imageCursorPath, chartCanvas.width-imageCursorWidth, y-imageCursorHeight/2,imageCursorWidth,imageCursorHeight);
                ctx.font = "normal " +fontSizeCursor+ "px Roboto";
                ctx.fillStyle = colorCursorFont;
                ctx.fillText(text,chartCanvas.width - rightTextField - (5*pt),y+imageCursorHeight/5);
                ctx.stroke();
                chartCanvas.requestPaint();
            }

        }
    }

/************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                        OrderPanel
************************************************************************************************/
    Component
    {
        id: delegateOrderPanel

        ///Order panel
        Item
        {
            property int fromStringReadOnly: btnMarket.checked ? 0 : 1

            width: 312 * pt
            height: childrenRect.height
            ColumnLayout
            {
                anchors.top: parent.top
                anchors.topMargin: 16 * pt
                spacing: 0 * pt

                ///The header of the panel
                Item
                {
                    width: childrenRect.width
                    height: childrenRect.height

                    //Title line
                    RowLayout
                    {
                        spacing: 8 * pt
                        Item
                        {
                            width: 20 * pt
                            height: 20 * pt

                            //Title order image
                            Image
                            {
                                source: path
                                anchors.fill: parent
                            }
                        }
                        //Title order text
                        Text
                        {
                            color: currTheme.textColor
                            font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                            text: titleOrder
                        }
                    }
                }

                Item
                {
                    width: parent.width
                    height: 10 * pt
                }

                //Balance in the order panel
                Text
                {
                    text: qsTr("Balance: ") + balance + " " + currencyName
                    color: currTheme.textColor
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                }

                Item
                {
                    width: parent.width
                    height: 20 * pt
                }

                Item
                {
                    width: childrenRect.width
                    height: childrenRect.height

                    //List of order lines
                    ListModel
                    {
                        id: modelInputFrame
                        ListElement{titleToken:"Ammount";token:""}
                        ListElement{titleToken:"Price";token:"10 800.47"}
                        ListElement{titleToken:"Total";token:"0"}
                    }

                    ///Input fields via repeater
                    ColumnLayout
                    {
                        spacing: 16 * pt
                        Item
                        {
                            id: frameButton
                            width: childrenRect.width
                            height: childrenRect.height

                            //Frame Buttons-checkers(Market/Limit)
                            RowLayout
                            {
                                spacing: 16 * pt

                                DapButton
                                {
                                    id: btnMarket
                                    anchors.left: parent.left
                                    textButton: "Market"
                                    implicitWidth: 58 * pt
                                    implicitHeight: 24 * pt
                                    checkable: true
                                    checked: true
                                    colorBackgroundNormal: checked ? "#F8F7FA" : "#FFFFFF"
                                    colorBackgroundHover: checked ? "#F8F7FA" : "#FFFFFF"
                                    horizontalAligmentText:Qt.AlignHCenter
                                    borderColorButton: checked ? "#070023" : "#908D9D"
                                    borderWidthButton: 1 * pt
                                    fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular11
                                    colorTextButton: checked ? "#070023" : "#908D9D"

                                    onClicked:
                                    {
                                        btnMarket.checked = true;
                                        btnLimit.checked = false;
                                    }

                                }

                                DapButton
                                {
                                    id: btnLimit
                                    anchors.right: parent.right
                                    textButton: "Limit"
                                    implicitWidth: 50 * pt
                                    implicitHeight: 24 * pt
                                    checked: false
                                    checkable: true
                                    colorBackgroundNormal: checked ? "#F8F7FA" : "#FFFFFF"
                                    colorBackgroundHover: checked ? "#F8F7FA" : "#FFFFFF"
                                    horizontalAligmentText:Qt.AlignHCenter
                                    borderColorButton: checked ? "#070023" : "#908D9D"
                                    borderWidthButton: 1 * pt
                                    fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular11
                                    colorTextButton: checked ? "#070023" : "#908D9D"

                                    onClicked:
                                    {
                                        btnMarket.checked = false;
                                        btnLimit.checked = true;
                                    }
                                }
                            }
                        }

                        //Order Fields
                        Repeater
                        {
                            model: modelInputFrame
                            RowLayout
                            {
                                spacing: 0
                                Item
                                {
                                    height: childrenRect.height
                                    width: 118 * pt

                                    //String name. Text from model
                                    Text
                                    {
                                        text: titleToken
                                        color: currTheme.textColor
                                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                                    }
                                }

                                //String field
                                Rectangle
                                {
                                    width: 130 * pt
                                    height: 22 * pt
                                    radius: 6
                                    border.width: 1 * pt
                                    border.color:
                                    {
                                        if(!currencyTextInput.readOnly)
                                            return "#908D9D"
                                        else
                                            return "#C7C6CE"
                                    }
                                    color: currTheme.backgroundMainScreen

                                    //Input field
                                    TextInput
                                    {
                                        id: currencyTextInput
                                        anchors.left: parent.left
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.right: textCurrency.left
                                        anchors.leftMargin: 6 * pt
                                        anchors.rightMargin: 6 * pt
                                        color: readOnly ? "#ACAAB5" : "#59556C"
                                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                                        verticalAlignment: Qt.AlignVCenter
                                        validator: RegExpValidator{ regExp: /\d+/ }
                                        clip: true
                                        readOnly:index > fromStringReadOnly ? true : false
                                        text: token//readOnly ? "0" : ""

                                    }

                                    //Mark to input field
                                    Text
                                    {
                                        id: textCurrency
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.rightMargin: 6 * pt
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignRight
                                        color: currTheme.textColor
                                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                                        text: index === 0 ? currencyName : tokenName
                                    }
                                }
                            }
                        }

                        //Order Approval Button (Shell/Buy)
                        DapButton
                        {
                            anchors.right: parent.right
                            anchors.topMargin: 12 * pt
                            textButton: titleOrder
                            implicitWidth: 130 * pt
                            implicitHeight: 30 * pt
                            colorBackgroundNormal: "#3E3853"
                            colorBackgroundHover: "#3E3853"
                            horizontalAligmentText:Qt.AlignHCenter
                            borderColorButton: "#000000"
                            borderWidthButton: 0
                            fontButton.family:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegularCustom
                            fontButton.pixelSize: 13 * pt
                            colorTextButton: "#FFFFFF"

                            onClicked:
                            {
                                frameButton.visible = false;
                                modelInputFrame.append({"titleToken":"Fee (0.2%)","token":"10 800.47"});
                                modelInputFrame.append({"titleToken":"Total+Fee","token":"10 800.47"});
                            }
                        }
                    }
                }
            }
        }
    }

/************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                      ExchangeHistory
************************************************************************************************/


    //Transaction list delegate.
    Component
    {
        id: delegateExchangeHistory
        ItemDelegate
        {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 27 * pt

            Text
            {
                id: timeExchangeHistory
                text: time
                color: currTheme.textColor
                font.family:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 8 * pt
                width: 87 * pt
            }

            Text
            {
                id: statusExchangeHistory
                text: status
                color:
                {
                    if(status === "Buy")
                        return "#4B8BEB"
                    else
                        return "#6F9F00"
                }
                font.family:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular10
                anchors.left: timeExchangeHistory.right
                anchors.leftMargin: 20 * pt
                anchors.top: parent.top
                anchors.topMargin: 8 * pt
                width: 42 * pt
            }

            Text
            {
                id: priceExchangeHistory
                text: price
                color: currTheme.textColor
                font.family:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular11
                anchors.left: statusExchangeHistory.right
                anchors.leftMargin: 20 * pt
                anchors.top: parent.top
                anchors.topMargin: 8 * pt
                width: 104 * pt
            }

            Text
            {
                id: tokenExchangeHistory
                text: token
                color: currTheme.textColor
                font.family:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular11
                anchors.left: priceExchangeHistory.right
                anchors.leftMargin: 20 * pt
                anchors.top: parent.top
                anchors.topMargin: 8 * pt
                width: 117 * pt
            }

            Rectangle
            {
                id:lineBottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1 * pt
                visible:
                {
                    if(index < modelExchangeHistory.count - 1)
                        return true;
                    else
                        return false;
                }
                color: currTheme.lineSeparatorColor
            }
        }
    }

    Connections
    {
        target: dapHistoryButton
        onClicked:
        {
            if(dapListHistoryVisible)
            {
                dapListHistoryVisible = false
                dapIconHistoryButton = "qrc:/resources/icons/ic_chevron_down.png"
            }
            else
            {
                dapListHistoryVisible = true
                dapIconHistoryButton = "qrc:/resources/icons/ic_chevron_up.png"
            }
        }
    }
}
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
