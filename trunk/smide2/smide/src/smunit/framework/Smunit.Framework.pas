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
unit Smunit.Framework;

interface

uses
  Smide.System,
  Smide.System.Collections,
  Smide.System.Collections.Specialized,
  Smide.System.Reflection,
  Smide.System.Types;

type
  EAssertionFailedException = class(Exception)
  public
  end;

  EComparisonFailure = class(EAssertionFailedException)
  private
    FExpected: WideString;
    FActual: WideString;
    FExcepted: WideString;
  protected
    function get_Message: WideString; override;
  public
    constructor Create(Message: WideString; Expected: WideString; Actual: WideString); overload;
    property Expected: WideString read FExcepted;
    property Actual: WideString read FActual;
  end;

  TAssert = class(TSmideObject)
  public
    class procedure AssertTrue(Message: WideString; Condition: Boolean); overload;
    class procedure AssertTrue(Condition: Boolean); overload;
    class procedure AssertFalse(Message: WideString; Condition: Boolean); overload;
    class procedure AssertFalse(Condition: Boolean); overload;
    class procedure Fail(Message: WideString); overload;
    class procedure Fail; overload;

    class procedure AssertEquals(Message: WideString; TypeHandler: ITypeHandler; const Expected; const Actual); overload;
    class procedure AssertEquals(TypeHandler: ITypeHandler; const Expected; const Actual); overload;
    class procedure AssertSame(Message: WideString; TypeHandler: ITypeHandler; const Expected; const Actual); overload;
    class procedure AssertSame(TypeHandler: ITypeHandler; const Expected; const Actual); overload;
    class procedure AssertNotSame(Message: WideString; TypeHandler: ITypeHandler; const Expected; const Actual); overload;
    class procedure AssertNotSame(TypeHandler: ITypeHandler; const Expected; const Actual); overload;

    class procedure AssertEquals(Message: WideString; Expected, Actual: TTypeData); overload;
    class procedure AssertEquals(Expected, Actual: TTypeData); overload;

    class procedure AssertEquals(Message: WideString; Expected, Actual: TObject); overload;
    class procedure AssertEquals(Expected, Actual: TObject); overload;

    class procedure AssertEquals(Message: WideString; Expected, Actual: IInterface); overload;
    class procedure AssertEquals(Expected, Actual: IInterface); overload;

    class procedure AssertEquals(Message: WideString; Expected, Actual: string); overload;
    class procedure AssertEquals(Expected, Actual: string); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: WideString); overload;
    class procedure AssertEquals(Expected, Actual: WideString); overload;

    class procedure AssertEquals(Message: WideString; Expected, Actual: Extended; Delta: Extended = 0); overload;
    class procedure AssertEquals(Expected, Actual: Extended; Delta: Extended = 0); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: Double; Delta: Double = 0); overload;
    class procedure AssertEquals(Expected, Actual: Double; Delta: Double = 0); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: Single; Delta: Single = 0); overload;
    class procedure AssertEquals(Expected, Actual: Single; Delta: Single = 0); overload;

    class procedure AssertEquals(Message: WideString; Expected, Actual: Boolean); overload;
    class procedure AssertEquals(Expected, Actual: Boolean); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: Byte); overload;
    class procedure AssertEquals(Expected, Actual: Byte); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: Char); overload;
    class procedure AssertEquals(Expected, Actual: Char); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: ShortInt); overload;
    class procedure AssertEquals(Expected, Actual: ShortInt); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: SmallInt); overload;
    class procedure AssertEquals(Expected, Actual: SmallInt); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: Integer); overload;
    class procedure AssertEquals(Expected, Actual: Integer); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: Int64); overload;
    class procedure AssertEquals(Expected, Actual: Int64); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: Word); overload;
    class procedure AssertEquals(Expected, Actual: Word); overload;
    class procedure AssertEquals(Message: WideString; Expected, Actual: LongWord); overload;
    class procedure AssertEquals(Expected, Actual: LongWord); overload;
    class procedure AssertNotNil(Data: TTypeData); overload;
    class procedure AssertNotNil(Obj: TObject); overload;
    class procedure AssertNotNil(Intf: IInterface); overload;
    class procedure AssertNotNil(Message: WideString; Data: TTypeData); overload;
    class procedure AssertNotNil(Message: WideString; Obj: TObject); overload;
    class procedure AssertNotNil(Message: WideString; Intf: IInterface); overload;
    class procedure AssertNil(Data: TTypeData); overload;
    class procedure AssertNil(Obj: TObject); overload;
    class procedure AssertNil(Intf: IInterface); overload;
    class procedure AssertNil(Message: WideString; Data: TTypeData); overload;
    class procedure AssertNil(Message: WideString; Obj: TObject); overload;
    class procedure AssertNil(Message: WideString; Intf: IInterface); overload;
    class procedure AssertSame(Expected, Actual: TTypeData); overload;
    class procedure AssertSame(Expected, Actual: TObject); overload;
    class procedure AssertSame(Expected, Actual: IInterface); overload;
    class procedure AssertSame(Message: WideString; Expected, Actual: TTypeData); overload;
    class procedure AssertSame(Message: WideString; Expected, Actual: TObject); overload;
    class procedure AssertSame(Message: WideString; Expected, Actual: IInterface); overload;
    class procedure AssertNotSame(Message: WideString; Expected, Actual: TObject); overload;
    class procedure AssertNotSame(Message: WideString; Expected, Actual: IInterface); overload;
    class procedure AssertNotSame(Expected, Actual: TObject); overload;
    class procedure AssertNotSame(Expected, Actual: IInterface); overload;

    class procedure AssertNotEmpty(s: string); overload;
    class procedure AssertNotEmpty(Message: WideString; s: string); overload;
    class procedure AssertNotEmpty(s: WideString); overload;
    class procedure AssertNotEmpty(Message: WideString; s: WideString); overload;
    class procedure AssertEmpty(s: string); overload;
    class procedure AssertEmpty(Message: WideString; s: string); overload;
    class procedure AssertEmpty(s: WideString); overload;
    class procedure AssertEmpty(Message: WideString; s: WideString); overload;

    class function Format(Message, Expected, Actual: WideString): WideString;
  private
    class procedure FailSame(Message: WideString);
    class procedure FailNotSame(Message: WideString; TypeHandler: ITypeHandler; const Expected, Actual);
    class procedure FailNotEquals(Message: WideString; TypeHandler: ITypeHandler; const Expected, Actual);
  end;

  IProtectable = interface
    ['{FAA2790F-5E91-4592-88D5-B252482082E6}']
    procedure Protect;
  end;

  TTestResult = class;
  TTestFailureCollection = class;

  {$METHODINFO ON}
  TTestCase = class;
  {$METHODINFO OFF}

  ITest = interface;

  ITestListener = interface
    ['{52790B2B-907C-41DC-9ECB-4D1606F16131}']
    procedure AddError(Test: ITest; e: Exception);
    procedure AddFailure(Test: ITest; e: EAssertionFailedException);
    procedure EndTest(Test: ITest);
    procedure StartTest(Test: ITest);
  end;

  ITestListenerEnumerator = interface(IEnumerator)
    ['{D31FC038-356C-4132-9CE4-B9E0BB71243B}']
    function GetCurrent: ITestListener;
    property Current: ITestListener read GetCurrent;
  end;

  TTestListenerEnumerator = class(TEnumeratorBase, ITestListenerEnumerator)
  protected
    function GetCurrent: ITestListener;
  public
    property Current: ITestListener read GetCurrent;
  end;

  TTestListenerCollection = class(TCollectionBase)
  private
    function GetItem(Index: Integer): ITestListener;
    procedure SetItem(Index: Integer; const Value: ITestListener);
  protected
    function get_TypeHandler: ITypeHandler; override;
  public
    function Add(const Value: ITestListener): Integer;
    procedure Insert(Index: Integer; const Value: ITestListener);
    procedure Remove(const Value: ITestListener);
    function Contains(const Value: ITestListener): Boolean;
    function IndexOf(const Value: ITestListener): Integer;
    procedure GetEnumerator(out Enumerator: IEnumerator); override;
    function GetEnumerator: ITestListenerEnumerator; overload; virtual;

    property Items[Index: Integer]: ITestListener read GetItem write SetItem;
  end;

  ITest = interface
    ['{B1D64F2B-E41B-4F2E-9C0A-60CFA2ED89C1}']
    function CountTestCases: Integer;
    procedure Run(Result: TTestResult);
  end;

  ITestEnumerator = interface(IEnumerator)
    ['{D31FC038-356C-4132-9CE4-B9E0BB71243B}']
    function GetCurrent: ITest;
    property Current: ITest read GetCurrent;
  end;

  TTestEnumerator = class(TEnumeratorBase, ITestEnumerator)
  protected
    function GetCurrent: ITest;
  public
    property Current: ITest read GetCurrent;
  end;

  TTestCollection = class(TCollectionBase)
  private
    function GetItem(Index: Integer): ITest;
    procedure SetItem(Index: Integer; const Value: ITest);
  protected
    function get_TypeHandler: ITypeHandler; override;
  public
    function Add(const Value: ITest): Integer;
    procedure Insert(Index: Integer; const Value: ITest);
    procedure Remove(const Value: ITest);
    function Contains(const Value: ITest): Boolean;
    function IndexOf(const Value: ITest): Integer;
    procedure GetEnumerator(out Enumerator: IEnumerator); override;
    function GetEnumerator: ITestEnumerator; overload; virtual;

    property Items[Index: Integer]: ITest read GetItem write SetItem;
  end;

  TTestCase = class(TAssert, ITest)
  private
    FName: string;
    FMethod: TMethodInfo;
  protected
    function CreateResult: TTestResult; virtual;
    procedure RunTest; virtual;
    procedure SetUp; virtual;
    procedure TearDown; virtual;
  public
    constructor Create; overload; virtual;
    constructor Create(Name: string; Method: TMethodInfo = nil); overload; virtual;

    function CountTestCases: Integer; virtual;

    function Run: TTestResult; overload; virtual;
    procedure Run(Result: TTestResult); overload; virtual;
    procedure RunBare(); virtual;

    property Name: string read FName write FName;
  public
    function ToString: WideString; override;
  end;

  TTestFailure = class(TSmideObject)
  private
    FFailedTest: ITest;
    FExceptionName: WideString;
    FExceptionMessage: WideString;
    FAddress: Pointer;
    FTrace: WideString;
    FIsFailure: Boolean;
    FExceptionString: WideString;
  public
    constructor Create(FailedTest: ITest; RaisedException: Exception; Address: Pointer); overload;

    function ToString: WideString; override;
    property Trace: WideString read FTrace;

    property ExceptionMessage: WideString read FExceptionMessage;
    property ExceptionName: WideString read FExceptionName;
    property ExceptionString: WideString read FExceptionString;
    property IsFailure: Boolean read FIsFailure;
    property FailedTest: ITest read FFailedTest;
  end;

  ITestFailureEnumerator = interface(IEnumerator)
    ['{61406877-6A6C-47A0-8DB7-2CDA8BC1B990}']
    function GetCurrent: TTestFailure;
    property Current: TTestFailure read GetCurrent;
  end;

  TTestFailureEnumerator = class(TEnumeratorBase, ITestFailureEnumerator)
  protected
    function GetCurrent: TTestFailure;
  public
    property Current: TTestFailure read GetCurrent;
  end;

  TTestFailureCollection = class(TReadOnlyCollectionBase)
  protected // TCollectionBase
    function get_TypeHandler: ITypeHandler; override;
  protected
    function Add(Value: TTestFailure): Integer;
  private // ITestFailureCollection
    function GetItem(Index: Integer): TTestFailure;
  public
    function Contains(Value: TTestFailure): Boolean;
    function IndexOf(Value: TTestFailure): Integer;

    procedure GetEnumerator(out Enumerator: IEnumerator); override;
    function GetEnumerator: ITestFailureEnumerator; overload;

    property Items[Index: Integer]: TTestFailure read GetItem; default;
  end;

  TTestResult = class(TSmideObject)
  private
    FFailures: TTestFailureCollection;
    FErrors: TTestFailureCollection;
    FListeners: TTestListenerCollection;
    FRunTests: Integer;
    FStop: Boolean;
    function GetErrors: TTestFailureCollection;
    function GetFailures: TTestFailureCollection;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddError(Test: ITest; e: Exception);
    procedure AddFailure(Test: ITest; e: EAssertionFailedException);

    procedure AddListener(Listener: ITestListener);
    procedure RemoveListener(Listener: ITestListener);
    function CloneListeners: TTestListenerCollection;
    procedure EndTest(Test: ITest);

    procedure Run(Test: TTestCase);
    function RunCount: Integer;
    procedure RunProtected(Test: ITest; P: IProtectable);
    function ShouldStop: Boolean;
    procedure StartTest(Test: ITest);
    procedure Stop;
    function WasSuccessful: Boolean;

    property Failures: TTestFailureCollection read GetFailures;
    property Errors: TTestFailureCollection read GetErrors;
  end;

  TTestSuite = class(TSmideObject, ITest)
  private
    FName: WideString;
    FTests: TTestCollection;
    procedure SetName(const Value: WideString);

    procedure AddTestMethod(Method: TMethodInfo; Names: TStringCollection; TheClass: TClass);

    class function ExceptionToString(e: Exception): WideString;

    function IsPublicTestMethod(Method: TMethodInfo): Boolean;
    function IsTestMethod(Method: TMethodInfo): Boolean;
    function GetTests: TTestCollection;
  protected
  public
    constructor Create; overload;
    constructor Create(TheClass: TClass; Name: WideString); overload; virtual;
    constructor Create(TheClass: TClass); overload; virtual;
    constructor Create(Name: WideString); overload; virtual;

    destructor Destroy; override;

    class function Warning(Message: WideString): ITest;

    procedure AddTest(Test: ITest);
    procedure AddTestSuite(TestClass: TClass);

    class function CreateTest(TheClass: TClass; Name: WideString; Method: TMethodInfo = nil): ITest; overload;
    function CountTestCases: Integer;
    class function GetConstructor(TheClass: TClass): Pointer;

    procedure Run(Result: TTestResult);
    procedure RunTest(Test: ITest; Result: TTestResult);

    property Name: WideString read FName write SetName;

    property Tests: TTestCollection read GetTests;
  end;

