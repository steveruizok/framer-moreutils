{ Icon } = require 'Icon'
require 'moreutils'

Framer.Extras.Hints.disable()
Framer.Extras.Preloader.disable()
Screen.backgroundColor = '#eee'


# ----------------
# text styles

# Styles

fontSize = 16

styles =
	serif:
		fontSize: fontSize
		color: '#000'
		fontFamily: 'Georgia'
		lineHeight: 1
	sansSerif:
		fontSize: fontSize
		color: '#000'
		fontFamily: 'Arial'
		lineHeight: 1
	mono:
		fontSize: fontSize
		color: '#333'
		fontFamily: 'Menlo'
	h1:
		serif: false
		fontSize: fontSize * 2.5
		fontWeight: 500
	h2:
		fontSize: fontSize * 2
		fontWeight: 500
	h3:
		fontSize: fontSize * 1.75
		fontWeight: 500
	h4:
		fontSize: fontSize * 1.5
		fontWeight: 500
	h5:
		fontSize: fontSize * 1.25
		fontWeight: 500
	h6:
		fontSize: fontSize * 1
		fontWeight: 500
	lead:
		fontSize: fontSize * 1.25
		fontWeight: 300
	body:
		fontSize: fontSize
	caption:
		fontSize: fontSize * .81
	code:
		fontSize: fontSize * .75
		color: '#333'
		fontWeight: 600

# Text Classes

isSerif = (bool) ->
	if bool then return SerifText else return SansText

# Serif Text

class SerifText extends TextLayer
	constructor: (options = {}) ->
		_.defaults options, styles.serif
		super options

# Sans Text

class SansText extends TextLayer
	constructor: (options = {}) ->
		_.defaults options, styles.sansSerif
		super options

# Mono Text

class MonoText extends TextLayer
	constructor: (options = {}) ->
		_.defaults options, styles.mono
		super options

# H1

class H1 extends isSerif(styles.h1.serif)
	constructor: (options = {}) ->
		_.defaults options, styles.h1
		super options

# H2

class H2 extends isSerif(styles.h2.serif)
	constructor: (options = {}) ->
		_.defaults options, styles.h2
		super options

# H3

class H3 extends isSerif(styles.h3.serif)
	constructor: (options = {}) ->
		_.defaults options, styles.h3
		super options

# H4

class H4 extends isSerif(styles.h4.serif)
	constructor: (options = {}) ->
		_.defaults options, styles.h4
		super options

# H5

class H5 extends isSerif(styles.h5.serif)
	constructor: (options = {}) ->
		_.defaults options, styles.h5
		super options

# H6

class H6 extends isSerif(styles.h6.serif)
	constructor: (options = {}) ->
		_.defaults options, styles.h6
		super options

# Lead

class Lead extends isSerif(styles.lead.serif)
	constructor: (options = {}) ->
		_.defaults options, styles.lead
		super options

# Body

class Body extends isSerif(styles.body.serif)
	constructor: (options = {}) ->
		_.defaults options, styles.body
		super options

# Caption

class Caption extends isSerif(styles.caption.serif)
	constructor: (options = {}) ->
		_.defaults options, styles.caption
		super options

# Code

class Code extends MonoText
	constructor: (options = {}) ->
		_.defaults options, styles.code
		super options



# ----------------
# components

# App

class App extends FlowComponent
	constructor: (options = {}) ->
		
		_.defaults options,
			backgroundColor: '#FFF'
		
		super options
		
		@header = new Header
		
		
		# when transition starts, change the header's title
		@onTransitionStart @updateNext
		
		@onTransitionEnd @resetPrevious
	
	updateNext: (prev, next) =>
		if next?.onLoad?
			next.onLoad()
			
		@header.backIcon.visible = prev?
		
		@header.updateTitle(next.name ? '')
		
	resetPrevious: (prev, next) =>
		if prev?.reset?
			prev.reset()

