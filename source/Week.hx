package;

import sys.io.File;
import sys.FileSystem;
import openfl.utils.Assets;
import haxe.Json;

typedef SwagWeek =
{
	var songs:Array<SwagSongs>;
	var characters:Array<String>;
	var name:String;
	var locked:Bool;
	var background:String;
	var backgroundColor:String;
	var unlockAfter:String;
	var hiddenUntilUnlocked:Bool;
}

typedef SwagSongs =
{
	var name:String;
}

class Week
{
	public static var currentLoadedWeeks:Map<String, SwagWeek> = [];
	public static var weeksList:Array<String> = [];

	public static function loadJsons(isStoryMode:Bool = false)
	{
		currentLoadedWeeks.clear();
		weeksList = [];

		final list:Array<String> = CoolUtil.coolTextFile(Paths.ttxt('weeks/weekList'));
		for (i in 0...list.length)
		{
			if (!currentLoadedWeeks.exists(list[i]))
			{
				var week:SwagWeek = parseJson(Paths.jjson('weeks/' + list[i]));
				if (week != null)
				{
					if (week != null && (isStoryMode))
					{
						currentLoadedWeeks.set(list[i], week);
						weeksList.push(list[i]);
					}
				}
			}
		}
	}

	public static function parseJson(path:String):SwagWeek
	{
		var rawJson:String = null;

		if (FileSystem.exists(path))
			rawJson = File.getContent(path);

		return Json.parse(rawJson);
	}
}