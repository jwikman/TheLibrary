page 70331 "Posted LIB Book Loan Card"
{
    Caption = 'Posted Book Loan';
    PageType = Card;
    SourceTable = "Posted LIB Book Loan Header";
    UsageCategory = None;
    Extensible = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the posted book loan.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the library member who borrowed the books.';
                }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the library member.';
                }
                field("Loan Date"; Rec."Loan Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the books were loaned.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected return date for the loaned books.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date of the book loan.';
                }
            }
            part(Lines; "Posted LIB Book Loan Subp.")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
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
                PromotedIsBig = true;

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
