package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class StoryItem extends FlxSprite
{
	public var targetY:Float = 0;
	public var flashingInt:Int = 0;

	public function new(x:Float, y:Float, name:String = '')
	{
		super(x, y);

		loadGraphic(Paths.image('storymenu/' + name));
		TitleState.curDir = "assets";
		antialiasing = true;
	}

	private var isFlashing:Bool = false;

	public function startFlashing():Void
		isFlashing = true;

	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		y = CoolUtil.coolLerp(y, (targetY * 120) + 480, 0.17);

		if (isFlashing)
			flashingInt += 1;

		if (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2))
			color = FlxColor.fromRGB(51, 255, 255);
		else
			color = FlxColor.WHITE;
	}
}