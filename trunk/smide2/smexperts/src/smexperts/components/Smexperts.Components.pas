unit Smexperts.Components;

interface

procedure Register;

implementation

uses
  Classes,
  Smexperts.Components.ListTable;

procedure Register;
begin
  RegisterComponents('Smexperts.Components', [TListTable]);
end;

end.

