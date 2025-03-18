import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"
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
                text: qsTr("New Order")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        ScrollView
        {
            id: scrollView

            Layout.fillHeight: true
            Layout.fillWidth: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            clip: true

            contentData:
            ColumnLayout
            {
                id: column
                width: scrollView.width
                spacing: 0

                Rectangle {
                    color: currTheme.mainBackground
                    Layout.fillWidth: true
                    height: 30

                    Text {
                        color: currTheme.white
                        text: qsTr("Select Type")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }
                }

                Rectangle
                {
                    height: 60
                    color: "transparent"
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    Layout.rightMargin: 36

                    ListModel
                    {
                        id: ordersModelType
                        ListElement{type: "VPN"}
                        ListElement{type: "Stake"}
                    }

                    DapCustomComboBox {
                        id: types
                        anchors.fill: parent
                        model: ordersModelType
                        backgroundColorShow: currTheme.secondaryBackground

                        mainTextRole: "type"
                        font: mainFont.dapFont.regular16

                        onCurrentIndexChanged: error.text = ""
                    }
                }

//TODO: now only SELL
//                Rectangle {
//                    color: currTheme.mainBackground
//                    Layout.fillWidth: true
//                    height: 30

//                    Text {
//                        color: currTheme.white
//                        text: qsTr("Direction")
//                        font: mainFont.dapFont.medium12
//                        horizontalAlignment: Text.AlignLeft
//                        anchors.verticalCenter: parent.verticalCenter
//                        anchors.left: parent.left
//                        anchors.leftMargin: 16
//                    }
//                }

//                Rectangle
//                {
//                    height: 60
//                    color: "transparent"
//                    Layout.fillWidth: true

//                    ListModel
//                    {
//                        id: ordersModelDirection
//                        ListElement{direction: "sell"}
//                        ListElement{direction: "buy"}
//                    }

//                    DapCustomComboBox {
//                        id: direction
//                        anchors.fill: parent
//                        anchors.leftMargin: 16
//                        anchors.rightMargin: 16
//                        model: ordersModelDirection
//                        backgroundColorShow: currTheme.secondaryBackground

//                        mainTextRole: "direction"
//                        font: mainFont.dapFont.regular16
//                    }
//                }

                Rectangle {
                    color: currTheme.mainBackground
//                    Layout.topMargin: 20
                    Layout.fillWidth: true
                    height: 30

                    Text {
                        color: currTheme.white
                        text: qsTr("Network")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }
                }

                Rectangle
                {
                    height: 60
                    color: "transparent"
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    Layout.rightMargin: 36

                    DapCustomComboBox {
                        id: networks
                        anchors.fill: parent
                        model: dapModelTokens
                        backgroundColorShow: currTheme.secondaryBackground
                        defaultText: qsTr("Networks")
                        mainTextRole: "network"
                        font: mainFont.dapFont.regular16
                    }
                }

                Rectangle {
                    color: currTheme.mainBackground
                    Layout.fillWidth: true
//                    Layout.topMargin: 20
                    height: 30

                    visible: types.currentText === "Stake"

                    Text {
                        color: currTheme.white
                        text: qsTr("Fee value")
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
                    Layout.leftMargin: 34
                    Layout.rightMargin: 36
                    height: 80
                    color: "transparent"
                    visible: types.currentText === "Stake"

                    DapTextField
                    {
                        id: textInputValue
                        anchors.fill: parent
                        anchors.rightMargin: 10
                        anchors.topMargin: 20
                        anchors.bottomMargin: 20
                        placeholderText: "0.0"
                        validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                        font: mainFont.dapFont.regular16
                        horizontalAlignment: Text.AlignRight

                        borderWidth: 1
                        borderRadius: 4
                        placeholderColor: currTheme.gray

                        selectByMouse: true
                        DapContextMenu{}
                    }
                }

                Rectangle {
                    color: currTheme.mainBackground
                    Layout.fillWidth: true
//                    Layout.topMargin: 20
                    height: 30
                    visible: types.currentText === "VPN"

                    Text {
                        color: currTheme.white
                        text: qsTr("Price")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }
                }

                RowLayout
                {
                    id: framePriceField
                    Layout.fillWidth: true
                    Layout.topMargin: 20
                    Layout.leftMargin: 36
                    Layout.rightMargin: 36
                    height: 80
                    visible: types.currentText === "VPN"


//                    spacing: 31

                    DapTextField
                    {
                        id: textInputPrice
                        Layout.fillWidth: true
                        width: 171
                        Layout.minimumHeight: 40
                        Layout.maximumHeight: 40
                        placeholderText: "0.0"
                        validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                        font: mainFont.dapFont.regular16
                        horizontalAlignment: Text.AlignRight

                        borderWidth: 1
                        borderRadius: 4
                        placeholderColor: currTheme.gray

                        selectByMouse: true
                        DapContextMenu{}
                    }

                    Rectangle
                    {
                        id: frameTokens
                        color: "transparent"
                        height: 42
                        Layout.minimumWidth: 125
                        Layout.maximumWidth: 125
                        Layout.leftMargin: 5
                        Layout.rightMargin: 0

                        DapCustomComboBox {
                            id: priceToken
                            anchors.fill: parent
                            model: dapModelTokens.get(networks.currentIndex).tokens

                            backgroundColorShow: currTheme.secondaryBackground
                            defaultText: qsTr("Tokens")
                            mainTextRole: "name"
                            font: mainFont.dapFont.regular16
                        }
                    }
                }


                Rectangle {
                    color: currTheme.mainBackground
                    Layout.topMargin: 20
                    Layout.fillWidth: true
                    height: 30
                    visible: types.currentText === "VPN"


                    Text {
                        color: currTheme.white
                        text: qsTr("Amount units")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }
                }

                RowLayout
                {
                    id: frameUnits
                    Layout.fillWidth: true
                    Layout.topMargin: 20
                    Layout.leftMargin: 36
                    Layout.rightMargin: 36
                    height: 80

                    visible: types.currentText === "VPN"


//                    spacing: 31

                    DapTextField
                    {
                        id: textInputUnits
                        Layout.fillWidth: true
                        width: 171
                        Layout.minimumHeight: 40
                        Layout.maximumHeight: 40
                        placeholderText: "0"
                        validator: RegExpValidator { regExp: /[0-9]{0,40}/ }
                        font: mainFont.dapFont.regular16
                        horizontalAlignment: Text.AlignRight

                        borderWidth: 1
                        borderRadius: 4
                        placeholderColor: currTheme.gray

                        selectByMouse: true
                        DapContextMenu{}
                    }

                    Rectangle
                    {
                        id: framePriceUnit
                        color: "transparent"
                        height: 42
                        Layout.minimumWidth: 125
                        Layout.maximumWidth: 125
                        Layout.leftMargin: 5
                        Layout.rightMargin: 0

                        ListModel{
                            id: priceUnitModel
                            ListElement{unit:"SEC"}
                        }

                        DapCustomComboBox {
                            id: priceUnit
                            anchors.fill: parent
                            model: priceUnitModel
                            backgroundColorShow: currTheme.secondaryBackground

                            mainTextRole: "unit"
                            font: mainFont.dapFont.regular16
                        }
                    }
                }

                Rectangle {
                    color: currTheme.mainBackground
                    Layout.fillWidth: true
                    Layout.topMargin: 20
                    height: 30
                    visible: types.currentText === "VPN"


                    Text {
                        color: currTheme.white
                        text: qsTr("Node address")
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
                    Layout.leftMargin: 34
                    Layout.rightMargin: 36
                    height: 69
                    color: "transparent"
                    visible: types.currentText === "VPN"


                    DapTextField
                    {
                        id: textInputNodeAddr
                        anchors.verticalCenter: parent.verticalCenter
                        placeholderText: qsTr("0000:0000:0000:0000")
                        font: mainFont.dapFont.regular16
                        horizontalAlignment: Text.AlignLeft
                        anchors.fill: parent
                        anchors.rightMargin: 10
                        anchors.topMargin: 20
                        anchors.bottomMargin: 20

                        bottomLineVisible: true
                        bottomLineSpacing: 6
                        bottomLineLeftRightMargins: 6

                        validator: RegExpValidator { regExp: /[0-9aA-zZ]{0,4}::[0-9aA-zZ]{0,4}::[0-9aA-zZ]{0,4}::[0-9aA-zZ]{0,4}/ }

                        selectByMouse: true
                        DapContextMenu{}
                    }
                }

                Rectangle {
                    color: currTheme.mainBackground
                    Layout.fillWidth: true
                    Layout.topMargin: 20
                    height: 30
                    visible: false

                    Text {
                        color: currTheme.white
                        text: qsTr("TX Conditional Hash")
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
                    Layout.leftMargin: 34
                    Layout.rightMargin: 36
                    height: 69
                    color: "transparent"
                    visible: false

                    DapTextField
                    {
                        id: textInputTxCondHash
                        anchors.verticalCenter: parent.verticalCenter
                        placeholderText: qsTr("0x672B2153BADD98E4B95D5571CB39AC59216E307A4E3412DFBCC552AC7BF0BBA0")
                        font: mainFont.dapFont.regular16
                        horizontalAlignment: Text.AlignLeft
                        anchors.fill: parent
                        anchors.rightMargin: 10
                        anchors.topMargin: 20
                        anchors.bottomMargin: 20

                        bottomLineVisible: true
                        bottomLineSpacing: 6
                        bottomLineLeftRightMargins: 6

                        validator: RegExpValidator { regExp: /0x[0-9aA-fF]{0,64}/ }

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
                        text: qsTr("Certificate")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }
                }

                Rectangle
                {
                    height: types.displayText === "VPN" ? 60 : 55
                    color: "transparent"
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 36

                    DapCustomComboBox {
                        id: certificate
                        anchors.fill: parent
                        model: certificatesModel
                        backgroundColorShow: currTheme.secondaryBackground
                        defaultText: qsTr("Certificates")
                        mainTextRole: "completeBaseName"
                        font: mainFont.dapFont.regular16
                    }
                }

                Rectangle {
                    color: currTheme.mainBackground
//                    Layout.topMargin: 20
                    Layout.fillWidth: true
                    height: 30
                    visible: types.currentText === "VPN"


                    Text {
                        color: currTheme.white
                        text: qsTr("Region")
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
                    Layout.leftMargin: 34
                    Layout.rightMargin: 36
                    height: 69
                    color: "transparent"
                    visible: types.currentText === "VPN"

                    DapTextField
                    {
                        id: textInputRegion
                        anchors.verticalCenter: parent.verticalCenter
                        placeholderText: qsTr("None")
                        font: mainFont.dapFont.regular16
                        horizontalAlignment: Text.AlignLeft
                        anchors.fill: parent
                        anchors.rightMargin: 10
                        anchors.topMargin: 20
                        anchors.bottomMargin: 20

                        bottomLineVisible: true
                        bottomLineSpacing: 6
                        bottomLineLeftRightMargins: 6

                        validator: RegExpValidator { regExp: /[aA-zZ]{0,100}/ }

                        selectByMouse: true
                        DapContextMenu{}
                    }
                }


                Rectangle {
                    color: currTheme.mainBackground
                    Layout.topMargin: 20
                    Layout.fillWidth: true
                    height: 30
                    visible: types.currentText === "VPN"

                    Text {
                        color: currTheme.white
                        text: qsTr("Continent")
                        font: mainFont.dapFont.medium12
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                    }
                }

                Rectangle
                {
                    height: 55
                    color: "transparent"
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 36
                    visible: types.currentText === "VPN"

                    ListModel
                    {
                        id: ordersModelContinent
//                        ListElement{continent: "None"}
                        ListElement{continent: "Africa"}
                        ListElement{continent: "Europe"}
                        ListElement{continent: "North America"}
                        ListElement{continent: "South America"}
                        ListElement{continent: "Southeast Asia"}
                        ListElement{continent: "Asia"}
                        ListElement{continent: "Oceania"}
                        ListElement{continent: "Antarctica"}
                    }

                    DapCustomComboBox {
                        id: continent
                        anchors.fill: parent
                        model: ordersModelContinent
                        backgroundColorShow: currTheme.secondaryBackground
                        defaultText: qsTr("Continent")
                        mainTextRole: "continent"
                        font: mainFont.dapFont.regular16
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

                    Layout.minimumHeight: 64
                    Layout.maximumHeight: 64
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Layout.bottomMargin: 12
                    Layout.maximumWidth: 281
                    color: currTheme.neon
                    text: ""
                    font: mainFont.dapFont.regular14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    visible: true
                }

                DapButton
                {
                    implicitHeight: 36
                    implicitWidth: 163

                    Layout.bottomMargin: 40
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    textButton: qsTr("Create new Order")
                    fontButton: mainFont.dapFont.medium14
                    horizontalAligmentText:Qt.AlignCenter
                    onClicked:{


                        if(types.displayText === "VPN")
                        {
                            if(networks.displayText === "Networks")
                            {
                                error.text = qsTr("Please select network.")
                            }
                            else
                            if (textInputPrice.text === "" || textInputPrice.text === "0" || textInputPrice.text === "0.0")
                            {
                                error.text = qsTr("Please input price.")
                            }
                            else
                            if (textInputUnits.text === "" || textInputPrice.text === "0" )
                            {
                                error.text = qsTr("Please input amount units.")
                            }
                            else
                            if (textInputNodeAddr.text === "")
                            {
                                error.text = qsTr("Please input node address in selected network: ") + networks.currentText
                            }
                            else
                            if (certificate.displayText === "Certificates")
                            {
                                error.text = qsTr("Please select certifiacte.")
                            }
                            else
                            if (textInputRegion.text === "")
                            {
                                error.text = qsTr("Please input region.")
                            }
                            else
                            if (continent.displayText === "Continent" || continent.displayText === "None")
                            {
                                error.text = qsTr("Please select continent.")
                            }
                            else
                            {
                                error.text = ""

                                console.log("Create new VPN order")
                                console.log("Network "     + networks.currentText)
                                console.log("Cert "        + certificate.currentText)
                                console.log("Price "       + textInputPrice.text)
                                console.log("Price Unit "  + priceUnit.currentText)
                                console.log("Price Token " + priceToken.currentText)
                                console.log("Units "       + textInputUnits.text)
                                console.log("Node Addr "   + textInputNodeAddr.text)
                                console.log("Region "      + textInputRegion.text)
                                console.log("Continent "   + continent.currentText)

                                var argsRequest = logicMainApp.createRequestToService
                                        ("createVPNOrder",
                                         networks.displayText,
                                         "sell", "1",
                                         textInputPrice.text,
                                         priceUnit.displayText,
                                         priceToken.displayText,
                                         textInputUnits.text,
                                         textInputNodeAddr.text,
                                         certificate.displayText,
                                         textInputRegion.text,
                                         continent.displayText)


                                ordersModule.createVPNOrder(argsRequest)

                            }
                        }
                        else if(types.displayText === "Stake")
                        {
                            if(networks.displayText === "Networks")
                            {
                                error.text = qsTr("Please select network.")
                            }
                            else
                            if (textInputValue.text === "" || textInputValue.text === "0" || textInputValue.text === "0.0")
                            {
                                error.text = qsTr("Please input fee value.")
                            }
                            else
                            if (certificate.displayText === "Certificates")
                            {
                                error.text = qsTr("Please select certifiacte.")
                            }
                            else
                            {
                                error.text = ""

                                console.log("Create new Stake order")
                                console.log("Network "     + networks.displayText)
                                console.log("Value "       + textInputValue.text)
                                console.log("Cert "        + certificate.displayText)

                                var argsRequest = logicMainApp.createRequestToService
                                        ("DapCreateStakeOrder",
                                          networks.displayText,
                                          textInputValue.text,
                                          certificate.displayText)

                                ordersModule.createStakeOrder(networks.displayText, textInputValue.text, certificate.displayText)
                            }
                        }
                    }
                }
            }
        }
    }

    Connections
    {
        target: ordersModule
        function onSigCreateVPNOrder(order)
        {
            console.log(order)
            logicOrders.commandResult.success = order.success
            logicOrders.commandResult.message = order.message

            navigator.done()
        }

        function onSigCreateStakeOrder(order)
        {
            console.log(order)

            logicOrders.commandResult.success = order.success
            logicOrders.commandResult.message = order.message

            navigator.done()
        }
    }
}




