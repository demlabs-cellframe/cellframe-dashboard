import QtQuick 2.14
import QtQuick.Controls 2.14

StackView {
    id: stackView
//    initialItem: "qrc:/walletSkin/Home.qml"
    hoverEnabled: false

    property bool isDappLoad: false
    property string currentTitle: ""

    Page{id: empty; title:""; background: Rectangle{color: currTheme.mainBackground}}

    pushEnter: Transition {
             PropertyAnimation {
                 property: "opacity"
                 from: 0
                 to:1
                 duration: 300
             }
         }
         pushExit: Transition {
             PropertyAnimation {
                 property: "opacity"
                 from: 1
                 to:0
                 duration: 300
             }
         }
         popEnter: Transition {
             PropertyAnimation {
                 property: "opacity"
                 from: 0
                 to:1
                 duration: 300
             }
         }
         popExit: Transition {
             PropertyAnimation {
                 property: "opacity"
                 from: 1
                 to:0
                 duration: 300
             }
         }

    Connections{
        target: translator
        function onLanguageChanged()
        {
            console.log("MainStackView",
                        "onLanguageChanged")
            currentTitle = typeof(stackView.currentItem.title) === "undefined" ? "" : stackView.currentItem.title
        }
    }

    function clearAll()
    {
        stackView.clear()
        stackView.push(initialItem)
        headerWindow.background.visible = true
//        walletNameLabel.visible = true
    }

    function setInitialItem(item)
    {
        logicMainApp.currentPage = item
        stackView.initialItem = item
//        stackView.pop()
        stackView.clear(StackView.popTransition)
        stackView.push(empty)
        stackView.push(item)
        currentTitle = typeof(stackView.currentItem.title) === "undefined" ? "" : stackView.currentItem.title
    }
}
