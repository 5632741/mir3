(******************************************************************************
 *   LomCN Mir3 Polish Game Language LGU File 2013                            *
 *                                                                            *
 *   Web       : http://www.lomcn.org                                         *
 *   Version   : 0.0.0.1                                                      *
 *                                                                            *
 *   - File Info -                                                            *
 *                                                                            *
 *   It holds the mir3 game polish language strings.                          *
 *                                                                            *
 ******************************************************************************
 * Change History                                                             *
 *                                                                            *
 *  - 0.0.0.1 [2013-04-05] Coly : first init                                  *
 *  - 0.0.0.2 [2013-04-07] budyniowski: translation                           *
 *                                                                            *
 *                                                                            *
 *                                                                            *
 ******************************************************************************
 * :Info:                                                                     *
 * The Maximum of String Literale is 255 so you need to add ' + '             *
 * at the end of 255 Char...                                                  *
 * The String it self can have a length of 1024                               *
 *                                                                            *
 * !! Don't localize or delete things with "�" !!                             *
 * !! it is part of the Script Engine Commands !!                             *
 *                                                                            *
 * !!! Attention, only the English language files are                         * 
 * !!! matched by the development team, not other languages??.                *
 *                                                                            * 
 ******************************************************************************)

unit mir3_language_game;

interface

uses Windows, SysUtils, Classes;

function GetGameLine(): Integer; stdcall;
function GetGameString(ID: Integer; Buffer: PChar): Integer; stdcall;

implementation

function GetGameLine(): Integer; stdcall;
begin
  Result := 2000;
end;

function GetGameString(ID: Integer; Buffer: PChar): Integer; stdcall;
var
  Value : string;
