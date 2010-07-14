#############################################################################
##
##  Tools.gi                    MatricesForHomalg package    Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations of homalg tools.
##
#############################################################################

####################################
#
# methods for operations (you MUST replace for an external CAS):
#
####################################

################################
##
## operations for ring elements:
##
################################

##
InstallMethod( Zero,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    local RP;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.Zero) then
        if IsFunction( RP!.Zero ) then
            return RP!.Zero( R );
        else
            return RP!.Zero;
        fi;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( One,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    local RP;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.One) then
        if IsFunction( RP!.One ) then
            return RP!.One( R );
        else
            return RP!.One;
        fi;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( MinusOne,
        "for homalg rings",
        [ IsHomalgRing ],
        
  function( R )
    local RP;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.MinusOne) then
        if IsFunction( RP!.MinusOne ) then
            return RP!.MinusOne( R );
        else
            return RP!.MinusOne;
        fi;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( IsZero,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    local R, RP;
    
    R := HomalgRing( r );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.IsZero) then
        return RP!.IsZero( r );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( IsOne,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    local R, RP;
    
    R := HomalgRing( r );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.IsOne) then
        return RP!.IsOne( r );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( IsMinusOne,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return IsZero( r + One( r ) );
    
end );

## a synonym of `-<elm>':
InstallMethod( AdditiveInverseMutable,
        "for homalg rings elements",
        [ IsHomalgRingElement ],
        
  function( r )
    local R, RP;
    
    R := HomalgRing( r );
    
    if not HasRingElementConstructor( R ) then
        Error( "no ring element constructor found in the ring\n" );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.Minus) and IsBound(RP!.Zero) and HasRingElementConstructor( R ) then
        return RingElementConstructor( R )( RP!.Minus( Zero( R ), r ), R );
    fi;
    
    ## never fall back to:
    ## return Zero( r ) - r;
    ## this will cause an infinite loop with a method for \- in LIRNG.gi
    
    TryNextMethod( );
    
end );

##
InstallMethod( \/,
        "for homalg ring elements",
        [ IsHomalgRingElement, IsHomalgRingElement ],
        
  function( a, u )
    local R, RP, au;
    
    R := HomalgRing( a );
    
    if not HasRingElementConstructor( R ) then
        Error( "no ring element constructor found in the ring\n" );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.DivideByUnit) then
        au := RP!.DivideByUnit( a, u );
        if au = fail then
            return fail;
        fi;
        return RingElementConstructor( R )( au, R );
    fi;
    
    Error( "could not find a procedure called DivideByUnit in the homalgTable\n" );
    
end );

##
InstallMethod( DegreeMultivariatePolynomial,
        "for homalg rings elements",
        [ IsHomalgRingElement ],
        
  function( r )
    local R, RP, weights, minus_r;
    
    R := HomalgRing( r );
    
    RP := homalgTable( R );
    
    if Set( WeightsOfIndeterminates( R ) ) <> [ 1 ] then
        
        weights := WeightsOfIndeterminates( R );
        
        if IsList( weights[1] ) then
            if IsBound(RP!.MultiWeightedDegreeMultivariatePolynomial) then
                return RP!.MultiWeightedDegreeMultivariatePolynomial( r, weights, R );
            fi;
        elif IsBound(RP!.WeightedDegreeMultivariatePolynomial) then
            return RP!.WeightedDegreeMultivariatePolynomial( r, weights, R );
        fi;
        
    elif IsBound(RP!.DegreeMultivariatePolynomial) then
        
        return RP!.DegreeMultivariatePolynomial( r, R );
        
    fi;
    
    TryNextMethod( );
    
end );

###########################
##
## operations for matrices:
##
###########################

##  <#GAPDoc Label="IsZeroMatrix:homalgTable_entry">
##  <ManSection>
##    <Func Arg="M" Name="IsZeroMatrix" Label="homalgTable entry"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>M</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>IsZeroMatrix</C> is bound then the standard method
##      for the property <Ref Prop="IsZero" Label="for matrices"/> shown below returns
##      <M>RP</M>!.<C>IsZeroMatrix</C><M>( <A>M</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( IsZero,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.IsZeroMatrix) then
        ## CAUTION: the external system must be able
        ## to check zero modulo possible ring relations!
        
        return RP!.IsZeroMatrix( M ); ## with this, \= can fall back to IsZero
    fi;
    
    #=====# the fallback method #=====#
    
    ## from the GAP4 documentation: ?Zero
    ## `ZeroSameMutability( <obj> )' is equivalent to `0 * <obj>'.
    
    return M = 0 * M; ## hence, by default, IsZero falls back to \= (see below)
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##----------------------
## the methods for Eval:
##----------------------

##  <#GAPDoc Label="Eval:IsInitialMatrix">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with HomalgInitialMatrix"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix <A>C</A> was created using
##      <Ref Meth="HomalgInitialMatrix" Label="constructor for initial matrices filled with zeros"/>
##      then the filter <C>IsInitialMatrix</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      (&see; <Ref Meth="InitialMatrix" Label="homalgTable entry for initial matrices"/>)
##      will be used to set the attribute <C>Eval</C> and resets the filter <C>IsInitialMatrix</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (IsInitialMatrix)",
        [ IsHomalgMatrix and IsInitialMatrix and
          HasNrRows and HasNrColumns ],
        
  function( C )
    local R, RP, z, zz;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if IsBound( RP!.InitialMatrix ) then
        ResetFilterObj( C, IsInitialMatrix );
        return RP!.InitialMatrix( C );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called InitialMatrix in the ",
               "homalgTable to evaluate a non-internal initial matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    z := Zero( HomalgRing( C ) );
    
    ResetFilterObj( C, IsInitialMatrix );
    
    zz := ListWithIdenticalEntries( NrColumns( C ), z );
    
    return homalgInternalMatrixHull(
                   List( [ 1 .. NrRows( C ) ], i -> ShallowCopy( zz ) ) );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="InitialMatrix:homalgTable_entry">
##  <ManSection>
##    <Func Arg="C" Name="InitialMatrix" Label="homalgTable entry for initial matrices"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>InitialMatrix</C> is bound then the method
##      <Ref Meth="Eval" Label="for matrices created with HomalgInitialMatrix"/>
##      resets the filter <C>IsInitialMatrix</C> and returns <M>RP</M>!.<C>InitialMatrix</C><M>( <A>C</A> )</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:IsInitialIdentityMatrix">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with HomalgInitialIdentityMatrix"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix <A>C</A> was created using
##      <Ref Meth="HomalgInitialIdentityMatrix" Label="constructor for initial quadratic matrices with ones on the diagonal"/>
##      then the filter <C>IsInitialIdentityMatrix</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      (&see; <Ref Meth="InitialIdentityMatrix" Label="homalgTable entry for initial identity matrices"/>)
##      will be used to set the attribute <C>Eval</C> and resets the filter <C>IsInitialIdentityMatrix</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (IsInitialIdentityMatrix)",
        [ IsHomalgMatrix and IsInitialIdentityMatrix and
          HasNrRows and HasNrColumns ],
        
  function( C )
    local R, RP, o, z, zz, id;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if IsBound( RP!.InitialIdentityMatrix ) then
        ResetFilterObj( C, IsInitialIdentityMatrix );
        return RP!.InitialIdentityMatrix( C );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called InitialIdentityMatrix in the ",
               "homalgTable to evaluate a non-internal initial identity matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    z := Zero( HomalgRing( C ) );
    o := One( HomalgRing( C ) );
    
    ResetFilterObj( C, IsInitialIdentityMatrix );
    
    zz := ListWithIdenticalEntries( NrColumns( C ), z );
    
    id := List( [ 1 .. NrRows( C ) ],
                function(i)
                  local z;
                  z := ShallowCopy( zz ); z[i] := o; return z;
                end );
    
    return homalgInternalMatrixHull( id );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="InitialIdentityMatrix:homalgTable_entry">
##  <ManSection>
##    <Func Arg="C" Name="InitialIdentityMatrix" Label="homalgTable entry for initial identity matrices"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>InitialIdentityMatrix</C> is bound then the method
##      <Ref Meth="Eval" Label="for matrices created with HomalgInitialIdentityMatrix"/>
##      resets the filter <C>IsInitialIdentityMatrix</C> and returns <M>RP</M>!.<C>InitialIdentityMatrix</C><M>( <A>C</A> )</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##
InstallMethod( Eval,
        "for homalg matrices (HasEvalMatrixOperation)",
        [ IsHomalgMatrix and HasEvalMatrixOperation ],
        
  function( C )
    local func_arg;
    
    func_arg := EvalMatrixOperation( C );
    
    ResetFilterObj( C, EvalMatrixOperation );
    
    ## delete the component which was left over by GAP
    Unbind( C!.EvalMatrixOperation );
    
    return CallFuncList( func_arg[1], func_arg[2] );
    
end );