implementation

// TODO: remove this functions

const
  FuzzFactor = 1000;
  ExtendedResolution = 1E-19 * FuzzFactor;
  DoubleResolution = 1E-15 * FuzzFactor;
  SingleResolution = 1E-7 * FuzzFactor;

function Min(const A, B: Integer): Integer; overload;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Int64): Int64; overload;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Single): Single; overload;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Double): Double; overload;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Extended): Extended; overload;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Integer): Integer; overload;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Int64): Int64; overload;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Single): Single; overload;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Double): Double; overload;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Extended): Extended; overload;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function IsNan(const AValue: Single): Boolean; overload;
begin
  Result := ((PLongWord(@AValue)^ and $7F800000) = $7F800000) and
    ((PLongWord(@AValue)^ and $007FFFFF) <> $00000000);
end;

function IsNan(const AValue: Double): Boolean; overload;
begin
  Result := ((PInt64(@AValue)^ and $7FF0000000000000) = $7FF0000000000000) and
    ((PInt64(@AValue)^ and $000FFFFFFFFFFFFF) <> $0000000000000000);
end;

function IsNan(const AValue: Extended): Boolean; overload;
type
  TExtented = packed record
    Mantissa: Int64;
    Exponent: Word;
  end;
  PExtended = ^TExtented;
