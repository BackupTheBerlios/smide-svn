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
unit Tests.Smunit.Framework.TestCaseTest;

interface

uses
  Smide.System,
  Smunit.Framework;

type
  TTestCaseTest = class(TTestCase)
  protected
    procedure VerifyError(Test: ITest);
    procedure VerifySuccess(Test: ITest);
    procedure VerifyFailure(Test: ITest);
  public
    procedure TestCaseToString;
    procedure TestError;
    procedure TestRunAndTearDownFails;
    procedure TestSetupFails;
    procedure TestSuccess;
    procedure TestFailure;
    procedure TestTearDownAfterError;
    procedure TestTearDownFails;
    procedure TestTearDownSetupFails;
    procedure TestWasRun;
    procedure TestExceptionRunningAndTearDown;
    procedure TestNoArgTestCasePasses;
    procedure TestNamelessTestCase;
  end;

implementation

uses
  Tests.Smunit.Framework.Success,
  Tests.Smunit.WasRun,
  Tests.Smunit.Framework.NoArgTestCaseTest;

type
  TTornDown = class(TTestCase)
  private
    FTornDown: Boolean;
  protected
    procedure TearDown; override;
    procedure RunTest; override;
  end;

  { TTornDown }

procedure TTornDown.RunTest;
begin
  raise Exception.Create;
end;

procedure TTornDown.TearDown;
begin
  FTornDown := true;
end;

{ TTestCaseTest }

procedure TTestCaseTest.VerifyError(Test: ITest);
var
  Result: TTestResult;
begin
  Result := TTestResult.Create;
  try
    Test.Run(Result);
    AssertTrue(Result.RunCount = 1);
    AssertTrue(Result.Failures.Count = 0);
    AssertTrue(Result.Errors.Count = 1);
  finally
    Result.Free;
  end;
end;

procedure TTestCaseTest.VerifySuccess(Test: ITest);
var
  Result: TTestResult;
begin
  Result := TTestResult.Create;
  try
    Test.Run(Result);
    AssertTrue(Result.RunCount = 1);
    AssertTrue(Result.Failures.Count = 0);
    AssertTrue(Result.Errors.Count = 0);
  finally
    Result.Free;
  end;
end;

procedure TTestCaseTest.VerifyFailure(Test: ITest);
var
  Result: TTestResult;
begin
  Result := TTestResult.Create;
  try
    Test.Run(Result);
    AssertTrue(Result.RunCount = 1);
    AssertTrue(Result.Failures.Count = 1);
    AssertTrue(Result.Errors.Count = 0);
  finally
    Result.Free;
  end;
end;

procedure TTestCaseTest.TestCaseToString;
begin
  AssertEquals('TestCaseToString(Tests.Smunit.Framework.TestCaseTest.TTestCaseTest)', toString);
end;

type
  TTestErrorTestCase = class(TTestCase)
  protected
    procedure RunTest; override;
  end;

procedure TTestErrorTestCase.RunTest;
begin
  raise Exception.Create;
end;

procedure TTestCaseTest.TestError;
begin
  VerifyError(TTestErrorTestCase.Create);
end;

type
  TTestRunAndTearDownFailsTestCase = class(TTornDown)
  protected
    procedure TearDown; override;
  end;

procedure TTestRunAndTearDownFailsTestCase.TearDown;
begin
  inherited;
  raise Exception.Create;
end;

procedure TTestCaseTest.TestRunAndTearDownFails;
var
  Test: TTestRunAndTearDownFailsTestCase;
  TestIntf: ITest;
begin
  Test := TTestRunAndTearDownFailsTestCase.Create();
  TestIntf := Test;
  VerifyError(TestIntf);
  AssertTrue(Test.FTornDown);
end;

type
  TTestSetupFailsTestCase = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure RunTest; override;
  end;

procedure TTestSetupFailsTestCase.RunTest;
begin
end;

procedure TTestSetupFailsTestCase.SetUp;
begin
  raise Exception.Create;
end;

procedure TTestCaseTest.TestSetupFails;
begin
  VerifyError(TTestSetupFailsTestCase.Create);
end;

procedure TTestCaseTest.TestSuccess;
begin
  VerifySuccess(TSuccess.Create);
end;

type
  TTestFailureTestCase = class(TTestCase)
  protected
    procedure RunTest; override;
  end;

procedure TTestFailureTestCase.RunTest;
begin
  Fail;
end;

procedure TTestCaseTest.TestFailure;
begin
  VerifyFailure(TTestFailureTestCase.Create);
end;

procedure TTestCaseTest.TestTearDownAfterError;
var
  Test: TTornDown;
  TestIntf: ITest;
begin
  Test := TTornDown.Create();
  TestIntf := Test;
  VerifyError(TestIntf);
  AssertTrue(Test.FTornDown);
end;

type
  TTestTearDownFailsTestCase = class(TTestCase)
  protected
    procedure TearDown; override;
    procedure RunTest; override;
  end;

procedure TTestTearDownFailsTestCase.RunTest;
begin
end;

procedure TTestTearDownFailsTestCase.TearDown;
begin
  raise Exception.Create;
end;

procedure TTestCaseTest.TestTearDownFails;
begin
  VerifyError(TTestTearDownFailsTestCase.Create);
end;

type
  TTestTearDownSetupFailsTestCase = class(TTornDown)
  protected
    procedure SetUp; override;
  end;

procedure TTestTearDownSetupFailsTestCase.SetUp;
begin
  raise Exception.Create;
end;

procedure TTestCaseTest.TestTearDownSetupFails;
var
  Test: TTestTearDownSetupFailsTestCase;
  TestIntf: ITest;
begin
  Test := TTestTearDownSetupFailsTestCase.Create;
  TestIntf := Test;
  VerifyError(Test);
  AssertTrue(not Test.FTornDown);
end;

procedure TTestCaseTest.TestWasRun;
var
  Test: TWasRun;
  TestIntf: ITest;
begin
  Test := TWasRun.Create;
  TestIntf := Test;
  Test.Run.Free;
  AssertTrue(Test.FWasRun);
end;

type
  TTestExceptionRunningAndTearDownTestCase = class(TTornDown)
  protected
    procedure TearDown; override;
  end;

procedure TTestExceptionRunningAndTearDownTestCase.TearDown;
begin
  raise Exception.Create('TearDown');
end;

procedure TTestCaseTest.TestExceptionRunningAndTearDown;
var
  Result: TTestResult;
  Test: ITest;
begin
  Result := TTestResult.Create;
  Test := TTestExceptionRunningAndTearDownTestCase.Create;
  try
    Test.Run(Result);
    AssertEquals('TearDown', Result.Errors[0].ExceptionMessage);
  finally
    Result.Free;
  end;
end;

procedure TTestCaseTest.TestNoArgTestCasePasses;
var
  Test: ITest;
  Result: TTestResult;
begin
  Test := TTestSuite.Create(TNoArgTestCaseTest);
  Result := TTestResult.Create;
  try
    Test.Run(Result);
    AssertTrue(Result.RunCount = 1);
    AssertTrue(Result.Failures.Count = 0);
    AssertTrue(Result.Errors.Count = 0);
  finally
    Result.Free;
  end;
end;

procedure TTestCaseTest.TestNamelessTestCase;
var
  Test: TTestCase;
  TestIntf: ITest;
begin
  Test := TTestCase.Create;
  TestIntf := Test;

  with Test.Run do
  try
    AssertTrue(Failures.Count = 1);
  finally
    Free;
  end;
end;

end.

