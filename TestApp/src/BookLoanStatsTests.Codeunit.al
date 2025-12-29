namespace Demo.Library.Test;

using Demo.Library;
using System.TestLibraries.Utilities;

codeunit 70455 "LIB Book Loan Stats Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Library Assert";
        Any: Codeunit Any;

    [Test]
    procedure TestSetPeriodThisMonth()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        ExpectedStartDate: Date;
        ExpectedEndDate: Date;
    begin
        // [GIVEN] Today's date
        ExpectedStartDate := CalcDate('<-CM>', Today());
        ExpectedEndDate := CalcDate('<CM>', Today());

        // [WHEN] Setting period to This Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Month");

        // [THEN] Start and End dates should match current month boundaries
        Assert.AreEqual(ExpectedStartDate, BookLoanStatistics.GetStartDate(), 'Start date should be first day of current month');
        Assert.AreEqual(ExpectedEndDate, BookLoanStatistics.GetEndDate(), 'End date should be last day of current month');
    end;

    [Test]
    procedure TestSetPeriodThisYear()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        ExpectedStartDate: Date;
        ExpectedEndDate: Date;
    begin
        // [GIVEN] Today's date
        ExpectedStartDate := CalcDate('<-CY>', Today());
        ExpectedEndDate := CalcDate('<CY>', Today());

        // [WHEN] Setting period to This Year
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Year");

        // [THEN] Start and End dates should match current year boundaries
        Assert.AreEqual(ExpectedStartDate, BookLoanStatistics.GetStartDate(), 'Start date should be January 1st');
        Assert.AreEqual(ExpectedEndDate, BookLoanStatistics.GetEndDate(), 'End date should be December 31st');
    end;

    [Test]
    procedure TestSetPeriodLastMonth()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        ExpectedStartDate: Date;
        ExpectedEndDate: Date;
    begin
        // [GIVEN] Today's date
        ExpectedStartDate := CalcDate('<-CM-1M>', Today());
        ExpectedEndDate := CalcDate('<CM-1M>', Today());

        // [WHEN] Setting period to Last Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"Last Month");

        // [THEN] Start and End dates should match previous month boundaries
        Assert.AreEqual(ExpectedStartDate, BookLoanStatistics.GetStartDate(), 'Start date should be first day of last month');
        Assert.AreEqual(ExpectedEndDate, BookLoanStatistics.GetEndDate(), 'End date should be last day of last month');
    end;

    [Test]
    procedure TestSetPeriodAllTime()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
    begin
        // [WHEN] Setting period to All Time
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"All Time");

        // [THEN] Start date should be blank and End date should be maximum
        Assert.AreEqual(0D, BookLoanStatistics.GetStartDate(), 'Start date should be blank for All Time');
        Assert.AreEqual(DMY2Date(31, 12, 9999), BookLoanStatistics.GetEndDate(), 'End date should be maximum date');
    end;

    [Test]
    procedure TestGetTotalLoansWithNoData()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        TotalLoans: Integer;
    begin
        // [GIVEN] No book loan ledger entries
        CleanupBookLoanLedgerEntries();

        // [WHEN] Getting total loans for This Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Month");
        TotalLoans := BookLoanStatistics.GetTotalLoans();

        // [THEN] Total loans should be 0
        Assert.AreEqual(0, TotalLoans, 'Total loans should be 0 when no data exists');
    end;

    [Test]
    procedure TestGetTotalLoansWithData()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        TotalLoans: Integer;
    begin
        // [GIVEN] 3 book loan entries this month
        CleanupBookLoanLedgerEntries();
        CreateBookLoanLedgerEntry(Today(), "LIB Book Loan Entry Type"::Loan);
        CreateBookLoanLedgerEntry(Today() - 5, "LIB Book Loan Entry Type"::Loan);
        CreateBookLoanLedgerEntry(Today() - 10, "LIB Book Loan Entry Type"::Loan);
        CreateBookLoanLedgerEntry(Today() - 50, "LIB Book Loan Entry Type"::Loan); // Previous month

        // [WHEN] Getting total loans for This Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Month");
        TotalLoans := BookLoanStatistics.GetTotalLoans();

        // [THEN] Total loans should be 3
        Assert.AreEqual(3, TotalLoans, 'Total loans should be 3 for current month');
    end;

    [Test]
    procedure TestGetTotalReturns()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        TotalReturns: Integer;
    begin
        // [GIVEN] 2 loan entries and 1 return entry this month
        CleanupBookLoanLedgerEntries();
        CreateBookLoanLedgerEntry(Today(), "LIB Book Loan Entry Type"::Loan);
        CreateBookLoanLedgerEntry(Today() - 5, "LIB Book Loan Entry Type"::Loan);
        CreateBookLoanLedgerEntry(Today() - 3, "LIB Book Loan Entry Type"::Return);

        // [WHEN] Getting total returns for This Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Month");
        TotalReturns := BookLoanStatistics.GetTotalReturns();

        // [THEN] Total returns should be 1
        Assert.AreEqual(1, TotalReturns, 'Total returns should be 1 for current month');
    end;

    [Test]
    procedure TestGetUniqueBooksLoaned()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        Book1: Code[20];
        Book2: Code[20];
        Member: Code[20];
        UniqueBooks: Integer;
    begin
        // [GIVEN] 3 loan entries for 2 different books this month
        CleanupBookLoanLedgerEntries();
        Book1 := CreateBookNo();
        Book2 := CreateBookNo();
        Member := CreateMemberNo();

        CreateBookLoanLedgerEntryWithDetails(Today(), "LIB Book Loan Entry Type"::Loan, Book1, Member);
        CreateBookLoanLedgerEntryWithDetails(Today() - 5, "LIB Book Loan Entry Type"::Loan, Book2, Member);
        CreateBookLoanLedgerEntryWithDetails(Today() - 10, "LIB Book Loan Entry Type"::Loan, Book1, Member); // Same book again

        // [WHEN] Getting unique books loaned for This Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Month");
        UniqueBooks := BookLoanStatistics.GetUniqueBooksLoaned();

        // [THEN] Unique books should be 2
        Assert.AreEqual(2, UniqueBooks, 'Unique books loaned should be 2');
    end;

    [Test]
    procedure TestGetUniqueMembers()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        Book: Code[20];
        Member1: Code[20];
        Member2: Code[20];
        UniqueMembers: Integer;
    begin
        // [GIVEN] 3 loan entries for 2 different members this month
        CleanupBookLoanLedgerEntries();
        Book := CreateBookNo();
        Member1 := CreateMemberNo();
        Member2 := CreateMemberNo();

        CreateBookLoanLedgerEntryWithDetails(Today(), "LIB Book Loan Entry Type"::Loan, Book, Member1);
        CreateBookLoanLedgerEntryWithDetails(Today() - 5, "LIB Book Loan Entry Type"::Loan, Book, Member2);
        CreateBookLoanLedgerEntryWithDetails(Today() - 10, "LIB Book Loan Entry Type"::Loan, Book, Member1); // Same member again

        // [WHEN] Getting unique members for This Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Month");
        UniqueMembers := BookLoanStatistics.GetUniqueMembers();

        // [THEN] Unique members should be 2
        Assert.AreEqual(2, UniqueMembers, 'Unique members should be 2');
    end;

    [Test]
    procedure TestGetMostBorrowedBooks()
    var
        TempMostBorrowedBook: Record "LIB Most Borrowed Book" temporary;
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        Book1: Code[20];
        Book2: Code[20];
        Member: Code[20];
    begin
        // [GIVEN] Multiple loans for different books
        CleanupBookLoanLedgerEntries();
        Book1 := CreateBookNo();
        Book2 := CreateBookNo();
        Member := CreateMemberNo();

        CreateBookLoanLedgerEntryWithDetails(Today(), "LIB Book Loan Entry Type"::Loan, Book1, Member);
        CreateBookLoanLedgerEntryWithDetails(Today() - 5, "LIB Book Loan Entry Type"::Loan, Book1, Member);
        CreateBookLoanLedgerEntryWithDetails(Today() - 10, "LIB Book Loan Entry Type"::Loan, Book2, Member);

        // [WHEN] Getting most borrowed books for This Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Month");
        BookLoanStatistics.GetMostBorrowedBooks(TempMostBorrowedBook);

        // [THEN] Should have 2 books in the list
        Assert.AreEqual(2, TempMostBorrowedBook.Count(), 'Should have 2 books in most borrowed list');

        // [THEN] First book should be Book1 with 2 loans
        TempMostBorrowedBook.FindSet();
        Assert.AreEqual(Book1, TempMostBorrowedBook."Book No.", 'First book should be Book1');
        Assert.AreEqual(2, TempMostBorrowedBook."Loan Count", 'Book1 should have 2 loans');

        // [THEN] Second book should be Book2 with 1 loan
        TempMostBorrowedBook.Next();
        Assert.AreEqual(Book2, TempMostBorrowedBook."Book No.", 'Second book should be Book2');
        Assert.AreEqual(1, TempMostBorrowedBook."Loan Count", 'Book2 should have 1 loan');
    end;

    [Test]
    procedure TestGetAverageLoanDuration()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        Book: Code[20];
        Member: Code[20];
        DocNo: Code[20];
        AvgDuration: Decimal;
    begin
        // [GIVEN] One loan and return with 14 days duration
        CleanupBookLoanLedgerEntries();
        Book := CreateBookNo();
        Member := CreateMemberNo();
        DocNo := CopyStr(Any.AlphanumericText(10), 1, 20);

        CreateBookLoanLedgerEntryWithDocNo(Today() - 14, "LIB Book Loan Entry Type"::Loan, Book, Member, DocNo);
        CreateBookLoanLedgerEntryWithDocNo(Today(), "LIB Book Loan Entry Type"::Return, Book, Member, DocNo);

        // [WHEN] Getting average loan duration for This Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Month");
        AvgDuration := BookLoanStatistics.GetAverageLoanDuration();

        // [THEN] Average duration should be 14 days
        Assert.AreEqual(14, AvgDuration, 'Average loan duration should be 14 days');
    end;

    [Test]
    procedure TestGetAverageLoanDurationMultipleReturns()
    var
        BookLoanStatistics: Codeunit "LIB Book Loan Statistics";
        Book1: Code[20];
        Book2: Code[20];
        Member: Code[20];
        DocNo1: Code[20];
        DocNo2: Code[20];
        AvgDuration: Decimal;
    begin
        // [GIVEN] Two loans with different durations (14 and 7 days)
        CleanupBookLoanLedgerEntries();
        Book1 := CreateBookNo();
        Book2 := CreateBookNo();
        Member := CreateMemberNo();
        DocNo1 := CopyStr(Any.AlphanumericText(10), 1, 20);
        DocNo2 := CopyStr(Any.AlphanumericText(10), 1, 20);

        CreateBookLoanLedgerEntryWithDocNo(Today() - 14, "LIB Book Loan Entry Type"::Loan, Book1, Member, DocNo1);
        CreateBookLoanLedgerEntryWithDocNo(Today(), "LIB Book Loan Entry Type"::Return, Book1, Member, DocNo1);

        CreateBookLoanLedgerEntryWithDocNo(Today() - 7, "LIB Book Loan Entry Type"::Loan, Book2, Member, DocNo2);
        CreateBookLoanLedgerEntryWithDocNo(Today(), "LIB Book Loan Entry Type"::Return, Book2, Member, DocNo2);

        // [WHEN] Getting average loan duration for This Month
        BookLoanStatistics.SetPeriod("LIB Book Loan Stats Period"::"This Month");
        AvgDuration := BookLoanStatistics.GetAverageLoanDuration();

        // [THEN] Average duration should be 10.5 days
        Assert.AreEqual(10.5, AvgDuration, 'Average loan duration should be 10.5 days');
    end;

    local procedure CleanupBookLoanLedgerEntries()
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
    begin
        BookLoanLedgerEntry.DeleteAll();
    end;

    local procedure CreateBookLoanLedgerEntry(PostingDate: Date; EntryType: Enum "LIB Book Loan Entry Type")
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
    begin
        BookLoanLedgerEntry.Init();
        BookLoanLedgerEntry."Entry No." := GetNextEntryNo();
        BookLoanLedgerEntry."Book No." := CreateBookNo();
        BookLoanLedgerEntry."Member No." := CreateMemberNo();
        BookLoanLedgerEntry."Posting Date" := PostingDate;
        BookLoanLedgerEntry."Document No." := CopyStr(Any.AlphanumericText(10), 1, 20);
        BookLoanLedgerEntry."Entry Type" := EntryType;
        BookLoanLedgerEntry.Quantity := 1;
        BookLoanLedgerEntry.Insert();
    end;

    local procedure CreateBookLoanLedgerEntryWithDetails(PostingDate: Date; EntryType: Enum "LIB Book Loan Entry Type"; BookNo: Code[20]; MemberNo: Code[20])
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
    begin
        BookLoanLedgerEntry.Init();
        BookLoanLedgerEntry."Entry No." := GetNextEntryNo();
        BookLoanLedgerEntry."Book No." := BookNo;
        BookLoanLedgerEntry."Member No." := MemberNo;
        BookLoanLedgerEntry."Posting Date" := PostingDate;
        BookLoanLedgerEntry."Document No." := CopyStr(Any.AlphanumericText(10), 1, 20);
        BookLoanLedgerEntry."Entry Type" := EntryType;
        BookLoanLedgerEntry.Quantity := 1;
        BookLoanLedgerEntry.Insert();
    end;

    local procedure CreateBookLoanLedgerEntryWithDocNo(PostingDate: Date; EntryType: Enum "LIB Book Loan Entry Type"; BookNo: Code[20]; MemberNo: Code[20]; DocNo: Code[20])
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
    begin
        BookLoanLedgerEntry.Init();
        BookLoanLedgerEntry."Entry No." := GetNextEntryNo();
        BookLoanLedgerEntry."Book No." := BookNo;
        BookLoanLedgerEntry."Member No." := MemberNo;
        BookLoanLedgerEntry."Posting Date" := PostingDate;
        BookLoanLedgerEntry."Document No." := DocNo;
        BookLoanLedgerEntry."Entry Type" := EntryType;
        BookLoanLedgerEntry.Quantity := 1;
        BookLoanLedgerEntry.Insert();
    end;

    local procedure GetNextEntryNo(): Integer
    var
        BookLoanLedgerEntry: Record "LIB Book Loan Ledger Entry";
    begin
        if BookLoanLedgerEntry.FindLast() then
            exit(BookLoanLedgerEntry."Entry No." + 1);
        exit(1);
    end;

    local procedure CreateBookNo(): Code[20]
    begin
        exit(CopyStr('BOOK' + Format(Any.IntegerInRange(1000, 9999)), 1, 20));
    end;

    local procedure CreateMemberNo(): Code[20]
    begin
        exit(CopyStr('MEMBER' + Format(Any.IntegerInRange(1000, 9999)), 1, 20));
    end;
}
