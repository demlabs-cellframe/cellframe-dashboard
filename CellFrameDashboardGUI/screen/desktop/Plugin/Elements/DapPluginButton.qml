import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Button
{
    ///@detalis heightButton Button height.
    property int heightButton
    ///@detalis widthButton Button width.
    property int widthButton
    ///@detalis textButton Text button.
    property string textButton
    ///@detalis fontButton Font setting.
    property alias fontButton: buttonText.font
    ///@detalis horizontalAligmentText Horizontal alignment.
    property alias horizontalAligmentText:buttonText.horizontalAlignment
    ///@detalis colorTextButton This property overrides the color of the text.
    property alias colorTextButton: buttonText.color

    property alias radius: dapBackgroundButton.radius

    id: dapButton

    ///@details empty default background
    background: Item { id:background }

    contentItem:
        Rectangle
        {
            id: dapBackgroundButton
            anchors.fill: parent
            LinearGradient
            {
                anchors.fill: parent
                source: parent
                start: Qt.point(0,parent.height/2)
                end: Qt.point(parent.width,parent.height/2)
                gradient:
                    Gradient {
                        GradientStop
                        {
                            position: 0;
                            color: dapButton.enabled ?
                                   dapButton.hovered ? "#E62083" :
                                                       "#C91D73" :
                                                       "#2E3138"
                        }
                        GradientStop
                        {
                            position: 1;
                            color:  dapButton.enabled ?
                                    dapButton.hovered ? "#E62263" :
                                                        "#D51F5D" :
                                                        "#2E3138"
                        }
                    }
            }

            implicitWidth: widthButton
            implicitHeight: heightButton

            ///button text
            Text
            {
                id: buttonText
                anchors.fill: parent
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignRight
                color: currTheme.textColor
                text: qsTr(textButton)
            }
        }
    DropShadow {
        anchors.fill: dapBackgroundButton
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
        samples: 32
        color: "#2A2C33"
        source: dapBackgroundButton
        smooth: true
        }
}