# Header
class Header extends Layer
	constructor: (options = {}) ->
			
		_.assign @,
			topics: []
		
		_.assign options,
			width: Screen.width
			height: 72
			shadowY: 1
			shadowBlur: 6
			shadowColor: 'rgba(0,0,0,.16)'
		
		_.defaults options, 
			name: 'Header'
			backgroundColor: '#fff'
		
		super options
		
		@statusBar = new Layer
			name: 'Status Bar'
			parent: @
			height: 20
			width: @width
			backgroundColor: null
			
		Utils.build @statusBar, ->
			@leftContent = new Layer
				name: '.'
				parent: @
				height: @height
				image: 'images/statusbar_left.png'
				width: @height * 44/20
			
			@rightContent = new Layer
				name: '.'
				parent: @
				x: Align.right()
				height: @height
				image: 'images/statusbar_right.png'
				width: @height * 80/20
				
			@time = new TextLayer
				name: '.'
				parent: @
				x: Align.center()
				y: Align.center()
				fontSize: 12
				fontWeight: 500
				color: '#000'
				text: new Date().toLocaleTimeString([], {hour: 'numeric', minute: '2-digit'})
				
		
		@titleLayer = new H6
			name: 'Title'
			parent: @
			y: Align.center(10)
			width: Screen.width
			textAlign: 'center'
			text: ''
			
		@backIcon = new Icon
			name: 'Back Icon'
			parent: @
			y: Align.center(10)
			x: 8
			icon: 'arrow-left'
			visible: false
			
		@menuIcon = new Icon
			name: 'Menu Icon'
			parent: @
			y: Align.center(10)
			x: Align.right(-8)
			icon: 'dots-vertical'

		# events
		
		@backIcon.onTap => app.showPrevious()
		
		@on "change:title", (value) ->
			@titleLayer.text = value
		
		# definitions
			
		Utils.define @, 'title', options.title
		
	updateTitle: (title) =>

		@titleLayer.animateStop()
		
		@titleLayer.once Events.AnimationEnd, =>
			@title = title
			
			@titleLayer.animate
				opacity: 1
				options:
					time: .3
					delay: .15
	
		@titleLayer.animate
			opacity: 0
			options:
				time: .2

# View

class View extends ScrollComponent
	constructor: (options = {}) ->
		
		_.assign options,
			width: Screen.width
			height: Screen.height
			backgroundColor: '#FFF'
			scrollHorizontal: false
			contentInset:
				top: app.header.height
				bottom: 64
			
		super options
		
		@content.backgroundColor = '#FFF'
		
		Utils.define @, 'title', options.title
			
	swipeHome: =>
		return if flow.current is homeView
		flow.showPrevious()

# Separator

class Separator extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Separator'
			width: Screen.width
			height: 16
			backgroundColor: '#eee'
			clip: true
			shadowY: -1
			shadowColor: 'rgba(0,0,0,.41)'
	
		super options

# Metric

