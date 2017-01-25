package com.isartdigital.perle.ui.popin.collector;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author de Toffoli Matthias
 */

 
 
class ProductionPanel extends SmartComponent
{

	private var panels:Array<PackPanel>;
	
	public function new() 
	{
		super(AssetName.COLLECTOR_PANEL);
		
		
		panels = new Array<PackPanel>();
		
		for (i in 0...6)
		if (i < 3) spawnPackPanel(AssetName.PANEL_COLLECTOR_SPAWNER + (i + 1), false,i);
		else spawnPackPanel(AssetName.PANEL_COLLECTOR_SPAWNER + (i + 1), true,i);
		
	}
	
	private function spawnPackPanel(spawnerName:String, isLocked:Bool, i:Int):Void{
		var panel:PackPanel;
		
		if (isLocked) panel = new PackPanelLock(i);
		else panel = new PackPanelUnlock(i);
		
		var spawner:UISprite = cast(SmartCheck.getChildByName(this, spawnerName), UISprite);
		
		panel.position = spawner.position;
		
		spawner.parent.removeChild(spawner);
		
		addChild(panel);
		
		panels.push(panel);
	}
	
}