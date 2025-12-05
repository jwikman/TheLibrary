codeunit 70450 "LIB Library Setup Test"
{
    Subtype = Test;

    [Test]
    procedure TestLibrarySetupExists()
    var
        LibrarySetup: Record "LIB Library Setup";
    begin
        // [GIVEN] A fresh test environment
        
        // [WHEN] We try to get or insert Library Setup
        if not LibrarySetup.Get() then
            LibrarySetup.Insert(true);

        // [THEN] Library Setup record should exist
        LibrarySetup.Get();
    end;

    [Test]
    procedure TestLibrarySetupAuthorNos()
    var
        LibrarySetup: Record "LIB Library Setup";
    begin
        // [GIVEN] Library Setup exists
        if not LibrarySetup.Get() then
            LibrarySetup.Insert(true);

        // [WHEN] We set Author Nos.
        LibrarySetup."Author Nos." := 'AUTHOR';
        LibrarySetup.Modify(true);

        // [THEN] The field should be updated
        LibrarySetup.Get();
        if LibrarySetup."Author Nos." <> 'AUTHOR' then
            Error('Expected Author Nos. to be AUTHOR, but was %1', LibrarySetup."Author Nos.");
    end;
}