class Metric extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Metric'
			clip: true
			backgroundColor: '#FFF'
			shadowY: 2
			shadowBlur: 4
			shadowColor: 'rgba(0,0,0,.16)'
			data:
				title: 'Reading'
				start: 12
				end: 42
				current: 32
				unit: '%'
				startDate: '1 December 2017'
				endDate: '31 December 2017'
				history: [
					{date: '1 December 2017', value: 12},
					{date: '2 December 2017', value: 13},
					{date: '4 December 2017', value: 17},
					{date: '6 December 2017', value: 18},
					{date: '12 December 2017', value: 20},
					{date: '16 December 2017', value: 29}
					]
				lowerBetter: false
			
		super options
		
		_.assign @,
			data: options.data
		
		_.assign @data,
			startDate: new Date(Date.parse(@data.startDate))
			endDate: new Date(Date.parse(@data.endDate))
			currentDate: new Date()
			progress: _.clamp((@data.current - @data.start) / (@data.end - @data.start), 0, 1)
		
		_.assign @data,
			totalTime: @data.endDate.getTime() - @data.startDate.getTime()
			passedTime: @data.currentDate.getTime() - @data.startDate.getTime()
		
		_.assign @data,
			progressTime: _.clamp(@data.passedTime/@data.totalTime, 0, 1)
		
		# title
		
		@title = new H6
			name: 'Title'
			parent: @
			x: Align.center()
			y: 16
			text: @data.title
			
		# log data
		
		@logIcon = new Icon
			name: 'Log Data Icon'
			parent: @
			x: Align.right()
			y: 0
			icon: 'plus'
			color: '#0075d0'
		
		# metrics
		
		@currentMetric = new H3
			name: 'Current Metric'
			parent: @
			x: Align.center()
			y: @title.maxY + 24
			text: @data.current
		
		@currentUnit = new Caption
			name: 'Current Unit'
			parent: @
			text: @data.unit
		
		_.assign @currentUnit,
			x: @currentMetric.maxX + 2
			y: @currentMetric.y
		
		@startMetric = new H6
			name: 'Start Metric'
			parent: @
			x: 8
			text: @data.start
			
		@endMetric = new H6
			name: 'End Metric'
			parent: @
			x: Align.right(-8)
			text: @data.end
		
		Utils.delay 0, =>
			for layer in [@startMetric, @currentUnit, @endMetric]
				layer.maxY = @currentMetric.maxY - 2
		
		# progress
		
		color = getStatusColor(@data.progress - @data.progressTime, @data.lowerBetter)
		
		@progressFrame = new Layer
			name: 'Progress Frame'
			parent: @
			y: @currentMetric.maxY + 12
			x: 8
			width: @width - 16
			height: 8
			borderRadius: 8
			backgroundColor: new Color(color).alpha(.2)
			
		@progressFill = new Layer
			name: 'Progress Fill'
			parent: @
			y: @currentMetric.maxY + 12
			x: 8
			width: (@width - 16) * @data.progress
			height: 8
			borderRadius: 8
			backgroundColor: color
		
		# date progress
		
		@dateProgressFrame = new Layer
			name: 'Date Progress Frame'
			parent: @
			y: @progressFrame.maxY + 8
			x: 8
			width: @width - 16
			height: 4
			borderRadius: 8
		
		@dateProgressFill = new Layer
			name: 'Date Progress Fill'
			parent: @
			y: @progressFrame.maxY + 8
			x: 8
			width: (@width - 16) * (@data.progressTime)
			height: 4
			borderRadius: 8
			backgroundColor: '#000'
		
		# start date
		
		dateOptions = {month: 'short', day: 'numeric', year: '2-digit'}
		
		@startDateLayer = new H6
			name: 'Start Date'
			parent: @
			x: 8
			y: @dateProgressFill.maxY + 16
			text: @data.startDate.toLocaleDateString([], dateOptions)
		
		@endDateLayer = new H6
			name: 'End Date'
			parent: @
			x: Align.right(-8)
			y: @dateProgressFill.maxY + 16
			text: @data.endDate.toLocaleDateString([], dateOptions)
		
		# more icon
		
		@moreIcon = new Icon
			parent: @
			x: Align.center()
			y: @progressFill.maxY + 18
			icon: 'chevron-down'
			
		# Graph
		
		@graph = new Graph
			parent: @
			x: 16
			y: @moreIcon.maxY + 16
			width: @width - 32
			data: @data
		
		@height = @endDateLayer.maxY + 24
		
		
		@on "change:toggled", @toggleGraph
		
		@onTap => 
			@toggled = !@toggled
			
			for sib in @siblings
				if sib.constructor.name is 'Metric'
					sib.toggled = false
		
		Utils.define @, "toggled", false
	
	toggleGraph: =>
	
		if not @toggled
			
			@moreIcon.icon = 'chevron-down'
		
			@moreIcon.animate
				y: @progressFill.maxY + 18
				options:
					time: .25
		
			@animate
				height: @endDateLayer.maxY + 24
				options:
					time: .25
					
			return
			
		@moreIcon.icon = 'chevron-up'
			
		@moreIcon.animate
			y: @graph.maxY + 8
			options:
				time: .25
		
		@animate
			height: @graph.maxY + 48
			options:
				time: .25


# ----------------
# custom views


# ----------------
# data

# User

user =
	name: 'Charlie Rogers'
	age: 28
	sex: Utils.randomChoice(['female', 'male', 'nonbinary'])
	date: new Date


# ----------------
# implementation

app = new App

# Home View

homeView = new View
	name: 'Home View'

Utils.build homeView, ->
	
	@backgroundColor = '#efefef'
	@content.backgroundColor = '#efefef'
	
	separators = []
	
	for i in _.range(6)
		separators[i] = new Separator
			parent: @content
			y: 96 * i
			
	# Utils.distribute Link
	
	link = new Layer
		parent: @content
		y: separators[0].maxY
		height: 79
		width: @width
		backgroundColor: '#FFF'
	
	new H4
		parent: link
		x: 32
		y: Align.center()
		text: 'Utils.distribute'
	
	new Icon	
		parent: link
		x: Align.right(-8)
		y: Align.center()
		icon: 'chevron-right'
		
	link.onTap -> app.showNext(distributeView)
	
	# Utils.align Link
	
	link = new Layer
		parent: @content
		y: separators[1].maxY
		height: 79
		width: @width
		backgroundColor: '#FFF'
	
	new H4
		parent: link
		x: 32
		y: Align.center()
		text: 'Utils.align'
	
	new Icon	
		parent: link
		x: Align.right(-8)
		y: Align.center()
		icon: 'chevron-right'
		
	link.onTap -> app.showNext(alignView)
	
	# Utils.constrain Link
	
	link = new Layer
		parent: @content
		y: separators[2].maxY
		height: 79
		width: @width
		backgroundColor: '#FFF'
	
	new H4
		parent: link
		x: 32
		y: Align.center()
		text: 'Utils.constrain'
	
	new Icon	
		parent: link
		x: Align.right(-8)
		y: Align.center()
		icon: 'chevron-right'
		
	link.onTap -> app.showNext(constrainView)
	
	# Utils.pin Link
	
	link = new Layer
		parent: @content
		y: separators[3].maxY
		height: 79
		width: @width
		backgroundColor: '#FFF'
	
	new H4
		parent: link
		x: 32
		y: Align.center()
		text: 'Utils.pin'
	
	new Icon	
		parent: link
		x: Align.right(-8)
		y: Align.center()
		icon: 'chevron-right'
		
	link.onTap -> app.showNext(pinView)
	
	# Utils.grid Link
	
	link = new Layer
		parent: @content
		y: separators[4].maxY
		height: 79
		width: @width
		backgroundColor: '#FFF'
	
	new H4
		parent: link
		x: 32
		y: Align.center()
		text: 'Utils.grid'
	
	new Icon	
		parent: link
		x: Align.right(-8)
		y: Align.center()
		icon: 'chevron-right'
		
	link.onTap -> app.showNext(gridView)
	
	
	

