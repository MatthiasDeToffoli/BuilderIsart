package com.isartdigital.perle.ui.hud.building;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager.Population;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author de Toffoli Matthias
 */
class SoulCounterHouse extends SmartComponent
{
	
	public function new() 
	{
		super(AssetName.HOUSE_SOUL_COUNTER);
		
		var pPop:Population = cast(BuildingHud.virtualBuilding, VHouse).getPopulation();
		var counter:TextSprite = cast(SmartCheck.getChildByName(this,"_infos_house_txt"));
		counter.text = pPop.quantity + "/" + pPop.max;
		
		var spawner:UISprite = cast(SmartCheck.getChildByName(this, "_infos_house_icon"),UISprite);
		
		var aName:String = "";
		
		if (BuildingHud.virtualBuilding.alignementBuilding == Alignment.heaven) aName = AssetName.PROD_ICON_SOUL_HEAVEN_SMALL;
		else aName = AssetName.PROD_ICON_SOUL_HELL_SMALL;
		var soulGraphic:UISprite = new UISprite(aName);
		soulGraphic.position = spawner.position;
		addChild(soulGraphic);
		spawner.parent.removeChild(spawner);
		
	}
	
	override public function destroy():Void 
	{
		if (parent != null) parent.removeChild(this);
		super.destroy();
	}
	
	
	
}