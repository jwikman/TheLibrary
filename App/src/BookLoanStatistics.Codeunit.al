namespace Demo.Library;

codeunit 70300 "LIB Book Loan Statistics"
{
    Access = Public;
    InherentPermissions = X;
    InherentEntitlements = X;

    var
        StartDate: Date;
        EndDate: Date;

    /// <summary>
    /// Sets the date range for statistics based on the selected period.
    /// </summary>
    /// <param name="Period">The period to calculate statistics for.</param>
#pragma warning disable LC0010
    procedure SetPeriod(Period: Enum "LIB Book Loan Stats Period")
#pragma warning restore LC0010
    begin
        case Period of
            Period::"This Month":
                begin
                    StartDate := CalcDate('<-CM>', Today());
                    EndDate := CalcDate('<CM>', Today());
                end;
            Period::"This Quarter":
                begin
                    StartDate := CalcDate('<-CQ>', Today());
                    EndDate := CalcDate('<CQ>', Today());
                end;
            Period::"This Year":
                begin
                    StartDate := CalcDate('<-CY>', Today());
                    EndDate := CalcDate('<CY>', Today());
                end;
            Period::"Last Month":
                begin
                    StartDate := CalcDate('<-CM-1M>', Today());
                    EndDate := CalcDate('<CM-1M>', Today());
                end;
            Period::"Last Quarter":
                begin
                    StartDate := CalcDate('<-CQ-1Q>', Today());
                    EndDate := CalcDate('<CQ-1Q>', Today());
                end;
            Period::"Last Year":
                begin
                    StartDate := CalcDate('<-CY-1Y>', Today());
                    EndDate := CalcDate('<CY-1Y>', Today());
                end;
            Period::"All Time":
                begin
                    StartDate := 0D;
                    EndDate := DMY2Date(31, 12, 9999);
                end;
        end;
    end;

    /// <summary>
    /// Gets the total number of loans within the current period.
    /// </summary>
    /// <returns>The total number of loans.</returns>
    procedure GetTotalLoans(): Integer
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
    begin
        BookLoanLedgerEntry.SetRange("Entry Type", BookLoanLedgerEntry."Entry Type"::Loan);
        ApplyDateFilter(BookLoanLedgerEntry);
        exit(BookLoanLedgerEntry.Count());
    end;

    /// <summary>
    /// Gets the total number of returns within the current period.
    /// </summary>
    /// <returns>The total number of returns.</returns>
    procedure GetTotalReturns(): Integer
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
    begin
        BookLoanLedgerEntry.SetRange("Entry Type", BookLoanLedgerEntry."Entry Type"::Return);
        ApplyDateFilter(BookLoanLedgerEntry);
        exit(BookLoanLedgerEntry.Count());
    end;

    /// <summary>
    /// Gets the number of unique books loaned within the current period.
    /// </summary>
    /// <returns>The number of unique books loaned.</returns>
    procedure GetUniqueBooksLoaned(): Integer
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
        BookNo: Code[20];
        UniqueBooks: List of [Code[20]];
    begin
        BookLoanLedgerEntry.SetRange("Entry Type", BookLoanLedgerEntry."Entry Type"::Loan);
        ApplyDateFilter(BookLoanLedgerEntry);
        if BookLoanLedgerEntry.FindSet() then
            repeat
                BookNo := BookLoanLedgerEntry."Book No.";
                if not UniqueBooks.Contains(BookNo) then
                    UniqueBooks.Add(BookNo);
            until BookLoanLedgerEntry.Next() = 0;
        exit(UniqueBooks.Count());
    end;

    /// <summary>
    /// Gets the number of unique members who borrowed books within the current period.
    /// </summary>
    /// <returns>The number of unique members.</returns>
    procedure GetUniqueMembers(): Integer
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
        MemberNo: Code[20];
        UniqueMembers: List of [Code[20]];
    begin
        BookLoanLedgerEntry.SetRange("Entry Type", BookLoanLedgerEntry."Entry Type"::Loan);
        ApplyDateFilter(BookLoanLedgerEntry);
        if BookLoanLedgerEntry.FindSet() then
            repeat
                MemberNo := BookLoanLedgerEntry."Member No.";
                if not UniqueMembers.Contains(MemberNo) then
                    UniqueMembers.Add(MemberNo);
            until BookLoanLedgerEntry.Next() = 0;
        exit(UniqueMembers.Count());
    end;

    /// <summary>
    /// Gets the most borrowed books within the current period.
    /// </summary>
    /// <param name="TempMostBorrowedBook">Temporary record to store the most borrowed books.</param>
    procedure GetMostBorrowedBooks(var TempMostBorrowedBook: Record "LIB Most Borrowed Book" temporary)
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
        Book: Record "LIB Book";
        LineNo: Integer;
    begin
        TempMostBorrowedBook.Reset();
        TempMostBorrowedBook.DeleteAll();
        LineNo := 0;

        BookLoanLedgerEntry.SetCurrentKey("Book No.");
        BookLoanLedgerEntry.SetRange("Entry Type", BookLoanLedgerEntry."Entry Type"::Loan);
        ApplyDateFilter(BookLoanLedgerEntry);

        if BookLoanLedgerEntry.FindSet() then
            repeat
                TempMostBorrowedBook.SetRange("Book No.", BookLoanLedgerEntry."Book No.");
                if TempMostBorrowedBook.FindFirst() then begin
                    TempMostBorrowedBook."Loan Count" += 1;
                    TempMostBorrowedBook.Modify();
                end else begin
                    TempMostBorrowedBook.Reset();
                    LineNo += 1;
                    TempMostBorrowedBook.Init();
                    TempMostBorrowedBook."Line No." := LineNo;
                    TempMostBorrowedBook."Book No." := BookLoanLedgerEntry."Book No.";
                    if Book.Get(BookLoanLedgerEntry."Book No.") then begin
                        TempMostBorrowedBook."Book Title" := Book.Title;
                        TempMostBorrowedBook."Author No." := Book."Author No.";
                    end;
                    TempMostBorrowedBook."Loan Count" := 1;
                    TempMostBorrowedBook.Insert();
                end;
            until BookLoanLedgerEntry.Next() = 0;

        // Sort by loan count descending
        TempMostBorrowedBook.Reset();
        TempMostBorrowedBook.SetCurrentKey("Loan Count");
        TempMostBorrowedBook.Ascending(false);
    end;

    /// <summary>
    /// Calculates the average loan duration in days for books returned within the current period.
    /// </summary>
    /// <returns>The average loan duration in days.</returns>
    procedure GetAverageLoanDuration(): Decimal
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
        LoanEntry: Record "LIB Book Loan Ledger Entry";
        TotalDays: Integer;
        Count: Integer;
    begin
        BookLoanLedgerEntry.SetRange("Entry Type", BookLoanLedgerEntry."Entry Type"::Return);
        ApplyDateFilter(BookLoanLedgerEntry);

        if BookLoanLedgerEntry.FindSet() then
            repeat
                // Find the corresponding loan entry
                LoanEntry.SetRange("Book No.", BookLoanLedgerEntry."Book No.");
                LoanEntry.SetRange("Member No.", BookLoanLedgerEntry."Member No.");
                LoanEntry.SetRange("Document No.", BookLoanLedgerEntry."Document No.");
                LoanEntry.SetRange("Entry Type", LoanEntry."Entry Type"::Loan);
                if LoanEntry.FindFirst() then begin
                    TotalDays += BookLoanLedgerEntry."Posting Date" - LoanEntry."Posting Date";
                    Count += 1;
                end;
            until BookLoanLedgerEntry.Next() = 0;

        if Count > 0 then
            exit(TotalDays / Count);
        exit(0);
    end;

    local procedure ApplyDateFilter(var BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry")
    begin
        if StartDate <> 0D then
            BookLoanLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
    end;

    /// <summary>
    /// Gets the start date of the current period.
    /// </summary>
    /// <returns>The start date.</returns>
    procedure GetStartDate(): Date
    begin
        exit(StartDate);
    end;

    /// <summary>
    /// Gets the end date of the current period.
    /// </summary>
    /// <returns>The end date.</returns>
    procedure GetEndDate(): Date
    begin
        exit(EndDate);
    end;
}
