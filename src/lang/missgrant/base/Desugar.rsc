module lang::missgrant::base::Desugar

import lang::missgrant::base::AST;
import IO;


Controller desugar(Controller ctl) {
  init = ctl.states[0].name;
  ctl = visit (ctl) {
    case s:state(n, as, ts) => state(n, as, ts + nts)
       when nts := [ transition(e, init) | e <- ctl.resets ]
  };
  ctl.resets = [];
  return ctl;
}


  