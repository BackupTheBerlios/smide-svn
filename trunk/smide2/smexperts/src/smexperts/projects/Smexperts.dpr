library Smexperts;

uses
  SysUtils,
  Classes,
  ToolsApi,
  Smexperts.System;

{$LIBSUFFIX '70d'}

procedure WizardTerminate;
begin
  Smexperts.System.UnRegister;
end;

function WizardInit(const BorlandIDEServices: IBorlandIDEServices; RegisterProc: TWizardRegisterProc; var Terminate: TWizardTerminateProc): Boolean
  stdcall;
begin
  Result := (BorlandIDEServices <> nil);

  if Result then
  begin
    //ToolsApi.BorlandIDEServices := BorlandIDEServices;
    Assert(ToolsApi.BorlandIDEServices = BorlandIDEServices);
    ToolsApi.LibraryWizardProc := RegisterProc;

    Terminate := WizardTerminate;

    Smexperts.System.Register;
  end;
end;

exports
  WizardInit Name WizardEntryPoint;

begin

end.

