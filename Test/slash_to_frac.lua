local FRAC_CMDS = { frac = true, dfrac = true, tfrac = true, cfrac = true }

local function read_brace_group(s, i)
  local n = #s
  local depth, j = 0, i
  repeat
    local cj = s:sub(j,j)
    if cj == "{" then depth = depth + 1
    elseif cj == "}" then depth = depth - 1 end
    j = j + 1
    if j > n + 1 then return nil end
  until depth == 0
  return j
end

-- Does s consist of exactly one balanced "(...)" spanning its WHOLE length
-- (i.e. the "(" at position 1 is matched by the ")" at the very last
-- character, with nothing before or after)?  If so, return the inner text.
local function bare_paren_wrap(s)
  if s:sub(1,1) ~= "(" then return nil end
  local n = #s
  local depth, j = 0, 1
  repeat
    local cj = s:sub(j,j)
    if cj == "(" then depth = depth + 1
    elseif cj == ")" then depth = depth - 1 end
    if depth == 0 then
      if j == n then return s:sub(2, n - 1) else return nil end
    end
    j = j + 1
  until j > n
  return nil
end

local convert_math -- forward declaration (mutual recursion with simplify_term)

-- Given a term that is about to become a numerator/denominator, strip
-- redundant parentheses: a single "(...)" wrap is invisible (the \frac
-- bar already groups it); a doubled "((...))" wrap collapses to exactly
-- one visible pair (the user's way of asking for visible parentheses).
-- Any division found inside is converted too.  A leading "-" (from the
-- unary-minus-after-"/" rule) is preserved across the simplification.
local function simplify_term(term)
  local prefix = ""
  local body = term
  if body:sub(1,1) == "-" then prefix, body = "-", body:sub(2) end
  local inner = bare_paren_wrap(body)
  if not inner then return term end
  local layers = 1
  local core = inner
  while true do
    local deeper = bare_paren_wrap(core)
    if not deeper then break end
    layers = layers + 1
    core = deeper
  end
  local converted = convert_math(core)
  if layers >= 2 then
    return prefix .. "(" .. converted .. ")"
  else
    return prefix .. converted
  end
end

local function read_unit_forward(s, i)
  local n = #s
  local start = i
  local parts, tail
  local c = s:sub(i,i)
  if c == "(" then
    local depth, j = 0, i
    repeat
      local cj = s:sub(j,j)
      if cj == "(" then depth = depth + 1
      elseif cj == ")" then depth = depth - 1 end
      j = j + 1
      if j > n + 1 then break end
    until depth == 0
    if depth ~= 0 then return nil, start end
    i = j
    -- Parenthesized content is a unit at this level, but may itself contain
    -- fractions or other shorthand that needs conversion.
    parts = { "(", convert_math(s:sub(start + 1, j - 2)), ")" }
    tail = i
  elseif c == "\\" then
    local j = i + 1
    while s:sub(j,j):match("%a") do j = j + 1 end
    if j == i + 1 then return nil, start end
    local cmd = s:sub(i+1, j-1)
    i = j
    if FRAC_CMDS[cmd] then
      for _ = 1, 2 do
        if s:sub(i,i) == "{" then
          local ni = read_brace_group(s, i)
          if ni then i = ni end
        end
      end
    end
  elseif c:match("[%w%.]") then
    local j = i
    while s:sub(j,j):match("[%w%.]") do j = j + 1 end
    i = j
  else
    return nil, start
  end
  while true do
    local pc = s:sub(i,i)
    if pc == "^" or pc == "_" then
      local j = i + 1
      local nc = s:sub(j,j)
      if nc == "{" then
        local ni = read_brace_group(s, j)
        if not ni then break end
        -- Script groups are part of the unit for division parsing, but their
        -- math content still needs the same conversions (including \/).
        parts = parts or {}
        parts[#parts + 1] = s:sub(tail or start, j)
        parts[#parts + 1] = convert_math(s:sub(j + 1, ni - 2))
        parts[#parts + 1] = "}"
        tail = ni
        i = ni
      elseif nc == "\\" then
        local k = j + 1
        while s:sub(k,k):match("%a") do k = k + 1 end
        i = k
      elseif nc ~= "" then
        i = j + 1
      else
        break
      end
    else
      break
    end
  end
  if parts then
    parts[#parts + 1] = s:sub(tail, i - 1)
    return table.concat(parts), i
  end
  return s:sub(start, i - 1), i
end

convert_math = function(s)
  local out, i, n = {}, 1, #s
  while i <= n do
    -- Prefer the longest forms so, for example, "<-->" is not consumed as
    -- a left arrow followed by a stray "->".  This runs only on extracted
    -- math-mode content; text outside math is left unchanged by process_line.
    local arrow = nil
    local capital = s:sub(i, i)
    local is_double_capital = capital:match("%u")
      and s:sub(i + 1, i + 1) == capital
      and not s:sub(i - 1, i - 1):match("%a")
      and not s:sub(i + 2, i + 2):match("%a")
    if s:sub(i, i + 1) == "\\/" then
      -- An escaped slash is explicitly literal, not a fraction separator.
      arrow = "/"
      i = i + 2
    elseif is_double_capital then
      -- QQ, RR, CC, etc. are convenient shorthand for blackboard-bold sets.
      arrow = "\\mathbb{" .. capital .. "}"
      i = i + 2
    elseif s:sub(i, i + 3) == "<-->" then
      arrow = "\\longleftrightarrow"
      i = i + 4
    elseif s:sub(i, i + 3) == "<==>" then
      arrow = "\\Longleftrightarrow"
      i = i + 4
    elseif s:sub(i, i + 2) == "-->" then
      arrow = "\\longrightarrow"
      i = i + 3
    elseif s:sub(i, i + 2) == "<--" then
      arrow = "\\longleftarrow"
      i = i + 3
    elseif s:sub(i, i + 2) == "==>" then
      arrow = "\\Longrightarrow"
      i = i + 3
    elseif s:sub(i, i + 2) == "<==" then
      arrow = "\\Longleftarrow"
      i = i + 3
    elseif s:sub(i, i + 2) == "<->" then
      arrow = "\\leftrightarrow"
      i = i + 3
    elseif s:sub(i, i + 2) == "<=>" then
      arrow = "\\Leftrightarrow"
      i = i + 3
    -- TeX font declarations use range markers such as "<-6>" and
    -- "<8->".  They can be read while this callback's math state is active,
    -- so do not turn those markers into arrows.
    elseif s:sub(i, i + 1) == "->" and not s:sub(i - 1, i - 1):match("%d") then
      arrow = "\\to"
      i = i + 2
    elseif s:sub(i, i + 1) == "<-" and not s:sub(i + 2, i + 2):match("%d") then
      arrow = "\\leftarrow"
      i = i + 2
    elseif s:sub(i, i + 1) == "=>" then
      arrow = "\\Rightarrow"
      i = i + 2
    elseif s:sub(i, i + 1) == "<=" then
      arrow = "\\Leftarrow"
      i = i + 2
    end
    if arrow then
      out[#out+1] = arrow
    else
      local unit, ni = read_unit_forward(s, i)
      if unit then
        local terms, j = { unit }, ni
        while true do
          local k = j
          while s:sub(k,k) == " " do k = k + 1 end
          if s:sub(k,k) == "/" then
            local k2 = k + 1
            while s:sub(k2,k2) == " " do k2 = k2 + 1 end
            local neg = ""
            if s:sub(k2,k2) == "-" then
              neg = "-"; k2 = k2 + 1
              while s:sub(k2,k2) == " " do k2 = k2 + 1 end
            end
            local u2, nj = read_unit_forward(s, k2)
            if u2 then terms[#terms+1] = neg .. u2; j = nj else break end
          else break end
        end
        if #terms > 1 then
          for t = 1, #terms do terms[t] = simplify_term(terms[t]) end
          local result = terms[1]
          for t = 2, #terms do
            result = "\\frac{" .. result .. "}{" .. terms[t] .. "}"
          end
          out[#out+1] = result
        else
          out[#out+1] = unit
        end
        i = j
      else
        out[#out+1] = s:sub(i,i)
        i = i + 1
      end
    end
  end
  return table.concat(out)
end

-- ===================== line-level wrapper =====================
-- Persistent state across calls (i.e. across lines of the document).
-- Each math-mode span in a line is extracted whole and handed to
-- convert_math() in one call; text, comments and delimiters themselves
-- are copied through untouched.
local state = { math = false }

local function process_line(line)
	local out = {}
	local i, n = 1, #line
	local seg_start = state.math and 1 or nil

	local function flush(upto)
		if seg_start then
			out[#out + 1] = convert_math(line:sub(seg_start, upto - 1))
			seg_start = nil
		end
	end

	while i <= n do
		local c = line:sub(i, i)
		if c == "%" and line:sub(i - 1, i - 1) ~= "\\" then
			flush(i)
			out[#out + 1] = line:sub(i)
			i = n + 1
		elseif c == "$" then
			local two = line:sub(i, i + 1) == "$$"
			flush(i)
			out[#out + 1] = two and "$$" or "$"
			state.math = not state.math
			i = i + (two and 2 or 1)
			if state.math then seg_start = i end
		elseif c == "\\" and (line:sub(i + 1, i + 1) == "[" or line:sub(i + 1, i + 1) == "(") then
			flush(i)
			out[#out + 1] = line:sub(i, i + 1)
			state.math = true
			i = i + 2
			seg_start = i
		elseif c == "\\" and (line:sub(i + 1, i + 1) == "]" or line:sub(i + 1, i + 1) == ")") then
			flush(i)
			out[#out + 1] = line:sub(i, i + 1)
			state.math = false
			i = i + 2
		elseif seg_start then
			i = i + 1 -- accumulate; the actual parse happens once, on flush
		else
			out[#out + 1] = c
			i = i + 1
		end
	end
	flush(i) -- flush a trailing math segment that continues onto the next line

	return table.concat(out)
end

luatexbase.add_to_callback(
	"process_input_buffer",
	process_line,
	"slash_to_frac"
)