# Distribute View
distributeView = new View
	name: 'Utils'

Utils.build distributeView, ->
	
	# In design software, "distribute" normally means something like, "Arrange all layers so that they are spaced evenly between two points." The result is a nice horizontal or vertical distribution. Utils.distribute works the same way: take an array of layers, give it a property to change, and the start and end values to distribute between. For a horizontal distribution, the property would be `x` (or `midX`) and the values would be the left and right values of the distribution. For a vertical distribution, same idea but with y. Of course, since this is code, we can get creative: we could distribute layers between multiple values, such as hueRotate or rotation, size or borderRadius, etc. In each case, whatever the property we're distributing, the first layer in the array would use the start value and each following layer would be set that much closer to the end value, until the last is set to the end value.
	
	@title = new H3
		parent: @content
		x: Align.center()
		y: 32
		text: 'Utils.distribute'
		
		
	@subtitle = new Code
		parent: @content
		x: Align.center()
		y: @title.maxY + 8
		text: 'Utils.distribute(array, property, start, end)'
	
	separators = []
	
	for i in _.range(5)
		separators[i] = new Layer
			parent: @content
			name: '.'
			width: Screen.width - 16
			height: 1
			x: 8
			y: @subtitle.maxY + 16 + (180 * i)
			backgroundColor: '#777'
		
		
	# standard x position / distribution
	
	layers = []
	
	for i in _.range(10)
		layers[i] = new Layer
			name: 'Distribute Layer 1'
			parent: @content
			y: separators[0].y + 32
			width: 28
			height: 72
			borderWidth: 1
			borderColor: '#00aaff'
			backgroundColor: '#98d5ff'
			animationOptions: 
				time: .25
			
	Utils.distribute(layers, 'x', 32, @width - 60)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[0].y + 128
		text: 'Utils.distribute(layers, "x", 32, 256)'
	
	# x position / rotation distribution
	
	layers = []
	
	for i in _.range(10)
		layers[i] = new Layer
			name: 'Distribute Layer 1'
			parent: @content
			y: separators[1].y + 32
			width: 28
			height: 72
			borderWidth: 1
			borderColor: '#00aaff'
			backgroundColor: '#98d5ff'
			animationOptions: 
				time: .25
			
	Utils.distribute(layers, 'x', 32, @width - 60)
	Utils.distribute(layers, 'rotation', 0, 180)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[1].y + 128
		text: 'Utils.distribute(layers, "rotation", 0, 180)'
	
	# x position / hueRotate distribution
	
	layers = []
	
	for i in _.range(10)
		layers[i] = new Layer
			name: 'Distribute Layer 2'
			parent: @content
			width: 28
			height: 72
			y: separators[2].y + 32
			backgroundColor: '#22ccff'
			animationOptions: 
				time: .25
			
	Utils.distribute(layers, 'x', 32, @width - 60)
	Utils.distribute(layers, 'hueRotate', 0, 180)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[2].y + 128
		text: 'Utils.distribute(layers, "hueRotate", 0, 180)'
	
	# x position / hueRotate / borderRadius distribution
	
	layers = []
	
	for i in _.range(10)
		layers[i] = new Layer
			name: 'Distribute Layer 2'
			parent: @content
			y: separators[3].y + 32
			width: 28
			height: 72
			borderWidth: 1
			borderColor: '#00aaff'
			backgroundColor: '#98d5ff'
			animationOptions: 
				time: .25
			
	Utils.distribute(layers, 'x', 32, @width - 60)
	Utils.distribute(layers, 'opacity', .1, 1)
	Utils.distribute(layers, 'borderRadius', 0, 32)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[3].y + 128
		text: 'Utils.distribute(layers, "opacity", 0.1, 1)'
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[3].y + 144
		text: 'Utils.distribute(layers, "borderRadius", 0, 32)'
		
	@updateContent()

# Align View
alignView = new View
	name: 'Utils'

