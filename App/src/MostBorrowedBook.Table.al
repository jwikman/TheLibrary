namespace Demo.Library;

table 70310 "LIB Most Borrowed Book"
{
    Caption = 'Most Borrowed Book';
    TableType = Temporary;
    DataClassification = SystemMetadata;
    Extensible = false;
    Access = Public;
    InherentPermissions = X;
    InherentEntitlements = X;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line number.';
            AllowInCustomizations = AsReadOnly;
        }
        field(2; "Book No."; Code[20])
        {
            Caption = 'Book No.';
            ToolTip = 'Specifies the book number.';
            TableRelation = "LIB Book";
        }
        field(3; "Book Title"; Text[100])
        {
            Caption = 'Book Title';
            ToolTip = 'Specifies the title of the book.';
        }
        field(4; "Author No."; Code[20])
        {
            Caption = 'Author No.';
            ToolTip = 'Specifies the author number.';
            TableRelation = "LIB Author";
        }
        field(5; "Loan Count"; Integer)
        {
            Caption = 'Loan Count';
            ToolTip = 'Specifies how many times this book was loaned in the period.';
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
        key(LoanCount; "Loan Count")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Book No.", "Book Title", "Loan Count")
        {
        }
        fieldgroup(Brick; "Book Title", "Loan Count")
        {
        }
    }
}
