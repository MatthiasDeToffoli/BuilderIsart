package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.ClippingManager;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import pixi.core.math.Point;


typedef Index = {
	var x:Int;
	var y:Int;
}


/**
 * This is a VirtualTile
 * correspond to a tile ingame, and is stored in a clippingArray
 * (Should be abstract ?
 * Mélange du virtuel avec les cases du clipping dangereux ?
 * Créer une ClippingCell en plus de VCell ?)
 * @author ambroise
 */
class VTile extends Virtual{
	/**
	 * temporary ! the best way to add road in my mind would be the same way as for buildings...
	 * todo déplacer ds VGround, supprimer plutôt et ajouter cela ds l'éditeur hud ou cheat
	 */ 
	private static var ROAD_MAP:Array<Array<String>> = [
		["","","","","Road_br","Road_tl","",""],
		["","","","Road_br","Road_tl","","",""],
		["Road_v","Road_v","Road_v","Road_c","","","",""],
		["","","","Road_h","","","",""],
		["Road_v","Road_v","Road_v","Road_tl","","","",""],
		["","","","","","","",""],
		["","","","","","","",""],
		["","","","","","","",""],
		["","","","","","","",""],
		["","","","","","","",""],
		["","","","","","","",""],
		["","","","","","","",""]
	];
	
	
	/**
	 * translate an Index to a Point
	 * @param Index
	 * @return Point
	 */
	//this function is necessary beceause save translate enum to array.....
	public static function indexToPoint(pIndex:Index):Point{
			return new Point(pIndex.x, pIndex.y);
	}
	
	/**
	 * translate a Point to an Index
	 * @param Point
	 * @return Index
	 */
	public static function pointToIndex(pPoint:Point):Index{
		return {x:Std.int(pPoint.x), y:Std.int(pPoint.y)};
	}
	public static var clippingMap:Map<Int, Map<Int, Array<VTile>>>;
	
	/**
	 * This is the only part that will be saved from VTile.
	 */
	public var tileDesc:TileDescription;
	
	/**
	 * SURE ? position x,y in Ground.container;
	 * todo : remove ?
	 */
	private var position:Point;
	
	/**
	 * position x,y in clippingMap (!= isoMap) (!= modelMap)
	 */
	private var positionClippingMap:Index;
	
	public static function initClass ():Void {
		clippingMap = new Map<Int, Map<Int, Array<VTile>>>(); 
	}
	
	// nous sers désormé de grille virtuel pour les débug l'appelle à était désactivé :)
	public static function buildInsideRegion (pRegion:Region, pImmediateVisible:Bool = false):Void {
		
		
		var col:Int = pRegion.desc.type == Alignment.neutral ? Ground.COL_X_STYX_LENGTH:Ground.COL_X_LENGTH;
		var row:Int = pRegion.desc.type == Alignment.neutral ? Ground.ROW_Y_STYX_LENGTH:Ground.ROW_Y_LENGTH;
		
		for (x in 0...col) {	
			for (y in 0...row) {
				// todo : supprimer les road d'ici ...
				var tempRoadAssetName:String = (ROAD_MAP[x] != null && ROAD_MAP[x][y] != null && ROAD_MAP[x][y] != "") ? ROAD_MAP[x][y] :"Ground";
				
				var tileDesc:TileDescription = {
					className:"Ground",
					assetName: tempRoadAssetName,
					id:IdManager.newId(),
					regionX:pRegion.desc.x,
					regionY:pRegion.desc.y,
					mapX:x,
					mapY:y
				};
				
				var lGround:VGround = new VGround(tileDesc);
				if (pImmediateVisible)
					lGround.activate();
				
			}
		}
	}
	
	public static function buildWhitoutSave ():Void {
		if (RegionManager.worldMap[0][0] == null)
			throw("first Region not created");
			
		//buildInsideRegion(RegionManager.worldMap[0][0]);
	}
	
	public static function buildFromSave (pSave:Save):Void {
		var lLength:UInt = pSave.ground.length;
		
		for (i in 0...lLength)
			new VGround(pSave.ground[i]);
			
		lLength = pSave.building.length;
		for (i in 0...lLength)
			if (pSave.building[i].isTribunal) VTribunal.getInstance(pSave.building[i]);
			else new VBuilding(pSave.building[i]);
	}

		
	public function new (pDescription:TileDescription) {
		super();
		tileDesc = pDescription;
		
		/*var regionPos:Index = RegionManager.regionPosToFirstTile( {
			x: pDescription.regionX, 
			y: pDescription.regionY
		});*/
		
		var regionPos:Index = RegionManager.worldMap[tileDesc.regionX][tileDesc.regionY].desc.firstTilePos;
		
		position = IsoManager.modelToIsoView(new Point(
			tileDesc.mapX + regionPos.x, 
			tileDesc.mapY + regionPos.y
		));
		
		positionClippingMap = {
			x:cast(ClippingManager.posToClippingMap(position).x, Int),
			y:cast(ClippingManager.posToClippingMap(position).y, Int)
		}
		
		addToClippingList(positionClippingMap);
	}
		
	/**
	 * Determine the position of the Cell in the Array and add it.
	 * The 2d array itself is paralell to the camera (not isoView)
	 * @param	isBuilding
	 */
	private function addToClippingList(pPos:Index):Void {
		
		if (clippingMap[pPos.x] == null)
			clippingMap[pPos.x] = new Map<Int, Array<VTile>>();
		if (clippingMap[pPos.x][pPos.y] == null)
			clippingMap[pPos.x][pPos.y] = new Array<VTile>();
		
		// array length should be max 2 if only ground and building can be on each other !
		clippingMap[pPos.x][pPos.y].push(this);
	}
	
	private function removeFromClippingList ():Void {
		clippingMap[positionClippingMap.x][positionClippingMap.y].splice(
			clippingMap[positionClippingMap.x][positionClippingMap.y].indexOf(this),
			1
		);
	}
	
	override public function destroy():Void {
		removeFromClippingList();
		super.destroy();
	}
	
}