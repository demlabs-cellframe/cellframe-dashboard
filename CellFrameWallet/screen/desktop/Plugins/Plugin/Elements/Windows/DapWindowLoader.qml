import QtQuick 2.2
import QtQml 2.12
import QtQuick.Controls 2.12

Popup {

    id: dialog
    property alias source:loader.source

    scale: mainWindow.scale

    width: 700 * mainWindow.scale
    height: 600 * mainWindow.scale
    parent: Overlay.overlay
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    
    modal: true
    
    contentItem: 
    	Loader{
            id: loader
	    anchors.fill: parent
    	    }
    	
    background:
        Rectangle
    	{
    	    anchors.fill: parent
            color: "transparent"
            radius: 16 
        }
}