##  <#GAPDoc Label="Eval:HasEvalInvolution">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with Involution"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="Involution" Label="for matrices"/>
##      then the filter <C>HasEvalInvolution</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="Involution" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalInvolution)",
        [ IsHomalgMatrix and HasEvalInvolution ],
        
  function( C )
    local R, RP, M;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    M :=  EvalInvolution( C );
    
    if IsBound(RP!.Involution) then
        return RP!.Involution( M );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called Involution in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return homalgInternalMatrixHull( TransposedMat( Eval( M )!.matrix ) );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Involution:homalgTable_entry">
##  <ManSection>
##    <Func Arg="M" Name="Involution" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>Involution</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with Involution"/> returns
##      <M>RP</M>!.<C>Involution</C> applied to the content of the attribute <C>EvalInvolution</C><M>( <A>C</A> ) = <A>M</A></M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:HasEvalCertainRows">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with CertainRows"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="CertainRows" Label="for matrices"/>
##      then the filter <C>HasEvalCertainRows</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="CertainRows" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalCertainRows)",
        [ IsHomalgMatrix and HasEvalCertainRows ],
        
  function( C )
    local R, RP, e, M, plist;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    e :=  EvalCertainRows( C );
    
    M := e[1];
    plist := e[2];
    
    if IsBound(RP!.CertainRows) then
        return RP!.CertainRows( M, plist );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called CertainRows in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return homalgInternalMatrixHull( Eval( M )!.matrix{ plist } );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="CertainRows:homalgTable_entry">
##  <ManSection>
##    <Func Arg="M, plist" Name="CertainRows" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>CertainRows</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with CertainRows"/> returns
##      <M>RP</M>!.<C>CertainRows</C> applied to the content of the attribute
##      <C>EvalCertainRows</C><M>( <A>C</A> ) = [ <A>M</A>, <A>plist</A> ]</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:HasEvalCertainColumns">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with CertainColumns"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="CertainColumns" Label="for matrices"/>
##      then the filter <C>HasEvalCertainColumns</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="CertainColumns" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalCertainColumns)",
        [ IsHomalgMatrix and HasEvalCertainColumns ],
        
  function( C )
    local R, RP, e, M, plist;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    e :=  EvalCertainColumns( C );
    
    M := e[1];
    plist := e[2];
    
    if IsBound(RP!.CertainColumns) then
        return RP!.CertainColumns( M, plist );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called CertainColumns in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return homalgInternalMatrixHull(
                   Eval( M )!.matrix{[ 1 .. NrRows( M ) ]}{plist} );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="CertainColumns:homalgTable_entry">
##  <ManSection>
##    <Func Arg="M, plist" Name="CertainColumns" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>CertainColumns</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with CertainColumns"/> returns
##      <M>RP</M>!.<C>CertainColumns</C> applied to the content of the attribute
##      <C>EvalCertainColumns</C><M>( <A>C</A> ) = [ <A>M</A>, <A>plist</A> ]</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:HasEvalUnionOfRows">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with UnionOfRows"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="UnionOfRows" Label="for matrices"/>
##      then the filter <C>HasEvalUnionOfRows</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="UnionOfRows" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalUnionOfRows)",
        [ IsHomalgMatrix and HasEvalUnionOfRows ],
        
  function( C )
    local R, RP, e, A, B, U;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    e :=  EvalUnionOfRows( C );
    
    A := e[1];
    B := e[2];
    
    if IsBound(RP!.UnionOfRows) then
        return RP!.UnionOfRows( A, B );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called UnionOfRows in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    U := ShallowCopy( Eval( A )!.matrix );
    
    U{ [ NrRows( A ) + 1 .. NrRows( A ) + NrRows( B ) ] } := Eval( B )!.matrix;
    
    return homalgInternalMatrixHull( U );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="UnionOfRows:homalgTable_entry">
##  <ManSection>
##    <Func Arg="A, B" Name="UnionOfRows" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>UnionOfRows</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with UnionOfRows"/> returns
##      <M>RP</M>!.<C>UnionOfRows</C> applied to the content of the attribute
##      <C>EvalUnionOfRows</C><M>( <A>C</A> ) = [ <A>A</A>, <A>B</A> ]</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:HasEvalUnionOfColumns">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with UnionOfColumns"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="UnionOfColumns" Label="for matrices"/>
##      then the filter <C>HasEvalUnionOfColumns</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="UnionOfColumns" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalUnionOfColumns)",
        [ IsHomalgMatrix and HasEvalUnionOfColumns ],
        
  function( C )
    local R, RP, e, A, B, U;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    e :=  EvalUnionOfColumns( C );
    
    A := e[1];
    B := e[2];
    
    if IsBound(RP!.UnionOfColumns) then
        return RP!.UnionOfColumns( A, B );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called UnionOfColumns in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    U := List( Eval( A )!.matrix, ShallowCopy );
    
    U{ [ 1 .. NrRows( A ) ] }
      { [ NrColumns( A ) + 1 .. NrColumns( A ) + NrColumns( B ) ] }
      := Eval( B )!.matrix;
    
    return homalgInternalMatrixHull( U );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="UnionOfColumns:homalgTable_entry">
##  <ManSection>
##    <Func Arg="A, B" Name="UnionOfColumns" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>UnionOfColumns</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with UnionOfColumns"/> returns
##      <M>RP</M>!.<C>UnionOfColumns</C> applied to the content of the attribute
##      <C>EvalUnionOfColumns</C><M>( <A>C</A> ) = [ <A>A</A>, <A>B</A> ]</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:HasEvalDiagMat">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with DiagMat"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="DiagMat" Label="for matrices"/>
##      then the filter <C>HasEvalDiagMat</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="DiagMat" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalDiagMat)",
        [ IsHomalgMatrix and HasEvalDiagMat ],
        
  function( C )
    local R, RP, e, z, m, n, diag, mat;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    e :=  EvalDiagMat( C );
    
    if IsBound(RP!.DiagMat) then
        return RP!.DiagMat( e );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called DiagMat in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    z := Zero( R );
    
    m := Sum( List( e, NrRows ) );
    n := Sum( List( e, NrColumns ) );
    
    diag := List( [ 1 .. m ],  a -> List( [ 1 .. n ], b -> z ) );
    
    m := 0;
    n := 0;
    
    for mat in e do
        diag{ [ m + 1 .. m + NrRows( mat ) ] }{ [ n + 1 .. n + NrColumns( mat ) ] }
          := Eval( mat )!.matrix;
        
        m := m + NrRows( mat );
        n := n + NrColumns( mat );
    od;
    
    return homalgInternalMatrixHull( diag );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="DiagMat:homalgTable_entry">
##  <ManSection>
##    <Func Arg="e" Name="DiagMat" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>DiagMat</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with DiagMat"/> returns
##      <M>RP</M>!.<C>DiagMat</C> applied to the content of the attribute
##      <C>EvalDiagMat</C><M>( <A>C</A> ) = <A>e</A></M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:HasEvalKroneckerMat">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with KroneckerMat"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="KroneckerMat" Label="for matrices"/>
##      then the filter <C>HasEvalKroneckerMat</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="KroneckerMat" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalKroneckerMat)",
        [ IsHomalgMatrix and HasEvalKroneckerMat ],
        
  function( C )
    local R, RP, A, B;
    
    R := HomalgRing( C );
    
    if HasIsCommutative( R ) and not IsCommutative( R ) then
        Info( InfoWarning, 1, "\033[01m\033[5;31;47m",
              "the Kronecker product is only defined for commutative rings!",
              "\033[0m" );
    fi;
    
    RP := homalgTable( R );
    
    A :=  EvalKroneckerMat( C )[1];
    B :=  EvalKroneckerMat( C )[2];
    
    if IsBound(RP!.KroneckerMat) then
        return RP!.KroneckerMat( A, B );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called KroneckerMat in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return homalgInternalMatrixHull(
                   KroneckerProduct( Eval( A )!.matrix, Eval( B )!.matrix ) );
    ## this was easy, thanks GAP :)
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="KroneckerMat:homalgTable_entry">
##  <ManSection>
##    <Func Arg="A, B" Name="KroneckerMat" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>KroneckerMat</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with KroneckerMat"/> returns
##      <M>RP</M>!.<C>KroneckerMat</C> applied to the content of the attribute
##      <C>EvalKroneckerMat</C><M>( <A>C</A> ) = [ <A>A</A>, <A>B</A> ]</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:HasEvalMulMat">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with MulMat"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="\*" Label="for ring elements and matrices"/>
##      then the filter <C>HasEvalMulMat</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="MulMat" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalMulMat)",
        [ IsHomalgMatrix and HasEvalMulMat ],
        
  function( C )
    local R, RP, e, a, A;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    e :=  EvalMulMat( C );
    
    a := e[1];
    A := e[2];
    
    if IsBound(RP!.MulMat) then
        return RP!.MulMat( a, A );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called MulMat in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return a * Eval( A );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="MulMat:homalgTable_entry">
