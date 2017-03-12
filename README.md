# YouTube Player for Framer

[Framer](https://framer.com) module for displaying YouTube videos.
It wraps [standard YouTube iFrame player](https://developers.google.com/youtube/iframe_api_reference), so the player itself can be manipulated in many interesting ways.

TODO: image

## Examples

TODO: example

## Installation

```
$ cd /your/project.framer
$ npm install framer-youtube-player --save
```

## How to use

```coffeescript
YouTubePlayer = require 'framer-youtube-player'

youtube = new YouTubePlayer
    video: "9bZkp7q19f0"
    width: 400
    height: 225
    playerVars: # see https://developers.google.com/youtube/player_parameters
        autoplay: 1
        controls: 0
```

You can also subscribe to different events:

```coffeescript
youtube.on YouTubePlayer.Events.Loaded, (player, target) ->
	print 'YouTube Loaded'
	player.playVideo() # see https://developers.google.com/youtube/iframe_api_reference#Playback_controls

```

## API

### new YouTubePlayer

Instantiates a new instance of YouTubePlayer.

#### Available options

```coffeescript
youtube = new YouTubePlayer
    # all the standard Layer options, like width, height, parent and blur
    video: <string> # YouTube video ID, like "9bZkp7q19f0"
    playerVars: <object>
        autoplay: <number> (0 || 1)
        controls: <number> (0 || 1)
        # see https://developers.google.com/youtube/player_parameters for other options
```

All the options are optional.

### youtube.video

Can set video for playing.

### Events

YouTubePlayer supports all the events that standard [iframe player supports](https://developers.google.com/youtube/iframe_api_reference#Events),
as well as special Loaded event.

#### YouTubePlayer.Events.Loaded

Raises when video is loaded. At this point, you can start using [player API](https://developers.google.com/youtube/iframe_api_reference).

```coffeescript
youtube.on YouTubePlayer.Events.Loaded, (player, targetComponent) ->
    player.seekTo(10)
    player.playVideo()
```

#### YouTubePlayer.Events.Ready

Standard [onReady event](https://developers.google.com/youtube/iframe_api_reference#Events) of iframe player.

```coffeescript
youtube.on YouTubePlayer.Events.Ready, (event, targetComponent) ->
    player = event.target
```

#### YouTubePlayer.Events.StateChange

Standard [onStateChange event](https://developers.google.com/youtube/iframe_api_reference#Events) of iframe player.

```coffeescript
youtube.on YouTubePlayer.Events.StateChange, (event, targetComponent) ->
    player = event.target
    state = event.data
```

State is one of following:
- -1 (unstarted)
- 0 (ended)
- 1 (playing)
- 2 (paused)
- 3 (buffering)
- 5 (video cued)

#### YouTubePlayer.Events.PlaybackQualityChange

Standard [onPlaybackQualityChange event](https://developers.google.com/youtube/iframe_api_reference#Events) of iframe player.

```coffeescript
youtube.on YouTubePlayer.Events.PlaybackQualityChange, (event, targetComponent) ->
    player = event.target
    quality = event.data
```

Quality is one of following strings:
- small
- medium
- large
- hd720
- hd1080
- highres

#### YouTubePlayer.Events.PlaybackRateChange

Standard [onPlaybackRateChange event](https://developers.google.com/youtube/iframe_api_reference#Events) of iframe player.

```coffeescript
youtube.on YouTubePlayer.Events.PlaybackRateChange, (event, targetComponent) ->
    player = event.target
    playbackRate = event.data
```

#### YouTubePlayer.Events.Error

Standard [onError event](https://developers.google.com/youtube/iframe_api_reference#Events) of iframe player.

```coffeescript
youtube.on YouTubePlayer.Events.Error, (event, targetComponent) ->
    player = event.target
    errorCode = event.data
```

#### YouTubePlayer.Events.ApiChange

Standard [onApiChange event](https://developers.google.com/youtube/iframe_api_reference#Events) of iframe player.

```coffeescript
youtube.on YouTubePlayer.Events.ApiChange, (event, targetComponent) ->
    player = event.target
    options = player.getOptions 'captions'
```

## Tips

You can set parent layer for YouTubePlayer, so it will be handy to move it around. Currently the Framer Studio's AutoCode feature does not work with custom modules.

```coffeescrips
layerA = new Layer # editable with AutoCode
	x: 200
	y: 300
	width: 400
	height: 225

youtube = new YouTubePlayer
	parent: layerA
	video: "9bZkp7q19f0"
	width: 400
	height: 225

```
