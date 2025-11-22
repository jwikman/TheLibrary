page 70329 "LIB Book Loan List"
{
    Caption = 'Book Loans';
    PageType = List;
    SourceTable = "LIB Book Loan Header";
    CardPageId = "LIB Book Loan";
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
                    ToolTip = 'Specifies the unique identifier for the book loan.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the library member borrowing the books.';
                }
                field("Member Name"; Rec."Member Name")
                {
                    ToolTip = 'Specifies the name of the library member.';
                }
                field("Loan Date"; Rec."Loan Date")
                {
                    ToolTip = 'Specifies the date when the books are loaned.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ToolTip = 'Specifies the expected return date for the loaned books.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the book loan (Open or Posted).';
                }
                field("No. of Lines"; Rec."No. of Lines")
                {
                    ToolTip = 'Specifies the number of lines in the book loan.';
                }
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
