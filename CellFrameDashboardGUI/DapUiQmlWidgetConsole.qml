import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls.Styles 1.4
import Qt.labs.platform 1.0
import CellFrameDashboard 1.0


DapUiQmlWidgetConsoleForm {
    id: dapQmlWidgetConsole
    execute.onClicked: {
        dapServiceController.executeCommand(command.text)
        execute.enabled = false;

    }
    Connections {
           target: dapServiceController
           onResultChanged: {
                command.clear()
                result.text = dapServiceController.Result
                execute.enabled = true
            }
    }

}
