package;

import sys.io.File;
import sys.FileSystem;
import openfl.utils.Assets;
import hscript.Parser;
import hscript.Expr;
import hscript.Interp;

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

    public function callFunction(func:String, ?args:Array<Dynamic>)
    {
        if(interp.variables.exists(func))
        {
            var real_func = interp.variables.get(func);

            try {
                if(args == null)
                    real_func();
                else
                    Reflect.callMethod(null, real_func, args);
            } catch(e) {
                trace(e.details());
                trace("ERROR Caused in " + func + " with " + Std.string(args) + " args");
            }
        }

        for(other_script in other_scripts)
        {
            other_script.callFunction(func, args);
        }
    }

    public function setDefaultVariables()
    {
        interp.variables.set("File", File);
        interp.variables.set("FileSystem", FileSystem);
        interp.variables.set("BGSprite", BGSprite);
        interp.variables.set("FlxG", flixel.FlxG);
        interp.variables.set("Assets", openfl.utils.Assets);
        interp.variables.set("LimeAssets", lime.utils.Assets);
        interp.variables.set("FlxSprite", flixel.FlxSprite);
        interp.variables.set("Math", Math);
        interp.variables.set("FlxMath", flixel.math.FlxMath);
        interp.variables.set("MusicBeatState", MusicBeatState);
        interp.variables.set("Alphabet", Alphabet);
        interp.variables.set("AttachedFlxText", AttachedFlxText);
        interp.variables.set("AttachedSprite", AttachedSprite);
        interp.variables.set("TitleState", TitleState);
        interp.variables.set("Std", Std);
        interp.variables.set("StringTools", StringTools);

        interp.variables.set("import", function(class_name:String) {
            var classes = class_name.split(".");

            if(Type.resolveClass(class_name) != null)
                interp.variables.set(classes[classes.length - 1], Type.resolveClass(class_name));
            else if(Type.resolveEnum(class_name) != null)
            {
                var enum_new = {};
                var good_enum = Type.resolveEnum(class_name);

                for(constructor in good_enum.getConstructors())
                {
                    Reflect.setField(enum_new, constructor, good_enum.createByName(constructor));
                }

                interp.variables.set(classes[classes.length - 1], enum_new);
            }
            else
                trace(class_name + " isn't a valid class or enum!");
        });

        interp.variables.set("PlayState", PlayState);
        interp.variables.set("Conductor", Conductor);
        interp.variables.set("Paths", Paths);
        interp.variables.set("CoolUtil", CoolUtil);
        interp.variables.set("Note", Note);
        interp.variables.set("Song", Song);

        interp.variables.set("trace", function(value:Dynamic) {
            trace(value);
        });

        /* WIP
        interp.variables.set("loadScript", function(script_path:String) {
            var new_script = new HScriptHandler(script_path);
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
        */

        interp.variables.set("otherScripts", other_scripts);
        interp.variables.set("currentOptions", PlayState.instance.currentOptions);

        interp.variables.set("bf", PlayState.instance.boyfriend);
        interp.variables.set("gf", PlayState.instance.gf);
        interp.variables.set("dad", PlayState.instance.dad);

        interp.variables.set("removeStage", function() {
            PlayState.instance.remove(PlayState.instance.bg);
            PlayState.instance.remove(PlayState.instance.stageFront);
            PlayState.instance.remove(PlayState.instance.stageCurtains);
        });
    }
}