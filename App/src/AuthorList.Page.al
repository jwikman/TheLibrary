page 70322 "LIB Author List"
{
    Caption = 'Authors';
    PageType = List;
    SourceTable = "LIB Author";
    CardPageId = "LIB Author Card";
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
                    ToolTip = 'Specifies the unique identifier for the author.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the author.';
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the country of the author.';
                }
                field(ISNI; Rec.ISNI)
                {
                    ToolTip = 'Specifies the International Standard Name Identifier (16 digits).';
                }
                field(ORCID; Rec.ORCID)
                {
#pragma warning disable AA0240
                    ToolTip = 'Specifies the Open Researcher and Contributor ID in format: 0000-0000-0000-0000.';
#pragma warning restore AA0240
                }
                field("VIAF ID"; Rec."VIAF ID")
                {
                    ToolTip = 'Specifies the Virtual International Authority File identifier.';
                }
            }
        }
    }
}
