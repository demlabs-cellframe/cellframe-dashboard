import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item {
    property string nameWallet: ""
    property bool isMigrate: false

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
        height: isMigrate ? 180 + migrateMsg.height + 16 : 180
        // height: 280
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

        ColumnLayout
        {
            id: layout
            anchors.fill: parent
//            spacing: 0
            Text
            {
                Layout.leftMargin: 40
                Layout.rightMargin: 40
                Layout.topMargin: 24
                Layout.fillWidth: true
                height: 36
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Are you sure you would like to delete this wallet?")
                font: mainFont.dapFont.bold14
                lineHeightMode: Text.FixedHeight
                lineHeight: 17.5
                color: currTheme.white
                wrapMode: Text.WordWrap
            }

            Text
            {
                id: migrateMsg
                visible: isMigrate
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 16
                Layout.fillWidth: true
                height: 36
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("When the Wallet is restarted, this wallet will be re-ported from the cellframe node.")
                font: mainFont.dapFont.medium12
                lineHeightMode: Text.FixedHeight
                lineHeight: 17.5
                color: currTheme.orange
                wrapMode: Text.WordWrap
            }

            RowLayout {
                Layout.fillWidth: true
                height: 60
                Layout.topMargin: 3
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                spacing: 6

                Image
                {
                    id: checkBox
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
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
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    font: mainFont.dapFont.regular12
                    color: currTheme.white
                    text: qsTr("I am sure that I want to delete this wallet")
                    wrapMode: Text.WordWrap

                    MouseArea{
                        anchors.fill: parent
                        onClicked: checkBox.isChecked = !checkBox.isChecked
                    }
                }
            }

            DapButton
            {
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.bottomMargin: 24

                Layout.fillWidth: true
                implicitHeight: 36
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

    function show(name_wallet, is_Migrate) {
        checkBox.isChecked = false
        visible = true
        nameWallet = name_wallet
        isMigrate = is_Migrate
        backgroundFrame.opacity = 0.4
        frameRemoveDialog.opacity = 1
    }
}