begin
  Result := ((PExtended(@AValue)^.Exponent and $7FFF) = $7FFF) and
    ((PExtended(@AValue)^.Mantissa and $7FFFFFFFFFFFFFFF) <> 0);
end;

function IsInfinite(const AValue: Double): Boolean;
begin
  Result := ((PInt64(@AValue)^ and $7FF0000000000000) = $7FF0000000000000) and
    ((PInt64(@AValue)^ and $000FFFFFFFFFFFFF) = $0000000000000000);
end;

function SameValue(const A, B: Extended; Epsilon: Extended): Boolean; overload;
begin
  if Epsilon = 0 then
    Epsilon := Max(Min(Abs(A), Abs(B)) * ExtendedResolution, ExtendedResolution);
  if A > B then
    Result := (A - B) <= Epsilon
  else
    Result := (B - A) <= Epsilon;
end;

function SameValue(const A, B: Double; Epsilon: Double): Boolean; overload;
begin
  if Epsilon = 0 then
    Epsilon := Max(Min(Abs(A), Abs(B)) * DoubleResolution, DoubleResolution);
  if A > B then
    Result := (A - B) <= Epsilon
  else
    Result := (B - A) <= Epsilon;
end;

function SameValue(const A, B: Single; Epsilon: Single): Boolean; overload;
begin
  if Epsilon = 0 then
    Epsilon := Max(Min(Abs(A), Abs(B)) * SingleResolution, SingleResolution);
  if A > B then
    Result := (A - B) <= Epsilon
  else
    Result := (B - A) <= Epsilon;
