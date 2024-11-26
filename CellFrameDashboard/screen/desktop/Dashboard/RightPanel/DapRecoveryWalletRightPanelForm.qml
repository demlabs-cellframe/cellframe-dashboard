import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import "qrc:/widgets"
import "../../../"
import "../../controls"

DapRectangleLitAndShaded
{
//    dapButtonClose.normalImageButton: "qrc:/resources/icons/" + pathTheme + "/back_icon.png"
//    dapButtonClose.hoverImageButton: "qrc:/resources/icons/" + pathTheme + "/back_icon_hover.png"

//    dapButtonClose.heightImageButton: 14 
//    dapButtonClose.widthImageButton: 13 

    property alias checkBox1: checkBox1
    property alias checkBox2: checkBox2
    property alias acceptedLayout: acceptedLayout

    property alias dapButtonClose: itemButtonClose

    property alias dapButtonAction: actionButton
    property alias dapButtonNext: nextButton

    property alias dapTextMethod: textMethod

    property alias dapWarningText1: warningText1
    property alias dapWarningText2: warningText2

    property alias dapWordsGrid: wordsGrid
    property alias dapBackupFileName: backupFileName

    property alias dapTextTopMessage: textTopMessage
//    property alias dapTextBottomMessage: textBottomMessage
    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    Shortcut {
       context: Qt.ApplicationShortcut
       sequence: "Ctrl+V"

       onActivated: {
            if(logicWallet.walletRecoveryType === "Words" && logicWallet.restoreWalletMode)
            {
                dapButtonNext.enabled = true
                walletHashManager.pasteWordsFromClipboard(walletInfo.password)
            }
       }
    }

    Shortcut {
       context: Qt.ApplicationShortcut
       sequence: "Ctrl+C"

       onActivated: {
            if(logicWallet.walletRecoveryType === "Words" && !logicWallet.restoreWalletMode && actionButton.enabled)
            {
                dapButtonNext.enabled = true
                walletHashManager.copyWordsToClipboard()

                dapMainWindow.infoItem.showInfo(
                            0,0,
                            dapMainWindow.width*0.5,
                            8,
                            qsTr("Words copied"),
                            "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
            }
       }
    }

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        //Header
        Item
        {
            Layout.fillWidth: true
            height: 42 

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16

                id: itemButtonClose
                height: 20 
                width: 20 
                heightImage: 20 
                widthImage: 20 

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/back.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/back_hover.svg"
            }

            Text
            {

                id: textHeader
                text: qsTr("New wallet")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }
        //Body
        Rectangle
        {
            id: frameMethod
            Layout.fillWidth: true
            color: currTheme.mainBackground
            height: 30 
            Text
            {
                id: textMethod
                color: currTheme.white
                text: qsTr("Recovery method: 24 words")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.margins: 16
            Layout.alignment: Qt.AlignHCenter

            Text
            {
                id: textTopMessage
                anchors.fill: parent

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: "#79FFFA"
                wrapMode: Text.WordWrap
                font: mainFont.dapFont.regular14
            }
        }

        Grid {
            id: wordsGrid

            Layout.topMargin: 4
            Layout.minimumHeight: 120
            Layout.maximumHeight: 120
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: 318

            columns: 3

            columnSpacing: 50
//            rowSpacing: 5

            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter
            flow: Grid.TopToBottom

            Repeater {
                delegate: Text {
                    Layout.fillWidth: true
                    text: modelData
                    color: currTheme.white
                    font: mainFont.dapFont.regular12

                }
                model: wordsModel
            }
        }

        Text
        {
            id: backupFileName
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Layout.leftMargin: 16

            color: "#C7C6CE"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font: mainFont.dapFont.regular14
        }

        Item
        {
            id: frameBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        ColumnLayout{
            id: bottomPlace
            Layout.alignment: Qt.AlignBottom
//            Layout.topMargin: 20
            Layout.fillWidth: true
            height: 262
            spacing: 20

            ColumnLayout{
                id: acceptedLayout
                Layout.fillWidth: true
                height: 165
                Layout.rightMargin: 16
                spacing: 0

                Rectangle{
                    Layout.fillWidth: true
                    height: 1
                    color: currTheme.mainBackground
                }

                RowLayout{
                    Layout.topMargin: 16
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    spacing: 0

                    Image
                    {
                        id: checkBox1
                        Layout.alignment: Qt.AlignTop
                        Layout.topMargin: -10
                        sourceSize.width: 50
                        sourceSize.height: 50
                        property bool isChecked: false
                        source: isChecked ? "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_on.png"
                                          : "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_off.png"

                        MouseArea{
                            anchors.fill: parent
                            onClicked:
                            {
                                checkBox1.isChecked = !checkBox1.isChecked
                                if (!checkBox1.isChecked)
                                    nextButton.enabled = false
                            }
                        }
                    }

                    Text
                    {
                        id: warningText1
                        Layout.fillWidth: true
                        font: mainFont.dapFont.regular14
                        color: currTheme.white
                        text: ""
                        wrapMode: Text.WordWrap
                        MouseArea{
                            anchors.fill: parent
                            onClicked:
                            {
                                checkBox1.isChecked = !checkBox1.isChecked
                                if (!checkBox1.isChecked)
                                    nextButton.enabled = false
                            }
                        }
                    }
                }

                RowLayout{
                    Layout.topMargin: 16
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    spacing: 0

                    Image
                    {
                        id: checkBox2
                        Layout.alignment: Qt.AlignTop
                        Layout.topMargin: -10
                        sourceSize.width: 50
                        sourceSize.height: 50
                        property bool isChecked: false
                        source: isChecked ? "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_on.png"
                                          : "qrc:/Resources/" + pathTheme + "/icons/other/ic_checkbox_off.png"

                        MouseArea{
                            anchors.fill: parent
                            onClicked:
                            {
                                checkBox2.isChecked = !checkBox2.isChecked
                                if (!checkBox2.isChecked)
                                    nextButton.enabled = false
                            }
                        }
                    }

                    Text
                    {
                        id: warningText2
                        Layout.fillWidth: true
                        font: mainFont.dapFont.regular14
                        color: currTheme.white
                        text: ""
                        wrapMode: Text.WordWrap
                        MouseArea{
                            anchors.fill: parent
                            onClicked:
                            {
                                checkBox2.isChecked = !checkBox2.isChecked
                                if (!checkBox2.isChecked)
                                    nextButton.enabled = false
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.preferredHeight: 96
                Layout.leftMargin: 36
                Layout.rightMargin: 35
                spacing: 14

                DapButton
                {
                    id: actionButton

                    Layout.bottomMargin: 40
                    Layout.topMargin: 20
                    Layout.alignment: Qt.AlignHCenter

                    implicitHeight: 36
                    implicitWidth: 132
                    checkable: true
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14

                    enabled: checkBox1.isChecked && checkBox2.isChecked
                }

                DapButton
                {
                    id: nextButton

                    enabled: false

                    Layout.bottomMargin: 40
                    Layout.topMargin: 20
                    Layout.alignment: Qt.AlignHCenter

                    implicitHeight: 36
                    implicitWidth: 132
                    textButton: qsTr("Next")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14
                }
            }
        }
    }
}
