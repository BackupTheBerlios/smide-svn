unit Smide.System.Types.Common;

interface

uses
  Smide.System.Types.Runtime.TypeData,
  Smide.System.Reflection.Runtime.Handles,
  Smide.System.Common,
  Smide.System.Globalization;

type
  ITypeHandler = interface
    ['{65A4B33E-3965-44DF-B117-9F7D96A83398}']
    procedure ValueToData(const Value; out Data: TTypeData);
    procedure DataToValue(const Data: TTypeData; var Value);
    procedure ClearValue(var Value);
    procedure FreeData(var Data: TTypeData);
    function CompareValues(const Value1; const Value2): Integer;
    function EqualsValues(const Value1; const Value2): Boolean;
    function SameValues(const Value1; const Value2): Boolean;
    //function VarRecToData(const VarRec: TVarRec; out Data: TTypeData): Boolean;
    //function VarRecToValue(const VarRec: TVarRec; out Value): Boolean;
    function ValueToString(const Value): WideString;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider = nil): WideString;

    function GetHashCode(const Value): Integer;

    function get_TypeSize: Integer;
    property TypeSize: Integer read get_TypeSize;

    function get_RuntimeTypeHandle: TRuntimeTypeHandle;
    property RuntimeTypeHandle: TRuntimeTypeHandle read get_RuntimeTypeHandle;
  end;

implementation

end.

