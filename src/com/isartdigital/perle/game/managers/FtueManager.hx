package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.ui.hud.ftue.FtueUI;
import com.isartdigital.utils.game.GameStage;

/**
 * ...
 * @author Rafired
 */
class FtueManager
{
	public static function createFtue():Void {
		GameStage.getInstance().getHudContainer().addChild(FtueUI.getInstance());
		FtueUI.getInstance().open();	
	}
	
	public static function removeFtue():Void {
		GameStage.getInstance().getHudContainer().removeChild(FtueUI.getInstance());	
	}
	
}