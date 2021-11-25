import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../"
import "qrc:/widgets"

DapAbstractTab {
    id :testPageTab
    color: currTheme.backgroundMainScreen

    dapTopPanel:Item{}
    dapRightPanel: Item{}

    dapScreen:DapPluginsScreen{}
}
