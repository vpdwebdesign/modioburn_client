import QtQuick 2.9
import QtQuick.Controls 2.2

Item {

    property alias blinkerWidth: blinker.width
    property alias blinkerHeight: blinker.height
    property alias tStarted: randomTimer.running
    property string ledColor

    function getRandomInt(min, max) {
      min = Math.ceil(min);
      max = Math.floor(max);
      return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    Rectangle {
        id: blinker
        anchors.centerIn: parent
        color: "transparent"
    }

    Timer {
        property int duration: 1

        id: randomTimer
        interval: duration
        repeat: true
        onTriggered: function() {
            duration = getRandomInt(1, 500);
            if (blinker.color == "#00000000")
                blinker.color = ledColor
            else
                blinker.color = "#00000000"
        }
    }
}
