Theme = require "components/Theme"
theme = undefined

class exports.View extends ScrollComponent
	constructor: (options = {}) ->
		theme = Theme.theme
		@__constructor = true
		@__instancing = true

		# ---------------
		# Options

		_.defaults options,
			backgroundColor: '#FFF'
			contentInset:
				bottom: 64
				
			padding: {}
			title: ''
			load: null
			unload: null
			key: null
			clip: false
			preserveContent: false
			oneoff: false

		_.assign options,
			width: @app.contentWidth
			height: @app.windowFrame.height
			scrollHorizontal: false

		super options

		@key = options.key

		# ---------------
		# Layers

		@app.views.push(@)
		@content.backgroundColor = @backgroundColor
		@sendToBack()

		# ---------------
		# Definitions
		
		delete @__constructor
		
		# 				Property			Initial value 			Callback 	Validation		Error
		Utils.define @, 'title', 			options.title, 			undefined, 	_.isString, 	'View.title must be a string.'
		Utils.define @, 'padding',			options.padding, 		undefined, 	_.isObject, 	'View.padding must be an object.'
		Utils.define @, 'load', 			options.load, 			undefined, 	_.isFunction, 	'View.load must be a function.'
		Utils.define @, 'unload', 			options.unload, 		undefined, 	_.isFunction, 	'View.unload must be a function.'
		Utils.define @, 'oneoff', 			options.oneoff, 		undefined, 	_.isBoolean, 	'View.oneoff must be a boolean (true or false).'
		Utils.define @, 'preserveContent',	options.preserveContent, undefined,	_.isBoolean, 	'View.preserveContent must be a boolean (true or false).'
		
		delete @__instancing

		# unless padding is specifically null, set padding defaults
		if @padding?
			_.defaults @padding,
				left: 16,
				right: 16,
				top: 16,

		# ---------------
		# Events
		
		@content.on "change:children", @_fitChildrenToPadding
		@app.on "change:windowFrame", @_updateSize

	# ---------------
	# Private Functions
	
	_delayUpdateSize: =>
		Utils.delay 1, @_updateSize


	_updateSize: (windowFrame) =>
		# perhaps doing nothing is the best thing to do
		@keyLayer?.y = 8 + (@app.windowFrame.y - @y)
		return

			
	_fitChildrenToPadding: (children) =>
		return if not @padding

		w = @width - @padding.right - @padding.left

		for child in children.added
			if child.x < @padding.left then child.x = @padding.left
			if child.y < @padding.top then child.y = @padding.top
			if child.width > w 
				Utils.delay 0, -> child.width = w

	# ---------------
	# Private Methods

	_loadView: (app, next, prev) =>
		try 
			return if @_initial and @preserveContent
			@load(app, next, prev)
			@_initial = true
		catch
			throw "View ('#{@title ? @name}') must have a working `load` property (a callback). If it does have one, there's an error in it!"
		@app.loading = false

		if @key
			@keyLayer = new TextLayer
				name: "Key: #{@key}"
				parent: @
				fontSize: 12
				fontWeight: 600
				y: 8
				width: @width
				textAlign: 'center'
				color: '#000'
				text: @key

	
	_unloadView: (app, next, prev, direction) =>
		try @unload(app, next, prev, direction)
		
		return if @preserveContent

		child.destroy() for child in _.without(@children, @content)
		child.destroy() for child in @content.children

		if @oneoff and direction is 'back'
			@destroy()
			return

	# ---------------
	# Public Methods
	

	refresh: (loadingTime) =>
		loadingTime ?= _.random(.3, .5)

		@app.loading = true
		@_unloadView()
		
		Utils.delay loadingTime, => @app.showNext(@)


	onLoad: (callback) -> 	
		@load = callback


	onUnload: (callback) -> 
		@unload = callback

	# ---------------
	# Special Definitions