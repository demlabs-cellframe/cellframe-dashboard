import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "Parts"
import "../controls"
import "qrc:/widgets"

Page {
    id: page
    title: qsTr("Wallet")
    background: Rectangle {color: currTheme.mainBackground }
    anchors.fill: parent
    hoverEnabled: true

    QMLClipboard{
        id: clipboard
    }

    property bool isHistoryRequest: false
    property bool isHasDataWallet: walletTokensModel.count > 0

    readonly property int horizBorder: 16
    readonly property int verticalSpacing: 20
    readonly property int tokenMinHeight: 240
    readonly property int lastActionsMinHeight: 220

    readonly property int sectionHeight: 60
    readonly property int elementHeight: 50

    property int historyModelCount: modelHistory.getCount()

    property bool shortHistoryView: (typeof (modelHistory) === "undefined" ||
                             modelHistory.getCount() <= 2 ? false : true)

    Component.onCompleted:
    {
        updateTokens()
        updateHistory()
        isHistoryRequest = txExplorerModule.isRequest
        isHasDataWallet = walletModule.isModel()
        setHeightTokenList()
    }

    ListView
    {
        id: networkMenu

        width: page.width - horizBorder*2
        height: 31

        x: horizBorder
        y: verticalSpacing

        clip: true
        orientation: ListView.Horizontal
        interactive: true

        model: walletModelInfo

        spacing: 12

        delegate:
        Rectangle
        {
            id: networkItemMenu
            width: nameNet.width + 32
            height: 30
            color: (walletModule.currentNetworkName === "" && index === 0) ||
                   walletModule.currentNetworkName === networkName || netArea.containsMouse ?
                       currTheme.lime : currTheme.secondaryBackground
            radius: 10

            Text {
                id: nameNet
                anchors.centerIn: parent
                elide: Text.ElideMiddle
                text: networkName
                font: mainFont.dapFont.medium13
                horizontalAlignment: Text.AlignHCenter
                color: (walletModule.currentNetworkName === "" && index === 0) ||
                       walletModule.currentNetworkName === networkName || netArea.containsMouse ?
                           currTheme.mainBackground : currTheme.white
            }

            MouseArea
            {
                id: netArea
                anchors.fill: parent
                hoverEnabled: true

                onClicked:
                {
                    if(walletModule.currentNetworkName !== networkName)
                    {
                        walletModule.currentNetworkName = networkName
                        networkMenu.currentIndex = index
                        showLastActions.isShow = false
                        showAllTokens.isShow = false
                        tokenView.forceLayout()
                        lastActionsView.forceLayout()

                        flickablePlace.contentY = 0
                    }
                }
            }
        }
    }

    Rectangle
    {
        id: addrWallet

        width: page.width - horizBorder*2
        height: 40

        x: horizBorder
        y: networkMenu.y + networkMenu.height + verticalSpacing

        color: currTheme.mainBackground
        border.width: 1
        border.color: currTheme.secondaryBackground

        radius: 12

        RowLayout{
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 0

            Text{
                text: walletModule.currentNetworkName + qsTr(" address:")
                font: mainFont.dapFont.regular14
                horizontalAlignment: Text.AlignHCenter
                color: currTheme.gray

            }

            Text{
                id: addrWalletText
                Layout.preferredWidth: 80
                text: walletModule.currentAddress
                font: mainFont.dapFont.regular14
                horizontalAlignment: Text.AlignHCenter
                color: currTheme.white
                elide: Text.ElideMiddle
            }

            Item{Layout.fillWidth: true}

            CopyButton
            {
                id: networkAddressCopyButton
                Layout.alignment: Qt.AlignRight
                popupText: qsTr("Address copied")
                onCopyClicked:
                    clipboard.setText(addrWalletText.text)
            }
        }
    }

    Flickable
    {
        id: flickablePlace
        width: page.width
        height: page.height - y

        x: 0
        y: addrWallet.y + addrWallet.height + verticalSpacing

        contentWidth: page.width
        contentHeight: mainLayout.height
        interactive: true
        clip: true


        Text
        {
            visible: walletTokensModel.count === 0

            width: parent.width

            x: 0
            y: 0

            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter

            color: currTheme.gray
            text: qsTr("There are no tokens yet")
            font: mainFont.dapFont.medium14
        }

        Item
        {
            id: mainLayout

            visible: isHasDataWallet

            width: parent.width
            height: showLastActionsContainer.y +
                    showLastActionsContainer.height + 100
            x: 0
            y: 0

            ListView
            {
                id: tokenView
                visible: walletTokensModel.count > 0
                property int tokenIndex: -1
                property int heightDelegate: 60

                width: parent.width
                x: 0
                y: 0

                model: walletTokensModel
                interactive: false

                clip: true

                spacing: 30

                delegate: TokensDelegate{}

                Behavior on height {
                    NumberAnimation{duration: 200}
                }
            }

            Rectangle
            {
                id: showAllTokensContainer
                width: parent.width
                color: "transparent"


                visible: walletTokensModel.count <= 3 ? false : true && walletTokensModel.count > 0
                height: visible ? 20 : 0

                x: 0
                y: tokenView.y + tokenView.height + (visible ? verticalSpacing : 0)

                ShowButton
                {
                    id: showAllTokens

                    width: parent.width
                    y: (parent.height - height)/2

                    text: isShow ?  qsTr("Show less tokens") : qsTr("Show all tokens")

                    onButtonClicked:
                    {
                        tokenView.height =
                                getHeight(showAllTokens.isShow,
                                          tokenMinHeight, tokenView.contentHeight)
                    }
                }
            }

            AnimatedImage
            {
                visible: !isHasDataWallet && isHistoryRequest && !walletModelInfo.size
                source: "qrc:/walletSkin/Resources/BlackTheme/icons/Loader.gif"

                width: 240
                height: 240

                playing: visible

                mipmap: true

                anchors.horizontalCenter: parent.horizontalCenter

                Text{
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 42

                    text: qsTr("Wallet loading...")
                    color: currTheme.gray
                    font: mainFont.dapFont.medium14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            ListView
            {
                id: lastActionsView

                visible: historyModelCount > 0

                property int heightDelegate: elementHeight
                property int heightSection: sectionHeight

                width: parent.width

                x: 0
                y: showAllTokensContainer.y +
                   showAllTokensContainer.height + verticalSpacing

                section.property: "date"
                section.criteria: ViewSection.FullString
                section.delegate: SectionDelegate{}

                spacing: 0

                model: modelHistory

                clip: true
                interactive: false

                delegate: LastActionsDelegate{}

                Behavior on height {
                    NumberAnimation{duration: 200}
                }
            }

            Rectangle
            {
                id: historyButton
                visible: historyModelCount > 0 && historyModelCount < fullModelHistory.count && (showLastActions.isShow || !showLastActionsContainer.visible)

                width: parent.width
                height: visible ? 50 : 0
                color: "transparent"

                x: 0
                y: lastActionsView.y + lastActionsView.height + 12

                DapButton
                {
                    x: horizBorder
                    y: (parent.height - height)/2

                    width: parent.width - horizBorder*2
                    height: 36

                    textButton: qsTr("See all transactions")

                    fontButton: mainFont.dapFont.medium14
                    horizontalAligmentText: Text.AlignHCenter

                    defaultColor: currTheme.secondaryBackground
                    defaultColorNormal0: currTheme.secondaryBackground
                    defaultColorNormal1: currTheme.secondaryBackground

                    opacityDropShadow: 0
                    opacityInnerShadow: 0
                    defaultColorHovered0: currTheme.grayDark
                    defaultColorHovered1: currTheme.grayDark

                    radius: 10

                    onClicked:
                    {
                        dapMainWindow.openHistory()
                    }
                }
            }

            Rectangle
            {
                id: showLastActionsContainer
                width: parent.width
                color: "transparent"

                visible: historyModelCount > 2
                height: visible ? 20 : 0

                x: 0
                y: historyButton.y + historyButton.height

                ShowButton
                {
                    id: showLastActions

                    visible: historyModelCount > 0

                    width: parent.width
                    y: (parent.height - height)/2

                    text: isShow ? qsTr("Show less transactions") : qsTr("Show more transactions")

                    onButtonClicked:
                    {
                        lastActionsView.height =
                                getHeight(showLastActions.isShow,
                                          lastActionsMinHeight, getLastActionsHeight())
                    }
                }

            }

            AnimatedImage
            {
                visible: !isHistoryRequest
                source: "qrc:/walletSkin/Resources/BlackTheme/icons/Loader.gif"

                width: 240
                height: 240

                mipmap: true

                playing: visible

                anchors.horizontalCenter: parent.horizontalCenter

                y: showAllTokensContainer.y +
                   showAllTokensContainer.height

                Text{
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 42

                    text: qsTr("History loading...")
                    color: currTheme.gray
                    font: mainFont.dapFont.medium14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        AnimatedImage
        {
            visible: !isHasDataWallet && !isHistoryRequest && isHasDataWallet//walletTokensModel.size

            source: "qrc:/walletSkin/Resources/BlackTheme/icons/Loader.gif"

            width: 240
            height: 240

            playing: visible

            mipmap: true

            y: (page.height - height)/4
            x: (page.width - width) /2

            Text{
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 42

                text: qsTr("Data loading...")
                color: currTheme.gray
                font: mainFont.dapFont.medium14
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

    }

    function getHeight(showAll, minHeight, realHeight)
    {
        if (!realHeight)
            return 0

        if (showAll)
            return realHeight

        if(realHeight < minHeight)
            return realHeight
        else
            return minHeight
    }

    function updateSize(item)
    {
        tokenView.forceLayout()
        lastActionsView.forceLayout()

        if(item === "wallets")
            tokenView.height =
                    getHeight(showAllTokens.isShow, tokenMinHeight, tokenView.contentHeight)
        else if(item === "history")
            lastActionsView.height =
                    getHeight(showLastActions.isShow, lastActionsMinHeight, getLastActionsHeight())
        else
        {
            tokenView.height =
                    getHeight(showAllTokens.isShow, tokenMinHeight, tokenView.contentHeight)
            lastActionsView.height =
                    getHeight(showLastActions.isShow, lastActionsMinHeight, getLastActionsHeight())
        }

        console.log("lastActionsView.height", lastActionsView.height)

    }

    function getLastActionsHeight()
    {
        var height = modelHistory.getLastDays() * sectionHeight +
                historyModelCount * elementHeight

        return height
    }

    function updateTokens()
    {
        isHasDataWallet = true
        showAllTokens.isShow = false
        tokenView.height = getHeight(showAllTokens.isShow,
                                          tokenMinHeight, tokenView.contentHeight)
        tokenView.forceLayout()
        mainLayout.visible = true;

        updateSize("wallets")        
    }

    function updateHistory()
    {
        historyModelCount = modelHistory.getCount()
        showLastActions.isShow = false
        lastActionsView.height = getHeight(showLastActions.isShow, lastActionsMinHeight, getLastActionsHeight())
        lastActionsView.forceLayout()
        updateSize("history")
    }

    Connections
    {
        target: walletModule
        function onTokenModelChanged()
        {
            updateTokens()
        }

        function onWalletsModelChanged()
        {
            updateTokens()
        }

        function onCurrentWalletChanged()
        {
            isHasDataWallet = false
            isHistoryRequest = false
            updateHistory()
        }

        function onCurrentNetworkChanged(networkName)
        {
            isHasDataWallet = false
        }

        function onСurrentDataChange()
        {
            isHasDataWallet = true
        }        
    }

    Connections
    {
        target: txExplorerModule
        function onUpdateHistoryModel()
        {
            isHistoryRequest = true
            updateSize("history")
        }
    }

    Connections
    {
        target: modelHistory
        function onCountChanged()
        {
            updateHistory()
        }
    }

    function setHeightTokenList()
    {
        var countTokenModel = walletTokensModel.count
        var visibleListHeight = (tokenView.heightDelegate * countTokenModel) + (tokenView.spacing * (countTokenModel - 1))
        if(visibleListHeight < 0)
        {
            visibleListHeight = 0
        }
    }

    Connections
    {
        target: walletTokensModel
        function onSizeChanged()
        {
            isHasDataWallet = true
            
            setHeightTokenList()
        }
    }
}
