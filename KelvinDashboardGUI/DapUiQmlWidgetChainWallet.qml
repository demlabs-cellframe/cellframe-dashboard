import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
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
        console.log(listViewWallet.currentIndex)

    save.onClicked: {
        dialogAddWallet.show()
}


}
