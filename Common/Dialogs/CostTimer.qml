import QtQuick 2.9
import QtQuick.Controls 2.2

Dialog {
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: 320
    parent: ApplicationWindow.overlay

    modal: true
    title: "Time/Cost Details"
    standardButtons: Dialog.Close

    Column {
        id: column
        spacing: 20
        width: parent.width

        Image {
            id: logo
            width: parent.width / 2
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/assets/icons/logo2.png"
        }

        Label {
            width: parent.width
            font.pixelSize: 25
            font.bold: true
            text: mbTimer.elapsed
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Label.Wrap
        }

        Label {
            width: parent.width
            font.pixelSize: 27
            font.bold: true
            text: mbTimer.cost
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Label.Wrap
        }
    }
}
