unit BasicCRTEncoderUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, CRTEncoderUnit, CRTUnit, BaseEncoderUnit;

type

  { TBasicCRTEncoder }

  TBasicCRTEncoder = class(TBaseCRTEncoder)
  private
  protected
    function EncodeConstraint(Constraint: TCRTConstraint): TEncoding;
  public

  end;


implementation
uses
  ClauseUnit, TSeitinVariableUnit, SatSolverInterfaceUnit, NumberTheoryUnit;

{ TBasicCRTEncoder }

function TBasicCRTEncoder.EncodeConstraint(Constraint: TCRTConstraint
  ): TEncoding;
var
  cl: TClauseCollection;
  Lit: TLiteral;

begin
  SatSolverInterfaceUnit.ReNewSatSolver('CNFCollection');

  Lit := CreateLiteral(GetVariableManager.CreateNewVariable, False);

  Result := TEncoding.Create(GetSatSolver.CNF.Copy, Lit);


end;

end.

