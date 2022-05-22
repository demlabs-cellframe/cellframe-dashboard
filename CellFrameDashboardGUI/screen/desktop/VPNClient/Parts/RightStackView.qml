import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    id: rightStackView
    width: 300

    StackView {
        id: stackView
        anchors.fill: parent
        clip: true
    }

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

    color: "dark blue"
}

