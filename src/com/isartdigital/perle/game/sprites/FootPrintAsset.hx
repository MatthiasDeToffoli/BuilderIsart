package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.managers.PoolingManager;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * ...
 * @author Alexis
 */
class FootPrintAsset extends Tile
{
	
	private static inline var FOOTPRINT_ASSET:String = "FootPrint"; 
	private static inline var FOOTPRINT_RED:String = "red"; 
	private static inline var FOOTPRINT_GREEN:String = "green"; 
	private static inline var FOOTPRINT_YELLOW:String = "yellow"; 
	public static var footPrint:FootPrintAsset;
	public static var footPrintArray:Array<Array<FootPrintAsset>>;
	public static var arrayContainerFootPrint:Array<Array<Container>>;
	
	public static function createFootPrint(pJ:Int,pI:Int):Void {
		footPrint = PoolingManager.getFromPool(FOOTPRINT_ASSET);
		
		footPrint.init();
		var lContainer:Container = new Container();
		lContainer.addChild(footPrint);
        footPrint.start();
		footPrintArray[pJ][pI] = footPrint;
		arrayContainerFootPrint[pJ][pI] = lContainer;
	}
	
	public function setStateCantBePut():Void {
		setState(DEFAULT_STATE);
		setState(FOOTPRINT_RED);
	}
	
	public function setStateCanBePut():Void {
		setState(DEFAULT_STATE);
		setState(FOOTPRINT_GREEN);
	}
	
	public function setStateAreaEffect():Void {
		setState(FOOTPRINT_YELLOW);
	}
	
	override public function init():Void {
		super.init();
	}

	public function new(?pAssetName:String) 
	{
		super(pAssetName);
		
	}
	
}