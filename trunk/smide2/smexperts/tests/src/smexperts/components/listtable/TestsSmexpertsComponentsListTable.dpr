program TestsSmexpertsComponentsListTable;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  Smexperts.Components.ListTable in '..\..\..\..\..\src\smexperts\components\Smexperts.Components.ListTable.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
