﻿(*******************************************************************
 *   LomCN Mir3 Spanish Language LGU File 2012                     *
 *                                                                 *
 *   Web       : http://www.lomcn.org                              *
 *   Version   : 0.0.0.2                                           *
 *                                                                 *
 *   - File Info -                                                 *
 *                                                                 *
 *   It holds the mir3 spanish language strings.                   *
 *                                                                 *
 *******************************************************************
 * Change History                                                  *
 *                                                                 *
 *  - 0.0.0.1 [2013-02-11] Elamo : first init                      *
 *  - 0.0.0.2 [2013-04-13] Coly : change to UTF8 + code support    *
 *                                                                 *
 *                                                                 *
 *                                                                 *
 *                                                                 *
 *                                                                 *
 *******************************************************************)

library Spanish;

uses
  Windows, 
  SysUtils,
  Classes,
  mir3_language_launcher in 'mir3_language_launcher.pas',
  mir3_language_game     in 'mir3_language_game.pas',
  mir3_language_magic    in 'mir3_language_magic.pas';

{$E lgu}
{$R *.res}

const
  LANGUAGE_FILE_AUTOR   = 'Ashran , Elamo';
  LANGUAGE_FILE_VERSION = $00000002;


function GetFileAutor(Buffer: PWideChar) : Integer; stdcall;
var
  Value : String;
begin
  if Assigned(Buffer) then
  begin
    Value := LANGUAGE_FILE_AUTOR;
    lstrcpynW(Buffer, PWideChar(Value), lstrlenW(PWideChar(Value))+1);
  end;
  Result := lstrlenW(PWideChar(Value))+1;
end;

function GetFileVersion(): Integer; stdcall;
begin
  Result := LANGUAGE_FILE_VERSION;
end;

exports
   GetFileAutor      name 'LomCN_GetFileAutor',
   GetFileVersion    name 'LomCN_GetFileVersion',

   GetLauncherLine   name 'LomCN_GetLauncherLine',
   GetLauncherString name 'LomCN_GetLauncherString',
   
   GetGameLine       name 'LomCN_GetGameLine',
   GetGameString     name 'LomCN_GetGameString',

   GetMagicLine      name 'LomCN_GetMagicLine',
   GetMagicString    name 'LomCN_GetMagicString';

begin
end.
