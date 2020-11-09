<!doctype html>
<html lang="en">

<head>
    <title>Ant Media Server WebRTC Player</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
        integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>

    <style>
        video {
            width: 100%;
            max-width: 640px;
        }

        /* Everything but the jumbotron gets side spacing for mobile first views */
        .header,
        .marketing,
        .footer {
            padding: 15px;
        }

        /* Custom page header */
        .header {
            padding-bottom: 20px;
        }

        /* Customize container */
        @media (min-width : 768px) {
            .container {
                max-width: 730px;
            }
        }

        .container-narrow>hr {
            margin: 30px 0;
        }

        /* Main marketing message and sign up button */
        .jumbotron {
            text-align: center;
        }

        /* Responsive: Portrait tablets and up */
        @media screen and (min-width: 768px) {

            /* Remove the padding we set earlier */
            .header,
            .marketing,
            .footer {
                padding-right: 0;
                padding-left: 0;
            }
        }

        .options {
            display: none;
        }
    </style>
</head>

<body>

    <div class="container">
        <div class="header clearfix">
            <div class="row">
                <h3 class="col text-muted">WebRTC Play</h3>
                <nav class="col align-self-center">
                    <ul class="nav float-right">
                        <li><a href="http://antmedia.io">Contact</a></li>
                    </ul>
                </nav>
            </div>
        </div>


        <div class="jumbotron">

            <div class="col-sm-12 form-group">
                <video id="remoteVideo" autoplay controls playsinline></video>
            </div>
            <div class="form-group col-sm-12 text-left">
                <input type="text" class="form-control" id="streamName" placeholder="Type stream name">
            </div>
            <div class="col-sm-12 text-right">
                <button type="button" id="options" class="btn btn-outline-primary btn-sm">Options</button>
            </div>
            <div class="form-group col-sm-12 text-left options">
                <div class="dropdown">
                    <button class="btn btn-outline-primary btn-sm dropdown-toggle" type="button" id="dropdownMenuButton"
                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        Force Stream Resolution
                    </button>
                    <div id="dropdownMenu" class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                        <a class="dropdown-item active" href="#">Automatic</a>
                    </div>
                </div>
                <div class="dropdown-divider"></div>
                <label>Data Channel Messages</label>
                <textarea class="form-control" id="dataMessagesTextarea" style="font-size:10px" rows="8"></textarea>
                <div class="form-row">
                    <div class="form-group col-sm-10">
                        <input type="text" class="form-control" id="dataTextbox"
                            placeholder="Write your message to send publisher/players">
                    </div>
                    <div class="form-group col-sm-2">
                        <button type="button" id="send" class="btn btn-outline-primary btn-block">Send</button>
                    </div>
                </div>

            </div>
            <div class="form-group">
                <button class="btn btn-primary" id="start_play_button">Start Playing</button>
                <button class="btn btn-primary" id="stop_play_button">Stop Playing</button>
            </div>

            <div class="col-sm-10 offset-sm-1" id="stats_panel" style="display: none;">
                <div class="row text-muted text-left">
                    <div class="col-sm-6">
                        <small>
                            <div id="average_bit_rate_container">Average Bitrate(Kbps): <span
                                    id="average_bit_rate"></span></div>
                            <div id="latest_bit_rate_container">Latest Bitrate(Kbps): <span id="latest_bit_rate"></span>
                            </div>
                            <div id="packet_lost_container">PacketsLost: <span id="packet_lost_text"></span></div>
                            <div id="jitter_container">Jitter Average Delay(Secs): <span id="jitter_text"></span></div>
                            <div id="audio_level_container">Audio Level: <span id="audio_level"></span></div>

                        </small>
                    </div>
                    <div class="col-sm-6">
                        <small>
                            <div id="incoming_resolution_container">Frame WidthxHeight: <span
                                    id="frame_width"></span>x<span id="frame_height"></span></div>
                            <div id="frame_decoded_container">Frames Decoded: <span id="frame_decoded"></span></div>
                            <div id="frame_dropped_container">Frames Dropped: <span id="frame_dropped"></span></div>
                            <div id="frame_received_container">Frames Received: <span id="frame_received"></span></div>
                        </small>
                    </div>
                </div>
            </div>
            <span class="badge badge-warning" id="bitrateInfo" style="font-size:14px;display:none"
                style="display: none">Weak Network Connection</span>

        </div>
        <footer class="footer text-center">
            <p>
                <a href="http://antmedia.io">Ant Media Server</a>
            </p>
        </footer>
    </div>

    <script src="https://code.jquery.com/jquery-3.4.1.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
        crossorigin="anonymous"></script>

