namespace Demo.Library;

page 70304 "LIB Book Statistics FactBox"
{
    Caption = 'Book Statistics';
    PageType = CardPart;
    SourceTable = "LIB Book";
    Extensible = true;
    InherentPermissions = X;
    InherentEntitlements = X;

    layout
    {
        area(Content)
        {
            field("Book No."; Rec."No.")
            {
                Caption = 'Book No.';
                ToolTip = 'Specifies the book number.';
                ApplicationArea = All;
                Visible = false;
            }
            group(ThisMonth)
            {
                Caption = 'This Month';
                field(LoansThisMonth; LoansThisMonth)
                {
                    Caption = 'Loans';
                    ToolTip = 'Specifies the number of loans this month.';
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = Favorable;

                    trigger OnDrillDown()
                    begin
                        DrillDownLoans(LoansThisMonth, "LIB Book Loan Stats Period"::"This Month");
                    end;
                }
            }
            group(ThisYear)
            {
                Caption = 'This Year';
                field(LoansThisYear; LoansThisYear)
                {
                    Caption = 'Loans';
                    ToolTip = 'Specifies the number of loans this year.';
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = Favorable;

                    trigger OnDrillDown()
                    begin
                        DrillDownLoans(LoansThisYear, "LIB Book Loan Stats Period"::"This Year");
                    end;
                }
            }
            group(AllTime)
            {
                Caption = 'All Time';
                field(LoansAllTime; LoansAllTime)
                {
                    Caption = 'Total Loans';
                    ToolTip = 'Specifies the total number of loans for this book.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownLoans(LoansAllTime, "LIB Book Loan Stats Period"::"All Time");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalculateStatistics();
    end;

    local procedure CalculateStatistics()
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
    begin
        LoansThisMonth := 0;
        LoansThisYear := 0;
        LoansAllTime := 0;

        if Rec."No." = '' then
            exit;

        // This Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Month");
        BookLoanLedgerEntry.SetRange("Book No.", Rec."No.");
        BookLoanLedgerEntry.SetRange("Entry Type", BookLoanLedgerEntry."Entry Type"::Loan);
        BookLoanLedgerEntry.SetRange("Posting Date", BookLoanStatistics.GetStartDate(), BookLoanStatistics.GetEndDate());
        LoansThisMonth := BookLoanLedgerEntry.Count();

        // This Year
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Year");
        BookLoanLedgerEntry.SetRange("Posting Date", BookLoanStatistics.GetStartDate(), BookLoanStatistics.GetEndDate());
        LoansThisYear := BookLoanLedgerEntry.Count();

        // All Time
        BookLoanLedgerEntry.SetRange("Posting Date");
        LoansAllTime := BookLoanLedgerEntry.Count();
    end;

    local procedure DrillDownLoans(LoanCount: Integer; Period: Enum "LIB Book Loan Stats Period")
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
    begin
        if LoanCount = 0 then
            exit;

        BookLoanLedgerEntry.SetRange("Book No.", Rec."No.");
        BookLoanLedgerEntry.SetRange("Entry Type", BookLoanLedgerEntry."Entry Type"::Loan);

        if Period <> Period::"All Time" then begin
            BookLoanStatistics.SetPeriod(Period);
            BookLoanLedgerEntry.SetRange("Posting Date", BookLoanStatistics.GetStartDate(), BookLoanStatistics.GetEndDate());
        end;

        Page.Run(Page::"LIB Book Loan Ledger Entries", BookLoanLedgerEntry);
    end;

    var
        LoansThisMonth: Integer;
        LoansThisYear: Integer;
        LoansAllTime: Integer;
}
