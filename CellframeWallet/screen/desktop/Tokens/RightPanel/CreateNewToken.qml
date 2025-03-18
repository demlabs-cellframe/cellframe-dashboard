import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.12 as Controls
import "qrc:/widgets"
import "../parts"
import "../../controls"

DapRectangleLitAndShaded {
    id: root

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

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

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
                onClicked: navigator.clear()
            }

            Text
            {
                id: textHeader
                text: qsTr("New Token")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        Rectangle {
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 30 

            Text {
                color: currTheme.white
                text: qsTr("Name of token")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            height: 53 
            color: "transparent"

            DapTextField
            {
                id: textInputNewTokenName
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: qsTr("Name of token")
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10 
                anchors.bottomMargin: 10 

                bottomLineVisible: true
                bottomLineSpacing: 6
                bottomLineLeftRightMargins: 6

                validator: RegExpValidator { regExp: /[0-9A-Za-z\.\-]+/ }

                selectByMouse: true
                DapContextMenu{}
            }
        }

        Rectangle {
            color: currTheme.mainBackground
            Layout.topMargin: 20
            Layout.fillWidth: true
            height: 30 

            Text {
                color: currTheme.white
                text: qsTr("Select network")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        Item
        {
            height: 56 
            Layout.fillWidth: true

            DapCustomComboBox {
                id: networks
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                model: dapModelTokens
                backgroundColorShow: currTheme.secondaryBackground

                mainTextRole: "network"
                font: mainFont.dapFont.regular16
            }
        }

        Rectangle {
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 30 

            Text {
                color: currTheme.white
                text: qsTr("Select certificate")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        Item
        {
            height: 56 
            Layout.fillWidth: true

            DapCustomComboBox {
                id: certificates
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                model: certificatesModel
                backgroundColorShow: currTheme.secondaryBackground

                mainTextRole: "completeBaseName"
                font: mainFont.dapFont.regular16
            }
        }

        Rectangle {
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 30 

            Text {
                color: currTheme.white
                text: qsTr("Total supply")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        Item
        {
            Layout.fillWidth: true
            Layout.topMargin: 10
            height: 60 

            Rectangle
            {
                anchors.fill: parent
                anchors.leftMargin: 33
                anchors.rightMargin: 33
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                border.width: 1
                radius: 4
                border.color: "#666E7D"
                color: "transparent"

                DapTextField
                {
                    id: textInputAmount
                    anchors.fill: parent
                    placeholderText: "0.0"
                    validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignRight

                    borderWidth: 1
                    borderRadius: 4
                    placeholderColor: currTheme.white

                    selectByMouse: true
                    DapContextMenu{}
                }
            }
        }


        Item
        {
            id: frameBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Text
        {
            id: error

            Layout.minimumHeight: 30
            Layout.maximumHeight: 30
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.bottomMargin: 12
            Layout.maximumWidth: 281

            color: "#79FFFA"
            text: ""
            font: mainFont.dapFont.regular14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            visible: false
        }

        DapButton
        {
            implicitHeight: 36
            implicitWidth: 163

            Layout.bottomMargin: 40
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            textButton: qsTr("Create new token")
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText:Qt.AlignCenter
            onClicked:{

                var supply = textInputAmount.text

                if(textInputNewTokenName.text === "")
                {
                    error.visible = true
                    error.text = qsTr("Empty token name")
                }
                else
                if (supply === "" || stringWorker.testAmount("0.0", supply))
                {
                    error.visible = true
                    error.text = qsTr("Zero supply.")
                }
                else
                {
                    error.visible = false
                    logicMainApp.requestToService("DapTokenDeclCommand", stringWorker.toDatoshi(supply),
                                                          networks.displayText,
                                                          textInputNewTokenName.text,
                                                          certificates.displayText)
                }
            }

            DapCustomToolTip {
                contentText: qsTr("Create new token")
            }
        }
    }

    Connections{
        target: dapServiceController
        function onResponseDeclToken(resultDecl)
        {
            logicTokens.commandResult = resultDecl
            navigator.done()
        }
    }
}




