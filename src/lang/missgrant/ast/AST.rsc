module lang::missgrant::ast::AST

import List;
import Graph;
import Map;

data Controller = controller(list[Event] events, 
					  list[str] resets, 
					  list[Command] commands,
					  list[State] states);

data State = state(str name, list[str] actions, list[Transition] transitions);

data Command = command(str name, str token);
data Event = event(str name, str token);
data Transition = transition(str event, str state);


anno loc Controller@location;
anno loc State@location;
anno loc Command@location;
anno loc Event@location;
anno loc Transition@location;

data ControllerState = 
	controllerState(
		Controller ctl,
		str curStateName, 
		StateEnv stateEnv,
		map[str,str] eventNameToToken,
		map[str,str]  commandNameToToken,
		map[str,str]  eventTokenToName,
		map[str,str]  commandTokenToName
	);

alias StateEnv = map[str, State];

public State initial(Controller ctl) = ctl.states[0];

public State final(Controller ctl) = last(ctl.states);

public list[str] consumes(State s) = [ e | transition(e, _) <- s.transitions ];

public Graph[str] stateGraph(Controller ctl) = 
  { <s1, s2> | /state(s1, _, ts) <- ctl, transition(_, s2) <- ts };

public StateEnv stateEnv(Controller ctl) = ( n: s | s:state(n, _, _) <- ctl.states);

public map[str,str] eventEnv(Controller ctl) = ( n: t | e:event(n, t) <- ctl.events);

public map[str,str] commandEnv(Controller ctl) = ( n: t | command(n, t) <- ctl.commands);

public set[str] usedEvents(Controller ctl) = { e | /transition(e, _) <- ctl };

public set[str] usedActions(Controller ctl) = { a |  /state(_, as, _) <- ctl, a <- as };

public set[str] definedCommands(Controller ctl) = { n | command(n, _) <- ctl.commands };

public set[str] definedEvents(Controller ctl) = { n | event(n, _) <- ctl.events };

public set[str] definedStates(Controller ctl) = { n | state(n, _, _) <- ctl.states };

public ControllerState initialControllerState(Controller ctl) {
	evNameToToken = eventEnv(ctl);
	comNameToToken = commandEnv(ctl);
	return controllerState(ctl, initial(ctl).name, stateEnv(ctl),
			 evNameToToken, comNameToToken,
			 invertUnique(evNameToToken),invertUnique(comNameToToken));
}
