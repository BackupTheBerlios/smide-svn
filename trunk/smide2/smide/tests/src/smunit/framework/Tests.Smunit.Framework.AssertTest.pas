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
unit Tests.Smunit.Framework.AssertTest;

interface

uses
  Smide.System,
  Smunit.Framework;

type
  TAssertTest = class(TTestCase)
    procedure TestFail;
    procedure TestAssertObjectEquals;
    procedure TestAssertInterfaceEquals;
    procedure TestAssertObjectEqualsNil;
    procedure TestAssertInterfaceEqualsNil;
    procedure TestAssertStringEquals;
    procedure TestAssertNilNotEqualsString;
    procedure TestAssertStringNotEqualsNil;
    procedure TestAssertWideStringEquals;
    procedure TestAssertNilNotEqualsWideString;
    procedure TestAssertWideStringNotEqualsNil;
    procedure TestAssertNilNotEqualsNil;
    procedure TestAssertNil;
    procedure TestAssertNotNil;
    procedure TestAssertTrue;
    procedure TestAssertFalse;
    procedure TestAssertObjectSame;
    procedure TestAssertInterfaceSame;
    procedure TestAssertObjectNotSame;
    procedure TestAssertInterfaceNotSame;
    procedure TestAssertNotSameFailsNil;
    procedure TestAssertBooleanEquals;
  end;

implementation

{ TAssertTest }

procedure TAssertTest.TestAssertObjectEquals;
var
  o: TObject;
  o1, o2: TObject;
begin
  o := TObject.Create;
  try
    AssertEquals(o, o);
  finally
    o.Free;
  end;

  o1 := TObject.Create;
  o2 := TObject.Create;
  try
    try
      AssertEquals(o1, o2);
    except
      on EAssertionFailedException do
        exit;
    end;
  finally
    o1.Free;
    o2.Free;
  end;

  Fail;
end;

procedure TAssertTest.TestAssertObjectEqualsNil;
begin
  AssertEquals(TObject(nil), TObject(nil))
end;

procedure TAssertTest.TestAssertNilNotEqualsNil;
var
  o: TObject;
begin
  try
    o := TObject.Create;
    try
      AssertEquals(nil, o);
    finally
      o.Free;
    end;
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TAssertTest.TestAssertNilNotEqualsString;
var
  P: PChar;
begin
  try
    P := nil;
    AssertEquals(string(P), 'foo');
    Fail();
  except
    on EAssertionFailedException do
      ;
  end;
end;

procedure TAssertTest.TestAssertNilNotEqualsWideString;
var
  P: pwidechar;
begin
  try
    P := nil;
    AssertEquals(WideString(P), 'foo');
    Fail();
  except
    on EAssertionFailedException do
      ;
  end;
end;

procedure TAssertTest.TestAssertNil;
var
  o: TObject;
begin
  o := nil;
  AssertNil(o);
  try
    o := TObject.Create;
    try
      AssertNil(o);
    finally
      o.Free;
    end;
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TAssertTest.TestAssertStringEquals;
begin
  AssertEquals('abc', 'abc');
end;

procedure TAssertTest.TestAssertStringNotEqualsNil;
var
  P: PChar;
begin
  try
    P := nil;
    AssertEquals('foo', string(P));
    Fail();
  except
    on EAssertionFailedException do
      ;
  end;
end;

procedure TAssertTest.TestAssertWideStringEquals;
begin
  AssertEquals(WideString('abc'), 'abc');
end;

procedure TAssertTest.TestAssertWideStringNotEqualsNil;
var
  P: pwidechar;
begin
  try
    P := nil;
    AssertEquals('foo', WideString(P));
    Fail();
  except
    on EAssertionFailedException do
      ;
  end;
end;

procedure TAssertTest.TestFail;
begin
  try
    Fail;
  except
    on EAssertionFailedException do
      exit;
  end;

  raise EAssertionFailedException.Create();
end;

procedure TAssertTest.TestAssertNotNil;
var
  o: TObject;
begin
  o := TObject.Create;
  try
    AssertNotNil(o);
  finally
    o.Free;
  end;
  o := nil;
  try
    AssertNotNil(o);
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TAssertTest.TestAssertTrue;
begin
  AssertTrue(true);
  try
    AssertTrue(false);
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TAssertTest.TestAssertFalse;
begin
  AssertFalse(false);
  try
    AssertFalse(true);
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TAssertTest.TestAssertObjectSame;
var
  o1, o2: TObject;
begin
  o1 := TObject.Create;
  try
    AssertSame(o1, o1);
  finally
    o1.Free;
  end;
  try
    o1 := TObject.Create;
    o2 := TObject.Create;
    try
      AssertSame(o1, o2);
    finally
      o1.Free;
      o2.Free;
    end;
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TAssertTest.TestAssertInterfaceEquals;
var
  o: IInterface;
  o1, o2: IInterface;
begin
  o := TInterfacedObject.Create;
  AssertEquals(o, o);

  o1 := TInterfacedObject.Create;
  o2 := TInterfacedObject.Create;
  try
    AssertEquals(o1, o2);
  except
    on EAssertionFailedException do
      exit;
  end;

  Fail;
end;

procedure TAssertTest.TestAssertInterfaceEqualsNil;
var
  o: IInterface;
begin
  o := nil;
  AssertEquals(o, nil)
end;

procedure TAssertTest.TestAssertInterfaceSame;
var
  o1, o2: IInterface;
begin
  o1 := TInterfacedObject.Create;
  AssertSame(o1, o1);
  try
    o1 := TInterfacedObject.Create;
    o2 := TInterfacedObject.Create;

    AssertSame(o1, o2);
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TAssertTest.TestAssertObjectNotSame;
var
  o1, o2: TObject;
begin
  o1 := TObject.Create;
  o2 := TObject.Create;
  try
    AssertNotSame(o1, TObject(nil));
    AssertNotSame(nil, o1);
    AssertNotSame(o1, o2);
  finally
    o1.Free;
    o2.Free;
  end;

  try
    o1 := TObject.Create;
    try
      AssertNotSame(o1, o1);
    finally
      o1.Free;
    end;
  except
    on EAssertionFailedException do
      exit;
  end;

  Fail;
end;

procedure TAssertTest.TestAssertInterfaceNotSame;
var
  o1: IInterface;
begin
  AssertNotSame(TInterfacedObject.Create as IInterface, nil);
  AssertNotSame(nil, TInterfacedObject.Create as IInterface);
  AssertNotSame(TInterfacedObject.Create as IInterface, TInterfacedObject.Create as IInterface);

  try
    o1 := TInterfacedObject.Create;
    AssertNotSame(o1, o1);
  except
    on EAssertionFailedException do
      exit;
  end;

  Fail;
end;

procedure TAssertTest.TestAssertNotSameFailsNil;
begin
  try
    AssertNotSame(TObject(nil), TObject(nil));
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

procedure TAssertTest.TestAssertBooleanEquals;
begin
  AssertEquals(true, true);
  AssertEquals(false, false);
  try
    AssertEquals(false, true);
  except
    on EAssertionFailedException do
      exit;
  end;
  Fail;
end;

end.

