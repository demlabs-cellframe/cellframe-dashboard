import QtQuick 2.4
import "qrc:/"
import "../../"

DapAbstractTab
{
    id: settingsTab

    dapTopPanel: DapSettingsTopPanel { }

    dapScreen: DapSettingsScreen { }

    dapRightPanel: DapSettingsRightPanel { }
}
