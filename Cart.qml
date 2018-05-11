import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import ModioBurn.Tools 1.0

import "Common"

Pane {

    objectName: "cartPane" // identifies object by name in Stackview. Useful for checking if current stackview item
                           // is a given object

    property string pageTitle: qsTr("Shopping Cart")

    property string cartItemsRectangleColor: "transparent"
    property int cartItemsRectangleHeight: 50

    ParentModel {
        id: cartModel
    }

    CartBar {
        id: cartBar
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
//        width: Math.round(0.3 * parent.width)
        visible: (transactionsModel.cartItemCount > 0)
    }

    ListView {
        id: cartListView
        anchors.top: cartBar.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: buttonRow.top
        anchors.bottomMargin: 20
        clip: true
        model: transactionsModel
        delegate: cartItemsDelegate
        ScrollBar.vertical: ScrollBar {
            active: true
        }

        visible: (transactionsModel.cartItemCount > 0)
    }

    Component {
        id: cartItemsDelegate

        ColumnLayout {
            anchors.left: parent.left
            anchors.leftMargin: 20

            RowLayout {
                Layout.fillWidth: true
                height: cartItemsRectangleHeight + 20
                spacing: 10

                Rectangle {
                    width: 50
                    height: cartItemsRectangleHeight
                    color: cartItemsRectangleColor

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: String(index + 1)
                        font.pixelSize: 15
                        width: parent.width - 5
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    width: 80
                    height: cartItemsRectangleHeight
                    color: cartItemsRectangleColor

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: model.itemType
                        font.pixelSize: 15
                        width: parent.width - 5
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    width: 180
                    height: cartItemsRectangleHeight
                    color: cartItemsRectangleColor

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: model.itemName
                        font.pixelSize: 15
                        width: parent.width - 5
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    width: 120
                    height: cartItemsRectangleHeight
                    color: cartItemsRectangleColor

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: model.quantity
                        font.pixelSize: 15
                        width: parent.width - 5
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    width: 120
                    height: cartItemsRectangleHeight
                    color: cartItemsRectangleColor

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: model.pricePerUnit
                        font.pixelSize: 15
                        width: parent.width - 5
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    width: 120
                    height: cartItemsRectangleHeight
                    color: cartItemsRectangleColor

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: model.totalCost
                        font.pixelSize: 15
                        width: parent.width - 5
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: copyMediumRectangle
                    width: 120
                    height: cartItemsRectangleHeight
                    color: cartItemsRectangleColor

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: model.copyMedium
                        font.pixelSize: 15
                        width: parent.width - 5
                        wrapMode: Text.WordWrap
                    }
                }

                Button {
                    anchors.left: copyMediumRectangle.right
                    anchors.verticalCenter: copyMediumRectangle.verticalCenter
                    text: "delete"
                    onClicked: shoppingCart.removeItemAt(index)
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20
                height: 1
                color: "#bfbfbf"
                opacity: 0.3
            }
        }
    }

    Rectangle {
        id: cartEmptyRectangle
        width: 220
        height: 80
        radius: 20
        anchors.centerIn: parent
        visible: (transactionsModel.cartItemCount <= 0)
        opacity: 1.0
        color: "#d55c5c"

        Label {
            anchors.centerIn: parent
            font.pixelSize: 30
            color: "#f2f2f2"
            text: "Cart Empty"
        }

        Timer {
            id: flashingTimer
            interval: 700
            repeat: true
            running: cartEmptyRectangle.visible
            onTriggered: function() {
                if (cartEmptyRectangle.opacity == 1.0) {
                    cartEmptyRectangle.opacity = 0.0
                } else {
                    cartEmptyRectangle.opacity = 1.0
                }
            }
        }
    }

    RowLayout {
        id: buttonRow
        width: Math.round(parent.width / 2)
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            Layout.fillWidth: true
            text: "checkout"
            onClicked: {
                paymentOptionPopup.open()
            }
            enabled: (transactionsModel.cartItemCount > 0)
        }
        Button {
            Layout.fillWidth: true
            text: "clear cart"
            onClicked: shoppingCart.clearCart()
            enabled: (transactionsModel.cartItemCount > 0)
        }
    }

    Popup {
        id: paymentOptionPopup
        x: Math.round((mainAppWindow.width / 2) - (width / 2))
        y: Math.round((mainAppWindow.height / 2) - (height / 2))
        closePolicy: "NoAutoClose"

        ColumnLayout {
            spacing: 20

            Label {
                Layout.fillWidth: true
                font.bold: true
                font.pixelSize: 16
                text: "Please select a payment option"
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                Label {
                    text: "Payment Option"
                }
                ComboBox {
                    id: paymentOptionSelector
                    implicitWidth: 200
                    model: cartModel.paymentMethodsModel
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Button {
                    Layout.fillWidth: true
                    text: "Close"
                    onClicked: paymentOptionPopup.close()
                }
                Button {
                    Layout.fillWidth: true
                    text: "OK"
                    onClicked: {
                        shoppingCart.paymentMethod = paymentOptionSelector.currentText
                        shoppingCart.checkoutItems()
                        paymentOptionPopup.close()
                    }
                }
            }
        }
    }
}
