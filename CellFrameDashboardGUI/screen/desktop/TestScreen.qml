import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4 as OldControls
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/"
import "../"
import "qrc:/widgets"

DapAbstractScreen {

    dapFrame.color: currTheme.backgroundMainScreen

    Rectangle
    {
        id: testFrame
        anchors.fill: parent
        anchors.margins: 24 * pt
        anchors.rightMargin: 0 * pt
        color: currTheme.backgroundElements
        radius: 16*pt
        ListView
        {
            id: listViewSettings
            anchors.fill: parent
//            anchors.topMargin: 35 * pt
            anchors.leftMargin: 20 * pt
            model: modelTest
            clip: true
        }
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: testFrame
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: testFrame
    }
    InnerShadow {
        anchors.fill: testFrame
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
    }

    Page {
        id: newPage

        background: Rectangle {
            color: "Black"
        }
    }

    VisualItemModel
    {
        id: modelTest

        RowLayout {
            Button {
                Layout.topMargin: 20 * pt
                text: "Red"
                onClicked: {
                    testTabView.currentIndex = 0
                }
            }
            Button {
                Layout.topMargin: 20 * pt
                text: "Blue"
                onClicked: {
                    testTabView.currentIndex = 1
                }
            }
            Button {
                Layout.topMargin: 20 * pt
                text: "Green"
                onClicked: {
                    testTabView.currentIndex = 2
                }
            }
        }

        OldControls.TabView {
            id: testTabView
            tabPosition: Qt.BottomEdge

            tabsVisible: false
            OldControls.Tab {
                title: "Red"
                Rectangle { color: "red" }
                Component.onCompleted: {
                    console.info("RED TAB CREATED")
                }
                Component.onDestruction: {
                    console.info("RED TAB DESTROYED")
                }
            }
            OldControls.Tab {
                title: "Blue"
                StackView {
                    id: testStack
                    anchors.fill: parent
                    initialItem: blueRect
                    replaceEnter: Transition {
                        PropertyAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 300
                        }
                    }
                    replaceExit: Transition {
                        PropertyAnimation {
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 250
                        }
                    }
                }

                Page {
                    id: blueRect

                    Rectangle {
                        width: blueRect.width / 2
                        height: blueRect.height
                        anchors {
                            top: parent.top
                            left: parent.left
                        }

                        color: "blue"
                    }
                    Rectangle {
                        width: blueRect.width / 2
                        height: blueRect.height
                        anchors {
                            top: parent.top
                            right: parent.right
                        }
                        color: "yellow"
                    }

                    Button {
                        text: "ADD"
                        anchors.centerIn: parent
                        onClicked: {
                            push(newPage)
                        }
                    }

                    Component.onCompleted: {
                        console.info("BLUE TAB CREATED")
                    }
                    Component.onDestruction: {
                        console.info("BLUE TAB DESTROYED")
                    }
                }
            }
            OldControls.Tab {
                title: "Green"
                Rectangle { color: "green" }
                Component.onCompleted: {
                    console.info("GREEN TAB CREATED")
                }
                Component.onDestruction: {
                    console.info("GREEN TAB DESTROYED")
                }
            }
        }

        DapComboBoxNew {
            id: testComboBoxNew
            model: ["test1","test2","test3","test4"]
//            model: [
//                {
//                    "name": "test1"
//                },
//                {
//                    "name": "test2"
//                },
//                {
//                    "name": "test3"
//                },
//                {
//                    "name": "test4"
//                }
//            ]
        }

        RowLayout
        {
            Switch{
                id: themeSwitch
                text: "Test Theme"
                Layout.alignment: Qt.AlignCenter
                onPositionChanged:
                {
                    if(currThemeVal)
                        currThemeVal = false
                    else
                        currThemeVal = true
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: currTheme.textColor
                    verticalAlignment: Text.AlignVCenter


                    leftPadding: parent.indicator.width + parent.spacing
                }

            }
        }

        RowLayout
        {

            spacing: 20 * pt

            DapButton
            {
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 15 * pt
                implicitHeight: 36 * pt
                implicitWidth: 250 * pt
                textButton: qsTr("Test button active")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                colorBackgroundHover: currTheme.buttonColorHover
                colorBackgroundNormal: currTheme.buttonColorNormal
                colorButtonTextNormal: currTheme.textColor
                colorButtonTextHover: currTheme.textColor
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }

            DapButton
            {
                enabled: false
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 15 * pt
                implicitHeight: 36 * pt
                implicitWidth: 250 * pt
                textButton: qsTr("Test button no active")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                colorBackgroundHover: currTheme.buttonColorNoActive
                colorBackgroundNormal: currTheme.buttonColorNoActive
                colorButtonTextNormal: currTheme.textColor
                colorButtonTextHover: currTheme.textColor
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }
        }

        RowLayout
        {
            DapTextField
            {
                Layout.topMargin: 30 * pt
                id: textInputAmountPayment
                Layout.fillWidth: true
                width: 150 * pt
                height: 28 * pt
                placeholderText: qsTr("Test Text Field")
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                horizontalAlignment: Text.AlignRight
                borderWidth: 1 * pt
                borderRadius: 5 * pt
            }
        }



        Rectangle
        {
//            height: 50 * pt
//            Layout.topMargin: 30 * pt
            Layout.fillWidth: true
            color: "transparent"
            height: 80 * pt
            width: 250 * pt
            DapComboBox
            {
                anchors.fill: parent
                anchors.topMargin: 30 * pt
                comboBoxTextRole: ["name"]
                mainLineText: "private"
                indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                sidePaddingNormal: 19 * pt
                sidePaddingActive: 19 * pt
                widthPopupComboBoxNormal: 250 * pt
                widthPopupComboBoxActive: 250 * pt
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 42 * pt
                topEffect: false
                x: sidePaddingNormal
                normalColor: currTheme.backgroundMainScreen
                hilightTopColor: currTheme.backgroundMainScreen
                hilightColor: currTheme.buttonColorNormal
                normalTopColor: currTheme.backgroundMainScreen
                paddingTopItemDelegate: 8 * pt
                heightListElement: 42 * pt
                indicatorWidth: 24 * pt
                indicatorHeight: indicatorWidth
                colorDropShadow: currTheme.shadowColor
                roleInterval: 15
                endRowPadding: 37
                fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
                colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                alignTextComboBox: [Text.AlignLeft, Text.AlignRight]
                model: dapModelWallets
            }
        }

        RowLayout
        {
            height: 50 * pt
            Text
            {
                Layout.topMargin: 30 * pt
                Layout.leftMargin: 5 * pt
                Layout.fillWidth: true
                verticalAlignment: Qt.AlignVCenter
                text:"Test Text"
                font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular18
                color: currTheme.textColor
            }
        }
        RowLayout
        {
            height: 46 * pt
            DapCheckBox
            {
                id: buttonUseExestingWallet
//                anchors.fill: parent
                Layout.fillWidth: true
                Layout.fillHeight: true
//                anchors.leftMargin: 22 * pt
//                height: 46 * pt

                nameCheckbox: qsTr("Test Check Box")
                fontCheckbox: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                nameTextColor: currTheme.textColor

                checkboxOn:"qrc:/resources/icons/" + pathTheme + "/ic_checkbox_on.png"
                checkboxOff:"qrc:/resources/icons/" + pathTheme + "/ic_checkbox_off.png"

                indicatorInnerSize: 46 * pt
            }
        }
        RowLayout
        {
            spacing: 100 * pt
//            anchors.fill: parent
            DapRadioButton
            {
                nameRadioButton: qsTr("Test Radio Button 1")
                indicatorInnerSize: 46 * pt
                spaceIndicatorText: 3 * pt
                implicitHeight: indicatorInnerSize
                fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }
            DapRadioButton
            {
                nameRadioButton: qsTr("Test Radio Button 2")
                checked: true
                indicatorInnerSize: 46 * pt
                spaceIndicatorText: 3 * pt
                fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                implicitHeight: indicatorInnerSize
            }
        }
    }
}
