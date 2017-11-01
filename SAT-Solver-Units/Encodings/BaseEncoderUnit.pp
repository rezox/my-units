unit BaseEncoderUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ClauseUnit, BaseProblemUnit;

type

  { TEncoding }

  TEncoding = class(TObject)
  private
    FClauses: TClauseCollection;
    FOutput: TLiteral;

  public
    property Clauses: TClauseCollection read FClauses;
    property Output: TLiteral read FOutput;

    // This class owns cl.
    constructor Create(cl: TClauseCollection; Lit: TLiteral);
    destructor Destroy; override;

    function ToString: AnsiString; override;

  end;

  { TBaseEncoder }

  TBaseEncoder = class(TObject)
  public
    constructor Create;
    destructor Destroy; override;

    {
      Result.Clauses |- (Result.lit <=> Problem).
    }
    function Encode(Problem: TBaseProblem): TEncoding; virtual; abstract;
    function GetEncoder(const EncoderName: AnsiString): TBaseEncoder; virtual; abstract;
  end;

implementation

{ TEncoding }

constructor TEncoding.Create(cl: TClauseCollection; Lit: TLiteral);
begin
  inherited Create;

  FClauses := cl;
  FOutput := Lit;
end;

destructor TEncoding.Destroy;
begin
  FClauses.Free;

  inherited Destroy;
end;

function TEncoding.ToString: AnsiString;
begin
  Result := '(' + Clauses.ToString + ',' + LiteralToString(Output) + ')';
end;

{ TBaseEncoder }

constructor TBaseEncoder.Create;
begin
  inherited;

end;

destructor TBaseEncoder.Destroy;
begin
  inherited Destroy;
end;

end.
