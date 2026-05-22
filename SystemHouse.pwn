#include <a_samp>
#include "ASAN_FS"
#include <crashdetect>
#include <sscanf>
#include <streamer>
#include <mxINI>
#include <UKR>
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
new FALSE = false, CMDSString[1000];
#define ShowInfoBox(%0,%1,%2,%3) do{format(CMDSString, 1000, %2, %3); ShowPlayerDialog(%0, 520, DIALOG_STYLE_MSGBOX, %1, CMDSString, "{FF0000}Вiдмiна", "");}while(FALSE)
#define SendMSG(%0,%1,%2,%3,%4) do{new _str[%2]; format(_str,%2,%3,%4); SendClientMessage(%0,%1,_str);}while(FALSE)
#define Loop(%0,%1) for(new %0 = 0; %0 < %1; %0++)
#define TYPE_OUT (0)
#define TYPE_INT (1)
#define COLOUR_INFO 0x00FFFFFF
#define COLOUR_SYSTEM 0xB60000FF
#define COLOUR_YELLOW 0xFFFF2AFF
#define COLOUR_GREEN 0x00BC00FF
#define SPAWN_IN_HOUSE // Комментарий Если Ви не хотите, чтобы игрок spawn в своем будинку в следующий раз он возвращается.
#define GH_USE_MAPICONS // Комментарий, если Ви не хотите карте значками.
#define GH_HINTERIOR_UPGRADE // Комментарий, если Ви не хотите, чтобы игроки были в состоянии модернизировать их домашнего iнтерєра.
#define HSPAWN_TIMER_RATE 900 // После, как долго будет таймер Визова появляются в будинку функции? (в мс)
#define MICON_VD 25.0 // Значок карты видимом диапазоне (drawdistance).
#define DEFAULT_H_INTERIOR 0 // DEFAULT домашнего iнтерєра при создании будинку
#define DEFAULT_H_INTERIOR_PRICE 3000000 // По умолчанию домашнего iнтерєра цiна при создании будинку
#define GH_USE_WEAPONSTORAGE // Если определено владельца будинку может хранить свое оружие в будинку хранения.
#define GH_SAVE_ADMINWEPS // Если определено дом владелец может сохранить оружие, как пулемет, гранаты, РПГ и т.д..
#define GH_DEBUGGING // Если определена це позволит отладки печатает в консоли сервера.
#define MAX_HOUSES 451 // Макс будинку создан
#define MAX_HOUSES_OWNED 2 // Макс будинкiв, принадлежащих за игрока
#define PICKUP_MODEL_OUT (1273)
#define PICKUP_MODEL_INT (1272)
#define PICKUP_TYPE (1)
#define HOUSEFILE_LENGTH 30 // Длина housefile (по умолчанию /House/Houses/<0-MAX_HOUSES>.ini
#define MAX_VISIT_TIME 60 // Максимальное время игрок может быть посещения в (в секундах).
#define INVALID_HOWNER_NAME "*** INV_PL_ID" // "iмя " хозяина будинку, когда немає реального владельца будинку (если це имело смысл)
#define H_INT_0_VALUE 3000000 // iнтерєр будинку цiна для будинкушнего iнтерєра 0
#define H_INT_1_VALUE 100000 //iнтерєр будинку цiна для будинкушнего iнтерєра 1
#define H_INT_2_VALUE 1000000 // iнтерєр будинку цiна для будинкушнего iнтерєра 2
#define H_INT_3_VALUE 1500000 // iнтерєр будинку цiна для домашнего iнтерєра 3
#define H_INT_4_VALUE 1500000 // iнтерєр будинку цiна для домашнего iнтерєра 4
#define H_INT_5_VALUE 2500000 // iнтерєр будинку цiна для домашнего iнтерєра 5
#define H_INT_6_VALUE 3000000 // iнтерєр будинку цiна для домашнего iнтерєра 6
#define H_INT_7_VALUE 5000000 // iнтерєр будинку цiна для домашнего iнтерєра 7
#define H_INT_8_VALUE 7500000 // iнтерєр будинку цiна для домашнего iнтерєра 8
#define H_INT_9_VALUE 10000000 // iнтерєр будинку цiна для домашнего iнтерєра 9
#define H_INT_10_VALUE 25000000 // iнтерєр будинку цiна для домашнего iнтерєра 10
#define HOUSE_SELLING_PROCENT 83 // количество дом значение игрок получит, когда дом продается.
#define HOUSE_SELLING_PROCENT2 1.2 // OFC Общий процент близлежащих будинкiв будет идти /down путем, когда дом продается /bought неподалеку.
#define RANGE_BETWEEN_HOUSES 80 // диапазон, используемый при увеличении /decreasing Значение близлежащих будинкiв, когда дом купили /sold (значение 0 для отключения)
#define MAX_HOUSE_NAME 35 // Максимальная длина дом iмя
#define MIN_HOUSE_NAME 4 // Mв длину дом iмя
#define MAX_HOUSE_PASSWORD 20 // Максимальная длина пароля дом
#define MIN_HOUSE_PASSWORD 4 // Мин длина дом пароль
#define DEFAULT_HOUSE_NAME "{00FFFF}вільний" // iмя по умолчанию, когда дом создан /sold
#define MIN_HOUSE_VALUE 500000 // Мин будинку стоимость будинку (OFC цены будут изменяться, когда дом купили /sold поблизости)
#define MAX_HOUSE_VALUE 50000000 // Макс дома стоимость дома (OFC цены будут изменяться, когда дом купили /sold поблизости)
#define CASE_SENSETIVE false // Используется в виде чеков STRCMP iмя. Определить, как истинный /false [0/1]. Читайте вики для получения дополнительной информации
#if defined GH_USE_CPS
new HouseCPOut[MAX_HOUSES], HouseCPInt[MAX_HOUSES];
#endif
#if !defined GH_USE_CPS
new HousePickupOut[MAX_HOUSES], HousePickupInt[MAX_HOUSES];
#endif
new Text3D:HouseLabel[MAX_HOUSES];
new Float:X, Float:Y, Float:Z, Float:Angle;
#if defined GH_USE_MAPICONS
new HouseMIcon[MAX_HOUSES];
#endif
#define LABELTEXT1 "{00FF00}будинок: %s\n{00FF00}Власник будинку: {00FFFF}Немає власника\n{00FF00}Будинок продається за: %d $\nБудинок ID: %d"
#define LABELTEXT2 " {FFFF00}%s\n{00FF00}Власник будинку: {FF0000}%s\n{00FF00}Будинок придбаний за: %d $\nБудинок ID: %d"
#define FILEPATH "/House/Houses/%d.ini"
#define INFORMATION_HEADER "{00FFFF}iнформацiя"
#define E_NO_HOUSES_OWNED "Ви не являетесь власником цього будинку."
#define I_HMENU "/housemenu - для доступа до меню будинку."
#define E_H_ALREADY_OWNED "Будинок вже належить iншому."
#define E_INVALID_HPASS_LENGTH "Невiрна довжина пароля."
#define E_INVALID_HPASS "Пароль залишився без змiн."
#define E_INVALID_HNAME_LENGTH "Невiрна довжина назви будинку."
#define I_HPASS_NO_CHANGE "Ваш пароль незмiнено."
#define I_HPASS_REMOVED "пароль був видалений."
#define E_NOT_ENOUGH_PMONEY "У Вас немає стiльки грошей!"
#define E_INVALID_AMOUNT "Невiрна сума."
#define E_HSTORAGE_L_REACHED "Ви не можете зберiгати в будинку стiльки грошей. (максимум 25000000 $)"
#define E_NOT_ENOUGH_HSMONEY "У Вас немає на зберiганнi стiльки грошей!"
#define E_NO_WEAPONS "У Вас немає зброї."
#define E_NO_HS_WEAPONS "У Вас немає зброї на зберiганнi."
#define E_C_ACCESS_SE_HM "Ви не можете вiдкрити меню будинку, це не Ваш будинок."
#define E_NOT_IN_HOUSE "Ви повиннi бути в будинку для використання цiєї команди."
#define E_NOT_HOWNER "Ви повиннi бути власником будинку для використання цiєї команди."
#define E_INVALID_HID "Невiрний будинок ID. цей будинок ID не iснує."
#define E_H_A_F_SALE "Цей будинок вже на продажi. Ви не можете продати будинок."
#define HMENU_ENTER_PASS "назва будинку: %s\nВласник будинку: %s\nБудинок придбаний за: %d $\nБудинок ID: %d\n\nЩоб увiйти в будинок, введiть пароль:"
#define HMENU_BUY_HOUSE "%s, Ви хочете придбати цей Будинок за %d $ ?"
#define HMENU_BUY_HINTERIOR "Ви хочете придбати iнтер'єр %s для будинку за %d $ ?"
#define HMENU_SELL_HOUSE "%s, Ви впевненi, що хочете продати свiй будинок %s за %d $ ?"
#define I_SELL_HOUSE1 "Ви успiшно продали свiй будинок за %d $.\nОплата: %d $.\nВашi %d $ , якi були на зберiганнi, були переданi Вам."
#define I_SELL_HOUSE2 "Ви успiшно продали свiй будинок \"%s\" за %d $.\nОплата: %d $."
#define I_BUY_HOUSE "Ви успiшно купили цей будинок за %d $ !"
#define I_HPASSWORD_CHANGED "Ви успiшно створили пароль для будинку \"%s\"!"
#define I_HNAME_CHANGED "Ви успiшно створили iмя для будинку \"%s\"!"
#define E_ALREADY_HAVE_HINTERIOR "У Вас вже є цей iнтер'єр."
#define I_VISITING_HOUSEINT "Ви оглядаєте iнтер'єр %s.\nЦей iнтер'єр коштує %d $.\nЧас огляду закiнчиться через %d Сек."
#define E_CANT_AFFORD_HINT "Ви не можете дозволити собi придбати iнтер'єр %s.\nВартiсть iнтер'єру: %d $.\nУ Вас є: %d $.\nВам не вистачає: %d $."
#define I_HINT_BOUGHT "Ви купили iнтер'єр %s за %d $."
#define I_HINT_DEPOSIT1 "У Вас на зберiганнi вже є %d $.\n\nВведiть суму, яку Ви хочете покласти:"
#define I_HINT_WITHDRAW1 "У Вас на зберiганнi є %d $.\n\nВведiть суму, яку Ви хочете зняти:"
#define I_HINT_DEPOSIT2 "Ви успiшно поклали на зберiгання %d $.\nПоточний баланс: %d $."
#define I_HINT_WITHDRAW2 "Ви успiшно зняли  з зберiгання %d $.\nПоточний баланс: %d $."
#define I_HINT_CHECKBALANCE "У Вас на зберiганнi лежить %d $."
#define E_HINT_WAIT_BEFORE_VISITING "Будьласка, зачекайте до огляду наступного iнтер'єру."
#define I_HS_WEAPONS1 "Успiшно збережено %d одиницi зброї у Вашому будинку."
#define I_HS_WEAPONS2 "Ви успiшно зняли з зберiгання %d одиниць зброї в Вашому будинку."
#define I_WRONG_HPASS1 "Ви не увiйшли в будинок %s з використанням пароля \"%s\"."
#define I_WRONG_HPASS2 "Будинок iнформацiя: %s [%d] спробував увiйти до будинку з використанням пароля \"%s\"."
#define I_CORRECT_HPASS1 "Ви успiшно увiйшли в будинок %s використовуючи пароль \"%s\"!"
#define I_CORRECT_HPASS2 "Будинок iнформацiя: %s [%d] успiшно увiйшов у Ваш будинок, використовуючи пароль \"%s\"!"
#define E_TOO_MANY_HOUSES "Вибачтете, але будинок з максимальним ID %d вже створений.\nВидалiть один з iснуючих або збiльшiть максимум будинкiв."
#define E_INVALID_HVALUE "Неправильна вартiсть будинку. Вартiсть повинна бути вiд 500,000 $ i до 50,000,000 $."
#define I_H_CREATED "Будинок ID %d Створений..."
#define I_H_DESTROYED "Будинок ID %d видалений..."
#define I_ALLH_DESTROYED "Всi будинки видаленi. (i того %d)"
#define I_HSPAWN_CHANGED "Ви змiнили позицiю спавна i кут для будинку ID %d."
#define I_TELEPORT_MSG "Ви телепортувались до будинку ID %d."
#define I_H_SOLD "Ви продали будинок ID %d..."
#define I_ALLH_SOLD "Всi будинки на серверi були проданi. (i того %d)"
#define I_H_PRICE_CHANGED "Вартiсть будинку ID %d була змiнена на %d $."
#define I_ALLH_PRICE_CHANGED "Ви змiнили вартiсть всiх будинкiв на серверi на %d $. (i того %d)"
#define I_HINT_VISIT_OVER "Час огляду закiнчився.\nВи хочете придбати iнтер'єр %s за %d $ ?"
#define E_CMD_USAGE_CREATEHOUSE "Використання: /createhouse [вартiсть] [додатково: iнтер'єр будинку (вiд 1[дешевий] до 10)[дорогий]]"
#define E_CMD_USAGE_REMOVEHOUSE "Використання: /removehouse [ID будинку]"
#define E_CMD_USAGE_CHANGESPAWN "Використання: /changespawn [ID будинку]"
#define E_CMD_USAGE_GOTOHOUSE "Використання: /gotohouse [ID будинку]"
#define E_CMD_USAGE_SELLHOUSE "Використання: /sellhouse [ID будинку]"
#define E_CMD_USAGE_CHANGEPRICE "Використання: /changeprice [ID будинку] [вартiсть]"
#define E_CMD_USAGE_CHANGEALLPRICE "Використання: /changeallprices [вартiсть]"
#if defined GH_DEBUGGING
#define DEBUG_OP_DISCONNECT "[House] %s [%d] залишився в своєму будинку (disconnect)"
#define DEBUG_OP_ED_CP1 "[House] %s [%d] увiйшов в будинок ID %d."
#define DEBUG_OP_ED_CP2 "[House] %s [%d] вийшов з будинку ID %d."
#define DEBUG_OP_PUD_PICKUP1 "[House] %s [%d] увiйшов в Будинок ID %d."
#define DEBUG_OP_PUD_PICKUP2 "[House] %s [%d] вийшов з будинку ID %d."
#define DEBUG_ODR1 "[House] %s [%d] купив Будинок ID %d за %d $."
#define DEBUG_ODR2 "[House] %s [%d] змiнив назву будинку ID %d на %s."
#define DEBUG_ODR3 "[House] %s [%d] купив iнтер'єр %s за %d $ для будинку ID %d."
#define DEBUG_ODR4 "[House] %s [%d] оглядає iнтер'єр %s (Будинок ID %d)"
#define DEBUG_ODR5 "[House] для будинку ID %d встановлений iнтер'єр %d."
#define DEBUG_ODR6 "[House] %s [%d] перевiрив суму грошей в будинку ID %d (сума: %d $)"
#define DEBUG_ODR7 "[House] %s [%d] поклав на зберiгання %d $ в будинку ID %d."
#define DEBUG_ODR8 "[House] %s [%d] зняв з зберiгання %d $ в будинку ID %d."
#define DEBUG_ODR10 "[House] %s [%d] поклав на зберiгання %d одиниць зброї в будинку ID %d."
#define DEBUG_ODR11 "[House] %s [%d] зняв з зберiгання %d одиниць зброї в будинку ID %d."
#define DEBUG_ODR12 "[House] %s [%d] успiшно увiйшов в будинок ID %d з використанням пароля."
#define DEBUG_ODR13 "[House] %s [%d] продав свiй Будинок за %d $ (грошей в будинку: %d $ | Будинок ID %d)"
#define DEBUG_ODR14 "[House] %s [%d] змiнив пароль в будинку ID %d."
#define DEBUG_OP_CMD1 "[House] %s [%d] створив будинок (Будинок ID %d | вартiсть: %d $ | всього будинкiв: %d)"
#define DEBUG_OP_CMD3 "[House] %s [%d] видалив будинок ID %d."
#define DEBUG_OP_CMD5 "[House] %s [%d] видалив всi будинки (%d у результатi)"
#define DEBUG_OP_CMD7 "[House] %s [%d] змiнив позицiю спавна i кут для будинку ID %d."
#define DEBUG_OP_CMD8 "[House] %s [%d] продав будинок ID %d."
#define DEBUG_OP_CMD9 "[House] %s [%d] продав всi будинки (%d у результатi)"
#define DEBUG_OP_CMD10 "[House] %s [%d] змiнив вартiсть будинку ID %d на %d $."
#define DEBUG_OP_CMD11 "[House] %s [%d] змiнив вартiсть всiх будинкiв на %d $ (%d у результатi)"
#define DEBUG_OP_SPAWN "[House] %s [%d] Заспавнився в своїм будинку."
#endif
new lockpas[MAX_PLAYERS];//массив блокировок диалога ввода пароля
/////////////////////////////////////////////////
new bool:IsPlayerOnHousePickup[MAX_PLAYERS];
new LastHousePickupID[MAX_PLAYERS] = {-1, ...};
new Float:LastPickupX[MAX_PLAYERS];
new Float:LastPickupY[MAX_PLAYERS];
new Float:LastPickupZ[MAX_PLAYERS];
///////////////////////////////////////////////////
new dlgcont[MAX_PLAYERS];//контроль ИД диалога
new timcontrol;//контрольный таймер нахождения игрока в будинку
#define MAX_VW_HOUSE (999 + MAX_HOUSES)//максимальный виртуальный мир системы будинкiв
public OnFilterScriptInit()
{
timcontrol = SetTimer("HouseOneSec", 1003, 1);//контрольный таймер нахождения игрока в будинку
for(new i = 0; i < MAX_PLAYERS; i++)//цикл для всех игроков
{
dlgcont[i] = -600;//не существующий ИД диалога
lockpas[i] = 0;//обнуление массива блокировок диалога ввода пароля
}

// Очищаємо PVars для гравців ПЕРЕД стартом завантаження
Loop(i, MAX_PLAYERS)
{
if(IsPlayerConnected(i) && !IsPlayerNPC(i))
{
SetPVarInt(i, "HousePrevTime", 0);
SetPVarInt(i, "HousePreview", 0);
SetPVarInt(i, "IsHouseVisiting", 0);
SetPVarInt(i, "LastHouseCP", 0);
SetPVarInt(i, "IsInHouse", 0);
SetPVarInt(i, "HousePrevInt", 0);
SetPVarInt(i, "ChangeHouseInt", 0);
SetPVarInt(i, "HouseIntUpgradeMod", 0);
SetPVarInt(i, "JustCreatedHouse", 0);
SetPVarInt(i, "FirstSpawn", 0);
}
}

// Запускаємо покроковий таймер завантаження будинків (починаємо з ID 0)
SetTimerEx("LoadHousesStepByStep", 15, false, "d", 0);
return 1;
}

