package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets;
import haxe.Json;
import haxe.format.JsonParser;

class MenuCharacter extends FlxSprite
{
	public var character:String;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);
		changeCharacter(character);
	}

	public function changeCharacter(?character:String = 'bf') {
		if(character == null) character = '';
		if(character == this.character) return;

		this.character = character;
		antialiasing = true;
		visible = true;

		var dontPlayAnim:Bool = false;
		scale.set(1, 1);
		updateHitbox();

		switch(character) {
			case '':
				visible = false;
				dontPlayAnim = true;
			default:
		        var rawJson = null;
		        if(rawJson == null) {
			        rawJson = sys.io.File.getContent(Paths.file("images/week-characters/" + character + ".json", TEXT));
		        }
				var charFile:MenuChar = cast Json.parse(rawJson);
				frames = Paths.getSparrowAtlas('week-characters/' + charFile.spritePath);
				animation.addByPrefix('idle', charFile.idle, 24);
				animation.addByPrefix('confirm', charFile.confirm, 24, false);
				if(charFile.scale != 1) {
					scale.set(charFile.scale, charFile.scale);
					updateHitbox();
				}
				offset.set(charFile.offsets[0], charFile.offsets[1]);
				animation.play('idle');
		}
	}
}

typedef MenuChar = {
	var spritePath:String;
	var scale:Float;
	var offsets:Array<Int>;
	var idle:String;
	var confirm:String;
}
