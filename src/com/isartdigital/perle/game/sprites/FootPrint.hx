package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.perle.game.sprites.Phantom.EventExceeding;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.utils.game.GameStage;
import haxe.Json;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * ...
 * @author Alexis
 */
class FootPrint extends Tile
{

	public static var container(default, null):Container;
	
	public static inline var ROTATION_IN_RAD = 0.785398;
	private static inline var DEPLACEMENT_FOOTPRINT_CONST = 100;
	
	
	public static var footPrintPoint:Point;
	private static var lInstance:Phantom;
	
	private static var deplacementFootprint:Int;
	private static var eventArray:Array<Index>;
	
	public function new(?pAssetName:String) 
	{
		super(pAssetName);
		
	}
	
	public static function startClass() {
		Phantom.eExceedingTiles.addListener(Phantom.EVENT_CANT_BUILD,onCantBeBuid);	
	}
	
	override public function init():Void {
		super.init();
	}
	
	public static function initClass():Void {
		container = new Container();
		GameStage.getInstance().getBuildContainer().addChild(container);
	}
	
	/**
	 * Function to create the shadow of the footprint
	 * @param	pInstance of the Shadow
	 */
	public static function createShadow(pInstance:Phantom):Void {
		lInstance = pInstance;
		//point of footprint
		if (Building.BUILDING_NAME_TO_MAPSIZE[lInstance.buildingName].footprint == 0)
			deplacementFootprint = 0;
		else 
			deplacementFootprint = DEPLACEMENT_FOOTPRINT_CONST;
		
		var lX:Int = cast(Building.BUILDING_NAME_TO_MAPSIZE[lInstance.buildingName].width + Building.BUILDING_NAME_TO_MAPSIZE[lInstance.buildingName].footprint * 2,Int);
		var lY:Int = cast(Building.BUILDING_NAME_TO_MAPSIZE[lInstance.buildingName].height + Building.BUILDING_NAME_TO_MAPSIZE[lInstance.buildingName].footprint * 2,Int);
		
		FootPrintAsset.footPrintArray = [];
		FootPrintAsset.arrayContainerFootPrint = [];
		for (j in 0...lY) {
			FootPrintAsset.footPrintArray[j] = [];
			FootPrintAsset.arrayContainerFootPrint[j] = [];
			for (i in 0...lX) {
				FootPrintAsset.createFootPrint(j, i);
				container.addChild(FootPrintAsset.arrayContainerFootPrint[j][i]);
			}	
		}
		eventArray = [];
		setPositionFootPrintAssets(pInstance.position);
	}
	
	private static function onCantBeBuid(pEvent:EventExceeding):Void {
		/*if (pEvent[0] == null)
			return;*/
		//trace(pEvent);
		//trace("onCantBeBuid");
		//trace("length evetnArray: " + pEvent.exceedingTile.length);
		eventArray = pEvent.exceedingTile;
		
		/*for (i in 0...pEvent.length) {
			trace(pEvent[i].x);
			trace(pEvent[i].y);
		}*/
		/*for (i in 0...pEvent.length) {
		}*/
		//var test:Dynamic = Json.stringify(pEvent);
		//trace(pEvent[0].x);
		//trace(pEvent.length);
		
		setPositionFootPrintAssets(pEvent.phantomPosition);
		
		for (i in 0...pEvent.exceedingTile.length) {
			//trace("x: " + pEvent[i].x + " y: " + pEvent[i].y);
			if (FootPrintAsset.footPrintArray[pEvent.exceedingTile[i].x+1] != null &&
				FootPrintAsset.footPrintArray[pEvent.exceedingTile[i].x+1][pEvent.exceedingTile[i].y+1] != null)
				FootPrintAsset.footPrintArray[pEvent.exceedingTile[i].y+1][pEvent.exceedingTile[i].x+1].setStateCantBePut();
		}
		
	}
	
	public static function setPositionFootPrintAssets(pInstancePosition:Point):Void {
		
		for (k in 0...FootPrintAsset.footPrintArray.length) {
			for (l in 0...FootPrintAsset.footPrintArray[k].length) {
				var lPoint:Point = new Point(l-1, k-1);
				lPoint = IsoManager.modelToIsoView(lPoint);
				
				lPoint = new Point(lPoint.x + pInstancePosition.x, lPoint.y + pInstancePosition.y);
				FootPrintAsset.footPrintArray[k][l].position = new Point( lPoint.x, lPoint.y);
				
				/*if (eventArray == null)
					return;*/
				FootPrintAsset.footPrintArray[k][l].setStateCanBePut();
				//checkIfCanBePutted(k, l);
				/*if (l == eventArray[0].x && k == eventArray[0].y)
					FootPrintAsset.footPrintArray[k][l].setStateCantBePut();
				else
					FootPrintAsset.footPrintArray[k][l].setStateCanBePut();*/
			}
		}
	}
	
	/*private static function checkIfCanBePutted(x:Int, y:Int) {
		for (i in 0...eventArray.length) {
			if (x == eventArray[i].x+1 && y == eventArray[i].y+1)
				FootPrintAsset.footPrintArray[x][y].setStateCantBePut();
			else
				FootPrintAsset.footPrintArray[x][y].setStateCanBePut();
		}
	}*/
	
	public static function removeShadow() {
		for (k in 0...FootPrintAsset.footPrintArray.length) {
			for (l in 0...FootPrintAsset.footPrintArray[k].length) {
				FootPrintAsset.footPrintArray[k][l].scale = new Point(1, 1);
				FootPrintAsset.footPrintArray[k][l].recycle();
			}
		}
	}
	
	override public function recycle():Void {
		
		super.recycle();
	}
	
}