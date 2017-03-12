# documentation: https://developers.google.com/youtube/iframe_api_reference

# will resolve when window.onYouTubeIframeAPIReady is called
youTubeReady = new Promise (resolve, reject) ->
    window.onYouTubeIframeAPIReady = -> resolve()

# standard youtube iframe api initialization
tag = document.createElement 'script'
tag.src = 'https://www.youtube.com/iframe_api'
firstScriptTag = document.getElementsByTagName('script')[0]
firstScriptTag.parentNode.insertBefore tag, firstScriptTag

class YouTubePlayer extends Layer

    # events, see https://developers.google.com/youtube/iframe_api_reference#Events
    @Events:
        Loaded: 'yt-loaded' # occurs when video is queued and ready to play. will provide the player as parameter.
        Ready: 'yt-ready'
        StateChange: 'yt-stateChange'
        PlaybackQualityChange: 'yt-playbackQualityChange'
        PlaybackRateChange: 'yt-playbackRateChange'
        Error: 'yt-error'
        ApiChange: 'yt-apiChange'

    # options: { video, playerVars }
    # for playerVars, see https://developers.google.com/youtube/player_parameters
    constructor: (options={}) ->

        # this div will be replaced with youtube iframe
        div = document.createElement 'div'

        @_playerReady = new Promise (playerResolve, playerReject) =>

            youTubeReady.then =>

                # player is only accessible on ready event
                @_player = new YT.Player(div,
                    width: @width
                    height: @height
                    playerVars: options.playerVars
                    events:
                        'onReady': (event) =>
                            playerResolve event.target
                            @emit YouTubePlayer.Events.Ready, event
                        'onStateChange': (event) => @emit YouTubePlayer.Events.StateChange, event
                        'onPlaybackQualityChange': (event) => @emit YouTubePlayer.Events.PlaybackQualityChange, event
                        'onPlaybackRateChange': (event) => @emit YouTubePlayer.Events.PlaybackRateChange, event
                        'onError': (event) =>
                            playerReject event.data
                            @emit YouTubePlayer.Events.Error, event
                        'onApiChange': (event) => @emit YouTubePlayer.Events.ApiChange, event
                );

                # on size change of the layer, resize the iframe
                @on "change:width", -> @_player.width = @width
                @on "change:height", -> @_player.height = @height

        # calling super causes @define properties being assigned
        super options

        @_element.appendChild div

    @define "video",
        get: -> @_video
        set: (video) ->
            @_video = video
            @_playerReady.then =>
                @_player.cueVideoById video
                @_player.playVideo() if @playerVars?.autoplay
                @emit YouTubePlayer.Events.Loaded, @_player

    @define "playerVars",
        get: -> @_playerVars
        set: (value) -> @_playerVars = value

module?.exports = YouTubePlayer
