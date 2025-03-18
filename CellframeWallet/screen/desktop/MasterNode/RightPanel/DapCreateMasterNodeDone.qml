import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0

import "qrc:/widgets"
import "../../../"
import "../../controls"
import "../../Settings/NodeSettings"


DapRectangleLitAndShaded
{
    property var linkKeys:
    {
        "support": "https://t.me/cellframetechsupport",
        "feedback": "https://cellframe.net/feedback-form/",
        "site": "https://cellframe.net/"
    }

    QMLClipboard
    {
        id: clipboard
    }

    ListModel { id: ulTextModel }

    id: root

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
        Item
    {
        anchors.fill: parent

        // image
        Image
        {
            id: okIcon
            anchors.top: parent.top
            anchors.topMargin: 24
            anchors.horizontalCenter: parent.horizontalCenter
            width: 64
            height: 64
            mipmap: true
            source: "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.svg"
        }

        //body
        ScrollView
        {
            id: scrollView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: okIcon.bottom
            anchors.bottom: buttonDone.top
            anchors.topMargin: 12
            anchors.bottomMargin: 12

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            clip: true

            contentData:
                ColumnLayout
            {
                width: scrollView.width
                spacing: 0

                Text
                {
                    id: textHeader
                    Layout.fillWidth: true
                    Layout.leftMargin: 36
                    Layout.rightMargin: 36
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.WordWrap
                    color: currTheme.white
                    font: mainFont.dapFont.medium24
                    text: qsTr("Master node created successfully!")
                }

                RowLayout{

                    Layout.fillWidth: true
                    Layout.leftMargin: 36
                    Layout.rightMargin: 36
                    Layout.topMargin: 12
                    spacing: 4

                    Text
                    {
                        id: textA1
                        Layout.alignment: Qt.AlignLeft
                        horizontalAlignment: Text.AlignLeft
                        color: currTheme.white
                        font: mainFont.dapFont.regular13
                        text: qsTr("Hash:")
                    }

                    Text
                    {
                        id: hashText
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignLeft
                        color: currTheme.white
                        font: mainFont.dapFont.regular13
                        text: nodeMasterModule.getDataRegistration("stakeHash")
                        elide: Text.ElideMiddle
                        MouseArea{
                            anchors.fill: parent
                            onEntered: hashText.color = currTheme.neon
                            onExited: hashText.color = currTheme.gray
                            onClicked: {
                                clipboard.setText(hashText.text)
                                showInfoNotification(qsTr("Hash copied"), "check_icon.png")
                            }
                        }
                    }
                }

                Text
                {
                    id: textA2
                    Layout.fillWidth: true
                    Layout.leftMargin: 36
                    Layout.rightMargin: 36
                    Layout.topMargin: 8
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.WordWrap
                    color: currTheme.white
                    font: mainFont.dapFont.regular13
                    text: qsTr("The hash from the transaction must be sent to the Cellframe team. There are multiple ways to request approval of your node:")
                }


                ListView
                {
                    id: ulView
                    implicitHeight: contentHeight
                    Layout.fillWidth: true
                    Layout.leftMargin: 36
                    Layout.rightMargin: 36
                    Layout.topMargin: 16
                    spacing: 12
                    clip: true
                    model: ulTextModel
                    interactive: false

                    delegate:
                        Item
                    {
                        width: parent.width
                        height: liText.contentHeight

                        Text
                        {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 8
                            font: mainFont.dapFont.regular13
                            color: currTheme.white
                            text: "•"
                        }

                        DapTextWithLinks
                        {
                            id: liText
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 20
                            text: str
                            onLinkClicked: tryOpenLink(foundLink)
                        }
                    }
                }

                DapTextWithLinks
                {
                    id: textC1
                    Layout.fillWidth: true
                    Layout.leftMargin: 36
                    Layout.rightMargin: 36
                    Layout.topMargin: 16
                    onLinkClicked: tryOpenLink(foundLink)
                }

                Item
                {
                    Layout.fillHeight: true
                }
            }
       }

        // button
        DapButton
        {
            id: buttonDone
            implicitHeight: 36
            implicitWidth: 132
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 40
            textButton: qsTr("Done")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14

            onClicked:
            {
                dapRightPanel.push(loaderMasterNodePanel)
            }
        }
    }

    function wrapLink(text, keyWord)
    {
        var ahrefBegin = "<a href='" + keyWord + "' style='color: " + currTheme.lime + "; text-decoration: none;'>"
        var ahrefEnd = "</a>"
        return ahrefBegin + text + ahrefEnd
    }

    function setTextLinks()
    {
        var spanMasterNode = "<span style='color: " + currTheme.inputActive + ";'>" + qsTr("master node") + "</span>"

        var supportLink = wrapLink(qsTr("Cellframe Support group"), "support")
        var feedbackLink = wrapLink(qsTr("Feedback form"), "feedback")
        var websiteLink = wrapLink(qsTr("Cellframe website"), "site")

        var text1 = qsTr("via the administrator in the ") + supportLink
        var text2 = qsTr("via sending an email to tech_support@cellframe.net")
        var text3 = qsTr("via this ") + feedbackLink + qsTr(" on the ") + websiteLink

        ulTextModel.clear()
        ulTextModel.append({ "str": text1})
        ulTextModel.append({ "str": text2})
        ulTextModel.append({ "str": text3})

        textC1.text = qsTr("If using the ") + feedbackLink + qsTr(", please specify the topic of your request as ") + spanMasterNode + qsTr(" and leave a valid e-mail address for the team to contact you.")
    }

    function tryOpenLink(key)
    {
        if(key in linkKeys)
        {
            console.log("Open link:", linkKeys[key])
            Qt.openUrlExternally(linkKeys[key])
        }
        else
        {
            console.log("Unknown key for link:", key)
        }
    }

    Component.onCompleted:
    {
        setTextLinks()
    }

    Component.onDestruction:
    {

    }
}



