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
unit Tests.Smunit.Framework.SuiteTest;

interface

uses
  Smunit.Framework;

type
  {$WARNINGS OFF}
  TSuiteTest = class(TTestCase)
  protected
    FResult: TTestResult;
    procedure SetUp; override;
    procedure TearDown; override;
  public
    class function Suite: ITest;

    procedure TestInheritedTests;
    procedure TestNoTestCaseClass;
    procedure TestNoTestCases;
    procedure TestNotExistingTestCase;
    procedure TestNotPublicTestCase;
    procedure TestNotVoidTestCase;
    procedure TestOneTestCase;
    procedure TestShadowedTests;
    procedure TestAddTestSuite;
  end;
  {$WARNINGS ON}

implementation

uses
  Tests.Smunit.Framework.InheritedTestCase,
  Tests.Smunit.Framework.NoTestCases,
  Tests.Smunit.Framework.NoTestCaseClass,
  Tests.Smunit.Framework.NotPublicTestCase,
  Tests.Smunit.Framework.NotVoidTestCase,
  Tests.Smunit.Framework.OneTestCase,
  Tests.Smunit.Framework.OverrideTestCase;

{ TSuiteTest }

procedure TSuiteTest.SetUp;
begin
  FResult := TTestResult.Create;
end;

class function TSuiteTest.Suite: ITest;
var
  Suite: TTestSuite;
begin
  Suite := TTestSuite.Create('Suite Tests');

  // build the suite manually, because some of the suites are testing
  // the functionality that automatically builds suites
  Suite.addTest(TSuiteTest.Create('TestNoTestCaseClass'));
  Suite.addTest(TSuiteTest.Create('TestNoTestCases'));
  Suite.addTest(TSuiteTest.Create('TestOneTestCase'));
  Suite.addTest(TSuiteTest.Create('TestNotPublicTestCase'));
  Suite.addTest(TSuiteTest.Create('TestNotVoidTestCase'));
  Suite.addTest(TSuiteTest.Create('TestNotExistingTestCase'));
  Suite.addTest(TSuiteTest.Create('TestInheritedTests'));
  Suite.addTest(TSuiteTest.Create('TestShadowedTests'));
  Suite.addTest(TSuiteTest.Create('TestAddTestSuite'));

  Result := Suite;
end;

procedure TSuiteTest.TearDown;
begin
  FResult.Free;
end;

procedure TSuiteTest.TestAddTestSuite;
var
  Suite: TTestSuite;
  Test: ITest;
begin
  Suite := TTestSuite.Create;
  Test := Suite;
  Suite.AddTestSuite(TOneTestCase);
  Test.Run(FResult);
  AssertEquals(1, FResult.RunCount);
end;

procedure TSuiteTest.TestInheritedTests;
var
  Suite: ITest;
begin
  Suite := TTestSuite.Create(TInheritedTestCase);
  Suite.Run(FResult);
  AssertTrue(FResult.WasSuccessful);
  AssertEquals(2, FResult.RunCount);
end;

procedure TSuiteTest.TestNoTestCaseClass;
var
  Suite: ITest;
begin
  Suite := TTestSuite.Create(TNoTestCaseClass);
  Suite.Run(FResult);
  AssertTrue(not FResult.WasSuccessful);
  AssertEquals(1, FResult.RunCount);
end;

procedure TSuiteTest.TestNoTestCases;
var
  Suite: ITest;
begin
  Suite := TTestSuite.Create(TNoTestCases);
  Suite.Run(FResult);
  AssertTrue(FResult.RunCount = 1);
  AssertTrue(FResult.Failures.Count = 1);
  AssertTrue(not FResult.WasSuccessful);
end;

procedure TSuiteTest.TestNotExistingTestCase;
var
  Suite: ITest;
begin
  Suite := TSuiteTest.Create('NotExistingMethod');
  Suite.Run(FResult);
  AssertTrue(FResult.RunCount = 1);
  AssertTrue(FResult.Failures.Count = 1);
  AssertTrue(FResult.Errors.Count = 0);
end;

procedure TSuiteTest.TestNotPublicTestCase;
var
  Suite: ITest;
begin
  Suite := TTestSuite.Create(TNotPublicTestCase);
  AssertEquals(1, Suite.CountTestCases);
end;

procedure TSuiteTest.TestNotVoidTestCase;
var
  Suite: ITest;
begin
  Suite := TTestSuite.Create(TNotVoidTestCase);
  AssertEquals(1, Suite.CountTestCases);
end;

procedure TSuiteTest.TestOneTestCase;
var
  Suite: ITest;
begin
  Suite := TTestSuite.Create(TOneTestCase);
  Suite.Run(FResult);
  AssertEquals(1, FResult.RunCount);
  AssertEquals(0, FResult.Failures.Count);
  AssertEquals(0, FResult.Errors.Count);
  AssertTrue(FResult.WasSuccessful);
end;

procedure TSuiteTest.TestShadowedTests;
var
  Suite: ITest;
begin
  Suite := TTestSuite.Create(TOverrideTestCase);
  Suite.Run(FResult);
  AssertEquals(1, FResult.RunCount);
end;

end.

