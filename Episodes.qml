import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import ModioBurn.Tools 1.0

Pane {

    property string pageTitle: "Episodes - " + seriesTitleText + ", Season " + seriesSeasonText

    property string seriesThumb
    property string seriesTitleText
    property string seriesSeasonText

    property string currentlySelectedEpisode_number
    property string currentlySelectedEpisode_title

    // prices
    property real episodePrice: itemPriceManager.itemPrice("episode")
    property real dvdPrice: itemPriceManager.itemPrice("dvd")
    property real usbDiskPrice: 0.00

    property real ppu: 50.00 // pricePerUnit
    property real totalCost: 50.00


    ParentModel {
        id: parentModelEpisodes

        Component.onCompleted: {
            seriesTitle = seriesTitleText.toLowerCase()
            season = seriesSeasonText
            initEpisodesModel()
            episodesView.model = episodesModel
        }
    }

    RowLayout {
        id: seriesDataRow
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20

        Image {
            id: seriesThumbImage
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            source: seriesThumb
        }

        Label {
            id: seriesTitleText_
            font.pixelSize: 30
            anchors.left: seriesThumbImage.right
            anchors.leftMargin: 20
            anchors.top: parent.top
            text: seriesTitleText
        }

        Label {
            id: seriesSeasonText_
            font.pixelSize: 25
            anchors.top: seriesTitleText_.bottom
            anchors.topMargin: 20
            anchors.left: seriesThumbImage.right
            anchors.leftMargin: 20
            text: "Season " + seriesSeasonText
        }

    }

    RowLayout {
        id: episodesViewTopBar
        width: parent.width - 20
        anchors.top: seriesDataRow.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        Rectangle {
            id: episodeNumberColumn
            width: 100
            height: 30
            anchors.left: parent.left
            color: "teal"

            Text {
                text: qsTr("#")
                font.pixelSize: 15
                color: "white"
                anchors.centerIn: parent
            }
        }

        Rectangle {
            id: episodeTitleColumn
            width: 600
            height: 30
            anchors.left: episodeNumberColumn.right
            anchors.leftMargin: 10
            color: "teal"

            Text {
                text: qsTr("Title")
                font.pixelSize: 15
                color: "white"
                anchors.centerIn: parent
            }
        }

        Rectangle {
            id: episodeAiredColumn
            width: 200
            height: 30
            anchors.left: episodeTitleColumn.right
            anchors.leftMargin: 10
            color: "teal"

            Text {
                text: qsTr("Aired Date")
                font.pixelSize: 15
                color: "white"
                anchors.centerIn: parent
            }
        }
    }

    ListView {
        id: episodesView
        anchors.top: episodesViewTopBar.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        clip: true
        delegate: episodesDelegate
        ScrollBar.vertical: ScrollBar {
            id: episodesScrollbar
            active: true
            contentItem: Rectangle {
                implicitWidth: 10
                radius: width / 2
                color: episodesScrollbar.pressed ? "#607d8b" : "#a5b7c0"
            }
        }
    }

    Component {
        id: episodesDelegate

        Item {
            width: parent.width - 20
            height: 70
            anchors.left: parent.left
            anchors.leftMargin: 20

            RowLayout {
                anchors.fill: parent

                Rectangle {
                    id: episodeNumberRectangle
                    width: 100
                    height: 70
                    color: "transparent"
                    anchors.left: parent.left

                    Text {
                        id: episodeNumberText
                        anchors.centerIn: parent
                        color: "#595959"
                        // index starts at 0
                        text: (index + 1) < 10 ? String("0" + (index + 1)) : String(index + 1)
                        font.pixelSize: 20
                        width: parent.width - 10
                    }
                }

                Rectangle {
                    id: episodeTitleRectangle
                    width: 600
                    height: 70
                    color: "transparent"
                    anchors.left: episodeNumberRectangle.right
                    anchors.leftMargin: 10

                    Text {
                        id: episodeTitleText
                        anchors.centerIn: parent
                        color: "#595959"
                        font.pixelSize: 20
                        width: parent.width - 10
                        text: title
                    }
                }

                Rectangle {
                    id: episodeAiredRectangle
                    width: 200
                    height: 70
                    color: "transparent"
                    anchors.left: episodeTitleRectangle.right
                    anchors.leftMargin: 10

                    Text {
                        id: episodeAiredText
                        anchors.centerIn: parent
                        color: "#595959"
                        font.pixelSize: 20
                        width: parent.width - 10
                        text: aired
                    }

                }

                RowLayout {
                    id: episodeActionButtons
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: episodeAiredRectangle.right
                    anchors.leftMargin: 30
                    spacing: 10
                      Button {
                          text: "Watch"
                          onClicked: notYet.open()
                      }
                      Button {
                          text: "Buy"
                          onClicked: {
                              currentlySelectedEpisode_number = episodeNumberText.text
                              currentlySelectedEpisode_title = episodeTitleText.text
                              episodeTransactionPopup.open()
                          }
                      }
                  }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20
                height: 1
                color: "#bfbfbf"
                opacity: 0.5
            }
        }
    }

    Popup {
        id: episodeTransactionPopup
        modal: true
        focus: true
        x: Math.round((mainAppWindow.width / 2) - (width / 2))
        y: Math.round((mainAppWindow.height / 2) - (height / 2))

        closePolicy: "NoAutoClose"

        ColumnLayout {
            spacing: 10

            RowLayout {
                id: episodeDataLayout
                spacing: 20
                height: thumbImage.height + 20

                Image {
                    id: thumbImage
                    source: seriesThumb
                    fillMode: Image.PreserveAspectFit
                }

                Column {
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    Layout.fillWidth: true
                    spacing: 15

                    Label {
                        font.pixelSize: 20
                        font.bold: true
                        text: seriesTitleText + ", Season " + seriesSeasonText
                    }

                    Label {
                        font.pixelSize: 18
                        text: "Episode " + currentlySelectedEpisode_number + ": " + currentlySelectedEpisode_title
                    }

                    Label {
                        id: ppuText
                        font.pixelSize: 14
                        font.italic: true
                        text: "Price Per Unit = Ksh" + String(ppu) + ".00"
                    }

                    Label {
                        id: totalCostText
                        font.pixelSize: 14
                        font.italic: true
                        text: "Total Cost = Ksh" + String(totalCost) + ".00"
                    }

                }
            }

            RowLayout {
                width: parent.width
                spacing: 20

                Label {
                    text: "Where to copy?"
                }

                ComboBox {
                    id: transferOptionSelector
                    implicitWidth: 200
                    model: parentModelEpisodes.copyMediaModel
                    onActivated: {
                        var copyMediumCost = 0.0

                        switch (transferOptionSelector.currentText.toLowerCase()) {
                        case "dvd":
                            copyMediumCost = dvdPrice
                            break
                        case "usb disk":
                            copyMediumCost = usbDiskPrice
                            break
                        }

                        ppu = episodePrice + copyMediumCost
                        totalCost = ppu * numberOfCopiesSelector.value
                    }
                }
            }

            RowLayout {
                width: parent.width
                spacing: 20

                Label {
                    text: "Copies"
                }

                SpinBox {
                    id: numberOfCopiesSelector
                    from: 1
                    value: 1
                    editable: true
                    onValueChanged: {
                        var copyMediumCost = 0.0

                        switch (transferOptionSelector.currentText.toLowerCase()) {
                        case "dvd":
                            copyMediumCost = dvdPrice
                            break
                        case "usb disk":
                            copyMediumCost = usbDiskPrice
                            break
                        }

                        ppu = episodePrice + copyMediumCost
                        totalCost = ppu * numberOfCopiesSelector.value
                    }
                }
            }

            RowLayout {
                width: parent.width
                spacing: 20

                Button {
                    text: "cancel"
                    onClicked: {
                        transferOptionSelector.currentIndex = 0
                        numberOfCopiesSelector.value = 1
                        episodeTransactionPopup.close()
                    }
                }

                Button {
                    text: "add to cart"
                    onClicked: {
                        var fullEpisodeTitle = seriesTitleText + " S" +
                                seriesSeasonText + "E" +
                                currentlySelectedEpisode_number + " - \"" +
                                currentlySelectedEpisode_title + "\""

                        var transactionItemsArray = [
                                "Episode",
                                fullEpisodeTitle,
                                numberOfCopiesSelector.value,
                                ppu,
                                totalCost,
                                transferOptionSelector.currentText]

                        shoppingCart.addNewItem(transactionItemsArray)

                        transferOptionSelector.currentIndex = 0
                        numberOfCopiesSelector.value = 1
                        episodeTransactionPopup.close()
                    }
                }
            }
        }
    }
}
