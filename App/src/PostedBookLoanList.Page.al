page 70332 "Posted LIB Book Loan List"
{
    Caption = 'Posted Book Loans';
    PageType = List;
    SourceTable = "Posted LIB Book Loan Header";
    CardPageId = "Posted LIB Book Loan Card";
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
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the unique identifier for the posted book loan.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the library member who borrowed the books.';
                }
                field("Member Name"; Rec."Member Name")
                {
                    ToolTip = 'Specifies the name of the library member.';
                }
                field("Loan Date"; Rec."Loan Date")
                {
                    ToolTip = 'Specifies the date when the books were loaned.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ToolTip = 'Specifies the expected return date for the loaned books.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date of the book loan.';
                }
                field("No. of Lines"; Rec."No. of Lines")
                {
                    ToolTip = 'Specifies the number of lines in the posted book loan.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Return)
            {
                ApplicationArea = All;
                Caption = 'Return';
                ToolTip = 'Process the return of the loaned books.';
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    BookReturnPostYesNo: Codeunit "LIB Book Return-Post (Yes/No)";
                begin
                    BookReturnPostYesNo.Run(Rec);
                end;
            }
        }
    }
}
