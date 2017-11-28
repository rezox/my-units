unit CRTEncoderUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BaseEncoderUnit, BaseConstraintUnit, CRTConstraintUnit;

type

  { TBaseCRTEncoder }

  TBaseCRTEncoder = class(TBaseEncoder)
  protected
    function EncodeConstraint(Constraint: TCRTConstraint): TEncoding; virtual; abstract;

  public
    function Encode(Problem: TBaseConstraint): TEncoding; override;
    class function GetEncoder(const EncoderName: AnsiString): TBaseEncoder; override;

  end;


implementation
uses
  BasicCRTEncoderUnit;

{ TBaseCRTEncoder }

function TBaseCRTEncoder.Encode(Problem: TBaseConstraint): TEncoding;
begin
  Result := Self.EncodeConstraint(Problem as TCRTConstraint);
end;

class function TBaseCRTEncoder.GetEncoder(const EncoderName: AnsiString
  ): TBaseEncoder;
var
  Index: Integer;
begin
  Index := FAllEncoders.IndexOfName(EncoderName);
  if Index < 0 then
    Exit(nil);
  Result := FAllEncoders.Objects[Index] as TBaseEncoder;

end;


end.

