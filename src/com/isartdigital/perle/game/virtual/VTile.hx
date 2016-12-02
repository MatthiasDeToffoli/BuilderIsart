package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.ClippingManager;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;
import pixi.core.math.Point;

/**
 * This is a VirtualCell
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
	
	public static var list:Map<String, Map<Int, Map<Int, VTile>>> = new Map<String, Map<Int, Map<Int, VTile>>>();
	
	/**
	 * position x,y in Ground.container;
	 */
	private var position:Point;

	// ! todo : faire une save qui sert d'initial, et un code pour éditer le monde inGame ?
	// todo : mettre ailleurs ?
	/**
	 * todo :
	 * Temp : build the game whitout Save, a default Save will be used as initial later.
	 */
	public static function buildInitial():Void {
		for (x in 0...Ground.COL_X_LENGTH) {	
			for (y in 0...Ground.ROW_Y_LENGTH) {
				// todo : supprimer les road d'ici ...
				var tempRoadAssetName:String = (ROAD_MAP[x] != null && ROAD_MAP[x][y] != null && ROAD_MAP[x][y] != "") ? ROAD_MAP[x][y] :"Ground";
				
				var tileDesc:TileDescription = {
					className:"Ground",
					assetName: tempRoadAssetName,
					mapX:x,
					mapY:y
				};
				new VGround(tileDesc);
			}
		}
	}
	
	public static function buildFromSave(pSave:Save):Void {
		var lLength:UInt = pSave.ground.length;
		
		for (i in 0...lLength)
			new VGround(pSave.ground[i]);
			
		lLength = pSave.building.length;
		for (i in 0...lLength)
			new VBuilding(pSave.building[i]);
	}
		
	public function new(pDescription:TileDescription) {
		super(pDescription);
		position = IsoManager.modelToIsoView(new Point(tileDesc.mapX, tileDesc.mapY));
		addToList();
	}
		
	/**
	 * Determine the position of the Cell in the Array and add it.
	 * The 2d array itself is paralell to the camera (not isoView)
	 * @param	isBuilding
	 */
	private function addToList():Void {
		var clippingMapPos:Point = ClippingManager.posToClippingMap(position);
		var xRow:Int = cast(clippingMapPos.x, Int);
		var yCol:Int = cast(clippingMapPos.y, Int);
		
		if (list[tileDesc.className] == null)
			list[tileDesc.className] = new Map<Int, Map<Int, VTile>>();
		if (list[tileDesc.className][xRow] == null)
			list[tileDesc.className][xRow] = new Map<Int, VTile>();
			
		list[tileDesc.className][xRow][yCol] = this;
	}
	
}