##  <ManSection>
##    <Func Arg="a, A" Name="MulMat" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>MulMat</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with MulMat"/> returns
##      <M>RP</M>!.<C>MulMat</C> applied to the content of the attribute
##      <C>EvalMulMat</C><M>( <A>C</A> ) = [ <A>a</A>, <A>A</A> ]</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:HasEvalAddMat">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with AddMat"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="\+" Label="for matrices"/>
##      then the filter <C>HasEvalAddMat</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="AddMat" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalAddMat)",
        [ IsHomalgMatrix and HasEvalAddMat ],
        
  function( C )
    local R, RP, e, A, B;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    e :=  EvalAddMat( C );
    
    A := e[1];
    B := e[2];
    
    if IsBound(RP!.AddMat) then
        return RP!.AddMat( A, B );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called AddMat in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return Eval( A ) + Eval( B );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="AddMat:homalgTable_entry">
##  <ManSection>
##    <Func Arg="A, B" Name="AddMat" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>AddMat</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with AddMat"/> returns
##      <M>RP</M>!.<C>AddMat</C> applied to the content of the attribute
##      <C>EvalAddMat</C><M>( <A>C</A> ) = [ <A>A</A>, <A>B</A> ]</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:HasEvalSubMat">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with SubMat"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="\-" Label="for matrices"/>
##      then the filter <C>HasEvalSubMat</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="SubMat" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalSubMat)",
        [ IsHomalgMatrix and HasEvalSubMat ],
        
  function( C )
    local R, RP, e, A, B;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    e :=  EvalSubMat( C );
    
    A := e[1];
    B := e[2];
    
    if IsBound(RP!.SubMat) then
        return RP!.SubMat( A, B );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called SubMat in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return Eval( A ) - Eval( B );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="SubMat:homalgTable_entry">
##  <ManSection>
##    <Func Arg="A, B" Name="SubMat" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>SubMat</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with SubMat"/> returns
##      <M>RP</M>!.<C>SubMat</C> applied to the content of the attribute
##      <C>EvalSubMat</C><M>( <A>C</A> ) = [ <A>A</A>, <A>B</A> ]</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:HasEvalCompose">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with Compose"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix was created using
##      <Ref Meth="\*" Label="for composable matrices"/>
##      then the filter <C>HasEvalCompose</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      <Ref Meth="Compose" Label="homalgTable entry"/>
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (HasEvalCompose)",
        [ IsHomalgMatrix and HasEvalCompose ],
        
  function( C )
    local R, RP, e, A, B;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    e :=  EvalCompose( C );
    
    A := e[1];
    B := e[2];
    
    if IsBound(RP!.Compose) then
        return RP!.Compose( A, B );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called Compose in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return Eval( A ) * Eval( B );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Compose:homalgTable_entry">
##  <ManSection>
##    <Func Arg="A, B" Name="Compose" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>Compose</C> is bound then
##      the method <Ref Meth="Eval" Label="for matrices created with Compose"/> returns
##      <M>RP</M>!.<C>Compose</C> applied to the content of the attribute
##      <C>EvalCompose</C><M>( <A>C</A> ) = [ <A>A</A>, <A>B</A> ]</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:IsIdentityMatrix">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with HomalgIdentityMatrix"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix <A>C</A> was created using
##      <Ref Meth="HomalgIdentityMatrix" Label="constructor for identity matrices"/>
##      then the filter <C>IsOne</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      (&see; <Ref Meth="IdentityMatrix" Label="homalgTable entry"/>)
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (IsOne)",
        [ IsHomalgMatrix and IsOne and HasNrRows and HasNrColumns ], 10,
        
  function( C )
    local R, RP, o, z, zz, id;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if IsBound( RP!.IdentityMatrix ) then
        return RP!.IdentityMatrix( C );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called IdentityMatrix in the ",
               "homalgTable to evaluate a non-internal identity matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    z := Zero( HomalgRing( C ) );
    o := One( HomalgRing( C ) );
    
    zz := ListWithIdenticalEntries( NrColumns( C ), z );
    
    id := List( [ 1 .. NrRows( C ) ],
                function(i)
                  local z;
                  z := ShallowCopy( zz ); z[i] := o; return z;
                end );
    
    return homalgInternalMatrixHull( id );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="IdentityMatrix:homalgTable_entry">
##  <ManSection>
##    <Func Arg="C" Name="IdentityMatrix" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>IdentityMatrix</C> is bound then the method
##      <Ref Meth="Eval" Label="for matrices created with HomalgIdentityMatrix"/> returns
##      <M>RP</M>!.<C>IdentityMatrix</C><M>( <A>C</A> )</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Eval:IsZeroMatrix">
##  <ManSection>
##    <Meth Arg="C" Name="Eval" Label="for matrices created with HomalgZeroMatrix"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      In case the matrix <A>C</A> was created using
##      <Ref Meth="HomalgZeroMatrix" Label="constructor for zero matrices"/>
##      then the filter <C>IsZeroMatrix</C> for <A>C</A> is set to true and the <C>homalgTable</C> function
##      (&see; <Ref Meth="ZeroMatrix" Label="homalgTable entry"/>)
##      will be used to set the attribute <C>Eval</C>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( Eval,
        "for homalg matrices (IsZero)",
        [ IsHomalgMatrix and IsZero and HasNrRows and HasNrColumns ], 20,
        
  function( C )
    local R, RP, z;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if ( NrRows( C ) = 0 or NrColumns( C ) = 0 ) and
       not ( IsBound( R!.SafeToEvaluateEmptyMatrices ) and
             R!.SafeToEvaluateEmptyMatrices = true ) then
        Info( InfoWarning, 1, "\033[01m\033[5;31;47m",
              "an empty matrix is about to get evaluated!",
              "\033[0m" );
    fi;
    
    if IsBound( RP!.ZeroMatrix ) then
        return RP!.ZeroMatrix( C );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called ZeroMatrix in the ",
               "homalgTable to evaluate a non-internal zero matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    z := Zero( HomalgRing( C ) );
    
    ## copying the rows saves memory;
    ## we assume that the entries are never modified!!!
    return homalgInternalMatrixHull(
                   ListWithIdenticalEntries( NrRows( C ),
                           ListWithIdenticalEntries( NrColumns( C ), z ) ) );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="ZeroMatrix:homalgTable_entry">
##  <ManSection>
##    <Func Arg="C" Name="ZeroMatrix" Label="homalgTable entry"/>
##    <Returns>the <C>Eval</C> value of a &homalg; matrix <A>C</A></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>ZeroMatrix</C> is bound then the method
##      <Ref Meth="Eval" Label="for matrices created with HomalgZeroMatrix"/> returns
##      <M>RP</M>!.<C>ZeroMatrix</C><M>( <A>C</A> )</M>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="NrRows:homalgTable_entry">
##  <ManSection>
##    <Func Arg="C" Name="NrRows" Label="homalgTable entry"/>
##    <Returns>a nonnegative integer</Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>NrRows</C> is bound then the standard method
##      for the attribute <Ref Attr="NrRows"/> shown below returns
##      <M>RP</M>!.<C>NrRows</C><M>( <A>C</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( NrRows,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    local R, RP;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.NrRows) then
        return RP!.NrRows( C );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called NrRows in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return Length( Eval( C )!.matrix );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="NrColumns:homalgTable_entry">
