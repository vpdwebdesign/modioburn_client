import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Window 2.3
import QtMultimedia 5.9

Window {
    id: audioPlayerWindow
    minimumWidth: 620
    minimumHeight: 400
    maximumWidth: 620
    maximumHeight: 400
    visible: true
    title: "ModioBurn Music Player - " + songTitle + ", " + artistName

    objectName: "AudioPlayer"

    onClosing: {
        close.accepted = false
        audioPlayer.stop()
        mainToolBar.audioPlayingIconVisible = false
        close.accepted = true
    }

    onVisibilityChanged: {
        if (audioPlayerWindow.visibility == Window.Minimized)
        {
            mainToolBar.audioPlayingIconVisible = true
            mainToolBar.audioItemsCountVisible = true
        }
        else if ((audioPlayerWindow.visibility == Window.Maximized) ||
                 (audioPlayerWindow.visibility == Window.Windowed) ||
                 (audioPlayerWindow.visibility == Window.FullScreen))
        {
            mainToolBar.audioPlayingIconVisible = true
            mainToolBar.audioItemsCountVisible = false
        }
    }


    Component.onCompleted: {
        x = Math.round(mainAppWindow.width / 2) - Math.round(width / 2)
        y = Math.round(mainAppWindow.height / 2) - Math.round(height / 2)
    }

    // global properties
    property string songUrl
    property string coverArtUrl
    property string songTitle
    property string albumTitle
    property string artistName

    Item {
        id: audioPlayerControl

        function playPause() {
            if (audioPlayer.playbackState == 1)
            {
                audioPlayer.pause()
            }
            else if(audioPlayer.playbackState == 2)
            {
                audioPlayer.play()
            }
            else
            {
                audioPlayer.play()
            }
        }

        function rewind()
        {
            if (audioPlayer.seekable)
            {
                if (audioPlayer.position > 5000)
                {
                    audioPlayer.seek(audioPlayer.position - 5000)
                }
                else
                {
                    audioPlayer.seek(0)
                }
            }

        }

        function fastForward()
        {
            if (audioPlayer.seekable)
            {
                if ((audioPlayer.duration - audioPlayer.position) < (5000))
                {
                    audioPlayer.seek(audioPlayer.duration)
                }
                else
                {
                    audioPlayer.seek(audioPlayer.position + 5000)
                }
            }
        }

        function stop()
        {
            if (audioPlayer.playbackState != 3)
                audioPlayer.stop()
        }

        function msToTime(duration) {
            var seconds = parseInt((duration / 1000) % 60)
            var minutes = parseInt((duration / (1000 * 60)) % 60)

            minutes = (minutes < 10) ? "0" + minutes : minutes
            seconds = (seconds < 10) ? "0" + seconds : seconds

            return minutes + ":" + seconds
        }

        Connections {
            target: audioPlayer

            onStopped: {
                playPauseButton.icon.name = "play"
            }

            onError: {
                console.log(error + " error string is " + errorString)
            }

//            onMediaObjectChanged: {
//                if (audioPlayer.mediaObject)
//                    audioPlayer.mediaObject.notifyInterval = 50
//            }
        }
    }

    MediaPlayer {
        id: audioPlayer
        source: songUrl
        autoLoad: true
        autoPlay: true
        onPositionChanged: {
            seekSlider.value = audioPlayer.position
            playbackPositionText.text = playbackPositionText.pad(audioPlayerControl.msToTime(audioPlayer.position))
        }
        volume: volumeDial.volume
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        anchors.bottomMargin: 20


        RowLayout {
            Layout.fillWidth: true

            Image {
                id: coverArt
                fillMode: Image.Pad
                source: coverArtUrl
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Dial {
                    id: volumeDial
                    anchors.centerIn: parent
                    value: 0.3

                    property real volume: QtMultimedia.convertVolume(volumeDial.value,
                                                                           QtMultimedia.LogarithmicVolumeScale,
                                                                           QtMultimedia.LinearVolumeScale)

                    height: 140
                    width: 140
                }

                Label {
                    anchors.top: volumeDial.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: volumeDial.horizontalCenter
                    text: "Volume"
                }

            }
        }

        Item {
            id: songLabelContainer
            clip: true

            Layout.fillWidth: true
            Layout.preferredHeight: songNameLabel.implicitHeight

            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                PauseAnimation {
                    duration: 2000
                }
                ParallelAnimation {
                    XAnimator {
                        target: songNameLabel
                        from: 0
                        to: songLabelContainer.width - songNameLabel.implicitWidth
                        duration: 5000
                    }
                }
                PauseAnimation {
                    duration: 1000
                }
                ParallelAnimation {
                    XAnimator {
                        target: songNameLabel
                        from: songLabelContainer.width - songNameLabel.implicitWidth
                        to: 0
                        duration: 5000
                    }
                }
            }

            Label {
                id: songNameLabel
                text: artistName + " - " + songTitle
                font.pixelSize: Qt.application.font.pixelSize * 1.4
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            Label {
                id: playbackPositionText

                function pad(number) {
                    if (number <= 9)
                        return "0" + number;
                    return number;
                }
            }

            Slider {
                id: seekSlider
                Layout.fillWidth: true
                from: 0.0
                to: audioPlayer.duration
                onVisualPositionChanged: {
                    if (audioPlayer.seekable)
                        audioPlayer.seek(seekSlider.value)
                }

                ToolTip {
                    parent: seekSlider.handle
                    visible: seekSlider.pressed
                    text: pad(audioPlayerControl.msToTime(audioPlayer.position))
                    y: parent.height

                    function pad(number) {
                        if (number <= 9)
                            return "0" + number;
                        return number;
                    }
                }
            }

            Label {
                id: songDurationText
                text: pad(audioPlayerControl.msToTime(audioPlayer.duration))

                function pad(number) {
                    if (number <= 9)
                        return "0" + number;
                    return number;
                }
            }
        }

        RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignHCenter

            RoundButton {
                icon.name: "stop"
                icon.width: 32
                icon.height: 32
                onClicked: {
                    audioPlayerControl.stop()
                }
            }
            RoundButton {
                icon.name: "previous"
                icon.width: 32
                icon.height: 32
                enabled: false
            }
            RoundButton {
                icon.name: "fr"
                icon.width: 32
                icon.height: 32
                onClicked: {
                    audioPlayerControl.rewind()
                }
            }
            RoundButton {
                id: playPauseButton
                icon.name: (audioPlayer.playbackState == 1) ? "pause" : "play"
                icon.width: 32
                icon.height: 32
                onClicked: {
                    audioPlayerControl.playPause()
                }
            }
            RoundButton {
                icon.name: "ff"
                icon.width: 32
                icon.height: 32
                onClicked: {
                    audioPlayerControl.fastForward()
                }
            }
            RoundButton {
                icon.name: "next"
                icon.width: 32
                icon.height: 32
                enabled: false
            }
            RoundButton {
                icon.name: (audioPlayer.loops == MediaPlayer.Infinite) ? "repeat_once" : "repeat"
                icon.width: 32
                icon.height: 32
                onClicked: {
                    if (audioPlayer.loops != MediaPlayer.Infinite)
                        audioPlayer.loops = MediaPlayer.Infinite
                    else
                        audioPlayer.loops = 1
                }
            }
            RoundButton {
                enabled: false
                icon.name: "shuffle"
                icon.width: 32
                icon.height: 32
            }
            RoundButton {
                icon.name: audioPlayer.muted ? "audio_off" : "audio_on"
                icon.width: 32
                icon.height: 32
                onClicked: {
                    if (audioPlayer.muted)
                        audioPlayer.muted = false
                    else
                        audioPlayer.muted = true
                }
            }
        }
    }
}
