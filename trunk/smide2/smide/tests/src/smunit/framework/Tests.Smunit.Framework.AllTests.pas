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
unit Tests.Smunit.Framework.AllTests;

interface

uses
  Smunit.Framework,
  Smunit.Textui;

type
  {$TYPEINFO ON}
  {$METHODINFO ON}
  {$WARNINGS OFF}
  TAllTests = class
  public
    class function Suite: ITest;
    class procedure Main;
  end;
  {$WARNINGS ON}

implementation

uses
  Tests.Smunit.Framework.Success,
  Tests.Smunit.Framework.TestCaseTest,
  Tests.Smunit.Framework.AssertTest,
  Tests.Smunit.Framework.DoublePrecisionAssertTest,
  Tests.Smunit.WasRun,
  Tests.Smunit.Framework.NoArgTestCaseTest,
  Tests.Smunit.Framework.SuiteTest,
  Tests.Smunit.Framework.InheritedTestCase,
  Tests.Smunit.Framework.OneTestCase,
  Tests.Smunit.Framework.NoTestCases,
  Tests.Smunit.Framework.NoTestCaseClass,
  Tests.Smunit.Framework.NotPublicTestCase,
  Tests.Smunit.Framework.NotVoidTestCase,
  Tests.Smunit.Framework.OverrideTestCase,
  Tests.Smunit.Framework.TestImplementorTest,
  Tests.Smunit.Framework.TestListenerTest;

{ TAllTests }

class procedure TAllTests.Main;
begin
  Smunit.Textui.TTestRunner.Run(Suite).Free;
end;

class function TAllTests.Suite: ITest;
var
  Suite: TTestSuite;
begin
  Suite := TTestSuite.Create('Smunit Framework Tests');

  Suite.AddTestSuite(TTestCaseTest);
  Suite.AddTest(TSuiteTest.Suite);
  Suite.AddTestSuite(TTestListenerTest);
  Suite.AddTestSuite(TAssertTest);
  Suite.AddTestSuite(TTestImplementorTest);
  Suite.AddTestSuite(TNoArgTestCaseTest);
  // TODO: Suite.AddTestSuite(TComparisonFailureTest)
  Suite.AddTestSuite(TDoublePrecisionAssertTest);

  Result := Suite;
end;

end.

