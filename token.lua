local keywords = {
    "auto",
    "double",
    "int",
    "struct",
    "break",
    "else",
    "long",
    "switch",
    "case",
    "enum",
    "register",
    "typedef",
    "char",
    "extern",
    "return",
    "union",
    "const",
    "float",
    "short",
    "unsigned",
    "continue",
    "for",
    "signed",
    "void",
    "default",
    "goto",
    "sizeof",
    "volatile",
    "do",
    "if",
    "static",
    "while"
}

local fastOct = {}
local fastDec = {}
local fastHex = {}
local fastAlpha = {}
local fastAlphaUnder = {"_" = true}
local fastSeperator = {}

do
    local i = 48
    local v = 0
    local c
    while i <= 55 do
        c = string.char(i)
        fastOct[c] = v
        fastDec[c] = v
        fastHex[c] = v
        i = i + 1
        v = v + 1
    end
    while i <= 57 do
        c = string.char(i)
        fastDec[c] = v
        fastHex[c] = v
        i = i + 1
        v = v + 1
    end
    i = 65
    local c2
    while i <= 70 do
        c = string.char(i)
        c2 = string.char(i + 32)
        fastHex[c] = v
        fastHex[c2] = v
        fastAlpha[c] = true
        fastAlpha[c2] = true
        fastAlphaUnder[c] = true
        fastAlphaUnder[c2] = true
        i = i + 1
        v = v + 1
    end
    while i <= 90 do
        c = string.char(i)
        c2 = string.char(i + 32)
        fastAlpha[c] = true
        fastAlpha[c2] = true
        fastAlphaUnder[c] = true
        fastAlphaUnder[c2] = true
        i = i + 1
    end
end

local function startsWith(s1, s2)
    if (#s1 < #s2) or (s1 == s2) then
        return false
    end
    return string.sub(s1, 1, #s2) == s2
end

local function pullKeyword(str)
    for i=1, #keywords do
        if startsWith(str, keywords[i]) then
            return keywords[i]
        end
    end
    return
end

local function pull

local function pullIdentifier(str)
    local len = #str
    if len == 0 then
        return
    end
    local s1 = string.sub(str, 1, 1)
    if not fastAlphaUnder[s1] then
        return
    end
    local i = 2
    local c
    while i <= len do
        c = string.sub(str, i, i)
        if not (fastAlphaUnder[c] or fastDec[c]) then
            return string.sub(str, 1, i - 1)
        end
    end
    return str
end

local function tokenise(txt)
    local tokenList = {}
    while #txt > 0 do
        local v = pullKeyword(txt)
        if v then
            tokenList[#tokenList + 1] = {"key", v}
        else
            v = pull
