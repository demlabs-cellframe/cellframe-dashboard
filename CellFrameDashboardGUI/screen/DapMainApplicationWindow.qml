import QtQuick 2.4

DapMainApplicationWindowForm 
{
    
    menuTabWidget.onPuthScreenChanged: 
    {
        screens.setSource(Qt.resolvedUrl(menuTabWidget.c))
        var s = page
        console.log(page)
    }
}
