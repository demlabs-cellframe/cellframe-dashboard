import QtQuick 2.0
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Window 2.15
import Qt.labs.settings 1.0
//import Scaling 1.0

import "Resources/theme"
import "qrc:/resources/QML"
import "forms"

ApplicationWindow
{
    id: window

    property string pathForms: "qrc:/walletSkin/forms/"
    property string pathTheme: currThemeVal ? "BlackTheme" : "LightTheme"
    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme
    property alias mainFont: quicksandFonts
    property alias mainWindow : mainWindow
    property real mainWindowScale: systemFrameContent.scale
    property var framerect: app
    property alias frameMainWindow: systemFrameContent

//    property bool isMobile: true

    MainLogic{ id: params}
    Black {id: darkTheme}
    Light {id: lightTheme}
    DapFontQuicksand { id: quicksandFonts}


    readonly property int testNewCoordinate: -1000

    Settings {id: settings}

    width: 640
    height: 480
    visible: true

    color: darkTheme.mainBackground

    SystemFrameComponent
    {
        id: systemFrameContent
        anchors.fill: parent

        header.enabled: false

        dataItem: DapMainApplicationWindow
        {
            id: mainWindow
            anchors.fill: parent
        }
    }


//    Rectangle {
//        color: "#00000000"
//        width: 300
//        height: 40
//        anchors.fill: parent

//        Row {
//            anchors.centerIn: parent
//            spacing: 10

//            Text {
//                id: textTitle
//                text: "Text Field: "
//                width: 100
//                height: 100
//                color: "black"
//                font.pixelSize: 40
//                horizontalAlignment: Text.AlignRight
//                verticalAlignment: Text.AlignVCenter
//            }

//            TextField {
//                id: textField

//                width: 300
//                height: 100
//                text: ""
//                font.pixelSize: 40
//                placeholderText: qsTr("Enter Your Text")
//                onEditingFinished: {
//                    console.log("Text entered: ", textField.text)
//                }
//            }
//        }
//    }

    onClosing: {
        console.log("onClosing")

        close.accepted = false
        Qt.quit()
    }

    Component.onCompleted: {
        window.showMaximized()
//        Scaling.getNativDPI()
    }
}
