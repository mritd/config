--[[
Conky Widgets by londonali1010 (2009)

This script is meant to be a "shell" to hold a suite of widgets for use in Conky.

To configure:
+ Copy the widget's code block (will be framed by --(( WIDGET NAME )) and --(( END WIDGET NAME )), with "[" instead of "(") somewhere between "require 'cairo'" and "function conky_widgets()", ensuring not to paste into another widget's code block
+ To call the widget, add the following between "cr = cairo_create(cs)" and "cairo_destroy(cr)" at the end of the script:
	NAME_OF_FUNCTION(cr, OPTIONS)
+ Replace OPTIONS with the options for your widget (should be specified in the widget's code block) 

Call this script in Conky using the following before TEXT (assuming you save this script to ~/scripts/conky_widgets.lua):
	lua_load ~/scripts/conky_widgets.lua
	lua_draw_hook_pre widgets
	
Changelog:
+ v1.1 -- Simplified calls to widgets by implementing a global drawing surface, and included imlib2 by default (03.11.2009)
+ v1.0 -- Original release (17.10.2009)
]]

require 'cairo'
require 'imlib2'

function conky_widgets()
	if conky_window == nil then return end
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
	cr = cairo_create(cs)
	
	cairo_destroy(cr)
end
