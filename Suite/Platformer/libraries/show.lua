--[[
   Author: Julio Manuel Fernandez-Diaz
   Date:   January 12, 2007
   (For Lua 5.1)
   Modified slightly by RiciLake to avoid the unnecessary table traversal in tablecount()
   Formats tables with cycles recursively to any depth.
   The output is returned as a string.
   References to other tables are shown as values.
   Self references are indicated.
   The string returned is "Lua code", which can be procesed
   (in the case in which indent is composed by spaces or "--").
   Userdata and function keys and values are shown as strings,
   which logically are exactly not equivalent to the original code.
   This routine can serve for pretty formating tables with
   proper indentations, apart from printing them:
      print(table.show(t, "t"))   -- a typical use
   Heavily based on "Saving tables with cycles", PIL2, p. 113.
   Arguments:
      t is the table.
      name is the name of the table (optional)
      indent is a first indentation (optional).
--]]

function table.show(t, name, indent)
    local cart     -- a container
    local autoref  -- for self references
 
    -- returns true if the table is empty
    local function isemptytable(t) return next(t) == nil end
 
    local function basicSerialize (o)
       local so = tostring(o)
       if type(o) == "function" then
          local info = debug.getinfo(o, "S")
          if info.what == "C" then
             return string.format("%q", so .. ", C function")
          else
             return string.format("%q", so .. ", defined in (" ..
                 info.linedefined .. "-" .. info.lastlinedefined ..
                 ")" .. info.source)
          end
       elseif type(o) == "number" or type(o) == "boolean" then
          return so
       else
          return string.format("%q", so)
       end
    end
 
    local function addtocart (value, name, indent, saved, field)
       indent = indent or ""
       saved = saved or {}
       field = field or name
 
       cart = cart .. indent .. field
 
       if type(value) ~= "table" then
          cart = cart .. " = " .. basicSerialize(value) .. ";\n"
       else
          if saved[value] then
             cart = cart .. " = {}; -- " .. saved[value]
                         .. " (self reference)\n"
             autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
          else
             saved[value] = name
             if isemptytable(value) then
                cart = cart .. " = {};\n"
             else
                cart = cart .. " = {\n"
                for k, v in pairs(value) do
                   k = basicSerialize(k)
                   local fname = string.format("%s[%s]", name, k)
                   field = string.format("[%s]", k)
                   addtocart(v, fname, indent .. "   ", saved, field)
                end
                cart = cart .. indent .. "};\n"
             end
          end
       end
    end
 
    name = name or "__unnamed__"
    if type(t) ~= "table" then
       return name .. " = " .. basicSerialize(t)
    end
    cart, autoref = "", ""
    addtocart(t, name, indent)
    return cart .. autoref
end

-- Return the show function for require()
local show = table.show
return show