public OnFilterScriptExit()
{
new file[HOUSEFILE_LENGTH], tmp;
Loop(i, MAX_PLAYERS)
{
if(IsPlayerConnected(i) && !IsPlayerNPC(i))
{
tmp = GetPVarInt(i, "LastHouseCP");
format(file, sizeof(file), FILEPATH, tmp);
if(!strcmp(GetHouseOwner(tmp), pNick(i), CASE_SENSETIVE) && GetPVarInt(i, "IsInHouse") == 1 && fexist(file))
{
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_setInteger(hFile, "QuitInHouse", 1);
ini_closeFile(hFile);
}
}
}
}
UnloadSystemHouse(); // Вигрузка будинкiв
KillTimer(timcontrol);//контрольный таймер нахождения игрока в будинку
return 1;
}
public OnPlayerSpawn(playerid)
{
if(GetPVarInt(playerid, "FirstSpawn") == 0)
{
// Используется для того, чтобы плеер spawn в их будинку, если они уходят в их будинку (только призвал к первому spawn)
#if defined SPAWN_IN_HOUSE
SetTimerEx("HouseSpawning", HSPAWN_TIMER_RATE, false, "i", playerid);
#endif
// Увеличение скорости таймера, если ваш режимы игры OnPlayerSpawn Визывается после таймер закончился
}
return 1;
}
public OnPlayerConnect(playerid)
{
dlgcont[playerid] = -600;//не существующий ИД диалога
lockpas[playerid] = 0;//разблокировать диалог ввода пароля
SetPVarInt(playerid, "HousePrevTime", 0);//обнуление важных глобальных переменных !!!
SetPVarInt(playerid, "HousePreview", 0);
SetPVarInt(playerid, "IsHouseVisiting", 0);
SetPVarInt(playerid, "LastHouseCP", 0);
SetPVarInt(playerid, "IsInHouse", 0);
SetPVarInt(playerid, "HousePrevInt", 0);
SetPVarInt(playerid, "IsHouseVisiting", 0);
SetPVarInt(playerid, "ChangeHouseInt", 0);
SetPVarInt(playerid, "HouseIntUpgradeMod", 0);
SetPVarInt(playerid, "JustCreatedHouse", 0);
SetPVarInt(playerid, "FirstSpawn", 0);
return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
if(GetPVarInt(playerid, "HousePrevTime") != 0)
{//если игрок осматривает iнтер'єр, то вернуть старый iнтер'єр
SetPVarInt(playerid, "HousePreview", 0);
KillTimer(GetPVarInt(playerid, "HousePrevTimer"));
SetPVarInt(playerid, "IsHouseVisiting", 0);
SetPVarInt(playerid, "HousePrevTime", 0);
new file555[HOUSEFILE_LENGTH], h = GetPVarInt(playerid, "LastHouseCP");
format(file555, sizeof(file555), FILEPATH, h);

// Виправлено для mxINI
new hFile555 = ini_openFile(file555);
if(hFile555 >= 0)
{
ini_setInteger(hFile555, "HouseInterior", GetPVarInt(playerid, "OldHouseInt"));
ini_closeFile(hFile555);
}

#if defined GH_DEBUGGING
(DEBUG_ODR5, h, GetPVarInt(playerid, "OldHouseInt"));
#endif
DestroyHouseEntrance(h, TYPE_INT);
CreateCorrectHouseExitCP(h, -1);
Loop(i, MAX_PLAYERS)
{
if(GetPVarInt(i, "LastHouseCP") == h && GetPVarInt(i, "IsInHouse") == 1)
{
SetPlayerHouseInterior(i, h);
}
}
}

new file[HOUSEFILE_LENGTH];
format(file, sizeof(file), FILEPATH, GetPVarInt(playerid, "LastHouseCP"));

// Виправлено: ini_exist замінено на fexist
if(!strcmp(GetHouseOwner(GetPVarInt(playerid, "LastHouseCP")), pNick(playerid), CASE_SENSETIVE) && GetPVarInt(playerid, "IsInHouse") == 1 && fexist(file))
{
// Виправлено для mxINI
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_setInteger(hFile, "QuitInHouse", 1);
ini_closeFile(hFile);
}
#if defined GH_DEBUGGING
(DEBUG_OP_DISCONNECT, pNick(playerid), playerid);
#endif
}
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
dcmd(removeallhouses, 15, cmdtext);
dcmd(changeallprices, 15, cmdtext);
dcmd(sellallhouses, 13, cmdtext);
dcmd(createhouse, 11, cmdtext);
dcmd(relhouses, 9, cmdtext);//перезагрузка системы будинкiв
dcmd(lchouse, 7, cmdtext);//блокировка будинку по его ИД
dcmd(removehouse, 11, cmdtext);
dcmd(changeprice, 11, cmdtext);
dcmd(changespawn, 11, cmdtext);
dcmd(sellhouse, 9, cmdtext);
dcmd(housemenu, 9, cmdtext);
dcmd(gotohouse, 9, cmdtext);
dcmd(ghcmds, 6, cmdtext);
return 0;
}
#if defined GH_USE_CPS
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
new keys, updown, leftright;
GetPlayerKeys(playerid, keys, updown, leftright);
if((keys & KEY_SPRINT) || (keys & KEY_SECONDARY_ATTACK) || (keys & KEY_FIRE)) return 1;
if(IsPlayerOnHousePickup[playerid] && LastHousePickupID[playerid] == checkpointid) return 1;
static prev_tick_cp[MAX_PLAYERS];
if(GetTickCount() - prev_tick_cp[playerid] < 100) return 1;
prev_tick_cp[playerid] = GetTickCount();
IsPlayerOnHousePickup[playerid] = true;
LastHousePickupID[playerid] = checkpointid;
GetPlayerPos(playerid, LastPickupX[playerid], LastPickupY[playerid], LastPickupZ[playerid]);
if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
{
new file[HOUSEFILE_LENGTH], string[256]; //
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);
if(checkpointid == HouseCPOut[h])
{
SetPVarInt(playerid, "LastHouseCP", h);
if(!strcmp(GetHouseOwner(h), pNick(playerid), CASE_SENSETIVE)/* || IsPlayerAdmin(playerid)*/) // Если удалить комментарий, RCON администраторы могут войти в любой дом они хотят.
{
SetPVarInt(playerid, "IsInHouse", 1);
SetPlayerHouseInterior(playerid, h);
if(!strcmp(GetHouseOwner(h), pNick(playerid), CASE_SENSETIVE))
{
SendClientMessage(playerid, COLOUR_INFO, I_HMENU);
}
#if defined GH_DEBUGGING
(DEBUG_OP_ED_CP1, pNick(playerid), playerid, h);
#endif
}
if(strcmp(GetHouseOwner(h), pNick(playerid), CASE_SENSETIVE) && strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE))
{
// Оптимізація mxINI: Читаємо пароль будинку
new hFile = ini_openFile(file);
new hPass[MAX_HOUSE_PASSWORD + 1];
if(hFile >= 0)
{
ini_getString(hFile, "HousePassword", hPass, sizeof(hPass));
ini_closeFile(hFile);
}

if(!strcmp(hPass, "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE))
{
ShowInfoBox(playerid, INFORMATION_HEADER, LABELTEXT2, GetHouseName(h), GetHouseOwner(h), GetHouseValue(h), h);
}
if(strcmp(hPass, "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE))
{
format(string,sizeof(string), HMENU_ENTER_PASS, GetHouseName(h), GetHouseOwner(h), GetHouseValue(h), h);
ShowPlayerDialog(playerid, 521, DIALOG_STYLE_INPUT, "{00FF00}Iнформацiя про будинок", string, "{00FF00}Ok", "{FF0000}Вiдмiна");
dlgcont[playerid] = 521;
}
}

// Оптимізація mxINI: Читаємо вартість будинку
new hFileVal = ini_openFile(file);
new hValue = 0;
if(hFileVal >= 0)
{
ini_getInteger(hFileVal, "HouseValue", hValue);
ini_closeFile(hFileVal);
}

if(!strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE) && hValue > 0 && GetPVarInt(playerid, "JustCreatedHouse") == 0)
{
format(string, sizeof(string), HMENU_BUY_HOUSE, pNick(playerid), GetHouseValue(h));
ShowPlayerDialog(playerid, 504, DIALOG_STYLE_MSGBOX, "{00FF00}Купiвля будинку", string, "{00FF00}Купити", "{FF0000}Вiдмiна");
dlgcont[playerid] = 504;
}
break;
}
if(checkpointid == HouseCPInt[h])
{
#if defined GH_HINTERIOR_UPGRADE
if(GetPVarInt(playerid, "HousePreview") == 1)
{
new tmpstring[50];
GetPVarString(playerid, "HousePrevName", tmpstring, 50);
format(string, sizeof(string), HMENU_BUY_HINTERIOR, tmpstring, GetPVarInt(playerid, "HousePrevValue"));
ShowPlayerDialog(playerid, 517, DIALOG_STYLE_MSGBOX, "{00FF00}Iнтер'єр", string, "{00FF00}Купити", "{FF0000}Вiдмiна");
dlgcont[playerid] = 517;
}
#endif
if(GetPVarInt(playerid, "HousePreview") == 0)
{
SetPVarInt(playerid, "IsInHouse", 0);

// Оптимізація mxINI: Читаємо координати виходу
new Float:sOutX, Float:sOutY, Float:sOutZ, Float:sOutA;
new sInt, sWorld;
new hFileSpawn = ini_openFile(file);
if(hFileSpawn >= 0)
{
ini_getFloat(hFileSpawn, "SpawnOutX", sOutX);
ini_getFloat(hFileSpawn, "SpawnOutY", sOutY);
ini_getFloat(hFileSpawn, "SpawnOutZ", sOutZ);
ini_getFloat(hFileSpawn, "SpawnOutAngle", sOutA);
ini_getInteger(hFileSpawn, "SpawnInterior", sInt);
ini_getInteger(hFileSpawn, "SpawnWorld", sWorld);
ini_closeFile(hFileSpawn);
}

SetPlayerPosEx(playerid, sOutX, sOutY, sOutZ, sInt, sWorld);
SetPlayerFacingAngle(playerid, sOutA);
SetPlayerInterior(playerid, sInt);
SetPlayerVirtualWorld(playerid, sWorld);
#if defined GH_DEBUGGING
(DEBUG_OP_ED_CP2, pNick(playerid), playerid, h);
#endif
}
break;
}
}
}
return 1;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
IsPlayerOnHousePickup[playerid] = false;
LastHousePickupID[playerid] = -1;

//////////////////////////////////////////////////////////////////////
if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GetPVarInt(playerid, "JustCreatedHouse") == 1)
{
Loop(h, MAX_HOUSES)
{
if(checkpointid == HouseCPOut[h])
{
SetPVarInt(playerid, "JustCreatedHouse", 0);
break;
}
}
}
return 1;
}
#endif
#if !defined GH_USE_CPS
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
new keys, updown, leftright;
GetPlayerKeys(playerid, keys, updown, leftright);
if((keys & KEY_SPRINT) || (keys & KEY_SECONDARY_ATTACK) || (keys & KEY_FIRE)) return 1;
if(IsPlayerOnHousePickup[playerid] && LastHousePickupID[playerid] == pickupid) return 1;
static prev_tick[MAX_PLAYERS];
if(GetTickCount() - prev_tick[playerid] < 100) return 1;
prev_tick[playerid] = GetTickCount();

IsPlayerOnHousePickup[playerid] = true;
LastHousePickupID[playerid] = pickupid;
GetPlayerPos(playerid, LastPickupX[playerid], LastPickupY[playerid], LastPickupZ[playerid]);

