package com.isartdigital.perle.ui.popin.shop.card;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.BuildingName;
import com.isartdigital.perle.game.managers.BuyManager;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.FakeTraduction;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class CCUBuilding extends CarouselCardUnlock{

	private var textName:TextSprite;
	private var textPriceSoftHard:TextSprite;
	private var textPriceWood:TextSprite;
	private var textPriceIron:TextSprite;
	private var iconSoftHard:UISprite;
	private var iconIron:UISprite;
	private var iconWood:UISprite;
	
	public function new() {
		super(AssetName.CAROUSSEL_CARD_UNLOCKED);
		name = componentName;
	}
	
	override function buildCard ():Void {
		super.buildCard();
		
		image = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUILDING_PICTURE), UISprite);
		textName = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUILDING_NAME), TextSprite);
		textPriceSoftHard = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUILDING_PRICE_SOFT_HARD), TextSprite);
		textPriceWood = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUILDING_PRICE_WOOD), TextSprite);
		textPriceIron = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUILDING_PRICE_IRON), TextSprite);
		iconSoftHard = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUILDING_ICON_SOFT_HARD), UISprite);
		iconWood = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUILDING_ICON_WOOD), UISprite);
		iconIron = cast(SmartCheck.getChildByName(this, AssetName.CARD_BUILDING_ICON_IRON), UISprite);
		
		SmartPopinExtended.setImage(image, BuildingName.getAssetName(buildingName));
		//textName.text = FakeTraduction.assetNameNameToTrad(buildingName);
		textName.text = Localisation.getText(buildingName);
		setPrice(BuyManager.getPrice(buildingName));
	}
	
	private function setPrice (pPrices:Map<GeneratorType, Int>):Void {
		
		// hard currency is an alternative... not supported yet ! (only for altar)
		textPriceSoftHard.text = ResourcesManager.shortenValue(pPrices[GeneratorType.soft]);
		changeIconSpawner(AssetName.PROD_ICON_SOFT_SMALL, iconSoftHard);
		setWoodIronPrice(
			pPrices[GeneratorType.buildResourceFromParadise],
			textPriceWood,
			iconWood
		);
		setWoodIronPrice(
			pPrices[GeneratorType.buildResourceFromHell],
			textPriceIron,
			iconIron
		);
	}
	
	private function setWoodIronPrice (pPrice:Int, pTextSprite:TextSprite, pIcon:UISprite):Void {
		if (pPrice == null) {
			removeChild(pIcon);
			removeChild(pTextSprite);
			pIcon.destroy();
			pTextSprite.destroy();
			// yeah the final step is missing :/, not that important anyway
			//pIcon = null;
			//pTextSprite = null;
		}
		else {
			pTextSprite.text = ResourcesManager.shortenValue(pPrice); 
		}
	}
	
	override function _click(pEvent:EventTarget = null):Void {
		super._click(pEvent);
		if (DialogueManager.ftueStepClickOnCard || BuyManager.canBuy(buildingName)) {
			if (DialogueManager.ftueStepClickOnCard)
				DialogueManager.endOfaDialogue();
			Phantom.onClickShop(buildingName);
			Hud.getInstance().hideBuildingHud();
			//SoundManager.getSound("SOUND_SPEND").play();
			//Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING);
			SoundManager.getSound("SOUND_NEUTRAL").play();
			var arrayForChange:Map<String, Dynamic> = ["type" => BuildingHudType.MOVING, "building" => null];
			Hud.eChangeBH.emit(Hud.EVENT_CHANGE_BUIDINGHUD, arrayForChange);
		}
		
		// todo : il close le shop même si canBuy == false  :(
		// @alexis : ce todo il est bon ? si oui supprime le.
	}
	
}