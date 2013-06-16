module lang::missgrant::base::Outline

import lang::missgrant::base::AST;
import ParseTree; // for loc annos

//node outlineController(Controller ctl) = outline(ctl);

node outline(Controller ctl) = "outline"([outline(ctl.events), outline(ctl.commands), outline(ctl.states)]);

node outline(list[Event] es) = "events"([ outline(e) | e <- es])[@label="Events"];

// todo: pass env around to lookup resets
// node outline(list[str] rs) = "resets"([ outline(e) | e <- es])[@label="Reset Events"];

node outline(list[Command] cs) = "commands"([ outline(c) | c <- cs])[@label="Commands"];

node outline(list[State] ss) = "states"([ outline(s) | s <- ss])[@label="States"];

node outline(e:event(n, t)) = "event"()[@label="<n> <t>"][@\loc=e@location];

node outline(c:command(n, t)) = "command"()[@label="<n> <t>"][@\loc=c@location];

node outline(s:state(n, as, ts)) = "state"([ outline(t) | t <- ts ])[@label=n][@\loc=s@location];

// todo: pass env around to lookup state locs.
node outline(t:transition(e, s)) = "transition"()[@label="<e> -\> <s>"][@\loc=t@location];

node outline(t:transition(n, e, s)) = "transition"()[@label="after <n> <e> -\> <s>"][@\loc=t@location];

