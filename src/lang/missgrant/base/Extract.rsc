module lang::missgrant::base::Extract

import lang::missgrant::base::AST;

alias TransRel = rel[str state, str event,  str toState];
alias ActionRel = rel[str state, str command];

TransRel transRel(Controller ctl) 
  = { <s1, t.event, t.state> | /state(s1, _, ts) <- ctl, Transition t <- ts };

ActionRel commands(Controller ctl) 
  = { <s, a> | /state(s, as, _) <- ctl, a <- as }; 
