page 70321 "LIB Author Card"
{
    Caption = 'Author Card';
    PageType = Card;
    SourceTable = "LIB Author";
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
                    ToolTip = 'Specifies the unique identifier for the author.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the author.';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country of the author.';
                }
                field(Biography; Rec.Biography)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a brief biography of the author.';
                    MultiLine = true;
                }
            }
            group(Identifiers)
            {
                Caption = 'Identifiers';

                field(ISNI; Rec.ISNI)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the International Standard Name Identifier (16 digits).';
                }
                field(ORCID; Rec.ORCID)
                {
                    ApplicationArea = All;
#pragma warning disable AA0240
                    ToolTip = 'Specifies the Open Researcher and Contributor ID in format: 0000-0000-0000-0000.';
#pragma warning restore AA0240
                }
                field("VIAF ID"; Rec."VIAF ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Virtual International Authority File identifier.';
                }
            }
        }
    }
}