end;

{ EAssertionFailedException }

{ EComparisonFailure }

constructor EComparisonFailure.Create(Message, Expected,
  Actual: WideString);
begin
  inherited Create(Message);
  FExpected := Expected;
  FActual := Actual;
end;

function EComparisonFailure.get_Message: WideString;
begin
  // TODO: cut long strings "..." look at junit
  Result := inherited get_Message;
  Result := TAssert.Format(Result, FExpected, FActual);
end;

type
  TWarningTestCase = class(TTestCase)
  private
    FMessage: WideString;
  protected
    procedure RunTest; override;
  public
    constructor Create(Name: string; Message: WideString);
  end;

  { TWarningTestCase }

constructor TWarningTestCase.Create(Name: string; Message: WideString);
begin
  inherited Create(Name);
  FMessage := Message;
end;

procedure TWarningTestCase.RunTest;
begin
  Fail(FMessage);
end;

{ TAssert }

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual, Delta: Extended);
begin
  if IsInfinite(Expected) then
  begin
    if not (Expected = Actual) then
      FailNotEquals(Message, TType.GetTypeHandler(TypeInfo(Extended)), Expected, Actual);
  end
  else
  begin
    // cause you cannot compare NAN Values, we need to ask
    if IsNan(Expected) or IsNan(Actual) then
      FailNotEquals(Message, TType.GetTypeHandler(TypeInfo(Extended)), Expected, Actual);

    if SameValue(Expected, Actual, Delta) then
      exit;

    FailNotEquals(Message, TType.GetTypeHandler(TypeInfo(Extended)), Expected, Actual);
  end;
end;

class procedure TAssert.AssertEquals(Expected, Actual, Delta: Extended);
begin
  AssertEquals('', Expected, Actual, Delta);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: Boolean);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(Boolean)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: Boolean);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: string);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message, Expected, Actual: WideString);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(WideString)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: string);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(string)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: TObject);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(TObject)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: TObject);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: WideString);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: Byte);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(Byte)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: Int64);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: Int64);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(Int64)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: Integer);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: Word);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(Word)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: LongWord);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: LongWord);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(LongWord)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: Word);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: Integer);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(Integer)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: Char);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: Char);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(Char)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: Byte);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: ShortInt);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(ShortInt)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: SmallInt);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: SmallInt);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(SmallInt)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: ShortInt);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertFalse(Condition: Boolean);
begin
  AssertTrue(not Condition);
end;

class procedure TAssert.AssertFalse(Message: WideString; Condition: Boolean);
begin
  AssertTrue(Message, not Condition);
end;

class procedure TAssert.AssertNotNil(Message: WideString; Obj: TObject);
begin
  AssertTrue(Message, Obj <> nil);
end;

class procedure TAssert.AssertNotNil(Obj: TObject);
begin
  AssertNotNil('', Obj);
end;

class procedure TAssert.AssertNotEmpty(Message: WideString; s: string);
begin
  if s = '' then
    Fail(Message);
end;

class procedure TAssert.AssertNotEmpty(s: string);
begin
  AssertNotEmpty('', s);
end;

class procedure TAssert.AssertNotEmpty(Message, s: WideString);
begin
  if s = '' then
    Fail(Message);
end;

class procedure TAssert.AssertNotEmpty(s: WideString);
begin
  AssertNotEmpty('', s);
end;

class procedure TAssert.AssertNotNil(Message: WideString; Intf: IInterface);
begin
  AssertTrue(Message, Intf <> nil);
end;

class procedure TAssert.AssertNotSame(Message: WideString; Expected, Actual: IInterface);
begin
  AssertNotSame(Message, TType.GetTypeHandler(TypeInfo(IInterface)), Expected, Actual);
end;

class procedure TAssert.AssertNotSame(Message: WideString; Expected, Actual: TObject);
begin
  AssertNotSame(Message, TType.GetTypeHandler(TypeInfo(TObject)), Expected, Actual);
end;

class procedure TAssert.AssertNotSame(Expected, Actual: IInterface);
begin
  AssertNotSame('', Expected, Actual);
end;

class procedure TAssert.AssertNotSame(Expected, Actual: TObject);
begin
  AssertNotSame('', Expected, Actual);
end;

class procedure TAssert.AssertNil(Message: WideString; Intf: IInterface);
begin
  AssertTrue(Message, Intf = nil);
end;

class procedure TAssert.AssertNil(Message: WideString; Obj: TObject);
begin
  AssertTrue(Message, Obj = nil);
end;

class procedure TAssert.AssertNil(Obj: TObject);
begin
  AssertNil('', Obj);
end;

class procedure TAssert.AssertSame(Expected, Actual: TObject);
begin
  AssertSame('', Expected, Actual);
end;

class procedure TAssert.AssertSame(Expected, Actual: IInterface);
begin
  AssertSame('', Expected, Actual);
end;

class procedure TAssert.AssertSame(Message: WideString; Expected, Actual: IInterface);
begin
  AssertSame(Message, TType.GetTypeHandler(TypeInfo(IInterface)), Expected, Actual);
