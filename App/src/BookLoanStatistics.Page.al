namespace Demo.Library;

page 70302 "LIB Book Loan Statistics"
{
    Caption = 'Book Loan Statistics';
    PageType = Card;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Extensible = true;
    SourceTable = "LIB Library Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    InherentPermissions = X;
    InherentEntitlements = X;

    layout
    {
        area(Content)
        {
            group(Period)
            {
                Caption = 'Period';
                field("Selected Period"; SelectedPeriod)
                {
                    Caption = 'Period';
                    ToolTip = 'Specifies the period for which statistics are calculated.';

                    trigger OnValidate()
                    begin
                        CalculateStatistics();
                    end;
                }
                field("Start Date"; StartDate)
                {
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the start date of the selected period.';
                    Editable = false;
                }
                field("End Date"; EndDate)
                {
                    Caption = 'End Date';
                    ToolTip = 'Specifies the end date of the selected period.';
                    Editable = false;
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                field("Total Loans"; TotalLoans)
                {
                    Caption = 'Total Loans';
                    ToolTip = 'Specifies the total number of book loans in the selected period.';
                    StyleExpr = true;
                    Style = Favorable;
                }
                field("Total Returns"; TotalReturns)
                {
                    Caption = 'Total Returns';
                    ToolTip = 'Specifies the total number of book returns in the selected period.';
                    StyleExpr = true;
                    Style = Favorable;
                }
                field("Unique Books Loaned"; UniqueBooksLoaned)
                {
                    Caption = 'Unique Books Loaned';
                    ToolTip = 'Specifies the number of unique books that were loaned in the selected period.';
                }
                field("Unique Members"; UniqueMembers)
                {
                    Caption = 'Unique Members';
                    ToolTip = 'Specifies the number of unique members who borrowed books in the selected period.';
                }
                field("Average Loan Duration"; AverageLoanDuration)
                {
                    Caption = 'Average Loan Duration (Days)';
                    ToolTip = 'Specifies the average duration of book loans in days for books returned in the selected period.';
                    DecimalPlaces = 0 : 2;
                }
            }
            part("Most Borrowed Books"; "LIB Most Borrowed Books Part")
            {
                Caption = 'Most Borrowed Books';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                Caption = 'Refresh';
                ToolTip = 'Refresh the statistics.';
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    CalculateStatistics();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        SelectedPeriod := SelectedPeriod::"This Month";
        CalculateStatistics();
    end;

    local procedure CalculateStatistics()
    var
        TempMostBorrowedBook: Record "LIB Most Borrowed Book" temporary;
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
    begin
        BookLoanStatistics.SetPeriod(SelectedPeriod);

        StartDate := BookLoanStatistics.GetStartDate();
        EndDate := BookLoanStatistics.GetEndDate();
        TotalLoans := BookLoanStatistics.GetTotalLoans();
        TotalReturns := BookLoanStatistics.GetTotalReturns();
        UniqueBooksLoaned := BookLoanStatistics.GetUniqueBooksLoaned();
        UniqueMembers := BookLoanStatistics.GetUniqueMembers();
        AverageLoanDuration := BookLoanStatistics.GetAverageLoanDuration();

        BookLoanStatistics.GetMostBorrowedBooks(TempMostBorrowedBook);
        CurrPage."Most Borrowed Books".Page.LoadData(TempMostBorrowedBook);
    end;

    var
        SelectedPeriod: Enum "LIB Book Loan Stats Period";
        StartDate: Date;
        EndDate: Date;
        TotalLoans: Integer;
        TotalReturns: Integer;
        UniqueBooksLoaned: Integer;
        UniqueMembers: Integer;
        AverageLoanDuration: Decimal;
}
