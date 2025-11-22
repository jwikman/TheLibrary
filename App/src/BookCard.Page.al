page 70324 "LIB Book Card"
{
    Caption = 'Book Card';
    PageType = Card;
    SourceTable = "LIB Book";
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
                    ToolTip = 'Specifies the unique identifier for the book.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the title of the book.';
                }
                field("Author No."; Rec."Author No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the author of the book.';
                }
                field(ISBN; Rec.ISBN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the International Standard Book Number.';
                }
                field("Genre Code"; Rec."Genre Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the genre of the book.';
                }
                field("Publication Year"; Rec."Publication Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the year the book was published.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the book.';
                    MultiLine = true;
                }
            }
            group(Inventory)
            {
                Caption = 'Inventory';

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of copies owned.';
                }
                field("Available Quantity"; Rec."Available Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of copies currently available for loan.';
                }
            }
        }
    }
}
