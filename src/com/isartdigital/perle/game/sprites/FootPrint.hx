package com.isartdigital.perle.game.sprites;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.managers.PoolingObject;
import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * ...
 * @author Alexis
 */
class FootPrint extends Tile
{

	public static var container(default, null):Container;
	
	private static inline var ROTATION_IN_RAD = 0.785398;
	private static inline var DEPLACEMENT_FOOTPRINT_CONST = 100;
	private static inline var FOOTPRINT_ASSET:String = "FootPrint"; 
	
	public static var footPrint:FootPrint;
	public static var footPrintPoint:Point;
	private static var lInstance:Phantom;
	
	private static var deplacementFootprint:Float;
	
	public function new(?pAssetName:String) 
	{
		super(pAssetName);
		
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
		footPrint = PoolingManager.getFromPool(FOOTPRINT_ASSET);
        footPrint.init();
        container.addChild(footPrint);
        footPrint.start();
		footPrint.rotation = ROTATION_IN_RAD;
		container.scale.y = 0.5;
		
		//point of footprint
		if (Building.BUILDING_NAME_TO_MAPSIZE[lInstance.buildingName].footprint == 0)
			deplacementFootprint = 0;
		else 
			deplacementFootprint = DEPLACEMENT_FOOTPRINT_CONST;
	
		//position	
		footPrint.position = new Point(lInstance.x, (lInstance.y-deplacementFootprint)*2);		
		//Give width and height
		footPrint.width = footPrint.width * (Building.BUILDING_NAME_TO_MAPSIZE[lInstance.buildingName].width + Building.BUILDING_NAME_TO_MAPSIZE[lInstance.buildingName].footprint*2);
		footPrint.height = footPrint.height * (Building.BUILDING_NAME_TO_MAPSIZE[lInstance.buildingName].height + Building.BUILDING_NAME_TO_MAPSIZE[lInstance.buildingName].footprint*2);
	
	}
	
	//deplacement en fonction de la position
	public static function doActionShadow() {
		footPrint.position = new Point(lInstance.x, (lInstance.y-deplacementFootprint)*2);	
	}
	
	public static function removeShadow() {
		footPrint.scale = new Point(1, 1);
		footPrint.recycle();
	}
	
	override public function recycle():Void {
		
		super.recycle();
	}
	
}