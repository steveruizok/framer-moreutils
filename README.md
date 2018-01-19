# framer-moreutils

Expand Utils with some handy helper functions.

# Installation

## Manual Install
1. Download this repository
2. With your project open in Framer, drag the 'moreutils.coffee' file the code editor

## Install via Framer Modules.

[![Install with Framer Modules](https://www.framermodules.com/assets/badge.png)](https://open.framermodules.com/moreutils>)

# Usage

Framer uses an object called `Utils` to store common utility functions, such as `Utils.delay`. The moreutils module adds new methods to this `Utils` object, such as `Utils.align`.

<span style="font-size: 24px;">Utils.pin(layer, *targetLayer, directions, distance*)</span>

### Utils.unpin(layer, targetLayer, direction)

### Utils.constrain(layer, options, distance)

### Utils.build(target, function)

### Utils.align([layers], property, target, animate)

### Utils.distribute([layers], property, start, end, animate)

### Utils.grid([layers], cols, rowMargin, colMargin)

### Utils.makeGrid(layer, cols, rows, rowMargin, colMargin)

### Utils.fit(layer, [layers], property, padding)

### Utils.contain(layer, {padding})

### Utils.chainAnimations([animations], looping)