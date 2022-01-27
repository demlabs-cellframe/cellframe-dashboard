import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import "../screen"
import "qrc:/resources/QML"
import "../screen/controls"
import "../resources/theme"

FocusScope {
    Button {
        id: btn
        width: 100
        height: 100
        anchors.centerIn: parent
        text: "TEST"
        onClicked: {
            console.log("PRESSED")
            app.startService()
        }
    }
}
