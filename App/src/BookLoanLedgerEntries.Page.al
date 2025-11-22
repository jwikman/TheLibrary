page 70333 "LIB Book Loan Ledger Entries"
{
    Caption = 'Book Loan Ledger Entries';
    PageType = List;
    SourceTable = "LIB Book Loan Ledger Entry";
    UsageCategory = Lists;
    ApplicationArea = All;
    Extensible = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the entry number.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number.';
                }
                field("Book No."; Rec."Book No.")
                {
                    ToolTip = 'Specifies the book number.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the member number.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the entry type (Loan or Return).';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the quantity (positive for loan, negative for return).';
                }
                field("Loan Date"; Rec."Loan Date")
                {
                    ToolTip = 'Specifies when the book was loaned.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies when the book should be returned.';
                }
                field("Return Date"; Rec."Return Date")
                {
                    ToolTip = 'Specifies when the book was actually returned (for Return entries).';
                }
            }
        }
    }
}