begin
  case ID of
    (*******************************************************************
    *                     Login, Server Selection.                     *
    *******************************************************************)
    1 : Value := 'Zaloguj Si�';                                                              // Button
    2 : Value := 'Wyj�cie';                                                                // Button
    3 : Value := 'Nowe Konto';                                                         // Button URL
    4 : Value := 'Zmiana Has�a';                                                     // Button URL
    5 : Value := 'LOGIN                                   HAS�O�CE�';                // Button
    6 : Value := 'Zaloguj Si� (L)';                                                          // [1] Hint
    7 : Value := 'Wyj�cie (X)';                                                            // [2] Hint
    8 : Value := 'Nowe Konto (N)';                                                     // [3] Hint
    9 : Value := 'Zmiana Has�a (P)';                                                 // [4] Hint
    10: Value := 'Zosta�e� od��czony.';                                         // Infoboard
    11: Value := 'Serwer jest niedost�pny poniewa�\trwaj� prace konserwacyjne.';                       // Infoboard
    12: Value := 'Nie mo�na po��czy� z serwerem.\Serwer jest nieosi�galny.';            // Infoboard
    13: Value := 'Czy na pewno chcesz wyj��?';
    14: Value := 'Reserved';
    15: Value := 'Reserved';
    { SM_LOGIN_PASSWORD_FAIL }
    16: Value := 'Tw�j login lub has�o s� niepoprawne.\Prosz� spr�buj ponownie.';
    17: Value := 'Wprowadzono b��dne dane logowania\trzy razy.\Prosz� spr�buj ponownie p�niej.';
    18: Value := 'Nie mo�na uzyska� informacji o koncie.\Prosz� spr�buj ponownie p�niej.';
    19: Value := 'Twoje konto zosta�o zablokowane.\Wejd� na stron� www.lomcn.org\po wi�cej informacji.';
    20: Value := 'Tw�j abonament wygas�.\Wejd� na stron� www.lomcn.org\po wi�cej informacji.';
    21: Value := 'Wyst�pi�y nieznane b��dy!\Wejd� na stron� www.lomcn.org\po wi�cej informacji.';
    22: Value := 'Reserved';
    23: Value := 'Reserved';
    24: Value := 'Reserved';
    25: Value := 'Reserved';
    { SM_LOGIN_PASSWORD_OK Verify Subscription }
    26: Value := 'Dzisiaj wygasa tw�j abonament!\Wejd� na stron� http://www.lomcn.org\po wi�cej informacji.';
    27: Value := 'Tw�j abonament wyga�nie za\ %d dni.';
    28: Value := 'Dost�p z twojego IP b�dzie wa�ny przez\nast�pnych %d dni.';
    29: Value := 'Dzisiaj wygasa dost�p z twojego IP!';
    30: Value := 'Dost�p z twojego IP b�dzie wa�ny przez\nast�pnych %d godzin.';
    31: Value := 'Tw�j login b�dzie wa�ny przez\nast�pnych %d godzin.';
    32: Value := 'Reserved';
    33: Value := 'Reserved';
    34: Value := 'Reserved';
    35: Value := 'Reserved';
    36: Value := 'Reserved';
    37: Value := 'Reserved';
    38: Value := 'Reserved';
    39: Value := 'Reserved';
    40: Value := 'Reserved';
    (*******************************************************************
    *               Character Selection / Creation                     *
    *******************************************************************)
    41: Value := 'Wczytywanie informacji o postaci, prosz� czekaj...';
    42: Value := 'Wybierz Wojownika';
    43: Value := 'Wybierz Czarodzieja';
    44: Value := 'Wybierz Taoist�';
    45: Value := 'Wybierz Skrytob�jc�';
    46: Value := 'Potwierd�';
    47: Value := 'Anuluj';
    48: Value := 'Imi�';
    49: Value := 'Poziom';
    50: Value := 'Klasa';
    51: Value := 'Z�oto';
    52: Value := 'Exp';
    53: Value := 'Reserved';
    54: Value := 'Reserved';
    55: Value := 'M�czyzna';
    56: Value := 'Kobieta';
    57: Value := 'Wojownik';
    58: Value := 'Czarodziej';
    59: Value := 'Taoista';
    60: Value := 'Skrytob�jca';
    { Information about Warriors }
    61: Value := '�Y05��C1D1AD69��C23A3A3A� [%s Wojownik]�CE�\�Y08�'             // SE: Better to have gender first
               + ' Wojownicy s�yn� ze swojej ogromnej si�y i witalno�ci. Nie jest �atwo\'
               + ' pokona� ich w boju, a ich dodatkowym atutem jest mo�liwo�� u�ywania\'
               + ' ci�kiego or�a oraz zbroi. Wojownicy s� niezr�wnani w zwarciu, natomiast\'
               + ' s�abo sobie radz� z odpieraniem atak�w dystansowych. R�norodno�ci ekwipunku\'
               + ' zaprojektowanego specjalnie dla Wojownik�w umo�liwia wyr�wnanie jego szans\'
               + ' w walce z przeciwnikami dystansowymi. Wojownik jest dobr� klas� dla\'
               + ' pocz�tkuj�cych ze wzgl�du na jego proste lecz pot�ne umiej�tno�ci.\';
    { Information about Wizards }
    62: Value := '�Y05��C1D1AD69��C23A3A3A� [%s Czarodziej]�CE�\�Y08�'
               + ' Czarodzieje posiadaj� ma�o si�y oraz wytrzyma�o�ci, ale potrafi� u�ywa�\'
               + ' pot�nej magii. Ich zakl�cia bojowe s� bardzo skuteczne, ale czas potrzebny\'
               + ' na inkantacj� ods�ania Czarodzieja na ewentualny kontratak ze strony wroga.\'
               + ' Dlatego, graj�c Czarodziejem musisz zawsze d��y� do tego aby atakowa� wrog�w\'
               + ' z bezpiecznej odleg�o�ci. Czarodzieje s� s�abi fizycznie, dlatego ci�ko jest\'
               + ' ich trenowa� we wczesnych etapach gry, natomiast staj� si� bardzo pot�ni\'
               + ' kiedy tylko naucz� si� bardziej zaawansowanych zakl��. Ze wzgl�du na liczne\'
               + ' zalety i wady, gra Czarodziejem wymaga du�o uwagi i umiej�tno�ci.\';
    { Information about Taoists }
    63: Value := '�Y05��C1D1AD69��C23A3A3A� [%s Taoista]�CE�\�Y08�'
               + ' Taoi�ci s� uosobieniem r�wnowagi mi�dzy si�� a witalno�ci�, ale zamiast\'
               + ' bezpo�rednio anga�owa� si� w walk� z wrogiem, wol� trzyma� si� z boku,\'
               + ' poniewa� ich prawdziw� si�� jest wspieranie innych klas. Ich podstawowe\'
               + ' zakl�cia s�u�� do leczenia i ochrony towarzyszy broni. Mog� oni r�wnie�\'
               + ' przyzywa� do pomocy pot�ne chowa�ce, oraz rzuca� kilka dobrze wywa�onych\'
               + ' zakl�� bojowych. Pomimo wielu przydatnych umiej�tno�ci, brak t�yzny fizycznej\'
               + ' czyni Taoist�w trudnymi do wyszkolenia. Najlepiej radz� sobie oni w towarzystwie\'
			   + ' jednej z pozosta�ych klas postaci.\';
    { Information about Assassins }
    64: Value :=  '�Y05��C1D1AD69��C23A3A3A� [%s Skrytob�jca]�CE�\�Y08�'
               + '�C1D1AD69��C2C19D59� Skrytob�jcy s� cz�onkami tajemniczej organizacji a ich historia jest prawie\'
               + ' ca�kowicie nieznana. S� oni s�abi fizycznie ale potrafi� si� doskonale\'
               + ' kamuflowa� oraz atakowa� pozostaj�c w ukryciu, oczywi�cie s� r�wnie� �wietni\'
               + ' w szybkim odbieraniu �ycia. Jednak�e musz� oni unika� anga�owania si� w walk�\'
               + ' przeciwko wielu przeciwnikom poniewa� maj� oni mniej umiej�tno�ci obronnych od\'
               + ' innych postaci. Gra Skrytob�jc� jest zalecana dla do�wiadczonych graczy, gdy�\'
               + ' wymaga wprawnych ruch�w, sprytnych decyzji oraz szybkiego my�lenia.�CE�\';
    65: Value := 'Posta� usuni�ta.';
    66: Value := 'Usuni�tych postaci nie mo�na przywr�ci�, i\'
               + 'nie mo�na stworzy� postaci z t� sam� nazw�\'
               + 'przez jaki� czas. Je�eli na pewno chcesz\'
               + 'usun�� posta�, wprowad� has�o i naci�nij\'
               + 'przycisk "Potwierd�".';  
    67: Value := 'Nie mo�esz stworzy� wi�cej ni� %d postaci.';
    68: Value := 'Prosz� stw�rz najpierw posta�.';
    69: Value := 'Nie mo�na uzyska� dost�pu do informacji o postaci.';
    70: Value := 'Posta� o tym imieniu ju� istnieje.';
    71: Value := 'Nie mo�esz stworzy� nast�pnej postaci.';
    72: Value := 'B��d tworzenia postaci - Kod b��du 4';
    73: Value := 'Mia� miejsce nieznany b��d.\Wejd� na stron� www.lomcn.org\po wi�cej informacji.';
    74: Value := 'Wykryto b��d przy usuwaniu\twojej postaci.';
    75: Value := 'Rozpocznij Gr�CE�';
    76: Value := 'Nowa Posta�CE�';
    77: Value := 'Usu� Posta�CE�';
    78: Value := 'Wyj�cie�CE�';
    79: Value := 'Reserved';
    80: Value := 'Reserved';
    (*******************************************************************
    *                        InGame Text                               *
    *******************************************************************)
    {Menu Bar}
    81: Value := 'Ustawienia';
    82: Value := 'Chat';
    83: Value := 'Wiadomo��';
    84: Value := 'Grupa';
    85: Value := 'Gildia';
    86: Value := 'Avatar';
    87: Value := 'Obl�enie';
    88: Value := 'Ustawienia-Auto';
    89: Value := 'Wyj�cie';
    90: Value := 'Zamknij';
    91..100 : Value := 'Reserved';
    {Game Settings}
    101: Value := 'Podstawowe';
    102: Value := 'Bezpiecze�stwo';
    103: Value := 'Chat';
    104: Value := 'Graficzne';
    { Page 1 Basic }
    105: Value := 'Tryb Ataku: Wszyscy';
    106: Value := 'Tryb Ataku: Pokojowy';
    107: Value := 'Tryb Ataku: Ma��e�stwo'; //(Kochanie)'; - Kochanek, Partner, Ma��onek, Para
    108: Value := 'Tryb Ataku: Mistrz-Ucze�';
    109: Value := 'Tryb Ataku: Grupowy';
    110: Value := 'Tryb Ataku: Gildiowy';
    111: Value := 'Tryb Ataku: Czerwony Kontra Biali';
    112: Value := 'Reserved';
    113: Value := 'Reserved';
    114: Value := 'Zmiana Pozycji Ataku';                   // Hint for Atak Mode
    116: Value := 'Normalna Pozycja Ataku';
    117: Value := 'Zmiana Pozycji Ataku';                   // Hint for Atak Mode
    118: Value := 'Muzyka W Tle';
    119: Value := '[ W��cz/Wy��cz Muzyk� W Tle ]';            // Hint Background Music
    120: Value := 'Efekty D�wi�kowe';
    121: Value := '[ W��cz/Wy��cz Efekty D�wi�kowe ]';               // Hint Sound Effects
    122: Value := 'D�wi�k Stereo';
    123: Value := '[ W��cz Wy��cz D�wi�k Stereo ]';           // Hint Sound Effects
    124: Value := 'Automatyczne Podnoszenia';
    125: Value := '[ W��cz/Wy��cz Automatyczne Podnoszenie ]';           // Hint Sound Effects
    126: Value := 'Poka� Nazwy Upuszczonych Przedmiot�w';
    127: Value := '[ W��cz/Wy��cz Pokazywanie Nazw Upuszczonych Przedmiot�w]'; // Hint Sound Effects
    { Page 2 Permissions }
    128: Value := 'Dopu�� Zaproszenia Do Grupy';
    129: Value := '[ W��cz/Wy��cz Zaproszenia Do Grupy ]';
    130: Value := 'Dopu�� Zaproszenia Do Gildii';
    131: Value := '[ W��cz/Wy��cz Zaproszenia Do Gildii ]';
    132: Value := 'Dopu�� Wskrzeszanie';
    133: Value := '[ W��cz/Wy��cz Wskrzeszanie ]';
    134: Value := 'Dopu�� Przywo�anie';
    135: Value := '[ W��cz/Wy��cz Przywo�anie ]';
    136: Value := 'Dopu�� Handel';
    137: Value := '[ W��cz/Wy��cz Handel ]';
    138: Value := 'Efekty Rozlewu Krwi (18+)'; // Fixed
    139: Value := '[ W��cz/Wy��cz Efekty Rozlewu Krwi ]';
    140: Value := 'Reserved';
    141: Value := 'hint reserved';
    142: Value := 'Reserved';
    143: Value := 'hint reserved';
    144: Value := 'Reserved';
    145: Value := 'hint reserved';
    146: Value := 'Reserved';
    147: Value := 'hint reserved';
    { Page 3 Chatting }
    148: Value := 'Szeptanie';
    149: Value := '[ W��cz/Wy��cz Nas�uchiwanie Szept�w ]';
    150: Value := 'Okrzyki';
    151: Value := '[ W��cz/Wy��cz Nas�uchiwanie Okrzyk�w ]';
    152: Value := 'Reserved';
    153: Value := 'hint reserved';
    154: Value := 'Wiadomo�ci Gildiowe';
    155: Value := '[ W��cz/Wy��cz Nas�uchiwanie Wiadomo�ci Gildiowych ]';
    156: Value := 'Zablokuj Szepty Od U�ytkownika';
    157: Value := '[ Zablokowano Szepty Od U�ytkownika %s ]';    // SE: it would be nice for the %s to let you know who is blocked - not necessary though | Coly: Prio 8 or so...
    158: Value := 'Reserved';
    159: Value := 'Reserved';
    160: Value := 'hint reserved';
    161: Value := 'Reserved';
    162: Value := 'hint reserved';
    163: Value := 'Reserved';
    164: Value := 'hint reserved';
    165: Value := 'Reserved';
    166: Value := 'hint reserved';
    167: Value := 'Reserved';
    168: Value := 'hint reserved';
    { Page 4 Visual }
    169: Value := 'Wska�nik Zmiany HP';
    170: Value := '[ W��cz/Wy��cz Wska�nik Zmiany HP ]';
    171: Value := 'Wy�wietlanie Grafiki Zakl��';
    172: Value := '[ W��cz/Wy��cz Wy�wietlanie Grafiki Zakl�� ]';
    173: Value := 'Wy�wietlanie Rozmytych Cieni';
    174: Value := '[ W��cz/Wy��cz Wy�wietlanie Rozmytych Cieni ]';
    175: Value := 'Wy�wietlanie Grafiki He�mu';
    176: Value := '[ W��cz/Wy��cz Wy�wietlanie Grafiki He�mu ]';
    177: Value := 'Wy�wietlanie Efekt�w Potwor�w';
    178: Value := '[ W��cz/Wy��cz Wy�wietlanie Efekt�w Potwor�w ]';
    179: Value := 'Wy�wietlanie Koloru Przefarbowanych W�os�w';
    180: Value := '[ W��cz/Wy��cz Wy�wietlanie Koloru Przefarbowanych W�os�w ]';
    181: Value := 'Wy�wietlanie Avatara';
    182: Value := '[ W��cz/Wy��cz Wy�wietlanie Avatara ]';
    183: Value := 'Poka� Potwory Na Mini-Mapie';  
    184: Value := '[ W��cz/Wy��cz Wy�wietlanie Potwor�w Na Mini-Mapie ]';
    185: Value := 'Wy�wietlanie Wska�nika HP Gracza';
    186: Value := '[ W��cz/Wy��cz Wska�nik HP Gracza ]';
    187: Value := 'Wy�wietlanie Wska�nika HP Potwor�w';
    188: Value := '[ W��cz/Wy��cz Wska�nik HP Potwor�w ]';
    189: Value := 'Reserved';
    { Exit Window }
    190: Value := 'Wyj�cie';
    191: Value := 'Opu�� gr�.';
    192: Value := 'Wyloguj si�';
    193: Value := 'Wyloguj si� i wybierz inn� posta�.';
    194: Value := 'Jeste� pewien, �e chcesz wyj��?';
    195: Value := 'Anuluj';
    { Belt Window }
    196: Value := 'Odwr��';         //Hint
    197: Value := 'Zamknij';          //Hint
    198: Value := 'Reserved';
    199: Value := 'Reserved';
    200: Value := 'Reserved';
    { Mini Map }
    201: Value := ''; //Hint
    202: Value := ''; //Hint
    203: Value := ''; //Hint
    204: Value := ''; //Hint
    205: Value := 'Brak Mini-Mapy';
    206: Value := 'Brak Dost�pnej Mapy!';
    207: Value := 'Nie u�ywane';
    208..210: Value := 'Reserved';
    { Body Window }
    211: Value := 'Poziom';
    212: Value := 'Do�wiadczenie';
    213: Value := 'Punkty Zdrowia (HP)';
    214: Value := 'Punkty Many (MP)';
    215: Value := 'Ci�ar Ekwipunku';
    216: Value := 'Ci�ar Zbroi';
    217: Value := 'Ci�ar Or�a';
    218: Value := 'Celno��';
    219: Value := 'Zwinno��';
    220: Value := 'Prw(Atk)';
    221: Value := 'Prw(Obr)';
    222: Value := 'Prw(S�a)';
    223: Value := 'Pierwiastek Atk (Atak)';           //Hint
    224: Value := 'Pierwiastek Obr (Obrona)';          //Hint
    225: Value := 'Pierwiastek S�a (S�abo��)';         //Hint
    226: Value := 'Pierwiastek Ognia (Atak)';          //Hint
    227: Value := 'Pierwiastek Ognia (Obrona)';         //Hint
    228: Value := 'Pierwiastek Ognia (S�abo��)';        //Hint
    229: Value := 'Pierwiastek Lodu (Atak)';           //Hint
    230: Value := 'Pierwiastek Lodu (Obrona)';          //Hint
    231: Value := 'Pierwiastek Lodu (S�abo��)';         //Hint
    232: Value := 'Pierwiastek Grzmotu (Atak)';       //Hint
    233: Value := 'Pierwiastek Grzmotu (Obrona)';      //Hint
    234: Value := 'Pierwiastek Grzmotu (S�abo��)';     //Hint
    235: Value := 'Pierwiastek Wiatru (Atak)';          //Hint
    236: Value := 'Pierwiastek Wiatru (Obrona)';         //Hint
    237: Value := 'Pierwiastek Wiatru (S�abo��)';        //Hint
    238: Value := 'Pierwiastek �wi�ty (Atak)';          //Hint
    239: Value := 'Pierwiastek �wi�ty (Obrona)';         //Hint
    240: Value := 'Pierwiastek �wi�ty (S�abo��)';        //Hint
    241: Value := 'Pierwiastek Mroczny (Atak)';          //Hint
    242: Value := 'Pierwiastek Mroczny (Obrona)';         //Hint
    243: Value := 'Pierwiastek Mroczny (S�abo��)';        //Hint
    244: Value := 'Pierwiastek Widmowy (Atak)';       //Hint
    245: Value := 'Pierwiastek Widmowy (Obrona)';      //Hint
    246: Value := 'Pierwiastek Widmowy (S�abo��)';     //Hint
    247..250: Value := 'Reserved';
    { Group Window }
    251: Value := 'Grupa';
    252: Value := 'Zamknij Okno Grupy';             //Hint
    253: Value := 'Dodaj Cz�onka Grupy';            //Hint
    254: Value := 'Usu� Cz�onka Grupy';     //Hint
    255: Value := 'Utw�rz Grup�';                 //Hint
    256: Value := 'Dopu�� Zaproszenia Do Grupy';        //Hint
    257..260: Value := 'Reserved';
    { Magic Window }
    261: Value := ' Ognia  ';                            //Hint
    262: Value := ' Lodu  ';                             //Hint
    263: Value := ' B�yskawicy  ';                       //Hint
    264: Value := ' Wiatru  ';                            //Hint
    265: Value := ' �wi�ty  ';                            //Hint
    266: Value := ' Mroczny  ';                            //Hint
    267: Value := ' Widmowy  ';                         //Hint
    268: Value := ' Fizyczny ';//'Sztuka Walki';         //Hint
    269: Value := 'Zamknij Okno';//'Zamknij Okno Zakl��';//Hint
    270: Value := ' Okrucie�stwa  ';                        //Hint - SE: I have no idea what these 3 should actually be...
    271: Value := ' Zab�jczy  ';                            //Hint - ??
    272: Value := ' Zamachu  ';                     //Hint - ??

    (* Development Strings, not for real play *)
    1050: Value := 'DC 1000-1000';
    1051: Value := 'AC 1000-1000';
    1052: Value := 'BC 1000-1000';
    1053: Value := 'MC 1000-1000';
    1054: Value := 'SC 1000-1000';
    1055: Value := 'MR 1000-1000';
    1056: Value := '+1000';
    1057: Value := '1000/1000';
    1058: Value := '194';
    1059: Value := '3.55 %';
    1060: Value := 'Coly\GameMasterGuild';
    1061: Value := 'Coly�s Spouse';
    1062: Value := '100-100';
    1063: Value := '10000';
    1064: Value := '1000';
    1065: Value := '99';
    1066: Value := '10';
    1067: Value := '+';
    1068: Value := '-';
    1069: Value := 'x';
    1070: Value := '*';

    1071..2000: Value := 'Reserved';
    else Value := 'Unsupported';
  end;

  ////////////////////////////////////////////////////////////////////////////
  ///

  if Assigned(Buffer) then
    CopyMemory(Buffer, PChar(Value), Length(Value));
  Result := Length(Value);
end;

end.
