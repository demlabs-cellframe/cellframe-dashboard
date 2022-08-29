import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "RightPanels"
import "logic"

RowLayout
{
    property string openOrders: "../OpenOrders.qml"
    property string ordersHistory: "../OrdersHistory.qml"
    property string detailOpen: "../RightPanels/DetailsOpen.qml"
    property string detailHistory: "../RightPanels/DetailsHistory.qml"

    property string currentPair: "All pairs"
    property string currentSide: "Both"
    property string currentPeriod: "All time"
    property bool isInitCompleted: false

    signal setCurrentMainScreen(var screen)
    signal setFilterSide(var side)
    signal setFilterPair(var pair)
    signal setFilterPeriod(var period)
    signal closedDetailsSignal()
    signal initCompleted()

    ListModel{id: bufferDetails}
    ListModel{id: checkingBufferDetails}
    ListModel{id: pairModelFilter}
    ListModel{id: openModel}
    ListModel{id: historyModel}
    Item{id: emptyRightPanel}

    LogicMyOrders{id: logic}

    id: myOrdersTab

    onSetCurrentMainScreen: logic.changeMainPage(screen)

    Component.onCompleted: {

        dapServiceController.requestToService("DapGetXchangeTxList", "GetOrdersPrivate", net, addr, "", "")

        logic.initOrdersModels()
        logic.initPairModelFilter()
        logic.changeMainPage(openOrders)
        logic.changeRightPanel(emptyRightPanel)
        initCompleted()
        isInitCompleted = true
    }

    onSetFilterPair: {
        currentPair = pair
        logic.filtrResults()
    }

    onSetFilterSide: {
        currentSide = side
        logic.filtrResults()
    }

    onSetFilterPeriod: {
        currentPeriod = period
        logic.filtrResults()
    }

    anchors.fill: parent
    spacing: 20

    ColumnLayout
    {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 20

        DapRectangleLitAndShaded
        {
            id: mainFrame
            Layout.fillWidth: true
            Layout.fillHeight: true

            color: currTheme.backgroundElements
            radius: currTheme.radiusRectangle
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:
                StackView {
                    id: screenStackView
                    anchors.fill: parent
                    clip: true
                }

        }
    }

    DefaultRightPanel
    {
        id: defaultRightPanel
        Layout.minimumWidth: 350
        Layout.fillHeight: true
    }

    DapRectangleLitAndShaded
    {
        id: rightFrame
        visible: false
        Layout.minimumWidth: 350
        Layout.fillHeight: true

        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            StackView {
                id: rightStackView
                anchors.fill: parent
                clip: true

                pushExit: Transition {
                    id: pushExit
                    PropertyAction { property: "x"; value: pushExit.ViewTransition.item.pos }
                }
                popEnter: Transition {
                    id: popEnter
                    PropertyAction { property: "x"; value: popEnter.ViewTransition.item.pos }
                }

                pushEnter: Transition {
                    PropertyAnimation {
                        property: "x"
                        easing.type: Easing.Linear
                        from: 350
                        to: 0
                        duration: 350
                    }
                }
                popExit: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: 0
                        to: 350
                        duration: 350
                    }
                }
            }
    }
}
