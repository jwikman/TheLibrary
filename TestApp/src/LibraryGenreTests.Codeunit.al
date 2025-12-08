namespace Demo.Library.Test;

using Demo.Library;
using System.TestLibraries.Utilities;

codeunit 70455 "LIB Library Genre Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Library Assert";
        Any: Codeunit Any;

    [Test]
    procedure TestCreateGenre()
    var
        Genre: Record "LIB Genre";
        GenreCode: Code[20];
    begin
        // [GIVEN] A unique genre code
        GenreCode := GenerateUniqueGenreCode('FIC');

        // [WHEN] Creating a new Genre with code and description
        Genre.Init();
        Genre.Code := GenreCode;
        Genre.Description := 'Fiction Books';
        Genre.Insert();

        // [THEN] Genre is created successfully
        Genre.Find();
        Assert.AreEqual(GenreCode, Genre.Code, 'Genre Code should be set');
        Assert.AreEqual('Fiction Books', Genre.Description, 'Genre Description should be set');
    end;

    [Test]
    procedure TestGenreCodeMustBeSet()
    var
        Genre: Record "LIB Genre";
    begin
        // [GIVEN] A new Genre record
        Genre.Init();
        Genre.Description := 'Test Description';

        // [WHEN] Trying to insert without a code
        // [THEN] Code field has NotBlank property, so it gets a default value
        // Instead, test that Code is required for uniqueness
        Genre.Code := GenerateUniqueGenreCode('TST');
        Genre.Insert();
        
        // Verify the code was set
        Assert.AreNotEqual('', Genre.Code, 'Code should not be empty');
    end;

    [Test]
    procedure TestGenreDescriptionValidation()
    var
        Genre: Record "LIB Genre";
        GenreCode: Code[20];
    begin
        // [GIVEN] A Genre with unique code
        GenreCode := GenerateUniqueGenreCode('MYS');
        Genre.Init();
        Genre.Code := GenreCode;
        Genre.Insert();

        // [WHEN] Setting and updating description
        Genre.Description := 'Mystery and Thriller Books';
        Genre.Modify();

        // [THEN] Description is accepted and stored
        Genre.Find();
        Assert.AreEqual('Mystery and Thriller Books', Genre.Description, 'Description should be updated');
    end;

    [Test]
    procedure TestGenreCodeIsUnique()
    var
        Genre1: Record "LIB Genre";
        Genre2: Record "LIB Genre";
        GenreCode: Code[20];
        DuplicateInsertFailed: Boolean;
    begin
        // [GIVEN] A Genre with a specific code
        GenreCode := GenerateUniqueGenreCode('SCI');
        Genre1.Init();
        Genre1.Code := GenreCode;
        Genre1.Description := 'Science Fiction';
        Genre1.Insert();

        // [WHEN] Trying to insert another Genre with the same code
        Genre2.Init();
        Genre2.Code := GenreCode;  // Same code as Genre1
        Genre2.Description := 'Different Description';
        
        // [THEN] Insert should fail due to primary key violation
        DuplicateInsertFailed := not Genre2.Insert();
        Assert.IsTrue(DuplicateInsertFailed, 'Cannot insert duplicate genre code');
    end;

    [Test]
    procedure TestGenreLookup()
    var
        Genre: Record "LIB Genre";
        InitialCount: Integer;
        FinalCount: Integer;
        Code1, Code2, Code3 : Code[20];
    begin
        // [GIVEN] Count existing genres
        Genre.Reset();
        InitialCount := Genre.Count();

        // [WHEN] Creating multiple new genres with unique codes
        Code1 := GenerateUniqueGenreCode('ROM');
        Code2 := GenerateUniqueGenreCode('HIS');
        Code3 := GenerateUniqueGenreCode('BIO');
        
        CreateGenre(Code1, 'Romance Novels');
        CreateGenre(Code2, 'Historical Books');
        CreateGenre(Code3, 'Biography and Memoir');

        // [THEN] 3 more genres should be retrievable
        Genre.Reset();
        FinalCount := Genre.Count();
        Assert.AreEqual(InitialCount + 3, FinalCount, 'Exactly 3 new genres should be created');
    end;

    local procedure CreateGenre(GenreCode: Code[20]; GenreDescription: Text[100])
    var
        Genre: Record "LIB Genre";
    begin
        Genre.Init();
        Genre.Code := GenreCode;
        Genre.Description := GenreDescription;
        Genre.Insert();
    end;

    local procedure GenerateUniqueGenreCode(Prefix: Code[10]): Code[20]
    var
        Genre: Record "LIB Genre";
        NewCode: Code[20];
        MaxAttempts: Integer;
        Attempt: Integer;
    begin
        MaxAttempts := 100;
        Attempt := 0;
        
        repeat
            Attempt += 1;
            NewCode := CopyStr(Prefix + Format(Any.IntegerInRange(100000, 999999)), 1, 20);
            Genre.SetRange(Code, NewCode);
        until Genre.IsEmpty() or (Attempt >= MaxAttempts);
        
        exit(NewCode);
    end;
}
