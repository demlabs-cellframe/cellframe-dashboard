import QtQuick 2.12
import CellFrameDashboard 1.0

DapUiQmlNewPaymentForm {
    amountText.onTextChanged: translatedText = Number(amountText.text.valueOf()) * 20
}
