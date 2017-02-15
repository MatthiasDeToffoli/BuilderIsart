package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.GameConfig;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.ValueChangeManager;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.ui.Button;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author de Toffoli Matthias
 */

 /**
  * button which add new region
  */
class ButtonRegion extends SmartButton
{

	/**
	 * the first case of the region to add
	 */
	private var firstCasePos:Point;
	
	/**
	 * position of the region in world map
	 */
	private var worldMapPos:Point;
	
	private var price:Float;
	
	/**
	 * the type of the region to add
	 */
	private var regionType:Alignment;
	
	public function new(pPos:Point,pWorldPos:Point) 
	{
		super(AssetName.BTN_BUY_REGION);
		firstCasePos = pPos;
		worldMapPos = pWorldPos;
		regionType = (pPos.x < 0) ? Alignment.heaven: Alignment.hell;
		Interactive.addListenerRewrite(this, rewriteTxt);
		rewriteTxt();
		RegionManager.eRegionCreate.on(RegionManager.REGION_CREATED, onRegionCreate);
	}
	
	public function hide():Void {
		alpha = 0.2;
		interactive = false;
	}

	public function show():Void {
		interactive = true;
		alpha = 1;
	}
	
	override function _click(pEvent:EventTarget = null):Void 
	{
		super._click(pEvent);
		rewriteTxt();
		if (DialogueManager.ftueStepRecolt || DialogueManager.ftueStepConstructBuilding ||  DialogueManager.ftueStepOpenPurgatory ||  DialogueManager.ftueStepPutBuilding) 
			return;
			
		if (RegionManager.haveMoneyForBuy(worldMapPos, regionType)){
			ValueChangeManager.addTextLostForRegion(position, GeneratorType.soft, price);
			RegionManager.createRegion(regionType, firstCasePos, VTile.pointToIndex(worldMapPos));
			destroy();
		}
		//ServerManager.addRegionToDataBase(regionType.getName(), VTile.pointToIndex(worldMapPos), VTile.pointToIndex(firstCasePos), this);		
	}
	
	private function rewriteTxt():Void {
		var priceTxt:TextSprite = cast(getChildByName(AssetName.BTN_BUY_REGION_PRICE),TextSprite);
		var config:TableConfig = GameConfig.getConfig();
		price = config.priceRegion * Math.pow(config.factorRegionGrowth, RegionManager.mapNumbersRegion[regionType]);
		
		priceTxt.text = ResourcesManager.shortenValue(price);
	}
	
	private function onRegionCreate(pData:Dynamic):Void {
		rewriteTxt();
	}
	
	override public function destroy():Void 
	{
		RegionManager.eRegionCreate.off(RegionManager.REGION_CREATED, onRegionCreate);
		Interactive.removeListenerRewrite(this, rewriteTxt);
		RegionManager.getButtonContainer().removeChild(this);
		super.destroy();
	}
	
}