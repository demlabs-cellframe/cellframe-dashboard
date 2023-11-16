import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../controls"


Item {

    property alias nameStatus: nameStatus
    property alias buttonSync: buttonSync
    property alias buttonNetwork: buttonNetwork

    MouseArea {
        anchors.fill: parent

        onClicked: {
            isOpen = false
            popupItem.close()
        }
    }

    Item{
        id: background
        anchors.fill: parent

        Rectangle {
            id: rPopup
            anchors.fill: parent
            visible: true
            radius: 8
            color: currTheme.mainBackground
        }

        DropShadow {
            anchors.fill: rPopup
            source: rPopup
            color: currTheme.shadowMain
            horizontalOffset: 5
            verticalOffset: 5
            radius: 10
            samples: 20
            opacity: 0.42
            cached: true
        }
        InnerShadow {
            anchors.fill: rPopup
            source: rPopup
            color: currTheme.reflection
            horizontalOffset: 0.5
            verticalOffset: 1
            radius: 0
            samples: 20
            opacity: 1
            fast: true
            cached: true
        }
    }

    //bottom hide line
    Item {
        width: parent.width
        height: 8
        anchors.bottom: parent.bottom

        Rectangle{
            id: bottomLine
            anchors.fill: parent
            color: currTheme.mainBackground
        }

        DropShadow {
            anchors.fill: bottomLine
            source: bottomLine
            color: currTheme.shadowMain
            horizontalOffset: 5
            verticalOffset: 5
            radius: 10
            samples: 20
            opacity: 0.42
        }
        InnerShadow {
            anchors.fill: bottomLine
            source: bottomLine
            color: currTheme.reflection
            horizontalOffset: 1
            verticalOffset: 0
            radius: 0
            samples: 0
            opacity: 1
            fast: true
            cached: true
        }
    }


    //content
    ColumnLayout
    {
//        opacity: 0
        id: layout
        spacing: 8
        anchors.fill: parent
        anchors.topMargin: 2
        clip: true

        //Buttons
        RowLayout {
            id:buttonsLayout
            Layout.fillWidth: true
            Layout.leftMargin: 2
            Layout.maximumHeight: 24
            Layout.minimumHeight: 24
            spacing: 1

            DapInfoButton {
                id: buttonSync
                enabled: false
                Layout.fillWidth: true
                Layout.fillHeight: true
                isSynch: true
                onClicked:
                {
                    logicMainApp.requestToService("DapNetworkSingleSyncCommand", name)

                    if(!USING_NOTIFY || !logicMainApp.stateNotify)
                        logicMainApp.requestToService("DapGetNetworksStateCommand")
                }
            }

            DapInfoButton {
                id: buttonNetwork
                isFakeStateButton: false
                enabled: false
                Layout.fillWidth: true
                Layout.fillHeight: true
                Component.onCompleted: setText()
                onClicked: {
                    console.log("onClicked on/off network")
                    buttonNetwork.updateFakeButton(true)
                    if (targetState !== "ONLINE" && networkState !== "ONLINE" )
                        logicMainApp.requestToService("DapNetworkGoToCommand", name, true)
                    else
                        logicMainApp.requestToService("DapNetworkGoToCommand", name, false)

                    if(!USING_NOTIFY || !logicMainApp.stateNotify)
                        logicMainApp.requestToService("DapGetNetworksStateCommand")
                }

                function setText()
                {
                    console.log("setText()")
                    buttonNetwork.updateFakeButton(false)//buttonNetwork.isFakeStateButton = false;
                    if (targetState !== "ONLINE" && networkState !== "ONLINE" )
                        buttonNetwork.textBut = qsTr("On network")
                    else
                        buttonNetwork.textBut = qsTr("Off network")
                }
            }
        }
        ///-------

        //body
        DapRowInfoText
        {
            Layout.topMargin: 8
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: staticText.implicitWidth + dynamicText.implicitWidth
            Layout.preferredHeight: 15

            staticText.text: qsTr("State: ")
            dynamicText.text: networkState
            onTextChangedSign: buttonNetwork.setText()
        }

        Text {
            id:errorMsg
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.leftMargin: 40
            Layout.rightMargin: 40
            Layout.preferredHeight: 15
            visible: errorMessage === "" || errorMessage === " "  ? false : true

            text: errorMessage
            font: mainFont.dapFont.medium12
            color: "#FF0000"
            elide: Text.ElideMiddle
            horizontalAlignment: Qt.AlignHCenter
        }

        DapRowInfoText
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: staticText.implicitWidth + dynamicText.implicitWidth
            Layout.preferredHeight: 15

            staticText.text: qsTr("Target state: ")
            dynamicText.text: targetState
            onTextChangedSign: buttonNetwork.setText()
        }

        DapRowInfoText
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: staticText.implicitWidth + dynamicText.implicitWidth
            Layout.preferredHeight: 15

            staticText.text: qsTr("Active links: ")
            dynamicText.text: activeLinksCount + qsTr(" of ") + linksCount
        }

        DapRowInfoText
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: staticText.implicitWidth + dynamicText.implicitWidth
            Layout.preferredHeight: 15

            staticText.text: qsTr("Address: ")
            dynamicText.text: nodeAddress + " "

            DapCopyButton
            {
                id: networkAddrCopyButton
                anchors.left: parent.dynamicText.right
                anchors.verticalCenter: parent.verticalCenter
                popupText: qsTr("Address copied")

                onCopyClicked:
                {
                    clipboard.setText(nodeAddress)

                }
            }
        }
        Item {
            Layout.fillHeight: true
        }
    }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 14

        height: 15
        spacing: 5
//        width: nameText.implicitWidth + nameStatus.width + spacing

        Text {
            id: nameText
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.maximumWidth: item_width/2
            font: mainFont.dapFont.medium12
            color: currTheme.white
            text: name
            elide: Text.ElideMiddle
        }

        Item{
            Layout.preferredHeight: 8
            Layout.preferredWidth: 8

            Image {
                id: nameStatus
                anchors.centerIn: parent
                sourceSize: Qt.size(8,8)
//                mipmap: true
                antialiasing: true
//                smooth: false
                fillMode: Image.PreserveAspectFit

                source: networkState === "ONLINE" ? "qrc:/Resources/" + pathTheme + "/icons/other/indicator_online.svg" :
                        networkState !== targetState ? "qrc:/Resources/" + pathTheme + "/icons/other/indicator_online.png" :
                        networkState === "ERROR" ?  "qrc:/Resources/" + pathTheme + "/icons/other/indicator_error.svg":
                                                    "qrc:/Resources/" + pathTheme + "/icons/other/indicator_offline.svg"

                opacity: networkState !== targetState? animationController.opacity : 1
            }
        }
    }
}





