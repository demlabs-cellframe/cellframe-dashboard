import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.4
import "qrc:/widgets"

Item
{
    id: root
    width: 278
    height: 82

    property real currentValue: 0.01
    property real spinBoxStep: 0.01
    property real minValue: 0.00

    property string valueName: "-"
    property int powerRound: 2

    property color currentColor: "#CAFC33"
    property string currentState: "Recommended"

    ListModel
    {
        id: statesData
    }

    Component.onCompleted: setUp()

    property var rangeValues:
    {
        "min": 0.003,
        "low": 0.004,
        "middle": 0.005,
        "high": 0.006,
        "veryHigh": 0.007,
        "max": 0.008
    }

    // Custom SpinBox
    Item
    {
        id: feeSpinbox
        width: parent.width
        height: 40
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        // Minus
        Rectangle
        {
            width: 40

            anchors.right: valueField.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 14

            radius: 4
            color: minusArea.containsMouse ? currTheme.inputActive : currTheme.input

            Rectangle
            {
                height: 2
                width: 14
                border.width: 2
                border.color: currTheme.white
                anchors.centerIn: parent
            }

            MouseArea
            {
                id: minusArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    if (currentValue >= minValue + spinBoxStep)
                    {
                        setValue(currentValue - spinBoxStep)
                    }
                }
            }
        }

        // Spin value
        Rectangle
        {
            id: valueField
            width: 170

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            color: currTheme.secondaryBackground
            border.width: 1
            border.color: currTheme.input
            radius: 4

            Item
            {
                id: inputValueItem

                implicitWidth: valueText.width + valueNameText.width > valueField.width ? valueField.width : valueText.width + valueNameText.width

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 1
                anchors.bottomMargin: 1
                anchors.leftMargin: 8
                anchors.rightMargin: 8

                // color: "transparent"
                // border.width: 1
                // border.color: "red"

                TextField
                {
                    id: valueText
                    width: textMetrics.width
                    height: parent.height
                    //anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    text: currentValue
                    color: currTheme.white
                    font: mainFont.dapFont.regular16
                    placeholderText: "0.0"
                    horizontalAlignment: Text.AlignRight

                    background:
                        Rectangle
                    {
                        color: valueField.color
                        //color: "pink"
                        //radius: valueField.radius
                    }

                    validator: RegExpValidator { regExp: /[0-9\.]+/ }

                    selectByMouse: true

                    onTextChanged:
                    {
                        var number = parseFloat(text)
                        if(!isNaN(number))
                            setValue(number)

                        textMetrics.text = text
                        valueText.width = textMetrics.width + 16
                    }

                    TextMetrics
                    {
                        id: textMetrics
                        font: valueText.font
                        text: valueText.text
                    }

                }

                Text
                {
                    id: valueNameText
                    width: contentWidth
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignLeft
                    text: valueName
                    font: mainFont.dapFont.regular16
                    color: currTheme.white
                }
            }
        }


        // Plus
        Rectangle
        {
            width: 40

            anchors.left: valueField.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 14

            radius: 4
            color: plusArea.containsMouse ? currTheme.inputActive : currTheme.input

            Rectangle
            {
                width: 14
                height: 2
                border.width: 2
                border.color: currTheme.white
                anchors.centerIn: parent
            }

            Rectangle
            {
                width: 2
                height: 14
                border.width: 2
                border.color: currTheme.white
                anchors.centerIn: parent
            }

            MouseArea
            {
                id: plusArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    setValue(currentValue + spinBoxStep)
                }
            }
        }
    }

    RowLayout
    {
        id: colorRect
        width: 278
        height: 4

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: feeSpinbox.bottom
        anchors.topMargin: 12

        spacing: 5

        Repeater
        {
            model: statesData

            delegate:
                Rectangle
            {
                width: 52
                Layout.fillHeight: true
                radius: 12
                color: model.enabled ? currentColor : "#666E7D"

                Behavior on color
                {
                    PropertyAnimation{duration: 150}
                }

                MouseArea
                {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: setValue(model.minValue)
                }
            }
        }
    }

    Text
    {
        id: textState
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: colorRect.bottom
        anchors.topMargin: 8
        text: currentState
        color: currentColor

        Behavior on color{
            PropertyAnimation{duration: 150}
        }
    }

    function setValue(value)
    {
        currentValue = value.toFixed(powerRound)
        updateState()
    }

    function updateState()
    {
        if(currentValue < minValue)
            return

        var checkSearch = false
        var idxSearch = -1

        for(var i = statesData.count -1; i >= 0; i--)
        {
            statesData.get(i).enabled = checkSearch

            if(statesData.get(i).minValue > currentValue || checkSearch)
                continue;

            idxSearch = i
            checkSearch = true
            currentState = statesData.get(i).name
            statesData.get(i).enabled = true
        }

        if(currentState === "Very low")
            currentColor = "#FF5F5F"
        else if(currentState === "Low")
            currentColor = "#FFCD44"
        else if(currentState === "Recommended")
            currentColor = "#CAFC33"
        else if(currentState === "High")
            currentColor = "#79FFFA"
        else if(currentState === "Very high")
            currentColor = "#9580FF"
    }

    function checkRanges(ranges)
    {
        if(ranges.min > ranges.low) return false
        if(ranges.low > ranges.middle) return false
        if(ranges.middle > ranges.high) return false
        if(ranges.high > ranges.veryHigh) return false
        if(ranges.veryHigh > ranges.max) return false
        return true
    }

    function setUp()
    {
        if(initStates(rangeValues))
        {
            setValue(rangeValues.middle)
        }
    }

    function initStates(rcvData)
    {
        if(!checkRanges(rcvData))
            return false

        statesData.clear()
        //very low range
        statesData.append(
                    {
                        name: "Very low",
                        minValue: rcvData.min,
                        maxValue: rcvData.low,
                        enabled: false
                    })

        //low range
        statesData.append(
                    {
                        name: "Low",
                        minValue: rcvData.low,
                        maxValue: rcvData.middle,
                        enabled: false
                    })

        //recomemnded range
        statesData.append(
                    {
                        name: "Recommended",
                        minValue: rcvData.middle,
                        maxValue: rcvData.high,
                        enabled: false
                    })

        //high range
        statesData.append(
                    {
                        name: "High",
                        minValue: rcvData.high,
                        maxValue: rcvData.veryHigh,
                        enabled: false
                    })

        //very high range
        statesData.append(
                    {
                        name: "Very high",
                        minValue: rcvData.veryHigh,
                        maxValue: rcvData.max,
                        enabled: false
                    })

        return true
    }
}
