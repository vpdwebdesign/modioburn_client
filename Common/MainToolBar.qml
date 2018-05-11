import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import ModioBurn.Tools 1.0

ToolBar {
    id: mainToolBar

    property alias currentPageTitle: toolBarTitle.text
    property int messageCount: 0
    property int shoppingCartItems: 0
    property bool videoPlayingIconVisible: false
    property bool videoItemsCountVisible: false
    property bool audioPlayingIconVisible: false
    property bool audioItemsCountVisible: false

    RowLayout {
        anchors.fill: parent
        spacing: 5

        ToolButton {
            id: back
            contentItem: Image {
                fillMode: Image.Pad
                source: "qrc:/assets/icons/back.png"
            }
            visible: (loggedIn && mainView.depth > 2) || (!loggedIn && mainView.depth > 1)
            enabled: (loggedIn && mainView.depth > 2) || (!loggedIn && mainView.depth > 1)
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Back")
            onClicked: function() {
                mainView.pop();
            }
        }

        ToolButton {
            id: help
            contentItem: Image {
                fillMode: Image.Pad
                source: "qrc:/assets/icons/help.png"
            }
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Help")
            onClicked: helpMenu.open()

            Menu {
                id: helpMenu
                x: parent.width - width
                y: parent.height
                transformOrigin: Menu.TopLeft

                MenuItem {
                    text: "Modio Burn Tutorial"
                    onTriggered: notYet.open()
                }
                MenuItem {
                    text: "About"
                    onTriggered: aboutDialog.open()
                }
            }
        }

        ToolButton {

            id: messages
            contentItem: Image {
                fillMode: Image.Pad
                source: "qrc:/assets/icons/notifications.png"
            }
            visible: loggedIn && userManager.role.hasPermission("read message")
            enabled: loggedIn && userManager.role.hasPermission("read message")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Notifications")
            onClicked: notificationsDialog.open()
        }

        NotificationIcon {
            id: notificationsFlasher
            x: messages.x + (messages.width - 10)
            y: messages.y + Math.round(messages.height / 3)
            z: 1
            opacity: (messages.enabled && messageCount > 0) ? 1.0 : 0.0
            iconSize: 20
            notificationNum: messageCount
        }

        ToolButton {
            id: cartButton
            contentItem: Image {
                fillMode: Image.Pad
                source: "qrc:/assets/icons/cart.png"
            }
            visible: loggedIn
            enabled: loggedIn
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Shopping Cart")
            onClicked: {
                if (mainView.currentItem.objectName != "cartPane")
                    mainView.push("../Cart.qml")
            }
        }

        NotificationIcon {
            id: cartItemCount
            x: cartButton.x + (cartButton.width - 10)
            y: cartButton.y + Math.round(cartButton.height / 3)
            z: 1
            opacity: (cartButton.enabled && shoppingCartItems > 0) ? 1.0 : 0.0
            iconSize: 20
            notificationNum: shoppingCartItems
            runTimer: false
        }


        ToolButton {
            id: systemStatusButton
            contentItem: Image {
                fillMode: Image.Pad
                source: "qrc:/assets/icons/system2.png"
            }
            visible: loggedIn && userManager.role.hasPermission("check system status")
            enabled: loggedIn && userManager.role.hasPermission("check system status")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Check system status")
            onClicked: notYet.open()
        }

        Label {
            id: toolBarTitle
            font.pixelSize: 26
            text: "Modio Burn"
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            Layout.fillWidth: true

        }

        ToolButton {
            id: videoPlayingIcon
            contentItem: Image {
                fillMode: Image.Pad
                source: "qrc:/assets/icons/videoplayer.png"
            }
            visible: loggedIn && userManager.role.hasPermission("play video") && videoPlayingIconVisible
            enabled: loggedIn && userManager.role.hasPermission("play video") && videoPlayingIconVisible
            ToolTip.visible: hovered
            ToolTip.text: "ModioBurn Video Player"
            onClicked: {
                vpWin.showNormal()
                vpWin.requestActivate()
            }
        }

        NotificationIcon {
            x: videoPlayingIcon.x + (videoPlayingIcon.width - 10)
            y: videoPlayingIcon.y + Math.round(videoPlayingIcon.height / 3)
            z: 1
            opacity: (videoPlayingIcon.enabled && videoItemsCountVisible) ? 1.0 : 0.0
            iconSize: 20
            notificationNum: 1
            runTimer: false
        }

        ToolButton {
            id: audioPlayingIcon
            contentItem: Image {
                fillMode: Image.Pad
                source: "qrc:/assets/icons/musicplayer.png"
            }
            visible: loggedIn && userManager.role.hasPermission("play audio") && audioPlayingIconVisible
            enabled: loggedIn && userManager.role.hasPermission("play audio") && audioPlayingIconVisible
            ToolTip.visible: hovered
            ToolTip.text: "ModioBurn Audio Player"
            onClicked: {
                apWin.showNormal()
                apWin.requestActivate()
            }
        }

        NotificationIcon {
            x: audioPlayingIcon.x + (audioPlayingIcon.width - 10)
            y: audioPlayingIcon.y + Math.round(audioPlayingIcon.height / 3)
            z: 1
            opacity: (audioPlayingIcon.enabled && audioItemsCountVisible) ? 1.0 : 0.0
            iconSize: 20
            notificationNum: 1
            runTimer: false
        }

        ToolButton {
            id: roleDisplay

            contentItem: Text {
                id: roleDisplayText
                font.pixelSize: 12
                text: role.toUpperCase()
                color: "#2e2f30"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 80
                implicitHeight: 20
                radius: 15
                color: "white"
            }

            visible: loggedIn
            enabled: loggedIn
        }

        ToolButton {
            id: timer
            contentItem: Image {
                fillMode: Image.Pad
                source: "qrc:/assets/icons/timer.png"
            }
            visible: loggedIn && ((role === "customer") || (role === "guest"))
            enabled: loggedIn && ((role === "customer") || (role === "guest"))
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Cost: ") + mbTimer.cost
            onClicked: costTimerDialog.open()
        }

        ToolButton {
            id: userAccountButton
            contentItem: Image {
                fillMode: Image.Pad
                source: "qrc:/assets/icons/user.png"
            }
            visible: loggedIn
            enabled: loggedIn
            ToolTip.visible: hovered
            ToolTip.text: qsTr("User Account")
            onClicked: userAccountMenu.open()

            Menu {
                id: userAccountMenu
                x: parent.width - width
                y: parent.height
                transformOrigin: Menu.TopRight

                MenuItem {
                    text: "Settings"
                    onTriggered: notYet.open()
                }
                MenuItem {
                    text: "Logout (" + username + ")"
                    onTriggered: logoutDialog.open()
                }
            }
        }

        ToolButton {
            id: shutdownButton
            contentItem: Image {
                fillMode: Image.Pad
                source: "qrc:/assets/icons/power.png"
            }
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Shut Down Modio Burn")
            onClicked: function() {
                shutdownDialog.open()
            }

            visible: loggedIn && userManager.role.hasPermission("shut system down")
            enabled: loggedIn && userManager.role.hasPermission("shut system down")
        }


        ToolSeparator {
            opacity: loggedIn ? 1.0 : 0.0
        }

        ToolButton {
            id: clock
            anchors.right: parent.right
            anchors.rightMargin: 5

            contentItem: Text {
                id: timerText
                text: mbTimer.clock
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 40
                implicitHeight: 40
                color: "transparent"
                border.color: "#cccccc"
            }
        }
    }

    Dialog {
        id: notificationsDialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 350
        height: 200
        parent: ApplicationWindow.overlay

        modal: true
        title: "Notifications"
        standardButtons: Dialog.Close

        Row {
            id: upperRow
            width: parent.width
            anchors.top: parent.top
            spacing: 20

            Label {
                font.pixelSize: 15
                text: "You have 0 notifications"
                anchors.verticalCenter: parent.verticalCenter
            }

            Button {
                text: "View"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: notYet.open()
            }
        }

    }

    Dialog {
        id: aboutDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 320
        parent: ApplicationWindow.overlay

        modal: true
        title: "Modio Burn Version 1.0"
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
                text: "Modio Burn is a state of the art Media Management and Accounting tool. "
                    + "The Modio Burn End User License is a two-in-one licensing solution "
                    + "applicable for single-user and multi-user setups. Please read "
                    + "LICENSE.pdf in the setup disc to learn more about the Modio Burn End User License.\n"
                    + "\nModio Burn is a product of KitiSoft Apps, Ltd."
                wrapMode: Label.Wrap
            }
        }
    }
}