##  <ManSection>
##    <Func Arg="C" Name="NrColumns" Label="homalgTable entry"/>
##    <Returns>a nonnegative integer</Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>NrColumns</C> is bound then the standard method
##      for the attribute <Ref Attr="NrColumns"/> shown below returns
##      <M>RP</M>!.<C>NrColumns</C><M>( <A>C</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( NrColumns,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    local R, RP;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.NrColumns) then
        return RP!.NrColumns( C );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called NrColumns in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return Length( Eval( C )!.matrix[ 1 ] );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="Determinant:homalgTable_entry">
##  <ManSection>
##    <Func Arg="C" Name="Determinant" Label="homalgTable entry"/>
##    <Returns>a ring element</Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>Determinant</C> is bound then the standard method
##      for the attribute <Ref Attr="DeterminantMat"/> shown below returns
##      <M>RP</M>!.<C>Determinant</C><M>( <A>C</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( DeterminantMat,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    local R, RP;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if NrRows( C ) <> NrColumns( C ) then
        Error( "the matrix is not quadratic\n" );
    fi;
    
    if IsBound(RP!.Determinant) then
        return RingElementConstructor( R )( RP!.Determinant( C ), R );
    fi;
    
    if not IsHomalgInternalMatrixRep( C ) then
        Error( "could not find a procedure called Determinant in the ",
               "homalgTable to apply to a non-internal matrix\n" );
    fi;
    
    #=====# can only work for homalg internal matrices #=====#
    
    return Determinant( Eval( C )!.matrix );
    
end );

##
InstallMethod( Determinant,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    
    return DeterminantMat( C );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

####################################
#
# methods for operations (you probably want to replace for an external CAS):
#
####################################

##
InstallMethod( IsUnit,
        "for homalg ring elements",
        [ IsHomalgRing, IsRingElement ],
        
  function( R, r )
    local RP;
    
    if HasIsZero( r ) and IsZero( r ) then
        return false;
    elif HasIsOne( r ) and IsOne( r ) then
        return true;
    fi;
    
    return not IsBool( Eval( LeftInverse( HomalgMatrix( [ r ], 1, 1, R ) ) ) );
    
end );

##
InstallMethod( IsUnit,
        "for homalg ring elements",
        [ IsHomalgRing, IsHomalgRingElement ],
        
  function( R, r )
    local RP;
    
    if HasIsZero( r ) and IsZero( r ) then
        return false;
    elif HasIsOne( r ) and IsOne( r ) then
        return true;
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.IsUnit) then
        return RP!.IsUnit( R, r );
    fi;
    
    #=====# the fallback method #=====#
    
    return not IsBool( Eval( LeftInverse( HomalgMatrix( [ r ], 1, 1, R ) ) ) );
    
end );

##
InstallMethod( IsUnit,
        "for homalg ring elements",
        [ IsHomalgInternalRingRep, IsRingElement ],
        
  function( R, r )
    
    return IsUnit( R!.ring, r );
    
end );

##
InstallMethod( IsUnit,
        "for homalg ring elements",
        [ IsHomalgRingElement ],
        
  function( r )
    
    return IsUnit( HomalgRing( r ), r );
    
end );

##  <#GAPDoc Label="ZeroRows:homalgTable_entry">
##  <ManSection>
##    <Func Arg="C" Name="ZeroRows" Label="homalgTable entry"/>
##    <Returns>a (possibly empty) list of positive integers</Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>ZeroRows</C> is bound then the standard method
##      of the attribute <Ref Attr="ZeroRows"/> shown below returns
##      <M>RP</M>!.<C>ZeroRows</C><M>( <A>C</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( ZeroRows,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    local R, RP, z;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.ZeroRows) then
        return RP!.ZeroRows( C );
    fi;
    
    #=====# the fallback method #=====#
    
    z := HomalgZeroMatrix( 1, NrColumns( C ), R );
    
    return Filtered( [ 1 .. NrRows( C ) ], a -> CertainRows( C, [ a ] ) = z );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="ZeroColumns:homalgTable_entry">
##  <ManSection>
##    <Func Arg="C" Name="ZeroColumns" Label="homalgTable entry"/>
##    <Returns>a (possibly empty) list of positive integers</Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>ZeroColumns</C> is bound then the standard method
##      of the attribute <Ref Attr="ZeroColumns"/> shown below returns
##      <M>RP</M>!.<C>ZeroColumns</C><M>( <A>C</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( ZeroColumns,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    local R, RP, z;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.ZeroColumns) then
        return RP!.ZeroColumns( C );
    fi;
    
    #=====# the fallback method #=====#
    
    z := HomalgZeroMatrix( NrRows( C ), 1, R );
    
    return Filtered( [ 1 .. NrColumns( C ) ], a -> CertainColumns( C, [ a ] ) = z );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##
InstallMethod( GetRidOfObsoleteRows,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    local R, RP, M;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.GetRidOfObsoleteRows) then
        M := HomalgMatrix( RP!.GetRidOfObsoleteRows( C ), R );
        if HasNrColumns( C ) then
            SetNrColumns( M, NrColumns( C ) );
        fi;
        SetZeroRows( M, [ ] );
        return M;
    fi;
    
    #=====# the fallback method #=====#
    
    ## get rid of zero rows
    ## (e.g. those rows containing the ring relations)
    
    M := CertainRows( C, NonZeroRows( C ) );
    
    SetZeroRows( M, [ ] );
    
    ## forgetting C may save memory
    if HasEvalCertainRows( M ) then
        if not IsEmptyMatrix( M ) then
            Eval( M );
        fi;
        ResetFilterObj( M, EvalCertainRows );
        Unbind( M!.EvalCertainRows );
    fi;
    
    return M;
    
end );

##
InstallMethod( GetRidOfObsoleteColumns,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    local R, RP, M;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.GetRidOfObsoleteColumns) then
        M := HomalgMatrix( RP!.GetRidOfObsoleteColumns( C ), R );
        if HasNrRows( C ) then
            SetNrRows( M, NrRows( C ) );
        fi;
        SetZeroColumns( M, [ ] );
        return M;
    fi;
    
    #=====# the fallback method #=====#
    
    ## get rid of zero columns
    ## (e.g. those columns containing the ring relations)
    
    M := CertainColumns( C, NonZeroColumns( C ) );
    
    SetZeroColumns( M, [ ] );
    
    ## forgetting C may save memory
    if HasEvalCertainColumns( M ) then
        if not IsEmptyMatrix( M ) then
            Eval( M );
        fi;
        ResetFilterObj( M, EvalCertainColumns );
        Unbind( M!.EvalCertainColumns );
    fi;
    
    return M;
    
end );

##  <#GAPDoc Label="AreEqualMatrices:homalgTable_entry">
##  <ManSection>
##    <Func Arg="M1,M2" Name="AreEqualMatrices" Label="homalgTable entry"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>M1</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>AreEqualMatrices</C> is bound then the standard method
##      for the operation <Ref Oper="\=" Label="for matrices"/> shown below returns
##      <M>RP</M>!.<C>AreEqualMatrices</C><M>( <A>M1</A>, <A>M2</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( \=,
        "for homalg comparable matrices",
        [ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    local R, RP;
    
    R := HomalgRing( M1 );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.AreEqualMatrices) then
        ## CAUTION: the external system must be able to check equality
        ## modulo possible ring relations (known to the external system)!
        return RP!.AreEqualMatrices( M1, M2 );
    elif IsBound(RP!.Equal) then
        ## CAUTION: the external system must be able to check equality
        ## modulo possible ring relations (known to the external system)!
        return RP!.Equal( M1, M2 );
    elif IsBound(RP!.IsZeroMatrix) then   ## ensuring this avoids infinite loops
        return IsZero( M1 - M2 );
    fi;
    
    TryNextMethod( );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="IsIdentityMatrix:homalgTable_entry">
##  <ManSection>
##    <Func Arg="M" Name="IsIdentityMatrix" Label="homalgTable entry"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>M</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>IsIdentityMatrix</C> is bound then the standard method
##      for the property <Ref Prop="IsOne"/> shown below returns
##      <M>RP</M>!.<C>IsIdentityMatrix</C><M>( <A>M</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( IsOne,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP;
    
    if NrRows( M ) <> NrColumns( M ) then
        return false;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.IsIdentityMatrix) then
        return RP!.IsIdentityMatrix( M );
    fi;
    
    #=====# the fallback method #=====#
    
    return M = HomalgIdentityMatrix( NrRows( M ), HomalgRing( M ) );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="IsDiagonalMatrix:homalgTable_entry">
