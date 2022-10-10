package;

import Week;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

#if desktop
import Discord.DiscordClient;
#end

class StoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = [];
	public static var loadedWeeks:Array<SwagWeek> = [];
	public static var loadedWeekList:Array<String> = [];

	private var scoreText:FlxText;
	private var curDifficulty:Int = 1;
	private var txtWeekTitle:FlxText;
	private var curWeek:Int = 0;
	private var txtTracklist:FlxText;
	private var grpWeekText:FlxTypedGroup<StoryItem>;
	private var grpWeekCharacters:FlxTypedGroup<StoryCharacter>;
	private var grpLocks:FlxTypedGroup<FlxSprite>;
	private var difficultySelectors:FlxGroup;
	private var sprDifficulty:FlxSprite;
	private var leftArrow:FlxSprite;
	private var rightArrow:FlxSprite;

	override function create()
	{
		Week.loadJsons(true);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		grpWeekText = new FlxTypedGroup<StoryItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		loadedWeeks = [];
		loadedWeekList = [];

		for (i in 0...Week.weeksList.length)
		{
			var weekFile:SwagWeek = Week.currentLoadedWeeks.get(Week.weeksList[i]);
			var isLocked:Bool = weekIsLocked(Week.weeksList[i]);
			if (!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				loadedWeekList.push(Week.weeksList[i]);

				var weekThing:StoryItem = new StoryItem(0, 466, Week.weeksList[i]);
				weekThing.y += ((weekThing.height + 20) * i);
				weekThing.targetY = i;
				weekThing.screenCenter(X);
				grpWeekText.add(weekThing);

				if (isLocked)
				{
					var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
					lock.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
					lock.animation.addByPrefix('lock', 'lock');
					lock.animation.play('lock');
					lock.antialiasing = true;
					lock.ID = i;
					grpLocks.add(lock);
				}
			}
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		add(new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51));

		grpWeekCharacters = new FlxTypedGroup<StoryCharacter>();
		add(grpWeekCharacters);

		final daWeek:SwagWeek = loadedWeeks[0];
		for (char in 0...3)
			grpWeekCharacters.add(new StoryCharacter((FlxG.width * 0.25) * (1 + char) - 150, 70, daWeek.characters[char]));

		txtTracklist = new FlxText(FlxG.width * 0.05, 500, 0, "Tracks", 32);
		txtTracklist.setFormat(Paths.font("vcr.ttf"), 32, 0xFFe55777, CENTER);
		add(txtTracklist);

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32);
		add(scoreText);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;
		add(txtWeekTitle);

		changeWeek();
		changeDifficulty();

		#if mobile
		addVirtualPad(LEFT_FULL, A_B);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = loadedWeeks[curWeek].name.toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		difficultySelectors.visible = !weekIsLocked(loadedWeekList[curWeek]);

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
					changeWeek(-1);
				else if (controls.DOWN_P)
					changeWeek(1);
				else if (FlxG.mouse.wheel != 0)
					changeWeek(-FlxG.mouse.wheel);

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				else if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
				selectWeek();
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);

		for (i in 0...grpWeekCharacters.length)
			if (grpWeekCharacters.members[i].animation.curAnim != null && grpWeekCharacters.members[i].animation.curAnim.finished && grpWeekCharacters.members[i].animation.curAnim.name != 'hey')
				grpWeekCharacters.members[i].dance();
	}

	private var movedBack:Bool = false;
	private var selectedWeek:Bool = false;
	private var stopspamming:Bool = false;

	private function selectWeek()
	{
		if (!weekIsLocked(loadedWeekList[curWeek]))
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();

				for (i in 0...grpWeekCharacters.length)
					if (grpWeekCharacters.members[i].animation.getByName('hey') != null)
						grpWeekCharacters.members[i].playAnim('hey');

				stopspamming = true;
			}

			selectedWeek = true;

			PlayState.storyPlaylist = [];

			final daWeek:SwagWeek = loadedWeeks[curWeek];
			for (i in 0...daWeek.songs.length)
				PlayState.storyPlaylist.push(daWeek.songs[i].name);

			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = curWeek;
			PlayState.isStoryMode = true;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	private function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficultyArray.length - 1;
		if (curDifficulty >= CoolUtil.difficultyArray.length)
			curDifficulty = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;
		sprDifficulty.y = leftArrow.y - 15;
		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	private var lerpScore:Int = 0;
	private var intendedScore:Int = 0;

	private function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;
		if (curWeek >= loadedWeeks.length)
			curWeek = 0;

		var bullShit:Int = 0;
		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && !weekIsLocked(loadedWeekList[curWeek]))
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));
		updateText();
	}

	private function weekIsLocked(name:String):Bool
	{
		final daWeek:SwagWeek = Week.currentLoadedWeeks.get(name);
		return (daWeek.locked
			&& daWeek.unlockAfter.length > 0
			&& (!StoryMenuState.weekCompleted.exists(daWeek.unlockAfter) || !StoryMenuState.weekCompleted.get(daWeek.unlockAfter)));
	}

	private function updateText()
	{
		final daWeek:SwagWeek = loadedWeeks[curWeek];
		for (i in 0...grpWeekCharacters.length)
			grpWeekCharacters.members[i].changeCharacter(daWeek.characters[i]);

		txtTracklist.text = "Tracks\n";

		for (i in 0...daWeek.songs.length)
			txtTracklist.text += "\n" + daWeek.songs[i].name;

		txtTracklist.text = txtTracklist.text.toUpperCase();
		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;
		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