</body>
<script type="module">
    import { WebRTCAdaptor } from "./js/webrtc_adaptor.js"
    import { getUrlParameter } from "./js/fetch.stream.js"

    var token = getUrlParameter("token");

    $(function () {
        var id = getUrlParameter("id");
        if (typeof id != "undefined") {
            $("#streamName").val(id);
        }
        else {
            id = getUrlParameter("name");
            if (typeof id != "undefined") {
                $("#streamName").val(id);
            }
            else {
                $("#streamName").val("stream1");
            }
        }
    });


    var start_play_button = document.getElementById("start_play_button");
    start_play_button.addEventListener("click", startPlaying, false)
    var stop_play_button = document.getElementById("stop_play_button");
    stop_play_button.addEventListener("click", stopPlaying, false);
    var options = document.getElementById("options");
    options.addEventListener("click", toggleOptions, false);
    var send = document.getElementById("send");
    send.addEventListener("click", sendData, false);

    var streamNameBox = document.getElementById("streamName")
    streamNameBox.defaultValue = "stream1";

    var streamId;

    function toggleOptions() {
        $(".options").toggle();
    }

    function sendData() {
        try {
            var iceState = webRTCAdaptor.iceConnectionState(streamId);
            if (iceState != null && iceState != "failed" && iceState != "disconnected") {

                webRTCAdaptor.sendData($("#streamName").val(), $("#dataTextbox").val());
                $("#dataMessagesTextarea").append("Sent: " + $("#dataTextbox").val() + "\r\n");
                $("#dataTextbox").val("");
            }
            else {
                alert("WebRTC playing is not active. Please click Start Playing first")
            }
        }
        catch (exception) {
            console.error(exception);
            alert("Message cannot be sent. Make sure you've enabled data channel and choose the correct player distribution on server web panel");
        }
    }

    function startPlaying() {
        streamId = streamNameBox.value;
        webRTCAdaptor.play(streamNameBox.value, token);
    }

    function stopPlaying() {
        webRTCAdaptor.stop(streamId);
    }

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

    var appName = location.pathname.substring(0, location.pathname.lastIndexOf("/") + 1);
    //var path =  location.hostname + ":" + location.port + appName + "websocket";
    var path = "192.168.41.195:5080/LiveApp/websocket"
    var websocketURL = "ws://" + path;

    if (location.protocol.startsWith("https")) {
        websocketURL = "wss://" + path;
    }

    function startAnimation() {

        $("#bitrateInfo").fadeIn(800, function () {
            $("#bitrateInfo").fadeOut(800, function () {
                $("#bitrateInfo").html("Weak Network Connection");
            });
        });
    }

    var webRTCAdaptor = new WebRTCAdaptor({
        websocket_url: websocketURL,
        mediaConstraints: mediaConstraints,
        peerconnection_config: pc_config,
        sdp_constraints: sdpConstraints,
        remoteVideoId: "remoteVideo",
        isPlayMode: true,
        debug: true,
        candidateTypes: ["tcp", "udp"],
        callback: function (info, obj) {
            if (info == "initialized") {
                console.log("initialized");
                start_play_button.disabled = false;
                stop_play_button.disabled = true;
            } else if (info == "play_started") {
                //joined the stream
                console.log("play started");
                start_play_button.disabled = true;
                stop_play_button.disabled = false;
                webRTCAdaptor.getStreamInfo(streamId);
                webRTCAdaptor.enableStats(obj.streamId);

            } else if (info == "play_finished") {
                //leaved the stream
                console.log("play finished");
                start_play_button.disabled = false;
                stop_play_button.disabled = true;
                $("#stats_panel").hide();
                // Reset stream resolutions in dropdown
                document.getElementById("dropdownMenu").innerHTML = '<a class="dropdown-item active" href="#">Automatic</a>';
            } else if (info == "closed") {
                //console.log("Connection closed");
                if (typeof obj != "undefined") {
                    console.log("Connecton closed: "
                        + JSON.stringify(obj));
                }
            } else if (info == "streamInformation") {

                var streamResolutions = new Array();

                obj["streamInfo"].forEach(function (entry) {
                    //It's needs to both of VP8 and H264. So it can be dublicate
                    if (!streamResolutions.includes(entry["streamHeight"])) {
                        streamResolutions.push(entry["streamHeight"]);
                    }
                });
                // Sort stream resolutions for good UI :)
                streamResolutions = streamResolutions.sort(function (a, b) { return a - b });

                // Add stream resolutions in dropdown menu
                const dropdownMenu = document.querySelector('.dropdown-menu');

                streamResolutions.forEach(streamResolution => {
                    dropdownMenu.innerHTML += '<a class="dropdown-item" href="#">' + streamResolution + 'p</a>';
                });

                $('.dropdown-menu a').click(function () {
                    var dropdownSelectedItem = $(this).text();

                    if (dropdownSelectedItem == "Automatic") {
                        dropdownSelectedItem = 0;
                    }

                    // Remove p character in stream resolution
                    dropdownSelectedItem = dropdownSelectedItem.replace('p', '');

                    // Call set stream resolution
                    webRTCAdaptor.forceStreamQuality(streamId, Number(dropdownSelectedItem));
                    // Remove current active item
                    $('a.dropdown-item.active').removeClass("active");
                    // Add active in new item
                    $(this).addClass("active");
                });
            }
            else if (info == "ice_connection_state_changed") {
                console.log("iceConnectionState Changed: ", JSON.stringify(obj));
            }
            else if (info == "updated_stats") {
                //obj is the PeerStats which has fields
                //averageIncomingBitrate - kbits/sec
                //currentIncomingBitrate - kbits/sec
                //packetsLost - total number of packet lost
                //fractionLost - fraction of packet lost

                $("#average_bit_rate").text(obj.averageIncomingBitrate);
                if (obj.averageIncomingBitrate > 0) {
                    $("#average_bit_rate_container").show();
                }
                else {
                    $("#average_bit_rate_container").hide();
                }
                $("#latest_bit_rate").text(obj.currentIncomingBitrate);
                if (obj.currentIncomingBitrate > 0) {
                    $("#latest_bit_rate_container").show();
                }
                else {
                    $("#latest_bit_rate_container").hide();
                }

                var packetLost = parseInt(obj.videoPacketsLost) + parseInt(obj.audioPacketsLost);
                $("#packet_lost_text").text(packetLost);
                if (packetLost > -1) {
                    $("#packet_lost_container").show();
                }
                else {
                    $("#packet_lost_container").hide();
                }

                var jitterAverageDelay = ((parseFloat(obj.videoJitterAverageDelay) + parseFloat(obj.audioJitterAverageDelay)) / 2).toPrecision(3);
                $("#jitter_text").text(jitterAverageDelay);
                if (jitterAverageDelay > 0) {
                    $("#jitter_container").show();
                }
                else {
                    $("#jitter_container").hide();
                }

                $("#audio_level").text(obj.audioLevel.toPrecision(3));
                if (obj.audioLevel > -1) {
                    $("#audio_level_container").show();
                }
                else {
                    $("#audio_level_container").hide();
                }


                $("#frame_width").text(obj.frameWidth);
                $("#frame_height").text(obj.frameHeight);
                if (obj.frameWidth > 0 && obj.frameHeight > 0) {
                    $("#incoming_resolution_container").show();
                }
                else {
                    $("#incoming_resolution_container").hide();
                }
                $("#frame_received").text(obj.framesReceived);
                if (obj.framesReceived > -1) {
                    $("#frame_received_container").show();
                }
                else {
                    $("#frame_received_container").hide();
                }

                $("#frame_decoded").text(obj.framesDecoded);
                if (obj.framesDecoded > -1) {
                    $("#frame_decoded_container").show();
                }
                else {
                    $("#frame_decoded_container").hide();
                }
                $("#frame_dropped").text(obj.framesDropped);
                if (obj.framesDropped > -1) {
                    $("#frame_dropped_container").show();
                }
                else {
                    $("#frame_dropped_container").hide();
                }

                $("#stats_panel").show();



                console.debug("Average incoming kbits/sec: " + obj.averageIncomingBitrate
                    + " Current incoming kbits/sec: " + obj.currentIncomingBitrate
                    + " video packetLost: " + obj.videoPacketsLost
                    + " audio packetLost: " + obj.audioPacketsLost
                    + " frame width: " + obj.frameWidth
                    + " frame height: " + obj.frameHeight
                    + " frame received: " + obj.framesReceived
                    + " frame decoded: " + obj.framesDecoded
                    + " frame dropped: " + obj.framesDropped
                    + " video jitter average delay: " + obj.videoJitterAverageDelay
                    + " audio jitter average delay: " + obj.audioJitterAverageDelay
                    + " audio level: " + obj.audioLevel);

            }
            else if (info == "data_received") {
                console.log("Data received: " + obj.event.data + " type: " + obj.event.type + " for stream: " + obj.streamId);
                $("#dataMessagesTextarea").append("Received: " + obj.event.data + "\r\n");
            }
            else if (info == "bitrateMeasurement") {

                console.debug(obj);
                if (obj.audioBitrate + obj.videoBitrate > obj.targetBitrate) {
                    startAnimation();
                }
                $("#video_bit_rate").text(parseInt(obj.audioBitrate) + parseInt(obj.videoBitrate));
            }
            else {
                console.log(info + " notification received");
            }
        },
        callbackError: function (error) {
            //some of the possible errors, NotFoundError, SecurityError,PermissionDeniedError

            console.log("error callback: " + JSON.stringify(error));
            alert(JSON.stringify(error));
        }
    });

    window.webRTCAdaptor = webRTCAdaptor;
</script>

</html>