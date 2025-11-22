page 70320 "LIB Library Setup"
{
    Caption = 'Library Setup';
    PageType = Card;
    SourceTable = "LIB Library Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Author Nos."; Rec."Author Nos.")
                {
                    ToolTip = 'Specifies the number series code used for assigning numbers to authors.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Book Nos."; Rec."Book Nos.")
                {
                    ToolTip = 'Specifies the number series code used for assigning numbers to books.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Member Nos."; Rec."Member Nos.")
                {
                    ToolTip = 'Specifies the number series code used for assigning numbers to library members.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Book Loan Nos."; Rec."Book Loan Nos.")
                {
                    ToolTip = 'Specifies the number series code used for assigning numbers to book loans.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Posted Book Loan Nos."; Rec."Posted Book Loan Nos.")
                {
                    ToolTip = 'Specifies the number series code used for assigning numbers to posted book loans.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec.Insert();
        end;
    end;
}
