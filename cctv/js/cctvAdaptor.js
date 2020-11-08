import { WebRTCAdaptor } from "./webrtc_adaptor.js"

export class CctvAdaptor{

    constructor(initialValues) {
        console.log("Construct CCTV Adaptor");

        this.src = null;
        this.type = null;

        this.hlsStream = null;
        this.streamId = null;
        this.webRtcSignalingServer = null;

        for (var key in initialValues) {
            if (initialValues.hasOwnProperty(key)) {
                this[key] = initialValues[key];
            }
        }

        if (this.type == "hls") {
            this.createHlsVideo()
        }

        if (this.hlsStream != null) {
            this.createHlsVideo(this.hlsStream);
        }

        if (this.webRtcSignalingServer != null) {
            this.createWebRtcAdaptor(this.webRtcSignalingServer);
        }
    }

    tryToPlay(stream, extension, noStreamCallback) {
        fetch(stream + extension, {method:'HEAD'})
        .then(function(response) {
            if (response.status == 200) {
                //initializePlayer(stream, extension);
            }
            else {
                console.error("No stream found");
                if (typeof noStreamCallback != "undefined") {
                    console.log("error!!!!!!!!!!!!!!!!!!");
                        //noStreamCallback();
                }
            }
        }).catch(function(err) {
            console.error("Error: " + err);
        });
    }

    createHlsVideo(videoSrc) {
        this.tryToPlay("http://media.pictonm.com:5080/LiveApp/streams/41HLS", ".m3u8", "test");
        let video = document.createElement("video");
        /*$(video).prop("muted", true);
        $(video).prop("controls", true);
        if (Hls.isSupported()) {
            this.#hls = new Hls();
            this.#hls.loadSource(videoSrc);
            this.#hls.attachMedia(video);
            this.#hls.on(Hls.Events.MANIFEST_PARSED, function() {
                video.play();
            });
        }
        else if (video.canPlayType('application/vnd.apple.mpegurl')) {
            video.src = videoSrc;
            video.addEventListener('loadedmetadata', function() {
                video.play();
            });
        }
        this.#hlsVideo = video;
        return this.#hlsVideo;*/
    }

    getHlsVideo() {
        return this.#hlsVideo;
    }

    createWebRtcAdaptor(webSocketURL) {
        let video = document.createElement("video");
        this.#webRtcAdaptor = new WebRTCAdaptor({
            websocket_url: webSocketURL,
            mediaConstraints: {
                video: false,
                audio: false
            },
            peerconnection_config: {
                'iceServers': [{
                    'urls': 'stun:stun1.l.google.com:19302'
                }]
            },
            sdp_constraints: {
                OfferToReceiveAudio: true,
                OfferToReceiveVideo: true
            },
            remoteVideoId: video,
            isPlayMode: true,
            debug: true,
            candidateTypes: ["tcp", "udp"],
            callback: function (info, obj) {
                console.log("info = " + info);
                console.log("obj = " + obj);
            },
            callbackError: function (error) {
                console.log("error callback: " + JSON.stringify(error));
                alert(JSON.stringify(error));
            }
        });
        return this.#webRtcAdaptor;
    }

    test(data) {
        return data;
    }
}