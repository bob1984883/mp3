#include <a_samp>
#include <streamer> //
#include <dini> //
#include <dudb> //
#include <sscanf> //
#include <UKR>
#include <mxINI>
#pragma unused strtok //
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
new FALSE = false, CMDSString[1000];
#define ShowInfoBox(%0,%1,%2,%3) do{format(CMDSString, 1000, %2, %3); ShowPlayerDialog(%0, 520, DIALOG_STYLE_MSGBOX, %1, CMDSString, "Close", "");}while(FALSE)
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
#define HSPAWN_TIMER_RATE 5000 // После, как долго будет таймер Визова появляются в будинку функции? (в мс)
#define MICON_VD 50.0 // Значок карты видимом диапазоне (drawdistance).
#define DEFAULT_H_INTERIOR 0 // DEFAULT домашнего iнтерєра при создании будинку
#define DEFAULT_H_INTERIOR_PRICE 3000000 // По умолчанию домашнего iнтерєра цiна при создании будинку
#define GH_USE_WEAPONSTORAGE // Если определено владельца будинку может хранить свое оружие в будинку хранения.
#define GH_SAVE_ADMINWEPS // Если определено дом владелец может сохранить оружие, как пулемет, гранаты, РПГ и т.д..
#define GH_DEBUGGING // Если определена це позволит отладки печатает в консоли сервера.
#define HCAR_COLOUR1 2 // перВий цвет housecar
#define HCAR_COLOUR2 4 // Второй цвет housecar
#define HCAR_RESPAWN 30 // респаун задержки дом автомобиля (в секундах)
#define HCAR_RANGE 10.0 // Диапазон для проверки близлежащих транспортных средств при сохранении будинку автомобиля.
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
#define DEFAULT_HOUSE_NAME "{00FFFF}вiльний" // iмя по умолчанию, когда дом создан /sold
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
#if defined GH_HOUSECARS
new HouseCar[MAX_HOUSES];
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
#define E_HCAR_NOT_IN_VEH "Ви повиннi бути в автомобiлi. Добавити автомобiль біля будинку."
#define E_INVALID_HID "Невірний будинок ID. цей будинок ID не існує."
#define E_NO_HCAR "цей будинок ID не має автомобіля біля будинку. Не вдаеться видалити."
#define E_H_A_F_SALE "Цей будинок вже на продажі. Ви не можете продати будинок."
#define HMENU_ENTER_PASS "назва будинку: %s\nВласник будинку: %s\nБудинок придбаний за: %d $\nБудинок ID: %d\n\nЩоб увійти в будинок, введіть пароль:"
#define HMENU_BUY_HOUSE "%s, Ви хочете придбати цей Будинок за %d $ ?"
#define HMENU_BUY_HINTERIOR "Ви хочете придбати інтер'єр %s для будинку за %d $ ?"
#define HMENU_SELL_HOUSE "%s, Ви впевнені, що хочете продати свій будинок %s за %d $ ?"
#define I_SELL_HOUSE1 "Ви успішно продали свій будинок за %d $.\nОплата: %d $.\nВаші %d $ , які були на зберіганні, були передані Вам."
#define I_SELL_HOUSE2 "Ви успішно продали свій будинок \"%s\" за %d $.\nОплата: %d $."
#define I_BUY_HOUSE "Ви успішно купили цей будинок за %d $ !"
#define I_HPASSWORD_CHANGED "Ви успішно створили пароль для будинку \"%s\"!"
#define I_HNAME_CHANGED "Ви успішно створили Імя для будинку \"%s\"!"
#define E_ALREADY_HAVE_HINTERIOR "У Вас вже є цей інтер'єр."
#define I_VISITING_HOUSEINT "Ви оглядаєте інтер'єр %s.\nЦей інтер'єр коштує %d $.\nЧас огляду закінчиться через %d Сек."
#define E_CANT_AFFORD_HINT "Ви не можете дозволити собі придбати інтер'єр %s.\nВартість інтер'єру: %d $.\nУ Вас є: %d $.\nВам не вистачає: %d $."
#define I_HINT_BOUGHT "Ви купили інтер'єр %s за %d $."
#define I_HINT_DEPOSIT1 "У Вас на зберіганні вже є %d $.\n\nВведіть суму, яку Ви хочете покласти:"
#define I_HINT_WITHDRAW1 "У Вас на зберіганні є %d $.\n\nВведіть суму, яку Ви хочете зняти:"
#define I_HINT_DEPOSIT2 "Ви успішно поклали на зберігання %d $.\nПоточний баланс: %d $."
#define I_HINT_WITHDRAW2 "Ви успішно зняли  з зберігання %d $.\nПоточний баланс: %d $."
#define I_HINT_CHECKBALANCE "У Вас на зберіганні лежить %d $."
#define E_HINT_WAIT_BEFORE_VISITING "Будьласка, зачекайте до огляду наступного інтер'єру."
#define I_HS_WEAPONS1 "Успішно збережено %d одиниці зброї у Вашому будинку."
#define I_HS_WEAPONS2 "Ви успішно зняли з зберігання %d одиниць зброї в Вашому будинку."
#define I_WRONG_HPASS1 "Ви не увійшли в будинок %s з використанням пароля \"%s\"."
#define I_WRONG_HPASS2 "Будинок інформація: %s [%d] спробував увійти до будинку з використанням пароля \"%s\"."
#define I_CORRECT_HPASS1 "Ви успішно увійшли в будинок %s використовуючи пароль \"%s\"!"
#define I_CORRECT_HPASS2 "Будинок інформація: %s [%d] успішно увійшов у Ваш будинок, використовуючи пароль \"%s\"!"
#define E_TOO_MANY_HOUSES "Вибачтете, але будинок з максимальним ID %d вже створений.\nВидаліть один з існуючих або збільшіть максимум будинків."
#define E_INVALID_HVALUE "Неправильна вартість будинку. Вартість повинна бути від 500,000 $ і до 50,000,000 $."
#define I_H_CREATED "Будинок ID %d Створений..."
#define I_HCAR_EXIST_ALREADY "Автомобіль біля будинку ID %d вже є. Заміна поточного."
#define I_HCAR_CREATED "Автомобіль біля будинку ID %d створений..."
#define I_H_DESTROYED "Будинок ID %d видалений..."
#define I_HCAR_REMOVED "Автомобіль біля будинку ID %d Видалений..."
#define I_ALLH_DESTROYED "Всі будинки видалені. (і того %d)"
#define I_ALLHCAR_REMOVED "Всі автомобілі біля будинків видалені. (%d у результаті)"
#define I_HSPAWN_CHANGED "Ви змінили позицію спавна і кут для будинку ID %d."
#define I_TELEPORT_MSG "Ви телепортувались до будинку ID %d."
#define I_H_SOLD "Ви продали будинок ID %d..."
#define I_ALLH_SOLD "Всі будинки на сервері були продані. (і того %d)"
#define I_H_PRICE_CHANGED "Вартість будинку ID %d була змінена на %d $."
#define I_ALLH_PRICE_CHANGED "Ви змінили вартість всіх будинків на сервері на %d $. (і того %d)"
#define I_HINT_VISIT_OVER "Час огляду закінчився.\nВи хочете придбати інтер'єр %s за %d $ ?"
#define E_INVALID_HCAR_MODEL "Неправильний ID моделі автомобіля. (ID моделі повинні бути від 400 і до 611)"
#define I_HCAR_CHANGED "ID моделі автомобіля біля будинку ID %d був змінений на %d."
#define E_CMD_USAGE_CREATEHOUSE "Використання: /createhouse [вартість] [додатково: інтер'єр будинку (від 1[дешевий] до 10)[дорогий]]"
#define E_CMD_USAGE_ADDHCAR "Використання: /addhcar [ID будинку]"
#define E_CMD_USAGE_REMOVEHOUSE "Використання: /removehouse [ID будинку]"
#define E_CMD_USAGE_REMOVEHCAR "Використання: /removehcar [ID будинку]"
#define E_CMD_USAGE_CHANGEHCAR "Використання: /changehcar [ID будинку] [ID моделі: 400-611]"
#define E_CMD_USAGE_CHANGESPAWN "Використання: /changespawn [ID будинку]"
#define E_CMD_USAGE_GOTOHOUSE "Використання: /gotohouse [ID будинку]"
#define E_CMD_USAGE_SELLHOUSE "Використання: /sellhouse [ID будинку]"
#define E_CMD_USAGE_CHANGEPRICE "Використання: /changeprice [ID будинку] [вартість]"
#define E_CMD_USAGE_CHANGEALLPRICE "Використання: /changeallprices [вартість]"
#if defined GH_DEBUGGING
#define DEBUG_OP_DISCONNECT "[House] %s [%d] залишився в своєму будинку (disconnect)"
#define DEBUG_OP_ED_CP1 "[House] %s [%d] увійшов в будинок ID %d."
#define DEBUG_OP_ED_CP2 "[House] %s [%d] вийшов з будинку ID %d."
#define DEBUG_OP_PUD_PICKUP1 "[House] %s [%d] увійшов в Будинок ID %d."
#define DEBUG_OP_PUD_PICKUP2 "[House] %s [%d] вийшов з будинку ID %d."
#define DEBUG_ODR1 "[House] %s [%d] купив Будинок ID %d за %d $."
#define DEBUG_ODR2 "[House] %s [%d] змінив назву будинку ID %d на %s."
#define DEBUG_ODR3 "[House] %s [%d] купив інтер'єр %s за %d $ для будинку ID %d."
#define DEBUG_ODR4 "[House] %s [%d] оглядає інтер'єр %s (Будинок ID %d)"
#define DEBUG_ODR5 "[House] для будинку ID %d встановлений інтер'єр %d."
#define DEBUG_ODR6 "[House] %s [%d] перевірив суму грошей в будинку ID %d (сума: %d $)"
#define DEBUG_ODR7 "[House] %s [%d] поклав на зберігання %d $ в будинку ID %d."
#define DEBUG_ODR8 "[House] %s [%d] зняв з зберігання %d $ в будинку ID %d."
#define DEBUG_ODR10 "[House] %s [%d] поклав на зберігання %d одиниць зброї в будинку ID %d."
#define DEBUG_ODR11 "[House] %s [%d] зняв з зберігання %d одиниць зброї в будинку ID %d."
#define DEBUG_ODR12 "[House] %s [%d] успішно увійшов в будинок ID %d з використанням пароля."
#define DEBUG_ODR13 "[House] %s [%d] продав свій Будинок за %d $ (грошей в будинку: %d $ | Будинок ID %d)"
#define DEBUG_ODR14 "[House] %s [%d] змінив пароль в будинку ID %d."
#define DEBUG_OP_CMD1 "[House] %s [%d] створив будинок (Будинок ID %d | вартість: %d $ | всього будинків: %d)"
#define DEBUG_OP_CMD2 "[House] %s [%d] створив автомобіль біля будинку ID %d."
#define DEBUG_OP_CMD3 "[House] %s [%d] видалив будинок ID %d."
#define DEBUG_OP_CMD4 "[House] %s [%d] видалив автомобіль біля будинку ID %d."
#define DEBUG_OP_CMD5 "[House] %s [%d] видалив всі будинки (%d у результаті)"
#define DEBUG_OP_CMD6 "[House] %s [%d] видалив всі автомобілі біля будинків (%d у результаті)"
#define DEBUG_OP_CMD7 "[House] %s [%d] змінив позицію спавна і кут для будинку ID %d."
#define DEBUG_OP_CMD8 "[House] %s [%d] продав будинок ID %d."
#define DEBUG_OP_CMD9 "[House] %s [%d] продав всі будинки (%d у результаті)"
#define DEBUG_OP_CMD10 "[House] %s [%d] змінив вартість будинку ID %d на %d $."
#define DEBUG_OP_CMD11 "[House] %s [%d] змінив вартість всіх будинків на %d $ (%d у результаті)"
#define DEBUG_OP_CMD12 "[House] %s [%d] змінив ID моделі автомобіля біля будинку ID %d на %d."
#define DEBUG_OP_SPAWN "[House] %s [%d] Заспавнився в своїм будинку."
#endif
new lockpas[MAX_PLAYERS];//массив блокировок диалога ввода пароля
new dlgcont[MAX_PLAYERS];//контроль ИД диалога
new timcontrol;//контрольный таймер нахождения игрока в будинку
#define MAX_VW_HOUSE (999 + MAX_HOUSES)//максимальный виртуальный мир системы будинків
public OnFilterScriptInit()
{
timcontrol = SetTimer("HouseOneSec", 1003, 1);//контрольный таймер нахождения игрока в будинку
for(new i = 0; i < MAX_PLAYERS; i++)//цикл для всех игроков
{
dlgcont[i] = -600;//не существующий ИД диалога
lockpas[i] = 0;//обнуление массива блокировок диалога ввода пароля
}
LoadSystemHouse(); // Загрузка фс будинку
Loop(i, MAX_PLAYERS)
{
if(IsPlayerConnected(i) && !IsPlayerNPC(i))
{
SetPVarInt(i, "HousePrevTime", 0);
}
}
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
if(!strcmp(GetHouseOwner(tmp), pNick(i), CASE_SENSETIVE) && GetPVarInt(i, "IsInHouse") == 1 && dini_Exists(file))
{
dini_IntSet(file, "QuitInHouse", 1);
#if defined GH_HOUSECARS
SaveHouseCar(tmp);
#endif
}
}
}
UnloadSystemHouse(); // Вигрузка будинків (также разгружает дом автомобили)
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
{//если игрок осматривает інтер'єр, то вернуть старый інтер'єр
SetPVarInt(playerid, "HousePreview", 0);
KillTimer(GetPVarInt(playerid, "HousePrevTimer"));
SetPVarInt(playerid, "IsHouseVisiting", 0);
SetPVarInt(playerid, "HousePrevTime", 0);
new file555[HOUSEFILE_LENGTH], h = GetPVarInt(playerid, "LastHouseCP");
format(file555, sizeof(file555), FILEPATH, h);
dini_IntSet(file555, "HouseInterior", GetPVarInt(playerid, "OldHouseInt"));
#if defined GH_DEBUGGING
(DEBUG_ODR5, h, GetPVarInt(playerid, "OldHouseInt"));
#endif
DestroyHouseEntrance(h, TYPE_INT);
CreateCorrectHouseExitCP(h);
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
if(!strcmp(GetHouseOwner(GetPVarInt(playerid, "LastHouseCP")), pNick(playerid), CASE_SENSETIVE) && GetPVarInt(playerid, "IsInHouse") == 1 && dini_Exists(file))
{
dini_IntSet(file, "QuitInHouse", 1);
#if defined GH_HOUSECARS
SaveHouseCar(GetPVarInt(playerid, "LastHouseCP"));
UnloadHouseCar(GetPVarInt(playerid, "LastHouseCP"));
#endif
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
dcmd(removeallhcars, 14, cmdtext);
dcmd(sellallhouses, 13, cmdtext);
dcmd(createhouse, 11, cmdtext);
dcmd(relhouses, 9, cmdtext);//перезагрузка системы будинків
dcmd(lchouse, 7, cmdtext);//блокировка будинку по его ИД
dcmd(removehouse, 11, cmdtext);
dcmd(changeprice, 11, cmdtext);
dcmd(changespawn, 11, cmdtext);
dcmd(removehcar, 10, cmdtext);
dcmd(changehcar, 10, cmdtext);
dcmd(sellhouse, 9, cmdtext);
dcmd(housemenu, 9, cmdtext);
dcmd(gotohouse, 9, cmdtext);
dcmd(addhcar, 7, cmdtext);
dcmd(ghcmds, 6, cmdtext);
return 0;
}
#if defined GH_USE_CPS
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
{
new file[HOUSEFILE_LENGTH], string[256]; // Не жалуются на огромные размеры, просто измените его, если вам нужно.
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
if(!strcmp(dini_Get(file, "HousePassword"), "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE))
{
ShowInfoBox(playerid, INFORMATION_HEADER, LABELTEXT2, GetHouseName(h), GetHouseOwner(h), GetHouseValue(h), h);
}
if(strcmp(dini_Get(file, "HousePassword"), "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE))
{
format(string,sizeof(string), HMENU_ENTER_PASS, GetHouseName(h), GetHouseOwner(h), GetHouseValue(h), h);
ShowPlayerDialog(playerid, 521, DIALOG_STYLE_INPUT, "{00FF00}Інформація про будинок", string, "{00FF00}Ok", "{FF0000}Відміна");
dlgcont[playerid] = 521;
}
}
if(!strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE) && dini_Int(file, "HouseValue") > 0 && GetPVarInt(playerid, "JustCreatedHouse") == 0)
{
format(string, sizeof(string), HMENU_BUY_HOUSE, pNick(playerid), GetHouseValue(h));
ShowPlayerDialog(playerid, 504, DIALOG_STYLE_MSGBOX, "{00FF00}Купівля будинку", string, "{00FF00}Купити", "{FF0000}Відміна");
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
ShowPlayerDialog(playerid, 517, DIALOG_STYLE_MSGBOX, "{00FF00}Iнтер'єр", string, "{00FF00}купити", "{FF0000}Відміна");
dlgcont[playerid] = 517;
}
#endif
if(GetPVarInt(playerid, "HousePreview") == 0)
{
SetPVarInt(playerid, "IsInHouse", 0);
SetPlayerPosEx(playerid, dini_Float(file, "SpawnOutX"), dini_Float(file, "SpawnOutY"), dini_Float(file, "SpawnOutZ"), dini_Int(file, "SpawnInterior"), dini_Int(file, "SpawnWorld"));
SetPlayerFacingAngle(playerid, dini_Float(file, "SpawnOutAngle"));
SetPlayerInterior(playerid, dini_Int(file, "SpawnInterior"));
SetPlayerVirtualWorld(playerid, dini_Int(file, "SpawnWorld"));
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
if(GetPVarInt(playerid, "HousePrevTime") != 0) return 1;//запрет активации пикапа
if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
{
new file[HOUSEFILE_LENGTH], string[256]; // Не жалуются на огромные размеры, просто измените его, если вам нужно.
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);
if(pickupid == HousePickupOut[h])
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
(DEBUG_OP_PUD_PICKUP1, pNick(playerid), playerid, h);
#endif
}
if(strcmp(GetHouseOwner(h), pNick(playerid), CASE_SENSETIVE) && strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE))
{
if(!strcmp(dini_Get(file, "HousePassword"), "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE))
{
ShowInfoBox(playerid, INFORMATION_HEADER, LABELTEXT2, GetHouseName(h), GetHouseOwner(h), GetHouseValue(h), h);
}
if(strcmp(dini_Get(file, "HousePassword"), "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE))
{
if(lockpas[playerid] == 1) return 1;//если диалог ввода пароля заблокований, то завершить public
lockpas[playerid] = 1;//заблокировать диалог ввода пароля
format(string,sizeof(string), HMENU_ENTER_PASS, GetHouseName(h), GetHouseOwner(h), GetHouseValue(h), h);
ShowPlayerDialog(playerid, 521, DIALOG_STYLE_INPUT, "Інформація про будинок", string, "{00FF00}OK", "{FF0000}Відміна");
dlgcont[playerid] = 521;
}
}
if(!strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE) && dini_Int(file, "HouseValue") > 0)
{
format(string, sizeof(string), HMENU_BUY_HOUSE, pNick(playerid), GetHouseValue(h));
ShowPlayerDialog(playerid, 504, DIALOG_STYLE_MSGBOX, "Купівля будинку", string, "{00FF00}Купити", "{FF0000}Відміна");
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
ShowPlayerDialog(playerid, 517, DIALOG_STYLE_MSGBOX, "інтер'єр", string, "{00FF00}Купити", "{FF0000}Відміна");
dlgcont[playerid] = 517;
}
#endif
if(GetPVarInt(playerid, "HousePreview") == 0)
{
SetPVarInt(playerid, "IsInHouse", 0);
SetPlayerPosEx(playerid, dini_Float(file, "SpawnOutX"), dini_Float(file, "SpawnOutY"), dini_Float(file, "SpawnOutZ"), dini_Int(file, "SpawnInterior"), dini_Int(file, "SpawnWorld"));
SetPlayerFacingAngle(playerid, dini_Float(file, "SpawnOutAngle"));
SetPlayerInterior(playerid, dini_Int(file, "SpawnInterior"));
SetPlayerVirtualWorld(playerid, dini_Int(file, "SpawnWorld"));
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
ShowPlayerDialog(playerid, 503, DIALOG_STYLE_MSGBOX, "Продажа будинку", string, "Продати", "{FF0000}Відміна");
dlgcont[playerid] = 503;
}
case 1:
{
#if defined GH_USE_WEAPONSTORAGE
ShowPlayerDialog(playerid, 518, DIALOG_STYLE_LIST, "Зберігання в будинку", "Зберігання грошей\nЗберігання зброї", "{00FF00}OK", "{FF0000}Відміна");
dlgcont[playerid] = 518;
#endif
#if !defined GH_USE_WEAPONSTORAGE
ShowPlayerDialog(playerid, 510, DIALOG_STYLE_LIST, "Зберігання грошей", "Покласти на зберігання\nЗняти з зберігання\nПровірити суму", "{00FF00}OK", "{FF0000}Відміна");
dlgcont[playerid] = 510;
#endif
}
case 2:
{
ShowPlayerDialog(playerid, 514, DIALOG_STYLE_INPUT, "назва будинку", "Введіть нову назву будинку", "{00FF00}OK", "{FF0000}Відміна");
dlgcont[playerid] = 514;
}
case 3:
{
ShowPlayerDialog(playerid, 513, DIALOG_STYLE_INPUT, "Пароль для будинку", "Введіть новий пароль для будинку нижче.\nЗалиште поле порожнім, якщо хочите зберегти Ваш старий пароль.\nВидалити - щоб видалити пароль.", "{00FF00}OK", "{FF0000}Видалити");
dlgcont[playerid] = 513;
}
case 4:
{
ShowPlayerDialog(playerid, 516, DIALOG_STYLE_LIST, "інтер'єр", "Попередній огляд інтер'єру\nкупити інтер'єр", "{00FF00}OK", "{FF0000}Відміна");
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
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
if(response)
{
if(GetOwnedHouses(playerid) == 0) return SendClientMessage(playerid, COLOUR_SYSTEM, E_NO_HOUSES_OWNED);
else
{
new tmp = dini_Int(file, "HouseStorage");
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT));
if(tmp >= 1)
{
ShowInfoBox(playerid, INFORMATION_HEADER, I_SELL_HOUSE1, ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT), (GetHouseValue(h) - ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT)), tmp);
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, tmp);
}
if(tmp == 0)
{
ShowInfoBox(playerid, INFORMATION_HEADER, I_SELL_HOUSE2, GetHouseName(h), ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT), (GetHouseValue(h) - ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT)));
}
dini_IntSet(file, "HouseValue", ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT));
dini_Set(file, "HouseOwner", INVALID_HOWNER_NAME);
dini_Set(file, "HousePassword", "INVALID_HOUSE_PASSWORD");
dini_Set(file, "HouseName", DEFAULT_HOUSE_NAME);
dini_IntSet(file, "HouseStorage", 0);
Loop(h2, MAX_HOUSES)
{
if(IsHouseInRangeOfHouse(h, h2, RANGE_BETWEEN_HOUSES) && h2 != h)
{
format(file2, sizeof(file2), FILEPATH, h2);
dini_IntSet(file2, "HouseValue", (dini_Int(file2, "HouseValue") - ReturnProcent(GetHouseValue(h2), HOUSE_SELLING_PROCENT2)));
UpdateHouseText(h2);
}
}
#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);
HouseMIcon[h] = CreateDynamicMapIcon(dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ"), 31, -1, dini_Int(file, "SpawnWorld"), dini_Int(file, "SpawnInterior"), -1, MICON_VD);
#endif
UpdateHouseText(h);
#if defined GH_DEBUGGING
(DEBUG_ODR13, pNick(playerid), playerid, GetHouseValue(h), tmp, h);
#endif
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
if(GetOwnedHouses(playerid) >= MAX_HOUSES_OWNED) { ShowInfoBox(playerid, INFORMATION_HEADER, "У Вас уже є %d будинки. Продайте один зі старих будинків щоб купити цей.", MAX_HOUSES_OWNED); return 1; }
if(strcmp(GetHouseOwner(GetPVarInt(playerid, "LastHouseCP")), pNick(playerid), CASE_SENSETIVE) && strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_H_ALREADY_OWNED);
if(GetHouseValue(h) > GetPlayerMoney(playerid)) { ShowInfoBox(playerid, INFORMATION_HEADER, "Ви не можете купити цей Будинок\nВартість будинку: $%d.\nУ Вас є: $%d.\nВам не хватає: $%d.", GetHouseValue(h), GetPlayerMoney(playerid), (GetHouseValue(h) - GetPlayerMoney(playerid))); return 1; }

else
{
format(hname, sizeof(hname), "%s's House", pNick(playerid));
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, - GetHouseValue(h));
dini_Set(file, "HouseOwner", pNick(playerid));
dini_Set(file, "HousePassword", "INVALID_HOUSE_PASSWORD");
dini_Set(file, "HouseName", hname);
dini_IntSet(file, "HouseStorage", 0);
ShowInfoBox(playerid, INFORMATION_HEADER, I_BUY_HOUSE, GetHouseValue(h));
Loop(h2, MAX_HOUSES)
{
if(IsHouseInRangeOfHouse(h, h2, RANGE_BETWEEN_HOUSES) && h2 != h)
{
format(file2, sizeof(file2), FILEPATH, h2);
dini_IntSet(file2, "HouseValue", (dini_Int(file2, "HouseValue") + ReturnProcent(GetHouseValue(h2), HOUSE_SELLING_PROCENT2)));
UpdateHouseText(h2);
}
}
#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);
HouseMIcon[h] = CreateDynamicMapIcon(dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ"), 32, -1, dini_Int(file, "SpawnWorld"), dini_Int(file, "SpawnInterior"), -1, MICON_VD);
#endif
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
SendClientMessage(playerid, COLOUR_SYSTEM, "Ваш пароль містить недопустимі символи:");
SendClientMessage(playerid, COLOUR_SYSTEM, "заборонені коди, чи знак відсотків, або ~ .");
return 1;
}
if(strlen(inputtext) > MAX_HOUSE_PASSWORD || (strlen(inputtext) < MIN_HOUSE_PASSWORD && strlen(inputtext) >= 1)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HPASS_LENGTH);
if(!strcmp(inputtext, "INVALID_HOUSE_PASSWORD", CASE_SENSETIVE)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HPASS);
else
{
if(strlen(inputtext) >= 1)
{
dini_Set(file, "HousePassword", inputtext);//пароль без хэш-шифрования
//					dini_IntSet(file, "HousePassword", udb_hash(inputtext));
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
dini_Set(file, "HousePassword", "INVALID_HOUSE_PASSWORD");
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
SendClientMessage(playerid, COLOUR_SYSTEM, "Ваш пароль містить недопустимі символи:");
SendClientMessage(playerid, COLOUR_SYSTEM, "заборонені коди, чи знак відтотків, або ~ .");
return 1;
}
if(strlen(inputtext) < MIN_HOUSE_NAME || strlen(inputtext) > MAX_HOUSE_NAME) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HNAME_LENGTH);
else
{
dini_Set(file, "HouseName", inputtext);
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
SetPVarInt(playerid, "OldHouseInt", dini_Int(file, "HouseInterior"));
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
if(dini_Int(file, "HouseInterior") == GetPVarInt(playerid, "HousePrevInt")) return SendClientMessage(playerid, COLOUR_SYSTEM, E_ALREADY_HAVE_HINTERIOR);
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
dini_IntSet(file, "HouseInteriorValue", GetPVarInt(playerid, "HousePrevValue"));
ShowInfoBox(playerid, INFORMATION_HEADER, I_HINT_BOUGHT, string, GetPVarInt(playerid, "HousePrevValue"));
#if defined GH_DEBUGGING
(DEBUG_ODR3, pNick(playerid), playerid, string, GetPVarInt(playerid, "HousePrevValue"), h);
#endif
}
}
}
if(GetPVarInt(playerid, "ChangeHouseInt") == 1)
{
dini_IntSet(file, "HouseInterior", GetPVarInt(playerid, "HousePrevInt"));
SetPVarInt(playerid, "ChangeHouseInt", 0);
DestroyHouseEntrance(h, TYPE_INT);
CreateCorrectHouseExitCP(h);
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
ShowPlayerDialog(playerid, 515, DIALOG_STYLE_LIST, "інтер'єр", string, "{00FF00}Купити", "{FF0000}Відміна");
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
dlgcont[playerid] = -600;//не существующий ИД диалога
return 1;
}
dlgcont[playerid] = -600;//не существующий ИД диалога
SetPVarInt(playerid, "HousePreview", 0);
KillTimer(GetPVarInt(playerid, "HousePrevTimer"));
SetPVarInt(playerid, "IsHouseVisiting", 0);
switch(response)
{
case 0:
{
dini_IntSet(file, "HouseInterior", GetPVarInt(playerid, "OldHouseInt"));

#if defined GH_DEBUGGING
(DEBUG_ODR5, h, GetPVarInt(playerid, "OldHouseInt"));
#endif

}
case 1:
{
GetPVarString(playerid, "HousePrevName", string, 50);
if(GetPlayerMoney(playerid) < GetPVarInt(playerid, "HousePrevValue"))
{
dini_IntSet(file, "HouseInterior", GetPVarInt(playerid, "OldHouseInt"));

#if defined GH_DEBUGGING
(DEBUG_ODR5, h, GetPVarInt(playerid, "OldHouseInt"));
#endif

ShowInfoBox(playerid, INFORMATION_HEADER, E_CANT_AFFORD_HINT, string, GetPVarInt(playerid, "HousePrevValue"), GetPlayerMoney(playerid), (GetPVarInt(playerid, "HousePrevValue") - GetPlayerMoney(playerid)));
}
else
{
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, - GetPVarInt(playerid, "HousePrevValue"));
dini_Set(file, "HouseInteriorName", string);
dini_IntSet(file, "HouseInterior", GetPVarInt(playerid, "HousePrevInt"));
dini_IntSet(file, "HouseInteriorValue", GetPVarInt(playerid, "HousePrevValue"));
ShowInfoBox(playerid, INFORMATION_HEADER, I_HINT_BOUGHT, string, GetPVarInt(playerid, "HousePrevValue"));
#if defined GH_DEBUGGING
(DEBUG_ODR3, pNick(playerid), playerid, string, GetPVarInt(playerid, "HousePrevValue"), h);

(DEBUG_ODR5, h, GetPVarInt(playerid, "HousePrevInt"));

#endif
}
}
}
DestroyHouseEntrance(h, TYPE_INT);
CreateCorrectHouseExitCP(h);
Loop(i, MAX_PLAYERS)
{
if(GetPVarInt(i, "LastHouseCP") == h && GetPVarInt(i, "IsInHouse") == 1)
{
SetPlayerHouseInterior(i, h);
}
}
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
new tmp = dini_Int(file, "HouseStorage");
if(listitem == 0) // Deposit
{
format(string, sizeof(string), I_HINT_DEPOSIT1, tmp);
ShowPlayerDialog(playerid, 511, DIALOG_STYLE_INPUT, "Зберігання грошей: покласти на зберігання", string, "{00FF00}Покласти", "{FF0000}Відміна");
dlgcont[playerid] = 511;
}
if(listitem == 1) // Withdraw
{
format(string, sizeof(string), I_HINT_WITHDRAW1, tmp);
ShowPlayerDialog(playerid, 512, DIALOG_STYLE_INPUT, "Зберігання грошей: зняти з зберігання", string, "{00FF00}Зняти", "{FF0000}Відміна");
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
SendClientMessage(playerid, COLOUR_SYSTEM, "Сума містить недопустимі символи:");
SendClientMessage(playerid, COLOUR_SYSTEM, "заборонені коди, чи знак процентів, або ~ .");
return 1;
}
new amount = floatround(strval(inputtext));
format(file, sizeof(file), FILEPATH, h);
if(amount > GetPlayerMoney(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_PMONEY);
if(amount < 1) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_AMOUNT);
if((dini_Int(file, "HouseStorage") + amount) > 50000000) return SendClientMessage(playerid, COLOUR_SYSTEM, E_HSTORAGE_L_REACHED);
else
{
dini_IntSet(file, "HouseStorage", (dini_Int(file, "HouseStorage") + amount));
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, - amount);
ShowInfoBox(playerid, INFORMATION_HEADER, I_HINT_DEPOSIT2, amount, dini_Int(file, "HouseStorage"));
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
SendClientMessage(playerid, COLOUR_SYSTEM, "Сума містить недопустимі символи:");
SendClientMessage(playerid, COLOUR_SYSTEM, "заборонені коди, чи знак процентів, або ~ .");
return 1;
}
new amount = floatround(strval(inputtext));
format(file, sizeof(file), FILEPATH, h);
if(amount > dini_Int(file, "HouseStorage")) return SendClientMessage(playerid, COLOUR_SYSTEM, E_NOT_ENOUGH_HSMONEY);
if(amount < 1) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_AMOUNT);
else
{
dini_IntSet(file, "HouseStorage", (dini_Int(file, "HouseStorage") - amount));
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, amount);
ShowInfoBox(playerid, INFORMATION_HEADER, I_HINT_WITHDRAW2, amount, dini_Int(file, "HouseStorage"));
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
ShowPlayerDialog(playerid, 510, DIALOG_STYLE_LIST, "Зберігання грошей", "Покласти на зберігання\nЗняти з зберігання\nПровірити суму", "{00FF00}OK", "{FF0000}Відміна");
dlgcont[playerid] = 510;
}
case 1:
{
ShowPlayerDialog(playerid, 519, DIALOG_STYLE_LIST, "Зберігання зброї", "Покласти на зберігання\nЗняти з зберігання", "{00FF00}OK", "{FF0000}Відміна");
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
dini_IntSet(file, tmp, WeaponData[weap][0]);
dini_IntSet(file, tmp2, WeaponData[weap][1]);
GivePlayerWeapon(playerid, WeaponData[weap][0], -WeaponData[weap][1]);
tmpcount++;
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
Loop(weap, 13)
{
format(tmp, sizeof(tmp), "Weapon%d", weap);
format(tmp2, sizeof(tmp2), "Weapon%dAmmo", weap);
if(dini_Int(file, tmp2) == 0) continue;
if(weap == 0) continue;
#if !defined GH_SAVE_ADMINWEPS
if(weap == 7 || weap == 8 || weap == 9 || weap == 11 || weap == 12) continue;
#endif
GivePlayerWeapon(playerid, dini_Int(file, tmp), dini_Int(file, tmp2));
dini_IntSet(file, tmp, 0);
dini_IntSet(file, tmp2, 0);
tmpcount++;
}
if(tmpcount >= 1)
{
ShowInfoBox(playerid, INFORMATION_HEADER, I_HS_WEAPONS2, tmpcount, AddS(tmpcount));
}
if(tmpcount == 0)
{
ShowInfoBox(playerid, INFORMATION_HEADER, E_NO_HS_WEAPONS, tmpcount); // I had to add tmpcount or it gave an error ^_^
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
SendClientMessage(playerid, COLOUR_SYSTEM, "Пароль містить недопустимі символи:");
SendClientMessage(playerid, COLOUR_SYSTEM, "заборонені коди, чи знак відсотків, або ~ .");
return 1;
}
if(strlen(inputtext) < MIN_HOUSE_PASSWORD || strlen(inputtext) > MAX_HOUSE_PASSWORD) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HPASS_LENGTH);
if(strcmp(dini_Get(file, "HousePassword"), inputtext, false) != 0)//пароль без хэш-шифрования
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
ShowPlayerDialog(playerid, 500, DIALOG_STYLE_LIST, "{00FF00}Меню будинку", "Продажа будинку\nЗберігання в будинку\nНазва будинку\nПароль для будинку\nінтер'єр", "{00FF00}OK", "{FF0000}Відміна");
dlgcont[playerid] = 500;
#endif
#if !defined GH_HINTERIOR_UPGRADE
ShowPlayerDialog(playerid, 500, DIALOG_STYLE_LIST, "{00FF00}Меню будинку", "Продажа будинку\nЗберігання в будинку\nНазва будинку\nПароль для будинку", "{00FF00}OK", "{FF0000}Відміна");
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
dini_Create(file);
GetPlayerPos(playerid, X, Y, Z);
GetPlayerFacingAngle(playerid, Angle);
dini_FloatSet(file, "CPOutX", X);
dini_FloatSet(file, "CPOutY", Y);
dini_FloatSet(file, "CPOutZ", Z);
dini_Set(file, "HouseName", DEFAULT_HOUSE_NAME);
dini_Set(file, "HouseOwner", INVALID_HOWNER_NAME);
dini_Set(file, "HousePassword", "INVALID_HOUSE_PASSWORD");
dini_Set(file, "HouseCreator", pNick(playerid));
dini_IntSet(file, "HouseValue", cost);
dini_IntSet(file, "HouseStorage", 0);
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
HouseLabel[h] = CreateDynamic3DTextLabel(labeltext, COLOUR_GREEN, X, Y, Z+0.7, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1);
SendMSG(playerid, COLOUR_YELLOW, 128, I_H_CREATED, h);
GetPosInFrontOfPlayer(playerid, X, Y, -2.5);
dini_FloatSet(file, "SpawnOutX", X);
dini_FloatSet(file, "SpawnOutY", Y);
dini_FloatSet(file, "SpawnOutZ", Z);
dini_FloatSet(file, "SpawnOutAngle", floatround((180 + Angle)));
dini_IntSet(file, "SpawnWorld", GetPlayerVirtualWorld(playerid));
dini_IntSet(file, "SpawnInterior", GetPlayerInterior(playerid));
dini_IntSet(file, "HouseInterior", hinterior);
#if defined GH_USE_CPS
switch(hinterior)
case 1:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_1_VALUE);
dini_Set(file, "HouseInteriorName", "Shitty Shack");
HouseCPInt[h] = CreateDynamicCP(2259.38, -1135.89, 1050.64, 1.50, (h + 1000), 10, -1, 10.0);
}
case 2:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_2_VALUE);
dini_Set(file, "HouseInteriorName", "Motel Room");
HouseCPInt[h] = CreateDynamicCP(2282.99, -1140.28, 1050.89, 1.50, (h + 1000), 11, -1, 10.0);
}
case 3:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_3_VALUE);
dini_Set(file, "HouseInteriorName", "Hotel Room 1");
HouseCPInt[h] = CreateDynamicCP(2233.69, -1115.26, 1050.88, 1.50, (h + 1000), 5, -1, 10.0);
}
case 4:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_4_VALUE);
dini_Set(file, "HouseInteriorName", "Hotel Room 2");
HouseCPInt[h] = CreateDynamicCP(2218.39, -1076.21, 1050.48, 1.50, (h + 1000), 1, -1, 10.0);
}
case 5:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_5_VALUE);
dini_Set(file, "HouseInteriorName", "Gang House");
HouseCPInt[h] = CreateDynamicCP(2496.00, -1692.08, 1014.74, 1.50, (h + 1000), 3, -1, 10.0);
}
case 6:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_6_VALUE);
dini_Set(file, "HouseInteriorName", "Normal House");
HouseCPInt[h] = CreateDynamicCP(2365.25, -1135.58, 1050.88, 1.50, (h + 1000), 8, -1, 10.0);
}
case 0:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_0_VALUE);
dini_Set(file, "HouseInteriorName", "Default House");
HouseCPInt[h] = CreateDynamicCP(2196.84, -1204.36, 1049.02, 1.5, (h + 1000), 6, -1, 10.0);
}
case 7:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_7_VALUE);
dini_Set(file, "HouseInteriorName", "Medium Mansion");
HouseCPInt[h] = CreateDynamicCP(2317.77, -1026.76, 1050.21, 1.50, (h + 1000), 9, -1, 10.0);
}
case 8:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_8_VALUE);
dini_Set(file, "HouseInteriorName", "Rich Mansion");
HouseCPInt[h] = CreateDynamicCP(2324.41, -1149.54, 1050.71, 1.50, (h + 1000), 12, -1, 10.0);
}
case 9:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_9_VALUE);
dini_Set(file, "HouseInteriorName", "Huge Mansion");
HouseCPInt[h] = CreateDynamicCP(140.28, 1365.92, 1083.85, 1.50, (h + 1000), 5, -1, 10.0);
}
case 10:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_10_VALUE);
dini_Set(file, "HouseInteriorName", "Mad Dogg's Mansion");
HouseCPInt[h] = CreateDynamicCP(1260.6603, -785.4005, 1091.9063, 1.50, (h + 1000), 5, -1, 10.0);
}
}
#endif
#if !defined GH_USE_CPS
switch(hinterior)
{
case 1:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_1_VALUE);
dini_Set(file, "HouseInteriorName", "Shitty Shack");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2260.38, -1135.89, 1050.64, (h + 1000), 10, -1, 15.0);
}
case 2:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_2_VALUE);
dini_Set(file, "HouseInteriorName", "Motel Room");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2284.24, -1139.42, 1050.89, (h + 1000), 11, -1, 15.0);
}
case 3:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_3_VALUE);
dini_Set(file, "HouseInteriorName", "Hotel Room 1");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2233.69, -1114.26, 1050.88, (h + 1000), 5, -1, 15.0);
}
case 4:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_4_VALUE);
dini_Set(file, "HouseInteriorName", "Hotel Room 2");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2216.39, -1077.10, 1050.48, (h + 1000), 1, -1, 15.0);
}
case 5:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_5_VALUE);
dini_Set(file, "HouseInteriorName", "Gang House");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2496.00, -1693.70, 1014.74, (h + 1000), 3, -1, 15.0);
}
case 6:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_6_VALUE);
dini_Set(file, "HouseInteriorName", "Normal House");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2365.25, -1134.00, 1050.88, (h + 1000), 8, -1, 15.0);
}
case 0:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_0_VALUE);
dini_Set(file, "HouseInteriorName", "Default House");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2195.84, -1204.36, 1049.02, (h + 1000), 6, -1, 15.0);
}
case 7:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_7_VALUE);
dini_Set(file, "HouseInteriorName", "Medium Mansion");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2319.43, -1026.33, 1050.21, (h + 1000), 9, -1, 15.0);
}
case 8:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_8_VALUE);
dini_Set(file, "HouseInteriorName", "Rich Mansion");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 2324.41, -1148.54, 1050.71, (h + 1000), 12, -1, 15.0);
}
case 9:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_9_VALUE);
dini_Set(file, "HouseInteriorName", "Huge Mansion");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 142.40, 1366.66, 1083.85, (h + 1000), 5, -1, 15.0);
}
case 10:
{
dini_IntSet(file, "HouseInteriorValue", H_INT_10_VALUE);
dini_Set(file, "HouseInteriorName", "Mad Dogg's Mansion");
HousePickupInt[h] = CreateDynamicPickup(PICKUP_MODEL_INT, PICKUP_TYPE, 1263.11, -785.26, 1091.9063, (h + 1000), 5, -1, 15.0);
}
}
#endif
dini_IntSet("/House/House.ini", "CurrentID", dini_Int("/House/House.ini", "CurrentID") + 1);
dini_IntSet("/House/House.ini", "CurrentWorld", dini_Int("/House/House.ini", "CurrentID") + 1000);
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
format(string, sizeof(string), " *** Адмін %s [%d] начав перезагрузку системи будинків.", sendername, playerid);
print(string);
SendClientMessageToAll(0xFF0000FF, string);
SetTimerEx("relhoyses1", 1000, 0, "i", playerid);
}
else
{
SendClientMessage(playerid, 0xFF0000FF, " У Вас немає прав на використання цієї команди !");
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
if(!strcmp(GetHouseOwner(tmp), pNick(i), CASE_SENSETIVE) && GetPVarInt(i, "IsInHouse") == 1 && dini_Exists(file))
{
dini_IntSet(file, "QuitInHouse", 1);
#if defined GH_HOUSECARS
SaveHouseCar(tmp);
#endif
}
}
}
UnloadSystemHouse(); // Вигрузка будинків (также разгружает дом автомобили)
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

