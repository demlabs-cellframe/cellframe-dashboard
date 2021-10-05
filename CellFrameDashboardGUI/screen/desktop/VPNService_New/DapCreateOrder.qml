import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/widgets"

DapCreateOrderForm {
    property string dapRegionOrder
    property string dapUnitOrder
    property string dapPriceOrder

    dapComboBoxRegion.onCurrentIndexChanged:
    {
        dapRegionOrder = dapComboBoxRegion.currentIndex.toString()
    }
    dapComboBoxUnit.onCurrentIndexChanged:
    {
        dapUnitOrder = dapComboBoxUnit.currentIndex.toString()
    }
    dapComboBoxPrice.onCurrentIndexChanged:
    {
        dapPriceOrder = dapComboBoxPrice.currentIndex.toString()
    }

    dapButtonCreate.onClicked:
    {
        if (dapTextInputNameOrder.text == "")
        {
            dapOrderNameWarning.visible = true
            console.warn("Empty order name")
        }
        else
        {
            dapOrderNameWarning.visible = false
            console.log("Create new order "+dapTextInputNameOrder.text);
            console.log("Region "+dapRegionOrder);
            console.log("Unit "+dapUnitOrder);
            console.log("Price "+dapPriceOrder);
            console.log("Network "+dapServiceController.CurrentNetwork)
            dapServiceController.requestToService();
        }
    }
    dapButtonClose.onClicked:
    {
        dapOrderNameWarning.visible = false
        previousActivated(earnedFundsOrder)
//        dashboardTopPanel.dapAddWalletButton.colorBackgroundNormal = "#070023"
    }
}
