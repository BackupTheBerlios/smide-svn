unit Smide.System.Types.Runtime.TypeInfo;

interface

type
  TTypeKind = (
    tkUnknown,
    tkInteger,
    tkChar,
    tkEnumeration,
    tkFloat,
    tkString,
    tkSet,
    tkClass,
    tkMethod,
    tkWideChar,
    tkLongString,
    tkWideString,
    tkVariant,
    tkArray,
    tkRecord,
    tkInterface,
    tkInt64,
    tkDynamicArray
    );
  TTypeKinds = set of TTypeKind;

  TOrdinalKind = (
    okSignedByte,
    okUnsignedByte,
    okSignedWord,
    otUnsignedWord,
    otSignedLong,
    otUnsignedLong
    );
  TOrdinalKinds = set of TOrdinalKind;

  TFloatKind = (
    fkSingle,
    fkDouble,
    fkExtended,
    fkComp,
    fkCurrency
    );
  TFloatKinds = set of TFloatKind;

  TMethodKind = (
    mkProcedure,
    mkFunction,
    mkConstructor,
    mkDestructor,
    mkClassProcedure,
    mkClassFunction,
    { Obsolete }
    mkSafeProcedure,
    mkSafeFunction
    );
  TMethodKinds = set of TMethodKind;

  TParameterFlag = (
    pfVar,
    pfConst,
    pfArray,
    pfAddress,
    pfReference,
    pfOut
    );
  TParameterFlags = set of TParameterFlag;

  TInterfaceFlag = (
    ifHasGuid,
    ifDispInterface,
    ifDispatch
    );
  TInterfaceFlags = set of TInterfaceFlag;
  TInterfaceFlagsBase = set of TInterfaceFlag;

  ShortStringBase = string[255];

  PPTypeInfo = ^PTypeInfo;
  PTypeInfo = ^TTypeInfo;
  TTypeInfo = record
    Kind: TTypeKind;
    Name: ShortString;
    {TypeData: TTypeData}
  end;

  PTypeInfoData = ^TTypeInfoData;
  TTypeInfoData = packed record
    case TTypeKind of
      tkUnknown, tkLongString, tkWideString, tkVariant: (
        );
      tkInteger, tkChar, tkEnumeration, tkSet, tkWideChar: (
        OrdinalKind: TOrdinalKind;
        case TTypeKind of
          tkInteger, tkChar, tkEnumeration, tkWideChar: (
            MinValue: Longint;
            MaxValue: Longint;
            case TTypeKind of
              tkInteger, tkChar, tkWideChar: (
                );
              tkEnumeration: (
                BaseType: PPTypeInfo;
                NameList: ShortStringBase;
                EnumerationUnitName: ShortStringBase
                )
              );
          tkSet: (
            CompType: PPTypeInfo
            )
          );
      tkFloat: (
        FloatKind: TFloatKind
        );
      tkString: (
        MaxLength: Byte
        );
      tkClass: (
        ClassType: TClass;
        ParentInfo: PPTypeInfo;
        PropCount: SmallInt;
        UnitName: ShortStringBase;
        {PropData: TPropData}
        );
      tkMethod: (
        MethodKind: TMethodKind;
        ParameterCount: Byte;
        ParameterList: array[0..1023] of Char
        {ParamList: array[1..ParamCount] of
           record
             Flags: TParamFlags;
             ParamName: ShortString;
             TypeName: ShortString;
           end;
         ResultType: ShortString}
        );
      tkInterface: (
        InterfaceParent: PPTypeInfo; { ancestor }
        InterfaceFlags: TInterfaceFlagsBase;
        Guid: TGUID;
        InterfaceUnit: ShortStringBase;
        {PropData: TPropData}
        );
      tkInt64: (
        MinInt64Value, MaxInt64Value: Int64);
      tkDynamicArray: (
        elSize: Longint;
        elType: PPTypeInfo; // nil if type does not require cleanup
        VarType: Integer; // Ole Automation varType equivalent
        elType2: PPTypeInfo; // independent of cleanup
        DynamicArrayUnitName: ShortStringBase
        );
  end;

  TPropData = packed record
    PropCount: Word;
    PropList: record
    end;
    {PropList: array[1..PropCount] of TPropInfo}
  end;

  PPropInfo = ^TPropInfo;
  TPropInfo = packed record
    PropType: PPTypeInfo;
    GetProc: Pointer;
    SetProc: Pointer;
    StoredProc: Pointer;
    Index: Integer;
    Default: Longint;
    NameIndex: SmallInt;
    Name: ShortString;
  end;

