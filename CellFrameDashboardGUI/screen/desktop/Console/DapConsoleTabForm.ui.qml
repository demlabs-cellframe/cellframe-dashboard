import QtQuick 2.4
import "qrc:/"
import "../../"

DapAbstractTab
{
    id: consoleTab

    dapTopPanel: DapConsoleTopPanel { }

    dapScreen: DapConsoleScreen { }

    dapRightPanel: DapConsoleRightPanel { }
}
