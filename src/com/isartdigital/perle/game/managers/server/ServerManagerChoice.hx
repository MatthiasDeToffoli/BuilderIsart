package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.ChoiceManager.EventRewardDesc;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.server.ServerManager.DbAction;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.popin.choice.Choice.ChoiceType;
import com.isartdigital.utils.Debug;

typedef SendXp = {
	var bad:Int;
	var good:Int;
}

/**
 * ...
 * @author grenu
 */
class ServerManagerChoice 
{
	
	public static function applyReward(pReward:EventRewardDesc, pChoice:ChoiceType):Void {
		var xp:SendXp = {
			bad: (pChoice == ChoiceType.HELL) ? pReward.xp : 0,
			good: (pChoice == ChoiceType.HEAVEN) ? pReward.xp : 0
		}
		
		ServerManager.callPhpFile(onSuccessApplyReward, onErrorApplyReward, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => "ChoicesNew",
			"funct" => "APPLY_REWARD",
			"karma" => pReward.karma,
			"iron" => pReward.iron,
			"wood" => pReward.wood,
			"gold" => pReward.gold,
			"badXP" => xp.bad,
			"goodXP" => xp.good,
			"soul" => pReward.soul,
			"tribuX" => VTribunal.getInstance().tileDesc.mapX,
			"tribuY" => VTribunal.getInstance().tileDesc.mapY,
			"tribuRegionX" => VTribunal.getInstance().tileDesc.regionX,
			"tribuRegionY" => VTribunal.getInstance().tileDesc.regionY
		]);
	}
	
	private static function onSuccessApplyReward(object:Dynamic):Void {
		trace(object);
	}
	
	private static function onErrorApplyReward(object:Dynamic):Void {
		Debug.error("Error php on apply reward : " + object);
	}

}