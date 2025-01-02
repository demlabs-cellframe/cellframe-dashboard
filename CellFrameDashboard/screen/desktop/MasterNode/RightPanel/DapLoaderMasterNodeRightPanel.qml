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

    property int currentStage: nodeMasterModule.currentStage

    property var loadingStagesText: [
        qsTr("Certificate verification"),
        qsTr("Configuring the node"),
        qsTr("Rebooting the node"),
        qsTr("Publishing your node"),
        qsTr("Locking tokens"),
        qsTr("Requesting to become a master node"),
        qsTr("Creating an order for the validator fee"),
        qsTr("Deleting an order"),
        qsTr("Returning the configuration settings"),
        qsTr("Return of m-tokens"),
        qsTr("Deleting a node")
    ]

    property var errorTexts: [
        qsTr("There is no certificate name or signature."),
        qsTr("An empty value was specified for freezing m-tokens."),
        qsTr("Other problems. Contact customer support."),
        qsTr("No stake delegate hash found in the mempool."),
        qsTr("No stake delegate hash found in the queue."),
        qsTr("There are node configuration problems."),
        qsTr("The transaction may have failed."),
        qsTr("The value of the desired commission was not found."),
        qsTr("The transaction was not created."),
        qsTr("There was a problem with the detention of tokens, we need to make another attempt."),
        qsTr("The commission payment order has not been created."),
        qsTr("Couldn't create a certificate."),
        qsTr("The public key of the certificate was not found."),
        qsTr("Couldn't copy the file."),
        qsTr("Other problems."),
        qsTr("The list of nodes has not been received."),
        qsTr("Node is not on the list yet. Please check its status in 15 seconds."),
        qsTr("I couldn't add a node."),
        qsTr("There was a problem with the return of tokens."),
        qsTr("No stake invalidate hash found in the mempool.")
    ]

    ListModel
    {
        id: stepsModel
        Component.onCompleted:
        {
            updateModelStage()
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
            height: 206

            Item
            {
                id: loadPanel
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
                        font: mainFont.dapFont.medium14
                        text: loadingStagesText[nodeMasterModule.creationStage]
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
                        text: ""
                    }
                }
            }

            Item
            {
                width: root.state === "ERROR" ? cancelButton.implicitWidth + retryButton.implicitWidth + 14 : cancelButton.implicitWidth
                height: 36
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: loadPanel.bottom
                anchors.topMargin: 16

                DapButton
                {
                    id: cancelButton
                    textButton: nodeMasterModule.isStartRegistration ? qsTr("Cancel") : qsTr("Ignore")
                    enabled: {
                        if(nodeMasterModule.creationStage === 4 && root.state === "ERROR")
                        {
                            return true;
                        }
                        return nodeMasterModule.creationStage !== 4
                    }
                    anchors.left: parent.left
                    anchors.top: parent.top
                    implicitHeight: 36
                    implicitWidth: 132
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium14
                    selected: false
                    onClicked:
                    {
                        nodeMasterModule.cencelRegistration()
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
                    fontButton: mainFont.dapFont.medium14
                    visible: root.state == "ERROR"
                    onClicked:
                    {
                        nodeMasterModule.continueRegistrationNode()
                    }
                }
            }
        }

        ListView
        {
            property int stepItemHeight: 52

            id: stepsView
            anchors.top: topPanel.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            model: stepsModel
            clip: true


            delegate: Rectangle
            {
                width: parent.width
                height: stepsView.stepItemHeight
                color: result === 2 ? currTheme.rowHover : currentStage === index ? currTheme.lightGreen : currTheme.secondaryBackground

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
                    visible: currentStage > index || result === 2
                    source: currentStage > index ? "qrc:/Resources/"+ pathTheme +"/icons/other/check_icon.svg" : result === 2 ? "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.svg": ""
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
                    color: result === 2 ? currTheme.orange : currentStage === index ? currTheme.mainBackground : currTheme.white
                    font: mainFont.dapFont.medium14
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
    }

    Connections
    {
        target: nodeMasterModule

        function onErrorCreation(code)
        {
            if(code > -1)
            {
                stepsModel.get(nodeMasterModule.currentStage).result = 2
                errorText.text = errorTexts[code]
                state = "ERROR"
            }
            else
            {
                stepsModel.get(nodeMasterModule.currentStage).result = 0
                state = "PROCESSING"
            }
        }

        function onFullStageListUpdate()
        {
            updateModelStage()
        }

        function onRegistrationCenceled()
        {
            dapRightPanel.push(baseMasterNodePanel)
        }
    }

    function updateModelStage()
    {
        if(!nodeMasterModule.isUploadCertificate())
        {
            loadingStagesText[0] = qsTr("Creating and verification a certificate")
        }
        var modelList = nodeMasterModule.getFullStepsLoader()

        for(var i=0; i < modelList.length; ++i)
        {
            // @result:
            // 0: no have
            // 1: ok
            // 2: error
            stepsModel.append({name: loadingStagesText[modelList[i]],
                       result: 0})
        }

        if(nodeMasterModule.currentStage > 0)
        {
            for( i = 0; i < nodeMasterModule.currentStage - 1; ++i)
            {
                stepsModel.get(i).result = 1
            }

            if(nodeMasterModule.errorStage > -1)
            {
                stepsModel.get(nodeMasterModule.errorStage).result = 2
                errorText.text = errorTexts[nodeMasterModule.errorMessage];
                state = "ERROR"
            }
        }
    }
}
