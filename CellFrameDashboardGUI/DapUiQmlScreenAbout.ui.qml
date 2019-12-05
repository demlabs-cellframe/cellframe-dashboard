import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0

Page {
    id: dapUiQmlScreenAbout
    
    property alias textTitle: textTitle
    property alias textAbout: textAbout
    property alias textVersion: textVersion
    property alias textYear: textYear
    
    title: qsTr("About")
    
    ColumnLayout {
        id: columnScreenLogin
        width: parent.width
        anchors.centerIn: parent
        clip: true
        
        RowLayout {
            id: rowAboutInformation
            spacing: 15
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 20
            
            Image {
                id: name
                source: "qrc:/Resources/Icons/icon.png"
                scale: 2
                Layout.alignment: Qt.AlignHCenter
            }
            
            ColumnLayout {
                id: columnText
                
                Text {
                    id: textTitle
                    width: parent.width
                    font.pointSize: 14
                    font.bold: true
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Text {
                    id: textAbout
                    width: parent.width
                    font.pointSize: 12
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
        
        Text {
            id: textVersion
            width: parent.width
            font.pointSize: 10
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
        
        Text {
            id: textYear
            width: parent.width
            font.pointSize: 10
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
    }
    
}
