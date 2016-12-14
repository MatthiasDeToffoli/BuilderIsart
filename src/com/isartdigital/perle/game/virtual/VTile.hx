package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.ClippingManager;
import com.isartdigital.perle.game.managers.IdManager;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;
import pixi.core.math.Point;
import pixi.flump.Movie;


 // todod a utilé
//typedef Region = {
	// (var "bâtiment déplacé")
	// idem hud contextuel
	// bizarre de le mettre ici à mon avis
	/*var floor3;
	var floor2;
	var floor1;*/
	/*var added:Bool;
	var building:Map<Int, Map<Int, VBuilding>>;
	var ground:Map<Int, Map<Int, VGround>>;
	var background: String;
}*/

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
	
	// todo : tjrs immediate visible ? car sert pas pr le load save
	public static function buildInsideRegion (pRegion:Region, pImmediateVisible:Bool = false):Void {
		
		// todo : add background ! :p
		// et enlever tile ? ou tile transparente ? plutôt enlever, huuum
		// et grille blanche par-dessus ?
		
		for (x in 0...Ground.COL_X_LENGTH) {	
			for (y in 0...Ground.ROW_Y_LENGTH) {
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
			
		buildInsideRegion(RegionManager.worldMap[0][0]);
	}
	
	public static function buildFromSave (pSave:Save):Void {
		var lLength:UInt = pSave.ground.length;
		
		for (i in 0...lLength)
			new VGround(pSave.ground[i]);
			
		lLength = pSave.building.length;
		for (i in 0...lLength)
			new VBuilding(pSave.building[i]);
	}

	/*
	private static function init ():Void {
		currentRegion = { 
			added:true,
			building:new Map<Int, Map<Int, VBuilding>>(),
			ground:new Map<Int, Map<Int, VGround>>(),
			background: "BgHell1"
		};
		
		// no final place, here just to see integration
		var tmpBg:Movie = new Movie(currentRegion.background.substring(0, currentRegion.background.length - 1));
		tmpBg.scale.set(2);
		GameStage.getInstance().getGameContainer().addChildAt(tmpBg, 0);
	}*/

		
	public function new (pDescription:TileDescription) {
		super();
		tileDesc = pDescription;
		
		var regionPos:Index = RegionManager.regionPosToFirstTile( {
			x: pDescription.regionX, 
			y: pDescription.regionY
		});
		
		position = IsoManager.modelToIsoView(new Point(
			tileDesc.mapX + regionPos.x, 
			tileDesc.mapY + regionPos.y
		));
		
		positionClippingMap = {
			x:cast(ClippingManager.posToClippingMap(position).x, Int),
			y:cast(ClippingManager.posToClippingMap(position).y, Int)
		}
		
		addToClippingList();
	}
		
	/**
	 * Determine the position of the Cell in the Array and add it.
	 * The 2d array itself is paralell to the camera (not isoView)
	 * @param	isBuilding
	 */
	private function addToClippingList():Void {
		var clippingMapPos:Point = ClippingManager.posToClippingMap(position);
		var xRow:Int = cast(clippingMapPos.x, Int);
		var yCol:Int = cast(clippingMapPos.y, Int);
		
		if (clippingMap[xRow] == null) // Map<Int, Map<Int, Array<VTile>>>;
			clippingMap[xRow] = new Map<Int, Array<VTile>>();
		if (clippingMap[xRow][yCol] == null)
			clippingMap[xRow][yCol] = new Array<VTile>();
		
		// array length should be max 2 if only ground and building can be on each other !
		clippingMap[xRow][yCol].push(this);
	}
	
}