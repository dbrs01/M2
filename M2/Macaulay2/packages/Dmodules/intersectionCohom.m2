-- Copyright 2020 by Andras C. Lorincz

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Computes the intersection cohomology D-module corresponding to an irreducible affine subvariety of the affine space. 
-- Special algorithm for the case when ideal is a complete intersection via Barlet-Kashiwara.
-- Computes the intersection cohomology groups of an irreducible affine variety.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

ICmodule = method( Options => {LocCohomStrategy => (Walther,null), LocStrategy => OTW})  -- Strat 1,2 for LocalCohom, Strat 3 for the localization after
ICmodule(Ideal) := options -> I -> (
    R := ring I;
    if class R =!= PolynomialRing
    then error "expected an ideal in a polynomial ring";
    primes := minimalPrimes I;
    if #primes > 1 then error "The variety defined by the ideal must be irreducible";
    P := primes#0;
    c:=codim P;
    if options.LocStrategy == CompleteIntersection then (  -- when complete intersection
	g:=flatten entries (gens I);
    	if #g>c then error "This strategy is for complete intersections only";
        F := product((0..c-1), i->g#i);
	W := makeWA R;
	F = sub(F,W);
	J := RatAnn F;
	for i from 0 to c-1 do J=J+ideal(sub(g#i,W)); -- submodule of H^c_I(R) generated by F^-1
	m := minors (c,jacobian(I));      
	l := (flatten entries (mingens m))#0;
	image map(W^1/J, W^1, matrix{{sub(l,W)}}) -- D-mod generated by fundamental class
	)
    else (
    	S := flatten entries mingens(ideal singularLocus P);
    	f:=1_R;
    	for i from 0 to #S-1 do (
	    if ((S_i % P) != 0) then (
	    	f=S_i; 
	    	break;
	    	);
	    );
    	H := localCohom(c, I, Strategy => options.LocCohomStrategy#0, LocStrategy => options.LocCohomStrategy#1);
    	if (first degree f) == 0 then H   --when smooth
    	else (      	    	    	  --general case
    	    G := Ddual H;
    	    f = sub(f,ring G);
    	    T := DlocalizeAll(G,f, Strategy => options.LocStrategy);
    	    image T#LocMap
       	    )
	)    		 
    );

ICcohom = method( Options => {LocCohomStrategy => (Walther,null), LocStrategy => OTW, Strategy => Schreyer })
ICcohom(Ideal) := options -> I -> (
    IC:=minimalPresentation ICmodule(I, LocCohomStrategy => options.LocCohomStrategy, LocStrategy => options.LocStrategy);
    n:=numgens (ring I);
    d:=dim I;
    w:=toList(n:1);
    integrationTable := Dintegration(IC,w, Strategy => options.Strategy);
    new HashTable from (for i from 0 to d list i=>integrationTable#(d-i)) 
    )

ICcohom(ZZ,Ideal) := options -> (k,I) -> (
    R:= ring I;
    if class R =!= PolynomialRing
    then error "expected an ideal in a polynomial ring";
    d:=dim I;
    if k>d then 0
    else (
    	IC:=minimalPresentation ICmodule(I, LocCohomStrategy => options.LocCohomStrategy, LocStrategy => options.LocStrategy);
    	n:=numgens R;
    	w:=toList(n:1);
    	Dintegration(d-k,IC,w, Strategy => options.Strategy)
      	)
    )