if(GetPVarInt(playerid, "HousePrevTime") != 0) return 1;
if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
{
new file[HOUSEFILE_LENGTH], string[256];
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);
if(pickupid == HousePickupOut[h])
{
SetPVarInt(playerid, "LastHouseCP", h);
if(!strcmp(GetHouseOwner(h), pNick(playerid), CASE_SENSETIVE))
{
SetPVarInt(playerid, "IsInHouse", 1);
SetPlayerHouseInterior(playerid, h);
if(!strcmp(GetHouseOwner(h), pNick(playerid), CASE_SENSETIVE))
{
SendClientMessage(playerid, COLOUR_INFO, I_HMENU);
}
#if defined GH_DEBUGGING
(DEBUG_OP_PUD_PICKUP1, pNick(playerid), playerid, h);
#endif
}
if(strcmp(GetHouseOwner(h), pNick(playerid), CASE_SENSETIVE) && strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE))
{
// Оптимізація mxINI: Читаємо пароль будинку
new hFile = ini_openFile(file);
new hPass[32];
if(hFile >= 0)
{
ini_getString(hFile, "HousePassword", hPass, sizeof(hPass));
ini_closeFile(hFile);
}

if(!strcmp(hPass, "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE))
{
ShowInfoBox(playerid, INFORMATION_HEADER, LABELTEXT2, GetHouseName(h), GetHouseOwner(h), GetHouseValue(h), h);
}
if(strcmp(hPass, "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE))
{
if(lockpas[playerid] == 1) return 1;
lockpas[playerid] = 1;
format(string,sizeof(string), HMENU_ENTER_PASS, GetHouseName(h), GetHouseOwner(h), GetHouseValue(h), h);
ShowPlayerDialog(playerid, 521, DIALOG_STYLE_INPUT, "{00FFFF}Iнформацiя про будинок", string, "{00FF00}OK", "{FF0000}Вiдмiна");
dlgcont[playerid] = 521;
}
}

// Оптимізація mxINI: Читаємо вартість будинку
new hFileVal = ini_openFile(file);
new hValue = 0;
if(hFileVal >= 0)
{
ini_getInteger(hFileVal, "HouseValue", hValue);
ini_closeFile(hFileVal);
}

if(!strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE) && hValue > 0)
{
format(string, sizeof(string), HMENU_BUY_HOUSE, pNick(playerid), GetHouseValue(h));
ShowPlayerDialog(playerid, 504, DIALOG_STYLE_MSGBOX, "Купiвля будинку", string, "{00FF00}Купити", "{FF0000}Вiдмiна");
dlgcont[playerid] = 504;
}
break;
}
if(pickupid == HousePickupInt[h])
{
#if defined GH_HINTERIOR_UPGRADE
if(GetPVarInt(playerid, "HousePreview") == 1)
{
new tmpstring[50];
GetPVarString(playerid, "HousePrevName", tmpstring, 50);
format(string, sizeof(string), HMENU_BUY_HINTERIOR, tmpstring, GetPVarInt(playerid, "HousePrevValue"));
ShowPlayerDialog(playerid, 517, DIALOG_STYLE_MSGBOX, "Iнтер'єр", string, "{00FF00}Купити", "{FF0000}Вiдмiна");
dlgcont[playerid] = 517;
}
#endif
if(GetPVarInt(playerid, "HousePreview") == 0)
{
SetPVarInt(playerid, "IsInHouse", 0);

// Оптимізація mxINI: Читаємо координати виходу одним махом
new Float:sOutX, Float:sOutY, Float:sOutZ, Float:sOutA;
new sInt, sWorld;
new hFileSpawn = ini_openFile(file);
if(hFileSpawn >= 0)
{
ini_getFloat(hFileSpawn, "SpawnOutX", sOutX);
ini_getFloat(hFileSpawn, "SpawnOutY", sOutY);
ini_getFloat(hFileSpawn, "SpawnOutZ", sOutZ);
ini_getFloat(hFileSpawn, "SpawnOutAngle", sOutA);
ini_getInteger(hFileSpawn, "SpawnInterior", sInt);
ini_getInteger(hFileSpawn, "SpawnWorld", sWorld);
ini_closeFile(hFileSpawn);
}

SetPlayerPosEx(playerid, sOutX, sOutY, sOutZ, sInt, sWorld);
SetPlayerFacingAngle(playerid, sOutA);
SetPlayerInterior(playerid, sInt);
SetPlayerVirtualWorld(playerid, sWorld);
#if defined GH_DEBUGGING
(DEBUG_OP_PUD_PICKUP2, pNick(playerid), playerid, h);
#endif
}
break;
}
}
}
return 1;
}

#endif
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
new string[400], file[HOUSEFILE_LENGTH], file2[HOUSEFILE_LENGTH], h = GetPVarInt(playerid, "LastHouseCP"); // Don't complain about huge size, just change it if you need.
format(file, sizeof(file), FILEPATH, h);
if(dialogid == 500)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
switch(listitem)
{
case 0:
{
format(string, sizeof(string), HMENU_SELL_HOUSE, pNick(playerid), GetHouseName(h), ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT));
ShowPlayerDialog(playerid, 503, DIALOG_STYLE_MSGBOX, "Продажа будинку", string, "Продати", "{FF0000}Вiдмiна");
dlgcont[playerid] = 503;
}
case 1:
{
#if defined GH_USE_WEAPONSTORAGE
ShowPlayerDialog(playerid, 518, DIALOG_STYLE_LIST, "Зберiгання в будинку", "Зберiгання грошей\nЗберiгання зброї", "{00FF00}OK", "{FF0000}Вiдмiна");
dlgcont[playerid] = 518;
#endif
#if !defined GH_USE_WEAPONSTORAGE
ShowPlayerDialog(playerid, 510, DIALOG_STYLE_LIST, "Зберiгання грошей", "Покласти на зберiгання\nЗняти з зберiгання\nПровiрити суму", "{00FF00}OK", "{FF0000}Вiдмiна");
dlgcont[playerid] = 510;
#endif
}
case 2:
{
ShowPlayerDialog(playerid, 514, DIALOG_STYLE_INPUT, "назва будинку", "Введiть нову назву будинку", "{00FF00}OK", "{FF0000}Вiдмiна");
dlgcont[playerid] = 514;
}
case 3:
{
ShowPlayerDialog(playerid, 513, DIALOG_STYLE_INPUT, "Пароль для будинку", "Введiть новий пароль для будинку нижче.\nЗалиште поле порожнiм, якщо хочите зберегти Ваш старий пароль.\nВидалити - щоб видалити пароль.", "{00FF00}OK", "{FF0000}Видалити");
dlgcont[playerid] = 513;
}
case 4:
{
ShowPlayerDialog(playerid, 516, DIALOG_STYLE_LIST, "Iнтер'єр", "Попереднiй огляд iнтер'єру\nкупити iнтер'єр", "{00FF00}OK", "{FF0000}Вiдмiна");
dlgcont[playerid] = 516;
}
}
}
return 1;
}
if(dialogid == 503)
{
    if(dialogid != dlgcont[playerid])
    {
        dlgcont[playerid] = -600;
        return 1;
    }
    dlgcont[playerid] = -600;

    h = GetPVarInt(playerid, "LastHouseCP");
    format(file, sizeof(file), FILEPATH, h);

    if(response)
    {
        if(GetOwnedHouses(playerid) == 0) return SendClientMessage(playerid, COLOUR_SYSTEM, E_NO_HOUSES_OWNED);
        else
        {
            new tmp = 0, hValue = 0;
            new hName[MAX_HOUSE_NAME];

            // Чисте зчитування ВСІХ даних за один прохід без використання сторонніх stock-функцій
            new hFileRead = ini_openFile(file);
            if(hFileRead >= 0)
            {
                ini_getInteger(hFileRead, "HouseStorage", tmp);
                ini_getInteger(hFileRead, "HouseValue", hValue);
                ini_getString(hFileRead, "HouseName", hName, sizeof(hName));
                ini_closeFile(hFileRead);
            }

            SetPVarInt(playerid, "MonControl", 1);
            GivePlayerMoney(playerid, ReturnProcent(hValue, HOUSE_SELLING_PROCENT));

            if(tmp >= 1)
            {
                ShowInfoBox(playerid, INFORMATION_HEADER, I_SELL_HOUSE1, ReturnProcent(hValue, HOUSE_SELLING_PROCENT), (hValue - ReturnProcent(hValue, HOUSE_SELLING_PROCENT)), tmp);
                SetPVarInt(playerid, "MonControl", 1);
                GivePlayerMoney(playerid, tmp);
            }
            else
            {
                ShowInfoBox(playerid, INFORMATION_HEADER, I_SELL_HOUSE2, hName, ReturnProcent(hValue, HOUSE_SELLING_PROCENT), (hValue - ReturnProcent(hValue, HOUSE_SELLING_PROCENT)));
            }

            // Перезапис файлу (тепер він успішно збережеться, бо файл був повністю закритий вище)
            new hFileWrite = ini_openFile(file);
            if(hFileWrite >= 0)
            {
                ini_setInteger(hFileWrite, "HouseValue", ReturnProcent(hValue, HOUSE_SELLING_PROCENT));
                ini_setString(hFileWrite, "HouseOwner", INVALID_HOWNER_NAME);
                ini_setString(hFileWrite, "HousePassword", "INVALID_HOUSE_PASSWORD");
                ini_setString(hFileWrite, "HouseName", DEFAULT_HOUSE_NAME);
                ini_setInteger(hFileWrite, "HouseStorage", 0);
                ini_closeFile(hFileWrite);
            }

            Loop(h2, MAX_HOUSES)
            {
                if(IsHouseInRangeOfHouse(h, h2, RANGE_BETWEEN_HOUSES) && h2 != h)
                {
                    format(file2, sizeof(file2), FILEPATH, h2);
                    new hFileLoop = ini_openFile(file2);
                    if(hFileLoop >= 0)
                    {
                        new h2_val = 0;
                        ini_getInteger(hFileLoop, "HouseValue", h2_val);
                        ini_setInteger(hFileLoop, "HouseValue", (h2_val - ReturnProcent(GetHouseValue(h2), HOUSE_SELLING_PROCENT2)));
                        ini_closeFile(hFileLoop);
                    }
                    UpdateHouseText(h2);
                }
            }

            #if defined GH_USE_MAPICONS
            DestroyDynamicMapIcon(HouseMIcon[h]);
            new Float:cpX, Float:cpY, Float:cpZ;
            new sWorld, sInt;
            new hFileIcon = ini_openFile(file);
            if(hFileIcon >= 0)
            {
                ini_getFloat(hFileIcon, "CPOutX", cpX);
                ini_getFloat(hFileIcon, "CPOutY", cpY);
                ini_getFloat(hFileIcon, "CPOutZ", cpZ);
                ini_getInteger(hFileIcon, "SpawnWorld", sWorld);
                ini_getInteger(hFileIcon, "SpawnInterior", sInt);
                ini_closeFile(hFileIcon);
            }
            HouseMIcon[h] = CreateDynamicMapIcon(cpX, cpY, cpZ, 31, -1, sWorld, sInt, -1, MICON_VD);
            #endif

            UpdateHouseText(h);
        }
    }
    return 1;
}


if(dialogid == 504)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
new hname[MAX_PLAYER_NAME+9];
if(GetOwnedHouses(playerid) >= MAX_HOUSES_OWNED) { ShowInfoBox(playerid, INFORMATION_HEADER, "{FF0000}У Вас уже є %d будинки. Продайте один з старих будинкiв щоб купити цей.", MAX_HOUSES_OWNED); return 1; }
if(strcmp(GetHouseOwner(GetPVarInt(playerid, "LastHouseCP")), pNick(playerid), CASE_SENSETIVE) && strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_H_ALREADY_OWNED);
if(GetHouseValue(h) > GetPlayerMoney(playerid)) { ShowInfoBox(playerid, INFORMATION_HEADER, "{FF0000}Ви не можете купити цей Будинок\nВартiсть будинку: $%d.\nУ Вас є: $%d.\nВам не хватає: $%d.", GetHouseValue(h), GetPlayerMoney(playerid), (GetHouseValue(h) - GetPlayerMoney(playerid))); return 1; }

else
{
format(hname, sizeof(hname), "%s's House", pNick(playerid));
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, - GetHouseValue(h));

// Оптимізація mxINI: Записуємо дані нового власника будинку
new hFileBuy = ini_openFile(file);
if(hFileBuy >= 0)
{
ini_setString(hFileBuy, "HouseOwner", pNick(playerid));
ini_setString(hFileBuy, "HousePassword", "INVALID_HOUSE_PASSWORD");
ini_setString(hFileBuy, "HouseName", hname);
ini_setInteger(hFileBuy, "HouseStorage", 0);
ini_closeFile(hFileBuy);
}

ShowInfoBox(playerid, INFORMATION_HEADER, I_BUY_HOUSE, GetHouseValue(h));
Loop(h2, MAX_HOUSES)
{
if(IsHouseInRangeOfHouse(h, h2, RANGE_BETWEEN_HOUSES) && h2 != h)
{
format(file2, sizeof(file2), FILEPATH, h2);

// Оптимізація mxINI: Оновлюємо ціну сусідніх будинків після покупки
new hFileLoop2 = ini_openFile(file2);
if(hFileLoop2 >= 0)
{
new h2_val = 0;
ini_getInteger(hFileLoop2, "HouseValue", h2_val);
ini_setInteger(hFileLoop2, "HouseValue", (h2_val + ReturnProcent(GetHouseValue(h2), HOUSE_SELLING_PROCENT2)));
ini_closeFile(hFileLoop2);
}
UpdateHouseText(h2);
}
}

// Зчитуємо ID інтер'єру з файлу для створення чекпоінту виходу
new hInteriorID = 0;
#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);

// Оптимізація mxINI: Читаємо дані для нової іконки мапи та інтер'єру
new Float:cpX, Float:cpY, Float:cpZ;
new sWorld, sInt;
new hFileIcon2 = ini_openFile(file);
if(hFileIcon2 >= 0)
{
ini_getFloat(hFileIcon2, "CPOutX", cpX);
ini_getFloat(hFileIcon2, "CPOutY", cpY);
ini_getFloat(hFileIcon2, "CPOutZ", cpZ);
ini_getInteger(hFileIcon2, "SpawnWorld", sWorld);
ini_getInteger(hFileIcon2, "SpawnInterior", sInt);
ini_getInteger(hFileIcon2, "HouseInterior", hInteriorID); // Зчитали інтер'єр
ini_closeFile(hFileIcon2);
}
HouseMIcon[h] = CreateDynamicMapIcon(cpX, cpY, cpZ, 32, -1, sWorld, sInt, -1, MICON_VD);
#else
new hFileFix = ini_openFile(file);
if(hFileFix >= 0)
{
ini_getInteger(hFileFix, "HouseInterior", hInteriorID);
ini_closeFile(hFileFix);
}
#endif

// Активуємо створення пікапу/чекпоінту виходу зсередини будинку
CreateCorrectHouseExitCP(h, hInteriorID);

// Автоматично заводимо гравця всередину купленого будинку
SetPVarInt(playerid, "IsInHouse", 1);
SetPlayerHouseInterior(playerid, h);
SendClientMessage(playerid, COLOUR_INFO, I_HMENU);

UpdateHouseText(h);
#if defined GH_DEBUGGING
(DEBUG_ODR1, pNick(playerid), playerid, h, GetHouseValue(h));
#endif
}
}
return 1;
}


