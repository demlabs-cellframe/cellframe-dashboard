import QtQml 2.2
import QtQuick 2.0

Canvas {
    id: canvas
    width: 130
    height: 130
//    width: 200
//    height: 200
    antialiasing: true

//    property color primaryColor: "orange"
//    property color secondaryColor: "lightblue"
    property color primaryColor: currTheme.white
    property color secondaryColor: currTheme.mainButtonColorNormal0

    property real centerWidth: width / 2
    property real centerHeight: height / 2
    property real radius: Math.min(canvas.width-20, canvas.height-20) / 2

    property real minimumValue: 0
    property real maximumValue: 100
    property real currentValue: 0

    property real angle: (currentValue - minimumValue) / (maximumValue - minimumValue) * 2 * Math.PI

    property real angleOffset: -Math.PI / 2

    property string text: "Text"

    signal clicked()

    onPrimaryColorChanged: requestPaint()
    onSecondaryColorChanged: requestPaint()
    onMinimumValueChanged: requestPaint()
    onMaximumValueChanged: requestPaint()
    onCurrentValueChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d");
        ctx.save();

        ctx.clearRect(0, 0, canvas.width, canvas.height);
//        if (mouseArea.pressed) {
//            ctx.beginPath();
//            ctx.lineWidth = 1;
//            ctx.fillStyle = Qt.lighter(canvas.secondaryColor, 1.25);
//            ctx.arc(canvas.centerWidth,
//                    canvas.centerHeight,
//                    canvas.radius,
//                    0,
//                    2*Math.PI);
//            ctx.fill();
//        }

        ctx.beginPath();
        ctx.lineWidth = 5;
        ctx.strokeStyle = primaryColor;
        ctx.arc(canvas.centerWidth,
                canvas.centerHeight,
                canvas.radius,
                angleOffset + canvas.angle,
                angleOffset + 2*Math.PI);
        ctx.stroke();

        ctx.beginPath();
        ctx.lineWidth = 15;
        ctx.strokeStyle = canvas.secondaryColor;
        ctx.arc(canvas.centerWidth,
                canvas.centerHeight,
                canvas.radius,
                canvas.angleOffset,
                canvas.angleOffset + canvas.angle);
        ctx.stroke();

        ctx.restore();
    }

    Text {
        anchors.centerIn: parent

        text: canvas.text
        color: currTheme.white
        font:  mainFont.dapFont.bold14
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: canvas.clicked()
        onPressedChanged: canvas.requestPaint()
    }
}