##  <ManSection>
##    <Func Arg="M" Name="IsDiagonalMatrix" Label="homalgTable entry"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>M</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>IsDiagonalMatrix</C> is bound then the standard method
##      for the property <Ref Meth="IsDiagonalMatrix"/> shown below returns
##      <M>RP</M>!.<C>IsDiagonalMatrix</C><M>( <A>M</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( IsDiagonalMatrix,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, diag;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.IsDiagonalMatrix) then
        return RP!.IsDiagonalMatrix( M );
    fi;
    
    #=====# the fallback method #=====#
    
    diag := DiagonalEntries( M );
    
    return M = HomalgDiagonalMatrix( diag, NrRows( M ), NrColumns( M ), R );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="GetColumnIndependentUnitPositions">
##  <ManSection>
##    <Oper Arg="A, poslist" Name="GetColumnIndependentUnitPositions" Label="for matrices"/>
##    <Returns>a (possibly empty) list of pairs of positive integers</Returns>
##    <Description>
##      The list of column independet unit position of the matrix <A>A</A>.
##      We say that a unit <A>A</A><M>[i,k]</M> is column independet from the unit <A>A</A><M>[l,j]</M>
##      if <M>i>l</M> and <A>A</A><M>[l,k]=0</M>.
##      The rows are scanned from top to bottom and within each row the columns are
##      scanned from right to left searching for new units, column independent from the preceding ones.
##      If <A>A</A><M>[i,k]</M> is a new column independent unit then <M>[i,k]</M> is added to the
##      output list. If <A>A</A> has no units the empty list is returned.<P/>
##      (for the installed standard method see <Ref Meth="GetColumnIndependentUnitPositions" Label="homalgTable entry"/>)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="GetColumnIndependentUnitPositions:homalgTable_entry">
##  <ManSection>
##    <Func Arg="M, poslist" Name="GetColumnIndependentUnitPositions" Label="homalgTable entry"/>
##    <Returns>a (possibly empty) list of pairs of positive integers</Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>M</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>GetColumnIndependentUnitPositions</C> is bound then the standard method
##      of the operation <Ref Meth="GetColumnIndependentUnitPositions" Label="for matrices"/> returns
##      <M>RP</M>!.<C>GetColumnIndependentUnitPositions</C><M>( <A>M</A>, <A>poslist</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( GetColumnIndependentUnitPositions,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomogeneousList ],
        
  function( M, poslist )
    local R, RP, rest, pos, i, j, k;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.GetColumnIndependentUnitPositions) then
        pos := RP!.GetColumnIndependentUnitPositions( M, poslist );
        if pos <> [ ] then
            SetIsZero( M, false );
        fi;
        return pos;
    fi;
    
    #=====# the fallback method #=====#
    
    rest := [ 1 .. NrColumns( M ) ];
    
    pos := [ ];
    
    for i in [ 1 .. NrRows( M ) ] do
        for k in Reversed( rest ) do
            if not [ i, k ] in poslist and
               IsUnit( R, GetEntryOfHomalgMatrix( M, i, k ) ) then
                Add( pos, [ i, k ] );
                rest := Filtered( rest,
                                a -> IsZero( GetEntryOfHomalgMatrix( M, i, a ) ) );
                break;
            fi;
        od;
    od;
    
    if pos <> [ ] then
        SetIsZero( M, false );
    fi;
    
    return pos;
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="GetRowIndependentUnitPositions">
##  <ManSection>
##    <Oper Arg="A, poslist" Name="GetRowIndependentUnitPositions" Label="for matrices"/>
##    <Returns>a (possibly empty) list of pairs of positive integers</Returns>
##    <Description>
##      The list of row independet unit position of the matrix <A>A</A>.
##      We say that a unit <A>A</A><M>[k,j]</M> is row independet from the unit <A>A</A><M>[i,l]</M>
##      if <M>j>l</M> and <A>A</A><M>[k,l]=0</M>.
##      The columns are scanned from left to right and within each column the rows are
##      scanned from bottom to top searching for new units, row independent from the preceding ones.
##      If <A>A</A><M>[k,j]</M> is a new row independent unit then <M>[j,k]</M> (yes <M>[j,k]</M>) is added to the
##      output list. If <A>A</A> has no units the empty list is returned.<P/>
##      (for the installed standard method see <Ref Meth="GetRowIndependentUnitPositions" Label="homalgTable entry"/>)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="GetRowIndependentUnitPositions:homalgTable_entry">
##  <ManSection>
##    <Func Arg="M, poslist" Name="GetRowIndependentUnitPositions" Label="homalgTable entry"/>
##    <Returns>a (possibly empty) list of pairs of positive integers</Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>M</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>GetRowIndependentUnitPositions</C> is bound then the standard method
##      of the operation <Ref Meth="GetRowIndependentUnitPositions" Label="for matrices"/> returns
##      <M>RP</M>!.<C>GetRowIndependentUnitPositions</C><M>( <A>M</A>, <A>poslist</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( GetRowIndependentUnitPositions,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomogeneousList ],
        
  function( M, poslist )
    local R, RP, rest, pos, j, i, k;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.GetRowIndependentUnitPositions) then
        pos := RP!.GetRowIndependentUnitPositions( M, poslist );
        if pos <> [ ] then
            SetIsZero( M, false );
        fi;
        return pos;
    fi;
    
    #=====# the fallback method #=====#
    
    rest := [ 1 .. NrRows( M ) ];
    
    pos := [ ];
    
    for j in [ 1 .. NrColumns( M ) ] do
        for k in Reversed( rest ) do
            if not [ j, k ] in poslist and
               IsUnit( R, GetEntryOfHomalgMatrix( M, k, j ) ) then
                Add( pos, [ j, k ] );
                rest := Filtered( rest,
                                a -> IsZero( GetEntryOfHomalgMatrix( M, a, j ) ) );
                break;
            fi;
        od;
    od;
    
    if pos <> [ ] then
        SetIsZero( M, false );
    fi;
    
    return pos;
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="GetUnitPosition">
##  <ManSection>
##    <Oper Arg="A, poslist" Name="GetUnitPosition" Label="for matrices"/>
##    <Returns>a (possibly empty) list of pairs of positive integers</Returns>
##    <Description>
##      The position <M>[i,j]</M> of the first unit <A>A</A><M>[i,j]</M> in the matrix <A>A</A>, where
##      the rows are scanned from top to bottom and within each row the columns are
##      scanned from left to right. If <A>A</A><M>[i,j]</M> is the first occurrence of a unit
##      then the position pair <M>[i,j]</M> is returned. Otherwise <C>fail</C> is returned.<P/>
##      (for the installed standard method see <Ref Meth="GetUnitPosition" Label="homalgTable entry"/>)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="GetUnitPosition:homalgTable_entry">
##  <ManSection>
##    <Func Arg="M, poslist" Name="GetUnitPosition" Label="homalgTable entry"/>
##    <Returns>a (possibly empty) list of pairs of positive integers</Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>M</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>GetUnitPosition</C> is bound then the standard method
##      of the operation <Ref Meth="GetUnitPosition" Label="for matrices"/> returns
##      <M>RP</M>!.<C>GetUnitPosition</C><M>( <A>M</A>, <A>poslist</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( GetUnitPosition,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomogeneousList ],
        
  function( M, poslist )
    local R, RP, pos, m, n, i, j;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.GetUnitPosition) then
        pos := RP!.GetUnitPosition( M, poslist );
        if IsList( pos ) and IsPosInt( pos[1] ) and IsPosInt( pos[2] ) then
            SetIsZero( M, false );
        fi;
        return pos;
    fi;
    
    #=====# the fallback method #=====#
    
    m := NrRows( M );
    n := NrColumns( M );
    
    for i in [ 1 .. m ] do
        for j in [ 1 .. n ] do
            if not [ i, j ] in poslist and not j in poslist and
               IsUnit( R, GetEntryOfHomalgMatrix( M, i, j ) ) then
                SetIsZero( M, false );
                return [ i, j ];
            fi;
        od;
    od;
    
    return fail;
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##
InstallMethod( DivideEntryByUnit,
        "for homalg matrices",
        [ IsHomalgMatrix, IsPosInt, IsPosInt, IsRingElement ],
        
  function( M, i, j, u )
    local R, RP;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.DivideEntryByUnit) then
        RP!.DivideEntryByUnit( M, i, j, u );
    else
        SetEntryOfHomalgMatrix( M, i, j, GetEntryOfHomalgMatrix( M, i, j ) / u );
    fi;
    
    ## caution: we deliberately do not return a new hull for Eval( M )
    
