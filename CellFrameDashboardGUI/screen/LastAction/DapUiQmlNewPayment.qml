import QtQuick 2.0

DapUiQmlNewPaymentForm {
    amountText.onTextChanged: convertedAmmount = Number(amountText.text.valueOf()) * 20

    Connections {
        target: pressedSendButton
        onPressedSendButtonChanged: {
            rightPanel.header.pop()
            rightPanel.content.pop()
            rightPanel.header.push("DapUiQmlStatusNewPaymentHeader.qml", {"rightPanel": rightPanel });
            rightPanel.content.push("DapUiQmlStatusNewPayment.qml", {"rightPanel": rightPanel} )
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