LoadSystemHouse(); // Загрузка фс будинку
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
format(string, sizeof(string), " *** Адмін %s [%d] перезагрузив систему будинків.", sendername, playerid);
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
SendClientMessage(playerid, 0xBFC0C2FF, " Використовуйте: /lchouse [ід будинку]");
SendClientMessage(playerid, 0xFF0000FF, " Увага !!! Команда блокує будинок по його ID !!!");
SendClientMessage(playerid, 0xFF0000FF, " Використовуйте тільки в КРАЙНЬОМУ випадку !!!");
return 1;
}
format(file, sizeof(file), FILEPATH, h);
if(!dini_Exists(file)) return SendClientMessage(playerid, 0xFF0000FF, " будинка з таким ID не існує !");
if(!strcmp(dini_Get(file, "HouseOwner"), INVALID_HOWNER_NAME, CASE_SENSETIVE)) return SendClientMessage(playerid, 0xFF0000FF, " Неможна ! Будинок вільний !");
if(!strcmp(dini_Get(file, "HouseOwner"), "* Будинок заблокований", CASE_SENSETIVE)) return SendClientMessage(playerid, 0xFF0000FF, " Будинок вже заблокований !");
dini_Set(file, "HouseOwner", "* Будинок заблокований");
dini_Set(file, "HouseName", "* Будинок заблокований");
UpdateHouseText(h);
new string[256];
new sendername[MAX_PLAYER_NAME];
GetPlayerName(playerid, sendername, sizeof(sendername));
format(string, sizeof(string), " *** Адмін %s [%d] заблокував Будинок ID %d .", sendername, playerid, h);
print(string);
SendClientMessageToAll(0xFF0000FF, string);
}
else
{
SendClientMessage(playerid, 0xFF0000FF, " У Вас немає прав на використання цієї команди !");
}
return 1;
}
dcmd_addhcar(playerid, params[])
{
new file[HOUSEFILE_LENGTH], h;
if(!IsPlayerAdmin(playerid)) return 0;
if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_HCAR_NOT_IN_VEH);
if(sscanf(params, "d", h)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_ADDHCAR);
format(file, sizeof(file), FILEPATH, h);
if(!dini_Exists(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
else
{
if(dini_Int(file, "HCar") == 1) { SendMSG(playerid, COLOUR_YELLOW, 128, I_HCAR_EXIST_ALREADY, h); }
if(dini_Int(file, "HCar") == 0) { SendMSG(playerid, COLOUR_YELLOW, 128, I_HCAR_CREATED, h); }
GetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
GetVehicleZAngle(GetPlayerVehicleID(playerid), Angle);
dini_FloatSet(file, "HCarPosX", X);
dini_FloatSet(file, "HCarPosY", Y);
dini_FloatSet(file, "HCarPosZ", Z);
dini_FloatSet(file, "HCarAngle", Angle);
dini_IntSet(file, "HCar", 1);
dini_IntSet(file, "HCarWorld", GetPlayerVirtualWorld(playerid));
dini_IntSet(file, "HCarInt", GetPlayerInterior(playerid));
dini_IntSet(file, "HCarModel", GetVehicleModel(GetPlayerVehicleID(playerid)));
#if defined GH_DEBUGGING
(DEBUG_OP_CMD2, pNick(playerid), playerid, h);
#endif
}
return 1;
}
dcmd_removehouse(playerid, params[])
{
new h, file[HOUSEFILE_LENGTH];
if(!IsPlayerAdmin(playerid)) return 0;
if(sscanf(params, "d", h)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_REMOVEHOUSE);
format(file, sizeof(file), FILEPATH, h);
if(!dini_Exists(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
else
{
DestroyHouseEntrance(h, TYPE_OUT);
DestroyHouseEntrance(h, TYPE_INT);
#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);
#endif
DestroyDynamic3DTextLabel(HouseLabel[h]);
SendMSG(playerid, COLOUR_YELLOW, 128, I_H_DESTROYED, h);
dini_Remove(file);
#if defined GH_DEBUGGING
(DEBUG_OP_CMD3, pNick(playerid), playerid, h);
#endif
}
return 1;
}
dcmd_removehcar(playerid, params[])
{
new file[HOUSEFILE_LENGTH], h;
if(!IsPlayerAdmin(playerid)) return 0;
if(sscanf(params, "d", h)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_REMOVEHCAR);
format(file, sizeof(file), FILEPATH, h);
if(!dini_Exists(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
if(dini_Int(file, "HCar") == 0) return SendClientMessage(playerid, COLOUR_SYSTEM, E_NO_HCAR);
else
{
UnloadHouseCar(h);
dini_IntSet(file, "HCar", 0);
SendMSG(playerid, COLOUR_YELLOW, 128, I_HCAR_REMOVED, h);
#if defined GH_DEBUGGING
(DEBUG_OP_CMD4, pNick(playerid), playerid, h);
#endif
}
return 1;
}
dcmd_changehcar(playerid, params[])
{
new file[HOUSEFILE_LENGTH], h, modelid;
if(!IsPlayerAdmin(playerid)) return 0;
if(sscanf(params, "dd", h, modelid)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_CMD_USAGE_CHANGEHCAR);
format(file, sizeof(file), FILEPATH, h);
if(!dini_Exists(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
if(modelid < 400 || modelid > 611) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HCAR_MODEL);
else
{
dini_IntSet(file, "HCarModel", modelid);
SendMSG(playerid, COLOUR_YELLOW, 128, I_HCAR_CHANGED, h, modelid);
#if defined GH_HOUSECARS
if(GetVehicleModel(HouseCar[h]) != -1)
{
if(IsVehicleOccupied(HouseCar[h]))
{
new Float:Velocity[3], Float:Pos[4], Seat[MAX_PLAYERS] = -1, interior, vw = GetVehicleVirtualWorld(HouseCar[h]);
Loop(i, MAX_PLAYERS)
{
if(!IsPlayerConnected(i) || IsPlayerNPC(i)) continue;
if(IsPlayerInVehicle(i, HouseCar[h]))
{
Seat[i] = GetPlayerVehicleSeat(i);
if(Seat[i] == 0)
{
interior = GetPlayerInterior(i); // Have to do it this way because there is no GetVehicleInterior..
}
}
}
GetVehiclePos(HouseCar[h], Pos[0], Pos[1], Pos[2]);
GetVehicleZAngle(HouseCar[h], Pos[3]);
GetVehicleVelocity(HouseCar[h], Velocity[0], Velocity[1], Velocity[2]);
DestroyVehicle(HouseCar[h]);
HouseCar[h] = CreateVehicle(modelid, Pos[0], Pos[1], Pos[2], Pos[3], HCAR_COLOUR1, HCAR_COLOUR2, HCAR_RESPAWN);
LinkVehicleToInterior(HouseCar[h], interior);
SetVehicleVirtualWorld(HouseCar[h], vw);
Loop(i, MAX_PLAYERS)
{
if(!IsPlayerConnected(i) || IsPlayerNPC(i) || Seat[i] == -1) continue;
if(IsPlayerInVehicle(i, HouseCar[h]))
{
PutPlayerInVehicle(i, HouseCar[h], Seat[i]);
}
}
SetVehicleVelocity(HouseCar[h], Velocity[0], Velocity[1], Velocity[2]);

}
if(!IsVehicleOccupied(HouseCar[h]))
{
UnloadHouseCar(h);
LoadHouseCar(h);
}
}
#endif
#if defined GH_DEBUGGING
(DEBUG_OP_CMD12, pNick(playerid), playerid, h, modelid);
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
if(dini_Exists(file))
{
UnloadHouseCar(h);
DestroyHouseEntrance(h, TYPE_OUT);
DestroyHouseEntrance(h, TYPE_INT);
#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);
#endif
DestroyDynamic3DTextLabel(HouseLabel[h]);
dini_Remove(file);
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
dcmd_removeallhcars(playerid, params[])
{
#pragma unused params
new hcount, file[HOUSEFILE_LENGTH];
if(!IsPlayerAdmin(playerid)) return 0;
else
{
Loop(h, MAX_HOUSES)
{
UnloadHouseCar(h);
format(file, sizeof(file), FILEPATH, h);
if(dini_Exists(file))
{
dini_IntSet(file, "HCar", 0);
}
}
SendMSG(playerid, COLOUR_YELLOW, 128, I_ALLHCAR_REMOVED, hcount);
#if defined GH_DEBUGGING
(DEBUG_OP_CMD6, pNick(playerid), playerid, hcount);
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
if(!dini_Exists(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
else
{
GetPlayerPos(playerid, X, Y, Z);
GetPlayerFacingAngle(playerid, Angle);
dini_FloatSet(file, "SpawnOutX", X);
dini_FloatSet(file, "SpawnOutY", Y);
dini_FloatSet(file, "SpawnOutZ", Z);
dini_FloatSet(file, "SpawnOutAngle", Angle);
dini_IntSet(file, "SpawnWorld", GetPlayerVirtualWorld(playerid));
dini_IntSet(file, "SpawnInterior", GetPlayerInterior(playerid));
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
if(!dini_Exists(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
else
{
SetPlayerPosEx(playerid, dini_Float(file, "SpawnOutX"), dini_Float(file, "SpawnOutY"), dini_Float(file, "SpawnOutZ"), dini_Int(file, "SpawnInterior"), dini_Int(file, "SpawnWorld"));
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
if(!dini_Exists(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
if(!strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_H_A_F_SALE);
else
{
SendMSG(playerid, COLOUR_YELLOW, 128, I_H_SOLD, h);
if(dini_Int(file, "HouseStorage") >= 1 && IsPlayerConnected(GetHouseOwnerEx(h)))
{
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, (dini_Int(file, "HouseStorage") + ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT)));
}
dini_IntSet(file, "HouseValue", ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT));
dini_Set(file, "HouseOwner", INVALID_HOWNER_NAME);
dini_Set(file, "HousePassword", "INVALID_HOUSE_PASSWORD");
dini_Set(file, "HouseName", DEFAULT_HOUSE_NAME);
dini_IntSet(file, "HouseStorage", 0);
Loop(h2, MAX_HOUSES)
{
if(IsHouseInRangeOfHouse(h, h2, RANGE_BETWEEN_HOUSES) && h2 != h)
{
format(file2, sizeof(file2), FILEPATH, h2);
dini_IntSet(file2, "HouseValue", (dini_Int(file2, "HouseValue") - ReturnProcent(GetHouseValue(h2), HOUSE_SELLING_PROCENT2)));
}
}
Loop(i, MAX_PLAYERS)
{
if(GetPVarInt(i, "LastHouseCP") == h && GetPVarInt(i, "IsInHouse") == 1)
{
SetPVarInt(i, "IsInHouse", 0);
SetPlayerPosEx(i, dini_Float(file, "SpawnOutX"), dini_Float(file, "SpawnOutY"), dini_Float(file, "SpawnOutZ"), dini_Int(file, "SpawnInterior"), dini_Int(file, "SpawnWorld"));
SetPlayerFacingAngle(i, dini_Float(file, "SpawnOutAngle"));
SetPlayerInterior(i, dini_Int(file, "SpawnInterior"));
SetPlayerVirtualWorld(i, dini_Int(file, "SpawnWorld"));
}
}
#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);
HouseMIcon[h] = CreateDynamicMapIcon(dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ"), 31, -1, dini_Int(file, "SpawnWorld"), dini_Int(file, "SpawnInterior"), -1, MICON_VD);
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
if(dini_Exists(file) && strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE))
{
if(dini_Int(file, "HouseStorage") >= 1 && IsPlayerConnected(GetHouseOwnerEx(h)))
{
SetPVarInt(playerid, "MonControl", 1);
GivePlayerMoney(playerid, (dini_Int(file, "HouseStorage") + ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT)));
}
dini_IntSet(file, "HouseValue", ReturnProcent(GetHouseValue(h), HOUSE_SELLING_PROCENT));
dini_Set(file, "HouseOwner", INVALID_HOWNER_NAME);
dini_Set(file, "HousePassword", "INVALID_HOUSE_PASSWORD");
dini_Set(file, "HouseName", DEFAULT_HOUSE_NAME);
dini_IntSet(file, "HouseStorage", 0);
#if defined GH_USE_MAPICONS
DestroyDynamicMapIcon(HouseMIcon[h]);
HouseMIcon[h] = CreateDynamicMapIcon(dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ"), 31, -1, dini_Int(file, "SpawnWorld"), dini_Int(file, "SpawnInterior"), -1, MICON_VD);
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
if(!dini_Exists(file)) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HID);
if(price < 500000 || price > 50000000) return SendClientMessage(playerid, COLOUR_SYSTEM, E_INVALID_HVALUE);
else
{
dini_IntSet(file, "HouseValue", price);
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
if(dini_Exists(file))
{
dini_IntSet(file, "HouseValue", price);
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
return ShowPlayerDialog(playerid, 520, DIALOG_STYLE_MSGBOX, "Команди", "/changeallprices\n/removeallhcars\n/sellallhouses\
\n/changeprice\n/changespawn\n/removehcar\n/sellhouse\n/housemenu\n/gotohouse\n/relhouses\n/lchouse\n/addhcar\
\n/changehcar\n/ghcmds", "Закрити", "");
}
}
forward HouseVisiting(playerid);
public HouseVisiting(playerid)
{

SetPVarInt(playerid, "HousePrevTime", 0);//сбрасываем блокировку меню будинку

new string[200], tmpstring[50];
GetPVarString(playerid, "HousePrevName", tmpstring, 50);
format(string, sizeof(string), I_HINT_VISIT_OVER, tmpstring, GetPVarInt(playerid, "HousePrevValue"));
ShowPlayerDialog(playerid, 517, DIALOG_STYLE_MSGBOX, "Інтер'єр", string, "{00FF00}Купити", "{FF0000}Відміна");
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
if(dini_Int(file, "QuitInHouse") == 1)
{
SetPVarInt(playerid, "IsInHouse", 1);
SetPVarInt(playerid, "LastHouseCP", h);
SetPlayerHouseInterior(playerid, h);
#if defined GH_HOUSECARS
LoadHouseCar(h);
#endif
SendClientMessage(playerid, COLOUR_INFO, I_HMENU);
dini_IntSet(file, "QuitInHouse", 0);
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

for(new i = 0; i < MAX_PLAYERS; i++)//цикл для всех игроков
{
if(IsPlayerConnected(i))//дальнейшее Виполняем если игрок в коннекте
{
SetPVarInt(i, "HousePrevTime", 0);//обнуление важных глобальных переменных !!!
SetPVarInt(i, "HousePreview", 0);
SetPVarInt(i, "IsHouseVisiting", 0);
SetPVarInt(i, "LastHouseCP", 0);
SetPVarInt(i, "IsInHouse", 0);
SetPVarInt(i, "HousePrevInt", 0);
SetPVarInt(i, "IsHouseVisiting", 0);
SetPVarInt(i, "ChangeHouseInt", 0);
SetPVarInt(i, "HouseIntUpgradeMod", 0);
SetPVarInt(i, "JustCreatedHouse", 0);
SetPVarInt(i, "FirstSpawn", 0);
}
}

new hcount = 0;
Loop(h, MAX_HOUSES)
{
new file[HOUSEFILE_LENGTH], labeltext[150];
format(file, sizeof(file), FILEPATH, h);
if(dini_Exists(file))
{
#if defined GH_USE_CPS
HouseCPOut[h] = CreateDynamicCP(dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ"), 1.5, dini_Int(file, "SpawnWorld"), dini_Int(file, "SpawnInterior"), -1, 15.0);
#endif
#if !defined GH_USE_CPS
HousePickupOut[h] = CreateDynamicPickup(PICKUP_MODEL_OUT, PICKUP_TYPE, dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ"), dini_Int(file, "SpawnWorld"), dini_Int(file, "SpawnInterior"), -1, 15.0);
#endif
CreateCorrectHouseExitCP(h);
if(!strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE))
{
format(labeltext, sizeof(labeltext), LABELTEXT1, GetHouseName(h), GetHouseValue(h), h);
HouseLabel[h] = CreateDynamic3DTextLabel(labeltext, COLOUR_GREEN, dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ")+0.7, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, dini_Int(file, "SpawnWorld"), dini_Int(file, "SpawnInterior"), -1);
#if defined GH_USE_MAPICONS
HouseMIcon[h] = CreateDynamicMapIcon(dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ"), 31, -1, dini_Int(file, "SpawnWorld"), dini_Int(file, "SpawnInterior"), -1, MICON_VD);
#endif
}
if(strcmp(GetHouseOwner(h), INVALID_HOWNER_NAME, CASE_SENSETIVE))
{
format(labeltext, sizeof(labeltext), LABELTEXT2, GetHouseName(h), GetHouseOwner(h), GetHouseValue(h), h);
HouseLabel[h] = CreateDynamic3DTextLabel(labeltext, COLOUR_GREEN, dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ")+0.7, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, dini_Int(file, "SpawnWorld"), dini_Int(file, "SpawnInterior"), -1);
#if defined GH_USE_MAPICONS
HouseMIcon[h] = CreateDynamicMapIcon(dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ"), 32, -1, dini_Int(file, "SpawnWorld"), dini_Int(file, "SpawnInterior"), -1, MICON_VD);
#endif
}
hcount++;
}
}
return 1;
}
stock LoadHouseCar(houseid)
{
#if defined GH_HOUSECARS
new file[HOUSEFILE_LENGTH];
format(file, sizeof(file), FILEPATH, houseid);
if(dini_Exists(file) && dini_Int(file, "HCar") == 1)
{
HouseCar[houseid] = CreateVehicle(dini_Int(file, "HCarModel"), dini_Float(file, "HCarPosX"), dini_Float(file, "HCarPosY"), dini_Float(file, "HCarPosZ"), dini_Float(file, "HCarAngle"), HCAR_COLOUR1, HCAR_COLOUR2, HCAR_RESPAWN);
SetVehicleVirtualWorld(HouseCar[houseid], dini_Int(file, "HCarWorld"));
LinkVehicleToInterior(HouseCar[houseid], dini_Int(file, "HCarInt"));
}
#endif
return 1;
}
stock UnloadHouseCar(houseid)
{
#if !defined GH_HOUSECARS
#pragma unused houseid
#endif
#if defined GH_HOUSECARS
new file[HOUSEFILE_LENGTH];
format(file, sizeof(file), FILEPATH, houseid);
if(dini_Exists(file) && dini_Int(file, "HCar") == 1)
{
if(GetVehicleModel(HouseCar[houseid]) >= 400 && GetVehicleModel(HouseCar[houseid]) <= 611 && HouseCar[houseid] >= 1)
{
DestroyVehicle(HouseCar[houseid]);
HouseCar[houseid] = -1;
}
}
#endif
return 1;
}
stock SaveHouseCar(houseid)
{
#if defined GH_HOUSECARS
new file[HOUSEFILE_LENGTH], Float:tmpx, Float:tmpy, Float:tmpz;
format(file, sizeof(file), FILEPATH, houseid);
if(dini_Exists(file) && dini_Int(file, "HCar") == 1)
{
tmpx = dini_Float(file, "HCarPosX"), tmpy = dini_Float(file, "HCarPosY"), tmpz = dini_Float(file, "HCarPosZ");
Loop(v, MAX_VEHICLES)
{
if(GetVehicleModel(v) < 400 || GetVehicleModel(v) > 611 || IsVehicleOccupied(v)) continue;
GetVehiclePos(v, X, Y, Z);
if(PointInRangeOfPoint(HCAR_RANGE, X, Y, Z, tmpx, tmpy, tmpz))
{
dini_IntSet(file, "HCarModel", GetVehicleModel(v));
DestroyVehicle(v);
break;
}
}
}
#endif
return 1;
}
stock GetOwnedHouses(playerid)
{
new file[HOUSEFILE_LENGTH], tmpcount;
Loop(h, MAX_HOUSES)
{
format(file, sizeof(file), FILEPATH, h);
if(dini_Exists(file))
{
if(!strcmp(dini_Get(file, "HouseOwner"), pNick(playerid), CASE_SENSETIVE))
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
if(dini_Exists(file))
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
if(dini_Exists(file))
{
if(!strcmp(pNick(playerid), dini_Get(file, "HouseOwner"), CASE_SENSETIVE))
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
#if defined GH_HOUSECARS
UnloadHouseCar(h);
#endif
}
return 1;
}
stock GetHouseValue(houseid)
{
new file[HOUSEFILE_LENGTH];
format(file, sizeof(file), FILEPATH, houseid);
if(dini_Exists(file))
{
return dini_Int(file, "HouseValue");
}
else return ("Couldn't Get House Value For House ID %d. File Doesn't Exist...", houseid);
}
stock GetHouseName(houseid)
{
new file[HOUSEFILE_LENGTH], hname[MAX_HOUSE_NAME];
format(hname, MAX_HOUSE_NAME, "%s", DEFAULT_HOUSE_NAME);
format(file, sizeof(file), FILEPATH, houseid);
if(dini_Exists(file))
{
format(hname, MAX_HOUSE_NAME, "%s", dini_Get(file, "HouseName"));
return hname;
}
return hname;
}
stock GetHouseOwner(houseid)
{
new file[HOUSEFILE_LENGTH], howner[MAX_PLAYER_NAME];
format(howner, MAX_PLAYER_NAME, INVALID_HOWNER_NAME);
format(file, sizeof(file), FILEPATH, houseid);
if(dini_Exists(file))
{
format(howner, MAX_PLAYER_NAME, "%s", dini_Get(file, "HouseOwner"));
return howner;
}
return howner;
}
stock IsHouseInRangeOfHouse(house, house2, Float:range = 250.0)
{
new file[HOUSEFILE_LENGTH], file2[25];
format(file, sizeof(file), FILEPATH, house);
format(file2, sizeof(file2), FILEPATH, house2);
if(dini_Exists(file) && dini_Exists(file2))
{
if(PointInRangeOfPoint(range, dini_Float(file, "CPOutX"), dini_Float(file, "CPOutY"), dini_Float(file, "CPOutZ"), dini_Float(file2, "CPOutX"), dini_Float(file2, "CPOutY"), dini_Float(file2, "CPOutZ")))
{
return 1;
}
}
return 0;
}
stock CreateCorrectHouseExitCP(houseid)
{
new file[HOUSEFILE_LENGTH];
format(file, sizeof(file), FILEPATH, houseid);
#if defined GH_USE_CPS
switch(dini_Int(file, "HouseInterior"))
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
switch(dini_Int(file, "HouseInterior"))
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
switch(dini_Int(file, "HouseInterior"))
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
if(!dini_Exists(file))
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
if(dini_Exists(file))
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
if(dini_Exists(file))
{
if(!strcmp(dini_Get(file, "HouseOwner"), INVALID_HOWNER_NAME, CASE_SENSETIVE))
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
