import QtQuick 2.12
import QtQuick.Controls 2.5

StackView {
    id: stackView
//    initialItem: "qrc:/Home.qml"

    function clearAll()
    {
        stackView.clear()
        stackView.push(initialItem)
    }

    function setInitialItem(item)
    {
        stackView.initialItem = item
        stackView.clear(StackView.ReplaceTransition)
        stackView.push(item)
    }
}
