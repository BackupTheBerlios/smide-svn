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
unit Smunit.Textui;

interface

uses
  Smide.System,
  Smide.System.Collections,
  Smunit.Framework,
  Smunit.Runner;

type
  TResultPrinter = class(TSmideObject, ITestListener)
  protected
    { TODO -odbiehl -csmunit : TResultPrinter use Smide.System.IO.Textwriter}

    procedure AddError(Test: ITest; e: Exception);
    procedure AddFailure(Test: ITest; e: EAssertionFailedException);
    procedure EndTest(Test: ITest);
    procedure StartTest(Test: ITest);

    procedure PrintHeader(Runtime: Integer); virtual;
    procedure PrintErrors(Result: TTestResult); virtual;
    procedure PrintFailures(Result: TTestResult); virtual;
    procedure PrintDefects(BoBoos: IEnumerator; Count: Integer; DefectType: WideString); virtual;
    procedure PrintDefect(booboo: TTestFailure; Count: Integer); virtual;
    procedure PrintDefectHeader(booboo: TTestFailure; Count: Integer); virtual;
    procedure PrintDefectTrace(booboo: TTestFailure); virtual;

    procedure PrintFooter(Result: TTestResult);

    function ElapsedTimeAsString(Runtime: Integer): WideString;
  public
    // TODO: constructor Create(writer: TextWriter);

    procedure Print(Result: TTestResult; Runtime: Integer); virtual;
    procedure PrintWaitPromp; virtual;
  end;

  TTestRunner = class(TBaseTestRunner)
  private
    FPrinter: TResultPrinter;
  protected
    function CreateTestResult: TTestResult; virtual;
    procedure RunFailed(Message: WideString); override;
    procedure Pause(Wait: Boolean); virtual;
  public
    class procedure Run(TestClass: TClass); overload;
    class function Run(Test: ITest): TTestResult; overload;
    class procedure RunAndWait(Test: ITest);
    function DoRun(Suite: ITest; Wait: Boolean = false): TTestResult;

    procedure TestStarted(TestName: WideString); override;
    procedure TestEnded(TestName: WideString); override;
    procedure TestFailed(Status: TTestRunStatus; Test: ITest; e: Exception); override;

    class procedure Main(Args: array of WideString);
    function Start(Args: array of WideString): TTestResult; virtual;

    constructor Create; overload;
    //constructor Create(writer: TClass); overload; // TODO: Create(writer: TTextWriter)
    constructor Create(Printer: TResultPrinter); overload;
    destructor Destroy; override;
  end;

const
  SUCCESS_EXIT = 0;
  FAILURE_EXIT = 1;
  EXCEPTION_EXIT = 2;

  // TODO: Version string
  Version = '@version@';

implementation

{ TResultPrinter }

procedure TResultPrinter.AddError(Test: ITest; e: Exception);
begin
  Write('E');
end;

procedure TResultPrinter.AddFailure(Test: ITest; e: EAssertionFailedException);
begin
  Write('F');
end;

function TResultPrinter.ElapsedTimeAsString(Runtime: Integer): WideString;
begin
  Result := TBaseTestRunner.ElapsedTimeAsString(Runtime);
end;

procedure TResultPrinter.EndTest(Test: ITest);
begin
end;

procedure TResultPrinter.Print(Result: TTestResult; Runtime: Integer);
begin
  PrintHeader(Runtime);
  PrintErrors(Result);
  PrintFailures(Result);
  PrintFooter(Result);
end;

procedure TResultPrinter.PrintDefect(booboo: TTestFailure; Count: Integer);
begin
  PrintDefectHeader(booboo, Count);
  PrintDefectTrace(booboo);
end;

procedure TResultPrinter.PrintDefectHeader(booboo: TTestFailure; Count: Integer);
begin
  Write(Count, ') ', booboo.ToString);
end;

procedure TResultPrinter.PrintDefects(BoBoos: IEnumerator; Count: Integer; DefectType:
  WideString);
begin
  if Count = 0 then
    exit;
  if Count = 1 then
    Writeln('There was ', Count, ' ' + DefectType + ':')
  else
    Writeln('There were ', Count, ' ' + DefectType + 's: ');

  with (BoBoos as ITestFailureEnumerator) do
    while MoveNext do
      PrintDefect(Current, CurrentIndex + 1);
end;

procedure TResultPrinter.PrintDefectTrace(booboo: TTestFailure);
begin
  Write(TBaseTestRunner.GetFilteredTrace(booboo.Trace));
end;

procedure TResultPrinter.PrintErrors(Result: TTestResult);
begin
  PrintDefects(Result.Errors.GetEnumerator, Result.Errors.Count, 'error');
end;

procedure TResultPrinter.PrintFailures(Result: TTestResult);
begin
  PrintDefects(Result.Failures.GetEnumerator, Result.Failures.Count, 'failure');
end;