if(dialogid == 513)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
if(InpTxtControl(inputtext) == 0)
{
SendClientMessage(playerid, COLOUR_SYSTEM, "Ваш пароль мiстить недопустимi символи:");
SendClientMessage(playerid, COLOUR_SYSTEM, "забороненi коди, чи знак вiдсоткiв, або ~ .");
return 1;
}
if(strlen(inputtext) > MAX_HOUSE_PASSWORD || (strlen(inputtext) < MIN_HOUSE_PASSWORD && strlen(inputtext) >= 1)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HPASS_LENGTH);
if(!strcmp(inputtext, "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HPASS);
else
{
if(strlen(inputtext) >= 1)
{
// Оптимізація mxINI: Запис нового пароля
new hFilePass = ini_openFile(file);
if(hFilePass >= 0)
{
ini_setString(hFilePass, "HousePassword", inputtext);
ini_closeFile(hFilePass);
}
ShowInfoBox(playerid, INFORMATION_HEADER, I_HPASSWORD_CHANGED, inputtext);
#if defined GH_DEBUGGING
(DEBUG_ODR14, pNick(playerid), playerid, h);
#endif
}
else SendClientMessage(playerid, COLOUR_INFO, I_HPASS_NO_CHANGE);
}
}
if(!response)
{
// Оптимізація mxINI: Скидання пароля
new hFilePassRem = ini_openFile(file);
if(hFilePassRem >= 0)
{
ini_setString(hFilePassRem, "HousePassword", "INVALID_HOUSE_PASSWORD");
ini_closeFile(hFilePassRem);
}
SendClientMessage(playerid, COLOUR_INFO, I_HPASS_REMOVED);
}
return 1;
}
if(dialogid == 514)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
if(InpTxtControl(inputtext) == 0)
{
SendClientMessage(playerid, COLOUR_SYSTEM, "Ваш пароль мiстить недопустимi символи:");
SendClientMessage(playerid, COLOUR_SYSTEM, "забороненi коди, чи знак вiдтоткiв, або ~ .");
return 1;
}
if(strlen(inputtext) < MIN_HOUSE_NAME || strlen(inputtext) > MAX_HOUSE_NAME) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HNAME_LENGTH);
else
{
// Оптимізація mxINI: Зміна назви будинку
new hFileAName = ini_openFile(file);
if(hFileAName >= 0)
{
ini_setString(hFileAName, "HouseName", inputtext);
ini_closeFile(hFileAName);
}
SendMSG(playerid, COLOUR_INFO, 128, I_HNAME_CHANGED, inputtext);
UpdateHouseText(h);
#if defined GH_DEBUGGING
(DEBUG_ODR2, pNick(playerid), playerid, h, inputtext);
#endif
}
}
return 1;
}
if(dialogid == 515)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
// Оптимізація mxINI: Читання старого інтер'єру будинку
new current_interior = 0;
new hFileIntRead = ini_openFile(file);
if(hFileIntRead >= 0)
{
ini_getInteger(hFileIntRead, "HouseInterior", current_interior);
ini_closeFile(hFileIntRead);
}
SetPVarInt(playerid, "OldHouseInt", current_interior);

switch(listitem)
{
case 0:
{
SetPVarInt(playerid, "HousePrevInt", 1);
SetPVarInt(playerid, "HousePrevValue", H_INT_1_VALUE);
SetPVarString(playerid, "HousePrevName", "Shitty Shack");
}
case 1:
{
SetPVarInt(playerid, "HousePrevInt", 2);
SetPVarInt(playerid, "HousePrevValue", H_INT_2_VALUE);
SetPVarString(playerid, "HousePrevName", "Motel Room");
}
case 2:
{
SetPVarInt(playerid, "HousePrevInt", 3);
SetPVarInt(playerid, "HousePrevValue", H_INT_3_VALUE);
SetPVarString(playerid, "HousePrevName", "Hotel Room 1");
}
case 3:
{
SetPVarInt(playerid, "HousePrevInt", 4);
SetPVarInt(playerid, "HousePrevValue", H_INT_4_VALUE);
SetPVarString(playerid, "HousePrevName", "Hotel Room 2");
}
case 4:
{
SetPVarInt(playerid, "HousePrevInt", 5);
SetPVarInt(playerid, "HousePrevValue", H_INT_5_VALUE);
SetPVarString(playerid, "HousePrevName", "Gang House");
}
case 5:
{
SetPVarInt(playerid, "HousePrevInt", 6);
SetPVarInt(playerid, "HousePrevValue", H_INT_6_VALUE);
SetPVarString(playerid, "HousePrevName", "Normal House");
}
case 6:
{
SetPVarInt(playerid, "HousePrevInt", 0);
SetPVarInt(playerid, "HousePrevValue", H_INT_0_VALUE);
SetPVarString(playerid, "HousePrevName", "Default House");
}
case 7:
{
SetPVarInt(playerid, "HousePrevInt", 7);
SetPVarInt(playerid, "HousePrevValue", H_INT_7_VALUE);
SetPVarString(playerid, "HousePrevName", "Medium Mansion");
}
case 8:
{
SetPVarInt(playerid, "HousePrevInt", 8);
SetPVarInt(playerid, "HousePrevValue", H_INT_8_VALUE);
SetPVarString(playerid, "HousePrevName", "Rich Mansion");
}
case 9:
{
SetPVarInt(playerid, "HousePrevInt", 9);
SetPVarInt(playerid, "HousePrevValue", H_INT_9_VALUE);
SetPVarString(playerid, "HousePrevName", "Huge Mansion");
}
case 10:
{
SetPVarInt(playerid, "HousePrevInt", 10);
SetPVarInt(playerid, "HousePrevValue", H_INT_10_VALUE);
SetPVarString(playerid, "HousePrevName", "Madd Dogg's Mansion");
}
}
if(current_interior == GetPVarInt(playerid, "HousePrevInt")) return SendClientMessage(playerid, COLOUR_SYSTEM, E_ALREADY_HAVE_HINTERIOR);
else
{
GetPVarString(playerid, "HousePrevName", string, 50);
switch(GetPVarInt(playerid, "HouseIntUpgradeMod"))
{
case 1:
{
SetPVarInt(playerid, "HousePrevTime", 1);//включаем блокировку меню будинку
SetPVarInt(playerid, "IsHouseVisiting", 1);
SetPVarInt(playerid, "HousePreview", 1);
SetPVarInt(playerid, "ChangeHouseInt", 1);
SetPVarInt(playerid, "HousePrevTimer", SetTimerEx("HouseVisiting", (MAX_VISIT_TIME * 1000), false, "i", playerid));
ShowInfoBox(playerid, INFORMATION_HEADER, I_VISITING_HOUSEINT, string, GetPVarInt(playerid, "HousePrevValue"), MAX_VISIT_TIME, AddS(MAX_VISIT_TIME));
#if defined GH_DEBUGGING
(DEBUG_ODR4, pNick(playerid), playerid, string, h);
#endif
}
case 2:
{
if(GetPVarInt(playerid, "HousePrevValue") > GetPlayerMoney(playerid))
{
ShowInfoBox(playerid, INFORMATION_HEADER, E_CANT_AFFORD_HINT, string, GetPVarInt(playerid, "HousePrevValue"), GetPlayerMoney(playerid), (GetPVarInt(playerid, "HousePrevValue") - GetPlayerMoney(playerid)));
}
if(GetPVarInt(playerid, "HousePrevValue") <= GetPlayerMoney(playerid))
{
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, - GetPVarInt(playerid, "HousePrevValue"));
SetPVarInt(playerid, "ChangeHouseInt", 1);
// Оптимізація mxINI: Оновлення вартості покращення інтер'єру
new hFileIntValWrite = ini_openFile(file);
if(hFileIntValWrite >= 0)
{
ini_setInteger(hFileIntValWrite, "HouseInteriorValue", GetPVarInt(playerid, "HousePrevValue"));
ini_closeFile(hFileIntValWrite);
}
ShowInfoBox(playerid, INFORMATION_HEADER, I_HINT_BOUGHT, string, GetPVarInt(playerid, "HousePrevValue"));
#if defined GH_DEBUGGING
(DEBUG_ODR3, pNick(playerid), playerid, string, GetPVarInt(playerid, "HousePrevValue"), h);
#endif
}
}
}
if(GetPVarInt(playerid, "ChangeHouseInt") == 1)
{
// Оптимізація mxINI: Оновлення самого ID інтер'єру
new hFileIntWrite = ini_openFile(file);
if(hFileIntWrite >= 0)
{
ini_setInteger(hFileIntWrite, "HouseInterior", GetPVarInt(playerid, "HousePrevInt"));
ini_closeFile(hFileIntWrite);
}
SetPVarInt(playerid, "ChangeHouseInt", 0);
DestroyHouseEntrance(h, TYPE_INT);
CreateCorrectHouseExitCP(h, -1);
Loop(i, MAX_PLAYERS)
{
if(GetPVarInt(i, "LastHouseCP") == h && GetPVarInt(i, "IsInHouse") == 1)
{
SetPlayerHouseInterior(i, h);
}
}
#if defined GH_DEBUGGING
(DEBUG_ODR5, h, GetPVarInt(playerid, "HousePrevInt"));
#endif
}
}
}
return 1;
}

#if defined GH_HINTERIOR_UPGRADE
if(dialogid == 516)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
switch(listitem)
{
case 0: SetPVarInt(playerid, "HouseIntUpgradeMod", 1);
case 1: SetPVarInt(playerid, "HouseIntUpgradeMod", 2);
}
format(string, sizeof(string),
"Shitty Shack Interior\t\t%s\nMotel Room Interior\t\t%s\nHotel Room Interior 1\t\t%s\nHotel Room Interior 2\t\t%s\nGang House Interior\t\t%s\nNormal House Interior\t\t%s\nDefault House Interior\t\t%s\nMedium Mansion Interior\t%s\nRich Mansion Interior\t\t%s\nHuge Mansion Interior\t\t%s\nMadd Dogg's Mansion\t\t%s",
FM(H_INT_1_VALUE), FM(H_INT_2_VALUE), FM(H_INT_3_VALUE), FM(H_INT_4_VALUE), FM(H_INT_5_VALUE), FM(H_INT_6_VALUE), FM(H_INT_0_VALUE), FM(H_INT_7_VALUE), FM(H_INT_8_VALUE), FM(H_INT_9_VALUE), FM(H_INT_10_VALUE));
ShowPlayerDialog(playerid, 515, DIALOG_STYLE_LIST, "Iнтер'єр", string, "{00FF00}Купити", "{FF0000}Вiдмiна");
dlgcont[playerid] = 515;
}
return 1;
}
#endif
#if defined GH_HINTERIOR_UPGRADE
if(dialogid == 517)
{
    if(dialogid != dlgcont[playerid])
    {
        dlgcont[playerid] = -600;
        return 1;
    }
    dlgcont[playerid] = -600;
    SetPVarInt(playerid, "HousePreview", 0);
    KillTimer(GetPVarInt(playerid, "HousePrevTimer"));
    SetPVarInt(playerid, "IsHouseVisiting", 0);

    h = GetPVarInt(playerid, "LastHouseCP");
    format(file, sizeof(file), FILEPATH, h);

    switch(response)
    {
        case 0:
        {
            new hFile = ini_openFile(file);
            if(hFile >= 0)
            {
                ini_setInteger(hFile, "HouseInterior", GetPVarInt(playerid, "OldHouseInt"));
                ini_closeFile(hFile);
            }
            #if defined GH_DEBUGGING
            (DEBUG_ODR5, h, GetPVarInt(playerid, "OldHouseInt"));
            #endif
        }
        case 1:
        {
            GetPVarString(playerid, "HousePrevName", string, 50);
            if(GetPlayerMoney(playerid) < GetPVarInt(playerid, "HousePrevValue"))
            {
                new hFile = ini_openFile(file);
                if(hFile >= 0)
                {
                    ini_setInteger(hFile, "HouseInterior", GetPVarInt(playerid, "OldHouseInt"));
                    ini_closeFile(hFile);
                }
                ShowInfoBox(playerid, INFORMATION_HEADER, E_CANT_AFFORD_HINT, string, GetPVarInt(playerid, "HousePrevValue"), GetPlayerMoney(playerid), (GetPVarInt(playerid, "HousePrevValue") - GetPlayerMoney(playerid)));
            }
            else
            {
                SetPVarInt(playerid, "MonControl", 1);
                GivePlayerMoney(playerid, - GetPVarInt(playerid, "HousePrevValue"));

                new hFile = ini_openFile(file);
                if(hFile >= 0)
                {
                    ini_setString(hFile, "HouseInteriorName", string);
                    ini_setInteger(hFile, "HouseInterior", GetPVarInt(playerid, "HousePrevInt"));
                    ini_setInteger(hFile, "HouseInteriorValue", GetPVarInt(playerid, "HousePrevValue"));
                    ini_closeFile(hFile);
                }

                ShowInfoBox(playerid, INFORMATION_HEADER, I_HINT_BOUGHT, string, GetPVarInt(playerid, "HousePrevValue"));
            }
        }
    }

    DestroyHouseEntrance(h, TYPE_INT);

    // Передаємо конкретний ID інтер'єру з PVar, щоб функція взагалі не лізла до файлу
    CreateCorrectHouseExitCP(h, GetPVarInt(playerid, "HousePrevInt"));

    SetPlayerHouseInterior(playerid, h);
    return 1;
}

#endif
if(dialogid == 510)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
// Оптимізація mxINI: Дізнаємося баланс сейфу будинку
new tmp = 0;
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getInteger(hFile, "HouseStorage", tmp);
ini_closeFile(hFile);
}

if(listitem == 0) // Deposit
{
format(string, sizeof(string), I_HINT_DEPOSIT1, tmp);
ShowPlayerDialog(playerid, 511, DIALOG_STYLE_INPUT, "Зберiгання грошей: покласти на зберiгання", string, "{00FF00}Покласти", "{FF0000}Вiдмiна");
dlgcont[playerid] = 511;
}
if(listitem == 1) // Withdraw
{
format(string, sizeof(string), I_HINT_WITHDRAW1, tmp);
ShowPlayerDialog(playerid, 512, DIALOG_STYLE_INPUT, "Зберiгання грошей: зняти з зберiгання", string, "{00FF00}Зняти", "{FF0000}Вiдмiна");
dlgcont[playerid] = 512;
}
if(listitem == 2) // Check Balance
{
ShowInfoBox(playerid, INFORMATION_HEADER, I_HINT_CHECKBALANCE, tmp);
#if defined GH_DEBUGGING
(DEBUG_ODR6, pNick(playerid), playerid, h, tmp);
#endif
}
}
return 1;
}
if(dialogid == 511)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
if(InpTxtControl(inputtext) == 0)
{
SendClientMessage(playerid, COLOUR_SYSTEM, "Сума мiстить недопустимi символи:");
SendClientMessage(playerid, COLOUR_SYSTEM, "забороненi коди, чи знак вiдсоткiв, або ~ .");
return 1;
}
new amount = floatround(strval(inputtext));
format(file, sizeof(file), FILEPATH, h);
if(amount > GetPlayerMoney(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_PMONEY);
if(amount < 1) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_AMOUNT);

// Оптимізація mxINI: Зчитуємо поточний баланс перед додаванням суми
new current_storage = 0;
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getInteger(hFile, "HouseStorage", current_storage);
ini_closeFile(hFile);
}

if((current_storage + amount) > 50000000) return SendClientMessage(playerid, COLOUR_SYSTEM, E_HSTORAGE_L_REACHED);
else
{
new new_storage = current_storage + amount;

// Оптимізація mxINI: Записуємо новий баланс сейфу
new hFileWrite = ini_openFile(file);
if(hFileWrite >= 0)
{
ini_setInteger(hFileWrite, "HouseStorage", new_storage);
ini_closeFile(hFileWrite);
}

SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, - amount);
ShowInfoBox(playerid, INFORMATION_HEADER, I_HINT_DEPOSIT2, amount, new_storage);
#if defined GH_DEBUGGING
(DEBUG_ODR7, pNick(playerid), playerid, amount, h);
#endif
}
}
return 1;
}

if(dialogid == 512)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
if(InpTxtControl(inputtext) == 0)
{
SendClientMessage(playerid, COLOUR_SYSTEM, "Сума мiстить недопустимi символи:");
SendClientMessage(playerid, COLOUR_SYSTEM, "забороненi коди, чи знак відсоткiв, або ~ .");
return 1;
}
new amount = floatround(strval(inputtext));
format(file, sizeof(file), FILEPATH, h);

// Оптимізація mxINI: Зчитуємо баланс сейфу перед зняттям
new current_storage = 0;
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getInteger(hFile, "HouseStorage", current_storage);
ini_closeFile(hFile);
}

