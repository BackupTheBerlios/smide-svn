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
unit Tests.Smunit.Framework.TestListenerTest;

interface

uses
  Smide.System,
  Smunit.Framework;

type
  TTestListenerTest = class(TTestCase, ITestListener)
  private
    FResult: TTestResult;
    FStartCount: Integer;
    FEndCount: Integer;
    FFailureCount: Integer;
    FErrorCount: Integer;
    procedure AddError(Test: ITest; e: Exception);
    procedure AddFailure(Test: ITest; e: EAssertionFailedException);
    procedure EndTest(Test: ITest);
    procedure StartTest(Test: ITest);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestError;
    procedure TestFailure;
    procedure TestStartStop;
  end;

implementation

{ TTestListenerTest }

procedure TTestListenerTest.AddError(Test: ITest; e: Exception);
begin
  Inc(FErrorCount);
end;

procedure TTestListenerTest.AddFailure(Test: ITest; e: EAssertionFailedException);
begin
  Inc(FFailureCount);
end;

procedure TTestListenerTest.EndTest(Test: ITest);
begin
  Inc(FEndCount);
end;

procedure TTestListenerTest.SetUp;
begin
  FResult := TTestResult.Create;
  FResult.AddListener(Self);

  FStartCount := 0;
  FEndCount := 0;
  FFailureCount := 0;
  FErrorCount := 0;
end;

procedure TTestListenerTest.StartTest(Test: ITest);
begin
  Inc(FStartCount);
end;

procedure TTestListenerTest.TearDown;
begin
  FResult.Free;
end;

type
  TTestErrorTestCase = class(TTestCase)
    procedure RunTest; override;
  end;

procedure TTestErrorTestCase.RunTest;
begin
  raise Exception.Create;
end;

procedure TTestListenerTest.TestError;
var
  Test: ITest;
begin
  Test := TTestErrorTestCase.Create('noop');
  Test.Run(FResult);
  AssertEquals(1, FErrorCount);
  AssertEquals(1, FEndCount);
end;

type
  TTestFailureTestCase = class(TTestCase)
    procedure RunTest; override;
  end;

procedure TTestFailureTestCase.RunTest;
begin
  Fail;
end;

procedure TTestListenerTest.TestFailure;
var
  Test: ITest;
begin
  Test := TTestFailureTestCase.Create('noop');
  Test.Run(FResult);
  AssertEquals(1, FFailureCount);
  AssertEquals(1, FEndCount);
end;

type
  TTestStartStopTestCase = class(TTestCase)
    procedure RunTest; override;
  end;

procedure TTestStartStopTestCase.RunTest;
begin
end;

procedure TTestListenerTest.TestStartStop;
var
  Test: ITest;
begin
  Test := TTestStartStopTestCase.Create('noop');
  Test.Run(FResult);
  AssertEquals(1, FStartCount);
  AssertEquals(1, FEndCount);
end;

end.

