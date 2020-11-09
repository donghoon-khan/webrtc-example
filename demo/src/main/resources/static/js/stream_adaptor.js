export class StreamAdaptor{

    #type
    #src
    #player
    constructor(initialValues) {
        this.videoId = null;

        for (var key in initialValues) {
            if (initialValues.hasOwnProperty(key)) {
                this[key] = initialValues[key];
            }
        }
    }
    
    src(param) {
        this.#type = param.type;
        this.#src = param.src;

        if (this.#type == "application/x-mpegURL") {
            this.tryToPlay(this.#src, this.hlsNoStreamCallback);
            this.initializePlayer(this.#type, this.#src);
        }
    }

    initializePlayer(type, src) {
        if (type == "application/x-mpegURL") {
            this.#player = videojs(this.videoId);
            this.#player.src({
                type: type,
                src: src
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

    play() {
        if (this.#type == "application/x-mpegURL") {
            this.#player.play();
        }
    }

    hlsNoStreamCallback() {
        alert("No stream found");
    }
}