Utils.build alignView, ->
	
	@title = new H3
		parent: @content
		x: Align.center()
		y: 32
		text: 'Utils.align'
	
	@subtitle = new Code
		parent: @content
		x: Align.center()
		y: @title.maxY + 8
		text: 'Utils.align(array, property, target)'
	
	separators = []
	
	for i in _.range(5)
		separators[i] = new Layer
			parent: @content
			name: '.'
			width: Screen.width - 16
			height: 1
			x: 8
			y: @subtitle.maxY + 16 + (180 * i)
			backgroundColor: '#777'
	
		
	# align on maxY property (bottom align)
	
	layers = []
	
	for i in _.range(10)
		layers[i] = new Layer
			name: 'Align Layer 1'
			parent: @content
			y: separators[0].y + 72
			width: 28
			height: _.random(32, 72)
			borderWidth: 1
			borderColor: '#00aaff'
			backgroundColor: '#98d5ff'
			animationOptions: 
				time: .25
			
	Utils.distribute(layers, 'x', 32, @width - 60)
	Utils.align(layers, 'maxY')
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[0].y + 128
		text: 'Utils.align(layers, "maxY")'
	
	# align on midY property (middle align)
	
	layers = []
	
	for i in _.range(10)
		layers[i] = new Layer
			name: 'Align Layer 1'
			parent: @content
			y: separators[1].y + 48
			width: 28
			height: _.random(32, 72)
			borderWidth: 1
			borderColor: '#00aaff'
			backgroundColor: '#98d5ff'
			animationOptions: 
				time: .25
			
	Utils.distribute(layers, 'x', 32, @width - 60)
	Utils.align(layers, 'midY')
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[1].y + 128
		text: 'Utils.align(layers, "midY")'
	
	# align on backgroundColor property (with animate)
	
	layers = []
	
	for i in _.range(10)
		layers[i] = new Layer
			name: 'Align Layer 2'
			parent: @content
			width: 28
			height: 64
			y: separators[2].y + 32
			backgroundColor: Color.random()
			animationOptions: 
				time: 5.25
			
	Utils.distribute(layers, 'x', 32, @width - 60)
	
	do (layers) =>
		@onLoad = -> Utils.align(layers, 'backgroundColor', '#23CBFF', true)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[2].y + 128
		fontSize: 10
		text: 'Utils.align(layers, "backgroundColor", "#23CBFF", true)'
	
	# align iteratively, using a function
	
	layers = []
	
	for i in _.range(10)
		layers[i] = new Layer
			name: 'Align Layer 2'
			parent: @content
			width: 28
			height: 64
			y: separators[3].y + 32
			animationOptions: 
				time: .25
		
	getColor = (i) -> Color.mix('#1738A8', '#AA88FF', i * 1/10)
	
	Utils.distribute(layers, 'x', 32, @width - 64)
	Utils.align(layers, 'backgroundColor', getColor)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[3].y + 128
		fontSize: fontSize * .6
		text: 'getColor = (i) -> Color.mix("#1738A8", "#AA88FF", i * 1/10)'
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[3].y + 144
		text: 'Utils.align(layers, "backgroundColor", getColor)'
		
	@updateContent()

# Constrain View
constrainView = new View
	name: 'Utils'

