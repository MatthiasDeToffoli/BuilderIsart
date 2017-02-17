package com.isartdigital.perle.ui.screens;

import com.isartdigital.perle.ui.popin.Confirm;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartScreen;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * Exemple de classe héritant de Screen
 * @author Mathieu ANTHOINE
 */
class TitleCard extends Screen 
{
	private var background:SmartScreen;
	private var btnStart:SmartButton;
	
	/**
	 * instance unique de la classe TitleCard
	 */
	private static var instance: TitleCard;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TitleCard {
		if (instance == null) instance = new TitleCard();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	public function new() 
	{
		super();
		background = new SmartScreen("Title_card_bg");
		btnStart = new SmartButton("ButtonPlay");
		addChild(background);
		addChild(btnStart);
		
		btnStart.once(MouseEventType.CLICK,onClick);
		btnStart.once(TouchEventType.TAP, onClick);
		
		SoundManager.getSound("MUSIC_MAIN").play();
	}
	
	private function onClick (pEvent:EventTarget): Void {
		Main.getInstance().startAfterTitleCard();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}