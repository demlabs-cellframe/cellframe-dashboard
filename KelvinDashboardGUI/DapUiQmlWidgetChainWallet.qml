import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls.Styles 1.4
import Qt.labs.platform 1.0
import KelvinDashboard 1.0

DapUiQmlWidgetChainWalletForm {
    id: dapQmlWidgetChainWallet
    
    property int indexWallet: -1
    property string nameWallet: ""
    
    listViewWallet.highlight:
        Component
        {
            Rectangle {
                id: rectangleMenu
                color: "#121B28"
                Rectangle
                {
                    height: rectangleMenu.height
                    width: 4
                    color: "green"
                }
            }
        }
    
    
    
    
    
    listViewTokens.onCurrentItemChanged:
    {
        updateBalanceText();
        console.log(textBalance.text);
    }

    buttonSaveWallet.onClicked: {
        dialogAddWallet.show()
    }
    
    buttonDeleteWallet.onClicked: {
        dialogRemoveWallet.show()
    }
    
    buttonSendToken.onClicked: {
        dialogSendToken.show()
    }

    listViewWallet.onCurrentItemChanged:
    {
//        listViewTokens.model = listViewWallet.model.get(listViewWallet.currentIndex).tokens
        
        if(listViewWallet.currentIndex >= 0)
        {
            indexWallet = listViewWallet.currentIndex
            nameWallet = listViewWallet.model.get(listViewWallet.currentIndex).name
            console.log("++++++" + indexWallet)
        }
        else
        {
            listViewWallet.currentIndex = 0
        }
        
//        updateBalanceText();
//        addressWallet.text = listViewWallet.model.get(listViewWallet.currentIndex).address
    }
}
