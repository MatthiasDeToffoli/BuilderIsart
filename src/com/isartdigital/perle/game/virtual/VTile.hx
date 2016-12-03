package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.ClippingManager;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;
import pixi.core.math.Point;

// todod a utilé
typedef Region = {
	// (var "bâtiment déplacé")
	// idem hud contextuel
	// bizarre de le mettre ici à mon avis
	/*var floor3;
	var floor2;
	var floor1;*/
	var building:Map<Int, Map<Int, VBuilding>>;
	var ground:Map<Int, Map<Int, VGround>>;
	/*var background;*/
}

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
	
	//public static var currentRegion:Map<String, Map<Int, Map<Int, VTile>>> = new Map<String, Map<Int, Map<Int, VTile>>>();
	public static var currentRegion:Region; // todo: permettre plusieurs région
	
	/**
	 * SURE ? position x,y in Ground.container;
	 * todo : remove ?
	 */
	private var position:Point;
	
	/**
	 * position x,y in currentRegion.building or ground (!= isoMap)
	 */
	private var positionClippingMap:Index;
	
	// ! todo : faire une save qui sert d'initial, et un code pour éditer le monde inGame ?
	// todo : mettre ailleurs ?
	/**
	 * todo :
	 * Temp : build the game whitout Save, a default Save will be used as initial later.
	 */
	public static function buildInitial():Void {
		init();
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
		init();
		var lLength:UInt = pSave.ground.length;
		
		for (i in 0...lLength)
			new VGround(pSave.ground[i]);
			
		lLength = pSave.building.length;
		for (i in 0...lLength)
			new VBuilding(pSave.building[i]);
	}
	
	private static function init ():Void {
		currentRegion = { 
			building:new Map<Int, Map<Int, VBuilding>>(),
			ground:new Map<Int, Map<Int, VGround>>()
		};
	}
		
	public function new(pDescription:TileDescription) {
		super(pDescription);
		position = IsoManager.modelToIsoView(new Point(tileDesc.mapX, tileDesc.mapY));
		positionClippingMap = {
			x:cast(ClippingManager.posToClippingMap(position).x, Int),
			y:cast(ClippingManager.posToClippingMap(position).y, Int)
		}
		//addToList();
	}
		
	/**
	 * Determine the position of the Cell in the Array and add it.
	 * The 2d array itself is paralell to the camera (not isoView)
	 * @param	isBuilding
	 */
	/*private function addToList():Void {
		var clippingMapPos:Point = ClippingManager.posToClippingMap(position);
		var xRow:Int = cast(clippingMapPos.x, Int);
		var yCol:Int = cast(clippingMapPos.y, Int);
		
		
		
		if (list[tileDesc.className] == null)
			list[tileDesc.className] = new Map<Int, Map<Int, VTile>>();
		if (list[tileDesc.className][xRow] == null)
			list[tileDesc.className][xRow] = new Map<Int, VTile>();
			
		list[tileDesc.className][xRow][yCol] = this;
	}*/
	
}