if(amount > current_storage) return SendClientMessage(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_HSMONEY);
if(amount < 1) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_AMOUNT);
else
{
new new_storage = current_storage - amount;

// Оптимізація mxINI: Записуємо новий баланс сейфу
new hFileWrite = ini_openFile(file);
if(hFileWrite >= 0)
{
ini_setInteger(hFileWrite, "HouseStorage", new_storage);
ini_closeFile(hFileWrite);
}

SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, amount);
ShowInfoBox(playerid, INFORMATION_HEADER, I_HINT_WITHDRAW2, amount, new_storage);
#if defined GH_DEBUGGING
(DEBUG_ODR8, pNick(playerid), playerid, amount, h);
#endif
}
}
return 1;
}
if(dialogid == 518)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
switch(listitem)
{
case 0:
{
ShowPlayerDialog(playerid, 510, DIALOG_STYLE_LIST, "Зберiгання грошей", "Покласти на зберiгання\nЗняти з зберiгання\nПровiрити суму", "{00FF00}OK", "{FF0000}Вiдмiна");
dlgcont[playerid] = 510;
}
case 1:
{
ShowPlayerDialog(playerid, 519, DIALOG_STYLE_LIST, "Зберiгання зброї", "Покласти на зберiгання\nЗняти з зберiгання", "{00FF00}OK", "{FF0000}Вiдмiна");
dlgcont[playerid] = 519;
}
}
}
return 1;
}
if(dialogid == 519)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
new WeaponData[13][2], tmp[9], tmp2[13], tmpcount;
switch(listitem)
{
case 0: // Store weapons
{
// Оптимізація mxINI: Відкриваємо файл 1 раз ПЕРЕД циклом
new hFileWeap = ini_openFile(file);
if(hFileWeap >= 0)
{
Loop(weap, 13)
{
format(tmp, sizeof(tmp), "Weapon%d", weap);
format(tmp2, sizeof(tmp2), "Weapon%dAmmo", weap);
if(weap == 0) continue;
#if !defined GH_SAVE_ADMINWEPS
if(weap == 7 || weap == 8 || weap == 9 || weap == 12) continue;
#endif
GetPlayerWeaponData(playerid, weap, WeaponData[weap][0], WeaponData[weap][1]);
if(WeaponData[weap][1] == 0 || (weap == 11 && WeaponData[weap][0] != 46)) continue;
ini_setInteger(hFileWeap, tmp, WeaponData[weap][0]);
ini_setInteger(hFileWeap, tmp2, WeaponData[weap][1]);
GivePlayerWeapon(playerid, WeaponData[weap][0], -WeaponData[weap][1]);
tmpcount++;
}
ini_closeFile(hFileWeap); // Закриваємо після завершення циклу
}
if(tmpcount >= 1)
{
ShowInfoBox(playerid, INFORMATION_HEADER, I_HS_WEAPONS1, tmpcount, AddS(tmpcount));
}
if(tmpcount == 0)
{
ShowInfoBox(playerid, INFORMATION_HEADER, E_NO_WEAPONS, tmpcount);
}
#if defined GH_DEBUGGING
(DEBUG_ODR10, pNick(playerid), playerid, tmpcount, h);
#endif
}
case 1: // Recieve Weapons
{
// Оптимізація mxINI: Відкриваємо файл 1 раз ПЕРЕД циклом
new hFileGetWeap = ini_openFile(file);
if(hFileGetWeap >= 0)
{
Loop(weap, 13)
{
format(tmp, sizeof(tmp), "Weapon%d", weap);
format(tmp2, sizeof(tmp2), "Weapon%dAmmo", weap);
new wAmmo = 0, wID = 0;
ini_getInteger(hFileGetWeap, tmp2, wAmmo);
if(wAmmo == 0) continue;
if(weap == 0) continue;
#if !defined GH_SAVE_ADMINWEPS
if(weap == 7 || weap == 8 || weap == 9 || weap == 11 || weap == 12) continue;
#endif
ini_getInteger(hFileGetWeap, tmp, wID);
GivePlayerWeapon(playerid, wID, wAmmo);
ini_setInteger(hFileGetWeap, tmp, 0);
ini_setInteger(hFileGetWeap, tmp2, 0);
tmpcount++;
}
ini_closeFile(hFileGetWeap); // Закриваємо після завершення циклу
}
if(tmpcount >= 1)
{
ShowInfoBox(playerid, INFORMATION_HEADER, I_HS_WEAPONS2, tmpcount, AddS(tmpcount));
}
if(tmpcount == 0)
{
ShowInfoBox(playerid, INFORMATION_HEADER, E_NO_HS_WEAPONS, tmpcount);
}
#if defined GH_DEBUGGING
(DEBUG_ODR11, pNick(playerid), playerid, tmpcount, h);
#endif
}
}
}
return 1;
}

if(dialogid == 520)
{
return 1;
}


if(dialogid == 521)
{
if(dialogid != dlgcont[playerid])
{
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога

lockpas[playerid] = 0;//разблокировать диалог ввода пароля

if(response)
{
format(file, sizeof(file), FILEPATH, h);
if(InpTxtControl(inputtext) == 0)
{
SendClientMessage(playerid, COLOUR_SYSTEM, "Пароль мiстить недопустимi символи:");
SendClientMessage(playerid, COLOUR_SYSTEM, "забороненi коди, чи знак вiдсоткiв, або ~ .");
return 1;
}
if(strlen(inputtext) < MIN_HOUSE_PASSWORD || strlen(inputtext) > MAX_HOUSE_PASSWORD) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HPASS_LENGTH);

// Оптимізація mxINI: Зчитуємо пароль будинку з файлу
new hActualPass[MAX_HOUSE_PASSWORD + 1];
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getString(hFile, "HousePassword", hActualPass, sizeof(hActualPass));
ini_closeFile(hFile);
}

if(strcmp(hActualPass, inputtext, false) != 0)//пароль без хэш-шифрования
{
ShowInfoBox(playerid, INFORMATION_HEADER, I_WRONG_HPASS1, GetHouseOwner(GetPVarInt(playerid, "LastHouseCP")), inputtext);
if(IsPlayerConnected(GetHouseOwnerEx(GetPVarInt(playerid, "LastHouseCP"))))
{
SendMSG(GetHouseOwnerEx(h), COLOUR_INFO, 128, I_WRONG_HPASS2, pNick(playerid), playerid, inputtext);
}
}
else
{
ShowInfoBox(playerid, INFORMATION_HEADER, I_CORRECT_HPASS1, GetHouseOwner(GetPVarInt(playerid, "LastHouseCP")), inputtext);
SetPVarInt(playerid, "IsInHouse", 1);
SetPlayerHouseInterior(playerid, GetPVarInt(playerid, "LastHouseCP"));
if(IsPlayerConnected(GetHouseOwnerEx(GetPVarInt(playerid, "LastHouseCP"))))
{
SendMSG(GetHouseOwnerEx(h), COLOUR_INFO, 128, I_CORRECT_HPASS2, pNick(playerid), playerid, inputtext);
}
#if defined GH_DEBUGGING
(DEBUG_ODR12, pNick(playerid), playerid, h);
#endif
}
}
return 1;
}
return 0;
}

stock Float:GetPosInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
new Float:a;
GetPlayerPos(playerid, x, y, a);
if (IsPlayerInAnyVehicle(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
else GetPlayerFacingAngle(playerid, a);
x += (distance * floatsin(-a, degrees));
y += (distance * floatcos(-a, degrees));
return a;
}
dcmd_housemenu(playerid, params[])
{
#pragma unused params

if(GetPVarInt(playerid, "HousePrevTime") != 0) return SendClientMessage(playerid, COLOUR_SYSTEM, "Зараз Ви не можете використовувати меню будинку.");//сообщение о запрете меню

if(strcmp(GetHouseOwner(GetPVarInt(playerid, "LastHouseCP")), pNick(playerid), CASE_SENSETIVE) && GetPVarInt(playerid, "IsInHouse") == 1) return SendClientMessage(playerid, COLOUR_SYSTEM, E_C_ACCESS_SE_HM);
if(GetPVarInt(playerid, "IsInHouse") == 0) return SendClientMessage(playerid, COLOUR_SYSTEM, E_NOT_IN_HOUSE);
if(GetOwnedHouses(playerid) == 0) return SendClientMessage(playerid, COLOUR_SYSTEM, E_NOT_HOWNER);
if(GetPVarInt(playerid, "IsInHouse") == 1 && !strcmp(GetHouseOwner(GetPVarInt(playerid, "LastHouseCP")), pNick(playerid), CASE_SENSETIVE) && GetOwnedHouses(playerid) >= 1)
{
#if defined GH_HINTERIOR_UPGRADE
ShowPlayerDialog(playerid, 500, DIALOG_STYLE_LIST, "{00FF00}Меню будинку", "Продажа будинку\nЗберiгання в будинку\nНазва будинку\nПароль для будинку\niнтер'єр", "{00FF00}OK", "{FF0000}Вiдмiна");
dlgcont[playerid] = 500;
#endif
#if !defined GH_HINTERIOR_UPGRADE
ShowPlayerDialog(playerid, 500, DIALOG_STYLE_LIST, "{00FF00}Меню будинку", "Продажа будинку\nЗберiгання в будинку\nНазва будинку\nПароль для будинку", "{00FF00}OK", "{FF0000}Вiдмiна");
dlgcont[playerid] = 500;
#endif
}
return 1;
}
dcmd_createhouse(playerid, params[])
{
new cost, file[HOUSEFILE_LENGTH], h = GetFreeHouseID(), labeltext[150], hinterior;
if(!IsPlayerAdmin(playerid)) return 0;
if(sscanf(params, "dD(" #DEFAULT_H_INTERIOR ")", cost, hinterior)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CREATEHOUSE);
if(hinterior > 10)
{
hinterior = 0;
}
if(h < 0)
{
ShowInfoBox(playerid, INFORMATION_HEADER, E_TOO_MANY_HOUSES, MAX_HOUSES - 1);
return 1;
}
if(cost < MIN_HOUSE_VALUE || cost > MAX_HOUSE_VALUE) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HVALUE);
else
{
format(file, sizeof(file), FILEPATH, h);

// Найнадійніший спосіб створення порожнього файлу в SA-MP
new File:createCheck = fopen(file, io_write);
if(createCheck) fclose(createCheck);

// Спочатку беремо початкові координати гравця
GetPlayerPos(playerid, X, Y, Z);
GetPlayerFacingAngle(playerid, Angle);

// Отримуємо координати перед гравцем (вона змінить змінні X та Y для спавну)
new Float:spawnX = X, Float:spawnY = Y;
GetPosInFrontOfPlayer(playerid, spawnX, spawnY, -2.5);

// Оптимізація mxINI: Відкриваємо файл 1 раз і записуємо ВСІ дані махом
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_setFloat(hFile, "CPOutX", X);
ini_setFloat(hFile, "CPOutY", Y);
ini_setFloat(hFile, "CPOutZ", Z);
ini_setString(hFile, "HouseName", DEFAULT_HOUSE_NAME);
ini_setString(hFile, "HouseOwner", INVALID_HOWNER_NAME);
ini_setString(hFile, "HousePassword", "INVALID_HOUSE_PASSWORD");
ini_setString(hFile, "HouseCreator", pNick(playerid));
ini_setInteger(hFile, "HouseValue", cost);
ini_setInteger(hFile, "HouseStorage", 0);
ini_setFloat(hFile, "SpawnOutX", spawnX);
ini_setFloat(hFile, "SpawnOutY", spawnY);
ini_setFloat(hFile, "SpawnOutZ", Z);
ini_setFloat(hFile, "SpawnOutAngle", floatround((180 + Angle)));
ini_setInteger(hFile, "SpawnWorld", GetPlayerVirtualWorld(playerid));
ini_setInteger(hFile, "SpawnInterior", GetPlayerInterior(playerid));
ini_setInteger(hFile, "HouseInterior", hinterior);
ini_closeFile(hFile); // Зберігаємо і закриваємо файл
}

format(labeltext, sizeof(labeltext), LABELTEXT1, DEFAULT_HOUSE_NAME, cost, h);
#if defined GH_USE_CPS
HouseCPOut[h] = CreateDynamicCP(X, Y, Z, 1.5, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 25.0);
HouseCPInt[h] = CreateDynamicCP(2196.84, -1204.36, 1049.02, 1.5, (h + 1000), 6, -1, 100.0);
#endif
#if !defined GH_USE_CPS
HousePickupOut[h] = CreateDynamicPickup(PICKUP_MODEL_OUT, PICKUP_TYPE, X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 15.0);
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2195.84, -1204.36, 1049.02, (h + 1000), 6, -1, 15.0);
#endif
#if defined GH_USE_MAPICONS
HouseMIcon[h] = CreateDynamicMapIcon(X, Y, Z, 31, -1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, MICON_VD);
#endif
HouseLabel[h] = CreateDynamic3DTextLabel(labeltext, COLOUR_GREEN, X, Y, Z+0.7, 8, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1);
SendMSG(playerid, COLOUR_YELLOW, 128, I_H_CREATED, h);

#if defined GH_USE_CPS
switch(hinterior)

case 1:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_1_VALUE); ini_setString(hFile, "HouseInteriorName", "Shitty Shack"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(2259.38, -1135.89, 1050.64, 1.50, (h + 1000), 10, -1, 10.0);
}
case 2:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_2_VALUE); ini_setString(hFile, "HouseInteriorName", "Motel Room"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(2282.99, -1140.28, 1050.89, 1.50, (h + 1000), 11, -1, 10.0);
}
case 3:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_3_VALUE); ini_setString(hFile, "HouseInteriorName", "Hotel Room 1"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(2233.69, -1115.26, 1050.88, 1.50, (h + 1000), 5, -1, 10.0);
}
case 4:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_4_VALUE); ini_setString(hFile, "HouseInteriorName", "Hotel Room 2"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(2218.39, -1076.21, 1050.48, 1.50, (h + 1000), 1, -1, 10.0);
}
case 5:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_5_VALUE); ini_setString(hFile, "HouseInteriorName", "Gang House"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(2496.00, -1692.08, 1014.74, 1.50, (h + 1000), 3, -1, 10.0);
}
case 6:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_6_VALUE); ini_setString(hFile, "HouseInteriorName", "Normal House"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(2365.25, -1135.58, 1050.88, 1.50, (h + 1000), 8, -1, 10.0);
}
case 0:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_0_VALUE); ini_setString(hFile, "HouseInteriorName", "Default House"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(2196.84, -1204.36, 1049.02, 1.5, (h + 1000), 6, -1, 10.0);
}
case 7:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_7_VALUE); ini_setString(hFile, "HouseInteriorName", "Medium Mansion"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(2317.77, -1026.76, 1050.21, 1.50, (h + 1000), 9, -1, 10.0);
}
case 8:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_8_VALUE); ini_setString(hFile, "HouseInteriorName", "Rich Mansion"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(2324.41, -1149.54, 1050.71, 1.50, (h + 1000), 12, -1, 10.0);
}
case 9:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_9_VALUE); ini_setString(hFile, "HouseInteriorName", "Huge Mansion"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(140.28, 1365.92, 1083.85, 1.50, (h + 1000), 5, -1, 10.0);
}
case 10:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_10_VALUE); ini_setString(hFile, "HouseInteriorName", "Mad Dogg's Mansion"); ini_closeFile(hFile); }
HouseCPInt[h] = CreateDynamicCP(1260.6603, -785.4005, 1091.9063, 1.50, (h + 1000), 5, -1, 10.0);
}
}
#endif
#if !defined GH_USE_CPS
switch(hinterior)
{
case 1:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_1_VALUE); ini_setString(hFile, "HouseInteriorName", "Shitty Shack"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2260.38, -1135.89, 1050.64, (h + 1000), 10, -1, 15.0);
}
case 2:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_2_VALUE); ini_setString(hFile, "HouseInteriorName", "Motel Room"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2284.24, -1139.42, 1050.89, (h + 1000), 11, -1, 15.0);
}
case 3:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_3_VALUE); ini_setString(hFile, "HouseInteriorName", "Hotel Room 1"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2233.69, -1114.26, 1050.88, (h + 1000), 5, -1, 15.0);
}
case 4:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_4_VALUE); ini_setString(hFile, "HouseInteriorName", "Hotel Room 2"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2216.39, -1077.10, 1050.48, (h + 1000), 1, -1, 15.0);
}
case 5:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_5_VALUE); ini_setString(hFile, "HouseInteriorName", "Gang House"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2496.00, -1693.70, 1014.74, (h + 1000), 3, -1, 15.0);
}
case 6:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_6_VALUE); ini_setString(hFile, "HouseInteriorName", "Normal House"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2365.25, -1134.00, 1050.88, (h + 1000), 8, -1, 15.0);
}
case 0:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_0_VALUE); ini_setString(hFile, "HouseInteriorName", "Default House"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2195.84, -1204.36, 1049.02, (h + 1000), 6, -1, 15.0);
}
case 7:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_7_VALUE); ini_setString(hFile, "HouseInteriorName", "Medium Mansion"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2319.43, -1026.33, 1050.21, (h + 1000), 9, -1, 15.0);
}
case 8:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_8_VALUE); ini_setString(hFile, "HouseInteriorName", "Rich Mansion"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2324.41, -1148.54, 1050.71, (h + 1000), 12, -1, 15.0);
}
case 9:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_9_VALUE); ini_setString(hFile, "HouseInteriorName", "Huge Mansion"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 142.40, 1366.66, 1083.85, (h + 1000), 5, -1, 15.0);
}
case 10:
{
hFile = ini_openFile(file);
if(hFile >= 0) { ini_setInteger(hFile, "HouseInteriorValue", H_INT_10_VALUE); ini_setString(hFile, "HouseInteriorName", "Mad Dogg's Mansion"); ini_closeFile(hFile); }
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 1263.11, -785.26, 1091.9063, (h + 1000), 5, -1, 15.0);
}
}
#endif

