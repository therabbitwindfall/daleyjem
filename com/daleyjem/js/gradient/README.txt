Apply a Top-Bottom or Left-Right gradient (with or without alpha transparency)

by attaching a "gradient" class to any HTML element. Does not interfere with existing classes

on element.
	
	


========
Usage:

========

<div class="some_existing_class gradient(#rrggbb[aa], #rrggbb[aa][, gradient_direction])">Some Text</div>


	@param	color1 = hex rgba color value (alpha hex value optional)

	@param	color2 = hex rgba color value (alpha hex value optional)

	@param	gradient_direction = (optional) linear direction of gradient transition ("tb" or "lr").
				     defaults to "tb" if not specified



========
Example:
========

gradient(#ffffffff, #00000000, tb)

	-> Applies a Top-Bottom gradient with the first color value

	   a full-opacity white, and the second color value

	   a full-transparency black
