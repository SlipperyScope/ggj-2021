extends Node
class_name Blurb

export (AudioStreamSample) var BlurbAudio
export (String, MULTILINE) var BlurbText
export (Texture) var FaceTexture
export (String) var CharacterName: String = "Name"
export var NoAudio = false
export var DefaultTextSpeed = 20
var Played = false