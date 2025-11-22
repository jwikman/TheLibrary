page 70325 "LIB Book List"
{
    Caption = 'Books';
    PageType = List;
    SourceTable = "LIB Book";
    CardPageId = "LIB Book Card";
    UsageCategory = Lists;
    ApplicationArea = All;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the unique identifier for the book.';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the title of the book.';
                }
                field("Author No."; Rec."Author No.")
                {
                    ToolTip = 'Specifies the author of the book.';
                }
                field(ISBN; Rec.ISBN)
                {
                    ToolTip = 'Specifies the International Standard Book Number.';
                }
                field("Genre Code"; Rec."Genre Code")
                {
                    ToolTip = 'Specifies the genre of the book.';
                }
                field("Publication Year"; Rec."Publication Year")
                {
                    ToolTip = 'Specifies the year the book was published.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the total number of copies owned.';
                }
                field("Available Quantity"; Rec."Available Quantity")
                {
                    ToolTip = 'Specifies the number of copies currently available for loan.';
                }
            }
        }
    }
}
