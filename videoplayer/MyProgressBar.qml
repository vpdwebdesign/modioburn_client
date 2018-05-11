import QtQuick 2.10
import "utils.js" as Utils

Rectangle {
    id: root
    color: "#44eeeeee"
    radius: Utils.scaled(5)
    property alias value: grip.value
    property color lineColor: "#880000ee"
    property color gripColor: "white"
    property real gripSize: Utils.scaled(8)
    property real gripTolerance: Utils.scaled(3.0)
    property real increment: 0.1
    property bool showGrip: true
    property bool tracking: true
    signal valueChangedByUi
    signal hoverAt(real value)
    // dx, dy: only the direction. dx>0 means enter from left or leave to left
    signal enter(point pos, point dpos)
    signal leave(point pos, point dpos)

    Rectangle {
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        radius: parent.radius
        width: grip.x + grip.radius
        height: parent.height
        color: displayedColor(root.lineColor)
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (parent.width) {
                parent.value = mouse.x / parent.width
                valueChangedByUi(parent.value)
            }
        }
        onMouseXChanged: {
            hoverAt(mouseX/parent.width)
//time and preview
        }
        onEntered: {
            enter(Qt.point(mouseX, mouseY), Qt.point(0, mouseY > height/2 ? 1 : -1))
            hoverAt(mouseX/parent.width)
        }
        onExited: {
            leave(Qt.point(mouseX, mouseY), Qt.point(0, mouseY > height/2 ? 1 : -1))
        }
    }

    Rectangle {
        id: grip
        property real value: 0
        x: (value * parent.width - width/2)
        anchors.verticalCenter: parent.verticalCenter
        width: root.gripTolerance * root.gripSize
        height: parent.height
        radius: width/2
        color: "transparent"

        MouseArea {
            id: mouseArea
            enabled: root.enabled
            anchors.fill:  parent
            drag {
                target: grip
                axis: Drag.XAxis
                minimumX: -parent.width/2
                maximumX: root.width - parent.width/2
            }
            onPositionChanged:  {
                if (drag.active)
                    updatePosition()
            }
            onReleased: {
                updatePosition()
            }
            function updatePosition() {
                value = (grip.x + grip.width/2) / grip.parent.width
                valueChangedByUi(value)
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: root.gripSize
            height: parent.height
            radius: width/2
            color: root.showGrip ? root.gripColor : "transparent"
        }
    }

    function displayedColor(c) {
        var tint = Qt.rgba(c.r, c.g, c.b, 0.25)
        return enabled ? c : Qt.tint(c, tint)
    }
}
