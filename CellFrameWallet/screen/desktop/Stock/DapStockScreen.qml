import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "parts"
import "parts/Chart"

Page
{
    id: mainStockScreen

    Component.onCompleted:
    {
        changeMainPage("parts/StockHome.qml")
    }

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    StackView {
        id: mainStackView
        anchors.fill: parent

        clip: true
    }


    function changeMainPage(page)
    {
        mainStackView.clear()
        mainStackView.push(page)
    }
}

