#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"


MODULE = Devel::Gladiator		PACKAGE = Devel::Gladiator



SV*
walk_arena()
PPCODE:
{
  SV* sva;
  I32 visited = 0;
  AV* av = newAV();
  for (sva = PL_sv_arenaroot; sva; sva = (SV*)SvANY(sva)) {
    register const SV * const svend = &sva[SvREFCNT(sva)];
    register SV* sv;
    for (sv = sva + 1; sv < svend; ++sv) {
      if (SvTYPE(sv) != SVTYPEMASK
          && SvREFCNT(sv)
          && sv != (SV*)av
          )
        {
          ++visited;
          av_push(av,sv);
          SvREFCNT_inc(sv);
        }
    }
  }

  while (visited--) {
    SV** sv = av_fetch(av, visited, (I32)0);

    /**    if (SvTYPE(sv) == SVt_PV
        || SvTYPE(sv) == SVt_IV
        || SvTYPE(sv) == SVt_NV
        || SvTYPE(sv) == SVt_RV
        || SvTYPE(sv) == SVt_PVIV
        || SvTYPE(sv) == SVt_PVNV
        || SvTYPE(sv) == SVt_PVMG) {
    **/
    if(sv) {
      av_store(av, visited, newRV_inc(*sv));
    }
  }

  ST(0) = newRV_noinc((SV*)av);
  sv_2mortal(ST(0));

  //sv_dump(ST(0));
  XSRETURN(1);
}

