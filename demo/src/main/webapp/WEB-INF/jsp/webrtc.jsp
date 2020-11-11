<!doctype html>
<html lang="en">

<head>
    <title>TEST Stream Player</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
        integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="/js/adapter-7.2.5.js"></script>
    <script src="/js/hls.min.js"></script>
</head>

<body>
    <div class="container">
        <div class="col-sm-12 form-group text-center">
            <h1>WebRTC</h1>
        </div>
        <div class="jumbotron">
            <div class="col-sm-12 form-group text-center">
                <video id="video" controls preload="auto" muted width="640" height="360"></video>
            </div>
            <div class="form-group col-sm-12 text-center">
                <div class="input-group mb-3">
                    <input type="text" class="form-control" id="stream-id" placeholder="Stream ID">
                    <div class="input-group-append">
                        <button class="btn btn-primary" id="start-button">Start Playing</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.4.1.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
        crossorigin="anonymous"></script>
</body>

<script type="module">
    import { StreamAdaptor } from "/js/stream_adaptor.js"

    var adaptor = new StreamAdaptor({
        videoId: "video"
    });

    adaptor.initializePlayer({
        type: "WebRTC",
        websocketURL: "ws://192.168.41.195:5080/WebRTCAppEE/websocket"
    });

    var start_play_button = document.getElementById("start-button");
    start_play_button.addEventListener("click", function(){
        adaptor.play($("#stream-id").val());
    }, false);
</script>

</html>