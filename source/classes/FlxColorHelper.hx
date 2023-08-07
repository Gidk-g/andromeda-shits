package classes;

import flixel.math.FlxMath;
import flixel.util.FlxColor;

class FlxColorHelper {
	public static var fc:FlxColor;

	public var color(get, null):Int;

	public function get_color():Int {
		return fc;
	}

	public var alpha(get, set):Int;

	public function get_alpha():Int {
		return fc.alpha;
	}

	public function set_alpha(obj:Int):Int {
		fc.alpha = obj;
		return obj;
	}

	public var alphaFloat(get, set):Float;

	public function get_alphaFloat():Float {
		return fc.alphaFloat;
	}

	public function set_alphaFloat(obj:Float):Float {
		fc.alphaFloat = obj;
		return obj;
	}

	public var black(get, set):Float;

	public function get_black():Float {
		return fc.black;
	}

	public function set_black(obj:Float):Float {
		fc.black = obj;
		return obj;
	}

	public var blue(get, set):Int;

	public function get_blue():Int {
		return fc.blue;
	}

	public function set_blue(obj:Int):Int {
		fc.blue = obj;
		return obj;
	}

	public var blueFloat(get, set):Float;

	public function get_blueFloat():Float {
		return fc.blueFloat;
	}

	public function set_blueFloat(obj:Float):Float {
		fc.blueFloat = obj;
		return obj;
	}

	public var brightness(get, set):Float;

	public function get_brightness():Float {
		return fc.brightness;
	}

	public function set_brightness(obj:Float):Float {
		fc.brightness = obj;
		return obj;
	}

	public var cyan(get, set):Float;

	public function get_cyan():Float {
		return fc.cyan;
	}

	public function set_cyan(obj:Float):Float {
		fc.cyan = obj;
		return obj;
	}

	public var green(get, set):Int;

	public function get_green():Int {
		return fc.green;
	}

	public function set_green(obj:Int):Int {
		fc.green = obj;
		return obj;
	}

	public var greenFloat(get, set):Float;

	public function get_greenFloat():Float {
		return fc.greenFloat;
	}

	public function set_greenFloat(obj:Float):Float {
		fc.greenFloat = obj;
		return obj;
	}

	public var hue(get, set):Float;

	public function get_hue():Float {
		return fc.hue;
	}

	public function set_hue(obj:Float):Float {
		fc.hue = obj;
		return obj;
	}

	public var lightness(get, set):Float;

	public function get_lightness():Float {
		return fc.lightness;
	}

	public function set_lightness(obj:Float):Float {
		fc.lightness = obj;
		return obj;
	}

	public var magenta(get, set):Float;

	public function get_magenta():Float {
		return fc.magenta;
	}

	public function set_magenta(obj:Float):Float {
		fc.magenta = obj;
		return obj;
	}

	public var red(get, set):Int;

	public function get_red():Int {
		return fc.red;
	}

	public function set_red(obj:Int):Int {
		fc.red = obj;
		return obj;
	}

	public var redFloat(get, set):Float;

	public function get_redFloat():Float {
		return fc.redFloat;
	}

	public function set_redFloat(obj:Float):Float {
		fc.redFloat = obj;
		return obj;
	}

	public var saturation(get, set):Float;

	public function get_saturation():Float {
		return fc.saturation;
	}

	public function set_saturation(obj:Float):Float {
		fc.saturation = obj;
		return obj;
	}

	public var yellow(get, set):Float;

	public function get_yellow():Float {
		return fc.yellow;
	}

	public function set_yellow(obj:Float):Float {
		fc.yellow = obj;
		return obj;
	}

	public static function add(lhs:Int, rhs:Int):Int {
		return fc = FlxColor.add(lhs, rhs);
	}