end;

class procedure TAssert.AssertSame(Message: WideString; Expected, Actual: TObject);
begin
  AssertSame(Message, TType.GetTypeHandler(TypeInfo(TObject)), Expected, Actual);
end;

class procedure TAssert.AssertTrue(Message: WideString; Condition: Boolean);
begin
  if not Condition then
    Fail(Message);
end;

class procedure TAssert.AssertTrue(Condition: Boolean);
begin
  AssertTrue('', Condition);
end;

class procedure TAssert.Fail(Message: WideString);
begin
  raise EAssertionFailedException.Create(Message);
end;

class procedure TAssert.Fail;
begin
  Fail('');
end;

class procedure TAssert.AssertEmpty(Message: WideString; s: string);
begin
  if s <> '' then
    Fail(Message);
end;

class procedure TAssert.AssertEmpty(s: string);
begin
  AssertEmpty('', s);
end;

class procedure TAssert.AssertEmpty(Message, s: WideString);
begin
  if s <> '' then
    Fail(Message);
end;

class procedure TAssert.AssertEmpty(s: WideString);
begin
  AssertEmpty('', s);
end;

class procedure TAssert.AssertEquals(Message: WideString; TypeHandler: ITypeHandler; const
  Expected, Actual);
begin
  if TypeHandler.EqualsValues(Expected, Actual) then
    exit;

  FailNotEquals(Message, TypeHandler, Expected, Actual);
end;

class procedure TAssert.AssertEquals(TypeHandler: ITypeHandler; const Expected, Actual);
begin
  AssertEquals('', TypeHandler, Expected, Actual);
end;

class procedure TAssert.FailNotEquals(Message: WideString; TypeHandler: ITypeHandler; const
  Expected, Actual);
begin
  Fail(Format(Message, TypeHandler.ValueToString(Expected), TypeHandler.ValueToString(Actual)));
end;

class procedure TAssert.FailNotSame(Message: WideString; TypeHandler: ITypeHandler; const Expected,
  Actual);
begin
  if Message <> '' then
    Message := Message + ' ';
  Fail(Message + 'expected same:<' + TypeHandler.ValueToString(Expected) + '> was not:<' +
    TypeHandler.ValueToString(Actual) + '>');
end;

class procedure TAssert.FailSame(Message: WideString);
begin
  if Message <> '' then
    Message := Message + ' ';
  Fail(Message + 'expected not same');
end;

class function TAssert.Format(Message, Expected, Actual: WideString): WideString;
begin
  if Message <> '' then
    Message := Message + ' ';
  Result := Message + 'expected:<' + Expected + '> but was:<' + Actual + '>';
end;

class procedure TAssert.AssertNotSame(TypeHandler: ITypeHandler; const Expected, Actual);
begin
  AssertNotSame('', TypeHandler, Expected, Actual);
end;

class procedure TAssert.AssertNotSame(Message: WideString; TypeHandler: ITypeHandler; const Expected, Actual);
begin
  if TypeHandler.SameValues(Expected, Actual) then
    FailSame(Message);
end;

class procedure TAssert.AssertSame(TypeHandler: ITypeHandler; const Expected, Actual);
begin
  AssertSame('', TypeHandler, Expected, Actual);
end;

class procedure TAssert.AssertSame(Message: WideString; TypeHandler: ITypeHandler; const
  Expected, Actual);
begin
  if TypeHandler.SameValues(Expected, Actual) then
    exit;

  FailNotSame(Message, TypeHandler, Expected, Actual);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: IInterface);
begin
  AssertEquals(Message, TType.GetTypeHandler(TypeInfo(IInterface)), Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: IInterface);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertNil(Intf: IInterface);
begin
  AssertNil('', Intf);
end;

class procedure TAssert.AssertNotNil(Intf: IInterface);
begin
  AssertNotNil('', Intf);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual, Delta: Double);
begin
  if IsInfinite(Expected) then
  begin
    if not (Expected = Actual) then
      FailNotEquals(Message, TType.GetTypeHandler(TypeInfo(Extended)), Expected, Actual);
  end
  else
  begin
    // cause you cannot compare NAN Values, we need to ask
    if IsNan(Expected) or IsNan(Actual) then
      FailNotEquals(Message, TType.GetTypeHandler(TypeInfo(Extended)), Expected, Actual);

    if SameValue(Expected, Actual, Delta) then
      exit;

    FailNotEquals(Message, TType.GetTypeHandler(TypeInfo(Extended)), Expected, Actual);
  end;
end;

class procedure TAssert.AssertEquals(Expected, Actual, Delta: Double);
begin
  AssertEquals('', Expected, Actual, Delta);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual, Delta: Single);
begin
  if IsInfinite(Expected) then
  begin
    if not (Expected = Actual) then
      FailNotEquals(Message, TType.GetTypeHandler(TypeInfo(Single)), Expected, Actual);
  end
  else
  begin
    // cause you cannot compare NAN Values, we need to ask
    if IsNan(Expected) or IsNan(Actual) then
      FailNotEquals(Message, TType.GetTypeHandler(TypeInfo(Single)), Expected, Actual);

    if SameValue(Expected, Actual, Delta) then
      exit;

    FailNotEquals(Message, TType.GetTypeHandler(TypeInfo(Single)), Expected, Actual);
  end;
end;

class procedure TAssert.AssertEquals(Expected, Actual, Delta: Single);
begin
  AssertEquals('', Expected, Actual, Delta);
end;

