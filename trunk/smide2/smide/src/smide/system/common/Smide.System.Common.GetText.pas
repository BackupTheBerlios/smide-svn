unit Smide.System.Common.GetText;

interface

function _(const MessageId: WideString): WideString; overload;
function _(const MessageId: WideString; Args: array of const): WideString; overload;

implementation

function _(const MessageId: WideString): WideString;
begin
  // TODO:
  Result := MessageId;
end;

function _(const MessageId: WideString; Args: array of const): WideString;
var
  i: Integer;
begin
  Result := MessageId;
  // TODO: format
  for i := 0 to High(Args) do
  begin
    Result := Result + #10#13;
    case TVarRec(Args[i]).VType of
      vtInteger: ; //(VInteger: Integer; VType: Byte);
      vtBoolean: ; //(VBoolean: Boolean);
      vtChar: Result := Result + TVarRec(Args[i]).VChar;
      vtExtended: ; //(VExtended: PExtended);
      vtString: Result := Result + TVarRec(Args[i]).VString^; //(VString: PShortString);
      vtPointer: ; //(VPointer: Pointer);
      vtPChar: Result := Result + TVarRec(Args[i]).VPChar; // (VPChar: PChar);
      vtObject: ; //(VObject: TObject);
      vtClass: ; //(VClass: TClass);
      vtWideChar: Result := Result + TVarRec(Args[i]).VWideChar; // (VWideChar: WideChar);
      vtPWideChar: Result := Result + TVarRec(Args[i]).VPWideChar; //(VPWideChar: PWideChar);
      vtAnsiString: Result := Result + PAnsiString(TVarRec(Args[i]).VAnsiString)^; //(VAnsiString: Pointer);
      vtCurrency: ; //(VCurrency: PCurrency);
      vtVariant: ; //(VVariant: PVariant);
      vtInterface: ; //(VInterface: Pointer);
      vtWideString: Result := Result + PWideString(TVarRec(Args[i]).VWideString)^; //(VWideString: Pointer);
      vtInt64: ; //(VInt64: PInt64);
    end;
  end;
end;

end.
