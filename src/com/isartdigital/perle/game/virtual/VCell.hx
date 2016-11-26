package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.ClippingManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.ClippingManager.EasyRectangle;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;
import com.isartdigital.perle.game.iso.IsoManager;
import pixi.core.math.Point;

/**
 * This is a VirtualCell
 * correspond to a tile ingame, and is stored in a clippingArray
 * (Should be abstract ?
 * Mélange du virtuel avec les cases du clipping dangereux ?
 * Créer une ClippingCell en plus de VCell ?)
 * @author ambroise
 */
class VCell {
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
	
	public static var list:Map<String, Map<Int, Map<Int, VCell>>> = new Map<String, Map<Int, Map<Int, VCell>>>();
	
	public var tileDesc:TileDescription;
	/**
	 * active is true if the instance represented by VCell should be visible on screen
	 */
	public var active(default, null):Bool = false;
	
	/**
	 * position x,y in Ground.container;
	 */
	private var position:Point;
	/**
	 * instance linked to VCell when active
	 */
	private var myInstance:Dynamic;
	
	
	// ! todo : faire une save qui sert d'initial, et un code pour éditer le monde inGame ?
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
		tileDesc = pDescription;
		position = IsoManager.modelToIsoView(new Point(tileDesc.mapX, tileDesc.mapY));
		addToList();
	}
	
	/**
	 * Should not be used, because the only one creating and destroying Buildings
	 * should be VCell (but just in case someone destroy() a Building while forgetting
	 * the VCell)
	 */
	public function removeLink():Void {
		myInstance = null;
	}
	
	/**
	 * Cell is visible and content will be displayed !
	 */
	public function activate():Void {
		if (active)
			throw("VCell is already active !");
		active = true;
		
		// look override in VClass !	
	}
	
	/**
	 * Cell is not visible, content will be wiped out !
	 */
	public function desactivate():Void {
		if (!active)
			throw("VCell is already unactive !");
			
		active = false;
		myInstance.recycle();
		myInstance = null;
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
			list[tileDesc.className] = new Map<Int, Map<Int, VCell>>();
		if (list[tileDesc.className][xRow] == null)
			list[tileDesc.className][xRow] = new Map<Int, VCell>();
			
		list[tileDesc.className][xRow][yCol] = this;
	}
	
	private function linkVirtual():Void {
		myInstance.linkVirtualCell(this);
	}
}