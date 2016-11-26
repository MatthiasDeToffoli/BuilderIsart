package com.isartdigital.perle.game.iso;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.StateGraphic;
import js.Lib;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * Manager Iso
 * @author Mathieu Anthoine
 */
class IsoManager
{	
	
	private static var halfWidth:Float;
	private static var halfHeight:Float;
	
	/**
	 * Initialisation du Manager Iso
	 * @param	pTileWidth largeur des tuiles
	 * @param	pTileHeight hauteur des tuiles
	 */
	public static function init (pTileWidth:UInt, pTileHeight:UInt): Void {
		halfWidth = pTileWidth / 2;
		halfHeight = pTileHeight / 2;
	}
	
	/**
	 * Conversion du modèle à la vue Isométrique
	 * @param	pPoint colonne et ligne dans le modèle
	 * @return point en x, y dans la vue
	 */
	public static function modelToIsoView(pPoint:Point):Point {
		return new Point (
			(pPoint.x - pPoint.y)*halfWidth,
			(pPoint.x + pPoint.y)*halfHeight
		);
	}

	/**
	 * Conversion de la vue Isométrique au modèle
	 * @param	pPoint coordonnées dans la vue
	 * @return colonne et ligne dans le modèle (valeurs non arrondies)
	 */
	public static function isoViewToModel(pPoint:Point):Point {
		return new Point (
			(pPoint.y/halfHeight+pPoint.x/halfWidth)/2,
			(pPoint.y/halfHeight-pPoint.x/halfWidth)/2
		);
	}
	
	/**
	 * détermine si l'objet A est devant l'objet B
	 * @param	pA Objet "IZsortable" A
	 * @param	pB Objet "IZsortable" B
	 * @return pA, pB ou null si les objets ne se superposent pas
	 */
	public static function isInFrontOf (pA:DisplayObject, pB:DisplayObject):DisplayObject {
		
		if ((Std.is(pA, StateGraphic) && untyped pA.boxType == BoxType.NONE) || (Std.is(pB, StateGraphic) && untyped pB.boxType == BoxType.NONE)) {
			throw "IsoManager.isFrontOf :: la propriété boxType des StateGraphic ne doit pas être définie à NONE";
			return null;
		}
		
		if (!CollisionManager.hitTestObject(pA, pB)) return null;
		
		if (!Std.is(pA, IZSortable) || !Std.is(pB, IZSortable)) throw "Les objets passés en paramètre doivent implémenter IZSortable";
		
		var lA:IZSortable = cast (pA, IZSortable);
		var lB:IZSortable = cast (pB, IZSortable);
		
		if (lA.rowMax < lB.rowMin) return pB; 
		else if (lB.rowMax < lA.rowMin) return pA;
		
		if (lA.colMax < lB.colMin) return pB; 
		else if (lB.colMax < lA.colMin) return pA;
		
		return null;
	}
	
	/**
	 * Z-sorting des objets transmis à la méthode
	 * @param	pTiles tableau des DisplayObject à trier en Z
	 * @return	tableau trié en Z
	 */
	public static function sortTiles (pTiles:Array<DisplayObject>):Array<DisplayObject> {

		var lNumTiles:Int=pTiles.length;
		var lTile:IZSortable;
		
		for (i in 0...lNumTiles) {
			lTile = cast(pTiles[i], IZSortable);
			lTile.behind = [];
			lTile.inFront = [];
		}

		var lA:IZSortable;
		var lB:IZSortable;
		var lFrontTile:DisplayObject;
		
		for (i in 0...lNumTiles) {
			lA = cast(pTiles[i],IZSortable);
			for (j in (i + 1)...lNumTiles) {
				lB = cast(pTiles[j], IZSortable);
				lFrontTile = isInFrontOf(pTiles[i],pTiles[j]);
				if (lFrontTile!=null) {
					if (lA == cast(lFrontTile,IZSortable)) {
						lA.behind.push(lB);
						lB.inFront.push(lA);
					}
					else {
						lB.behind.push(lA);
						lA.inFront.push(lB);
					}
				}
			}
		}
		
		var lToDraw:Array<IZSortable> = [];

		for (i in 0...lNumTiles) {
			lTile = cast(pTiles[i], IZSortable);
			if (lTile.behind.length == 0) lToDraw.push(lTile);
		}

		var lTilesDrawn:Array<DisplayObject> = [];
		var lFrontTile:IZSortable;
		
		while (lToDraw.length > 0) {
			lTile = lToDraw.pop();
			lTilesDrawn.push(cast(lTile,DisplayObject));
			
			for (j in 0...lTile.inFront.length) {
				lFrontTile = lTile.inFront[j];
				lFrontTile.behind.remove(lTile);
				if (lFrontTile.behind.length == 0) lToDraw.push(lFrontTile);
			}
		}
		
		if (pTiles.length != lTilesDrawn.length)
			throw("Probable error whit colMax/colMin/rowMax/rowMin assignment !");
			
		return lTilesDrawn;
	};
	
	
}