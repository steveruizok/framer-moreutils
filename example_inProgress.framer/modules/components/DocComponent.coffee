class exports.DocComponent extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options
		
		_.defaults options,
			name: "Documentation"
			backgroundColor: null
			color: black
			x: 16
			width: Screen.width - 32
			text: [
				"new Component"
				"status: {status}"
				]
			template: {}
		
		super options

		# ---------------
		# Layers
		
		if typeof options.text is 'string' then options.text = [options.text]
		
		@codeBlock = new Code
			name: 'Label'
			parent: @
			x: 0
			y: 0
			text: options.text.join('\n\t')
			color: @color
		
		Utils.toMarkdown(@codeBlock)
		
		template = {}
		formatter = {}
		
		_.entries(options.template).forEach (pair) =>
			key = pair[0]
			options = pair[1]
			layer = options[0]
			property = options[1]
			format = options[2]
			
			template[key] = layer[property]
			formatter[key] = format
			
			layer.onChange property, (value) =>
				@codeBlock.template = {"#{key}": value}
				@height = _.maxBy(@children, 'maxY')?.maxY
			
		@codeBlock.templateFormatter = formatter
		@codeBlock.template = template
			
		@copyIcon = new Icon
			name: 'Copy Icon'
			parent: @
			y: 0
			x: Align.right(-8)
			icon: 'content-copy'
			color: grey
			
		@copyLabel = new Label
			name: 'Copy Label'
			parent: @
			y: @copyIcon.maxY
			x: Align.right()
			text: 'COPY'
			color: grey
			
		@copyIcon.midX = @copyLabel.midX

		# ---------------
		# Cleanup
		
		child.name = '.' for child in @children unless options.showSublayers

		# ---------------
		# Definitions
			
		# ---------------
		# Events
		
		@copyIcon.onTap => 
			Utils.copyTextToClipboard(@codeBlock.text)
			
			@codeBlock.animate
				color: blue
				options: { time: .1 }
					
			Utils.delay .1, =>
				@codeBlock.animate
					color: @color
					options: { time: .5 }
					
		@height = _.maxBy(@children, 'maxY')?.maxY