// Оптимізація mxINI: Читаємо та оновлюємо глобальний лічильник в окрему змінну hFileCounter
new current_id_house = 0;
new hFileCounter = ini_openFile("/House/House.ini");
if(hFileCounter >= 0)
{
ini_getInteger(hFileCounter, "CurrentID", current_id_house);
current_id_house += 1;
ini_setInteger(hFileCounter, "CurrentID", current_id_house);
ini_setInteger(hFileCounter, "CurrentWorld", current_id_house + 1000);
ini_closeFile(hFileCounter);
}

SetPVarInt(playerid, "JustCreatedHouse", 1);
#if defined GH_DEBUGGING
(DEBUG_OP_CMD1, pNick(playerid), playerid, h, cost, GetTotalHouses());
#endif
}
return 1;
}

dcmd_relhouses(playerid, params[])
{
#pragma unused params
if(IsPlayerAdmin(playerid))
{
new string[256];
new sendername[MAX_PLAYER_NAME];
GetPlayerName(playerid, sendername, sizeof(sendername));
format(string, sizeof(string), " *** Адмiн %s [%d] начав перезагрузку системи будинкiв.", sendername, playerid);
print(string);
SendClientMessageToAll(0xFF0000FF, string);
SetTimerEx("relhoyses1", 1000, 0, "i", playerid);
}
else
{
SendClientMessage(playerid, 0xFF0000FF, " У Вас немає прав на використання цiєї команди !");
}
return 1;
}
forward relhoyses1(playerid);
public relhoyses1(playerid)
{
new file[HOUSEFILE_LENGTH], tmp;
Loop(i, MAX_PLAYERS)
{
if(IsPlayerConnected(i) && !IsPlayerNPC(i))
{
tmp = GetPVarInt(i, "LastHouseCP");
format(file, sizeof(file), FILEPATH, tmp);

// Оптимізація mxINI: заміна ini_exist на fexist
if(!strcmp(GetHouseOwner(tmp), pNick(i), CASE_SENSETIVE) && GetPVarInt(i, "IsInHouse") == 1 && fexist(file))
{
// Оптимізація mxINI: відкриваємо файл, записуємо та закриваємо
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_setInteger(hFile, "QuitInHouse", 1);
ini_closeFile(hFile);
}
}
}
}
UnloadSystemHouse(); // Вигрузка будинкiв
SetTimerEx("relhoyses2", 1000, 0, "i", playerid);
return 1;
}

forward relhoyses2(playerid);
public relhoyses2(playerid)
{
for(new i = 0; i < MAX_PLAYERS; i++)//цикл для всех игроков
{
dlgcont[i] = -600;//не существующий ИД диалога
lockpas[i] = 0;//обнуление массива блокировок диалога ввода пароля
}

// Виправлено: запускаємо наш новий покроковий таймер завантаження будинків без фризів
SetTimerEx("LoadHousesStepByStep", 15, false, "d", 0);

Loop(i, MAX_PLAYERS)
{
if(IsPlayerConnected(i) && !IsPlayerNPC(i))
{
SetPVarInt(i, "HousePrevTime", 0);
}
}
SetTimerEx("relhoyses3", 1000, 0, "i", playerid);
return 1;
}

forward relhoyses3(playerid);
public relhoyses3(playerid)
{
for(new i = 0; i < MAX_PLAYERS; i++)
{
if(IsPlayerConnected(i))
{
TogglePlayerControllable(i, 1);//разморозить всех игроков
}
}
new string[256];
new sendername[MAX_PLAYER_NAME];
GetPlayerName(playerid, sendername, sizeof(sendername));
format(string, sizeof(string), " *** Адмiн %s [%d] перезагрузив систему будинкiв.", sendername, playerid);
print(string);
SendClientMessageToAll(0xFF0000FF, string);
return 1;
}
dcmd_lchouse(playerid, params[])
{
if(IsPlayerAdmin(playerid))
{
new file[HOUSEFILE_LENGTH], h;
if(sscanf(params, "d", h))
{
SendClientMessage(playerid, 0xBFC0C2FF, " Використовуйте: /lchouse [iд будинку]");
SendClientMessage(playerid, 0xFF0000FF, " Увага !!! Команда блокує будинок по його ID !!!");
SendClientMessage(playerid, 0xFF0000FF, " Використовуйте тiльки в КРАЙНЬОМУ випадку !!!");
return 1;
}

format(file, sizeof(file), FILEPATH, h);

// Оптимізація mxINI: заміна ini_exist на рідну швидку fexist
if(!fexist(file)) return SendClientMessage(playerid, 0xFF0000FF, " будинка з таким ID не iснує !");

// Оптимізація mxINI: відкриваємо файл 1 раз для читання та перевірок
new hOwner[MAX_PLAYER_NAME + 1];
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getString(hFile, "HouseOwner", hOwner, sizeof(hOwner));
ini_closeFile(hFile);
}

if(!strcmp(hOwner, INVALID_HOWNER_NAME, CASE_SENSETIVE)) return SendClientMessage(playerid, 0xFF0000FF, " Неможна ! Будинок вiльний !");
if(!strcmp(hOwner, "* Будинок заблокований", CASE_SENSETIVE)) return SendClientMessage(playerid, 0xFF0000FF, " Будинок вже заблокований !");

// Оптимізація mxINI: відкриваємо файл для запису нових даних блокування
new hFileWrite = ini_openFile(file);
if(hFileWrite >= 0)
{
ini_setString(hFileWrite, "HouseOwner", "* Будинок заблокований");
ini_setString(hFileWrite, "HouseName", "* Будинок заблокований");
ini_closeFile(hFileWrite);
}

UpdateHouseText(h);
new string[256];
new sendername[MAX_PLAYER_NAME];
GetPlayerName(playerid, sendername, sizeof(sendername));
format(string, sizeof(string), " *** Адмiн %s [%d] заблокував Будинок ID %d .", sendername, playerid, h);
print(string);
SendClientMessageToAll(0xFF0000FF, string);
}
else
{
SendClientMessage(playerid, 0xFF0000FF, " У Вас немає прав на використання цiєї команди !");
}
return 1;
}


dcmd_removehouse(playerid, params[])
{
new h, file[HOUSEFILE_LENGTH];
if(!IsPlayerAdmin(playerid)) return 0;
if(sscanf(params, "d", h)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_REMOVEHOUSE);
format(file, sizeof(file), FILEPATH, h);

if(!fexist(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
else
{
DestroyHouseEntrance(h, TYPE_OUT);
DestroyHouseEntrance(h, TYPE_INT);
#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);
#endif
DestroyDynamic3DTextLabel(HouseLabel[h]);
SendMSG(playerid, COLOUR_YELLOW, 128, I_H_DESTROYED, h);

// Оптимізація mxINI: видаляємо файл рідною функцією fremove
fremove(file);

#if defined GH_DEBUGGING
(DEBUG_OP_CMD3, pNick(playerid), playerid, h);
#endif
}
return 1;
}

dcmd_removeallhouses(playerid, params[])
{
#pragma unused params
new hcount, file[HOUSEFILE_LENGTH];
if(!IsPlayerAdmin(playerid)) return 0;
else
{
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);
if(fexist(file))
{
DestroyHouseEntrance(h, TYPE_OUT);
DestroyHouseEntrance(h, TYPE_INT);
#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);
#endif
DestroyDynamic3DTextLabel(HouseLabel[h]);

fremove(file); // Видаляємо через fremove
hcount++;
}
}
SendMSG(playerid, COLOUR_YELLOW, 128, I_ALLH_DESTROYED, hcount);
#if defined GH_DEBUGGING
(DEBUG_OP_CMD5, pNick(playerid), playerid, hcount);
#endif
}
return 1;
}

dcmd_changespawn(playerid, params[])
{
new h, file[HOUSEFILE_LENGTH];
if(!IsPlayerAdmin(playerid)) return 0;
if(sscanf(params, "d", h)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CHANGESPAWN);
format(file, sizeof(file), FILEPATH, h);

if(!fexist(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
else
{
GetPlayerPos(playerid, X, Y, Z);
GetPlayerFacingAngle(playerid, Angle);

// Оптимізація mxINI: записуємо нові координати спавну за один прохід
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_setFloat(hFile, "SpawnOutX", X);
ini_setFloat(hFile, "SpawnOutY", Y);
ini_setFloat(hFile, "SpawnOutZ", Z);
ini_setFloat(hFile, "SpawnOutAngle", Angle);
ini_setInteger(hFile, "SpawnWorld", GetPlayerVirtualWorld(playerid));
ini_setInteger(hFile, "SpawnInterior", GetPlayerInterior(playerid));
ini_closeFile(hFile);
}

SendMSG(playerid, COLOUR_YELLOW, 128, I_HSPAWN_CHANGED, h);
#if defined GH_DEBUGGING
(DEBUG_OP_CMD7, pNick(playerid), playerid, h);
#endif
}
return 1;
}
dcmd_gotohouse(playerid, params[])
{
new h, file[HOUSEFILE_LENGTH];
if(!IsPlayerAdmin(playerid)) return 0;
if(sscanf(params, "d", h)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_GOTOHOUSE);
format(file, sizeof(file), FILEPATH, h);

// Оптимізація mxINI: заміна на fexist
if(!fexist(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
else
{
// Оптимізація mxINI: Читаємо координати спавну перед ТП
new Float:sX, Float:sY, Float:sZ;
new sInt, sWorld;
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getFloat(hFile, "SpawnOutX", sX);
ini_getFloat(hFile, "SpawnOutY", sY);
ini_getFloat(hFile, "SpawnOutZ", sZ);
ini_getInteger(hFile, "SpawnInterior", sInt);
ini_getInteger(hFile, "SpawnWorld", sWorld);
ini_closeFile(hFile);
}

SetPlayerPosEx(playerid, sX, sY, sZ, sInt, sWorld);
SendMSG(playerid, COLOUR_YELLOW, 128, I_TELEPORT_MSG, h);
}
return 1;
}

dcmd_sellhouse(playerid, params[])
{
new file[HOUSEFILE_LENGTH], h, file2[HOUSEFILE_LENGTH];
if(!IsPlayerAdmin(playerid)) return 0;
if(sscanf(params, "d", h)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_SELLHOUSE);
format(file, sizeof(file), FILEPATH, h);

if(!fexist(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
if(!strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_H_A_F_SALE);
else
{
SendMSG(playerid, COLOUR_YELLOW, 128, I_H_SOLD, h);

// Оптимізація mxINI: Дізнаємося баланс сейфу будинку перед продажем
new hStorage = 0;
new hFileRead = ini_openFile(file);
if(hFileRead >= 0)
{
ini_getInteger(hFileRead, "HouseStorage", hStorage);
ini_closeFile(hFileRead);
}

if(hStorage >= 1 && IsPlayerConnected(GetHouseOwnerEx(h)))
{
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, (hStorage + ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT)));
}

// Оптимізація mxINI: Обнуляємо дані та ставимо дефолтну ціну будинку
new hFileWrite = ini_openFile(file);
if(hFileWrite >= 0)
{
ini_setInteger(hFileWrite, "HouseValue", ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT));
ini_setString(hFileWrite, "HouseOwner", INVALID_HOWNER_NAME);
ini_setString(hFileWrite, "HousePassword", "INVALID_HOUSE_PASSWORD");
ini_setString(hFileWrite, "HouseName", DEFAULT_HOUSE_NAME);
ini_setInteger(hFileWrite, "HouseStorage", 0);
ini_closeFile(hFileWrite);
}

Loop(h2, MAX_HOUSES)
{
if(IsHouseInRangeOfHouse(h, h2, RANGE_BETWEEN_HOUSES) && h2 != h)
{
format(file2, sizeof(file2), FILEPATH, h2);

// Оптимізація mxINI: знижуємо ціну сусідніх будинків
new hFileLoop = ini_openFile(file2);
if(hFileLoop >= 0)
{
new h2_val = 0;
ini_getInteger(hFileLoop, "HouseValue", h2_val);
ini_setInteger(hFileLoop, "HouseValue", (h2_val - ReturnProcent(GetHouseValue(h2), HOUSE_SELLING_PROCENT2)));
ini_closeFile(hFileLoop);
}
}
}

// Оптимізація mxINI: читаємо координати для виселення гравців, що були всередині
new Float:sX, Float:sY, Float:sZ, Float:sA;
new sInt, sWorld;
new hFileSpawn = ini_openFile(file);
if(hFileSpawn >= 0)
{
ini_getFloat(hFileSpawn, "SpawnOutX", sX);
ini_getFloat(hFileSpawn, "SpawnOutY", sY);
ini_getFloat(hFileSpawn, "SpawnOutZ", sZ);
ini_getFloat(hFileSpawn, "SpawnOutAngle", sA);
ini_getInteger(hFileSpawn, "SpawnInterior", sInt);
ini_getInteger(hFileSpawn, "SpawnWorld", sWorld);
ini_closeFile(hFileSpawn);
}

Loop(i, MAX_PLAYERS)
{
if(GetPVarInt(i, "LastHouseCP") == h && GetPVarInt(i, "IsInHouse") == 1)
{
SetPVarInt(i, "IsInHouse", 0);
SetPlayerPosEx(i, sX, sY, sZ, sInt, sWorld);
SetPlayerFacingAngle(i, sA);
SetPlayerInterior(i, sInt);
SetPlayerVirtualWorld(i, sWorld);
}
}

#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);

// Оптимізація mxINI: читаємо дані для оновлення адмінської іконки мапи
new Float:cpX, Float:cpY, Float:cpZ;
new hFileIcon = ini_openFile(file);
if(hFileIcon >= 0)
{
ini_getFloat(hFileIcon, "CPOutX", cpX);
ini_getFloat(hFileIcon, "CPOutY", cpY);
ini_getFloat(hFileIcon, "CPOutZ", cpZ);
ini_closeFile(hFileIcon);
}
HouseMIcon[h] = CreateDynamicMapIcon(cpX, cpY, cpZ, 31, -1, sWorld, sInt, -1, MICON_VD);
#endif

UpdateHouseText(h);
#if defined GH_DEBUGGING
(DEBUG_OP_CMD8, pNick(playerid), playerid, h);
#endif
}
return 1;
}

dcmd_sellallhouses(playerid, params[])
{
#pragma unused params
new file[HOUSEFILE_LENGTH], hcount;
if(!IsPlayerAdmin(playerid)) return 0;
else
{
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);
if(fexist(file) && strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE))
{
// Оптимізація mxINI: Читаємо баланс сейфу будинку в масовому циклі
new hStorage = 0;
new hFileRead = ini_openFile(file);
if(hFileRead >= 0)
{
ini_getInteger(hFileRead, "HouseStorage", hStorage);
ini_closeFile(hFileRead);
}

if(hStorage >= 1 && IsPlayerConnected(GetHouseOwnerEx(h)))
{
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, (hStorage + ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT)));
}

