unit Smide.System.Runtime.Exceptions;

interface

uses
  Smide.System.Common;

type
  EOsError = class(ESystem)
  private
    FErrorCode: Integer;
  protected
    function get_Message: WideString; override;
  public
    constructor Create; override;
    constructor Create(ErrorCode: Integer); overload;
    constructor Create(ErrorCode: Integer; Message: WideString); overload;
    constructor Create(ErrorCode: Integer; Message: WideString; InnerException: Exception); overload;

    property ErrorCode: Integer read FErrorCode;
  end;

implementation

uses
  Windows,
  Smide.System.Types,
  Smide.System.Common.GetText,
  Smide.System.Runtime.Environment,
  Smide.System.Globalization;

{ EOsError }

constructor EOsError.Create;
begin
  inherited Create(_('System error occurred.'));
end;

constructor EOsError.Create(ErrorCode: Integer);
begin
  FErrorCode := ErrorCode;
  Create;
end;

constructor EOsError.Create(ErrorCode: Integer; Message: WideString);
begin
  FErrorCode := ErrorCode;
  Create;
end;

constructor EOsError.Create(ErrorCode: Integer; Message: WideString; InnerException: Exception);
begin
  FErrorCode := ErrorCode;
  inherited Create(Message, InnerException);
end;

function EOsError.get_Message: WideString;
var
  Buffer: array[0..500] of WideChar;
  ErrorMessage: WideString;
  Len: Integer;
begin
  Result := inherited get_Message;

  Len := FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_IGNORE_INSERTS or FORMAT_MESSAGE_ARGUMENT_ARRAY, nil, ErrorCode, 0, @Buffer,
    SizeOf(Buffer), nil);
  if Len <> 0 then
  begin
    while (Len > 0) and (Buffer[Len - 1] in [WideChar(#0)..WideChar(#32)]) do
      Dec(Len);
    SetString(ErrorMessage, Buffer, Len);
    Result := Result + TEnvironment.NewLine + _('Message: ') + ErrorMessage;
  end;

  Result := Result + TEnvironment.NewLine + _('ErrorCode: ') + TType.GetType(TypeInfo(Integer)).ValueToString(ErrorCode);
end;

end.

