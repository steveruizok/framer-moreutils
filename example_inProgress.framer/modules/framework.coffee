require 'moreutils'
theme = require 'components/Theme'
colors = require 'components/Colors'
typography = require 'components/Typography'

colors.updateColors()

# disable hints
Framer.Extras.Hints.disable()

# get rid of dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

# require in everything else
{ Button } = require 'components/Button'
{ Radiobox } = require 'components/Radiobox'
{ Checkbox } = require 'components/Checkbox'
{ DocComponent } = require 'components/DocComponent'
{ Footer } = require 'components/Footer'
{ Header } = require 'components/Header'
{ Segment } = require 'components/Segment'
{ Toggle } = require 'components/Toggle'
{ Tooltip } = require 'components/Tooltip'
{ Icon } = require 'components/Icon'
{ Link } = require 'components/Link'
{ Separator } = require 'components/Separator'
{ Select } = require 'components/Select'
{ Stepper } = require 'components/Stepper'
{ TextInput } = require 'components/TextInput'
{ View } = require 'components/View'
{ CarouselComponent } = require 'components/CarouselComponent'
{ PageTransitionComponent } = require 'components/PageTransitionComponent'
{ SortableComponent } = require 'components/SortableComponent'
{ TransitionPage } = require 'components/PageTransitionComponent'

# Exports for theme support 
_.assign exports,
	defaultTitle: "www.framework.com"
	app: undefined
	components: [
		'Button', 
		'Header', 
		'Radiobox',
		'Checkbox',
		'DocComponent',
		'Toggle',
		'Tooltip',
		'Select',
		'Icon', 
		'Stepper', 
		'Segment',
		'TextInput',
		'Link', 
		'Separator', 
		'TransitionPage', 
		'View', 
		'CarouselComponent', 
		'SortableComponent'
		'PageTransitionComponent'
		]
	theme: theme
	typography: typography
	colors: colors

# Add components to window
exports.components.forEach (componentName) ->
	window[componentName] = class FrameworkComponent extends eval(componentName)
		constructor: (options = {}) ->
			@app = exports.app
			super options


