package;

import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import openfl.utils.Assets;

typedef SwagStoryCharacter =
{
	var animations:Array<SwagStoryAnimation>;
	var danceAnimation:Array<String>;
	var scale:Float;
	var antialiasing:Bool;
	var flipX:Bool;
	var flipY:Bool;
}

typedef SwagStoryAnimation =
{
	var animation:String;
	var prefix:String;
	var framerate:Int;
	var looped:Bool;
	var indices:Array<Int>;
	var flipX:Bool;
	var flipY:Bool;
	var offset:Array<Float>;
}

class StoryCharacterData
{
	public static function loadJson(file:String):SwagStoryCharacter
		return parseJson(Paths.jjson('images/menucharacters/' + file));

	public static function parseJson(path:String):SwagStoryCharacter
	{
		var rawJson:String = '';

		if (FileSystem.exists(path))
			rawJson = File.getContent(path);

		return Json.parse(rawJson);
	}
}