package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import sys.FileSystem;
import sys.io.File;

class NoteSplash extends FlxSprite
{
	private var idleAnim:String;
	private var textureLoaded:String = null;
    public var daTex = PlayState.SONG.splashskin;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0, noteTexture:String=null) {
		super(x, y);

		var path = "";
		var balls:Array<String> = [TitleState.curDir,"assets"];
		var stopLookin = false;

		if (noteTexture != null && noteTexture.length >0 && noteTexture != ''){
			daTex = noteTexture;
		}

		for (i in balls){
			if (!stopLookin){
				if (FileSystem.exists(i + "/shared/images/"+daTex+".xml")){
					path = i + "/shared/images/"+daTex+".xml";
					stopLookin = true;
					break;
				}
			}
		}

		trace(daTex+": "+path);

		frames = FlxAtlasFrames.fromSparrow(Paths.getbmp(daTex), File.getContent(path));

		loadAnims();

		setupNoteSplash(x, y, note);
		antialiasing = true;
	}

	public function setupNoteSplash(x:Float, y:Float, note:Int = 0) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		alpha = 0.6;

		offset.set(10, 10);

		var animNum:Int = FlxG.random.int(1, 2);
		animation.play('note' + note + '-' + animNum, true);
		if(animation.curAnim != null)animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
	}

	function loadAnims() {
		for (i in 1...3) {
			animation.addByPrefix("note1-" + i, "note splash blue " + i, 24, false);
			animation.addByPrefix("note2-" + i, "note splash green " + i, 24, false);
			animation.addByPrefix("note0-" + i, "note splash purple " + i, 24, false);
			animation.addByPrefix("note3-" + i, "note splash red " + i, 24, false);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim != null)if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}