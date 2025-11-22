page 70323 "LIB Genre List"
{
    Caption = 'Genres';
    PageType = List;
    SourceTable = "LIB Genre";
    UsageCategory = Lists;
    ApplicationArea = All;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the unique code for the genre.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description of the genre.';
                }
            }
        }
    }
}
