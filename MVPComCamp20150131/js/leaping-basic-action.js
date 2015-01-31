/********************************************************
 * LeapingJS-Basic
 *   Basic action plugins for LeapingJS
 * Copyright (c) 2014,2015 Sakura-Shiki, Hiroshi Kawada
 * Released under the MIT license
 */
(function(){
	var	pageChangeFrame = window.LEAPING.PAGE_CHANGE_TIME;
	window.LEAPING.actions["fade"] = function( before, after, frame ) {
		if( pageChangeFrame === frame ) {
			before.style.display = "none";
			before.style.opacity = 1.0;
			after.style.display  = "block";
			after.style.opacity  = 1.0;
		} else {
			after.style.opacity = 1.0*frame/pageChangeFrame;
			after.style.display  = "block";
		}
	};
	window.LEAPING.actions["slide-in"] = function( before, after, frame ) {
		if( pageChangeFrame === frame ) {
			before.style.display = "none";
			before.style.opacity = 1.0;
			after.style.display  = "block";
			after.style.opacity  = 1.0;
			after.style.top = "0%";
		} else {
			after.style.top = (100.0*Math.cos((Math.PI/2)*(frame)/pageChangeFrame))+"%";
			after.style.display  = "block";
		}
	};
})();
