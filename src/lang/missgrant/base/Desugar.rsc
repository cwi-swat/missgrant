module lang::missgrant::base::Desugar

import lang::missgrant::base::AST;
import IO;


Controller desugar(Controller ctl) {
  init = ctl.states[0].name;
  ctl = visit (ctl) {
    case s:state(n, as, ts) => state(n, as, ts + [ transition(e, init) | e <- ctl.resets ])[@location=s@location]
  };
  ctl.resets = [];
  return ctl;
}


  