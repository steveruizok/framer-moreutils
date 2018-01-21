# framer-moreutils

Super handy helper functions for your Framer projects.

**[Pin](#Utils.pin(layer,-[targetLayer,-directions,-distance]))** Fix a layer's position relative to another layer

**[Unpin](#Utils.unpin(layer,-[targetLayer,-direction]))**: Remove a layer's pin relationship

**[Constrain](#Utils.constrain(layer,-constraints...))**: Set a layer's constraints, relative to its parent

**Align**: Set all layers in an array to the same property value

**Distribute**: Evenly distribute properties to layers in an array

**Fit**: Set a layer's property to the max property among a group of layers

**Contain**: Set a layer's spatial properties to contain its children.

**Grid**: Set layers into a grid of rows and columns

**MakeGrid**: Create a grid of copies from a layer

**ChainAnimations**: Set an array of Animations to each start when the previous ends

**PointInPolygon**: Check whether a point is within any straight-sided polygon

**LayerAtPoint**: Get the top-most layer at a given point

**LayersAtPoint**: Get all layers at a given point

**GetLayerFromElement**: Get which (if any) Layer owns a given element

**Bind**: Bind a function to a target

**Define**: Create a new layer property that emits an event when it changes



# Installation

## Manual Install
1. Download this repository
2. With your project open in Framer, drag the 'moreutils.coffee' file the code editor

## Install via Framer Modules.

[![Install with Framer Modules](https://www.framermodules.com/assets/badge.png)](https://open.framermodules.com/moreutils>)

# Usage

Framer uses an object called `Utils` to store common utility functions, such as `Utils.delay`. The moreutils module adds new methods to this `Utils` object, such as `Utils.align`.

Once the module has been installed, you can use these methods in your code the same way you would a standard Utils method. For example,  `Utils.align(myLayers, 'x', '100')`. Each method works is documented in the section below.

# Methods 

In the documentation below, arguments between brackets are optional. For example, **Utils.chainAnimations** takes two arguments: an array of layers and a boolean (true or false) for whether or not the chain should loop. The second argument is set to `true` by default, so your calls to  only have to provide this element when you want to the chain *not* to loop — or if you're feeling verbose. Either way, because the method will work without the second argument, we document it as **Utils.chainAnimations(layers, [animate])**, with brackets to show that the animate argument is optional.

### Utils.pin(layer, targetLayer, directions...)

Fixes **layerA**'s position relative to **layerB**. If layerB ever moves or changes, layerA will move with it in order to preserve this position. For the **directions** argument, you may use one or more directions: `'left'`, `'right'`, `'top'` or `'bottom'`). 

If multiple pins conflict, such as a pin to the `'top', 'bottom'`, only the last pin will get used.  This method accepts up to two **directions** arguments.

```coffeescript 
Utils.pin(layerA, layerB, 'left')
Utils.pin(layerA, layerB, 'left', 'top')
```
### Utils.unpin(layer, [targetLayer, direction])

Removes **layerA**'s pin relationships. If the optional argument with **layerB** is provided, only those relationships with **layerB** will be removed; likewise, if **layerA** has multiple pins to **layerB**, the **directions** argument can be used to remove specific pins.

```coffeescript 
Utils.pin(layerA, layerB, 'left', 'top')
Utils.pin(layerA, layerC, 'left')

Utils.unpin(layerA) 
# removes all of layerA's pins, both to layerB and layerC

Utils.unpin(layerA, layerB) 
# removes only layerA's pins to layerB
# layerA is still pinned to layerC

Utils.unpin(layerA, layerB, 'left')
# removes only layerA's left pin to layerB
# layerA is still pinned to layerB's top
```
### Utils.constrain(layer, constraints...)

Set a **layer**'s constraints, relative to its parent. This works the same as setting constraints in Design mode, where a **layer** may be constrained by one or more **constraints**. These are its parent's edges (`left`, `top`, `right`, `bottom`) or its parent's dimensions (`height`, `width`) and it may be set to preserve its `aspectRatio` as well. This method accepts as many **constraints** arguments as needed. 

When the parent layer changes its dimensions, the constrained layer may also transform, depending on the **constraints** set. Need a visual? Check out [this interactive example](https://framer.cloud/hCMbD).

```coffeescript
Utils.constrain(layerA, 'height')
Utils.constrain(layerA, 'height', 'left', 'aspectRatio')
```

#### Utils.bind(target, function)

#### Utils.align([layers], property, target, animate)

#### Utils.distribute(layers, property, start, end, animate)

#### Utils.grid(layers, [cols, rowMargin, colMargin])

#### Utils.makeGrid(layer, cols, [rows, rowMargin, colMargin])

#### Utils.fit(layer, layers, property, [padding])

#### Utils.contain(layer, [padding])

#### Utils.chainAnimations(animations, [looping])

#### Utils.pointInPolygon: (point, vertices)

#### Utils.getLayerAtPoint: (point, vertices)

#### Utils.getLayersAtPoint: (point, [layers])

#### Utils.getLayerFromElement: (element, [layers])