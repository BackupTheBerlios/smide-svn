{* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is smide2 code.
 *
 * The Initial Developer of the Original Code is
 * Daniel Biehl.
 * Portions created by the Initial Developer are Copyright (C) 2003, 2004
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Daniel Biehl <dbiehl@users.sourceforge.net>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *}
unit Smunit.Runner;

interface

uses
  Smide.System,
  Smide.System.Collections,
  Smide.System.Collections.Specialized,
  Smunit.Framework;

type

  ITestSuiteLoader = interface
    ['{DF3A4352-21FA-41F4-A6AD-5DE2440A5FAF}']
    function Load(SuiteClassName: WideString): TType;
    function ReLoad(AClass: TType): TType;
  end;

  TTestRunStatus = (trsError, trsFailure);

  ITestRunListener = interface
    ['{FC6A91F6-C92A-4498-98DB-683652BA96A2}']
    procedure TestRunStarted(TestSuiteName: WideString; TestCount: Integer);
    procedure TestRunEnded(ElapsedTime: Integer);
    procedure TestRunStopped(ElapsedTime: Integer);
    procedure TestStarted(TestName: WideString);
    procedure TestEnded(TestName: WideString);
    procedure TestFailed(Status: TTestRunStatus; TestName: WideString; Trace: WideString);
  end;

  ITestCollector = interface
    ['{F216CC96-A616-4308-AB45-34527CED09EE}']
    function CollectTests: IStringCollection;
  end;

  TBaseTestRunner = class(TSmideObject, ITestListener)
  private
    //class function GetPreferencesFile: widestring;
    //class procedure ReadPreferences: widestring;

  public // ITestListener
    procedure AddError(Test: ITest; e: Exception);
    procedure AddFailure(Test: ITest; e: EAssertionFailedException);
    procedure EndTest(Test: ITest);
    procedure StartTest(Test: ITest);
  public
    procedure TestStarted(TestName: WideString); virtual; abstract;
    procedure TestEnded(TestName: WideString); virtual; abstract;
    procedure TestFailed(Status: TTestRunStatus; Test: ITest; e: Exception); virtual; abstract;
  protected
    //class procedure SetPreferences(Value: Properties);
    //class function GetPreferences: Properties;
    //class procedure SavePreferences;
    //procedure ProcessArguments(Args: array of widestring);

    procedure RunFailed(Message: WideString); virtual; abstract;

    function LoadSuiteClass(SuiteClassName: WideString): TType; virtual;
    procedure ClearStatus; virtual;
    //class function ShowStackRaw: boolean;
    class function FilterLine(Line: WideString): Boolean; virtual;
  public
    //class procedure SetPreference(Key: widestring; value: Widestring);
    //class function GetPreference(Key: widestring): widestring; overload
    //class function GetPreference(Key: widestring): integer; overload

    function GetTest(SuiteClassName: WideString): ITest; virtual;
    class function ElapsedTimeAsString(Runtime: Integer): WideString; virtual;
    //procedure SetLoading(Value: boolean);
    //function ExtractClassName(ClassName: widestring): widestring;
    //function Truncate(s: widestring): widestring;

    function GetLoader: ITestSuiteLoader; virtual;
    //function UseReloadingTestSuiteLoader: boolean;

    class function GetFilteredTrace(Stack: WideString): WideString; virtual;
  end;

  TStandardTestSuiteLoader = class(TSmideObject, ITestSuiteLoader)
  public
    function Load(SuiteClassName: WideString): TType; virtual;
    function ReLoad(AClass: TType): TType; virtual;
  end;

const
  SUITE_METHODNAME = 'Suite';

implementation

uses
  Smide.System.Types,
  Smide.System.Reflection;

{ TBaseTestRunner }

procedure TBaseTestRunner.AddError(Test: ITest; e: Exception);
begin
  // TODO: with Lock do
  TestFailed(trsError, Test, e);
end;

procedure TBaseTestRunner.AddFailure(Test: ITest; e: EAssertionFailedException);
begin
  // TODO: with Lock do
  TestFailed(trsFailure, Test, e);
end;

procedure TBaseTestRunner.ClearStatus;
begin

end;

