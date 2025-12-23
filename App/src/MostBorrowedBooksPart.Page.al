namespace Demo.Library;

page 70303 "LIB Most Borrowed Books Part"
{
    Caption = 'Most Borrowed Books';
    PageType = ListPart;
    SourceTable = "LIB Most Borrowed Book";
    SourceTableTemporary = true;
    Editable = false;
    Extensible = true;
    InherentPermissions = X;
    InherentEntitlements = X;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Book No."; Rec."Book No.")
                {
                    Caption = 'Book No.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        Book: Record "LIB Book";
                    begin
                        if Book.Get(Rec."Book No.") then
                            Page.Run(Page::"LIB Book Card", Book);
                    end;
                }
                field("Book Title"; Rec."Book Title")
                {
                    Caption = 'Book Title';
                    ApplicationArea = All;
                }
                field("Author No."; Rec."Author No.")
                {
                    Caption = 'Author No.';
                    ApplicationArea = All;
                }
                field("Loan Count"; Rec."Loan Count")
                {
                    Caption = 'Loan Count';
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = Strong;
                }
            }
        }
    }

    /// <summary>
    /// Loads the most borrowed books data into the page.
    /// </summary>
    /// <param name="TempMostBorrowedBook">Temporary record containing the most borrowed books data.</param>
    procedure LoadData(var TempMostBorrowedBook: Record "LIB Most Borrowed Book" temporary)
    begin
        Rec.Copy(TempMostBorrowedBook, true);
        CurrPage.Update(false);
    end;
}
