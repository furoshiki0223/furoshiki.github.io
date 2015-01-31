##############################################################
# LeapingJS - Engine Core
# 
# Copyright (c) 2014,2015 Sakura-Shiki, Hiroshi Kawada
# Released under the MIT license

# Page switching time
PAGE_DELAY = 60

# chacking mobile or not
isMobile = (navigator.userAgent.indexOf('iPhone') > 0 &&
navigator.userAgent.indexOf('iPad') == -1) ||
navigator.userAgent.indexOf('iPod') > 0 ||
navigator.userAgent.indexOf('Android') > 0

# page swiching or not
isWorking = false

# use pushState or not for Single-page Applicaito
spaPush = false;

# frame count until this web page started
frameCount = 0

# frame count until the virtual page started
pageFrameCount = 0

# mutated visual state elements on the virtual pages
speedElems = []

# show delay element.
delayElems = []

# cached section elements.
sections = []

# Current page Number( ONLY using lp-touch="back"/"next", it working.)
pageCount = 0

# Max page counts.
maxPageCount = 0

# Next section element, when switching virtual page.
after = null

# Last section element, when switching virtual page.
before = null

# for plugins
window.LEAPING = { actions : {}, PAGE_CHANGE_TIME : PAGE_DELAY };


#######################################
# Set default CSS Values
setDefaultCSS = () ->
	style = document.createElement "style"
	style.textContent = """
		html,body {
			margin : 0;
			padding : 0;
			background-color : black;
			color : white;
			overflow : hidden;
			width : 100%;
			height: 100%;
		}
		html {
			touch-action : none;
		}
		section {
			display : none;
			position : fixed;
			top : 0%;
			left : 0%;
			width : 100%;
			height : 100%;
			background-repeat : no-repeat;
			background-position : center center;
			background-size : cover;
			text-align : center;
		}
		.img {
			display : block;
			position : fixed;
			top : 15%;
			left : 0%;
			width : 100%;
			height : 70%;
			background-repeat : no-repeat;
			background-position : center center;
			background-size : contain;
		}
		.lpBlock {
			position : fixed;
			dipslay : block;
			width : 100%;
			left : 0%;
			top : 0%;
			text-align : center;
			margin : 0;
			padding : 0;
		}
		.alignLeft {
			text-align : left;
		}
		.alignRight {
			text-align : right;
		}
		.nowloading {
			display : block;
			position : fixed;
			top : 0%;
			left : 0%;
			width : 100%;
			height : 100%;
			background-color: black;
		}
		.nowloading>.progress {
			position : absolute;
			bottom : 2%;
			right : 2%;
			width :100%;
			text-align : right;
		}
		.nowloading>.progress>.logo {
			display : inline-block;
			width : 16px;
			height : 16px;
		}
	"""
	(document.querySelector "head").appendChild style
	return

#######################################
# Show Loading View.
showLoadView = () ->
	nowLoading = document.createElement "div"
	nowLoading.setAttribute "class","nowloading"
	nowLoading.innerHTML = """
		<div class='progress'>Now Loading (<span class='percent'>0</span>%)</div>
	"""
	(document.querySelector "body").appendChild nowLoading
	return

#######################################
# Move Loading View.(Actially show the progress for loading resources.)
moveProgressView = () ->
	images = document.querySelectorAll "img"
	loadView = document.querySelector ".nowloading"
	percent  = loadView.querySelector ".percent"
	imageList = []
	allElems = document.getElementsByTagName "*"
	for image in images
		imageList.push (image.getAttribute "src")
	for elem in allElems
		convertParams elem
		bg = elem.getAttribute "lp-bg"
		if bg
			imageList.push bg
	cnt = 0
	if imageList.length
		for url in imageList
			img = document.createElement "img"
			img.onload = () ->
				cnt++
				percent.textContent = parseInt((cnt*100)/imageList.length)
				if imageList.length <= cnt
					fadeOut loadView
					showFirstSection()
			img.onerror = () ->
				alert "Can't load resource -> " + url
			img.src = url
	else
		percent.textContent = "100"
		fadeOut loadView
		showFirstSection()

	return

#######################################
# Fade out the element
fadeOut = (elem) ->
	beginFrame = 0
	maxFrame = 120.0
	work = () ->
		beginFrame++
		if maxFrame < beginFrame
			clearInterval timer
			elem.style.opacity = 0.0
			elem.style.display = "none"
		else
			elem.style.opacity = (maxFrame-beginFrame)/maxFrame
	timer = setInterval work, 1000/60
	return

#######################################
# Convert lp-* params and set Data
convertParams = (elem) ->
	classStr = elem.getAttribute "class"
	if ! classStr
		classStr = ""
	bg = elem.getAttribute "lp-bg"
	if bg
		elem.style.backgroundImage = "url("+bg+")"
	y = elem.getAttribute "lp-y"
	if y
		elem.setAttribute "class", classStr+" lpBlock"
		elem.style.top = y+"%"
	x = elem.getAttribute "lp-x"
	if x
		if x<=50
			elem.setAttribute "class", classStr+" lpBlock alignLeft"
		else 
			elem.setAttribute "class", classStr+" lpBlock alignRight"
		elem.style.left = x+"%"
	img = elem.getAttribute "lp-img"
	if img
		elem.style.backgroundImage = "url("+img+")"
		elem.setAttribute "class", classStr+" img"
	if elem.getAttribute "lp-speed"
		elem.setAttribute "lp-text", elem.textContent
	touch = elem.getAttribute "lp-touch"
	if touch
		if touch == "next"
			elem.addEventListener "click",gotoNextSection
			elem.style.cursor = "pointer"
		else if touch == "back"
			elem.addEventListener "click",goBackToLastSection
			elem.style.cursor = "pointer"
		else
			lst = touch.split(":")
			if lst[0] == "goto"
				elem.addEventListener "click",gotoTargetId
				elem.style.cursor = "pointer"
	return