Utils.build constrainView, ->
	
	
	@title = new H3
		parent: @content
		x: Align.center()
		y: 32
		text: 'Utils.constrain'
		
		
	@subtitle = new Code
		parent: @content
		x: Align.center()
		y: @title.maxY + 8
		text: 'Utils.constrain(layer, options = {})'
	
	separators = []
	
	for i in _.range(8)
		separators[i] = new Layer
			parent: @content
			name: '.'
			width: Screen.width - 16
			height: 1
			x: 8
			y: @subtitle.maxY + 16 + (196 * i)
			backgroundColor: '#777'
	
	# keep it dry functions
	
	animOptions =
		time: .35
	
	setMoves = (layerA) ->
		startX = layerA.x
		startY = layerA.y
		
		xaxis0 = new Animation layerA,
			x: startX + 16
			width: 64
			height: 96
			options: animOptions
		
		xaxis1 = new Animation layerA,
			x: startX - 16
			width: 128
			height: 96
			options: animOptions
		
		xaxis2 = new Animation layerA,
			x: startX
			width: 96
			height: 96
			options: animOptions
		
		
		yaxis0 = new Animation layerA,
			y: startY + 16
			width: 96
			height: 64
			options: animOptions
		
		yaxis1 = new Animation layerA,
			y: startY - 16
			width: 96
			height: 128
			options: animOptions
		
		yaxis2 = new Animation layerA,
			y: startY
			width: 96
			height: 96
			options: animOptions
		
		Utils.chainAnimations([xaxis0, xaxis1, xaxis2, yaxis0, yaxis1, yaxis2])
	
	makeParent = (separator = 0) =>
		return new Layer
			parent: @content
			y: separators[separator].y + 24
			x: Align.center
			width: 96
			height: 96
			borderWidth: 1
			borderColor: '#98d5ff'
			backgroundColor: '#cdebff'
	
	makeChild = (parent) =>
		return new Layer
			parent: parent
			width: 56
			height: 56
			x: 16
			y: 16
			borderWidth: 1
			borderColor: '#00aaff'
			backgroundColor: '#98d5ff'
			
	makeDescription = (separator, text) =>
		return new Code
			parent: @content
			x: Align.center()
			y: separators[separator].y + 160
			text: text
			
	# left
	
	parent = makeParent(0)
	child = makeChild(parent)
	makeDescription 0, 'Utils.constrain(layer, {left: true})'
	
	Utils.constrain child,
		left: true
		
	setMoves(parent, child)
	
	
	# right
	
	parent = makeParent(1)
	child = makeChild(parent)
	makeDescription 1, 'Utils.constrain(layer, {right: true})'
	
	Utils.constrain child,
		right: true
		
	setMoves(parent, child)
	
	
	# bottom
	
	parent = makeParent(2)
	child = makeChild(parent)
	makeDescription 2, 'Utils.constrain(layer, {bottom: true})'
	
	Utils.constrain child,
		bottom: true
		
	setMoves(parent, child)
	
	
	# top
	
	parent = makeParent(3)
	child = makeChild(parent)
	makeDescription 3, 'Utils.constrain(layer, {top: true})'
	
	Utils.constrain child,
		top: true
		
	setMoves(parent, child)
	
	
	# height
	
	parent = makeParent(4)
	child = makeChild(parent)
	makeDescription 4, 'Utils.constrain(layer, {height: true})'
	
	Utils.constrain child,
		height: true
		
	setMoves(parent, child)
	
	
	# width
	
	parent = makeParent(5)
	child = makeChild(parent)
	makeDescription 5, 'Utils.constrain(layer, {width: true})'
	
	Utils.constrain child,
		width: true
		
	setMoves(parent, child)
	
	
	# aspect ratio + width
	
	parent = makeParent(6)
	child = makeChild(parent)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[6].y + 160
		text: 'Utils.constrain(layer, {width: true, aspectRatio: true})'
		fontSize: 10
	
	Utils.constrain child,
		width: true
		aspectRatio: true
		
	setMoves(parent, child)
	
	
	# aspect ratio + height
	
	parent = makeParent(7)
	child = makeChild(parent)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[7].y + 160
		text: 'Utils.constrain(layer, {height: true, aspectRatio: true})'
		fontSize: 10
	
	Utils.constrain child,
		height: true
		aspectRatio: true
		
	setMoves(parent, child)
	
	@updateContent()

# Pin View

pinView = new View
	name: 'Utils'

