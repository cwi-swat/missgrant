module lang::missgrant::compile::ToSwitch

import lang::missgrant::compile::ToMethods;
import lang::missgrant::ast::MissGrant;

public str controller2switch(str name, Controller ctl) {
  return "public class <name> {
         '  <states2consts(ctl.states)>
         '  <controller2run(ctl)>
         '  <for (e <- ctl.events) {>
  	     '  <event2java(e)>
  	     '  <}>
  	     '  <for (c <- ctl.commands) {>
  	     '  <command2java(c)>
  	     '  <}>
  	     '}";
}


public str states2consts(list[State] states) {
  i = 0;
  return "<for (s <- states) {>
         'private static final int <stateName(s)> = <i>;
         '<i += 1;}>"; 
}


public str controller2run(Controller ctl) {
  return "public void run(Scanner input, Writer output) {
         '  int state = <stateName(initial(ctl))>;
         '  while (true) {
         '    String token = input.nextLine();
         '    switch (state) {
         '      <for (s <- ctl.states) {>
         '      <state2case(s)>
         '      <}>
         '    }
         '}";
}

public str state2case(State s) {
  return "case <stateName(s)>: {
         '  <for (a <- s.actions) {>
         '     <a>(output);
         '  <}>
         '  <for (transition(e, s2) <- s.transitions) {>
         '  if (<e>(token)) {
         '     state = <stateName(s2)>;
         '  }
         '  <}>
         '  break;
         '}";
}

