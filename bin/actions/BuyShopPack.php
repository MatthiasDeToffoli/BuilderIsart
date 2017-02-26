<?php
/**
 * Created by PhpStorm.
 * User: RABIERAmbroise
 * Date: 25/02/2017
 * Time: 16:14
 */

namespace actions;

use actions\utils\FacebookUtils as FacebookUtils;
use actions\utils\Send;
use actions\utils\Utils as Utils;
use actions\utils\Resources as Resources;
use actions\utils\TypeShopPack as TypeShopPack;
use actions\utils\GeneratorType as GeneratorType;

include_once("utils/Utils.php");
include_once("utils/FacebookUtils.php");
include_once("utils/Resources.php");
include_once("utils/TypeShopPack.php");
include_once("utils/GeneratorType.php");

class BuyShopPack
{
    const TABLE_SHOP_PACK = "TypeShopPack";
    const ID_SHOP_PACK = "ID";
    const ID_PLAYER = "IDPlayer";

    public static function doAction () {
        global $db;
        $lInfo = static::getInfo();
        $lConfig = Utils::getTableRowByID(static::TABLE_SHOP_PACK, $lInfo[static::ID_SHOP_PACK]);

        $db->beginTransaction();
        $lWallet = Resources::getResources($lInfo[static::ID_PLAYER]);
        static::validate($lConfig, $lWallet);
        static::updateResources($lInfo, $lConfig, $lWallet);
        $db->commit();
    }

    private static function updateResources ($pInfo, $pConfig, $pWallet) {
        $newKarmaTotal = $pWallet[GeneratorType::hard];
        if ($pConfig[TypeShopPack::GiveKarma] != null)
            $newKarmaTotal += $pConfig[TypeShopPack::GiveKarma];
        if ($pConfig[TypeShopPack::PriceKarma] != null)
            $newKarmaTotal -= $pConfig[TypeShopPack::PriceKarma];

        if ($pWallet[GeneratorType::hard] != $newKarmaTotal)
            Resources::updateResources(
                $pInfo[static::ID_PLAYER],
                GeneratorType::hard,
                $newKarmaTotal
            );
        if ($pConfig[TypeShopPack::GiveGold] != null)
            Resources::updateResources(
                $pInfo[static::ID_PLAYER],
                GeneratorType::soft,
                $pWallet[GeneratorType::soft] + $pConfig[TypeShopPack::GiveGold]
            );
        if ($pConfig[TypeShopPack::GiveWood] != null)
            Resources::updateResources(
                $pInfo[static::ID_PLAYER],
                GeneratorType::resourcesFromHeaven,
                $pWallet[GeneratorType::resourcesFromHeaven] + $pConfig[TypeShopPack::GiveWood]
            );
        if ($pConfig[TypeShopPack::GiveIron] != null)
            Resources::updateResources(
                $pInfo[static::ID_PLAYER],
                GeneratorType::resourcesFromHell,
                $pWallet[GeneratorType::resourcesFromHell] + $pConfig[TypeShopPack::GiveIron]
            );
    }

    private static function getInfo () {
        return [
            static::ID_SHOP_PACK => Utils::getSinglePostValueInt(static::ID_SHOP_PACK),
            static::ID_PLAYER => FacebookUtils::getId()
        ];
    }

    private static function validate ($pConfig, $pWallet) {
        global $db;
        if (!($pConfig[TypeShopPack::PriceKarma] == null || $pWallet[GeneratorType::hard] >= $pConfig[TypeShopPack::PriceKarma])) {
           //Send::SHOP_CANNOT_BUY_NOT_ENOUGH_MONEY;
           $db->rollback();
           echo "not enough money (karma) for this pack";
           exit;
        }
    }
}

BuyShopPack::doAction();