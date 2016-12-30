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
	private static inline var FOOTPRINT_ASSET:String = "FootPrint"; 
	
	public static var footPrint:FootPrint;
	public static var footPrintPoint:Point;
	private static var lInstance:Phantom;
	
	public function new(?pAssetName:String) 
	{
		super(pAssetName);
		
	}
	
	override public function init():Void {
		super.init();
	}
	
	public static function initClass():Void {
		container = new Container();
		GameStage.getInstance().getGameContainer().addChild(container);
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
		if (Building.ASSETNAME_TO_MAPSIZE[lInstance.assetName].footprint == 0)
			footPrintPoint = new Point(0,0); 
		else
			footPrintPoint = new Point( -footPrint.width / 8, -footPrint.height / 2 - 50); //a revenir dessus si je trouves une meileur façon
			
		//position
		footPrint.position = new Point(lInstance.x + footPrintPoint.x, (lInstance.y + footPrintPoint.y)*2);	
		//Give width and height
		footPrint.width = footPrint.width * (Building.ASSETNAME_TO_MAPSIZE[lInstance.assetName].width + Building.ASSETNAME_TO_MAPSIZE[lInstance.assetName].footprint*2);
		footPrint.height = footPrint.height * (Building.ASSETNAME_TO_MAPSIZE[lInstance.assetName].height + Building.ASSETNAME_TO_MAPSIZE[lInstance.assetName].footprint*2);
	
	}
	
	//deplacement en fonction de la position
	public static function doActionShadow() {
		footPrint.position = new Point(lInstance.x + footPrintPoint.x, (lInstance.y + footPrintPoint.y)*2);	
	}
	
	public static function removeShadow() {
		footPrint.scale = new Point(1, 1);
		footPrint.recycle();
	}
	
	override public function recycle():Void {
		
		super.recycle();
	}
	
}