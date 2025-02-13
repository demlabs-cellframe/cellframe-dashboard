import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../controls"


Item {

    property alias nameStatus: nameAndStatus.indicator
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
            horizontalOffset: 1
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
            visible: app.getNodeMode() === 0 //local
            id:buttonsLayout
            Layout.fillWidth: true
            Layout.leftMargin: 2
            Layout.maximumHeight: 24
            Layout.minimumHeight: 24
            spacing: 1

            DapInfoButton {
                id: buttonSync
                enabled: false
                isFakeStateButton: false
                Layout.fillWidth: true
                Layout.fillHeight: true
                isSynch: true
                onClicked:
                {
                    buttonSync.updateFakeButton(true)
                    networksModule.goSync(networkName)
                    logicNet.delay(800, function(){buttonSync.updateFakeButton(false)})
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
                    if (targetState !== "NET_STATE_ONLINE" && networkState !== "NET_STATE_ONLINE" )
                        networksModule.goOnline(networkName)
                    else
                        networksModule.goOffline(networkName)
                }

                function setText()
                {
                    if(!app.getNodeMode())
                    {
                        console.log("setText()")
                        logicNet.delay(300, function(){
                            if(buttonNetwork) buttonNetwork.updateFakeButton(false)
                        })
    //                    buttonNetwork.updateFakeButton(false)//buttonNetwork.isFakeStateButton = false;
                        if (targetState !== "NET_STATE_ONLINE" && networkState !== "NET_STATE_ONLINE" )
                            buttonNetwork.textBut = qsTr("On network")
                        else
                            buttonNetwork.textBut = qsTr("Off network")
                    }
                }
            }
        }
        ///-------

        //body
        Item
        {
            property bool showProgress: !(networkState === "NET_STATE_OFFLINE" || networkState === "NET_STATE_ONLINE")
            property string progressText: showProgress ? " " + (logicNet.percentToRatio(syncPercent) * 100).toFixed(0) + "%" : ""
            property int spinerWidth: showProgress ? stateSpinerIcon.width : 0

            Layout.topMargin: 8
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: stateTextBlock.staticText.implicitWidth + stateTextBlock.dynamicText.implicitWidth + spinerWidth
            Layout.preferredHeight: 15

            DapRowInfoText
            {
                id: stateTextBlock
                anchors.top: parent.top
                anchors.left: parent.left
                height: parent.height
                staticText.text: qsTr("State: ")
                dynamicText.text: displayNetworkState + parent.progressText
                onTextChangedSign: buttonNetwork.setText()
            }

            Image
            {
                id: stateSpinerIcon
                width: 15
                height: 15
                anchors.right: parent.right
                y: parent.height / 2 - height / 2
                visible: parent.showProgress
                antialiasing: true
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(15,15)
                source: "qrc:/Resources/" + pathTheme + "/icons/other/sync_15x15.svg"

                NumberAnimation on rotation
                {
                    from: 0
                    to: -360
                    duration: 1000
                    loops: Animation.Infinite
                    running: true
                }
            }
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
            dynamicText.text: displayTargetState
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
            dynamicText.text: address + " "

            DapCopyButton
            {
                id: networkAddrCopyButton
                anchors.left: parent.dynamicText.right
                anchors.verticalCenter: parent.verticalCenter
                popupText: qsTr("Address copied")

                onCopyClicked:
                {
                    clipboard.setText(address)
                }
            }
        }
        Item {
            Layout.fillHeight: true
        }
    }

    Item
    {
        width: parent.width
        height: 42
        anchors.bottom: parent.bottom

        DapNetworkNameStatusComponent
        {
            id: nameAndStatus
            nameOfNetwork: networkName
            stateOfNetwork: networkState
            stateOfTarget: targetState
            percentOfSync: syncPercent
        }
    }
}
