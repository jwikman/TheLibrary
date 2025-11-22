page 70334 "Posted LIB Book Loan Subp."
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Posted LIB Book Loan Line";
    Extensible = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Book No."; Rec."Book No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the book that was loaned.';
                }
                field("Book Title"; Rec."Book Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the title of the book.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the book should be returned.';
                }
            }
        }
    }
}
