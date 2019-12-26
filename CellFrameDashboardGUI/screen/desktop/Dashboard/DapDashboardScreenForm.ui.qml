import QtQuick 2.4
import QtQuick.Controls 2.0
import "../../"

DapAbstractScreen {
    id: dapdashboard
    dapFrame.color: "green"
    dapFrame.height: parent.height
    textTest.text: "Here text"

    Item{
        id: dapButtonTest
        data: buttonTest
        width: 100
        height: 100
        anchors.centerIn: parent
    }

    Item {
        id: dapTextTest
        data: textTest

        anchors.top:  dapButtonTest.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
