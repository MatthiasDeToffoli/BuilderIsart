package com.isartdigital.perle.ui.hud.dialogue;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.utils.ui.smart.SmartComponent;

/**
 * ...
 * @author Rafired
 */
class IconsFtue extends SmartComponent
{
	private static var iconsArray:Array<Int>;
	private static var icon5:SmartComponent;
	private static var icon6:SmartComponent;
	private static var icon7:SmartComponent;
	private static var icon8:SmartComponent;
	private static var icon9:SmartComponent;
	
	public function new() 
	{
		super(AssetName.FTUE_ICONS);
		createIndicatorIcons();
	}
	
	private function createIndicatorIcons() {
		iconsArray =  [];
		iconsArray = [5, 6, 7, 8, 9];
	
		/*icon5 = cast(getChildByName(AssetName.FTUE_ICON_5), SmartComponent);	
		icon6 = cast(getChildByName(AssetName.FTUE_ICON_6), SmartComponent);	
		icon7 = cast(getChildByName(AssetName.FTUE_ICON_7), SmartComponent);	
		icon8 = cast(getChildByName(AssetName.FTUE_ICON_8), SmartComponent);	
		icon9 = cast(getChildByName(AssetName.FTUE_ICON_9), SmartComponent);*/	
		setAllFalse();
	}
	
	public static function setAllFalse() {
		icon5.visible = false;
		icon6.visible = false;
		icon7.visible = false;
		icon8.visible = false;
		icon9.visible = false;
	}
	
	public static function setIconOn(pDialogue:Int):SmartComponent {
		var lIcon:SmartComponent;
		lIcon = null;
		switch(pDialogue) {
			case 5 : lIcon = icon5;
			case 6 : lIcon = icon6;
			case 7 : lIcon = icon7;
			case 8 : lIcon = icon8;
			case 9 : lIcon = icon9;
		}
		
		if(lIcon !=null)
			lIcon.visible = true;
			
		return lIcon;
	}
	
}