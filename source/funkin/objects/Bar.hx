package funkin.objects;

import flixel.util.helpers.FlxBounds;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;

class Bar extends FlxSpriteGroup
{
	public var leftBar:FlxSprite;
	public var rightBar:FlxSprite;
	public var bg:FlxSprite;
	public var bgOffset(default, set):FlxPoint = new FlxPoint(0, 0);
	public var valueFunction:Void->Float = null;
	public var percent(default, set):Float = 0;
	public var bounds:FlxBounds<Float> = new FlxBounds(0.0, 0.0);
	public var leftToRight(default, set):Bool = true;
	public var barCenter(default, null):Float = 0;
	
	// you might need to change this if you want to use a custom bar
	public var barWidth(default, set):Int = 1;
	public var barHeight(default, set):Int = 1;
	public var barOffset:FlxPoint = new FlxPoint(3, 3);
	
	private function set_bgOffset(value:FlxPoint)
	{
		bgOffset = value;
		bg.setPosition(bg.x + bgOffset.x, bg.y + bgOffset.y);
		return value;
	}
	
	public function new(x:Float, y:Float, image:String = 'healthBar', valueFunction:Void->Float = null, boundX:Float = 0, boundY:Float = 1, ?width:Int, ?height:Int)
	{
		super(x, y);
		
		this.valueFunction = valueFunction;
		setBounds(boundX, boundY);
		
		if (image.length > 0) bg = new FlxSprite().loadGraphic(Paths.image(image));
		else bg = new FlxSprite().makeGraphic(width, height, FlxColor.WHITE);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setPosition(bg.x + bgOffset.x, bg.y + bgOffset.y);
		
		barWidth = Std.int(bg.width - 6);
		barHeight = Std.int(bg.height - 6);
		
		leftBar = new FlxSprite().makeGraphic(Std.int(bg.width), Std.int(bg.height), FlxColor.WHITE);
		// leftBar.color = FlxColor.WHITE;
		leftBar.antialiasing = antialiasing = ClientPrefs.globalAntialiasing;
		
		rightBar = new FlxSprite().makeGraphic(Std.int(bg.width), Std.int(bg.height), FlxColor.WHITE);
		rightBar.color = FlxColor.BLACK;
		rightBar.antialiasing = ClientPrefs.globalAntialiasing;
		
		add(bg);
		add(leftBar);
		add(rightBar);
		
		regenerateClips();
	}
	
	public var enabled:Bool = true;
	
	override function update(elapsed:Float)
	{
		if (!enabled)
		{
			super.update(elapsed);
			return;
		}
		
		if (valueFunction != null)
		{
			var value:Null<Float> = FlxMath.remapToRange(FlxMath.bound(valueFunction(), bounds.min, bounds.max), bounds.min, bounds.max, 0, 100);
			percent = (value != null ? value : 0);
		}
		else percent = 0;
		super.update(elapsed);
	}
	
	public function setBounds(min:Float, max:Float)
	{
		bounds.min = min;
		bounds.max = max;
	}
	
	public function setColors(left:FlxColor = null, right:FlxColor = null, ?back:FlxColor = null)
	{
		if (left != null) leftBar.color = left;
		if (right != null) rightBar.color = right;
		if (back != null) bg.color = back;
	}
	
	public function updateBar()
	{
		if (leftBar == null || rightBar == null) return;
		
		leftBar.setPosition(bg.x - bgOffset.x, bg.y - bgOffset.y);
		rightBar.setPosition(bg.x - bgOffset.x, bg.y - bgOffset.y);
		
		var leftSize:Float = 0;
		if (leftToRight) leftSize = FlxMath.lerp(0, barWidth, percent / 100);
		else leftSize = FlxMath.lerp(0, barWidth, 1 - percent / 100);
		
		leftBar.clipRect.width = leftSize;
		leftBar.clipRect.height = barHeight;
		leftBar.clipRect.x = barOffset.x;
		leftBar.clipRect.y = barOffset.y;
		
		rightBar.clipRect.width = barWidth - leftSize;
		rightBar.clipRect.height = barHeight;
		rightBar.clipRect.x = barOffset.x + leftSize;
		rightBar.clipRect.y = barOffset.y;
		
		barCenter = leftBar.x + leftSize + barOffset.x;
		
		// flixel is retarded
		leftBar.clipRect = leftBar.clipRect;
		rightBar.clipRect = rightBar.clipRect;
	}
	
	public function regenerateClips()
	{
		if (leftBar != null)
		{
			leftBar.setGraphicSize(Std.int(bg.width), Std.int(bg.height));
			leftBar.updateHitbox();
			leftBar.clipRect = new FlxRect(0, 0, Std.int(bg.width), Std.int(bg.height));
		}
		if (rightBar != null)
		{
			rightBar.setGraphicSize(Std.int(bg.width), Std.int(bg.height));
			rightBar.updateHitbox();
			rightBar.clipRect = new FlxRect(0, 0, Std.int(bg.width), Std.int(bg.height));
		}
		updateBar();
	}
	
	private function set_percent(value:Float)
	{
		var doUpdate:Bool = false;
		if (value != percent) doUpdate = true;
		percent = value;
		
		if (doUpdate) updateBar();
		return value;
	}
	
	private function set_leftToRight(value:Bool)
	{
		leftToRight = value;
		updateBar();
		return value;
	}
	
	private function set_barWidth(value:Int)
	{
		barWidth = value;
		regenerateClips();
		return value;
	}
	
	private function set_barHeight(value:Int)
	{
		barHeight = value;
		regenerateClips();
		return value;
	}
}
