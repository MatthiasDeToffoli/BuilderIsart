package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.ui.UIElement;
import com.isartdigital.perle.ui.hud.ButtonBuild;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPosition;
import pixi.core.display.Container;
import pixi.core.math.Point;

/**
 * Classe en charge de gérer les informations du Hud
 * @author Ambroise RABIER
 */
class Hud extends Screen 
{
	private static inline var MARGIN_RIGHT:Int = 10;
	// todo ? display:flex ?
	private var BUTTONS_NAMES(default, null):Array<String> = [
		"FactoryButton",
		"HouseButton",
		"TreesButton",
		"VillaButton"
	];
	private var BUTTON_START_POINT(default, null):Point = new Point(-340, -80);
	
	private static var instance: Hud;
	
	/*private var hudTopLeft:Sprite;
	private var hudBottomLeft:Container;*/
	private var hudBottom:Container;
	private var buildingBackground:UIElement;
	private var buttonMap:Map<String, ButtonBuild> = new Map<String, ButtonBuild>();

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Hud {
		if (instance == null) instance = new Hud();
		return instance;
	}	
	
	public function new() 
	{
		super();
		modal = false;
		/* TODO todo : A REMETTRE QUAND ASSETS HUD EN FLUMP
		hudBottom = new Container();
		buildingBackground = new UIElement("Hud");
		hudBottom.addChild(buildingBackground);
		
		createButtons(hudBottom, BUTTONS_NAMES, BUTTON_START_POINT, MARGIN_RIGHT);
		
		addChild(hudBottom);
		positionables.push({
			item:hudBottom,
			// added UIPosition.BOTTOM_CENTER
			align:UIPosition.BOTTOM_CENTER,
			offsetX:0,
			offsetY:50
		});*/
	}
	
	/**
	 * Create and set position of the buttons inside hudBottom
	 */
	private function createButtons(pContainer:Container, pNames:Array<String>, pStartPos:Point, pMargin:Int):Void {
		for (i in 0...pNames.length) {
			buttonMap[pNames[i]] = new ButtonBuild(pNames[i]);
			if (pNames[i] == pNames[0]) {
				buttonMap[pNames[i]].y += pStartPos.y;
				buttonMap[pNames[i]].x += pStartPos.x;
			} else {
				buttonMap[pNames[i]].y = buttonMap[pNames[0]].y;
				buttonMap[pNames[i]].x = buttonMap[pNames[i-1]].x + buttonMap[pNames[i-1]].width + pMargin;
			}
			pContainer.addChild(buttonMap[pNames[i]]);
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}