end );
    
##
InstallMethod( DivideRowByUnit,
        "for homalg matrices",
        [ IsHomalgMatrix, IsPosInt, IsRingElement, IsInt ],
        
  function( M, i, u, j )
    local R, RP, a, mat;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.DivideRowByUnit) then
        RP!.DivideRowByUnit( M, i, u, j );
    else
        
        #=====# the fallback method #=====#
        
        if j > 0 then
            ## the two for's avoid creating non-dense lists:
            for a in [ 1 .. j - 1 ] do
                DivideEntryByUnit( M, i, a, u );
            od;
            for a in [ j + 1 .. NrColumns( M ) ] do
                DivideEntryByUnit( M, i, a, u );
            od;
            SetEntryOfHomalgMatrix( M, i, j, One( R ) );
        else
            for a in [ 1 .. NrColumns( M ) ] do
                DivideEntryByUnit( M, i, a, u );
            od;
        fi;
        
    fi;
    
    ## since all what we did had a side effect on Eval( M ) ignoring
    ## possible other Eval's, e.g. EvalCompose, we want to return
    ## a new homalg matrix object only containing Eval( M )
    mat := HomalgMatrixWithAttributes( [
                   Eval, Eval( M ),
                   NrRows, NrRows( M ),
                   NrColumns, NrColumns( M ),
                   ], R );
    
    if HasIsZero( M ) and not IsZero( M ) then
        SetIsZero( mat, false );
    fi;
    
    return mat;
    
end );

##
InstallMethod( DivideColumnByUnit,
        "for homalg matrices",
        [ IsHomalgMatrix, IsPosInt, IsRingElement, IsInt ],
        
  function( M, j, u, i )
    local R, RP, a, mat;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.DivideColumnByUnit) then
        RP!.DivideColumnByUnit( M, j, u, i );
    else
        
        #=====# the fallback method #=====#
        
        if i > 0 then
            ## the two for's avoid creating non-dense lists:
            for a in [ 1 .. i - 1 ] do
                DivideEntryByUnit( M, a, j, u );
            od;
            for a in [ i + 1 .. NrRows( M ) ] do
                DivideEntryByUnit( M, a, j, u );
            od;
            SetEntryOfHomalgMatrix( M, i, j, One( R ) );
        else
            for a in [ 1 .. NrRows( M ) ] do
                DivideEntryByUnit( M, a, j, u );
            od;
        fi;
        
    fi;
    
    ## since all what we did had a side effect on Eval( M ) ignoring
    ## possible other Eval's, e.g. EvalCompose, we want to return
    ## a new homalg matrix object only containing Eval( M )
    mat := HomalgMatrixWithAttributes( [
                   Eval, Eval( M ),
                   NrRows, NrRows( M ),
                   NrColumns, NrColumns( M ),
                   ], R );
    
    if HasIsZero( M ) and not IsZero( M ) then
        SetIsZero( mat, false );
    fi;
    
    return mat;
    
end );

##
InstallMethod( CopyRowToIdentityMatrix,
        "for homalg matrices",
        [ IsHomalgMatrix, IsPosInt, IsList, IsPosInt ],
        
  function( M, i, L, j )
    local R, RP, v, vi, l, r;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.CopyRowToIdentityMatrix) then
        RP!.CopyRowToIdentityMatrix( M, i, L, j );
    else
        
        #=====# the fallback method #=====#
        
        if Length( L ) > 0 and IsHomalgMatrix( L[1] ) then
            v := L[1];
        fi;
        
        if Length( L ) > 1 and IsHomalgMatrix( L[2] ) then
            vi := L[2];
        fi;
        
        if IsBound( v ) and IsBound( vi ) then
            ## the two for's avoid creating non-dense lists:
            for l in [ 1 .. j - 1 ] do
                r := GetEntryOfHomalgMatrix( M, i, l );
                if not IsZero( r ) then
                    SetEntryOfHomalgMatrix( v, j, l, -r );
                    SetEntryOfHomalgMatrix( vi, j, l, r );
                fi;
            od;
            for l in [ j + 1 .. NrColumns( M ) ] do
                r := GetEntryOfHomalgMatrix( M, i, l );
                if not IsZero( r ) then
                    SetEntryOfHomalgMatrix( v, j, l, -r );
                    SetEntryOfHomalgMatrix( vi, j, l, r );
                fi;
            od;
        elif IsBound( v ) then
            ## the two for's avoid creating non-dense lists:
            for l in [ 1 .. j - 1 ] do
                r := GetEntryOfHomalgMatrix( M, i, l );
                SetEntryOfHomalgMatrix( v, j, l, -r );
            od;
            for l in [ j + 1 .. NrColumns( M ) ] do
                r := GetEntryOfHomalgMatrix( M, i, l );
                SetEntryOfHomalgMatrix( v, j, l, -r );
            od;
        elif IsBound( vi ) then
            ## the two for's avoid creating non-dense lists:
            for l in [ 1 .. j - 1 ] do
                r := GetEntryOfHomalgMatrix( M, i, l );
                SetEntryOfHomalgMatrix( vi, j, l, r );
            od;
            for l in [ j + 1 .. NrColumns( M ) ] do
                r := GetEntryOfHomalgMatrix( M, i, l );
                SetEntryOfHomalgMatrix( vi, j, l, r );
            od;
        fi;
        
    fi;
    
end );

##
InstallMethod( CopyColumnToIdentityMatrix,
        "for homalg matrices",
        [ IsHomalgMatrix, IsPosInt, IsList, IsPosInt ],
        
  function( M, j, L, i )
    local R, RP, u, ui, m, k, r;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.CopyColumnToIdentityMatrix) then
        RP!.CopyColumnToIdentityMatrix( M, j, L, i );
    else
        
        #=====# the fallback method #=====#
        
        if Length( L ) > 0 and IsHomalgMatrix( L[1] ) then
            u := L[1];
        fi;
        
        if Length( L ) > 1 and IsHomalgMatrix( L[2] ) then
            ui := L[2];
        fi;
        
        if IsBound( u ) and IsBound( ui ) then
            ## the two for's avoid creating non-dense lists:
            for k in [ 1 .. i - 1 ] do
                r := GetEntryOfHomalgMatrix( M, k, j );
                if not IsZero( r ) then
                    SetEntryOfHomalgMatrix( u, k, i, -r );
                    SetEntryOfHomalgMatrix( ui, k, i, r );
                fi;
            od;
            for k in [ i + 1 .. NrRows( M ) ] do
                r := GetEntryOfHomalgMatrix( M, k, j );
                if not IsZero( r ) then
                    SetEntryOfHomalgMatrix( u, k, i, -r );
                    SetEntryOfHomalgMatrix( ui, k, i, r );
                fi;
            od;
        elif IsBound( u ) then
            ## the two for's avoid creating non-dense lists:
            for k in [ 1 .. i - 1 ] do
                r := GetEntryOfHomalgMatrix( M, k, j );
                SetEntryOfHomalgMatrix( u, k, i, -r );
            od;
            for k in [ i + 1 .. NrRows( M ) ] do
                r := GetEntryOfHomalgMatrix( M, k, j );
                SetEntryOfHomalgMatrix( u, k, i, -r );
            od;
        elif IsBound( ui ) then
            ## the two for's avoid creating non-dense lists:
            for k in [ 1 .. i - 1 ] do
                r := GetEntryOfHomalgMatrix( M, k, j );
                SetEntryOfHomalgMatrix( ui, k, i, r );
            od;
            for k in [ i + 1 .. NrRows( M ) ] do
                r := GetEntryOfHomalgMatrix( M, k, j );
                SetEntryOfHomalgMatrix( ui, k, i, r );
            od;
        fi;
        
    fi;
    
end );

