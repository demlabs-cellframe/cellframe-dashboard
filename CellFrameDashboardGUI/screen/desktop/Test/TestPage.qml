import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
//import "qrc:/"
//import "../../"
import "../"
//import "qrc:/widgets"
import "qrc:/screen/controls" as Controls

Controls.DapPage {

    QtObject {
        id: navigator

        function openPage2() {
            dapRightPanel.push("qrc:/screen/desktop/TestPageForRightPannel2.qml")
        }
    }

    dapHeader.initialItem: TestPageForTopPanel { }

    dapScreen.initialItem: TestScreen { }

    dapRightPanel.initialItem: TestPageForRightPannel { }
}