# ... and finally, the App class
class window.App extends FlowComponent
	constructor: (options = {}) ->

		exports.app = @

		_.defaults options,
			backgroundColor: white
			title: exports.defaultTitle
			chrome: 'ios'
			contentWidth: Screen.width

		super options

		_.assign @,
			chrome: options.chrome
			_windowFrame: {}
			views: []
			contentWidth: Screen.width

		# Transition
		 
		@_platformTransition = switch @chrome
			when "safari"
				@_safariTransition
			when "ios"
				@_iosTransition
			else
				@_defaultTransition

		# layers

		@loadingLayer = new Layer 
			name: '.'
			size: Screen.size
			backgroundColor: if @chrome is "safari" then 'rgba(0,0,0,0)' else 'rgba(0,0,0,.14)'
			visible: false

		@loadingLayer._element.style["pointer-events"] = "all"
		@loadingLayer.sendToBack()

		# By this point, these should be different classes...
		unless @chrome is "safari"
			Utils.bind @loadingLayer, ->
				
				@loadingContainer = new Layer
					name: '.'
					parent: @
					x: Align.center()
					y: Align.center()
					size: 48
					backgroundColor: 'rgba(0,0,0,.64)'
					borderRadius: 8
					opacity: .8
					backgroundBlur: 30

				@iconLayer = new Icon 
					parent: @loadingContainer
					height: 32
					width: 32
					point: Align.center()
					style:
						lineHeight: 1
					color: white
					icon: "loading"

				anim = new Animation @iconLayer,
					rotation: 360
					options:
						curve: "linear"
						looping: true

				anim.start()


		# header

		if @chrome
			# don't show safari bar when opening this project on mobile web
			# ... but this might require a lot of app.header?.etc
			if @chrome is 'safari' and Utils.isSafari()
				@chrome = null

			@header = new Header
				app: @
				safari: @chrome is 'safari'
				title: options.title
		
			if @chrome is 'safari'
				@footer = new Footer 
					app: @

				@onSwipeUpEnd =>
					return unless @current.isMoving 

					@header._collapse()
					@footer._collapse()

				@onSwipeDownEnd =>
					return unless @current.isMoving

					@header._expand()
					@footer._expand()

		@header?.on "change:height", @_setWindowFrame
		@footer?.on "change:height", @_setWindowFrame

		@_setWindowFrame()

		# definitions
		Utils.define @, 'focused', null, @_showFocused, _.isObject, "App.focused must be an html element."
		Utils.define @, 'loading', false, @_showLoading, _.isBoolean, "App.loading must be a boolean (true or false)."

		# when transition starts, update the header
		@onTransitionStart @_updateHeader

		# when transition ends, reset the previous view
		@onTransitionEnd @_updatePrevious

		Screen.on Events.EdgeSwipeLeftEnd, @showPrevious

	# ---------------
	# Private Methods

	_showFocused: (el) =>
		# possibly... an app state dealing with an on-screen keyboard
		return

	_updateHeader: (prev, next, direction) =>
		# header changes
		return if not @header

		hasPrevious = prev? and next isnt @_stack[0]?.layer

		# safari changes
		if @header.safari
			@footer.hasPrevious = hasPrevious
			return

		# ios changes
		@header.backIcon.visible = hasPrevious
		@header.backText.visible = hasPrevious
		
		if next.title 
			@header.updateTitle(next.title)

	# Update the next View before transitioning
	_updateNext: (prev, next) =>
		return if not next

		next._loadView(@, next, prev)
		
	
	# Reset the previous View after transitioning
	_updatePrevious: (prev, next, direction) =>
		return unless prev? and prev instanceof View

		prev.sendToBack()
		prev._unloadView(@, next, prev, direction)

	_safariTransition: (nav, layerA, layerB, overlay) =>
		options = {time: 0.01}
		transition =
			layerA:
				show: {options: options, x: Align.center(), brightness: 100, y: @windowFrame.y}
				hide: {options: options, x: Align.center(), brightness: 101, y: @windowFrame.y}
			layerB:
				show: {options: options, x: Align.center(), brightness: 100, y: @windowFrame.y}
				hide: {options: options, x: Align.center(), brightness: 101, y: @windowFrame.y}

	_iosTransition: (nav, layerA, layerB, overlay) =>
		options = {curve: "spring(300, 35, 0)"}
		transition =
			layerA:
				show: {options: options, x: Align.center(), y: @windowFrame.y}
				hide: {options: options, x: 0 - layerA?.width / 2, y: @windowFrame.y}
			layerB:
				show: {options: options, x: Align.center(), y: @windowFrame.y}
				hide: {options: options, x: @width + layerB.width / 2, y: @windowFrame.y}

	_defaultTransition: (nav, layerA, layerB, overlay) =>
		options = {curve: "spring(300, 35, 0)"}
		transition =
			layerA:
				show: {options: options, x: Align.center(), y: @windowFrame.y}
				hide: {options: options, x: 0 - layerA?.width / 2, y: @windowFrame.y}
			layerB:
				show: {options: options, x: Align.center(), y: @windowFrame.y}
				hide: {options: options, x: @width + layerB.width / 2, y: @windowFrame.y}

	_setWindowFrame: =>
		@_windowFrame = {
			y: (@header?.height ? 0)
			x: @x
			maxX: @maxX
			maxY: @height - (@footer?.height ? 0)
			height: @height - (@footer?.height ? 0) - (@header?.height - 0)
			width: @width
			size: {
				height: @height - (@footer?.height ? 0) - (@header?.height - 0)
				width: @width
			}
		}

		@emit "change:windowFrame", @_windowFrame, @

	_showLoading: (bool) =>
		if bool
			@focused?.blur()
			@loadingLayer.visible = true
			@loadingLayer.bringToFront()

			# show safari loading
			if @chrome is "safari"
				@header._expand()
				@footer._expand()
				@header._showLoading(true)
				return

			# show ios loading
			return

		@loadingLayer.visible = false
		@loadingLayer.sendToBack()

		# show safari loading ended
		if @chrome is "safari"
			@header._expand()
			@footer._expand()
			@header._showLoading(false)
			return

	# ---------------
	# Public Methods
	
	# show next view
	showNext: (layer, loadingTime, options={}) ->
		@_initial ?= layer

		if @chrome is "safari" then loadingTime ?= _.random(.5, .75)

		@_updateNext(@current, layer)

		# if loading time specified...
		if loadingTime?
			@loading = true
			Utils.delay loadingTime, =>
				@loading = false
				@transition(layer, @_platformTransition, options)
			return

		# otherwise, show next
		@focused?.blur()
		@transition(layer, @_platformTransition, options)


	showPrevious: (options={}) =>
		return unless @previous
		return if @isTransitioning

		# Maybe people (Jorn, Steve for sure) pass in a layer accidentally
		options = {} if options instanceof(Framer._Layer)
		options = _.defaults({}, options, {count: 1, animate: true})

		if options.count > 1
			count = options.count
			@showPrevious(animate: false, count: 1) for n in [2..count]

		previous = @_stack.pop()
		current = @current
		try current._loadView()
		
		if @chrome is "safari"
			@loading = true
			loadingTime = _.random(.3, .75)
			Utils.delay loadingTime, =>
				@loading = false
				@_runTransition(previous?.transition, "back", options.animate, current, previous.layer)
			return

		@focused?.blur()
		@_runTransition(previous?.transition, "back", options.animate, current, previous.layer)


	@define "windowFrame",
		get: -> return @_windowFrame