(function(){var a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A;a=60,r=function(a){return setTimeout(a,1e3/60)},m=navigator.userAgent.indexOf("iPhone")>0&&-1===navigator.userAgent.indexOf("iPad")||navigator.userAgent.indexOf("iPod")>0||navigator.userAgent.indexOf("Android")>0,window.LEAPING={actions:{},PAGE_CHANGE_TIME:a},w=function(){var a;a=document.createElement("style"),a.textContent="html,body {\n	margin : 0;\n	padding : 0;\n	background-color : black;\n	color : white;\n	overflow : hidden;\n	width : 100%;\n	height: 100%;\n}\nhtml {\n	touch-action : none;\n}\nsection {\n	display : none;\n	position : fixed;\n	top : 0%;\n	left : 0%;\n	width : 100%;\n	height : 100%;\n	background-repeat : no-repeat;\n	background-position : center center;\n	background-size : cover;\n	text-align : center;\n}\n.lpBlock {\n	position : fixed;\n	dipslay : block;\n	width : 100%;\n	left : 0%;\n	top : 0%;\n	text-align : center;\n	margin : 0;\n	padding : 0;\n}\n.nowloading {\n	display : block;\n	position : fixed;\n	top : 0%;\n	left : 0%;\n	width : 100%;\n	height : 100%;\n	background-color: black;\n}\n.nowloading>.progress {\n	position : absolute;\n	bottom : 2%;\n	right : 2%;\n	width :100%;\n	text-align : right;\n}\n.nowloading>.progress>.logo {\n	display : inline-block;\n	width : 16px;\n	height : 16px;\n}",document.querySelector("head").appendChild(a)},y=function(){var a;a=document.createElement("div"),a.setAttribute("class","nowloading"),a.innerHTML="<div class='progress'>Now Loading (<span class='percent'>0</span>%)</div>",document.querySelector("body").appendChild(a)},q=function(){var a,b,c,e,g,h,i,j,k,l,m,n,o,p,q,r,s;for(i=document.querySelectorAll("img"),k=document.querySelector(".nowloading"),l=k.querySelector(".percent"),h=[],a=document.getElementsByTagName("*"),n=0,q=i.length;q>n;n++)g=i[n],h.push(g.getAttribute("src"));for(o=0,r=a.length;r>o;o++)e=a[o],d(e),b=e.getAttribute("lp-bg"),b&&h.push(b);for(c=0,p=0,s=h.length;s>p;p++)m=h[p],j=document.createElement("img"),j.onload=function(){return c++,l.textContent=parseInt(100*c/h.length),h.length<=c?(f(k),x()):void 0},j.onerror=function(){return alert("Can't load resource -> "+m)},j.src=m},f=function(a){var b,c,d,e;b=0,c=120,e=function(){return b++,b>c?(clearInterval(d),a.style.opacity=0,a.style.display="none"):a.style.opacity=(c-b)/c},d=setInterval(e,1e3/60)},d=function(a){var b,c,d,e,f,g;c=a.getAttribute("class"),c||(c=""),b=a.getAttribute("lp-bg"),b&&(a.style.backgroundImage="url("+b+")"),f=a.getAttribute("lp-x"),f&&(a.setAttribute("class",c+" lpBlock"),a.style.left=f+"%"),g=a.getAttribute("lp-y"),g&&(a.setAttribute("class",c+" lpBlock"),a.style.top=g+"%"),a.getAttribute("lp-speed")&&a.setAttribute("lp-text",a.textContent),e=a.getAttribute("lp-touch"),e&&("next"===e?a.addEventListener("click",j):"back"===e?a.addEventListener("click",i):(d=e.split(":"),"goto"===d[0]&&a.addEventListener("click",k)))},g=0,t=0,z=[],n=!1,p=function(){var d,e,f,h,i,j,k;for(g++,t++,j=0,k=z.length;k>j;j++)h=z[j],e=(t-a)*parseInt(h.getAttribute("lp-speed"))*.02,h.textContent=h.getAttribute("lp-text").substring(0,e);a>=t?(n=!0,d=null,d=b.getAttribute("lp-action"),d?window.LEAPING.actions[d]?window.LEAPING.actions[d](c,b,t):(c.style.opacity=1,c.style.display="none",b.style.opacity=1,b.style.display="block",t=a):a/2>t?(i=a/2,c.style.transform="scale("+(2+Math.cos(Math.PI/(1+t/i)))+")",c.style.opacity=(i-t)/(1*i)):(c&&(c.style.display="none"),i=a/2,f=t-i,b.style.display="block",b.style.transform="scale("+Math.sin(Math.PI/(1+f/i))+")",b.style.opacity=1-(i-f)/(1*i))):n=!1,r(p)},u=[],s=0,o=0,b=null,c=null,h=function(a){var b,c,d,e,f,g;for(d=[],c=a.getElementsByTagName("*"),f=0,g=c.length;g>f;f++)b=c[f],e=b.getAttribute("lp-speed"),e&&d.push(b);return d},A=function(){var a;m||(c&&(a=c.querySelector("video"),a&&a.pause()),b&&(a=b.querySelector("video"),a&&a.play()))},x=function(){t=a/2,s=0,u=document.querySelectorAll("section"),o=u.length,b=u[s],z=h(b),b.style.display="block",p(),A()},j=function(){n||(t=0,c=u[s],s++,s>=o&&(s=0),b=u[s],z=h(b),A())},i=function(){n||(t=0,c=u[s],s--,0>s&&(s=o-1),b=u[s],z=h(b),A())},k=function(){var a;n||(t=0,a=this.getAttribute("lp-touch").split(":"),c=b,b=document.querySelector("#"+a[1]),z=h(b),A())},v=function(a,b,c){var d,e,f;for(e=0,f=a.length;f>e;e++)d=a[e],d.style[b]=c},l=function(){w()},e=function(){y(),q()},l(),document.addEventListener("DOMContentLoaded",e)}).call(this);