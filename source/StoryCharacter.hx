package;

import sys.FileSystem;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.Lib;
import openfl.utils.Assets;
import StoryCharacterData as StoryCharacterParse;
import StoryCharacterData.SwagStoryCharacter;

/**
	Class based on Character.hx lmao
**/
class StoryCharacter extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>> = [];
	public var curCharacter:String = 'bf';
	public var danceIdle:Bool = false;

	public function new(x:Float, y:Float, name:String = 'bf')
	{
		super(x, y);

		changeCharacter(name);
	}

	public function changeCharacter(curCharacter:String = 'bf'):Void
	{
		this.curCharacter = curCharacter;

		if (curCharacter == '')
		{
			if (visible == true)
				visible = false;
		}
		else
		{
			if (visible == false)
				visible = true;

			scale.set(1, 1);
			updateHitbox();

			TitleState.curDir = "assets";

			final daCharacter:SwagStoryCharacter = StoryCharacterParse.loadJson(curCharacter);

			if (FileSystem.exists(Paths.xxml('menucharacters/' + curCharacter)))
				frames = FlxAtlasFrames.fromSparrow(Paths.image('menucharacters/' + curCharacter),
					Paths.xxml('menucharacters/' + curCharacter));
			else if (FileSystem.exists(Paths.ttxt('menucharacters/' + curCharacter)))
				frames = FlxAtlasFrames.fromSpriteSheetPacker(Paths.image('menucharacters/' + curCharacter),
					Paths.ttxt('menucharacters/' + curCharacter));
			else if (FileSystem.exists(Paths.jjson('menucharacters/' + curCharacter)))
				frames = FlxAtlasFrames.fromTexturePackerJson(Paths.image('menucharacters/' + curCharacter),
					Paths.jjson('menucharacters/' + curCharacter));

			animOffsets.clear();

			if (daCharacter.animations != null && daCharacter.animations.length > 0)
			{
				for (anim in daCharacter.animations)
				{
					final animAnimation:String = anim.animation;
					final animPrefix:String = anim.prefix;
					final animFramerate:Int = anim.framerate;
					final animLooped:Bool = anim.looped;
					final animIndices:Array<Int> = anim.indices;
					final animOffset:Array<Float> = anim.offset;
					final animFlipX:Bool = anim.flipX;
					final animFlipY:Bool = anim.flipY;

					if (animIndices != null && animIndices.length > 0)
						animation.addByIndices(animAnimation, animPrefix, animIndices, '', animFramerate, animLooped, animFlipX, animFlipY);
					else
						animation.addByPrefix(animAnimation, animPrefix, animFramerate, animLooped, animFlipX, animFlipY);

					if (animOffset != null && animOffset.length > 0)
						addOffset(animAnimation, animOffset[0], animOffset[1]);
					else
						addOffset(animAnimation);
				}
			}
			else
				animation.addByPrefix('idle', 'idle', 24, false);

			if (daCharacter.scale != 1)
			{
				scale.set(daCharacter.scale, daCharacter.scale);
				updateHitbox(); // is this acually needed?
			}

			if (daCharacter.antialiasing == true)
				antialiasing = true;
			else
				antialiasing = daCharacter.antialiasing;

			flipX = daCharacter.flipX;
			flipY = daCharacter.flipY;

			recalculateDanceIdle();
			dance();

			animation.finish();
		}
	}

	private var danced:Bool = false;

	public function dance()
	{
		if (danceIdle)
		{
			danced = !danced;

			if (danced)
				playAnim('danceRight');
			else
				playAnim('danceLeft');
		}
		else if (animation.getByName('idle') != null) {
			playAnim('idle');
		}
	}

	public var danceEveryNumBeats:Int = 2;
	private var settingCharacterUp:Bool = true;

	public function recalculateDanceIdle() {
		var lastDanceIdle:Bool = danceIdle;

		danceIdle = (animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null);

		if(settingCharacterUp)
		{
			danceEveryNumBeats = (danceIdle ? 1 : 2);
		}
		else if(lastDanceIdle != danceIdle)
		{
			var calc:Float = danceEveryNumBeats;
			if(danceIdle)
				calc /= 2;
			else
				calc *= 2;

			danceEveryNumBeats = Math.round(Math.max(calc, 1));
		}

		settingCharacterUp = false;
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		if (animOffsets.exists(AnimName))
			offset.set(animOffsets.get(AnimName)[0], animOffsets.get(AnimName)[1]);
		else
			offset.set(0, 0);
	}

	public function addOffset(Name:String, X:Float = 0, Y:Float = 0)
		animOffsets[Name] = [X, Y];
}
