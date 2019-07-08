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

        addressWallet.text = listViewWallet.model.get(listViewWallet.currentIndex).address
    }

    buttonSaveWallet.onClicked: {
        dialogAddWallet.show()
    }
    buttonSendToken.onClicked: {
        dialogSendToken.show()
    }
}
