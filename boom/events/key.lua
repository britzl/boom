local listener = require "boom.events.listener"

local M = {}

local key_pressed_listeners = {}
local key_released_listeners = {}

local ALL_KEYS = {
	[hash("key_space")] = true,
	[hash("key_exclamationmark")] = true,
	[hash("key_doublequote")] = true,
	[hash("key_hash")] = true,
	[hash("key_dollarsign")] = true,
	[hash("key_ampersand")] = true,
	[hash("key_singlequote")] = true,
	[hash("key_lparen")] = true,
	[hash("key_rparen")] = true,
	[hash("key_asterisk")] = true,
	[hash("key_plus")] = true,
	[hash("key_comma")] = true,
	[hash("key_minus")] = true,
	[hash("key_period")] = true,
	[hash("key_slash")] = true,
	[hash("key_0")] = true,
	[hash("key_1")] = true,
	[hash("key_2")] = true,
	[hash("key_3")] = true,
	[hash("key_4")] = true,
	[hash("key_5")] = true,
	[hash("key_6")] = true,
	[hash("key_7")] = true,
	[hash("key_8")] = true,
	[hash("key_9")] = true,
	[hash("key_colon")] = true,
	[hash("key_semicolon")] = true,
	[hash("key_lessthan")] = true,
	[hash("key_equals")] = true,
	[hash("key_greaterthan")] = true,
	[hash("key_questionmark")] = true,
	[hash("key_at")] = true,
	[hash("key_a")] = true,
	[hash("key_b")] = true,
	[hash("key_c")] = true,
	[hash("key_d")] = true,
	[hash("key_e")] = true,
	[hash("key_f")] = true,
	[hash("key_g")] = true,
	[hash("key_h")] = true,
	[hash("key_i")] = true,
	[hash("key_j")] = true,
	[hash("key_k")] = true,
	[hash("key_l")] = true,
	[hash("key_m")] = true,
	[hash("key_n")] = true,
	[hash("key_o")] = true,
	[hash("key_p")] = true,
	[hash("key_q")] = true,
	[hash("key_r")] = true,
	[hash("key_s")] = true,
	[hash("key_t")] = true,
	[hash("key_u")] = true,
	[hash("key_v")] = true,
	[hash("key_w")] = true,
	[hash("key_x")] = true,
	[hash("key_y")] = true,
	[hash("key_z")] = true,
	[hash("key_lbracket")] = true,
	[hash("key_rbracket")] = true,
	[hash("key_backslash")] = true,
	[hash("key_caret")] = true,
	[hash("key_underscore")] = true,
	[hash("key_grave")] = true,
	[hash("key_lbrace")] = true,
	[hash("key_rbrace")] = true,
	[hash("key_pipe")] = true,
	[hash("key_esc")] = true,
	[hash("key_f1")] = true,
	[hash("key_f2")] = true,
	[hash("key_f3")] = true,
	[hash("key_f4")] = true,
	[hash("key_f5")] = true,
	[hash("key_f6")] = true,
	[hash("key_f7")] = true,
	[hash("key_f8")] = true,
	[hash("key_f9")] = true,
	[hash("key_f10")] = true,
	[hash("key_f11")] = true,
	[hash("key_f12")] = true,
	[hash("key_up")] = true,
	[hash("key_down")] = true,
	[hash("key_left")] = true,
	[hash("key_right")] = true,
	[hash("key_lshift")] = true,
	[hash("key_rshift")] = true,
	[hash("key_lctrl")] = true,
	[hash("key_rctrl")] = true,
	[hash("key_lalt")] = true,
	[hash("key_ralt")] = true,
	[hash("key_tab")] = true,
	[hash("key_enter")] = true,
	[hash("key_backspace")] = true,
	[hash("key_insert")] = true,
	[hash("key_del")] = true,
	[hash("key_pageup")] = true,
	[hash("key_pagedown")] = true,
	[hash("key_home")] = true,
	[hash("key_end")] = true,
	[hash("key_numpad_0")] = true,
	[hash("key_numpad_1")] = true,
	[hash("key_numpad_2")] = true,
	[hash("key_numpad_3")] = true,
	[hash("key_numpad_4")] = true,
	[hash("key_numpad_5")] = true,
	[hash("key_numpad_6")] = true,
	[hash("key_numpad_7")] = true,
	[hash("key_numpad_8")] = true,
	[hash("key_numpad_9")] = true,
	[hash("key_numpad_divide")] = true,
	[hash("key_numpad_multiply")] = true,
	[hash("key_numpad_subtract")] = true,
	[hash("key_numpad_add")] = true,
	[hash("key_numpad_decimal")] = true,
	[hash("key_numpad_equal")] = true,
	[hash("key_numpad_enter")] = true,
	[hash("key_numpad_numlock")] = true,
	[hash("key_capslock")] = true,
	[hash("key_scrolllock")] = true,
	[hash("key_pause")] = true,
	[hash("key_lsuper")] = true,
	[hash("key_rsuper")] = true,
	[hash("key_menu")] = true,
	[hash("key_back")] = true,
}

local ANY_KEY = hash("*")

local keymap = {
	[ANY_KEY] = {
		pressed = false
	}
}
for key,_ in pairs(ALL_KEYS) do
	keymap[key] = {
		pressed = false
	}
end

--- Register callback that runs when a certain key is pressed.
-- @string key_id The key that must be pressed or nil for any key
-- @function cb The callback
-- @treturn function fn Cancel callback
function M.on_key_press(key_id, cb)
	if not cb then
		cb = key_id
		key_id = "*"
	end
	key_id = hash(key_id)
	local key = keymap[key_id]
	if not key then
		key = {}
		keymap[key_id] = key
	end
	return listener.register(key_pressed_listeners, key_id, cb)
end

--- Register callback that runs when a certain key is released.
-- @string key_id The key that must be released or nil for any key
-- @function cb The callback
-- @treturn function fn Cancel callback
function M.on_key_release(key_id, cb)
	if not cb then
		cb = key_id
		key_id = "*"
	end
	key_id = hash(key_id)
	local key = keymap[key_id]
	if not key then
		key = {}
		keymap[key_id] = key
	end
	return listener.register(key_released_listeners, key_id, cb)
end

--- Check if a certain key is down.
-- @string key_id The key that must be down, or nil for any key
-- @treturn bool down True if down
function M.is_key_down(key_id)
	key_id = key_id or "*"
	key_id = hash(key_id)
	local key = keymap[key_id]
	if not key then return false end
	return key.pressed
end

local function handle_input(action_id, action)
	local key = keymap[action_id]
	if key == nil then
		return
	end
	if action.pressed then
		key.pressed = true
		listener.trigger(key_pressed_listeners, action_id)
	elseif action.released then
		key.pressed = false
		listener.trigger(key_released_listeners, action_id)
	end
end

function M.__on_input(action_id, action)
	if action_id and ALL_KEYS[action_id] then
		handle_input(ANY_KEY, action)
		handle_input(action_id, action)
	end
end

function M.__destroy()
	key_pressed_listeners = {}
	key_released_listeners = {}
end

return M