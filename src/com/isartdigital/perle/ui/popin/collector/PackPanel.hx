package com.isartdigital.perle.ui.popin.collector;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.TimesInfo;
import com.isartdigital.perle.game.TimesInfo.Clock;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VCollectorHeaven;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author de Toffoli Matthias
 */
class PackPanel extends SmartComponent
{

	private var vBuildingLink:VCollector;
	private var timeText:TextSprite;
	private var gainText:TextSprite;
	private var pack:ProductionPack;
	
	public function new(pID:String, i:Int) 
	{
		super(pID);
		vBuildingLink = cast(BuildingHud.virtualBuilding, VCollector);
		
		var spawner:UISprite = cast (SmartCheck.getChildByName(this, AssetName.PANEL_COLLECTOR_SPAWNER_ICON), UISprite);
		var icon:UISprite = new UISprite(Std.is(vBuildingLink, VCollectorHeaven) ? AssetName.PROD_ICON_WOOD_LARGE:AssetName.PROD_ICON_STONE_LARGE);
		
		icon.position = spawner.position;
		
		spawner.parent.removeChild(spawner);
		
		addChild(icon);
		
		timeText = cast(SmartCheck.getChildByName(this, AssetName.PANEL_COLLECTOR_TIME_TEXT), TextSprite);
		gainText = cast(SmartCheck.getChildByName(this, AssetName.PANEL_COLLECTOR_GAIN), TextSprite);
		
		pack = vBuildingLink.myPacks[i];
		
		var lClock:Clock = TimesInfo.getClock(pack.time);
		timeText.text = lClock.minute + ":" + lClock.seconde;
		
		gainText.text = "" + pack.quantity;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
}