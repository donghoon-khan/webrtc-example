import { WebRTCAdaptor } from "/js/webrtc_adaptor.js"

export class StreamAdaptor{

    videoId
    player
    type
    hls
    webRTCAdaptor
    constructor(initialValues) {
        for (var key in initialValues) {
            if (initialValues.hasOwnProperty(key)) {
                this[key] = initialValues[key];
            }
        }
    }

    initializePlayer(param) {

        this.type = param.type;

        if (param.type.toLowerCase() == "hls") {
            var video = document.getElementById(this.videoId);
            if (Hls.isSupported()) {
                this.hls = new Hls();
                this.hls.loadSource(param.src);
                this.hls.attachMedia(video);
            } else if(video.canPlayType("application/vnd.apple.mpegurl")) {
                video.src = param.src;
            }
        } else if(param.type.toLowerCase() == "webrtc") {
            var pc_config = {
                'iceServers': [{
                    'urls': 'stun:stun1.l.google.com:19302'
                }]
            };
            var sdpConstraints = {
                OfferToReceiveAudio: true,
                OfferToReceiveVideo: true
        
            };
            var mediaConstraints = {
                video: false,
                audio: false
            };
            this.webRTCAdaptor = new WebRTCAdaptor({
                websocket_url: param.websocketURL,
                mediaConstraints: mediaConstraints,
                peerconnection_config: pc_config,
                sdp_constraints: sdpConstraints,
                remoteVideoId: this.videoId,
                isPlayMode: true,
                candidateTypes: ["tcp", "udp"],
                callback : function(info) {
                    if (info == "initialized") {
                        console.debug("initialized");
                    } else if (info == "play_started") {
                        console.debug("play started");
                    } else if (info == "play_finished") {
                        console.debug("play finished");
                    }
                },
                callbackError : function(error) {
                    console.error("error callback: " + error);
                    alert(error);
                }
            });
        }
    }

    tryToPlay(src, noStreamCallback) {
        fetch(src, {method:'HEAD'})
        .then(function(response) {
            if (response.status != 200) {
                console.error("No stream found");
                if (typeof noStreamCallback != "undefined") {
                    noStreamCallback();
                }
            }
        }).catch(function(err) {
            console.error("Error: " + err);
        });
    }

    play(src) {
        var video = document.getElementById(this.videoId);
        if (this.type.toLowerCase() == "hls") {
            video.play();
        } else if(this.type.toLowerCase() == "webrtc") {
            this.webRTCAdaptor.play(src);
            video.play();
        }
    }

    pause() {
        var video = document.getElementById(this.videoId);
        if (this.type.toLowerCase() == "hls") {
            video.pause();
        }
        else if (this.type.toLowerCase() == "webrtc") {
            this.webRTCAdaptor.stop();
            video.pause();
        }
    }

    hlsNoStreamCallback() {
        console.error("No stream found!");
    }
}