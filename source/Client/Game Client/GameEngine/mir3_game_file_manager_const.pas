(*******************************************************************
 *   LomCN Mir3 file manager constantes core File 2012             *
 *                                                                 *
 *   Web       : http://www.lomcn.co.uk                            *
 *   Version   : 0.0.0.1                                           *
 *                                                                 *
 *   - File Info -                                                 *
 *                                                                 *
 *   This file holds all Texture consts                            *
 *                                                                 *
 *                                                                 *
 *                                                                 *
 *******************************************************************
 * Change History                                                  *
 *                                                                 *
 *  - 0.0.0.1 [2012-10-10] Coly : fist init                        *
 *                                                                 *
 *                                                                 *
 *                                                                 *
 *                                                                 *
 *******************************************************************
 *  - TODO List for this *.pas file -                              *
 *-----------------------------------------------------------------*
 *  if a todo finished, then delete it here...                     *
 *  if you find a global TODO thats need to do, then add it here.. *
 *-----------------------------------------------------------------*
 *                                                                 *
 *  - TODO : -all -fill *.pas header information                   *
 *                 (how to need this file etc.)                    *
 *                                                                 *
 *******************************************************************)
 unit mir3_game_file_manager_const;

interface

const
  MAX_FILE_MAPPING                = 350; // Maximum of texture files thats we need to map

  MAP_PHAT                        = '.\map\';
  LIB_PHAT                        = '.\lib\';
  LOG_PHAT                        = '.\log\';
  SOUND_PHAT                      = '.\sound\';
  MAP_TEXTURE_PHAT_DATA           = '.\data\';
  MAP_TEXTURE_PHAT_WOOD           = '.\data\wood\';
  MAP_TEXTURE_PHAT_SAND           = '.\data\sand\';
  MAP_TEXTURE_PHAT_SNOW           = '.\data\snow\';
  MAP_TEXTURE_PHAT_FOREST         = '.\data\forest\';

  //TODO : Test Client for Wil / WTL ext... if wil set wil if wtl set wtl

  (* Basis Texture file Consts *)
  MAP_TEXTURE_TILESC              = 'Tilesc';
  MAP_TEXTURE_TILES30C            = 'Tiles30c';
  MAP_TEXTURE_TILES5C             = 'Tiles5c';
  MAP_TEXTURE_SMTILESC            = 'Smtilesc';
  MAP_TEXTURE_HOUSESC             = 'Housesc';
  MAP_TEXTURE_CLIFFSC             = 'Cliffsc';
  MAP_TEXTURE_DUNGEONSC           = 'Dungeonsc';
  MAP_TEXTURE_INNERSC             = 'Innersc';
  MAP_TEXTURE_FUNITURESC          = 'Furnituresc';
  MAP_TEXTURE_WALLSC              = 'Wallsc';
  MAP_TEXTURE_SMOBJECTSC          = 'SmObjectsc';
  MAP_TEXTURE_ANIMATIONSC         = 'Animationsc';
  MAP_TEXTURE_OBJECT1C            = 'Object1c';
  MAP_TEXTURE_OBJECT2C            = 'Object2c';
  MAP_TEXTURE_FREEUSER            = 'freeuser';
  { Game Textures }
  GAME_TEXTURE_INTERFACE1C        = 'Interface1c';
  GAME_TEXTURE_INTERFACE1C_INT    = 80;
  GAME_TEXTURE_PROGUSE            = 'ProgUse';
  GAME_TEXTURE_PROGUSE_INT        = 81;
  GAME_TEXTURE_GAMEINTER          = 'GameInter';
  GAME_TEXTURE_GAMEINTER_INT      = 82;
  GAME_TEXTURE_GAMEINTER1         = 'GameInter1';
  GAME_TEXTURE_GAMEINTER1_INT     = 83;
  GAME_TEXTURE_GAMEINTER2         = 'GameInter2';
  GAME_TEXTURE_GAMEINTER2_INT     = 84;
  GAME_TEXTURE_NPC                = 'NPC';
  GAME_TEXTURE_NPC_INT            = 85;
  GAME_TEXTURE_NPCFACE            = 'NPCface';
  GAME_TEXTURE_NPCFACE_INT        = 86;
  GAME_TEXTURE_MICON              = 'MIcon';
  GAME_TEXTURE_MICON_INT          = 87;
  GAME_TEXTURE_MAPICON            = 'MapIcon';
  GAME_TEXTURE_MAPICON_INT        = 88;
  GAME_TEXTURE_MMAP               = 'Mmap';
  GAME_TEXTURE_MMAP_INT           = 89;
  GAME_TEXTURE_FMMAP              = 'Fmmap';
  GAME_TEXTURE_FMMAP_INT          = 90;
  GAME_TEXTURE_INVENTORY          = 'Inventory';
  GAME_TEXTURE_INVENTORY_INT      = 91;
  GAME_TEXTURE_STOREITEM          = 'Storeitem';
  GAME_TEXTURE_STOREITEM_INT      = 92;
  GAME_TEXTURE_EQUIP              = 'Equip';
  GAME_TEXTURE_EQUIP_INT          = 93;
  GAME_TEXTURE_GROUND             = 'Ground';
  GAME_TEXTURE_GROUND_INT         = 94;
  GAME_TEXTURE_PEQUIPH1           = 'PEquipH1';        //Pet
  GAME_TEXTURE_PEQUIPH1_INT       = 95;                    //Pet
  GAME_TEXTURE_PEQUIPB1           = 'PEquipB1';        //Pet
  GAME_TEXTURE_PEQUIPB1_INT       = 96;                    //Pet
  { Human Body }
  HUMAN_TEXTURE_M_HUM_1           = 'M-Hum';
  HUMAN_TEXTURE_WM_HUM_1          = 'WM-Hum';
  HUMAN_TEXTURE_M_HUM_2           = 'M-HumA';
  HUMAN_TEXTURE_WM_HUM_2          = 'WM-HumA';
  HUMAN_TEXTURE_M_HUM_3           = 'M-HumEx1';
  HUMAN_TEXTURE_WM_HUM_3          = 'WM-HumEx1';
  HUMAN_TEXTURE_M_HUM_4           = 'M-HumAEx1';
  HUMAN_TEXTURE_WM_HUM_4          = 'WM-HumAEx1';
  HUMAN_TEXTURE_M_HUM_5           = 'M-HumEx2';
  HUMAN_TEXTURE_WM_HUM_5          = 'WM-HumEx2';
  HUMAN_TEXTURE_M_HUM_6           = 'M-HumAEx2';
  HUMAN_TEXTURE_WM_HUM_6          = 'WM-HumAEx2';
  { Human Wings }
  HUMAN_TEXTURE_M_SHUM_1          = 'M-SHum';
  HUMAN_TEXTURE_WM_SHUM_1         = 'WM-SHum';
  HUMAN_TEXTURE_M_SHUM_2          = 'M-SHumEx1';
  HUMAN_TEXTURE_WM_SHUM_2         = 'WM-SHumEx1';
  { Human Hair }
  HUMAN_TEXTURE_M_HAIR_1          = 'M-Hair';
  HUMAN_TEXTURE_WM_HAIR_1         = 'WM-Hair';
  HUMAN_TEXTURE_M_HAIR_2          = 'M-HairA';
  HUMAN_TEXTURE_WM_HAIR_2         = 'WM-HairA';
  HUMAN_TEXTURE_M_HAIR_3          = 'M-HairEx1';
  HUMAN_TEXTURE_WM_HAIR_3         = 'WM-HairEx1';
  HUMAN_TEXTURE_M_HAIR_4          = 'M-HairAEx1';
  HUMAN_TEXTURE_WM_HAIR_4         = 'WM-HairAEx1';
  { Human Helmet }
  HUMAN_TEXTURE_M_HELMET_1        = 'M-Helmet1';
  HUMAN_TEXTURE_WM_HELMET_1       = 'WM-Helmet1';
  HUMAN_TEXTURE_M_HELMET_2        = 'M-Helmet2';
  HUMAN_TEXTURE_WM_HELMET_2       = 'WM-Helmet2';
  HUMAN_TEXTURE_M_HELMET_3        = 'M-Helmet3';
  HUMAN_TEXTURE_WM_HELMET_3       = 'WM-Helmet3';
  HUMAN_TEXTURE_M_HELMET_4        = 'M-HelmetA1';
  HUMAN_TEXTURE_WM_HELMET_4       = 'WM-HelmetA1';
  HUMAN_TEXTURE_M_HELMET_5        = 'M-HelmetA2';
  HUMAN_TEXTURE_WM_HELMET_5       = 'WM-HelmetA2';
  HUMAN_TEXTURE_M_HELMET_6        = 'M-HelmetA3';
  HUMAN_TEXTURE_WM_HELMET_6       = 'WM-HelmetA3';
  { Human Weapon }
  HUMAN_TEXTURE_M_WEAPON_1        = 'M-Weapon1';
  HUMAN_TEXTURE_WM_WEAPON_1       = 'WM-Weapon1';
  HUMAN_TEXTURE_M_WEAPON_2        = 'M-Weapon2';
  HUMAN_TEXTURE_WM_WEAPON_2       = 'WM-Weapon2';
  HUMAN_TEXTURE_M_WEAPON_3        = 'M-Weapon3';
  HUMAN_TEXTURE_WM_WEAPON_3       = 'WM-Weapon3';
  HUMAN_TEXTURE_M_WEAPON_4        = 'M-Weapon4';
  HUMAN_TEXTURE_WM_WEAPON_4       = 'WM-Weapon4';
  HUMAN_TEXTURE_M_WEAPON_5        = 'M-Weapon5';
  HUMAN_TEXTURE_WM_WEAPON_5       = 'WM-Weapon5';
  HUMAN_TEXTURE_M_WEAPON_6        = 'M-Weapon6';
  HUMAN_TEXTURE_WM_WEAPON_6       = 'WM-Weapon6';
  HUMAN_TEXTURE_M_WEAPON_7        = 'M-Weapon7';
  HUMAN_TEXTURE_WM_WEAPON_7       = 'WM-Weapon7';
  HUMAN_TEXTURE_M_WEAPON_8        = 'M-Weapon8';
  HUMAN_TEXTURE_WM_WEAPON_8       = 'WM-Weapon8';
  HUMAN_TEXTURE_M_WEAPON_9        = 'M-Weapon9';
  HUMAN_TEXTURE_WM_WEAPON_9       = 'WM-Weapon9';
  HUMAN_TEXTURE_M_WEAPON_10       = 'M-Weapon10';
  HUMAN_TEXTURE_WM_WEAPON_10      = 'WM-Weapon10';
  HUMAN_TEXTURE_M_WEAPON_11       = 'M-Weapon11';
  HUMAN_TEXTURE_WM_WEAPON_11      = 'WM-Weapon11';
  HUMAN_TEXTURE_M_WEAPON_12       = 'M-Weapon12';
  HUMAN_TEXTURE_WM_WEAPON_12      = 'WM-Weapon12';
  { Human Weapon Assassin }
  HUMAN_TEXTURE_M_WEAPON_A1       = 'M-WeaponA1';
  HUMAN_TEXTURE_WM_WEAPON_A1      = 'WM-WeaponA1';
  HUMAN_TEXTURE_M_WEAPON_A2       = 'M-WeaponA2';
  HUMAN_TEXTURE_WM_WEAPON_A2      = 'WM-WeaponA2';
  HUMAN_TEXTURE_M_WEAPON_ADL1     = 'M-WeaponADL1';
  HUMAN_TEXTURE_WM_WEAPON_ADL1    = 'WM-WeaponADL1';
  HUMAN_TEXTURE_M_WEAPON_ADL2     = 'M-WeaponADL2';
  HUMAN_TEXTURE_WM_WEAPON_ADL2    = 'WM-WeaponADL2';
  HUMAN_TEXTURE_M_WEAPON_ADR1     = 'M-WeaponADR1';
  HUMAN_TEXTURE_WM_WEAPON_ADR1    = 'WM-WeaponADR1';
  HUMAN_TEXTURE_M_WEAPON_ADR2     = 'M-WeaponADR2';
  HUMAN_TEXTURE_WM_WEAPON_ADR2    = 'WM-WeaponADR2';
  HUMAN_TEXTURE_M_WEAPON_AOH1     = 'M-WeaponAOH1';
  HUMAN_TEXTURE_WM_WEAPON_AOH1    = 'WM-WeaponAOH1';
  HUMAN_TEXTURE_M_WEAPON_AOH2     = 'M-WeaponAOH2';
  HUMAN_TEXTURE_WM_WEAPON_AOH2    = 'WM-WeaponAOH2';
  HUMAN_TEXTURE_M_WEAPON_AOH3     = 'M-WeaponAOH3';
  HUMAN_TEXTURE_WM_WEAPON_AOH3    = 'WM-WeaponAOH3';

  MONSTER_TEXTURE_HORSE_1         = 'Horse';
  MONSTER_TEXTURE_HORSE_2         = 'Horse_Golden';
  MONSTER_TEXTURE_HORSE_3         = 'Horse_Iron';
  MONSTER_TEXTURE_HORSE_4         = 'Horse_Silver';
  MONSTER_TEXTURE_HORSE_Shadow    = 'HorseS';

  MAGIC_TEXTURE_1                 = 'Magic';
  MAGIC_TEXTURE_2                 = 'MagicEX';
  MAGIC_TEXTURE_3                 = 'MagicEx2';
  MAGIC_TEXTURE_4                 = 'MagicEx3';
  MAGIC_TEXTURE_5                 = 'MagicEx4';
  MAGIC_TEXTURE_6                 = 'MagicEx5';

  MAGIC_MONSTER_TEXTURE_1         = 'MonMagic';
  MAGIC_MONSTER_TEXTURE_2         = 'MonMagicEx';
  MAGIC_MONSTER_TEXTURE_3         = 'MonMagicEx2';
  MAGIC_MONSTER_TEXTURE_4         = 'MonMagicEx3';
  MAGIC_MONSTER_TEXTURE_5         = 'MonMagicEx4';
  MAGIC_MONSTER_TEXTURE_6         = 'MonMagicEx5';
  MAGIC_MONSTER_TEXTURE_7         = 'MonMagicEx6';
  MAGIC_MONSTER_TEXTURE_8         = 'MonMagicEx7';
  MAGIC_MONSTER_TEXTURE_9         = 'MonMagicEx8';
  MAGIC_MONSTER_TEXTURE_10        = 'MonMagicEx9';
  MAGIC_MONSTER_TEXTURE_11        = 'MonMagicEx10';

  MAX_MONSTER_FILE                = 49;
  MONSTER_TEXTURE_NORMAL          = 'Mon-%d';
  MONSTER_TEXTURE_SHADOW          = 'MonS-%d';

  { Video and Video Sound Files }
  VIDEO_GAME_START                = 'Wemade.dat';
  VIDEO_GAME_CREATE_CHAR          = 'CreateChr.dat';
  VIDEO_GAME_START_GAME           = 'StartGame.dat';
  VIDEO_SOUND_CREATE_CHAR         = 'CreateChr.wav';
  VIDEO_SOUND_START_GAME          = 'StartGame.wav';

  CONFIG_USER_FILE                = 'Mir3Client.conf';
  LOG_MIR3_CLIENT                 = 'Mir3Client.log';
  FONT_FILE                       = 'Mir3FontData.mfd';

implementation

end.
