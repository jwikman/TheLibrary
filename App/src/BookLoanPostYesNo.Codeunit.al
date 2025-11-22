codeunit 70351 "LIB Book Loan-Post (Yes/No)"
{
    TableNo = "LIB Book Loan Header";
    Access = Public;

    trigger OnRun()
    begin
        BookLoanHeader.Copy(Rec);
        Code();
        Rec := BookLoanHeader;
    end;

    var
        BookLoanHeader: Record "LIB Book Loan Header";
        BookLoanPost: Codeunit "LIB Book Loan-Post";
        ConfirmPostQst: Label 'Do you want to post the book loan?';

    local procedure Code()
    begin
        if not Confirm(ConfirmPostQst, false) then
            exit;

        BookLoanPost.Run(BookLoanHeader);
    end;
}
