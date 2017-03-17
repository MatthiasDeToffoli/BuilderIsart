package com.isartdigital.perle.game.iso;

import com.isartdigital.utils.Debug;
import com.isartdigital.utils.game.CollisionManager;
import com.isartdigital.utils.game.GameStage;
import js.Lib;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

/**
 * Manager Iso
 * @author Mathieu Anthoine
 * @version 0.3.0
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
		
		if (!Std.is(pA, IZSortable) || !Std.is(pB, IZSortable)) throw "Les objets passés en paramètre doivent implémenter IZSortable";
		
		var lA:IZSortable = cast (pA, IZSortable);
		var lB:IZSortable = cast (pB, IZSortable);
		
		if (lA.isoRect != null && lB.isoRect != null) {
			var lRectA:Rectangle = lA.isoRect.clone();
			var lRectB:Rectangle = lB.isoRect.clone();
			var lRectPosA:Point = new Point(lRectA.x, lRectA.y);
			var lRectPosB:Point = new Point(lRectB.x, lRectB.y);
			lRectPosA = GameStage.getInstance().getGameContainer().toLocal(lRectPosA, pA); // the rect is inside the building
			lRectPosB = GameStage.getInstance().getGameContainer().toLocal(lRectPosB, pB);
			lRectA.x = lRectPosA.x;
			lRectA.y = lRectPosA.y;
			lRectB.x = lRectPosB.x;
			lRectB.y = lRectPosB.y;
			//trace(collisionRectRect(lRectA, lRectB));
			// toLocal is needed, or it will bug. Another way would be to create the box into the same geomertric reference.
			if (!collisionRectRect(lRectA, lRectB)) return null;
			
			// toLocal will fail if there is any rescale between containers.
			// One time over 90 the result is different from collisionRectRect.
			//if (untyped !CollisionManager.getIntersection(lRectA,lRectB)) 
			//	return null;
		}
		else Debug.error("isoRect is needed for Z-sorting.");
		//else if (!CollisionManager.hitTestObject(lA.isoBox, lB.isoBox)) return null; // wrong because we need toLocal
		
		if (lA.rowMax < lB.rowMin) return pB; 
		else if (lB.rowMax < lA.rowMin) return pA;
		
		if (lA.colMax < lB.colMin) return pB; 
		else if (lB.colMax < lA.colMin) return pA;
		
		return null;
	}
	
	// fonctionne pas
	private static function collisionRectRect (rect1:Rectangle, rect2:Rectangle):Bool {
		return (rect1.x < rect2.x + rect2.width  &&
				rect1.x + rect1.width > rect2.x  &&
				rect1.y < rect2.y + rect2.height &&
				rect1.height + rect1.y > rect2.y);
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
			lTilesDrawn.push(cast(lTile, DisplayObject));
			
			for (j in 0...lTile.inFront.length) {
				lFrontTile = lTile.inFront[j];
				lFrontTile.behind.remove(lTile);
				if (lFrontTile.behind.length == 0) lToDraw.push(lFrontTile);
			}
		}
		
		if (pTiles.length != lTilesDrawn.length)
			Debug.error("Probable error whit colMax/colMin/rowMax/rowMin assignment ! " + "entering container length : " + pTiles.length + " . returning container length : " + lTilesDrawn.length);	
		
		if (lTilesDrawn.length < pTiles.length) Lib.debug();
		
		
		return lTilesDrawn;
	};
	
	
}