import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.0
import "../../controls"
import "../../History"
import "qrc:/widgets"

DapBottomScreen {

    property string nameDapp: ""

    heightForm: 700
    header.text: qsTr("Install dApp")

    onClosedClicked:{
        pluginsController.cancelDownload();
    }

//    Timer{id: timer}

//    function delay(delayTime, cb) {
//        timer.interval = delayTime;
//        timer.repeat = false;
//        timer.triggered.connect(cb);
//        timer.start();
//    }

    Connections{
        target: pluginsController
        function onRcvProgressDownload(progress, completed, download, total, time, speed, name, error)
        {
            nameDapp = name

            _errors.text = error
            _progress.text = progress + " %"
            _progress.currentValue = progress
            _name.text = name
            _download.value = download
            _total.value = total
            _timeRemain.value = time
            _speed.value = speed

            if(error === "Connected")
                _errors.color = currTheme.lightGreen
            else
                _errors.color = currTheme.red

            if(completed)
            {
                canceledDownload.enabled = false
                reloadDownload.enabled = false
                closeButton.enabled = false

                var result = {
                    "success": true,
                    "headerText": "",
                    "errorMessage": name.replace(".zip", "") + "\n " + qsTr("successfuly installed!"),
                }

                logicMainApp.commandResult = result
                dapBottomPopup.push("qrc:/walletSkin/forms/dApps/Parts/InstallDone.qml")

//                delay(2000,function() {
//                    logicMainApp.commandResult = result
//                    dapBottomPopup.push("qrc:/walletSkin/forms/dApps/Parts/InstallDone.qml")
//                } )
            }
        }
        function onRcvAbort()
        {

            var result = {
                "success": false,
                "headerText": qsTr("Cancel"),
                "errorMessage": qsTr("Operation canceled"),
            }

            logicMainApp.commandResult = result

            dapBottomPopup.push("qrc:/walletSkin/forms/dApps/Parts/InstallDone.qml")
//            dAppsLogic.rcvAbort()
        }

        function onSigActivated(){

            dapMainWindow.infoItem.showInfo(
                        185,0,
                        qsTr("dApp activated"),
                        "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/check_icon.png")

            dapBottomPopup.hide()

        }
    }

    dataItem:
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 16
        anchors.topMargin: 9
        anchors.bottomMargin: 0
        spacing: 0

        // Header dApp
        Text
        {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            id: _name
            color: currTheme.white
            text: nameDapp
            font: mainFont.dapFont.regular14
            horizontalAlignment: Text.AlignHLeft
        }

        DapProgressBar
        {
            id: _progress
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.topMargin: 71

            text: "0 %"
        }

        Text{

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: 24

            id:_errors
            color: currTheme.lightGreen
            font: mainFont.dapFont.regular14
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter

            text: qsTr("Connected")
        }

        GridLayout{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            Layout.topMargin: 56
            rows: 2
            columns: 2

            ColumnTextItem{
                id: _total
                value: ""
                name: qsTr("Total")
            }

            ColumnTextItem{
                id: _speed
                value: ""
                name: qsTr("Speed")
            }
            ColumnTextItem{
                id: _download
                value: ""
                name: qsTr("Download")
            }
            ColumnTextItem{
                id: _timeRemain
                value: ""
                name: qsTr("Time remain")
            }
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.topMargin: 88
            spacing: 17

            DapButton
            {
                Layout.preferredHeight: 36
                Layout.preferredWidth: 132
                Layout.leftMargin: 35

                implicitHeight: 36
                implicitWidth: 132

                id:reloadDownload
                textButton: qsTr("Reload")
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked: {
                    pluginsController.reloadDownload();
                }
            }

            DapButton
            {
                Layout.preferredHeight: 36
                Layout.preferredWidth: 132

                implicitHeight: 36
                implicitWidth: 132

                id: canceledDownload
                textButton: qsTr("Cancel")
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked: {
                    pluginsController.cancelDownload();
                }
            }
        }

        Item{Layout.fillHeight: true}
    }
}
