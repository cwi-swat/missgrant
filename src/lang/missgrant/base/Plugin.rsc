module lang::missgrant::base::Plugin

import lang::missgrant::base::Syntax;
import lang::missgrant::base::Parse;
import lang::missgrant::base::Implode;
import lang::missgrant::base::Check;
import lang::missgrant::base::Desugar;
import lang::missgrant::base::Compile;
import lang::missgrant::base::Rename;
import lang::missgrant::base::Visualize;
import lang::missgrant::base::Extract;
import lang::missgrant::base::Outline;
import lang::missgrant::base::XRef;

import util::IDE;
import util::Prompt;
import vis::Render;
import Message;
import ParseTree;
import List;
import String;
import IO;

private str CONTROLLER_LANG = "Controller";
private str CONTROLLER_EXT = "ctl";

void main() {
  registerLanguage(CONTROLLER_LANG, CONTROLLER_EXT, Tree(str src, loc l) {
     return parse(src, l);
  });

  contribs = {
		     popup(
			       menu(CONTROLLER_LANG,[

	    		     action("Visualize", void (Tree pt, loc l) {
	    		       renderController(implode(pt));
	    		     }),
	    		     edit("Rename...", rename)])
	    	  ),

    		 annotator(Tree (Tree pt) {
    		   if (start[Controller] ctl := pt) {
    		     ctl = xrefController(ctl);
    		     return ctl[@messages = check(implode(ctl))];
    		   }
    		 }),

    		 builder(set[Message] (Tree pt) {
    		   ctl = desugar(implode(pt));
    		   out = (pt@\loc)[extension="java"];
    		   class = split(".", out.file)[0];
    		   writeFile(out.top, compile(class, ctl));
       return {};
    		 }),
    		 
    		 outliner(node (Tree input) {
                 return outline(implode(input));
             })
             
  };
  
  registerContributions(CONTROLLER_LANG, contribs);
}
