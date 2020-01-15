import QtQuick 2.4
import "qrc:/"
import "../../"

DapAbstractTab
{
    id: logsTab

    dapTopPanel: DapLogsTopPanel { }

    dapScreen: DapLogsScreen { }

    dapRightPanel: DapLogsRightPanel { }
}
