package com.isartdigital.perle.ui.hud.building.valuesChange;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.ValueChangeManager;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Timer;

/**
 * ...
 * @author de Toffoli Matthias
 */
class ValueChange extends SmartComponent
{
	private var text:TextSprite;
	private var signe:String;
	private var timeLoop:Timer;
	private var basePosY:Float;
	
	public function new(pAssetName:String,pType:GeneratorType, pValue:Float) 
	{
		super(pAssetName);
		
		text = cast(getChildByName(AssetName.VALUES_CHANGE_TEXT), TextSprite);
		var spawner:UISprite = cast(getChildByName(AssetName.VALUES_CHANGE_ICON), UISprite);
		var icon:UISprite = new UISprite(ValueChangeManager.iconByType[pType]);
		icon.position = spawner.position;
		text.text = signe + ResourcesManager.shortenValue(pValue);
		spawner.parent.removeChild(spawner);
		addChild(icon);
		
	}
	
	public function init():Void {
		basePosY = position.y;
		timeLoop = Timer.delay(loop, ValueChangeManager.TIMESANIM);
		timeLoop.run = loop;
	}
	
	public function loop():Void {
		position.y -=  ValueChangeManager.VALUEMOOV *  ValueChangeManager.MOOVPERCENT / 100; 
		alpha = 2 - basePosY/position.y;
		if (position.y <= ( basePosY - ValueChangeManager.VALUEMOOV)) destroy();
	}
	
	public function inWait():Void {
		ValueChangeManager.addText(this);
	}
	
	override public function destroy():Void 
	{
		timeLoop.stop();
		parent.removeChild(this);
		super.destroy();
	}
}