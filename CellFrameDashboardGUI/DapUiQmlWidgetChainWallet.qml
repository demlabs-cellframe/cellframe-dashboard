import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls.Styles 1.4
import Qt.labs.platform 1.0
import CellFrameDashboard 1.0

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

    listViewWallet.onCurrentItemChanged:
    {
        listViewTokens.model.clear()
        for(var i = 0; i < listViewWallet.model.get(listViewWallet.currentIndex).count; i++)
        {
            var value = listViewWallet.model.get(listViewWallet.currentIndex).balance[i]
            listViewTokens.model.append({token: listViewWallet.model.get(listViewWallet.currentIndex).tokens[i], balance: value.replace(/[^\d.-]/g, '')});
        }

        if(listViewWallet.currentIndex >= 0)
        {
            indexWallet = listViewWallet.currentIndex
            nameWallet = listViewWallet.model.get(listViewWallet.currentIndex).name
        }
        else
        {
            listViewWallet.currentIndex = 0
        }
        
        addressWallet.text = listViewWallet.model.get(listViewWallet.currentIndex).address
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
}
