unit Smide.System.Runtime.Environment;

interface

uses
  Smide.System.Common,
  Smide.System.Types;

type
  TEnvironment = class(TStaticBase)
  protected
  public
    class procedure exit(ExitCode: Integer);
    // TODO: class function ExpandEnvironmentVariables(Name: string): string;
    class function GetCommandLineArgs: TWideStringArray;
    // TODO: class function GetEnvironmentVariable(variable: string): string;
    // TODO: class function GetEnvironmentVariables: IDictionary;
    // TODO: class function GetFolderPath(folder: SpecialFolder): string;
    // TODO: class function GetLogicalDrives: array of string;
    // TODO: private class function GetResourceString(key: String; array of values: array of TObject): String;
    // TODO: private class function GetStackTrace(e: Exception): String;
    // TODO: private class function nativeGetEnvironmentVariable(variable: String): String;
    // TODO: private class function nativeGetVersion: String;
    // TODO: private class function nativeGetWorkingSet: Int64;

    class function CommandLine: WideString;
    // TODO: public class function get_CurrentDirectory: String;
    // TODO: public class procedure set_CurrentDirectory(value: String);
    // TODO: property CurrentDirectory: String read get_CurrentDirectory write set_CurrentDirectory;
    // TODO: public class function get_ExitCode: Integer;
    // TODO: public class procedure set_ExitCode(value: Integer);
    // TODO: property ExitCode: Integer read get_ExitCode write set_ExitCode;
    // TODO: public class function get_HasShutdownStarted: Boolean;
    // TODO: property HasShutdownStarted: Boolean read get_HasShutdownStarted;
    // TODO: public class function get_MachineName: String;
    // TODO: property MachineName: String read get_MachineName;

    class function NewLine: WideString;

    // TODO: private class function get_OSInfo: OSName;
    // TODO: property OSInfo: OSName read get_OSInfo;
    // TODO: public class function get_OSVersion: OperatingSystem;
    // TODO: property OSVersion: OperatingSystem read get_OSVersion;
    // TODO: public class function get_StackTrace: String;
    // TODO: property StackTrace: String read get_StackTrace;
    // TODO: public class function get_SystemDirectory: String;
    // TODO: property SystemDirectory: String read get_SystemDirectory;

    class function TickCount: Integer;

    // TODO: public class function get_UserDomainName: String;
    // TODO: property UserDomainName: String read get_UserDomainName;
    // TODO: public class function get_UserInteractive: Boolean;
    // TODO: property UserInteractive: Boolean read get_UserInteractive;
    // TODO: public class function get_UserName: String;
    // TODO: property UserName: String read get_UserName;
    // TODO: public class function get_Version: Version;
    // TODO: property Version: Version read get_Version;
    // TODO: public class function get_WorkingSet: Int64;
    // TODO: property WorkingSet: Int64 read get_WorkingSet;
    // TODO: private static m_loadingResource: Boolean;
    // TODO: private static m_resMgrLockObject: TObject;
    // TODO: private static SystemResMgr: ResourceManager;
    // TODO: type
    // TODO:
    // TODO: private OSName = (
    // TODO:  Invalid: OSName = 0;
    // TODO: Nt4: OSName = 129;
    // TODO: Unknown: OSName = 1;
    // TODO: Win2k: OSName = 130;
    // TODO: Win95: OSName = 65;
    // TODO: Win98: OSName = 66;
    // TODO: Win9x: OSName = 64;
    // TODO: WinMe: OSName = 67;
    // TODO: WinNT: OSName = 128;
    // TODO:
    // TODO: );
    // TODO:
    // TODO: public SpecialFolder = (
    // TODO:  ApplicationData: SpecialFolder = 26;
    // TODO: CommonApplicationData: SpecialFolder = 35;
    // TODO: CommonProgramFiles: SpecialFolder = 43;
    // TODO: Cookies: SpecialFolder = 33;
    // TODO: Desktop: SpecialFolder = 0;
    // TODO: DesktopDirectory: SpecialFolder = 16;
    // TODO: Favorites: SpecialFolder = 6;
    // TODO: History: SpecialFolder = 34;
    // TODO: InternetCache: SpecialFolder = 32;
    // TODO: LocalApplicationData: SpecialFolder = 28;
    // TODO: MyComputer: SpecialFolder = 17;
    // TODO: MyMusic: SpecialFolder = 13;
    // TODO: MyPictures: SpecialFolder = 39;
    // TODO: Personal: SpecialFolder = 5;
    // TODO: ProgramFiles: SpecialFolder = 38;
    // TODO: Programs: SpecialFolder = 2;
    // TODO: Recent: SpecialFolder = 8;
    // TODO: SendTo: SpecialFolder = 9;
    // TODO: StartMenu: SpecialFolder = 11;
    // TODO: Startup: SpecialFolder = 7;
    // TODO: System: SpecialFolder = 37;
    // TODO: Templates: SpecialFolder = 21;
  end;

implementation

uses
  Windows;

{ TEnvironment }

class function TEnvironment.CommandLine: WideString;
begin
  Result := GetCommandLineW;
end;

class procedure TEnvironment.exit(ExitCode: Integer);
begin
  Halt(ExitCode);
end;

class function TEnvironment.GetCommandLineArgs: TWideStringArray;

  function GetParamStr(P: PWideChar; var Param: WideString): PWideChar;
  var
    i, Len: Integer;
    Start, S, Q: PWideChar;
  begin
    while true do
    begin
      while (P[0] <> #0) and (P[0] <= ' ') do
        P := CharNextW(P);
      if (P[0] = '"') and (P[1] = '"') then
        Inc(P, 2)
      else
        Break;
    end;
    Len := 0;
    Start := P;
    while P[0] > ' ' do
    begin
      if P[0] = '"' then
      begin
        P := CharNextW(P);
        while (P[0] <> #0) and (P[0] <> '"') do
        begin
          Q := CharNextW(P);
          Inc(Len, Q - P);
          P := Q;
        end;
        if P[0] <> #0 then
          P := CharNextW(P);
      end
      else
      begin
        Q := CharNextW(P);
        Inc(Len, Q - P);
        P := Q;
      end;
    end;

    SetLength(Param, Len);

    P := Start;
    S := Pointer(Param);
    i := 0;
    while P[0] > ' ' do
    begin
      if P[0] = '"' then
      begin
        P := CharNextW(P);
        while (P[0] <> #0) and (P[0] <> '"') do
        begin
          Q := CharNextW(P);
          while P < Q do
          begin
            S[i] := P^;
            Inc(P);
            Inc(i);
          end;
        end;
        if P[0] <> #0 then P := CharNextW(P);
      end
      else
      begin
        Q := CharNextW(P);
        while P < Q do
        begin
          S[i] := P^;
          Inc(P);
          Inc(i);
        end;
      end;
    end;

    Result := P;
  end;

var
  P: PWideChar;
  S: WideString;
begin
  SetLength(Result, 0);
  P := PWideChar(CommandLine);

  while true do
  begin
    P := GetParamStr(P, S);
    if S = '' then Break;
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result) - 1] := S;
  end;
end;

class function TEnvironment.NewLine: WideString;
begin
  Result := #13#10;
end;

class function TEnvironment.TickCount: Integer;
begin
  Result := Windows.GetTickCount;
end;

end.
