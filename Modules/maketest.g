LoadPackage( "AutoDoc" );
LoadPackage( "Modules" );

dir := DirectoryCurrent( );
files := AUTODOC_FindMatchingFiles( dir,
    ["gap", "examples", "examples/doc" ],
    [ "g", "gi", "gd" ] );
files := List(files, x -> Concatenation("../", x));

example_tree := ExtractExamples( Directory("doc/"), "ModulesForHomalg.xml", files, "All" );

QUIT_GAP( RunExamples( example_tree, rec( compareFunction := "uptowhitespace" ) ) );
