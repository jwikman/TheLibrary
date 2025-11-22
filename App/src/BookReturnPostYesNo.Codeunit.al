codeunit 70353 "LIB Book Return-Post (Yes/No)"
{
    TableNo = "Posted LIB Book Loan Header";
    Access = Public;

    trigger OnRun()
    begin
        PostedBookLoanHeader.Copy(Rec);
        Code();
        Rec := PostedBookLoanHeader;
    end;

    var
        PostedBookLoanHeader: Record "Posted LIB Book Loan Header";
        BookReturnPost: Codeunit "LIB Book Return-Post";
        ConfirmReturnQst: Label 'Do you want to process the return of the loaned books?';

    local procedure Code()
    begin
        if not Confirm(ConfirmReturnQst, false) then
            exit;

        BookReturnPost.Run(PostedBookLoanHeader);
    end;
}
