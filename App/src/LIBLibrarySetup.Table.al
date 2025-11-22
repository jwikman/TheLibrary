table 70300 "LIB Library Setup"
{
    Caption = 'Library Setup';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    Extensible = true;
    Access = Public;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(10; "Author Nos."; Code[20])
        {
            Caption = 'Author Nos.';
            ToolTip = 'Specifies the number series code used for assigning numbers to authors.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(11; "Book Nos."; Code[20])
        {
            Caption = 'Book Nos.';
            ToolTip = 'Specifies the number series code used for assigning numbers to books.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(12; "Member Nos."; Code[20])
        {
            Caption = 'Member Nos.';
            ToolTip = 'Specifies the number series code used for assigning numbers to library members.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(13; "Book Loan Nos."; Code[20])
        {
            Caption = 'Book Loan Nos.';
            ToolTip = 'Specifies the number series code used for assigning numbers to book loans.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14; "Posted Book Loan Nos."; Code[20])
        {
            Caption = 'Posted Book Loan Nos.';
            ToolTip = 'Specifies the number series code used for assigning numbers to posted book loans.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}
