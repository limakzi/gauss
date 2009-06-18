##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##

LoadPackage( "GAPDoc" );

SetGapDocLaTeXOptions( "utf8" );

list := [
         "../gap/OrbifoldTriangulation.gi",
         "../gap/SimplicialSet.gi",
         "../gap/Matrices.gi",
         "../gap/SCO.gi"
         ];

MakeGAPDocDoc( "doc", "SCO", list, "SCO" );

GAPDocManualLab( "SCO" );

quit;
