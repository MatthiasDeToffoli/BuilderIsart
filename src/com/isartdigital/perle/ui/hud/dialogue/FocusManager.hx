package com.isartdigital.perle.ui.hud.dialogue;

import com.isartdigital.perle.ui.hud.dialogue.Arrow;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIComponent;
import com.isartdigital.utils.ui.UIPositionable;
import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.interaction.EventTarget;

	
/**
 * Classe Exemple destinée à gérer l'accès/verrouillage des élements du jeu pour la FTUE
 * Permet de pointer facilement un élement de jeu et desactiver le comportement des autres
 * @author Mathieu Anthoine
 */
class FocusManager extends Screen 
{
	
	/**
	 * instance unique de la classe FTUE
	 */
	private static var instance: FocusManager;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): FocusManager {
		if (instance == null) instance = new FocusManager();
		return instance;
	}
	
	private var arrow:Arrow;
	private var arrowRotation:Float;
	private var target:DisplayObject;
	private var shadow:Container;
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modalImage = "assets/FTUE_bg.png";
		
		shadow = new Container();
	}

	/**
	 * Définit l'objet graphique à pointer
	 * @param	pTarget objet ciblé
	 * @param	pRotation rotation de la flèche qui pointe sur l'objet exprimé en degrés
	 */
	public function setFocus (?pTarget:DisplayObject, ?pRotation:Float = 0): Void {
		if (target != null && target.parent == this) swap(shadow, target);
			//trace(pTarget);
		if (pTarget != null) {
			//trace(pTarget);
			target = pTarget;
			swap(target, shadow);
		}	
		if(pRotation !=null)
			arrowRotation = pRotation;
		onResize();
	}
	
	/**
	 * Ferme le screen FTUE et replace les objets graphique comme il convient
	 */
	override public function close():Void 
	{
		if (target != null && target.parent == this) swap(shadow, target);
		super.close();
	}
	
	/**
	 * Echange l'objets graphique pointé avec un objet graphique "shadow"
	 * Dans le cas ou l'objet pointé est à sa place d'origine, il le met dans le Screen FTUE et place un repère (shadow) à sa place dans le conteneur d'origine
	 * Dans le cas ou l'objet pointé est dans le Screen FTUE, il le remet à sa place d'origine
	 * @param	pTarget objet dans le conteneur d'origine de l'objet ciblé
	 * @param	pFTUE objet dans le Screen FTUE
	 */
	private function swap (pTarget:DisplayObject, pFTUE: DisplayObject): Void {
		var lParent:Container = pTarget.parent;
		
		lParent.addChildAt(pFTUE,lParent.getChildIndex(pTarget));
		pFTUE.position = pTarget.position;
		addChildAt(pTarget,0);
		
		if (Std.is (lParent, UIComponent)) {
			var lPositionnables:Array<UIPositionable> = untyped lParent.positionables;
			for (i in 0...lPositionnables.length) {
				if (lPositionnables[i].item == pTarget) {
					lPositionnables[i].item = cast(pFTUE,Container);
					break;
				}
			}
		}
	}
	
	override function onResize(pEvent:EventTarget = null):Void 
	{
		if (target != null) {
			if (arrowRotation != 0) {
				if (arrow == null) { 
					arrow = new Arrow();
					addChild(arrow);
					arrow.start();
				}	
			}
			target.position = toLocal(shadow.position, shadow.parent);
			
			if (arrowRotation!= 0) {
				arrow.rotation = arrowRotation * Pixi.DEG_TO_RAD;
				arrow.position = target.position;
			}
		}
		super.onResize(pEvent);
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}