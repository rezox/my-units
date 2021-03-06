unit ParameterManagerUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, NameValueCollectionUnit;

const
  vbNone = 0;
  vbEveryThing = 512;

type
  TParameterList = specialize TGenericNameValueCollection<AnsiString>;

  { TRunTimeParameterManager }

  TRunTimeParameterManager = class(TParameterList)
  private
    function GetVerbosity: Integer;

  public
    property Verbosity: Integer read GetVerbosity;

    function GetValueByName(Name: AnsiString): AnsiString; override;
    procedure AddArgument(Name, Value: AnsiString);
    constructor Create;
    destructor Destroy; override;

    class function GetInstance: TRunTimeParameterManager;
  end;

procedure Initialize;
procedure Finalize;
function GetRunTimeParameterManager: TRunTimeParameterManager; inline;

implementation
uses
  ExceptionUnit;

var
  RunTimeParameterManager: TRunTimeParameterManager;

procedure Initialize;
begin
  if RunTimeParameterManager= nil then
    RunTimeParameterManager := TRunTimeParameterManager.Create;

end;

procedure Finalize;
begin
  RunTimeParameterManager.Free;

end;

function GetRunTimeParameterManager: TRunTimeParameterManager; inline;
begin
  Result := RunTimeParameterManager;

end;

{ TRunTimeParameterManager }

function TRunTimeParameterManager.GetVerbosity: Integer;
begin
  if GetValueByName('--Verbosity')<> '' then
    Exit(StrToInt(GetValueByName('--Verbosity')))
  else
    Exit(0);

end;

procedure TRunTimeParameterManager.AddArgument(Name, Value: AnsiString);
begin
  AddNameValue(UpperCase(Name), Value);
  Finalize;

end;

constructor TRunTimeParameterManager.Create;
  procedure PrintHelp;
  begin
    WriteLn('Invalid Usage!');
    WriteLn(ExtractFileName(ParamStr(0))+ ' {Name Value}^* ');

  end;
const
{$i ValidArguments.inc }

  procedure CheckParameter(Name, Value: AnsiString);
  var
    i: Integer;
  begin
    for i := Low(ValidArguments) to High(ValidArguments) do
    begin

      if UpperCase(Name) = UpperCase(ValidArguments[i]) then
      begin
        if Pos('NONE', UpperCase(ValidArgumentsValues[i])) <> 0 then
          Exit;

        if Pos(UpperCase(Value), UpperCase(ValidArgumentsValues[i])) <> 0 then
           Exit;

        WriteLn('Invalid Argument Value:', Name, ' ', Value, '.');
        WriteLn('Valid Arguments for ', Name, ' are');
        Write(ValidArgumentsValues[i]);
        Halt(1);

      end;

    end;

    for i := Low(ValidArguments) to High(ValidArguments) do
      if UpperCase(Name) = UpperCase(ValidArguments [i]) then
        Exit;

    WriteLn('Invalid Name :', Name, '.');
    WriteLn('Valid Parameters are: ');
    for i := Low(ValidArguments) to High(ValidArguments)  do
      Write(ValidArguments [i], ' , ');
    Halt(1);
  end;

var
  i: Integer;
  Name, V: AnsiString;

begin
  inherited;

  if Odd(Paramcount) then
  begin
    PrintHelp;
     raise Exception.Create('Invalid set of parameters');
  end;

  i := 1;

  while i <= Paramcount do
  begin
    Name := ParamStr(i);
    if Paramcount< i+ 1 then
      Break;
    V := ParamStr(i+ 1);
    CheckParameter(Name, V);
    AddArgument(Name, V);

    Inc(i, 2);

  end;

  for i := Low(ValidArguments) to High(ValidArguments) do
    if GetValueByName(ValidArguments[i]) = '' then
    begin
      AddArgument(ValidArguments[i],
        Copy(ValidArgumentsValues[i],
             1,
             Pos(':', ValidArgumentsValues[i] + ':') - 1
            )
        );
    end;
  Finalize;

end;

destructor TRunTimeParameterManager.Destroy;
begin
  inherited Destroy;

end;

class function TRunTimeParameterManager.GetInstance: TRunTimeParameterManager;
begin
  Result := GetRunTimeParameterManager;
end;

function TRunTimeParameterManager.GetValueByName(Name: AnsiString): AnsiString;
begin
  try
    Result := inherited GetValueByName(UpperCase(Name))

  except
    on e: ENameNotFound do
      Result := '';

  end;

end;

initialization
  RunTimeParameterManager := nil;
  Initialize;

finalization
  Finalize;
end.