class function TBaseTestRunner.ElapsedTimeAsString(Runtime: Integer): WideString;
var
  d: Double;
begin
  d := Runtime / 1000;
  Result := TType.GetType(TypeInfo(Double)).ValueToString(d);
end;

procedure TBaseTestRunner.EndTest(Test: ITest);
begin
  // TODO: with Lock do
  TestEnded(TType.GetTypeHandler(TypeInfo(ITest)).ValueToString(Test));
end;

class function TBaseTestRunner.FilterLine(Line: WideString): Boolean;
const
  patterns: array[0..6] of WideString = (
    'Smunit.Framework.TTestCase',
    'Smunit.Framework.TProtectable',
    'Smunit.Framework.TAssert.',
    'Smunit.Framework.TTestResult',
    'Smunit.Framework.TTestSuite',
    'Smunit.Textui.TTestRunner',
    //'Smide.System.Reflection.Runtime.TRuntimeMethodInfo.InvokeImpl(',
    'Smide.System.Reflection.TMethodBase.Invoke('
    );
var
  i: Integer;
begin
  Result := true;

  for i := 0 to High(patterns) do
    if Pos(patterns[i], Line) > 0 then
      exit;

  Result := false;
end;

class function TBaseTestRunner.GetFilteredTrace(Stack: WideString): WideString;
// TODO: Filter with StringReader & StringWriter
{var
  sr: IStringCollection;
  sw: IStringCollection;}
begin
  { // TODO:
  sr := TStringCollection.Create(Stack);
  sw := TStringCollection.Create;

  with sr.GetEnumerator do
    while MoveNext do
      if not FilterLine(Current) then
        sw.Add(Current);

  Result := sw.Text;
  }
  Result := Stack;
end;

function TBaseTestRunner.GetLoader: ITestSuiteLoader;
begin
  Result := TStandardTestSuiteLoader.Create;
end;

function TBaseTestRunner.GetTest(SuiteClassName: WideString): ITest;
var
  TestClass: TType;
  SuiteMethod: TMethodInfo;
  Test: ITest;
  Params: array of TVarRec;
begin
  Result := nil;
  if SuiteClassName = '' then
  begin
    ClearStatus;
    exit;
  end;

  try
    TestClass := LoadSuiteClass(SuiteClassName);
    if TestClass = nil then
    begin
      RunFailed('Class not found "' + SuiteClassName + '"');
      exit;
    end;
  except
    on e: Exception do
    begin
      RunFailed('Error: ' + e.Message);
      exit;
    end;
  end;

  SuiteMethod := TType.GetType(TestClass).GetMethod(SUITE_METHODNAME, []);

  if SuiteMethod = nil then
  begin
    ClearStatus;
    // TODO: Activator.CreateInstance(TTestClass)
    Result := nil;
    exit;
  end;

  if not SuiteMethod.IsStatic then
  begin
    RunFailed('Suite() method must be static');
    exit;
  end;

  Test := nil;
  try
    SetLength(Params, 0);
    SuiteMethod.Invoke(TestClass, Params, Test);
    if Test = nil then
    begin
      Result := Test;
      exit;
    end;
  except
    on e: Exception do
    begin
      RunFailed('Failed to invoke Suite(): ' + e.Message);
      exit;
    end;
  end;

  ClearStatus;

  Result := Test;
end;

function TBaseTestRunner.LoadSuiteClass(SuiteClassName: WideString): TType;
begin
  Result := GetLoader.Load(SuiteClassName);
end;

procedure TBaseTestRunner.StartTest(Test: ITest);
begin
  // TODO: with Lock do
  TestStarted(TType.GetTypeHandler(TypeInfo(ITest)).ValueToString(Test));
end;

{ TStandardTestSuiteLoader }

function TStandardTestSuiteLoader.Load(SuiteClassName: WideString): TType;
var
  ClassType: TType;
begin
  Result := nil;
  ClassType := TType.GetType(SuiteClassName);

  if ClassType = nil then
    exit;

  if not ClassType.IsClass then
    raise Exception.Create('Type ' + SuiteClassName + ' is not of type class');

  Result := ClassType;
end;

function TStandardTestSuiteLoader.ReLoad(AClass: TType): TType;
begin
  Result := AClass;
end;

end.

