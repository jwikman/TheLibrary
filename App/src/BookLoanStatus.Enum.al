enum 70371 "LIB Book Loan Status"
{
    Caption = 'Book Loan Status';
    Extensible = true;
    Access = Public;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Posted)
    {
        Caption = 'Posted';
    }
}
