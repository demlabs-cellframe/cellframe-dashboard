import QtQuick 2.4
import "qrc:/"
import "../../"

DapAbstractTab
{
    id: historyTab

    dapTopPanel: DapSettingsTopPanel { }

    dapScreen: DapSettingsScreen { }

    dapRightPanel: DapSettingsRightPanel { }
}
