import QtQuick 2.0

DapUiQmlScreenDialogAddWalletForm {
    id: dialogAddWallet
    focus: true

    Connections {
        target: nextButton
        onClicked: {
            if(isWordsRecoveryMethodChecked) {

                rightPanel.content.push("DapUiQmlRecoveryNotesForm.ui.qml", {"rightPanel": rightPanel});
                rightPanel.header.push("DapUiQmlScreenDialogAddWalletHeader.qml", {
                                           "backButtonNormal": "qrc:/res/icons/back_icon.png",
                                           "backButtonHovered": "qrc:/res/icons/back_icon_hover.png",
                                           "rightPanel": rightPanel
                                       });
            }
            else if(isQRCodeRecoveryMethodChecked) {
                rightPanel.content.push("DapUiQmlRecoveryQrForm.ui.qml", {"rightPanel": rightPanel});
                rightPanel.header.push("DapUiQmlScreenDialogAddWalletHeader.qml", {
                                           "backButtonNormal": "qrc:/res/icons/back_icon.png",
                                           "backButtonHovered": "qrc:/res/icons/back_icon_hover.png",
                                           "rightPanel": rightPanel
                                       });
            }
            else if(isExportToFileRecoveryMethodChecked) console.debug("Export to file"); /*TODO: create dialog select file to export */
            else {
                rightPanel.header.push("DapUiQmlWalletCreatedHeader.qml", {"rightPanel": rightPanel });
                rightPanel.content.push("DapUiQmlWalletCreated.qml", {"rightPanel": rightPanel} )
            }
        }
    }

    Connections {
        target: rightPanel.content.currentItem
        onPressedNextButtonChanged: {
            if(rightPanel.content.currentItem.isWordsCopied || rightPanel.content.currentItem.isQRCodeCopied) {
                rightPanel.header.push("DapUiQmlWalletCreatedHeader.qml", {"rightPanel": rightPanel });
                rightPanel.content.push("DapUiQmlWalletCreated.qml", {"rightPanel": rightPanel} )
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
