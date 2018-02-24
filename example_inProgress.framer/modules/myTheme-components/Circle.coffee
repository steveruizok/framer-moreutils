class exports.Circle extends Layer
	constructor: (options = {}) ->
		theme = Theme.theme

		_.defaults options,
			name: 'Circle'
			width: 100
			height: 100
			borderRadius: 50

		super options