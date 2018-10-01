import QtQuick 2.0
import KelvinDashboard 1.0

DapUiQmlScreenLogin {
   id: dapQmlScreenLogin 
   
   function acceptPassword()
   {
       dapScreenLogin.Password = textFieldPassword.text
       DapClient.authorization(textFieldPassword.text)
       console.log(textFieldPassword.text)
   }
   
   Connections {
       target: dapClient
       
       onIsAuthorizationChanged: {
           console.log("PARAM " + isAuthorization)
           textStatus.visible = true
           if(isAuthorization)
           {
               textStatus.text = "Password confirmed"
               textStatus.color = "green"
               textFieldPassword.color = "green"
           }
           else
           {
               textStatus.text = "Password not verified"
               textStatus.color = "red"
               textFieldPassword.color = "red"
           }
       }
   }
   
   buttonPassword.onClicked: acceptPassword()
}
