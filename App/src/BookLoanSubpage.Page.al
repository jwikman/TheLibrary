page 70330 "LIB Book Loan Subpage"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "LIB Book Loan Line";
    AutoSplitKey = true;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Book No."; Rec."Book No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the book being loaned.';
                }
                field("Book Title"; Rec."Book Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the title of the book.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity (must be 1).';
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
