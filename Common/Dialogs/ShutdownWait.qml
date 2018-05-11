import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Dialog {
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: 400
    height: 200
    parent: ApplicationWindow.overlay

    modal: true
    title: "Shutting down Modio Burn"
    onAboutToShow: shutdownWaitTextChangeTimer.start()

    ColumnLayout {
        spacing: 20
        Text {
            id: shutdownWaitText
            color: "#f3f3f4"
            text: "Beginning shutdown sequence. Please wait..."
        }

        Timer {
            id: shutdownWaitTextChangeTimer
            property int nextItem: 0
            property var shutdownSequenceList: [
            "Beginning shutdown sequence. Please wait...",
            "Logging out users...",
            "Logging out users...",
            "Disconnecting client devices...",
            "Disconnecting client devices...",
            "Transferring log data to Modio Burn Central Server...",
            "Transferring log data to Modio Burn Central Server...",
            "Transferring log data to Modio Burn Central Server...",
            "Shutting down...",
            "Shutting down..."
            ]
            interval: 1000
            repeat: true
            running: false
            onTriggered: function() {
                shutdownWaitText.text = shutdownSequenceList[nextItem];
                nextItem++;
            }
        }
    }

    ProgressBar {
        id: shutdownWaitProgress
        anchors.centerIn: parent
        indeterminate: true
    }
}
