import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item {
    property string nameWallet: ""

    Rectangle
    {
        id: backgroundFrame
        anchors.fill: parent
        visible: opacity
        color: currTheme.popup
        opacity: 0.0

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onClicked: hide()
        }

        Behavior on opacity {NumberAnimation{duration: 100}}
    }

    Rectangle
    {
        id: frameRemoveDialog
        anchors.centerIn: parent
        visible: opacity
        opacity: 0

        Behavior on opacity {NumberAnimation{duration: 200}}

        width: 328
        height: 180
        color: currTheme.popup
        radius: currTheme.popupRadius

        MouseArea
        {
            anchors.fill: parent
        }

        HeaderButtonForRightPanels{
            id: closeButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 9
            anchors.rightMargin: 10
            height: 20
            width: 20
            heightImage: 20
            widthImage: 20
            normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
            hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
            onClicked: hide()
        }

        Item
        {
            anchors.fill: parent
//            spacing: 0

            Item {
                id: titleBlock
                width: parent.width - 80
                height: 36
                anchors.leftMargin: 40
                anchors.rightMargin: 40
                anchors.topMargin: 24
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                Text
                {
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Are you sure you would like to delete this wallet?")
                    font: mainFont.dapFont.bold14
                    lineHeightMode: Text.FixedHeight
                    lineHeight: 17.5
                    color: currTheme.white
                    wrapMode: Text.WordWrap
                }
            }

            Item {
                width: parent.width
                height: 60
                anchors.topMargin: 3
                anchors.top: titleBlock.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                Image
                {
                    id: checkBox
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    sourceSize.width: 46
                    sourceSize.height: 46
                    property bool isChecked: false
                    source: isChecked ? "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_on.png"
                                      : "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_off.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: checkBox.isChecked = !checkBox.isChecked
                    }
                }

                Text
                {
                    id: warningText
                    width: parent.width
                    font: mainFont.dapFont.regular12
                    color: currTheme.white
                    text: qsTr("I am sure that I want to delete this wallet")
                    wrapMode: Text.WordWrap
                    x: 55
                    y: 14

                    MouseArea{
                        anchors.fill: parent
                        onClicked: checkBox.isChecked = !checkBox.isChecked
                    }
                }
            }

            Item {
                width: parent.width - 48
                height: 36
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                anchors.bottomMargin: 24
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                DapButton
                {
                    width: parent.width
                    height: parent.height
                    textButton: qsTr("Delete wallet")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.regular14
                    enabled: checkBox.isChecked
                    onClicked:
                    {
                        walletModule.removeWallet([nameWallet]);
                        walletModule.updateWalletList()
                        hide()
//                        walletsControllerPopup.show()
                    }
                }
            }
        }
    }

    InnerShadow
    {
        anchors.fill: frameRemoveDialog
        source: frameRemoveDialog
        color: currTheme.reflection
        horizontalOffset: 1
        verticalOffset: 1
        radius: 0
        samples: 10
        opacity: frameRemoveDialog.opacity
        fast: true
        cached: true
    }
    DropShadow
    {
        anchors.fill: frameRemoveDialog
        source: frameRemoveDialog
        color: currTheme.shadowMain
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 20
        opacity: frameRemoveDialog.opacity ? 0.42 : 0
        cached: true
    }

    function hide() {
        backgroundFrame.opacity = 0.0
        frameRemoveDialog.opacity = 0.0
        visible = false
        walletsControllerPopup.show()
    }

    function show(name_wallet) {
        checkBox.isChecked = false
        visible = true
        nameWallet = name_wallet
        backgroundFrame.opacity = 0.4
        frameRemoveDialog.opacity = 1
    }
}