Utils.build pinView, ->
	
	@title = new H3
		parent: @content
		x: Align.center()
		y: 32
		text: 'Utils.pin'
		
	@subtitle = new Code
		parent: @content
		x: Align.center()
		y: @title.maxY + 8
		text: 'Utils.pin(layer, directions, distance)'
	
	separators = []
	
	for i in _.range(8)
		separators[i] = new Layer
			parent: @content
			name: '.'
			width: Screen.width - 16
			height: 1
			x: 8
			y: @subtitle.maxY + 16 + (196 * i)
			backgroundColor: '#777'
	
	# mover
	
	animOptions =
		time: .35
	
	setMoves = (layer) ->
		
		startX = layer.x
		startY = layer.y
		
		xaxis0 = new Animation layer,
			x: startX + 16
			width: 64
			height: 96
			options: animOptions
		
		xaxis1 = new Animation layer,
			x: startX - 16
			width: 128
			height: 96
			options: animOptions
		
		xaxis2 = new Animation layer,
			x: startX
			width: 96
			height: 96
			options: animOptions
		
		
		yaxis0 = new Animation layer,
			y: startY + 16
			width: 96
			height: 64
			options: animOptions
		
		yaxis1 = new Animation layer,
			y: startY - 16
			width: 96
			height: 128
			options: animOptions
		
		yaxis2 = new Animation layer,
			y: startY
			width: 96
			height: 96
			options: animOptions
		
		
		Utils.chainAnimations([xaxis0, xaxis1, xaxis2, yaxis0, yaxis1, yaxis2])
	
	makeLgLayer = (separator = 0) =>
		return new Layer
			parent: @content
			y: separators[separator].y + 24
			x: Align.center
			width: 96
			height: 96
			borderWidth: 1
			borderColor: '#98d5ff'
			backgroundColor: '#cdebff'
	
	# left
	
	smLayer = new Layer
		parent: @content
		y: separators[0].y + 24
		x: 80
		width: 48
		height: 48
		borderWidth: 1
		borderColor: '#00aaff'
		backgroundColor: '#98d5ff'
	
	lgLayer = makeLgLayer(0)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[0].y + 160
		text: "Utils.pin(smLayer, lgLayer, 'left')"
	
	Utils.pin smLayer, lgLayer, 'left' 
	
	setMoves(lgLayer)
	
	
	
	# right
	
	smLayer = new Layer
		parent: @content
		y: separators[1].y + 24
		x: 248
		width: 48
		height: 48
		borderWidth: 1
		borderColor: '#00aaff'
		backgroundColor: '#98d5ff'
	
	lgLayer = makeLgLayer(1)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[1].y + 160
		text: "Utils.pin(smLayer, lgLayer, 'right')"
	
	Utils.pin smLayer, lgLayer, 'right' 
	
	setMoves(lgLayer)
	
	
	
	# top
	
	smLayer = new Layer
		parent: @content
		y: separators[2].y + 24
		x: 80
		width: 48
		height: 48
		borderWidth: 1
		borderColor: '#00aaff'
		backgroundColor: '#98d5ff'
	
	lgLayer = makeLgLayer(2)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[2].y + 160
		text: "Utils.pin(smLayer, lgLayer, 'top')"
	
	Utils.pin smLayer, lgLayer, 'top' 
	
	setMoves(lgLayer)
	
	
	
	# bottom
	
	smLayer = new Layer
		parent: @content
		y: separators[3].y + 72
		x: 248
		width: 48
		height: 48
		borderWidth: 1
		borderColor: '#00aaff'
		backgroundColor: '#98d5ff'
	
	lgLayer = makeLgLayer(3)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[3].y + 160
		text: "Utils.pin(smLayer, lgLayer, 'bottom')"
	
	Utils.pin smLayer, lgLayer, 'bottom' 
	
	setMoves(lgLayer)
	
	
	
	# distance
	
	smLayer = new Layer
		parent: @content
		y: separators[4].y + 24
		x: 80
		width: 48
		height: 48
		borderWidth: 1
		borderColor: '#00aaff'
		backgroundColor: '#98d5ff'
	
	lgLayer = makeLgLayer(4)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[4].y + 160
		text: "Utils.pin(smLayer, lgLayer, 'left', 48)"
	
	Utils.pin smLayer, lgLayer, 'left', 48 
	
	setMoves(lgLayer)
	
	
	
	# unpin
	
	smLayer = new Layer
		parent: @content
		y: separators[5].y + 24
		x: 80
		width: 48
		height: 48
		borderWidth: 1
		borderColor: '#00aaff'
		backgroundColor: '#98d5ff'
	
	lgLayer = makeLgLayer(5)
		
	description = new Code
		parent: @content
		x: Align.center()
		y: separators[5].y + 160
		text: "smLayer.onTap -> Utils.unpin(smLayer)"
	
	i = 0
	
	smLayer.onTap -> 
		if i % 2 is 0
			Utils.unpin smLayer
		else
			Utils.pin smLayer, lgLayer, 'left'
			
		i++
		
	
	Utils.pin smLayer, lgLayer, 'left' 
	
	setMoves(lgLayer)
	
	@updateContent()

# Grid View

gridView = new View
	name: 'Utils'

