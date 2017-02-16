package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.hud.building.valuesChange.ValueChange;
import com.isartdigital.perle.ui.hud.building.valuesChange.ValueGain;
import com.isartdigital.perle.ui.hud.building.valuesChange.ValueLost;
import com.isartdigital.utils.game.GameStage;
import haxe.Timer;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * ...
 * @author de Toffoli Matthias
 */
class ValueChangeManager
{

	public static var iconByType:Map<GeneratorType,String>;
	private static var textContainer:Container;
	public static inline var TIMESANIM:Int = 50;
	public static inline var VALUEMOOV:Int = 250;
	public static inline var MOOVPERCENT:Int = 5;
	
	public static function awake():Void {
		iconByType = [
		GeneratorType.buildResourceFromHell => AssetName.PROD_ICON_STONE,
		GeneratorType.buildResourceFromParadise => AssetName.PROD_ICON_WOOD,
		GeneratorType.soft => AssetName.PROD_ICON_SOFT,
		GeneratorType.hard => AssetName.PROD_ICON_HARD
		];
		
		textContainer = new Container();
		
		GameStage.getInstance().getGameContainer().addChild(textContainer);
	}
	
	public static function addTextLost(pPos:Point, pType:Alignment, pName:String){
		var i:Int,l:Int;
		var gains:Map<GeneratorType,Int> = BuyManager.getPrice(pName);
		var lKeys:Dynamic = gains.keys();
		l = lKeys.arr.length;
		addAndPositionText(pPos, new ValueLost(lKeys.arr[0], gains[lKeys.arr[0]]));
		
		if (l == 1) return;
		
		for (i in 1...l) {
			if (gains[lKeys.arr[i]] != null){
				var nextLost:ValueLost = new ValueLost(lKeys.arr[i], gains[lKeys.arr[i]]);
				nextLost.position = pPos.clone();
				Timer.delay(nextLost.inWait, 500 * i);
			}
			
		}
		
	}
	
	public static function addTextLostForRegion(pPos:Point, pType:GeneratorType, pGain:Float):Void {
		addAndPositionText(pPos, new ValueLost(pType,pGain));
	}
	
	public static function addTextGain(pPos:Point, pType:GeneratorType, pGain:Float):Void {
		addAndPositionText(pPos, new ValueGain(pType,pGain));
	}
	
	private static function addAndPositionText(pPos:Point, pText:ValueChange):Void{
		pText.position = pPos.clone();
		addText(pText);
	}
	
	public static function addText(pText:ValueChange):Void {
		pText.init();
		textContainer.addChild(pText);
	}
	
}