procedure TResultPrinter.PrintFooter(Result: TTestResult);
begin
  if (Result.WasSuccessful) then
  begin
    Writeln;
    Write('OK');
    Write(' (', Result.RunCount, ' test');
    if Result.RunCount > 1 then
      Write('s');
    Writeln(')');
  end
  else
  begin
    Writeln;
    Writeln('FAILURES!!!');
    Writeln('Tests Run: ', Result.RunCount(),
      ', Failures: ', Result.Failures.Count,
      ', Errors: ', Result.Errors.Count);
  end;
  Writeln;
end;

procedure TResultPrinter.PrintHeader(Runtime: Integer);
begin
  Writeln;
  Writeln('Time: ' + ElapsedTimeAsString(Runtime));
end;

procedure TResultPrinter.PrintWaitPromp;
begin
  Writeln;
  Writeln('<RETURN> to continue');
end;

procedure TResultPrinter.StartTest(Test: ITest);
begin
  Write('.');
end;

{ TTestRunner }

constructor TTestRunner.Create;
begin
  // TODO: Create(System.Out)
  Create(TResultPrinter.Create);
end;

constructor TTestRunner.Create(Printer: TResultPrinter);
begin
  FPrinter := Printer;
end;

destructor TTestRunner.Destroy;
begin
  inherited;
end;

procedure TTestRunner.TestEnded(TestName: WideString);
begin
end;

procedure TTestRunner.TestFailed(Status: TTestRunStatus; Test: ITest; e: Exception);
begin
end;

procedure TTestRunner.TestStarted(TestName: WideString);
begin
end;

function TTestRunner.CreateTestResult: TTestResult;
begin
  Result := TTestResult.Create;
end;

class procedure TTestRunner.Run(TestClass: TClass);
begin
  Run(TTestSuite.Create(TestClass) as ITest).Free;
end;

class function TTestRunner.Run(Test: ITest): TTestResult;
begin
  with TTestRunner.Create do
  try
    Result := DoRun(Test);
  finally
    Free;
  end;
end;

class procedure TTestRunner.RunAndWait(Test: ITest);
begin
  with TTestRunner.Create do
  try
    DoRun(Test, true).Free;
  finally
    Free;
  end;
end;

function TTestRunner.DoRun(Suite: ITest; Wait: Boolean): TTestResult;
var
  StartTime: Integer;
  EndTime: Integer;
  Runtime: Integer;
begin
  Result := CreateTestResult;

  Result.AddListener(FPrinter);

  StartTime := TEnvironment.TickCount;

  // TODO: my we must raise an argumentnil exception
  if Suite = nil then
  begin
    Suite := TTestSuite.Warning('Suite is nil');
  end;

  Suite.Run(Result);

  EndTime := TEnvironment.TickCount;
  Runtime := EndTime - StartTime;
  FPrinter.Print(Result, Runtime);

  Pause(Wait);
end;

procedure TTestRunner.Pause(Wait: Boolean);
begin
  if not Wait then
    exit;
  try
    FPrinter.PrintWaitPromp;
    Readln;
  except
  end
end;

procedure TTestRunner.RunFailed(Message: WideString);
begin
  // TODO: Console.Error.Writeline(Message);
  Writeln(Message);
  Free;
  TEnvironment.exit(FAILURE_EXIT);
end;

class procedure TTestRunner.Main(Args: array of WideString);
var
  TestRunner: TTestRunner;
  r: TTestResult;
  ExitCode: Integer;
begin
  TestRunner := TTestRunner.Create;
  r := nil;
  try
    try
      r := TestRunner.Start(Args);

      if not r.WasSuccessful then
        ExitCode := FAILURE_EXIT
      else
        ExitCode := SUCCESS_EXIT;

    except
      on e: Exception do
      begin
        Writeln(e.Message);
        ExitCode := EXCEPTION_EXIT;
      end;
    end;
  finally
    TestRunner.Free;
    r.Free;
  end;

  TEnvironment.exit(ExitCode);
end;

function TTestRunner.Start(Args: array of WideString): TTestResult;
var
  TestCase: WideString;
  Wait: Boolean;
  i: Integer;
  Suite: ITest;
begin
  Wait := false;
  TestCase := '';

  i := 1;
  while i < Length(Args) do
  begin
    if Args[i] = '-wait' then
      Wait := true
    else
      if Args[i] = '-v' then
        Writeln('Smunit ' + Version + ' by Daniel Biehl')
      else
        TestCase := Args[i];

    Inc(i);
  end;

  if TestCase = '' then
    raise
      Exception.Create('Usage: TestRunner [-wait] TestCaseName, where name is the name of the TestCase class');

  try
    Suite := GetTest(TestCase);
    Result := DoRun(Suite, Wait);
  except
    on e: Exception do
      raise Exception.Create('Could not create and run test suite: ' + e.Message);
  end;
end;

end.