// Оптимізація mxINI: Обнуляємо дані власника в масовому циклі
new hFileWrite = ini_openFile(file);
if(hFileWrite >= 0)
{
ini_setInteger(hFileWrite, "HouseValue", ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT));
ini_setString(hFileWrite, "HouseOwner", INVALID_HOWNER_NAME);
ini_setString(hFileWrite, "HousePassword", "INVALID_HOUSE_PASSWORD");
ini_setString(hFileWrite, "HouseName", DEFAULT_HOUSE_NAME);
ini_setInteger(hFileWrite, "HouseStorage", 0);
ini_closeFile(hFileWrite);
}

#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);

// Оптимізація mxINI: Читаємо координати та віртуальні світи для іконки
new Float:cpX, Float:cpY, Float:cpZ;
new sInt, sWorld;
new hFileIcon = ini_openFile(file);
if(hFileIcon >= 0)
{
ini_getFloat(hFileIcon, "CPOutX", cpX);
ini_getFloat(hFileIcon, "CPOutY", cpY);
ini_getFloat(hFileIcon, "CPOutZ", cpZ);
ini_getInteger(hFileIcon, "SpawnWorld", sWorld);
ini_getInteger(hFileIcon, "SpawnInterior", sInt);
ini_closeFile(hFileIcon);
}
HouseMIcon[h] = CreateDynamicMapIcon(cpX, cpY, cpZ, 31, -1, sWorld, sInt, -1, MICON_VD);
#endif

UpdateHouseText(h);
hcount++;
}
}
SendMSG(playerid, COLOUR_YELLOW, 128, I_ALLH_SOLD, hcount);
#if defined GH_DEBUGGING
(DEBUG_OP_CMD9, pNick(playerid), playerid, hcount);
#endif
}
return 1;
}

dcmd_changeprice(playerid, params[])
{
new h, file[HOUSEFILE_LENGTH], price;
if(!IsPlayerAdmin(playerid)) return 0;
if(sscanf(params, "dd", h, price)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CHANGEPRICE);
format(file, sizeof(file), FILEPATH, h);

if(!fexist(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
if(price < 500000 || price > 50000000) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HVALUE);
else
{
// Оптимізація mxINI: Зміна ціни будинку
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_setInteger(hFile, "HouseValue", price);
ini_closeFile(hFile);
}

SendMSG(playerid, COLOUR_YELLOW, 128, I_H_PRICE_CHANGED, h, price);
UpdateHouseText(h);
#if defined GH_DEBUGGING
(DEBUG_OP_CMD10, pNick(playerid), playerid, h, price);
#endif
}
return 1;
}

dcmd_changeallprices(playerid, params[])
{
new hcount, file[HOUSEFILE_LENGTH], price;
if(!IsPlayerAdmin(playerid)) return 0;
if(sscanf(params, "d", price)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CHANGEALLPRICE);
if(price < 500000 || price > 50000000) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HVALUE);
else
{
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);
if(fexist(file))
{
// Оптимізація mxINI: масова зміна цін усіх створених будинків
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_setInteger(hFile, "HouseValue", price);
ini_closeFile(hFile);
}

UpdateHouseText(h);
hcount++;
}
}
SendMSG(playerid, COLOUR_YELLOW, 128, I_ALLH_PRICE_CHANGED, price, hcount);
#if defined GH_DEBUGGING
(DEBUG_OP_CMD11, pNick(playerid), playerid, price, hcount);
#endif
}
return 1;
}

dcmd_ghcmds(playerid, params[])
{
#pragma unused params
if(!IsPlayerAdmin(playerid)) return 0;
else
{
return ShowPlayerDialog(playerid, 520, DIALOG_STYLE_MSGBOX, "Команди", "/changeallprices\n/sellallhouses\n/changeprice\n/changespawn\n/sellhouse\n/housemenu\n/gotohouse\n/relhouses\n/lchouse\n/ghcmds", "Закрити", "");
}
}

forward HouseVisiting(playerid);
public HouseVisiting(playerid)
{

SetPVarInt(playerid, "HousePrevTime", 0);//сбрасываем блокировку меню будинку

new string[200], tmpstring[50];
GetPVarString(playerid, "HousePrevName", tmpstring, 50);
format(string, sizeof(string), I_HINT_VISIT_OVER, tmpstring, GetPVarInt(playerid, "HousePrevValue"));
ShowPlayerDialog(playerid, 517, DIALOG_STYLE_MSGBOX, "Iнтер'єр", string, "{00FF00}Купити", "{FF0000}Вiдмiна");
dlgcont[playerid] = 517;
return 1;
}
forward HouseSpawning(playerid);
public HouseSpawning(playerid)
{
    new file[HOUSEFILE_LENGTH];
    Loop(h, MAX_HOUSES)
    {
        if(!strcmp(GetHouseOwner(h), pNick(playerid), CASE_SENSETIVE))
        {
            format(file, sizeof(file), FILEPATH, h);

            new quit_in_house = 0;
            new hFile = ini_openFile(file);
            if(hFile >= 0)
            {
                ini_getInteger(hFile, "QuitInHouse", quit_in_house);
                ini_closeFile(hFile);
            }

            if(quit_in_house == 1)
            {
                SetPVarInt(playerid, "IsInHouse", 1);
                SetPVarInt(playerid, "LastHouseCP", h);
                SetPlayerHouseInterior(playerid, h);

                new hInteriorID = 0;
                new hFileFix = ini_openFile(file);
                if(hFileFix >= 0)
                {
                    ini_getInteger(hFileFix, "HouseInterior", hInteriorID);
                    ini_closeFile(hFileFix);
                }
                CreateCorrectHouseExitCP(h, hInteriorID);

                SendClientMessage(playerid, COLOUR_INFO, I_HMENU);

                new hFileWrite = ini_openFile(file);
                if(hFileWrite >= 0)
                {
                    ini_setInteger(hFileWrite, "QuitInHouse", 0);
                    ini_closeFile(hFileWrite);
                }

                #if defined GH_DEBUGGING
                (DEBUG_OP_SPAWN, pNick(playerid), playerid);
                #endif
            }
        }
    }
    SetPVarInt(playerid, "FirstSpawn", 1);
    return 1;
}


forward InpTxtControl(string[]);
public InpTxtControl(string[])//контроль вводимого текста на посторонние символы
{
new dln, dopper;
dln = strlen(string);
dopper = 1;
for(new i = 0; i < dln; i++)
{
if(string[i] < 32 || string[i] == 37 || string[i] == 126 ||
string[i] == 127 || string[i] == 152 || string[i] == 160) { dopper = 0; }
}
return dopper;
}
stock LoadSystemHouse()
{
Loop(i, MAX_PLAYERS)
{
if(IsPlayerConnected(i) && !IsPlayerNPC(i))
{
SetPVarInt(i, "HousePrevTime", 0);
SetPVarInt(i, "HousePreview", 0);
SetPVarInt(i, "IsHouseVisiting", 0);
SetPVarInt(i, "LastHouseCP", 0);
SetPVarInt(i, "IsInHouse", 0);
SetPVarInt(i, "HousePrevInt", 0);
SetPVarInt(i, "ChangeHouseInt", 0);
SetPVarInt(i, "HouseIntUpgradeMod", 0);
SetPVarInt(i, "JustCreatedHouse", 0);
SetPVarInt(i, "FirstSpawn", 0);
}
}

new hcount = 0;
Loop(h, MAX_HOUSES)
{
// Виправлено: додали розмір [150] для масиву тексту
new file[HOUSEFILE_LENGTH], labeltext[150];
format(file, sizeof(file), FILEPATH, h);

if(fexist(file))
{
new Float:cpX, Float:cpY, Float:cpZ;
new sWorld, sInt, hValue, hInteriorID;
new hName[MAX_HOUSE_NAME];
new hOwner[MAX_PLAYER_NAME + 1];

new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getFloat(hFile, "CPOutX", cpX);
ini_getFloat(hFile, "CPOutY", cpY);
ini_getFloat(hFile, "CPOutZ", cpZ);
ini_getInteger(hFile, "SpawnWorld", sWorld);
ini_getInteger(hFile, "SpawnInterior", sInt);
ini_getInteger(hFile, "HouseValue", hValue);
ini_getInteger(hFile, "HouseInterior", hInteriorID);
ini_getString(hFile, "HouseName", hName, sizeof(hName));
ini_getString(hFile, "HouseOwner", hOwner, sizeof(hOwner));
ini_closeFile(hFile);
}

#if defined GH_USE_CPS
HouseCPOut[h] = CreateDynamicCP(cpX, cpY, cpZ, 1.5, sWorld, sInt, -1, 15.0);
#endif
#if !defined GH_USE_CPS
HousePickupOut[h] = CreateDynamicPickup(PICKUP_MODEL_OUT, PICKUP_TYPE, cpX, cpY, cpZ, sWorld, sInt, -1, 15.0);
#endif

CreateCorrectHouseExitCP(h, hInteriorID);

if(!strcmp(hOwner, INVALID_HOWNER_NAME, CASE_SENSETIVE))
{
format(labeltext, sizeof(labeltext), LABELTEXT1, hName, hValue, h);
HouseLabel[h] = CreateDynamic3DTextLabel(labeltext, COLOUR_GREEN, cpX, cpY, cpZ+0.7, 8, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, sWorld, sInt, -1);
#if defined GH_USE_MAPICONS
HouseMIcon[h] = CreateDynamicMapIcon(cpX, cpY, cpZ, 31, -1, sWorld, sInt, -1, MICON_VD);
#endif
}
else
{
format(labeltext, sizeof(labeltext), LABELTEXT2, hName, hOwner, hValue, h);
HouseLabel[h] = CreateDynamic3DTextLabel(labeltext, COLOUR_GREEN, cpX, cpY, cpZ+0.7, 8, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, sWorld, sInt, -1);
#if defined GH_USE_MAPICONS
HouseMIcon[h] = CreateDynamicMapIcon(cpX, cpY, cpZ, 32, -1, sWorld, sInt, -1, MICON_VD);
#endif
}
hcount++;
}
}
return 1;
}
stock GetOwnedHouses(playerid)
{
new file[HOUSEFILE_LENGTH], tmpcount;
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);
if(fexist(file)) // Оптимізація mxINI: fexist
{
new hOwner[MAX_PLAYER_NAME + 1];
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getString(hFile, "HouseOwner", hOwner, sizeof(hOwner));
ini_closeFile(hFile);
}

if(!strcmp(hOwner, pNick(playerid), CASE_SENSETIVE))
{
tmpcount++;
}
}
}
return tmpcount;
}

stock GetHouseOwnerEx(houseid)
{
new file[HOUSEFILE_LENGTH];
format(file, sizeof(file), FILEPATH, houseid);
if(fexist(file)) // Оптимізація mxINI: fexist
{
Loop(i, MAX_PLAYERS)
{
if(!strcmp(pNick(i), GetHouseOwner(houseid), CASE_SENSETIVE))
{
return i;
}
}
}
return INVALID_PLAYER_ID;
}

stock ReturnPlayerHouseID(playerid, houseslot)
{
new file[HOUSEFILE_LENGTH], tmpcount = 0;
if(houseslot < 1 && houseslot > MAX_HOUSES_OWNED) return -1;
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);
if(fexist(file)) // Оптимізація mxINI: fexist
{
new hOwner[MAX_PLAYER_NAME + 1];
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getString(hFile, "HouseOwner", hOwner, sizeof(hOwner));
ini_closeFile(hFile);
}

if(!strcmp(pNick(playerid), hOwner, CASE_SENSETIVE))
{
tmpcount++;
if(tmpcount == houseslot)
{
return h;
}
}
}
}
return -1;
}

stock UnloadSystemHouse()
{
Loop(h, MAX_HOUSES)
{
DestroyHouseEntrance(h, TYPE_OUT);
DestroyHouseEntrance(h, TYPE_INT);
#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);
#endif
DestroyDynamic3DTextLabel(HouseLabel[h]);
}
return 1;
}

stock GetHouseValue(houseid)
{
new file[HOUSEFILE_LENGTH];
format(file, sizeof(file), FILEPATH, houseid);
if(fexist(file)) // Оптимізація mxINI: fexist
{
new val = 0;
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getInteger(hFile, "HouseValue", val);
ini_closeFile(hFile);
}
return val;
}
else
{
printf("Couldn't Get House Value For House ID %d. File Doesn't Exist...", houseid);
return 0;
}
}

stock GetHouseName(houseid)
{
new file[HOUSEFILE_LENGTH], hname[MAX_HOUSE_NAME];
format(hname, MAX_HOUSE_NAME, "%s", DEFAULT_HOUSE_NAME);
format(file, sizeof(file), FILEPATH, houseid);
if(fexist(file)) // Оптимізація mxINI: fexist
{
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getString(hFile, "HouseName", hname, sizeof(hname));
ini_closeFile(hFile);
}
return hname;
}
return hname;
}

stock GetHouseOwner(houseid)
{
new file[HOUSEFILE_LENGTH], howner[MAX_PLAYER_NAME];
format(howner, MAX_PLAYER_NAME, INVALID_HOWNER_NAME);
format(file, sizeof(file), FILEPATH, houseid);
if(fexist(file)) // Оптимізація mxINI: fexist
{
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getString(hFile, "HouseOwner", howner, sizeof(howner));
ini_closeFile(hFile);
}
return howner;
}
return howner;
}

stock IsHouseInRangeOfHouse(house, house2, Float:range = 250.0)
{
new file[HOUSEFILE_LENGTH], file2[25];
format(file, sizeof(file), FILEPATH, house);
format(file2, sizeof(file2), FILEPATH, house2);
if(fexist(file) && fexist(file2)) // Оптимізація mxINI: fexist
{
new Float:x1, Float:y1, Float:z1;
new Float:x2, Float:y2, Float:z2;

new hFile1 = ini_openFile(file);
if(hFile1 >= 0)
{
ini_getFloat(hFile1, "CPOutX", x1);
ini_getFloat(hFile1, "CPOutY", y1);
ini_getFloat(hFile1, "CPOutZ", z1);
ini_closeFile(hFile1);
}

new hFile2 = ini_openFile(file2);
if(hFile2 >= 0)
{
ini_getFloat(hFile2, "CPOutX", x2);
ini_getFloat(hFile2, "CPOutY", y2);
ini_getFloat(hFile2, "CPOutZ", z2);
ini_closeFile(hFile2);
}

if(PointInRangeOfPoint(range, x1, y1, z1, x2, y2, z2))
{
return 1;
}
}
return 0;
}

