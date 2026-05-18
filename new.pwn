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
