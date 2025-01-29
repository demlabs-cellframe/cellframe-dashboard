import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item {

    property string hash: ""
    property string network: ""
    property string side: ""
    property string amount: ""

    property var feeStruct:
    {
        "error": 1,
        "fee_ticker": "UNKNOWN",
        "network_fee": "0.00",
        "validator_fee": "0.00"
    }

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

    Rectangle {
        id: frameRemoveDialog
        anchors.centerIn: parent
        visible: opacity
        opacity: 0

        Behavior on opacity {NumberAnimation{duration: 200}}

        width: 328
        height: 270
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
                text: qsTr("Are you sure you would like to delete this order?")
                font: mainFont.dapFont.bold14
                lineHeightMode: Text.FixedHeight
                lineHeight: 17.5
                color: currTheme.white
                wrapMode: Text.WordWrap
            }
        }


        ColumnLayout
        {
            anchors.top: titleBlock.bottom
            anchors.bottom: buttonFrame.top
            Layout.fillWidth: true

            RowLayout{
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.topMargin: 12
                Layout.leftMargin: 54
//                anchors.margins: 32

                spacing: 0
                Text{
                    id:fee1Name
                    Layout.fillWidth: true
                    text: qsTr("Network:")
                    color: currTheme.gray
                    font: mainFont.dapFont.medium14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }

                Item{
                    Layout.minimumWidth: 150
                    height: 20

                    DapBigText
                    {
                        id: fee1Value
                        anchors.fill: parent
                        textFont: mainFont.dapFont.medium14
                        textColor: currTheme.white
                        fullText: feeStruct.network_fee + " " + feeStruct.fee_ticker
                        horizontalAlign: Text.AlignRight
                    }
                }
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.topMargin: 12
                Layout.leftMargin: 54
                height: 20
                spacing: 0
                Layout.alignment: Qt.AlignHCenter
                Text{
                    id:fee2Name
                    Layout.fillWidth: true
                    text: qsTr("Validator:")
                    color: currTheme.gray
                    font: mainFont.dapFont.medium14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }

                Item{
                    Layout.minimumWidth: 150
                    height: 20

                    DapBigText
                    {
                        id: fee2Value
                        anchors.fill: parent
                        textFont: mainFont.dapFont.medium14
                        textColor: currTheme.white
                        fullText: feeStruct.validator_fee + " " + feeStruct.fee_ticker
                        horizontalAlign: Text.AlignRight
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.topMargin: 12
                // Layout.alignment: Qt.AlignHCenter
                Layout.leftMargin: 12
                height: 50
//                anchors.topMargin: 3
//                anchors.horizontalCenter: parent.horizontalCenter

                Image
                {
                    id: checkBox
                    anchors.left: parent.left
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
                    text: qsTr("I am sure that I want to delete this order")
                    wrapMode: Text.WordWrap
                    x: 55
                    y: 14

                    MouseArea{
                        anchors.fill: parent
                        onClicked: checkBox.isChecked = !checkBox.isChecked
                    }
                }
            }
        }

        Item {
            id: buttonFrame
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
                textButton: qsTr("Delete order")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular14
                enabled: checkBox.isChecked
                onClicked:
                {
                    var isBuy = side !== "Buy"

                    var resultTokenName = !isBuy ? dexModule.token1 : dexModule.token2
                    console.log("An order with a hash is deleted " + hash + " in the " + network + " network")
                    dexModule.requestOrderDelete(network, hash, feeStruct.validator_fee, resultTokenName, amount)
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
        // walletsControllerPopup.show()
    }

    function show(model) {
        checkBox.isChecked = false
        visible = true

        hash = model.hash
        network = model.network
        side = model.side
        amount = model.amount

        feeStruct = walletModule.getFee(network);

        backgroundFrame.opacity = 0.4
        frameRemoveDialog.opacity = 1
    }
}
