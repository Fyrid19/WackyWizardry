package funkin.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;
	
	var warnText:FlxText;
	
	override function create()
	{
		super.create();
		
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		
		warnText = new FlxText(0, 0, FlxG.width, "Sup bro, looks like you're running an   \n
			outdated version of Psych Engine ("
			+ Main.PSYCH_VERSION
			+ "),\n
			please update to "
			+ TitleState.updateVersion
			+ "!\n
			Press ESCAPE to proceed anyway.\n
			\n
			Thank you for using the Engine!", 32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}
	
	override function update(elapsed:Float)
	{
		if (!leftState)
		{
			if (controls.ACCEPT)
			{
				leftState = true;
				CoolUtil.browserLoad("https://github.com/ShadowMario/FNF-PsychEngine/releases");
			}
			else if (controls.BACK)
			{
				leftState = true;
			}
			
			if (leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1,
					{
						onComplete: function(twn:FlxTween) {
							FlxG.switchState(MainMenuState.new);
						}
					});
			}
		}
		super.update(elapsed);
	}
}
