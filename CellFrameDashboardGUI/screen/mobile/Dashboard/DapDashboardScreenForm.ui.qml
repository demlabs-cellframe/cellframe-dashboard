import QtQuick 2.4
import "../../"

DapAbstractScreen {
    frame.height: parent.height
    frame.color: "blue"

//    textTest.text: "Here text"

    Item{
        id: dapButtonTest
        data: buttonTest
        width: 500
        height: 500
        anchors.centerIn: parent
    }

    Item {
        id: dapTextTest
        data: textTest

        anchors.bottom: dapButtonTest.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
