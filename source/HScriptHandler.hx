package;

import haxe.Json;
import flixel.FlxG;
import haxe.io.Path;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.math.FlxAngle;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.math.FlxMath;
import lime.utils.Assets;
import hscript.Parser;
import hscript.Expr;
import hscript.Interp;
import sys.FileSystem;
import sys.io.File;

/**
    Handles hscript shit for u lmfao
**/
class HScriptHandler
{
    public var script:String;

    public var parser:Parser = new Parser();
    public var program:Expr;
    public var interp:Interp = new Interp();

    public var other_scripts:Array<HScriptHandler> = [];

    public var createPost:Bool = false;

    public function new(hscript_path: String)
    {
        program = parser.parseString(File.getContent(hscript_path));

        parser.allowJSON = true;
        parser.allowTypes = true;
        parser.allowMetadata = true;

        setDefaultVariables();

        interp.execute(program);
    }

    public function start()
    {
        callFunction("create");
    }

    public function update(elapsed:Float)
    {
        callFunction("update", [elapsed]);
    }

    public function callFunction(funcName:String, ?args:Array<Dynamic>)
    {
		if (args == null)
			args = [];

		try {
			var func:Dynamic = interp.variables.get(funcName);
			if (func != null && Reflect.isFunction(func))
				return Reflect.callMethod(null, func, args);
		} catch (error:Dynamic) {
            trace(error);
		}

        for(other_script in other_scripts)
        {
            other_script.callFunction(funcName, args);
        }

		return true;
    }

    public function setDefaultVariables()
    {
		interp.variables.set("Int", Int);
		interp.variables.set("String", String);
		interp.variables.set("Float", Float);
		interp.variables.set("Array", Array);
		interp.variables.set("Bool", Bool);
		interp.variables.set("Dynamic", Dynamic);
		interp.variables.set("Math", Math);
		interp.variables.set("FlxMath", FlxMath);
		interp.variables.set("Std", Std);
		interp.variables.set("StringTools", StringTools);
		interp.variables.set("FlxG", FlxG);
		interp.variables.set("FlxSound", FlxSound);
		interp.variables.set("FlxSprite", FlxSprite);
		interp.variables.set("FlxText", FlxText);
		interp.variables.set("FlxGraphic", FlxGraphic);
		interp.variables.set("FlxTween", FlxTween);
		interp.variables.set("FlxCamera", FlxCamera);
		interp.variables.set("Assets", Assets);
		interp.variables.set("File", File);
		interp.variables.set("FileSystem", FileSystem);
		interp.variables.set("PlayState", PlayState);
		interp.variables.set("FlxGroup", FlxGroup);
		interp.variables.set("FlxTimer", FlxTimer);
		interp.variables.set("FlxTypedGroup", FlxTypedGroup);
		interp.variables.set("CoolUtil", CoolUtil);
		interp.variables.set("Paths", Paths);
		interp.variables.set("Path", Path);
		interp.variables.set("Json", Json);
		interp.variables.set("FlxAngle", FlxAngle);
		interp.variables.set("FlxAtlasFrames", FlxAtlasFrames);
		interp.variables.set("FlxAtlas", FlxAtlas);
		interp.variables.set("Character", Character);
		interp.variables.set("Boyfriend", Boyfriend);
		interp.variables.set("Song", Song);
        interp.variables.set("Controls", Controls);
		interp.variables.set("Conductor", Conductor);
		interp.variables.set("Note", Note);
		interp.variables.set('BGSprite', BGSprite);
        interp.variables.set("FlxColor", classes.FlxColorHelper);
        interp.variables.set("FlxKey", classes.FlxKeyHelper);
        interp.variables.set("BlendMode", classes.BlendModeHelper);
        interp.variables.set("FlxCameraFollowStyle", classes.FlxCameraFollowStyleHelper);
        interp.variables.set("FlxTextAlign", classes.FlxTextAlignHelper);
        interp.variables.set("FlxTextBorderStyle", classes.FlxTextBorderStyleHelper);
        interp.variables.set("StringHelper", classes.StringHelper);

        interp.variables.set("loadScript", function(script_path:String) {
            var new_script = new HScriptHandler(TitleState.curDir + "/" + script_path);
            new_script.start();
            if(createPost)
                new_script.callFunction("createPost");
            other_scripts.push(new_script);
            return other_scripts.length - 1;
        });

        interp.variables.set("unloadScript", function(script_index:Int) {
            if(other_scripts.length - 1 >= script_index)
                other_scripts.remove(other_scripts[script_index]);
        });

		interp.variables.set('add', function(obj:FlxBasic) PlayState.instance.add(obj));
		interp.variables.set('addBehindGF', function(obj:FlxBasic) PlayState.instance.addBehindGF(obj));
		interp.variables.set('addBehindDad', function(obj:FlxBasic) PlayState.instance.addBehindDad(obj));
		interp.variables.set('addBehindBF', function(obj:FlxBasic) PlayState.instance.addBehindBF(obj));
		interp.variables.set('insert', function(pos:Int, obj:FlxBasic) PlayState.instance.insert(pos, obj));
		interp.variables.set('remove', function(obj:FlxBasic, splice:Bool = false) PlayState.instance.remove(obj, splice));

        interp.variables.set("otherScripts", other_scripts);
        interp.variables.set("currentOptions", PlayState.instance.currentOptions);

        interp.variables.set("boyfriend", PlayState.instance.boyfriend);
        interp.variables.set("gf", PlayState.instance.gf);
        interp.variables.set("dad", PlayState.instance.dad);

        interp.variables.set("removeStage", function() {
            PlayState.instance.remove(PlayState.instance.bg);
            PlayState.instance.remove(PlayState.instance.stageFront);
            PlayState.instance.remove(PlayState.instance.stageCurtains);
        });
    }
}