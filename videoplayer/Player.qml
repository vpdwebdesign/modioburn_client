import QtQuick 2.10
import QtQuick.Dialogs 1.2
import QtAV 1.7
import QtQuick.Window 2.3
import "utils.js" as Utils

Window {
    id: playerWindow
    objectName: "playerWindow"
    width: Utils.scaled(800)
    height: Utils.scaled(450)

    onClosing: {
        mainToolBar.videoPlayingIconVisible = false
        player.stop()
    }

    onVisibilityChanged: {
        if (playerWindow.visibility == Window.Minimized)
        {
            mainToolBar.videoPlayingIconVisible = true
            mainToolBar.videoItemsCountVisible = true
        }
        else if ((playerWindow.visibility == Window.Maximized) ||
                 (playerWindow.visibility == Window.Windowed) ||
                 (playerWindow.visibility == Window.FullScreen))
        {
            mainToolBar.videoPlayingIconVisible = true
            mainToolBar.videoItemsCountVisible = false
        }
    }

    property alias videoUrl: player.source
    property alias videoTitle: playerWindow.title

    VideoFilter {
        id: negate
        type: VideoFilter.GLSLFilter
        shader: Shader {
            postProcess: "gl_FragColor.rgb = vec3(1.0-gl_FragColor.r, 1.0-gl_FragColor.g, 1.0-gl_FragColor.b);"
        }
    }

    VideoFilter {
        id: hflip
        type: VideoFilter.GLSLFilter
        shader: Shader {
            sample: "vec4 sample2d(sampler2D tex, vec2 pos, int p) { return texture(tex, vec2(1.0-pos.x, pos.y));}"
        }
    }

    VideoOutput2 {
        id: videoOut
        opengl: true
        fillMode: VideoOutput.PreserveAspectFit
        anchors.fill: parent
        source: player
        orientation: 0
        property real zoom: 1
        //filters: [negate, hflip]
        SubtitleItem {
            id: subtitleItem
            fillMode: videoOut.fillMode
            rotation: -videoOut.orientation
            source: subtitle
            anchors.fill: parent
        }
        Text {
            id: subtitleLabel
            rotation: -videoOut.orientation
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            font: PlayerConfig.subtitleFont
            style: PlayerConfig.subtitleOutline ? Text.Outline : Text.Normal
            styleColor: PlayerConfig.subtitleOutlineColor
            color: PlayerConfig.subtitleColor
            anchors.fill: parent
            anchors.bottomMargin: PlayerConfig.subtitleBottomMargin
        }
    }

    MediaPlayer {
        id: player
        objectName: "player"
        autoPlay: true
        videoCodecPriority: PlayerConfig.decoderPriorityNames
        onPositionChanged: control.setPlayingProgress(position/duration)
        videoCapture {
            autoSave: true
            onSaved: {
                msg.info("capture saved at: " + path)
            }
        }
        onSourceChanged: {
            videoOut.zoom = 1
            videoOut.regionOfInterest = Qt.rect(0, 0, 0, 0)
        }

        onDurationChanged: control.duration = duration
        onPlaying: {
            control.mediaSource = player.source
            control.setPlayingState()
        }
        onSeekFinished: {
            console.log("seek finished " + Utils.msec2string(position))
        }

        onStopped: control.setStopState()
        onPaused: control.setPauseState()
        muted: control.mute // TODO: control from system
        volume: control.volume
        onVolumeChanged: { //why need this? control.volume = player.volume is not enough?
            if (Math.abs(control.volume - volume) >= 0.01) {
                control.volume = volume
            }
        }

        Component.onCompleted: function() {
            if (player.source !== "")
                player.play();
        }
    }

    Subtitle {
        id: subtitle
        player: player
        enabled: PlayerConfig.subtitleEnabled
        autoLoad: PlayerConfig.subtitleAutoLoad
        engines: PlayerConfig.subtitleEngines
        delay: PlayerConfig.subtitleDelay
        fontFile: PlayerConfig.assFontFile
        fontFileForced: PlayerConfig.assFontFileForced
        fontsDir: PlayerConfig.assFontsDir

        onContentChanged: { //already enabled
            if (!canRender || !subtitleItem.visible)
                subtitleLabel.text = text
        }
        onLoaded: {
            msg.info(qsTr("Subtitle") + ": " + path.substring(path.lastIndexOf("/") + 1))
        }
        onEngineChanged: { // assume a engine canRender is only used as a renderer
            subtitleItem.visible = canRender
            subtitleLabel.visible = !canRender
        }
        onEnabledChanged: {
            subtitleItem.visible = enabled
            subtitleLabel.visible = enabled
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: control.opacity > 0 || cursor_timer.running ? Qt.ArrowCursor : Qt.BlankCursor
        onWheel: {
            var deg = wheel.angleDelta.y/8
            var dp = wheel.pixelDelta
            var p = Qt.point(mouseX, mouseY) //playerWindow.mapToItem(videoOut, Qt.point(mouseX, mouseY))
            var fp = videoOut.mapPointToSource(p)
            if (fp.x < 0)
                fp.x = 0;
            if (fp.y < 0)
                fp.y = 0;
            if (fp.x > videoOut.videoFrameSize.width)
                fp.x = videoOut.videoFrameSize.width
            if (fp.y > videoOut.videoFrameSize.height)
                fp.y = videoOut.videoFrameSize.height
            videoOut.zoom *= (1.0 + deg*3.14/180.0);
            if (videoOut.zoom < 1.0)
                videoOut.zoom = 1.0
            var x0 = fp.x - fp.x/videoOut.zoom;
            var y0 = fp.y - fp.y/videoOut.zoom;
            // in fact, it must insected with video frame rect. opengl save us
            videoOut.regionOfInterest.x = x0
            videoOut.regionOfInterest.y = y0
            videoOut.regionOfInterest.width = videoOut.videoFrameSize.width/videoOut.zoom
            videoOut.regionOfInterest.height = videoOut.videoFrameSize.height/videoOut.zoom
        }

        onDoubleClicked: {
            control.toggleVisible()
        }

        onMouseXChanged: {
            cursor_timer.start()
            if (mouseX > playerWindow.width || mouseX < 0
                    || mouseY > playerWindow.height || mouseY < 0)
                return;
            if (player.playbackState == MediaPlayer.StoppedState || !player.hasVideo)
                return;
        }

        Timer {
            id: cursor_timer
            interval: 2000
        }
    }

//    Item {
//        anchors.fill: parent
//        focus: true
//        Keys.onPressed: {
//            switch (event.key) {
//            case Qt.Key_M:
//                control.mute = !control.mute
//                break
//            case Qt.Key_Right:
//                player.fastSeek = event.isAutoRepeat
//                player.seek(player.position + 10000)
//                break
//            case Qt.Key_Left:
//                player.fastSeek = event.isAutoRepeat
//                player.seek(player.position - 10000)
//                break
//            case Qt.Key_Up:
//                control.volume = Math.min(2, control.volume+0.05)
//                break
//            case Qt.Key_Down:
//                control.volume = Math.max(0, control.volume-0.05)
//                break
//            case Qt.Key_Space:
//                if (player.playbackState == MediaPlayer.PlayingState) {
//                    player.pause()
//                } else if (player.playbackState == MediaPlayer.PausedState){
//                    player.play()
//                }
//                break
//            case Qt.Key_Plus:
//                player.playbackRate += 0.1;
//                console.log("player.playbackRate: " + player.playbackRate);
//                break;
//            case Qt.Key_Minus:
//                player.playbackRate = Math.max(0.1, player.playbackRate - 0.1);
//                break;
//            case Qt.Key_F:
//                control.toggleFullScreen()
//                break
//            case Qt.Key_R:
//                videoOut.orientation += 90
//                break;
//            case Qt.Key_T:
//                videoOut.orientation -= 90
//                break;
//            case Qt.Key_C:
//                player.videoCapture.capture()
//                break
//            case Qt.Key_A:
//                if (videoOut.fillMode === VideoOutput.Stretch) {
//                    videoOut.fillMode = VideoOutput.PreserveAspectFit
//                } else if (videoOut.fillMode === VideoOutput.PreserveAspectFit) {
//                    videoOut.fillMode = VideoOutput.PreserveAspectCrop
//                } else {
//                    videoOut.fillMode = VideoOutput.Stretch
//                }
//                break
//            case Qt.Key_O:
//                fileDialog.open()
//                break;
//            case Qt.Key_N:
//                player.stepForward()
//                break
//            case Qt.Key_B:
//                player.stepBackward()
//                break;
//            //case Qt.Key_Back:
//            case Qt.Key_Q:
//                Qt.quit()
//                break
//            }
//        }
//    }

    ControlPanel {
        id: control
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
            margins: Utils.scaled(12)
        }
        mediaSource: player.source
        duration: player.duration

        onSeek: {
            player.fastSeek = false
            player.seek(ms)
        }
        onSeekForward: {
            player.fastSeek = false
            player.seek(player.position + ms)
        }
        onSeekBackward: {
            player.fastSeek = false
            player.seek(player.position - ms)
        }
        onPlay: player.play()
        onStop: player.stop()
        onTogglePause: {
            if (player.playbackState == MediaPlayer.PlayingState) {
                player.pause()
            } else {
                player.play()
            }
        }
        volume: player.volume
        onOpenFile: fileDialog.open()
        onShowInfo: pageLoader.source = "MediaInfoPage.qml"
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a media file"
        selectMultiple: true
        folder: PlayerConfig.lastFile
        onAccepted: {
            var sub, av
            for (var i = 0; i < fileUrls.length; ++i) {
                var s = fileUrls[i].toString()
                if (s.endsWith(".srt")
                        || s.endsWith(".ass")
                        || s.endsWith(".ssa")
                        || s.endsWith(".sub")
                        || s.endsWith(".idx") //vob
                        || s.endsWith(".mpl2")
                        || s.endsWith(".smi")
                        || s.endsWith(".sami")
                        || s.endsWith(".sup")
                        || s.endsWith(".txt"))
                    sub = fileUrls[i]
                else
                    av = fileUrls[i]
            }
            if (sub) {
                subtitle.autoLoad = false
                subtitle.file = sub
            } else {
                subtitle.autoLoad = PlayerConfig.subtitleAutoLoad
                subtitle.file = ""
            }
            if (av) {
                player.source = av
                PlayerConfig.lastFile = av
            }
        }
    }

    Connections {
        target: Qt.application
        onStateChanged: { //since 5.1
            if (Qt.platform.os === "winrt" || Qt.platform.os === "winphone") //paused by system
                return
            // winrt is handled by system
            switch (Qt.application.state) {
            case Qt.ApplicationSuspended:
            case Qt.ApplicationHidden:
                player.pause()
                break
            default:
                break
            }
        }
    }
    Connections {
        target: PlayerConfig
        onZeroCopyChanged: {
            var opt = player.videoCodecOptions
            if (PlayerConfig.zeroCopy) {
                opt["copyMode"] = "ZeroCopy"
            } else {
                opt["copyMode"] = "OptimizedCopy" //FIXME: CUDA
            }
            player.videoCodecOptions = opt
        }
    }
}