stock CreateCorrectHouseExitCP(houseid, hInteriorID)
{
new file[HOUSEFILE_LENGTH];
format(file, sizeof(file), FILEPATH, houseid);

#if defined GH_USE_CPS
switch(hInteriorID)
{
case 0: HouseCPInt[houseid] = CreateDynamicCP(2196.84, -1204.36, 1049.02, 1.5, (houseid + 1000), 6, -1, 10.0); // Default House
case 1: HouseCPInt[houseid] = CreateDynamicCP(2259.38, -1135.89, 1050.64, 1.50, (houseid + 1000), 10, -1, 10.0); // Shitty Shack House Interior
case 2: HouseCPInt[houseid] = CreateDynamicCP(2282.99, -1140.28, 1050.89, 1.50, (houseid + 1000), 11, -1, 10.0); // Motel House Interior
case 3: HouseCPInt[houseid] = CreateDynamicCP(2233.69, -1115.26, 1050.88, 1.50, (houseid + 1000), 5, -1, 10.0); // Hotel House Interior
case 4: HouseCPInt[houseid] = CreateDynamicCP(2218.39, -1076.21, 1050.48, 1.50, (houseid + 1000), 1, -1, 10.0); // Hotel 2 House Interior
case 5: HouseCPInt[houseid] = CreateDynamicCP(2496.00, -1692.08, 1014.74, 1.50, (houseid + 1000), 3, -1, 10.0); // CJ's House Interior
case 6: HouseCPInt[houseid] = CreateDynamicCP(2365.25, -1135.58, 1050.88, 1.50, (houseid + 1000), 8, -1, 10.0); // Verdant Bluff's Safehouse House Interior
case 7: HouseCPInt[houseid] = CreateDynamicCP(2317.77, -1026.76, 1050.21, 1.50, (houseid + 1000), 9, -1, 10.0); // Medium Mansion House Interior
case 8: HouseCPInt[houseid] = CreateDynamicCP(2324.41, -1149.54, 1050.71, 1.50, (houseid + 1000), 12, -1, 10.0); // Rich Mansion House Interior
case 9: HouseCPInt[houseid] = CreateDynamicCP(140.28, 1365.92, 1083.85, 1.50, (houseid + 1000), 5, -1, 10.0); // Huge Mansion House Interior
case 10: HouseCPInt[houseid] = CreateDynamicCP(1260.6603, -785.4005, 1091.9063, 1.50, (houseid + 1000), 5, -1, 10.0); // Madd Dogg's Mansion House Interior
}
#endif
#if !defined GH_USE_CPS
switch(hInteriorID)
{
case 0: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2195.84, -1204.36, 1049.02, (houseid + 1000), 6, -1, 15.0); // Default House
case 1: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2260.38, -1135.89, 1050.64, (houseid + 1000), 10, -1, 15.0); // Shitty Shack House Interior
case 2: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2284.24, -1139.42, 1050.89, (houseid + 1000), 11, -1, 15.0); // Motel House Interior
case 3: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2233.69, -1114.26, 1050.88, (houseid + 1000), 5, -1, 15.0); // Hotel House Interior
case 4: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2216.39, -1077.10, 1050.48, (houseid + 1000), 1, -1, 15.0); // Hotel 2 House Interior
case 5: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2496.00, -1693.70, 1014.74, (houseid + 1000), 3, -1, 15.0); // CJ's House Interior
case 6: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2365.25, -1134.00, 1050.88, (houseid + 1000), 8, -1, 15.0); // Verdant Bluff's Safehouse House Interior
case 7: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2319.43, -1026.33, 1050.21, (houseid + 1000), 9, -1, 15.0); // Medium Mansion House Interior
case 8: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2324.41, -1148.54, 1050.71, (houseid + 1000), 12, -1, 15.0); // Rich Mansion House Interior
case 9: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 142.40, 1366.66, 1083.85, (houseid + 1000), 5, -1, 15.0); // Huge Mansion House Interior
case 10: HousePickupInt[houseid] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 1263.11, -785.26, 1091.9063, (houseid + 1000), 5, -1, 15.0); // Madd Dogg's Mansion House Interior
}
#endif
return 1;
}

stock SetPlayerHouseInterior(playerid, house)
{
new file[HOUSEFILE_LENGTH];
format(file, sizeof(file), FILEPATH, house);

// Оптимізація mxINI: зчитуємо ID інтер'єру 1 раз на початку функції
new hInteriorID = 0;
new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getInteger(hFile, "HouseInterior", hInteriorID);
ini_closeFile(hFile);
}

switch(hInteriorID)
{
case 0:
{
SetPlayerPosEx(playerid, 2193.9001, -1202.4185, 1049.0234, 6, (house + 1000));
SetPlayerFacingAngle(playerid, 91.9386); // Default House Interior - Spawnpoint
}
case 1:
{
SetPlayerPosEx(playerid, 2262.5627, -1136.1664, 1050.6328, 10, (house + 1000));
SetPlayerFacingAngle(playerid, 267.5372); // Shitty Shack House Interior - Spawnpoint
}
case 2:
{
SetPlayerPosEx(playerid, 2283.0632, -1136.9760, 1050.8984, 11, (house + 1000));
SetPlayerFacingAngle(playerid, 358.7963); // Motel Room House Interior - Spawnpoint
}
case 3:
{
SetPlayerPosEx(playerid, 2233.6057, -1111.7039, 1050.8828, 5, (house + 1000));
SetPlayerFacingAngle(playerid, 2.9124); // Hotel House Interior - Spawnpoint
}
case 4:
{
SetPlayerPosEx(playerid, 2214.8909, -1076.0967, 1050.4844, 1, (house + 1000));
SetPlayerFacingAngle(playerid, 88.8910); // Hotel 2 House Interior - Spawnpoint
}
case 5:
{
SetPlayerPosEx(playerid, 2495.8035, -1695.0997, 1014.7422, 3, (house + 1000));
SetPlayerFacingAngle(playerid, 181.9661); // CJ's House Interior - Spawnpoint
}
case 6:
{
SetPlayerPosEx(playerid, 2365.2883, -1132.5228, 1050.8750, 8, (house + 1000));
SetPlayerFacingAngle(playerid, 358.0393); // Verdant Bluff's Safehouse House Interior - Spawnpoint
}
case 7:
{
SetPlayerPosEx(playerid, 2320.0730, -1023.9533, 1050.2109, 9, (house + 1000));
SetPlayerFacingAngle(playerid, 358.4915); // Medium Mansion House Interior - Spawnpoint
}
case 8:
{
SetPlayerPosEx(playerid, 2324.4490, -1145.2841, 1050.7101, 12, (house + 1000));
SetPlayerFacingAngle(playerid, 357.5873); // Richouse Mansion House Interior - Spawnpoint
}
case 9:
{
SetPlayerPosEx(playerid, 140.1788, 1369.1936, 1083.8641, 5, (house + 1000));
SetPlayerFacingAngle(playerid, 359.2263); // Huge Mansion House Interior - Spawnpoint
}
case 10:
{
SetPlayerPosEx(playerid, 1264.7765, -781.2485, 1091.9063, 5, (house + 1000));
SetPlayerFacingAngle(playerid, 270.6992); // Madd Dogg's Mansion House Interior - Spawnpoint
}
}
}

stock pNick(playerid)
{
new GHNick[MAX_PLAYER_NAME];
new aaa[64];//доработка для использования Русских ников
GetPlayerName(playerid, aaa, 64);//доработка для использования Русских ников
format(GHNick, sizeof(GHNick), "%s", aaa);//доработка для использования Русских ников
return GHNick;
}

stock PointInRangeOfPoint(Float:range, Float:x2, Float:y2, Float:z2, Float:X2, Float:Y2, Float:Z2)
{
X2 -= x2;
Y2 -= y2;
Z2 -= z2;
return ((X2 * X2) + (Y2 * Y2) + (Z2 * Z2)) < (range * range);
}
stock ReturnProcent(Float:amount, Float:procent)
{
return floatround((amount / 100 * procent));
}
stock SetPlayerPosEx(playerid, Float:posX, Float:posY, Float:posZ, Interior = 0, World = 0)
{
SetPlayerVirtualWorld(playerid, World);
SetPlayerInterior(playerid, Interior);
SetPlayerPos(playerid, posX, posY, posZ);
SetCameraBehindPlayer(playerid);
return 1;
}
stock GetFreeHouseID()
{
new file[HOUSEFILE_LENGTH];
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);

// Оптимізація mxINI: заміна на швидку fexist
if(!fexist(file))
{
return h;
}
}
return -1;
}

stock GetTotalHouses()
{
new tmpcount, file[HOUSEFILE_LENGTH];
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);

// Оптимізація mxINI: заміна на fexist
if(fexist(file))
{
tmpcount++;
}
}
return tmpcount;
}

stock UpdateHouseText(houseid)
{
new labeltext[150], file[HOUSEFILE_LENGTH];
format(file, sizeof(file), FILEPATH, houseid);

// Оптимізація mxINI: заміна на fexist
if(fexist(file))
{
// Замість dini_Get використовуємо вже готову та оптимізовану функцію GetHouseOwner
if(!strcmp(GetHouseOwner(houseid), INVALID_HOWNER_NAME, CASE_SENSETIVE))
{
format(labeltext, sizeof(labeltext), LABELTEXT1, GetHouseName(houseid), GetHouseValue(houseid), houseid);
}
else
{
format(labeltext, sizeof(labeltext), LABELTEXT2, GetHouseName(houseid), GetHouseOwner(houseid), GetHouseValue(houseid), houseid);
}
UpdateDynamic3DTextLabelText(HouseLabel[houseid], COLOUR_GREEN, labeltext);
}
}

stock FM(amount, delimiter[2]=",")
{
new txt[20];
format(txt, 20, "$%d", amount);
new l = strlen(txt);
if (amount < 0) // -
{
if (l >= 5) strins(txt, delimiter, l-3);
if (l >= 8) strins(txt, delimiter, l-6);
if (l >= 11) strins(txt, delimiter, l-9);
}
else
{
if (l >= 4) strins(txt, delimiter, l-3);
if (l >= 7) strins(txt, delimiter, l-6);
if (l >= 10) strins(txt, delimiter, l-9);
}
return txt;
}

stock AddS(amount)
{
new returnstring[2];
format(returnstring, 2, "");
if(amount != 1 && amount != -1)
{
format(returnstring, 2, "s");
}
return returnstring;
}
stock DestroyHouseEntrance(houseid, type)
{
#if defined GH_USE_CPS
if(type == TYPE_OUT) { DestroyDynamicCP(HouseCPOut[houseid]); }
if(type == TYPE_INT) { DestroyDynamicCP(HouseCPInt[houseid]); }
#endif
#if !defined GH_USE_CPS
if(type == TYPE_OUT) { DestroyDynamicPickup(HousePickupOut[houseid]); }
if(type == TYPE_INT) { DestroyDynamicPickup(HousePickupInt[houseid]); }
#endif
return 1;
}
stock IsVehicleOccupied(vehicleid)
{
Loop(i, MAX_PLAYERS)
{
if(IsPlayerInVehicle(i, vehicleid))
{
return 1;
}
}
return 0;
}
forward HouseOneSec();
public HouseOneSec()
{
new locper;
for(new i = 0; i < MAX_PLAYERS; i++)//цикл для всех игроков
{
if(IsPlayerConnected(i))//дальнейшее Виполняем если игрок в коннекте
{
locper = GetPlayerVirtualWorld(i);
if(GetPVarInt(i, "IsInHouse") == 1 && (locper < 1000 || locper > MAX_VW_HOUSE))
{
SetPVarInt(i, "IsInHouse", 0);
}

}
}
return 1;
}
forward LoadHousesStepByStep(start_id);
public LoadHousesStepByStep(start_id)
{
new end_id = start_id + 15;
if(end_id > MAX_HOUSES) end_id = MAX_HOUSES;

for(new h = start_id; h < end_id; h++)
{
new file[HOUSEFILE_LENGTH], labeltext[150];
format(file, sizeof(file), FILEPATH, h);

if(fexist(file))
{
new Float:cpX, Float:cpY, Float:cpZ;
new sWorld, sInt, hValue, hInteriorID;
new hName[MAX_HOUSE_NAME];
new hOwner[MAX_PLAYER_NAME + 1];

new hFile = ini_openFile(file);
if(hFile >= 0)
{
ini_getFloat(hFile, "CPOutX", cpX);
ini_getFloat(hFile, "CPOutY", cpY);
ini_getFloat(hFile, "CPOutZ", cpZ);
ini_getInteger(hFile, "SpawnWorld", sWorld);
ini_getInteger(hFile, "SpawnInterior", sInt);
ini_getInteger(hFile, "HouseValue", hValue);
ini_getInteger(hFile, "HouseInterior", hInteriorID);
ini_getString(hFile, "HouseName", hName, sizeof(hName));
ini_getString(hFile, "HouseOwner", hOwner, sizeof(hOwner));
ini_closeFile(hFile);
}

#if defined GH_USE_CPS
HouseCPOut[h] = CreateDynamicCP(cpX, cpY, cpZ, 1.5, sWorld, sInt, -1, 15.0);
#endif
#if !defined GH_USE_CPS
HousePickupOut[h] = CreateDynamicPickup(PICKUP_MODEL_OUT, PICKUP_TYPE, cpX, cpY, cpZ, sWorld, sInt, -1, 15.0);
#endif

CreateCorrectHouseExitCP(h, hInteriorID);

if(!strcmp(hOwner, INVALID_HOWNER_NAME, CASE_SENSETIVE))
{
format(labeltext, sizeof(labeltext), LABELTEXT1, hName, hValue, h);
HouseLabel[h] = CreateDynamic3DTextLabel(labeltext, COLOUR_GREEN, cpX, cpY, cpZ+0.7, 8, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, sWorld, sInt, -1);
#if defined GH_USE_MAPICONS
HouseMIcon[h] = CreateDynamicMapIcon(cpX, cpY, cpZ, 31, -1, sWorld, sInt, -1, MICON_VD);
#endif
}
else
{
format(labeltext, sizeof(labeltext), LABELTEXT2, hName, hOwner, hValue, h);
HouseLabel[h] = CreateDynamic3DTextLabel(labeltext, COLOUR_GREEN, cpX, cpY, cpZ+0.7, 8, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, sWorld, sInt, -1);
#if defined GH_USE_MAPICONS
HouseMIcon[h] = CreateDynamicMapIcon(cpX, cpY, cpZ, 32, -1, sWorld, sInt, -1, MICON_VD);
#endif
}
}
}

if(end_id < MAX_HOUSES)
{
SetTimerEx("LoadHousesStepByStep", 15, false, "d", end_id);
}
else
{
print("[SystemHouse] Усi будинки успішно завантаженi покроково без авто та фризiв!");
}
return 1;
}

public OnPlayerUpdate(playerid)
{
if(IsPlayerOnHousePickup[playerid])
{
// Якщо гравець вiдiйшов вiд точки запису бiльше нiж на 2.5 метри
if(!IsPlayerInRangeOfPoint(playerid, 2.5, LastPickupX[playerid], LastPickupY[playerid], LastPickupZ[playerid]))
{
IsPlayerOnHousePickup[playerid] = false;
LastHousePickupID[playerid] = -1;
}
}
return 1;
}

