enum 70372 "LIB Book Loan Entry Type"
{
    Caption = 'Book Loan Entry Type';
    Extensible = true;
    Access = Public;

    value(0; Loan)
    {
        Caption = 'Loan';
    }
    value(1; Return)
    {
        Caption = 'Return';
    }
}
