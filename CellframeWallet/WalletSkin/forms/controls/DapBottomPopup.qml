import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5

Item{
    id: root

    property string nameWall: ""
    property bool expiresWallet: false
    property bool isWalletActivate: false

    property bool isActive: false
    property alias stack: stack

    enabled: isActive

    signal closed()
    signal activatingSignal(var nameWallet, var statusRequest)
    signal deactivatingSignal(var nameWallet, var statusRequest)

    Rectangle{

        id: hideFrame
        anchors.fill: parent
        color:currTheme.mainBackground
        opacity: 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                id: opacityAnim
                duration: 200
            }
        }

        MouseArea{
            enabled: isActive
            anchors.fill: parent
            hoverEnabled: true
            onWheel: {}
            onClicked: {
                hide()
            }
        }
    }

    StackView{
        property int lastIndex: depth-1
        id: stack

        anchors.fill: parent
        enabled: isActive
        hoverEnabled: false

        clip: true

        // ANIMATION NOT WORK
        pushExit: Transition {
            id: pushExit
            PropertyAnimation {
                property: "y"
                easing.type: Easing.Linear
                from: 0
                to: height
                duration: 350
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "y"
                easing.type: Easing.Linear
                from: height
                to: 0
                duration: 350
            }
        }

        pushEnter: Transition {
            PropertyAnimation {
                property: "y"
                easing.type: Easing.Linear
                from: height
                to: 0
                duration: 350
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "y"
                from: 0
                to: height
                duration: 350
            }
        }
    }

    function hide()
    {
        isActive = false
        hideFrame.opacity = 0
        stack.clear()
        nameWall = ""
        expiresWallet = ""
        isWalletActivate = false
        closed()
    }

    function show(element)
    {
        isActive = true
        hideFrame.opacity = 0.3
        stack.push(element)
    }

    function push(element)
    {
        stack.push(element)
    }

    function pop()
    {
        stack.pop()
    }

    function showActivateWallet(walletName, expires)
    {
        isActive = true
        isWalletActivate = true
        nameWall = walletName
        expiresWallet = expires
        show("qrc:/walletSkin/forms/controls/DapActivateWalletPopup.qml")
    }

    function showDeactivateWallet(walletName)
    {
        isActive = true
        isWalletActivate = true
        nameWall = walletName
        show("qrc:/walletSkin/forms/controls/DapDeactivateWalletPopup.qml")
    }
}