#######################################
# Move for frame
moveFrame = () ->
	frameCount++
	pageFrameCount++
	for elem in speedElems
		count = (pageFrameCount-PAGE_DELAY)*parseInt(elem.getAttribute "lp-speed")*0.02
		elem.textContent = (elem.getAttribute "lp-text").substring(0,count)
	if pageFrameCount == 1
		for elem in delayElems
			elem.style.visibility = "hidden"
	if pageFrameCount <= PAGE_DELAY
		isWorking = true
		action = null
		action = after.getAttribute "lp-action"
		if action
			if window.LEAPING.actions[action]
				window.LEAPING.actions[action](before, after, pageFrameCount)
			else
				before.style.opacity = 1.0
				before.style.display = "none"
				after.style.opacity = 1.0
				after.style.display = "block"
				pageFrameCount = PAGE_DELAY
		else
			if pageFrameCount < PAGE_DELAY/2
				maxTime = PAGE_DELAY/2
				before.style.transform = "scale("+(2.0+Math.cos(Math.PI/(1.0+((0.5*pageFrameCount)/maxTime))))+")"
				before.style.opacity = ((maxTime-pageFrameCount)/(maxTime*1.0))
			else
				if before
					before.style.display = "none"
				maxTime = PAGE_DELAY/2
				currentFrame = pageFrameCount-maxTime
				after.style.display = "block"
				after.style.transform = "scale("+(Math.sin(Math.PI/(1.0+(currentFrame/maxTime))))+")"
				after.style.opacity = 1.0-((maxTime-currentFrame)/(maxTime*1.0))
	else
		isWorking = false
	# nextFrame moveFrame
	return

#######################################
# Get the elements that have lp-speed attribute
getSpeedElement = (elem) ->
	list = []
	elems = elem.getElementsByTagName "*"
	for d in elems
		speed = d.getAttribute "lp-speed"
		if speed
			list.push d
	return list

#######################################
# Get the elements that have lp-delay attribute
getDelayElement = (elem) ->
	list = []
	elems = elem.getElementsByTagName "*"
	for d in elems
		delay = d.getAttribute "lp-delay"
		if delay != null && delay != false
			list.push d
	return list

#######################################
# change video tag's playing state
switchVideoState = () ->
	if isMobile
		return
	if before 
		video = before.querySelector "video"
		if video
			video.pause()
	if after
		video = after.querySelector "video"
		if video
			video.play()
	return

#######################################
# Show first <section>
showFirstSection = () ->
	pageFrameCount = PAGE_DELAY/2
	pageCount = 0
	sections = document.querySelectorAll "section"
	maxPageCount = sections.length
	after = sections[pageCount]
	speedElems = getSpeedElement after
	after.style.display = "block"
	setInterval moveFrame, 1000/60
	switchVideoState()
	if spaPush && afterId
		history.pushState({id:afterId}, null, "#"+afterId);
	return

#######################################
# Go to next <section>
gotoNextSection = () ->
	if isWorking
		return
	if delayElems.length
		elem = delayElems.shift()
		elem.style.visibility = "visible"
		return
	pageFrameCount = 0
	before = sections[pageCount]
	pageCount++
	if maxPageCount <= pageCount
		pageCount = 0
	after = sections[pageCount]
	speedElems = getSpeedElement after
	delayElems = getDelayElement after
	switchVideoState()

	afterId = after.getAttribute "id"
	return

#######################################
# Go back to last <section>
goBackToLastSection = () ->
	if isWorking
		return
	if delayElems.length
		elem = delayElems.shift()
		elem.style.visibility = "visible"
		return
	pageFrameCount = 0
	before = sections[pageCount]
	pageCount--
	if pageCount < 0
		pageCount = maxPageCount-1
	after = sections[pageCount]
	speedElems = getSpeedElement after
	delayElems = getDelayElement after
	switchVideoState()
	return

#######################################
# Go to target <section> by id
gotoTargetId = () ->
	if isWorking
		return
	lst = (this.getAttribute "lp-touch").split(":")
	afterId = lst[1]
	switchPage afterId
	if spaPush
		history.pushState({id:afterId}, null, "#"+afterId);	
	return

#######################################
# Switch Page by Element ID
switchPage = (afterId) ->
	before = after
	after = document.querySelector "#"+afterId

	pageFrameCount = 0
	speedElems = getSpeedElement after
	delayElems = getDelayElement after
	switchVideoState()
	return


#######################################
# set styles for each elements.
setCSS = (elems,styleName,value) ->
	for elem in elems
		elem.style[styleName] = value
	return


#######################################
# Do when popState events fires.
popEvent = (evt) ->
	state = evt.state
	if state.id
		switchPage state.id
	return


#######################################
# Initialize immediately.
init = () ->
	setDefaultCSS();
	html = document.querySelector "html"
	ajastFontSize = () ->
		widthSize = parseInt(window.innerWidth*0.3);
		heightSize = parseInt(window.innerHeight*0.4);
		if heightSize < widthSize
			html.style.fontSize = heightSize+"%"
		else
			html.style.fontSize = widthSize+"%"
	window.addEventListener "resize", ajastFontSize
	ajastFontSize()
	return


#######################################
# Initialize before all of the elements are loaded.
delayInit = () ->
	if document.querySelector("body").getAttribute("lp-push") && window.history.pushState
		spaPush = true
		window.addEventListener 'popstate', popEvent
	showLoadView()
	moveProgressView()
	return

#######################################
# Do it on IE8+
if document.addEventListener
	init()
	document.addEventListener "DOMContentLoaded", delayInit