type
  PPropData = ^TPropData;

  { Published method record }
  PVmtMethodInfo = ^TVmtMethodInfo;
  TVmtMethodInfo = packed record
    Size: Word; { Size of the TVmtMethod record. }
    Address: Pointer; { Pointer to the method entry point. }
    Name: ShortString; { Name of the published method. }
  end;

  PVmtMethodParameterInfo = ^TVmtMethodParameterInfo;
  TVmtMethodParameterInfo = packed record
    Version: Byte; // Must be 1
    CallingConvention: Word;
    ReturnType: ^PTypeInfo;
    ParamSize: Word;
  end;

  PVmtMethodParameter = ^TVmtMethodParameter;
  TVmtMethodParameter = packed record
    Flags: TParameterFlags;
    ParamType: ^PTypeInfo;
    Access: Word;
    Name: ShortString;
  end;

  { Published method table }
  PMethodTable = ^TMethodTable;
  TMethodTable = packed record
    Count: Word;
    Methods: array[0..0] of Byte;
    { Methods: array[1..Count] of TVmtMethod; }
  end;

  { Field class table }
  PFieldClassTable = ^TFieldClassTable;
  TFieldClassTable = packed record
    Count: Word;
    Classes: packed array[0..0] of ^TClass;
    { Classes: packed array[1..Count] of ^TClass; }
  end;

  { Published field record }
  PField = ^TField;
  TField = packed record
    Offset: Integer; { Byte offset of field in the object. }
    ClassIndex: Word; { Index in the FieldClassTable of the field's type. }
    Name: ShortString; { Name of the published field. }
  end;

  { Published field table }
  PFieldTable = ^TFieldTable;
  TFieldTable = packed record
    Count: Word;
    FieldClassTable: PFieldClassTable;
    Fields: Byte;
    { Fields: packed array [1..Count] of TVmtField; }
  end;

  { Dynamic method table }
  PDynamicMethodTable = ^TDynamicMethodTable;
  TDynamicMethodTable = packed record
    Count: Word;
    Data: packed array[0..0] of Byte;
    { Indexes: packed array[1..Count] of SmallInt;
      Addresses: packed array[1..Count] of Pointer; }
  end;
  PDynamicMethodIndexes = ^TDynamicMethodIndexes;
  TDynamicMethodIndexes = packed array[0..0] of SmallInt;
  PDynamicMethodAddresses = ^TDynamicMethodAddresses;
  TDynamicMethodAddresses = packed array[0..0] of Pointer;

  { Initialization/finalization record }
  PTypeKind = ^TTypeKind;
  PInitTable = ^TInitTable;
  PInitRecord = ^TInitRecord;
  TInitRecord = packed record
    InitTable: ^PInitTable;
    Offset: Integer; { offset of field in object }
  end;
  PInitArray = ^TInitArray;
  TInitArray = array[0..0] of TInitRecord;

  { Initialization/finalization table }
  TInitTable = packed record
    TypeKind: Byte;
    Data: packed array[0..0] of Byte;
    { TypeName: ShortString;
      DataSize: Integer;
      Count: Integer;
      Records: array[1..Count] of TInitRecord; }
  end;

const
  atTypeMask = $7F;
  atByRef = $80;
  MaxAutoEntries = 4095;
  MaxAutoParams = 255;

type
  { Automation entry parameter list }
  PAutoParamList = ^TAutoParamList;
  TAutoParamList = packed record
    ReturnType: Byte;
    Count: Byte;
    Types: array[0..MaxAutoParams] of Byte;
  end;

  { Automation entry flags }
  { Automation table entry }
  PAutoEntry = ^TAutoEntry;
  TAutoEntry = packed record
    DispID: Integer;
    Name: PShortString;
    Flags: Integer; { Lower byte is TVmtAutoFlags }
    Params: PAutoParamList;
    Address: Pointer;
  end;

  { Automation table layout }
  PAutoTable = ^TAutoTable;
  TAutoTable = packed record
    Count: Integer;
    Entries: array[0..MaxAutoEntries] of TAutoEntry;
  end;

  PVirtualMethodTable = ^TVirtualMethodTable;
  TVirtualMethodTable = array[0..0] of Pointer;

implementation

end.
