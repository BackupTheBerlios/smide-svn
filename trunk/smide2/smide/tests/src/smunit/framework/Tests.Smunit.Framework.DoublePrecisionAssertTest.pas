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
unit Tests.Smunit.Framework.DoublePrecisionAssertTest;

interface

uses
  Smunit.Framework,
  Smide.System.Types;

type
  TDoublePrecisionAssertTest = class(TTestCase)
    procedure TestAssertEquals;
    procedure TestAssertEqualsDouble;
    procedure TestAssertEqualsSingle;
    procedure TestAssertEqualsComp;
    procedure TestAssertEqualsExtendedDouble;
    procedure TestAssertEqualsNaNFails;
    procedure TestAssertNaNEqualsFails;
    procedure TestAssertNaNEqualsNaNFails;
    procedure TestAssertPosInfinityNotEqualsNegInfinity;
    procedure TestAssertPosInfinityNotEquals;
    procedure TestAssertPosInfinityEqualsInfinity;
    procedure TestAssertNegInfinityEqualsInfinity;
  end;

implementation

{ TDoublePrecisionAssertTest }

procedure TDoublePrecisionAssertTest.TestAssertEquals;
begin
  AssertEquals(1.234, 1.234, 0);
end;

procedure TDoublePrecisionAssertTest.TestAssertEqualsComp;
var
  c, c1: comp;
begin
  c := 1.234;
  c1 := 1.234;
  AssertEquals(c, c1);
  c := 12.0;
  c1 := 11.99;
  AssertEquals(c, c1, 0.01);
end;

procedure TDoublePrecisionAssertTest.TestAssertEqualsDouble;
var
  d, d1: double;
begin
  d := 1.234;
  d1 := 1.234;
  AssertEquals(d, d1);
  d := 12.0;
  d1 := 11.99;
  AssertEquals(d, d1, 0.01);
end;

procedure TDoublePrecisionAssertTest.TestAssertEqualsExtendedDouble;
var
  d: double;
  e: extended;
begin
  d := 1.234;
  e := 1.234;
  AssertEquals(d, e, 0);
end;

procedure TDoublePrecisionAssertTest.TestAssertEqualsNaNFails;
begin
  try
    AssertEquals(1.234, 0.0 / 0.0, 0);
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TDoublePrecisionAssertTest.TestAssertEqualsSingle;
var
  s, s1: single;
begin
  s := 1.234;
  s1 := 1.234;
  AssertEquals(s, s1);
end;

procedure TDoublePrecisionAssertTest.TestAssertNaNEqualsFails;
begin
  try
    AssertEquals(0.0 / 0.0, 1.234, 0);
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TDoublePrecisionAssertTest.TestAssertNaNEqualsNaNFails;
begin
  try
    AssertEquals(0.0 / 0.0, 0.0 / 0.0, 0);
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TDoublePrecisionAssertTest.TestAssertNegInfinityEqualsInfinity;
begin
  AssertEquals( -1.0 / 0.0,  -1.0 / 0.0, 0);
end;

procedure TDoublePrecisionAssertTest.TestAssertPosInfinityEqualsInfinity;
begin
  AssertEquals(1.0 / 0.0, 1.0 / 0.0, 0);
end;

procedure TDoublePrecisionAssertTest.TestAssertPosInfinityNotEquals;
begin
  try
    AssertEquals(1.0 / 0.0, 1.23, 0);
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TDoublePrecisionAssertTest.TestAssertPosInfinityNotEqualsNegInfinity;
begin
  try
    AssertEquals(1.0 / 0.0, -1.0 / 0.0, 0);
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

end.

