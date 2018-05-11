import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import ModioBurn.Tools 1.0

import "Common"

Pane {

    property string pageTitle: qsTr("Series")

    property int delegateHeight: 220
    property int seriesRectangleWidth: 160
    property int seriesRectangleHeight: delegateHeight - 20
    property string seriesRectangleColor: "transparent"
    property real seriesRectangleOpacity: 1.0
    property int seriesYearRectangleWidth: Math.round(seriesRectangleWidth / 1.5)
    property int seriesFontSize: 16

    property string currentlySelectedSeries_thumb
    property string currentlySelectedSeries_title
    property string currentlySelectedSeries_season

    // prices
    property real seriesPrice: itemPriceManager.itemPrice("series")
    property real dvdPrice: itemPriceManager.itemPrice("dvd")
    property real usbDiskPrice: 0.00

    property real ppu: 50.00 // pricePerUnit
    property real totalCost: 50.00

    ParentModel {
        id: parentModelSeries
    }

    RowLayout {
        id: searchBarRow
        width: parent.width
        height: 80
        SearchBar {
            id: search
            Layout.alignment: Qt.AlignHCenter
            placeHolder: qsTr("Series title, stars, category or year")
            fuzzySearchEnabled: true
            onSearchActivated: {
                parentModelSeries.filter(ParentModel.Series, searchString)
            }
        }

    }

    Item {
        id: sortBarRow
        width: parent.width
        height: 30
        anchors.top: searchBarRow.bottom
        SortBarSeries {
            onSortActivated: {
                parentModelSeries.sort(ParentModel.Series, col, sortOrder)
            }
        }

    }

    ListView {
        id: seriesView
        clip: true
        anchors.top: sortBarRow.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        model: parentModelSeries.seriesModel
        delegate: seriesDelegate
        ScrollBar.vertical: ScrollBar {
            id: seriesScrollbar
            active: true
            contentItem: Rectangle {
                implicitWidth: 10
                radius: width / 2
                color: seriesScrollbar.pressed ? "#607d8b" : "#a5b7c0"
            }
        }
    }

    Component {
        id: seriesDelegate
        Item {
            width: parent.width
            height: delegateHeight

            Image {
                id: seriesThumb
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: "file:" + thumb
            }

            MouseArea {
                anchors.fill: seriesThumb
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: notYet.open()
            }

            RowLayout {
                height: parent.height
                anchors.left: seriesThumb.right
                anchors.leftMargin: 30
                spacing: 20

                Rectangle {
                    id: titleRectangle
                    width: seriesRectangleWidth
                    height: seriesRectangleHeight
                    color: seriesRectangleColor
                    opacity: seriesRectangleOpacity

                    Text {
                        id: seriesTitleText
                        anchors.centerIn: parent
                        color: "#595959"
                        text: title
                        font.pixelSize: seriesFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }

                }

                Rectangle {
                    id: seasonRectangle
                    width: Math.round(seriesRectangleWidth * 0.5)
                    height: seriesRectangleHeight
                    color: seriesRectangleColor
                    opacity: seriesRectangleOpacity

                    Text {
                        id: seriesSeasonText
                        anchors.centerIn: parent
                        color: "#595959"
                        text: season
                        font.pixelSize: seriesFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: starsRectangle
                    width: seriesRectangleWidth
                    height: seriesRectangleHeight
                    color: seriesRectangleColor
                    opacity: seriesRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: stars
                        font.pixelSize: seriesFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: categoryRectangle
                    width: seriesRectangleWidth
                    height: seriesRectangleHeight
                    color: seriesRectangleColor
                    opacity: seriesRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: category
                        font.pixelSize: seriesFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: yearRectangle
                    width: seriesYearRectangleWidth
                    height: seriesRectangleHeight
                    color: seriesRectangleColor
                    opacity: seriesRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: year
                        font.pixelSize: seriesFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }
            }


            RowLayout {
                id: buttons
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 20
                spacing: 10
                Button {
                    text: "Watch"
                    onClicked: notYet.open()
                }
                Button {
                    text: "Trailer"
                    onClicked: {

                        // test if file can be accessed before opening player window
                        if (fileManager.fileExists(trailer_url))
                        {
                            var videoPlayerComponent = Qt.createComponent("qrc:/Player.qml");
                            if (videoPlayerComponent.status === Component.Ready) {
                                vpWin = videoPlayerComponent.createObject(mainAppWindow, {
                                                                              "videoUrl": "file:" + trailer_url,
                                                                              "videoTitle": "ModioBurn Video Player - " + title + " trailer"
                                                                          })
                                vpWin.show()
                                mainToolBar.videoPlayingIconVisible = true
                                mainToolBar.videoItemsCountVisible = false
                            }
                        }
                        else
                        {
                            errorDialog.title = "File Not Found"
                            errorMessage.text = "Cannot access the specified file. Please ask the attendant for assistance."
                            errorDialog.open()
                        }
                    }
                }
                Button {
                    text: "Episodes"
                    onClicked: {
                        mainView.push("Episodes.qml", {
                                          "seriesThumb": seriesThumb.source,
                                          "seriesTitleText": seriesTitleText.text,
                                          "seriesSeasonText": seriesSeasonText.text
                                      })
                    }
                }
                Button {
                    text: "Buy"
                    onClicked: {
                        currentlySelectedSeries_thumb = seriesThumb.source
                        currentlySelectedSeries_title = seriesTitleText.text
                        currentlySelectedSeries_season = seriesSeasonText.text
                        seriesTransactionPopup.open()
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
        id: seriesTransactionPopup
        modal: true
        focus: true
        x: Math.round((mainAppWindow.width / 2) - (width / 2))
        y: Math.round((mainAppWindow.height / 2) - (height / 2))

        closePolicy: "NoAutoClose"

        ColumnLayout {
            spacing: 10

            RowLayout {
                id: seriesDataLayout
                spacing: 20
                height: thumbImage.height + 20

                Image {
                    id: thumbImage
                    source: currentlySelectedSeries_thumb
                    fillMode: Image.PreserveAspectFit
                }

                Column {
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    Layout.fillWidth: true
                    spacing: 20

                    Label {
                        font.pixelSize: 20
                        font.bold: true
                        text: currentlySelectedSeries_title + ", Season " + currentlySelectedSeries_season
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
                    model: parentModelSeries.copyMediaModel
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

                        ppu = seriesPrice + copyMediumCost
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

                        ppu = seriesPrice + copyMediumCost
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
                        seriesTransactionPopup.close()
                    }
                }

                Button {
                    text: "add to cart"
                    onClicked: {
                        var transactionItemsArray = [
                                "Series",
                                currentlySelectedSeries_title,
                                numberOfCopiesSelector.value,
                                ppu,
                                totalCost,
                                transferOptionSelector.currentText]

                        shoppingCart.addNewItem(transactionItemsArray)

                        transferOptionSelector.currentIndex = 0
                        numberOfCopiesSelector.value = 1
                        seriesTransactionPopup.close()
                    }
                }
            }
        }
    }
}
