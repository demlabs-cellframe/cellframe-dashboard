import QtQuick 2.0

ListView {

    model: dapConsoleController
    delegate: Text {
        text: lastCommand
        color: "#000000";
        font.pixelSize: 20 * pt
    }

}
