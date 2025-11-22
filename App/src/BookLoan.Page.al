page 70328 "LIB Book Loan"
{
    Caption = 'Book Loan';
    PageType = Document;
    SourceTable = "LIB Book Loan Header";
    UsageCategory = None;
    Extensible = true;

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
                    ToolTip = 'Specifies the unique identifier for the book loan.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the library member borrowing the books.';
                }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the library member.';
                }
                field("Loan Date"; Rec."Loan Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the books are loaned.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected return date for the loaned books.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the book loan (Open or Posted).';
                }
            }
            part(Lines; "LIB Book Loan Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
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
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';
                ToolTip = 'Post the book loan.';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BookLoanPostYesNo: Codeunit "LIB Book Loan-Post (Yes/No)";
                begin
                    BookLoanPostYesNo.Run(Rec);
                end;
            }
        }
    }
}
