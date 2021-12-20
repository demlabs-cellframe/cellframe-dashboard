import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"

DapAbstractTab {

    color: currTheme.backgroundMainScreen

    dapTopPanel: DapAppsTopPanel{color: currTheme.backgroundPanel}

    dapScreen: DapAppsScreen{}

    dapRightPanel: Item{}

}
