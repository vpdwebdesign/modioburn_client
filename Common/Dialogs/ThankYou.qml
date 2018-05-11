import QtQuick 2.9
import QtQuick.Controls 2.2

Dialog {
    id: thankYou
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: 320
    parent: ApplicationWindow.overlay

    modal: true
    title: "Thank You"
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
            text: "Thank you for using ModioBurn. Enjoy your purchases and come back again soon."
            wrapMode: Label.Wrap
        }
    }
}
