import QtQuick 2.7
import QtQuick.Controls 2.0

Item {

    property int iconSize: 100
    property int notificationNum
    property alias timerInterval: flashTimer.interval
    property bool runTimer: true
    property color iconBgColor: "red"

    Rectangle {
        id: flashingIcon
        radius: 50
        height: iconSize
        width: iconSize
        color: iconBgColor
        opacity: 1.0
        anchors.centerIn: parent

        Label {
            id: notificationNumber
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: Math.round(0.8 * iconSize)
            text: String(notificationNum)
        }

        Timer {
            id: flashTimer
            interval: 500
            repeat: true
            running: runTimer
            onTriggered: function() {
                if (flashingIcon.opacity == 1.0) {
                    flashingIcon.opacity = 0.0
                } else {
                    flashingIcon.opacity = 1.0
                }
            }
        }
    }
}

