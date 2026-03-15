import QtQuick 6.6
import QtQuick.Layouts

Item {
    id: statRoot
    width: 22; height: 22
    
    property real value: 0 // 0.0 a 1.0
    property string icon: ""
    property color circleColor: accent

    onValueChanged: canvas.requestPaint()

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.color: fg
        border.width: 1
        opacity: 0.2
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.antialiasing = true;
            ctx.lineWidth = 2;
            ctx.strokeStyle = circleColor;
            ctx.lineCap = "round";
            ctx.beginPath();
            var startAngle = -0.5 * Math.PI;
            var endAngle = startAngle + (value * 2 * Math.PI);
            ctx.arc(width/2, height/2, (width/2) - 1, startAngle, endAngle, false);
            ctx.stroke();
        }
    }

    Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 1
        text: icon
        color: circleColor
        font.pixelSize: 10
    }
}
