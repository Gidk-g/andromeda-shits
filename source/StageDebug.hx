package;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author bbpanzu
 */
class StageDebug extends MusicBeatState
{
	
	public function new(stageName:String) 
	{
		
		super();
		
		switch(stageName){

		}	

	}
	
	override function update(elapsed:Float) 
	{
		super.update(elapsed);
		var sp = 5;
		if (FlxG.keys.pressed.SHIFT) sp = 20;
		
		if(FlxG.keys.pressed.LEFT)FlxG.camera.scroll.x -= sp;
		if(FlxG.keys.pressed.UP)FlxG.camera.scroll.y -= sp;
		if(FlxG.keys.pressed.RIGHT)FlxG.camera.scroll.x += sp;
		if (FlxG.keys.pressed.DOWN) FlxG.camera.scroll.y += sp;
		
		if(FlxG.keys.pressed.Q)FlxG.camera.zoom -= 0.05;
		if(FlxG.keys.pressed.E)FlxG.camera.zoom += 0.05;
	}
	
	
	public function addSprite(x,y,path:String,scrollFactor:Float=1){
		var sprite:FlxSprite = new FlxSprite(x,y).loadGraphic(Paths.image(path, "shared"));
		sprite.scrollFactor.set(scrollFactor, scrollFactor);
		sprite.active = false;
		sprite.antialiasing = true;
		add(sprite);
	}
	
	public function addAnimPrefix(x,y,path:String,prefix:String,scrollFactor:Float=1){
		var sprite:FlxSprite = new FlxSprite(x, y);
		sprite.frames = Paths.getSparrowAtlas(path, "shared");
		sprite.animation.addByPrefix(prefix,prefix,24);
		sprite.animation.play(prefix);
		sprite.antialiasing = true;
		sprite.scrollFactor.set(scrollFactor, scrollFactor);
		add(sprite);
	}
	public function addAnimIndices(x,y,path:String,prefix:String,indices:Array<Int>,scrollFactor:Float=1){
		var sprite:FlxSprite = new FlxSprite(x, y);
		sprite.frames = Paths.getSparrowAtlas(path, "shared");
		sprite.animation.addByIndices(prefix, prefix, indices, "", 24);
		sprite.animation.play(prefix);
		sprite.antialiasing = true;
		sprite.scrollFactor.set(scrollFactor, scrollFactor);
		add(sprite);
	}
	
}