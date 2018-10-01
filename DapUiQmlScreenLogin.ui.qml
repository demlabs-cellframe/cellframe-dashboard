import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: dapUiQmlScreenLogin
    
    title: qsTr("Login")
    
    
    Column {
        anchors.centerIn: parent
        spacing: 10
        
        TextField {
            id: textFieldPassword
            placeholderText: "Password"
            echoMode: TextInput.Password
        }
        
        Button {
            text: "Log in"
            width: textFieldPassword.width
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    
}
