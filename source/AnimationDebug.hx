package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.desktop.Clipboard;

/**
	*DEBUG MODE
 */
class AnimationDebug extends FlxState
{
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var ghostchar:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var GHOST_curAnim:Int = 0;
	public static var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;
	var texto:String = '';
	public function new(daAnim:String = 'spooky',isDad:Bool=true)
	{
		super();
		this.daAnim = daAnim;
		AnimationDebug.isDad = isDad;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);


		if (isDad)
		{
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;

			char = dad;
			dad.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0,daAnim);
			bf.screenCenter();
			bf.debugMode = true;

			char = bf;
			bf.flipX = false;
		}
ghostchar = new Character(0, 0, daAnim, !isDad);
ghostchar.alpha = 0.5;
ghostchar.debugMode = true;
ghostchar.screenCenter();
			ghostchar.flipX != isDad;
			add(char);
			add(ghostchar);
		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;
		texto = '';
		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + " " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			var b = StringTools.replace(text.text, '[', '');
			var c = StringTools.replace(b, ']', '');
			var d = StringTools.replace(c, ',', ' ');
			dumbTexts.add(text);
			texto += d + '\n';
			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.justPressed.ESCAPE)
		{
			LoadingState.loadAndSwitchState(new PlayState());
		}

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;
/*
		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}*/

		if (FlxG.keys.justPressed.C && FlxG.keys.pressed.CONTROL)
		{
			openfl.system.System.setClipboard(texto);
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}
		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (FlxG.keys.justPressed.B)
		{
			ghostchar.visible = !ghostchar.visible;
		}
		
		if (FlxG.keys.justPressed.I)
		{
			GHOST_curAnim -= 1;
		}
		if (FlxG.keys.justPressed.K)
		{
			GHOST_curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.K || FlxG.keys.justPressed.I )
		{
			ghostchar.playAnim(animList[curAnim]);
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP){
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
				ghostchar.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
				
			}
			if (downP){
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
				ghostchar.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			}
			if (leftP){
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
				ghostchar.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			}
			if (rightP){
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;
				ghostchar.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;
			}

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		super.update(elapsed);
	}
}
