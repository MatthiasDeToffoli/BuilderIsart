package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;
import com.isartdigital.perle.game.virtual.vBuilding.VInternHouse;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VMarketingHouse;
import com.isartdigital.perle.ui.contextual.VHudContextual;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.perle.ui.popin.InfoBuilding;
import com.isartdigital.perle.ui.popin.InternHousePopin;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.perle.ui.popin.collector.CollectorPopin;
import com.isartdigital.perle.ui.popin.marketing.MarketingPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.math.Point;

/**
 * ...
 * @author Alexis
 */
class BHBuilt extends BHBuiltUndestoyable
{
	
	private var btnDestroy:SmartButton;
	private var soulConter:SoulCounterHouse;

	
	public function new(pID:String=null) 
	{
		super(pID);
		if (Std.is(BuildingHud.virtualBuilding, VHouse)) addSoulCounter();
	}
	
	public function addSoulCounter():Void {
		soulConter = new SoulCounterHouse();
		Hud.getInstance().addSecondaryComponent(soulConter);
	}
	
	override public function setMoveAndDestroy():Void 
	{
		Interactive.addListenerClick(btnDestroy, onClickDestroy);
		super.setMoveAndDestroy();
	}
	
	
	
	override function removeButtonsChange():Void 
	{
		Interactive.removeListenerClick(btnDestroy, onClickDestroy);
		super.removeButtonsChange();
	}
	
	override function findElements():Void 
	{
		btnDestroy = cast(getChildByName("ButtonDestroyBuilding"), SmartButton);
		super.findElements();
	}
	
	public function onClickDestroy(): Void {
		removeButtonsChange();
		UIManager.getInstance().openPopin(BuildingDestroyPoppin.getInstance());
		removeListenerGameContainer();
	}
	
	override public function destroy():Void 
	{
		Interactive.removeListenerClick(btnDestroy, onClickDestroy);
		if (soulConter != null) soulConter.destroy();
		super.destroy();
	}
	
}