class procedure TAssert.AssertEquals(Message: WideString; Expected, Actual: TTypeData);
begin
  AssertEquals(Message, TType.GetTypeDataTypeHandler, Expected, Actual);
end;

class procedure TAssert.AssertEquals(Expected, Actual: TTypeData);
begin
  AssertEquals('', Expected, Actual);
end;

class procedure TAssert.AssertNotNil(Data: TTypeData);
begin
  AssertNotNil('', Data);
end;

class procedure TAssert.AssertNotNil(Message: WideString; Data: TTypeData);
begin
  AssertTrue(Message, Data <> nil);
end;

class procedure TAssert.AssertNil(Data: TTypeData);
begin
  AssertNil('', Data);
end;

class procedure TAssert.AssertNil(Message: WideString; Data: TTypeData);
begin
  AssertTrue(Message, Data = nil);
end;

class procedure TAssert.AssertSame(Expected, Actual: TTypeData);
begin
  AssertSame('', Expected, Actual);
end;

class procedure TAssert.AssertSame(Message: WideString; Expected,
  Actual: TTypeData);
begin
  AssertSame(Message, TType.GetTypeDataTypeHandler, Expected, Actual);
end;

{ TTestCase }

function TTestCase.CountTestCases: Integer;
begin
  Result := 1;
end;

constructor TTestCase.Create(Name: string; Method: TMethodInfo);
begin
  Create;
  FName := Name;
  FMethod := Method;
end;

constructor TTestCase.Create;
begin
  inherited;
end;

function TTestCase.CreateResult: TTestResult;
begin
  Result := TTestResult.Create;
end;

function TTestCase.Run: TTestResult;
begin
  Result := CreateResult;
  Run(Result);
end;

procedure TTestCase.Run(Result: TTestResult);
begin
  Result.Run(Self);
end;

procedure TTestCase.RunBare;
var
  e: TObject;
  { TODO: cause we have memory leaks if RunTest and then TearDown fails
    we must free the raised exception from RunTest.
    Problem is that we lose the exception from the testcase.
    maybe we can implement a different behaivor, such own exception handlers
    for SetUp and TearDown.}
begin
  e := nil;
  SetUp;
  try
    try
      RunTest;
    except
      e := ExceptObject;
      raise;
    end;
  finally
    try
      TearDown;
    except
      if e <> nil then
        e.Free;
      raise;
    end;
  end;
end;

procedure TTestCase.RunTest;
var
  RunMethod: TMethodInfo;
  Params: array of TVarRec;
  Tmp: Pointer;
begin
  AssertNotEmpty(FName);

  if FMethod = nil then
  begin
    // we need an instance method with no parameters,
    RunMethod := TType.GetType(Self).GetMethod(FName, ([bfPublic, bfNonPublic, bfInstance,
      bfMethodInfo, bfParameterInfo, bfProcedure]), nil, nil, []);
  end
  else
    RunMethod := FMethod;

  if RunMethod = nil then
    Fail('Method "' + FName + '" not found');

  if not RunMethod.IsPublic then
    Fail('Method "' + FName + '" should be public');

  try
    SetLength(Params, 0);
    RunMethod.Invoke(Self, Params, Tmp);
  except
    // TODO: Invoke Exception
    raise;
  end;
end;

procedure TTestCase.SetUp;
begin

end;

procedure TTestCase.TearDown;
begin

end;

function TTestCase.ToString: WideString;
begin
  Result := Name + '(' + TType.GetType(Self).FullName + ')'
end;

{ TTestResult }

procedure TTestResult.AddError(Test: ITest; e: Exception);
begin
  // TODO: with Lock do
  begin
    FErrors.Add(TTestFailure.Create(Test, e, ExceptAddr));
    with CloneListeners.GetEnumerator do
      while MoveNext do
        (Current as ITestListener).AddError(Test, e);
  end;
end;

procedure TTestResult.AddFailure(Test: ITest; e: EAssertionFailedException);
begin
  // TODO: with Lock do
  begin
    FFailures.Add(TTestFailure.Create(Test, e, ExceptAddr));
    with CloneListeners.GetEnumerator do
      while MoveNext do
        (Current as ITestListener).AddFailure(Test, e);
  end;
end;

procedure TTestResult.AddListener(Listener: ITestListener);
begin
  // TODO: with Lock do
  begin
    FListeners.Add(Listener);
  end;
end;

function TTestResult.CloneListeners: TTestListenerCollection;
begin
  // TODO: with Lock do
  begin
    Result := FListeners;
  end;
end;

constructor TTestResult.Create;
begin
  inherited;
  FFailures := TTestFailureCollection.Create(true);
  FErrors := TTestFailureCollection.Create(true);
  FListeners := TTestListenerCollection.Create(true);
end;

destructor TTestResult.Destroy;
begin
  FFailures.Free;
  FErrors.Free;
  FListeners.Free;
  inherited;
end;

procedure TTestResult.EndTest(Test: ITest);
begin
  with CloneListeners.GetEnumerator do
    while MoveNext do
      (Current as ITestListener).EndTest(Test);
end;

function TTestResult.GetErrors: TTestFailureCollection;
begin
  // TODO: clone FErrors
  // TODO: with Lock do
  begin
    Result := FErrors;
  end;
end;

function TTestResult.GetFailures: TTestFailureCollection;
begin
  // TODO: clone FFailures
  // TODO: with Lock do
  begin
    Result := FFailures;
  end;
end;

procedure TTestResult.RemoveListener(Listener: ITestListener);
begin
  // TODO: with Lock do
  begin
    FListeners.Remove(Listener);
  end;
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
end;