Utils.build gridView, ->
	
	@title = new H3
		parent: @content
		x: Align.center()
		y: 32
		text: 'Utils.grid'
		
		
	@subtitle = new Code
		parent: @content
		x: Align.center()
		y: @title.maxY + 8
		text: 'Utils.grid(layers, columns, rowMargin, colMargin)'
	
	separators = []
	
	for i in _.range(8)
		separators[i] = new Layer
			parent: @content
			name: '.'
			width: Screen.width - 16
			height: 1
			x: 8
			y: @subtitle.maxY + 16 + (196 * i)
			backgroundColor: '#777'
			
	makeDescription = (separator, text) =>
		return new Code
			name: 'Description ' + separator
			parent: @content
			x: Align.center()
			y: separators[separator].y + 160
			text: text
			
	# basic grid
	
	layers = []
	
	for i in _.range(10)
		layers[i] = new Layer
			name: '.'
			parent: @content
			x: 96
			y: separators[0].y + 16
			width: 32
			height: 32
			borderWidth: 1
			borderColor: '#00aaff'
			backgroundColor: '#98d5ff'
			animationOptions: 
				time: .25
			
	makeDescription 0, 'Utils.grid(layers, 4)'
				
	Utils.grid(layers, 4)
	
	
			
	# basic grid
	
	layers = []
	
	for i in _.range(10)
		layers[i] = new Layer
			name: '.'
			parent: @content
			x: 96
			y: separators[0].y + 16
			width: 32
			height: 32
			borderWidth: 1
			borderColor: '#98d5ff'
			backgroundColor: '#cdebff'
			animationOptions: 
				time: .25
			
	makeDescription 0, 'Utils.grid(layers, 4)'
				
	Utils.grid(layers, 4)
	
	# making grid from layer
	
	layer = new Layer
		name: '.'
		parent: @content
		x: 96
		y: separators[1].y + 16
		width: 32
		height: 32
		borderWidth: 1
		borderColor: '#98d5ff'
		backgroundColor: '#cdebff'
		animationOptions: 
			time: .25
			
	Utils.makeGrid(layer, 4, 3)
			
	makeDescription 1, 'Utils.makeGrid(layer, 4, 3)'
	
	# choose a grid member
	
	layer = new Layer
		name: '.'
		parent: @content
		x: 96
		y: separators[2].y + 16
		width: 32
		height: 32
		borderWidth: 1
		borderColor: '#98d5ff'
		backgroundColor: '#cdebff'
		animationOptions: 
			time: .25
			
	grid = Utils.makeGrid(layer, 4, 3)
	
	grid.getLayer(1, 2).backgroundColor = '#98ee66'
	
	makeDescription 2, "grid.getLayer(1, 2).backgroundColor = '#98ee66'"
	
	# choose a random grid member
	
	layer = new Layer
		name: '.'
		parent: @content
		x: 96
		y: separators[3].y + 16
		width: 32
		height: 32
		borderWidth: 1
		borderColor: '#98d5ff'
		backgroundColor: '#cdebff'
		animationOptions: 
			time: .25
			
	grid = Utils.makeGrid(layer, 4, 3)
	
	grid.getRandom().backgroundColor = '#98ee66'
	
	makeDescription 3, "grid.getRandom().backgroundColor = '#98ee66'"
	
	
	# apply all to grid members
	
	layer = new Layer
		name: '.'
		parent: @content
		x: 96
		y: separators[4].y + 16
		width: 32
		height: 32
		borderWidth: 1
		borderColor: '#98d5ff'
		backgroundColor: '#cdebff'
		animationOptions: 
			time: .25
			
	grid = Utils.makeGrid(layer, 4, 3)
	
	grid.apply -> @rotation = 35
	
	makeDescription 4, "grid.apply -> @rotation = 35"
	
	
	# pull grid members
	
	layer = new Layer
		name: '.'
		parent: @content
		x: 96
		y: separators[5].y + 16
		width: 32
		height: 32
		borderWidth: 1
		borderColor: '#98d5ff'
		backgroundColor: '#cdebff'
		animationOptions: 
			time: .25
			
	grid = Utils.makeGrid(layer, 4, 3)
	
	Utils.distribute(grid.layers, 'hueRotate', 0, 360)
	
	do (grid) ->
		grid.apply -> @onTap => grid.pull(@)
	
	makeDescription 5, "layer.onTap -> grid.pull(@)"
	
	
	# push grid members
	
	layers = []
	
	for i in _.range(1)
		layers[i] = new Layer
			name: '.'
			parent: @content
			x: 96
			y: separators[6].y + 16
			width: 32
			height: 32
			borderWidth: 1
			borderColor: '#00aaff'
			backgroundColor: '#98d5ff'
			animationOptions: 
				time: .25
			
	grid = Utils.grid(layers, 4)
	
	Utils.distribute(grid.layers, 'hueRotate', 0, 360)
	
	do (grid) ->
		grid.apply -> @onTap => grid.push()
	
	makeDescription 6, "layer.onTap -> grid.push()"
	
	@updateContent()

# Template View

TemplateView = new View
	name: 'Utils'

Utils.build TemplateView, ->
	
	@title = new H3
		parent: @content
		x: Align.center()
		y: 32
		text: 'Utils.template'
		
	@subtitle = new Code
		parent: @content
		x: Align.center()
		y: @title.maxY + 8
		text: 'Utils.template(args...)'
	
	separators = []
	
	for i in _.range(8)
		separators[i] = new Layer
			parent: @content
			name: '.'
			width: Screen.width - 16
			height: 1
			x: 8
			y: @subtitle.maxY + 16 + (196 * i)
			backgroundColor: '#777'
	
	makeLgLayer = (separator = 0) =>
		return new Layer
			parent: @content
			y: separators[separator].y + 24
			x: Align.center
			width: 96
			height: 96
			borderWidth: 1
			borderColor: '#98d5ff'
			backgroundColor: '#cdebff'




app.showNext(homeView, false)

app.bringToFront()