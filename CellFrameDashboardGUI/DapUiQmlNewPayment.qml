import QtQuick 2.12
import CellFrameDashboard 1.0

DapUiQmlNewPaymentForm {
    amountText.onTextChanged: convertedAmmount = Number(amountText.text.valueOf()) * 20
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