procedure TTestResult.Run(Test: TTestCase);
begin
  StartTest(Test);
  RunProtected(Test, TProtectable.Create(Test));
  EndTest(Test);
end;

function TTestResult.RunCount: Integer;
begin
  // TODO: with Lock do
  begin
    Result := FRunTests;
  end;
end;

procedure TTestResult.RunProtected(Test: ITest; P: IProtectable);
begin
  try
    P.Protect;
  except
    on e: EAssertionFailedException do
    begin
      AddFailure(Test, e);
    end;
    on e: Exception do
    begin
      AddError(Test, e);
    end;
    // TODO: SysUtils Exception
  end;
end;

function TTestResult.ShouldStop: Boolean;
begin
  // TODO: with Lock do
  begin
    Result := FStop;
  end;
end;

procedure TTestResult.StartTest(Test: ITest);
var
  Count: Integer;
begin
  // TODO: with Lock do
  begin
    Count := Test.CountTestCases;

    Inc(FRunTests, Count);

    with CloneListeners.GetEnumerator do
      while MoveNext do
        (Current as ITestListener).StartTest(Test);
  end;
end;

procedure TTestResult.Stop;
begin
  FStop := true;
end;

function TTestResult.WasSuccessful: Boolean;
begin
  Result := (Failures.Count = 0) and (Errors.Count = 0);
end;

{ TTestFailure }

constructor TTestFailure.Create(FailedTest: ITest; RaisedException: Exception; Address: Pointer);
// TODO: Handle SysUtils Exceptions
// TODO: InnerExceptions
begin
  if FailedTest = nil then
    raise EArgumentNil.Create('FailedTest');
  if RaisedException = nil then
    raise EArgumentNil.Create('RaiseException');

  FFailedTest := FailedTest;
  FIsFailure := RaisedException is EAssertionFailedException;

  FExceptionName := TType.GetType(RaisedException).FullName;

  FExceptionMessage := RaisedException.Message;
  FAddress := Address;

  FTrace := RaisedException.StackTrace;

  FTrace := FTrace + #13#10;

  FExceptionString := RaisedException.ToString;
end;

function TTestFailure.ToString: WideString;
begin
  Result := TType.GetTypeHandler(TypeInfo(ITest)).ValueToString(FFailedTest) + ': (' + ExceptionName + ') ' + ExceptionMessage + #13#10;
end;

{ TTestSuite }

constructor TTestSuite.Create;
begin
  inherited;

  FTests := TTestCollection.Create(true);
end;

constructor TTestSuite.Create(TheClass: TClass; Name: WideString);
begin
  Create(TheClass);
  SetName(Name);
end;

constructor TTestSuite.Create(TheClass: TClass);
var
  Names: TStringCollection;
begin
  Create;

  // TODO: check the constructor

  if not TType.HasTypeInfo(TheClass) then
  begin
    AddTest(Warning('Class ' + TheClass.ClassName + ' has no type info.'));
    exit;
  end;

  FName := TType.GetType(TheClass).Name;

  try
    GetConstructor(TheClass);
  except
    AddTest(Warning('Class ' + TType.GetType(TheClass).FullName +
      ' has no public constructor TTestCase.Create(string Name) or TTestCase.Create.'));
    exit;
  end;

  if not (TType.GetType(TheClass).IsPublic) then
  begin
    AddTest(Warning('Class ' + TType.GetType(TheClass).FullName + ' is not public.'));
    exit;
  end;

  // get public procedures
  Names := TStringCollection.Create(true);
  try
    with TType.GetType(TheClass).GetMethods([bfPublic, bfNonPublic, bfInstance]).GetEnumerator do
    begin
      while MoveNext do
      begin
        AddTestMethod(Current, Names, TheClass);
      end;
    end;
  finally
    Names.Free;
  end;

  if Tests.Count = 0 then
    AddTest(Warning('No tests found in ' + TType.GetType(TheClass).FullName + '.'));
end;

procedure TTestSuite.AddTest(Test: ITest);
begin
  if Test = nil then
    raise EArgumentNil.Create('Test');
  FTests.Add(Test);
end;

constructor TTestSuite.Create(Name: WideString);
begin
  Create;
  SetName(Name);
end;

destructor TTestSuite.Destroy;
begin
  FTests.Free;
  inherited;
end;

procedure TTestSuite.SetName(const Value: WideString);
begin
  FName := Value;
end;

procedure TTestSuite.AddTestSuite(TestClass: TClass);
begin
  AddTest(TTestSuite.Create(TestClass));
end;

function TTestSuite.CountTestCases: Integer;
begin
  Result := Tests.Count;
end;

procedure TTestSuite.Run(Result: TTestResult);
begin
  with Tests.GetEnumerator do
    while MoveNext do
    begin
      if Result.ShouldStop then
        break;

      RunTest((Current as ITest), Result);
    end;
end;

procedure TTestSuite.RunTest(Test: ITest; Result: TTestResult);
begin
  Test.Run(Result);
end;

class function TTestSuite.Warning(Message: WideString): ITest;
begin
  Result := TWarningTestCase.Create('Warning', Message);
end;

class function TTestSuite.GetConstructor(TheClass: TClass): Pointer;
begin
  // TODO:
  Result := nil;
end;

procedure TTestSuite.AddTestMethod(Method: TMethodInfo; Names: TStringCollection; TheClass: TClass);
begin
  // TODO:
  if Names.Contains(Method.Name) then
    exit;

  if not IsPublicTestMethod(Method) then
  begin
    if IsTestMethod(Method) then
      AddTest(Warning('Test method is''nt public: ' + Method.Name + '.'));
    exit;
  end;

  Names.Add(Method.Name);
  AddTest(CreateTest(TheClass, Method.Name, Method));
