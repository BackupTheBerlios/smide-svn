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

unit Tests.Smunit.Framework.TestImplementorTest;

interface

uses
  Smide.System,
  Smunit.Framework;

type
  TDoubleTestCase = class(TSmideObject, ITest)
  private
    FTestCase: TTestCase;

  public
    constructor Create(TestCase: TTestCase);
    destructor Destroy; override;

    function CountTestCases: Integer;
    procedure Run(Result: TTestResult);
  end;

  TTestImplementorTest = class(TTestCase)
  private
    FTest: ITest;
  public
    constructor Create; override;

    procedure TestSuccessfulRun;
  end;

implementation

{ TDoubleTestCase }

function TDoubleTestCase.CountTestCases: Integer;
begin
  Result := 2;
end;

constructor TDoubleTestCase.Create(TestCase: TTestCase);
begin
  FTestCase := TestCase;
end;

destructor TDoubleTestCase.Destroy;
begin
  FTestCase.Free;
  inherited;
end;

type
  TProtectable = class(TSmideObject, IProtectable)
    FTest: TTestCase;
    constructor Create(Test: TTestCase);
    procedure Protect;
  end;

constructor TProtectable.Create(Test: TTestCase);
begin
  inherited Create;
  FTest := Test;
end;

procedure TProtectable.Protect;
begin
  FTest.RunBare;
  FTest.RunBare;
end;

procedure TDoubleTestCase.Run(Result: TTestResult);
begin
  Result.StartTest(Self);

  Result.RunProtected(Self, TProtectable.Create(FTestCase));
  Result.EndTest(Self);
end;

{ TTestImplementorTest }

type
  TTestImplementorTestTestCase = class(TTestCase)
    procedure RunTest; override;
  end;

procedure TTestImplementorTestTestCase.RunTest;
begin
end;

constructor TTestImplementorTest.Create;
begin
  FTest := TDoubleTestCase.Create(TTestImplementorTestTestCase.Create);
end;

procedure TTestImplementorTest.TestSuccessfulRun;
var
  Result: TTestResult;
begin
  Result := TTestResult.Create;
  try
    FTest.Run(Result);

    AssertEquals(FTest.CountTestCases, Result.RunCount());
    AssertEquals(0, Result.Errors.Count);
    AssertEquals(0, Result.Failures.Count);

  finally
    Result.Free;
  end;
end;

end.

