require 'framework'


# Setup
{ theme } = require 'components/Theme' # not usually needed

Canvas.backgroundColor = bg3
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

# ----------------
# App

app = new App

# Utils View

Content = (parent) ->
	s = new Separator
		parent: parent
		x: 0
		width: 100
	s.width = parent.width
	
	return new Layer
		parent: parent
		width: 312
		x: 16
		backgroundColor: null

# Utils Home

utilsView = new View
	title: 'Utils'
	contentInset:
		bottom: 200
				
utilsView.onLoad ->
	Utils.bind @content, ->
			
		title = new H3
			parent: @
			x: 16
			text: "Utils"
			
		body = new Body
			parent: @
			x: 16
			y: title.maxY + 16
			width: @width - 32
			text: "The **moreutils** module installs several new utilities. See below for documentation, or check the `moreutils.coffee` file for more documentation."
			
		Utils.toMarkdown(body)
		
		# text
		s = new Separator
			parent: @
			x: 0
			y: body.maxY + 32
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Text"
		
		new H4Link
			parent: @
			x: 16
			text: "Utils.toMarkdown"
			color: yellow80
			select: -> app.showNext(toMarkdownView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.randomText"
			color: yellow80
			select: -> app.showNext(randomTextView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.isEmail"
			color: yellow80
			select: -> app.showNext(isEmailView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.copyTextToClipboard"
			color: yellow80
			select: -> app.showNext(copyTextView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.getOrdinal"
			color: black
		
		# relationships
		s = new Separator
			parent: @
			x: 0
			y: body.maxY + 32
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Relationships"
			padding: {top: 16}
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.constrain"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.pin"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.unpin"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.pinOriginX"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.pinOriginY"
			color: black
		
		# positioning
		s = new Separator
			parent: @
			x: 0
			y: body.maxY + 32
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Positioning"
			padding: {top: 16}
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.distribute"
			color: yellow80
			select: -> app.showNext(distributeView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.align"
			color: yellow80
			select: -> app.showNext(alignView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.hug"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.contain"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.offsetX"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.offsetY"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.grid"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.makeGrid"
			color: black
			
		# layers
		s = new Separator
			parent: @
			x: 0
			y: body.maxY + 32
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Layers"
			padding: {top: 16}
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.pointInLayer"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.getLayerAtPoint"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.getLayersAtPoint"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.getLayerFromElement"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.pointInLayer"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.chainAnimations"
			color: black
			
		# properties
		s = new Separator
			parent: @
			x: 0
			y: body.maxY + 32
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Properties"
			padding: {top: 16}
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.define"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.linkProperties"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.setAttributes"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.px"
			color: black
			
		# data
		s = new Separator
			parent: @
			x: 0
			y: body.maxY + 32
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Data"
			padding: {top: 16}
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.CORSproxy"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.fetch"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.fetchJSON"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.timer"
			color: black
			
		Utils.offsetY(@children[2...])
				
	@updateContent()





		
	

# Utils.toMarkdown View

toMarkdownView = new View
	title: 'Utils.toMarkdown'
	contentInset:
		bottom: 200

toMarkdownView.onLoad ->
	Utils.bind @content, ->
		# -----------------
		# Utils.toMarkdown
		
		title = new H4
			name: 'Title'
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.toMarkdown**(textLayer)"
		
		Utils.toMarkdown(title)
		
		body = new Body2
			parent: @
			x: 16
			width: @width - 32
			text: "Utils.toMarkdown will convert some basic markdown syntax into inline styles. It works with bold, italic, strike-thru, and code tags.\n\nIf it's not working, try `Utils.delay 0, -> Utils.toMarkdown(textLayer)`."
			padding: {bottom: 16}
		
		Utils.toMarkdown(body)
		
		# examples
		
		content = new Content(@)
		
		new Label
			parent: content
			text: "Example_0"
			
		body = new Body
			parent: content
			x: 16
			text: "This is a **bold** and ***italic*** sentence."
			
		new Label
			parent: content
			text: "Example_1"
			
		body1 = new Body
			parent: content
			x: 16
			text: "This is a **bold** and ***italic*** sentence."
			
		Utils.offsetY(content.children)
		Utils.contain(content)
		
		Utils.toMarkdown(body1)
		
		new DocComponent
			parent: @
			text: [
				"Utils.toMarkdown(Example_1)"
				]
				
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

# Utils.distribute View

distributeView = new View
	title: 'Utils.distribute'
	contentInset:
		bottom: 200

distributeView.onLoad ->
	Utils.bind @content, ->
		# -----------------
		# Utils.distribute
			
	
		dtitle = new H4
			name: 'Title'
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.distribute**(layers, direction, [start], [end], [animate], [animationOptions])"
		
		Utils.delay 0, -> Utils.toMarkdown(dtitle)
		
		body = new Body2
			parent: @
			x: 16
			width: @width - 32
			text: "Utils.distrubute works the same way as the Distribute tools in Sketch or Framer's Design Mode. Give it an array of layers and a property (like 'x'), and it will try to evenly distribute the layers between the minimum and maximum values among the layers. You can also include values for where to start and where to end, and optionally animate the transition. The method includes alias names for 'midX' ('horizontal') and 'midY' ('vertical')."
			padding: {bottom: 16}
		
		# horizontal
		
		content = new Content(@)
			
		layers = _.range(10).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
		
		Utils.distribute(layers, 'horizontal', 16, 312)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.distribute("
				"layers,", 
				"'horizontal',", 
				"16,", 
				"312"
				")"
				]
		
		# color
		
		content = new Content(@)
			
		layers = _.range(10).map (l, i) ->
			new Layer
				parent: content
				size: 32
				x: i * 32
				backgroundColor: blue
				borderRadius: 16
		
		Utils.distribute(layers, 'hueRotate', 0, 180)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.distribute("
				"layers,", 
				"'hueRotate',", 
				"0,", 
				"180"
				")"
				]
				
		# animated
		
		content = new Content(@)
				
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
		
		Utils.distribute(layers, 'horizontal', 16, 312, true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.distribute("
				"layers,", 
				"'horizontal',", 
				"16,", 
				"312",
				"true",
				"{time: 1, looping: true}"
				")"
				]
				
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

# Utils.align View

alignView = new View
	title: 'Utils.align'
	contentInset:
		bottom: 200

alignView.onLoad ->
	Utils.bind @content, ->
		# -----------------
		# Utils.align
			
	
		title = new H4
			name: 'Title'
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.align**(layers, direction, [animate, [animationOptions]])"
		
		Utils.delay 0, -> Utils.toMarkdown(title)
	
		body = new Body2
			parent: @
			x: 16
			width: @width - 32
			text: "Utils.Align works the same way the Align tools work in Sketch or Design Mode. Give it an array of layers and a direction ('top', 'bottom', 'middle', 'left', 'right', or 'center'), and it will set the layers to the correct minimum or maximum among those layers."
			padding: {bottom: 16}
		
		# left
		
		content = new Content(@)
				
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
# 				y: _.random(24, 128)
		
		Utils.align(layers, 'left', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'left'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		
		# right
		
		content = new Content(@)
		
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
		
		Utils.align(layers, 'right', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'right'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		# middle
		
		content = new Content(@)
		
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
				y: _.random(24, 128)
		
		Utils.align(layers, 'middle', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'middle'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		# top
		
		content = new Content(@)
		
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
				y: _.random(24, 128)
		
		Utils.align(layers, 'top', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'top'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		# bottom
		
		content = new Content(@)
		
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
				y: _.random(24, 128)
		
		Utils.align(layers, 'bottom', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'bottom'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		# center
		
		content = new Content(@)
		
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
				y: _.random(24, 128)
		
		Utils.align(layers, 'center', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'center'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

# Utils.randomText View

randomTextView = new View
	title: 'Utils.randomText'
	contentInset:
		bottom: 200

randomTextView.onLoad ->
	Utils.bind @content, ->
	
		title = new H4
			name: 'Title'
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.randomText**(words, [sentences = false, [paragraphs = false]])"
		
		Utils.toMarkdown(title)
		
		body = new Body2
			parent: @
			x: 16
			width: @width - 32
			text: "Utils.randomText will generate *n* words of lorem ipsum text. By default, the string will be lower case words separated by a space, but you can return sentences or paragraphs as well."
			padding: {bottom: 16}
		
		Utils.toMarkdown(body)
				
		# words
		
		content = new Content(@)
		
		textLayer = new Body1
			parent: content
			text: Utils.randomText(16)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"textLayer = new Body2"
				"text: Utils.randomText(16)",
				]
		
		# sentences
		
		content = new Content(@)
		
		textLayer = new Body1
			parent: content
			text: Utils.randomText(16, true)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"textLayer = new Body2"
				"text: Utils.randomText(16, true)",
				]
		
		# paragraphs
		
		content = new Content(@)
		
		textLayer = new Body1
			parent: content
			text: Utils.randomText(48, true, true)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"textLayer = new Body2"
				"text: Utils.randomText(16, true, true)",
				]
		
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

# Utils.isEmail View

isEmailView = new View
	title: 'Utils.isEmail'
	contentInset:
		bottom: 200

isEmailView.onLoad ->
	Utils.bind @content, ->
	
		title = new H4
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.isEmail**(string)"
		
		Utils.toMarkdown(title)
		
		body = new Body2
			parent: @
			x: 16
			width: @width - 32
			text: "Utils.isEmail will return `true` if the string is a valid email address, or `false` if it isn't. This works well with an TextInput's 'change:value' event:"
		
		code = new Code
			parent: @
			text: "input.onChange 'value', (value) ->\n\tbutton.disabled = !Utils.isEmail(value)"
			padding: {bottom: 16}
		
		Utils.toMarkdown(body)
		
		# validEmail
		
		content = new Content(@)
		
		input = new TextInput
			parent: content
			value: 'stevecase@aol.com'
		
		button = new Button
			parent: content
			text: 'Submit'
			disabled: !Utils.isEmail(input.value)
		
		input.onChange "value", (value) -> button.disabled = !Utils.isEmail(value)
		
		Utils.offsetY(content.children, 8)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"new Button"
				"text: 'submit'"
				"disabled: !Utils.isEmail(input.value)"
				]
		
		# invalidEmail
		
		content = new Content(@)
		
		input1 = new TextInput
			parent: content
			value: 'stevecase@aol.c0m'
		
		button1 = new Button
			parent: content
			text: 'Submit'
			disabled: !Utils.isEmail(input1.value)
		
		input1.onChange "value", (value) -> button1.disabled = !Utils.isEmail(value)
		
		Utils.offsetY(content.children, 8)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"new Button"
				"text: 'submit'"
				"disabled: !Utils.isEmail(input.value)"
				]
		
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

# Utils.copyTextToClipboard View

copyTextView = new View
	title: 'Utils.copyTextToClipboard'
	contentInset:
		bottom: 200

copyTextView.onLoad ->
	Utils.bind @content, ->
	
		title = new H4
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.copyTextToClipboard**(string)"
		
		Utils.toMarkdown(title)
		
		body = new Body2
			parent: @
			x: 16
			width: @width - 32
			text: "Utils.copyTextToClipboard will copy a given string to the user's clipboard, as if the user had selected the text and pressed Command + C."
			padding: {bottom: 16}
		
		Utils.toMarkdown(body)
		
		# invalidEmail
		
		content = new Content(@)
		
		input = new TextInput
			parent: content
			value: 'This text will get copied to the clipboard.'
		
		button1 = new Button
			parent: content
			text: 'Copy to Clipboard'
			select: -> Utils.copyTextToClipboard(input.value)
			
		Utils.offsetY(content.children, 8)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"new Button"
				"text: 'Copy to Clipboard'"
				"select: ->\n\t\ttext = input.value \n\t\tUtils.copyTextToClipboard(text)"
				]
		
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

app.showNext(utilsView)

