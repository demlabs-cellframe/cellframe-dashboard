   import QtQuick 2.8
   
//    Component{
//        id: default_head_property
        Rectangle{
            height: 20
            border.color: "#aeaeae"
            color: "#e6e6e6"
            border.width: 1
            Text {
                text: styleData.value
                width: parent.width
                height: parent.height
                font.pointSize: 18
                minimumPointSize: 3
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
        }
//    }