import QtQuick 2.2
import QtQuick.Controls 2.12

Popup {

    id: dialog
    property alias source:loader.source

    width: 700
    height: 600
    anchors.centerIn: Overlay.overlay
    
    modal: true
    
    scale: mainWindow.scale

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
            radius: 16 * pt
        }
}