##
InstallMethod( SetColumnToZero,
        "for homalg matrices",
        [ IsHomalgMatrix, IsPosInt, IsPosInt ],
        
  function( M, i, j )
    local R, RP, zero, k;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.SetColumnToZero) then
        RP!.SetColumnToZero( M, i, j );
    else
        
        #=====# the fallback method #=====#
        
        zero := Zero( R );
        
        ## the two for's avoid creating non-dense lists:
        for k in [ 1 .. i - 1 ] do
            SetEntryOfHomalgMatrix( M, k, j, zero );
        od;
        
        for k in [ i + 1 .. NrRows( M ) ] do
            SetEntryOfHomalgMatrix( M, k, j, zero );
        od;
        
    fi;
    
    ## since all what we did had a side effect on Eval( M ) ignoring
    ## possible other Eval's, e.g. EvalCompose, we want to return
    ## a new homalg matrix object only containing Eval( M )
    return HomalgMatrixWithAttributes( [
                 Eval, Eval( M ),
                 NrRows, NrRows( M ),
                 NrColumns, NrColumns( M ),
                 ], R );
    
end );

##
InstallMethod( GetCleanRowsPositions,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomogeneousList ],
        
  function( M, clean_columns )
    local R, RP, one, clean_rows, m, j, i;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.GetCleanRowsPositions) then
        return RP!.GetCleanRowsPositions( M, clean_columns );
    fi;
    
    one := One( R );
    
    #=====# the fallback method #=====#
    
    clean_rows := [ ];
    
    m := NrRows( M );
    
    for j in clean_columns do
        for i in [ 1 .. m ] do
            if IsOne( GetEntryOfHomalgMatrix( M, i, j ) ) then
                Add( clean_rows, i );
                break;
            fi;
        od;
    od;
    
    return clean_rows;
    
end );

##
InstallMethod( ConvertRowToMatrix,
        "for homalg matrices",
        [ IsHomalgMatrix, IsInt, IsInt ],
        
  function( M, r, c )
    local R, RP, ext_obj, l, mat, j;
    
    if NrRows( M ) <> 1 then
        Error( "expecting a single row matrix as a first argument\n" );
    fi;
    
    if r = 1 then
        return M;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.ConvertRowToMatrix) then
        ext_obj := RP!.ConvertRowToMatrix( M, r, c );
        return HomalgMatrix( ext_obj, r, c, R );
    fi;
    
    #=====# the fallback method #=====#
    
    ## to use
    ## CreateHomalgMatrixFromString( GetListOfHomalgMatrixAsString( M ), c, r, R )
    ## we would need a transpose afterwards,
    ## which differs from Involution in general:
    
    l := List( [ 1 .. c ],  j -> CertainColumns( M, [ (j-1) * r + 1 .. j * r ] ) );
    l := List( l, GetListOfHomalgMatrixAsString );
    l := List( l, a -> CreateHomalgMatrixFromString( a, r, 1, R ) );
    
    mat := HomalgZeroMatrix( r, 0, R );
    
    for j in [ 1 .. c ] do
        mat := UnionOfColumns( mat, l[j] );
    od;
    
    return mat;
    
end );

##
InstallMethod( ConvertColumnToMatrix,
        "for homalg matrices",
        [ IsHomalgMatrix, IsInt, IsInt ],
        
  function( M, r, c )
    local R, RP, ext_obj;
    
    if NrColumns( M ) <> 1 then
        Error( "expecting a single column matrix as a first argument\n" );
    fi;
    
    if c = 1 then
        return M;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.ConvertColumnToMatrix) then
        ext_obj := RP!.ConvertColumnToMatrix( M, r, c );
        return HomalgMatrix( ext_obj, r, c, R );
    fi;
    
    #=====# the fallback method #=====#
    
    return CreateHomalgMatrixFromString( GetListOfHomalgMatrixAsString( M ), r, c, R ); ## delicate
    
end );

##
InstallMethod( ConvertMatrixToRow,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, ext_obj, r, c, l, mat, j;
    
    if NrRows( M ) = 1 then
        return M;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.ConvertMatrixToRow) then
        ext_obj := RP!.ConvertMatrixToRow( M );
        return HomalgMatrix( ext_obj, 1, NrRows( M ) * NrColumns( M ), R );
    fi;
    
    #=====# the fallback method #=====#
    
    r := NrRows( M );
    c := NrColumns( M );
    
    ## CreateHomalgMatrixFromString( GetListOfHomalgMatrixAsString( "Transpose"( M ) ), 1, r * c, R )
    ## would require a Transpose operation,
    ## which differs from Involution in general:
    
    l := List( [ 1 .. c ],  j -> CertainColumns( M, [ j ] ) );
    l := List( l, GetListOfHomalgMatrixAsString );
    l := List( l, a -> CreateHomalgMatrixFromString( a, 1, r, R ) );
    
    mat := HomalgZeroMatrix( 1, 0, R );
    
    for j in [ 1 .. c ] do
        mat := UnionOfColumns( mat, l[j] );
    od;
    
    return mat;
    
end );

##
InstallMethod( ConvertMatrixToColumn,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( M )
    local R, RP, ext_obj;
    
    if NrColumns( M ) = 1 then
        return M;
    fi;
    
    R := HomalgRing( M );
    
    RP := homalgTable( R );
    
    if IsBound(RP!.ConvertMatrixToColumn) then
        ext_obj := RP!.ConvertMatrixToColumn( M );
        return HomalgMatrix( ext_obj, NrColumns( M ) * NrRows( M ), 1, R );
    fi;
    
    #=====# the fallback method #=====#
    
    return CreateHomalgMatrixFromString( GetListOfHomalgMatrixAsString( M ), NrColumns( M ) * NrRows( M ), 1, R ); ## delicate
    
end );

##
InstallMethod( Eval,
        "for homalg matrices (HasPreEval)",
        [ IsHomalgMatrix and HasPreEval ],
        
  function( C )
    local R, RP, e;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    e :=  PreEval( C );
    
    if IsBound(RP!.PreEval) then
        return RP!.PreEval( e );
    fi;
    
    #=====# the fallback method #=====#
    
    return Eval( e );
    
end );

##  <#GAPDoc Label="DegreesOfEntries:homalgTable_entry">
##  <ManSection>
##    <Func Arg="C" Name="DegreesOfEntries" Label="homalgTable entry"/>
##    <Returns>a listlist of degrees/multi-degrees</Returns>
##    <Description>
##      Let <M>R :=</M> <C>HomalgRing</C><M>( <A>C</A> )</M> and <M>RP :=</M> <C>homalgTable</C><M>( R )</M>.
##      If the <C>homalgTable</C> component <M>RP</M>!.<C>DegreesOfEntries</C> is bound then the standard method
##      for the attribute <Ref Attr="DegreesOfEntries"/> shown below returns
##      <M>RP</M>!.<C>DegreesOfEntries</C><M>( <A>C</A> )</M>.
##    <Listing Type="Code"><![CDATA[
InstallMethod( DegreesOfEntries,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    local R, RP, weights, e, c;
    
    if IsZero( C ) then
        return ListWithIdenticalEntries( NrRows( C ),
                       ListWithIdenticalEntries( NrColumns( C ), -1 ) );
    fi;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if Set( WeightsOfIndeterminates( R ) ) <> [ 1 ] then
        
        weights := WeightsOfIndeterminates( R );
        
        if IsList( weights[1] ) then
            if IsBound(RP!.MultiWeightedDegreesOfEntries) then
                return RP!.MultiWeightedDegreesOfEntries( C, weights );
            fi;
        elif IsBound(RP!.WeightedDegreesOfEntries) then
            return RP!.WeightedDegreesOfEntries( C, weights );
        fi;
        
    elif IsBound(RP!.DegreesOfEntries) then
        return RP!.DegreesOfEntries( C );
    fi;
    
    #=====# the fallback method #=====#
    
    e := EntriesOfHomalgMatrix( C );
    
    e := List( e, DegreeMultivariatePolynomial );
    
    c := NrColumns( C );
    
    return List( [ 1 .. NrRows( C ) ], r -> e{[ ( r - 1 ) * c + 1 .. r * c ]} );
    
end );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##
InstallMethod( NonTrivialDegreePerRow,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    local R, RP, weights, e, deg0;
    
    if IsZero( C ) then
        return ListWithIdenticalEntries( NrRows( C ), -1 );
    fi;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if Set( WeightsOfIndeterminates( R ) ) <> [ 1 ] then
        
        weights := WeightsOfIndeterminates( R );
        
        if IsList( weights[1] ) then
            if IsBound(RP!.NonTrivialMultiWeightedDegreePerRow) then
                return RP!.NonTrivialMultiWeightedDegreePerRow( C, weights );
            fi;
        elif IsBound(RP!.NonTrivialWeightedDegreePerRow) then
            return RP!.NonTrivialWeightedDegreePerRow( C, weights );
        fi;
        
    elif IsBound(RP!.NonTrivialDegreePerRow) then
        
        return RP!.NonTrivialDegreePerRow( C );
        
    fi;
    
    #=====# the fallback method #=====#
    
    e := DegreesOfEntries( C );
    
    deg0 := DegreeMultivariatePolynomial( Zero( R ) );
    
    return List( e, row -> First( row, a -> not a = deg0 ) );
    
end );

