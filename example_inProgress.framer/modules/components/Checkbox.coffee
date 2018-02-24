Theme = require "components/Theme"
theme = undefined

MODEL = 'checkbox'

class exports.Checkbox extends Layer
	constructor: (options = {}) ->
		theme = Theme.theme
		@__constructor = true
		@__instancing = true

		# ---------------
		# Options

		_.defaults options,
			name: 'Checkbox'
			height: 32
			width: 32
			animationOptions:
				time: .2
				colorModel: 'husl'

			checked: false
			disabled: false

		_.assign options,
			backgroundColor: null

		@customOptions = {
			color: options.color
		}

		super options

		@props =
			x: @x - 4
			y: @y - 4

		# ---------------
		# Layers
		
		@iconLayer = new Icon
			name: "Icon"
			parent: @
			point: Align.center
			icon: 'checkbox-blank-outline'
			color: options.color

		Utils.linkProperties @, @iconLayer, "color"

		# ---------------
		# Events

		@onTap => @checked = !@checked
		@onMouseOver => @hovered = true
		@onMouseOut => @hovered = false

		# ---------------
		# Definitions
		
		delete @__constructor
		
		Utils.define @, 'theme', 'default', @_setTheme
		Utils.define @, 'checked', options.checked, @_showChecked, _.isBoolean, 'Checkbox.checked must be a boolean (true or false)'
		Utils.define @, 'hovered', false, @_showHovered, _.isBoolean, "Checkbox.hovered must be a boolean (true or false)."
		Utils.define @, 'error', options.disabled, @_showError, _.isBoolean, "Checkbox.error must be a boolean (true or false)."
		Utils.define @, 'disabled', options.disabled, @_showDisabled, _.isBoolean, "Checkbox.disabled must be a boolean (true or false)."
		
		delete @__instancing

		# ---------------
		# Cleanup
		
		child.name = '.' for child in @children unless options.showSublayers

	# ---------------
	# Private Methods

	_getCustomTheme: (color, backgroundColor) ->
		return {
			default:
				color: black
				borderColor: new Color(backgroundColor).darken(10)
				backgroundColor: backgroundColor
				shadowColor: 'rgba(0,0,0,.16)'
			disabled:
				color: new Color(color).alpha(.15)
				borderColor: new Color(color).alpha(.15)
				backgroundColor: new Color(backgroundColor).alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: black
				borderColor: new Color(backgroundColor).darken(20)
				backgroundColor: new Color(backgroundColor).darken(10)
				shadowColor: 'rgba(0,0,0,.16)'
			}

	_setTheme: (value) =>
		@animateStop()
		props = @customTheme?[value] ? _.defaults(
			_.clone(@customOptions), 
			theme[MODEL][value]
			)

		if @__instancing then @props = props 
		else @animate props

	_showChecked: (bool) =>
		if not bool
			@iconLayer.icon = 'checkbox-blank-outline'
			return

		@iconLayer.icon = 'checkbox-marked'
		return

	_showError: (bool) =>
		return if @disabled
		@theme = if bool then "error" else "default"

	_showHovered: (bool) =>
		return if @disabled
		@theme = if bool then "hovered" else "default"

	_showDisabled: (bool) =>
		if bool
			# show disabled
			@theme = 'disabled'
			@ignoreEvents = true
			return

		# show not disabled
		@theme = 'default'
		@ignoreEvents = false

	# ---------------
	# Public Methods


	# ---------------
	# Special Definitions