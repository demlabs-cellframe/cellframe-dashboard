import QtQuick 2.9
import QtQuick.Controls 2.2
import KelvinDashboard 1.0

Page {
    id: dapUiQmlScreenLogin
    
    property alias dapScreenLogin: dapScreenLogin
    property alias textFieldPassword: textFieldPassword
    property alias buttonPassword: buttonPassword
    property alias textStatus: textStatus
    
    title: qsTr("Login")
    
    DapScreenLogin
    {
        id: dapScreenLogin
    }
    
    Column {
        id: columnScreenLogin
        width: parent.width
        anchors.centerIn: parent
        spacing: 10
        clip: true
        
        TextField {
            id: textFieldPassword
            placeholderText: "Password"
            echoMode: TextInput.Password
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Text {
            id: textStatus
            width: parent.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
        }
        
        Button {
            id: buttonPassword
            text: "Log in"
            width: textFieldPassword.width
            anchors.horizontalCenter: parent.horizontalCenter
            focus: true
        }
    }
    
}
