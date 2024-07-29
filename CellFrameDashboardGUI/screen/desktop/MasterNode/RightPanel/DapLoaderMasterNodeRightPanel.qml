import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.4
import "qrc:/widgets"

DapRectangleLitAndShaded
{
    id: root

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    state: "PROCESSING"
    states: [
        State {
            name: "PROCESSING"
            PropertyChanges { target: processingTopPanel; visible: true }
            PropertyChanges { target: errorTopPanel; visible: false }
        },
        State {
            name: "ERROR"
            PropertyChanges { target: processingTopPanel; visible: false }
            PropertyChanges { target: errorTopPanel; visible: true }
        }
    ]

    property int currentStage: state == "ERROR" ? -1 : nodeMasterModule.creationStage

    property var loadingStagesText: [
        qsTr("Creating a certificate"),
        qsTr("Certificate verification"),
        qsTr("Configuring the node"),
        qsTr("Rebooting the node"),
        qsTr("Registering a node"),
        qsTr("Blocking tokens"),
        qsTr("Waiting for the transaction to complete")
    ]

    ListModel
    {
        id: stepsModel
        Component.onCompleted:
        {
            for(var i=0; i<loadingStagesText.length; ++i)
            {
                // @result:
                // 0: no have
                // 1: ok
                // 2: error
                append({name: loadingStagesText[i],
                           result: 0})
            }
        }
    }

    contentData:
    Item
    {
        anchors.fill: parent

        Item
        {
            id: topPanel
            width: parent.width
            implicitHeight: root.state == "PROCESSING" ? processingTopPanel.height : errorTopPanel.height
            anchors.top: parent.top
            anchors.topMargin: root.state == "PROCESSING" ? 50 : 23

            Item
            {
                id: processingTopPanel
                width: parent.width
                height: 62
                anchors.top: parent.top

                Image
                {
                    id: processingIcon
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    sourceSize: Qt.size(36,36)
                    smooth: true
                    antialiasing: true
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/Resources/"+ pathTheme +"/icons/other/loader.svg"

                    RotationAnimator
                    {
                        id: animatorIndicator
                        target: processingIcon
                        from: 0
                        to: 360
                        duration: 1000
                        loops: Animation.Infinite
                        running: true
                    }
                }

                Text
                {
                    id: stageText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    horizontalAlignment: Text.AlignHCenter
                    color: currTheme.white
                    font: mainFont.dapFont.regular14
                    text: registrationStagesText[nodeMasterModule.creationStage]
                }
            }

            Item
            {
                id: errorTopPanel
                width: parent.width
                height: 108
                anchors.top: parent.top

                Image
                {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    sourceSize: Qt.size(64,64)
                    smooth: true
                    antialiasing: true
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/Resources/"+ pathTheme +"/icons/other/no_icon.svg"
                }

                Text
                {
                    id: errorText
                    height: 36
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    color: currTheme.white
                    font: mainFont.dapFont.medium14
                    text: qsTr("The launch of the node has not been completed")
                }
            }
        }

        Item
        {
            width: root.state == "ERROR" ? cancelButton.implicitWidth + retryButton.implicitWidth + 14 : cancelButton.implicitWidth
            height: 36
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: topPanel.bottom
            anchors.topMargin: 16

            DapButton
            {
                id: cancelButton
                textButton: qsTr("Cancel")
                anchors.left: parent.left
                anchors.top: parent.top
                implicitHeight: 36
                implicitWidth: 132
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular14
                selected: false
                onClicked:
                {
                    // TODO
                }
            }

            DapButton
            {
                id: retryButton
                textButton: qsTr("Retry")
                anchors.right: parent.right
                anchors.top: parent.top
                implicitHeight: 36
                implicitWidth: 132
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular14
                visible: root.state == "ERROR"
                onClicked:
                {
                    // TODO
                }
            }
        }

        ListView
        {
            property int stepItemHeight: 52

            id: stepsView
            height: stepsModel.count * stepItemHeight
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            model: stepsModel

            delegate: Rectangle
            {
                width: parent.width
                height: stepsView.stepItemHeight
                color: result == 2 ? currTheme.rowHover : currentStage === index ? currTheme.lightGreen : currTheme.secondaryBackground

                Image
                {
                    id: resultIcon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    sourceSize: Qt.size(20,20)
                    smooth: true
                    antialiasing: true
                    fillMode: Image.PreserveAspectFit
                    visible: result > 0
                    source: result == 1 ? "qrc:/Resources/"+ pathTheme +"/icons/other/check_icon.svg" : "qrc:/Resources/"+ pathTheme +"/icons/other/no_icon.svg"
                }

                Text
                {
                    id: stepText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 42
                    anchors.rightMargin: 16
                    horizontalAlignment: Text.AlignLeft
                    color: result == 2 ? currTheme.orange : currentStage === index ? currTheme.mainBackground : currTheme.white
                    font: mainFont.dapFont.regular14
                    text: name
                }

                Rectangle
                {
                    width: parent.width
                    height: 1
                    color: currTheme.mainBackground
                    anchors.bottom: parent.bottom
                }
            }

            Rectangle
            {
                width: parent.width
                height: 1
                color: currTheme.mainBackground
                anchors.top: parent.top
            }
        }

        // demo
        Timer
        {
            id: tempTimer
            interval: 12000
            onTriggered:
            {
                for(var i=0; i<4; ++i)
                {
                    stepsModel.get(i).result = 1
                }
                stepsModel.get(4).result = 2

                state = "ERROR"
            }

            Component.onCompleted:
            {
                start()
            }
        }
    }

    Component.onCompleted:
    {

    }

    Component.onDestruction:
    {

    }
}