##
InstallMethod( NonTrivialDegreePerRow,
        "for homalg matrices",
        [ IsHomalgMatrix, IsList ],
        
  function( C, col_degrees )
    local R, RP, w, weights, e, deg0;
    
    if Length( col_degrees ) <> NrColumns( C ) then
        Error( "the number of entries in the list of column degrees does not match the number of columns of the matrix\n" );
    fi;
    
    if IsZero( C ) then
        return ListWithIdenticalEntries( NrRows( C ), -1 );
    fi;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    w := Set( col_degrees );
    
    if Set( WeightsOfIndeterminates( R ) ) <> [ 1 ] then
        
        weights := WeightsOfIndeterminates( R );
        
        if Length( w ) = 1 then
            if IsList( weights[1] ) then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerRow) then
                    return RP!.NonTrivialMultiWeightedDegreePerRow( C, weights ) + w[1];
                fi;
            elif IsBound(RP!.NonTrivialWeightedDegreePerRow) then
                return RP!.NonTrivialWeightedDegreePerRow( C, weights ) + w[1];
            fi;
        else
            if IsList( weights[1] ) then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerRowWithColPosition) then
                    e := RP!.NonTrivialMultiWeightedDegreePerRowWithColPosition( C, weights );
                    return List( [ 1 .. NrRows( C ) ], i -> e[1][i] + col_degrees[e[2][i]] );
                fi;
            elif IsBound(RP!.NonTrivialWeightedDegreePerRowWithColPosition) then
                e := RP!.NonTrivialWeightedDegreePerRowWithColPosition( C, weights );
                return List( [ 1 .. NrRows( C ) ], i -> e[1][i] + col_degrees[e[2][i]] );
            fi;
        fi;
        
    elif IsBound(RP!.NonTrivialDegreePerRow) then
        
        if Length( w ) = 1 then
            return RP!.NonTrivialDegreePerRow( C ) + w[1];
        else
            e := RP!.NonTrivialDegreePerRowWithColPosition( C );
            return List( [ 1 .. NrRows( C ) ], i -> e[1][i] + col_degrees[e[2][i]] );
        fi;
        
    fi;
    
    #=====# the fallback method #=====#
    
    e := DegreesOfEntries( C );
    
    deg0 := DegreeMultivariatePolynomial( Zero( R ) );
    
    return List( e, function( r ) local c; c := PositionProperty( r, a -> not a = deg0 ); return r[c] + col_degrees[c]; end );
    
end );

##
InstallMethod( NonTrivialDegreePerColumn,
        "for homalg matrices",
        [ IsHomalgMatrix ],
        
  function( C )
    local R, RP, weights, e, deg0;
    
    if IsZero( C ) then
        return ListWithIdenticalEntries( NrColumns( C ), -1 );
    fi;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    if Set( WeightsOfIndeterminates( R ) ) <> [ 1 ] then
        
        weights := WeightsOfIndeterminates( R );
        
        if IsList( weights[1] ) then
            if IsBound(RP!.NonTrivialMultiWeightedDegreePerColumn) then
                return RP!.NonTrivialMultiWeightedDegreePerColumn( C, weights );
            fi;
        elif IsBound(RP!.NonTrivialWeightedDegreePerColumn) then
            return RP!.NonTrivialWeightedDegreePerColumn( C, weights );
        fi;
        
    elif IsBound(RP!.NonTrivialDegreePerColumn) then
        
        return RP!.NonTrivialDegreePerColumn( C );
        
    fi;
    
    #=====# the fallback method #=====#
    
    e := DegreesOfEntries( C );
    
    deg0 := DegreeMultivariatePolynomial( Zero( R ) );
    
    return List( TransposedMat( e ), column -> First( column, a -> not a = deg0 ) );
    
end );

##
InstallMethod( NonTrivialDegreePerColumn,
        "for homalg matrices",
        [ IsHomalgMatrix, IsList ],
        
  function( C, row_degrees )
    local R, RP, w, weights, e, deg0;
    
    if Length( row_degrees ) <> NrRows( C ) then
        Error( "the number of entries in the list of row degrees does not match the number of rows of the matrix\n" );
    fi;
    
    if IsZero( C ) then
        return ListWithIdenticalEntries( NrColumns( C ), -1 );
    fi;
    
    R := HomalgRing( C );
    
    RP := homalgTable( R );
    
    w := Set( row_degrees );
    
    if Set( WeightsOfIndeterminates( R ) ) <> [ 1 ] then
        
        weights := WeightsOfIndeterminates( R );
        
        if Length( w ) = 1 then
            if IsList( weights[1] ) then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerColumn) then
                    return RP!.NonTrivialMultiWeightedDegreePerColumn( C, weights ) + w[1];
                fi;
            elif IsBound(RP!.NonTrivialWeightedDegreePerColumn) then
                return RP!.NonTrivialWeightedDegreePerColumn( C, weights ) + w[1];
            fi;
        else
            if IsList( weights[1] ) then
                if IsBound(RP!.NonTrivialMultiWeightedDegreePerColumnWithRowPosition) then
                    e := RP!.NonTrivialMultiWeightedDegreePerColumnWithRowPosition( C, weights );
                    return List( [ 1 .. NrColumns( C ) ], j -> e[1][j] + row_degrees[e[2][j]] );
                fi;
            elif IsBound(RP!.NonTrivialWeightedDegreePerColumnWithRowPosition) then
                e := RP!.NonTrivialWeightedDegreePerColumnWithRowPosition( C, weights );
                return List( [ 1 .. NrColumns( C ) ], j -> e[1][j] + row_degrees[e[2][j]] );
            fi;
        fi;
        
    elif IsBound(RP!.NonTrivialDegreePerColumn) then
        
        if Length( w ) = 1 then
            return RP!.NonTrivialDegreePerColumn( C ) + w[1];
        else
            e := RP!.NonTrivialDegreePerColumnWithRowPosition( C );
            return List( [ 1 .. NrColumns( C ) ], j -> e[1][j] + row_degrees[e[2][j]] );
        fi;
        
    fi;
    
    #=====# the fallback method #=====#
    
    e := DegreesOfEntries( C );
    
    deg0 := DegreeMultivariatePolynomial( Zero( R ) );
    
    return List( TransposedMat( e ), function( c ) local r; r := PositionProperty( c, a -> not a = deg0 ); return c[r] + row_degrees[r]; end );
    
end );

####################################
#
# methods for operations (you probably don't urgently need to replace for an external CAS):
#
####################################

##
InstallMethod( SUM,
        "for homalg ring elements",
        [ IsHomalgRingElement, IsHomalgRingElement ],
        
  function( r1, r2 )
    local R, RP;
    
    R := HomalgRing( r1 );
    
    if not HasRingElementConstructor( R ) then
        Error( "no ring element constructor found in the ring\n" );
    fi;
    
    if not IsIdenticalObj( R, HomalgRing( r2 ) ) then
        return Error( "the two elements are not in the same ring\n" );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.Sum) then
        return RingElementConstructor( R )( RP!.Sum( r1,  r2 ), R ) ;
    elif IsBound(RP!.Minus) then
        return RingElementConstructor( R )( RP!.Minus( r1, RP!.Minus( Zero( R ), r2 ) ), R ) ;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( PROD,
        "for homalg ring elements",
        [ IsHomalgRingElement, IsHomalgRingElement ],
        
  function( r1, r2 )
    local R, RP;
    
    R := HomalgRing( r1 );
    
    if not HasRingElementConstructor( R ) then
        Error( "no ring element constructor found in the ring\n" );
    fi;
    
    if not IsIdenticalObj( R, HomalgRing( r2 ) ) then
        return Error( "the two elements are not in the same ring\n" );
    fi;
    
    RP := homalgTable( R );
    
    if IsBound(RP!.Product) then
        return RingElementConstructor( R )( RP!.Product( r1,  r2 ), R ) ;
    fi;
    
    TryNextMethod( );
    
end );

