import QtQuick 2.12
import QtQuick.Controls 2.5

StackView {
    id: stackView

    function clearAll()
    {
        stackView.clear()
        stackView.push(initialItem)
        headerWindow.background.visible = true
        walletNameLabel.visible = true
    }

    function setInitialItem(item)
    {
        stackView.initialItem = item
        stackView.clear(StackView.ReplaceTransition)
        stackView.push(item)
    }
}
