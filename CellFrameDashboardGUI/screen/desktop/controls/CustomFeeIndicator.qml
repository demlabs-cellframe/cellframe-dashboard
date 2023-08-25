import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.4

ColumnLayout {
    id: root
    spacing: 8

    property color currentColor: currTheme.lightGreen
    property string currentState: "Recommended"

    property var feeData:
    {
        "currentValue": 0.0,
        "minValue": 0.0,
        "maxValue": 0.0,
        "recommendedValue": 0.0
    }

    ListModel{
        id: statesData
    }

//    signal sigSetValue(var value)

     RowLayout{
         Layout.alignment: Qt.AlignHCenter
         height: 4
         spacing: 5

         Repeater{
             model: statesData

             delegate: Rectangle{
                 width: 52
                 Layout.fillHeight: true
                 radius: 12
                 color: model.enabled ? currentColor : currTheme.input

//                 MouseArea{
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     onClicked: sigSetValue(model.minValue)
//                 }

                 Behavior on color{
                     PropertyAnimation{duration: 150}
                 }
             }
         }
     }

     Text{
         Layout.alignment: Qt.AlignHCenter
         horizontalAlignment: Text.AlignHCenter
         text: currentState
         font: mainFont.dapFont.medium13
         color: currentColor

         Behavior on color{
             PropertyAnimation{duration: 150}
         }
     }

     function setFeeValues(rcvData)
     {
        if(feeData === rcvData)
            return

        if(feeData.currentValue !== rcvData.currentValue &&
           feeData.minValue === feeData.minValue &&
           feeData.maxValue === feeData.maxValue &&
           feeData.recommendedValue === feeData.recommendedValue)

            updateIndicatorValue(rcvData)
        else
            updateStateData(rcvData)

        feeData = rcvData
     }

     function updateIndicatorValue(rcvData)
     {
         if(!statesData.count)
             return

         var checkSearch = false
         var idxSearch = -1
//         console.log(statesData.count)

         for(var i = statesData.count -1; i >= 0; i--)
         {
//             console.log("idx fee", i)
             statesData.get(i).enabled = false

             if(statesData.get(i).minValue > rcvData.currentValue)
                 continue;
             else if (statesData.get(i).minValue <= rcvData.currentValue && statesData.get(i).maxValue >= rcvData.currentValue && !checkSearch)
             {
                 idxSearch = i
                 checkSearch = true
                 currentState = statesData.get(i).name
             }

             if(checkSearch)
                 statesData.get(i).enabled = true
         }
//         console.log(statesData.get(idxSearch), currentState, checkSearch, idxSearch)

         if(currentState === "Very low")
             currentColor = currTheme.red
         else if(currentState === "Low")
             currentColor = currTheme.orange
         else if(currentState === "Recommended")
             currentColor = currTheme.lightGreen
         else if(currentState === "High")
             currentColor = currTheme.neon
         else if(currentState === "Very high")
             currentColor = currTheme.mainButtonColorNormal1
     }

     function updateStateData(rcvData)
     {

         var minValue = rcvData.minValue
         var maxValue = rcvData.maxValue
         var recommendedValue = rcvData.recommendedValue

         statesData.clear()

         //very low range
         statesData.append(
         {
             name: "Very low",
             minValue: minValue,
             maxValue: ((recommendedValue - minValue)/2) + minValue,
             enabled: false
         })

         //low range
         statesData.append(
         {
             name: "Low",
             minValue: ((recommendedValue - minValue)/2) + minValue,
             maxValue: recommendedValue,
             enabled: false
         })

         //recomemnded range
         statesData.append(
         {
              name: "Recommended",
              minValue: recommendedValue,
              maxValue: recommendedValue + recommendedValue * 0.1,
              enabled: false
         })

         //high range
         statesData.append(
         {
              name: "High",
              minValue: recommendedValue + recommendedValue * 0.1,
              maxValue: ((maxValue - recommendedValue)/2) + recommendedValue,
              enabled: false
         })

         //very high range
         statesData.append(
         {
              name: "Very high",
              minValue: ((maxValue - recommendedValue)/2) + recommendedValue,
              maxValue: maxValue,
              enabled: false
         })

         for(var i = 0; i < statesData.count; i++)
         {
             print("=====================")
             print(statesData.get(i).name)
             print(statesData.get(i).minValue)
             print(statesData.get(i).maxValue)
             print(minValue)
             print(maxValue)
             print(recommendedValue)
             print("----------------------")

         }

         updateIndicatorValue(rcvData)
     }
}
