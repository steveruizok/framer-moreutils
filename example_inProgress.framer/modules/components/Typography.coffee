Theme = require "components/Theme"
theme = Theme.theme

{ Link } = require 'components/Link'
framework = require 'framework'

updateTypography = ->
	for className, style of theme.typography
		do (className, style) =>

			window[className] = class FrameworkComponent extends TextLayer 
				constructor: (options = {}) ->
					@app = framework.app

					theme = Theme.theme 

					_.defaults options, theme.typography[className]
					_.defaults options, theme.typography[style.style]


					super options

			window[className + 'Link'] = class FrameworkComponent extends Link 
				constructor: (options = {}) ->
					@app = framework.app

					theme = Theme.theme 

					_.defaults options, theme.typography[className]
					_.defaults options, theme.typography[style.style]


					super options

exports.updateTypography = updateTypography
updateTypography()