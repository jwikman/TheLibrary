namespace Demo.Library;

enum 70300 "LIB Book Loan Stats Period"
{
    Caption = 'Book Loan Statistics Period';
    Extensible = true;
    Access = Public;

    value(0; "This Month")
    {
        Caption = 'This Month';
    }
    value(1; "This Quarter")
    {
        Caption = 'This Quarter';
    }
    value(2; "This Year")
    {
        Caption = 'This Year';
    }
    value(3; "Last Month")
    {
        Caption = 'Last Month';
    }
    value(4; "Last Quarter")
    {
        Caption = 'Last Quarter';
    }
    value(5; "Last Year")
    {
        Caption = 'Last Year';
    }
    value(6; "All Time")
    {
        Caption = 'All Time';
    }
}