end;

class function TTestSuite.CreateTest(TheClass: TClass; Name: WideString; Method: TMethodInfo):
  ITest;
var
  Test: TTestCase;
begin
  // TODO: get the Construcor and call him

  // Create the test
  try
    Test := TTestCase(TheClass.NewInstance);
    Test.Create(Name, Method);
    Result := Test;
  except
    on e: Exception do
      Result := Warning('Cannot instantiate test case: ' + Name + ' (' + ExceptionToString(e) + ').');
  end;
end;

function TTestSuite.IsPublicTestMethod(Method: TMethodInfo): Boolean;
begin
  Result := IsTestMethod(Method) and Method.IsPublic;
end;

function TTestSuite.IsTestMethod(Method: TMethodInfo): Boolean;
begin
  // TODO: Compare caseinsensitive
  // TODO: check count of parameters
  Result := (Pos('Test', Method.Name) = 1) and (Method.IsProcedure);
end;

function TTestSuite.GetTests: TTestCollection;
begin
  Result := FTests;
end;

class function TTestSuite.ExceptionToString(e: Exception): WideString;
begin
  // TODO: print stacktrace
  if not TType.HasTypeInfo(e) then
    Result := e.ClassName + ': ' + e.Message
  else
    Result := TType.GetType(e).FullName + ': ' + e.Message;
end;

{ TTestFailureCollection }

function TTestFailureCollection.Add(Value: TTestFailure): Integer;
begin
  Result := InnerList.ItemAdd(Value);
end;

function TTestFailureCollection.Contains(Value: TTestFailure): Boolean;
begin
  Result := InnerList.ItemContains(Value);
end;

procedure TTestFailureCollection.GetEnumerator(out Enumerator: IEnumerator);
begin
  Enumerator := GetEnumerator;
end;

function TTestFailureCollection.GetItem(Index: Integer): TTestFailure;
begin
  InnerList.ItemGet(Index, Result);
end;

function TTestFailureCollection.IndexOf(Value: TTestFailure): Integer;
begin
  Result := InnerList.ItemIndexOf(Value);
end;

function TTestFailureCollection.GetEnumerator: ITestFailureEnumerator;
begin
  Result := TTestFailureEnumerator.Create(Self.InnerList);
end;

function TTestFailureCollection.get_TypeHandler: ITypeHandler;
begin
  Result := TType.GetTypeHandler(TTestFailure);
end;

{ TTestFailureEnumerator }

function TTestFailureEnumerator.GetCurrent: TTestFailure;
begin
  GetCurrentItem(Result);
end;

{ TTestListenerEnumerator }

function TTestListenerEnumerator.GetCurrent: ITestListener;
begin
  GetCurrentItem(Result);
end;

{ TTestListenerCollection }

function TTestListenerCollection.Add(const Value: ITestListener): Integer;
begin
  Result := ItemAdd(Value);
end;

function TTestListenerCollection.Contains(const Value: ITestListener): Boolean;
begin
  Result := ItemContains(Value);
end;

function TTestListenerCollection.GetEnumerator: ITestListenerEnumerator;
begin
  Result := TTestListenerEnumerator.Create(InnerList);
end;

procedure TTestListenerCollection.GetEnumerator(out Enumerator: IEnumerator);
begin
  Enumerator := GetEnumerator;
end;

function TTestListenerCollection.GetItem(Index: Integer): ITestListener;
begin
  ItemGet(Index, Result);
end;

function TTestListenerCollection.get_TypeHandler: ITypeHandler;
begin
  Result := TType.GetTypeHandler(TypeInfo(ITestListener));
end;

function TTestListenerCollection.IndexOf(const Value: ITestListener): Integer;
begin
  Result := ItemIndexOf(Value);
end;

procedure TTestListenerCollection.Insert(Index: Integer; const Value: ITestListener);
begin
  ItemInsert(Index, Value);
end;

procedure TTestListenerCollection.Remove(const Value: ITestListener);
begin
  ItemRemove(Value);
end;

procedure TTestListenerCollection.SetItem(Index: Integer; const Value: ITestListener);
begin
  ItemSet(Index, Value);
end;

{ TTestEnumerator }

function TTestEnumerator.GetCurrent: ITest;
begin
  GetCurrentItem(Result);
end;

{ TTestCollection }

function TTestCollection.Add(const Value: ITest): Integer;
begin
  Result := ItemAdd(Value);
end;

function TTestCollection.Contains(const Value: ITest): Boolean;
begin
  Result := ItemContains(Value);
end;

function TTestCollection.GetEnumerator: ITestEnumerator;
begin
  Result := TTestEnumerator.Create(InnerList);
end;

procedure TTestCollection.GetEnumerator(out Enumerator: IEnumerator);
begin
  Enumerator := GetEnumerator;
end;

function TTestCollection.GetItem(Index: Integer): ITest;
begin
  ItemGet(Index, Result);
end;

function TTestCollection.get_TypeHandler: ITypeHandler;
begin
  Result := TType.GetTypeHandler(TypeInfo(ITest));
end;

function TTestCollection.IndexOf(const Value: ITest): Integer;
begin
  Result := ItemIndexOf(Value);
end;

procedure TTestCollection.Insert(Index: Integer; const Value: ITest);
begin
  ItemInsert(Index, Value);
end;

procedure TTestCollection.Remove(const Value: ITest);
begin
  ItemRemove(Value);
end;

procedure TTestCollection.SetItem(Index: Integer; const Value: ITest);
begin
  ItemSet(Index, Value);
end;

end.