	public static function fromCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float) {
		return fc = new FlxColor(FlxColor.fromCMYK(Cyan, Magenta, Yellow, Black, Alpha));
	}

	public static function fromHSB(Hue:Float, Saturation:Float, Brightness:Float, Alpha:Float = 1) {
		return fc = new FlxColor(FlxColor.fromHSB(Hue, Saturation, Brightness, Alpha));
	}

	public static function fromHSL(Hue:Float, Saturation:Float, Lightness:Float, Alpha:Float = 1) {
		return fc = new FlxColor(FlxColor.fromHSL(Hue, Saturation, Lightness, Alpha));
	}

	public static function fromInt(Value:Int) {
		return fc = new FlxColor(Value);
	}

	public static function fromRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255) {
		return fc = new FlxColor(FlxColor.fromRGB(Red, Blue, Green, Alpha));
	}

	public static function fromRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1) {
		return fc = new FlxColor(FlxColor.fromRGBFloat(Red, Blue, Green, Alpha));
	}

	public static function fromString(str:String) {
		var color = FlxColor.fromString(str);
		if (color == null)
			return fc = new FlxColor(FlxColor.fromInt(0xFFFFFFFF));
		else
			return fc = new FlxColor(color);
	}

	public function getAnalogousHarmony(Threshold:Int = 30) {
		return fc.getAnalogousHarmony(Threshold);
	}

	public function getColorInfo() {
		return fc.getColorInfo();
	}

	public function getComplementHarmony() {
		return fc.getComplementHarmony();
	}

	public function getDarkened(Factor:Float = 0.2) {
		return fc.getDarkened(Factor);
	}

	public function getInverted() {
		return fc.getInverted();
	}

	public function getLightened(Factor:Float = 0.2) {
		return fc.getLightened(Factor);
	}

	public function getSplitComplementHarmony(Threshold:Int = 30) {
		return fc.getSplitComplementHarmony(Threshold);
	}

	public function getTriadicHarmony() {
		return fc.getTriadicHarmony();
	}

	public static function gradient(color1:Int, color2:Int, steps:Int, ?ease:Float->Float) {
		return FlxColor.gradient(color1, color2, steps, ease);
	}

	public static function interpolate(color1:Int, color2:Int, Factor:Float = 0.5) {
		return fc = FlxColor.interpolate(color1, color2, Factor);
	}

	public static function multiply(color1:Int, color2:Int) {
		return fc = FlxColor.multiply(color1, color2);
	}

	public function setCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1) {
		return fc.setCMYK(Cyan, Magenta, Yellow, Black, Alpha);
	}

	public function setHSB(Hue:Float, Saturation:Float, Brightness:Float, Alpha:Float) {
		return fc.setHSB(Hue, Saturation, Brightness, Alpha);
	}

	public function setHSL(Hue:Float, Saturation:Float, Lightness:Float, Alpha:Float) {
		return fc.setHSL(Hue, Saturation, Lightness, Alpha);
	}

	public function setRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int) {
		return fc.setRGB(Red, Green, Blue, Alpha);
	}

	public function setRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float) {
		return fc.setRGBFloat(Red, Green, Blue, Alpha);
	}

	public static function substract(color1:Int, color2:Int) {
		return fc = FlxColor.subtract(color1, color2);
	}

	public function toHexString(Alpha:Bool = true, Prefix:Bool = true) {
		return fc.toHexString(Alpha, Prefix);
	}

	public function toWebString() {
		return fc.toWebString();
	}

	public function new(color:Int) {
		fc = new FlxColor(color);
	}

	public static var BLACK = 0xFF000000;
	public static var BLUE = 0xFF0000FF;
	public static var BROWN = 0xFF8B4513;
	public static var CYAN = 0xFF00FFFF;
	public static var GRAY = 0xFF808080;
	public static var GREEN = 0xFF008000;
	public static var LIME = 0xFF00FF00;
	public static var MAGENTA = 0xFFFF00FF;
	public static var ORANGE = 0xFFFFA500;
	public static var PINK = 0xFFFFC0CB;
	public static var PURPLE = 0xFF800080;
	public static var RED = 0xFFFF0000;
	public static var TRANSPARENT = 0x00000000;
	public static var WHITE = 0xFFFFFFFF;
	public static var YELLOW = 0xFFFFFF00;
}
