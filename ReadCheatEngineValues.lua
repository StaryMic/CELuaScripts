function readFile(a,b)local c=io.open(a,'r')if not c then return false end;local d=c:read('*all')c:close()if b then local e,f={},0;for g in d:gmatch('[^\n]+')do e[#e+1]=g end;return function()f=f+1;return e[f]end end;return d end
function writeFile(a,b,c)if type(b)=='string'then local d=c and'a'or'w'local e=io.open(a,d)e:write(b)e:close()return true end;return false end


local filePath = [[PUT FILE PATH HERE]]               -- path or file name. Keep the brackets if youre using "\" in your path
local previousValue
local addressToRead = 0x[[ADDRESS_GOES_HERE]] -- Remove "[[]]" and replace with the value's address

function readValue(self)
    local currentValue = math.ceil(readFloat(addressToRead)); -- Change to readFloat(addressToRead) if you do not need the value rounded up.
    if (not currentValue) then
        return self.destroy() -- destroys the timer
    end
    if (not previousValue) then                           -- no valid value; maybe a new instance of the script or so
        local fileContent = readFile(filePath);
        previousValue = tonumber(fileContent) or currentValue    -- assuming we store in plain file the hp value or a string representing player has died.
    end
    if (previousValue ~= currentValue) then                  -- a change has been detected;
        -- print('Value has changed',currentValue); [DEBUG STUFF]
        if (currentValue <= 0) then
            writeFile(filePath,"Player has died.")            -- 3rd parameter is to append it to file;
            -- self.enabled = false;                     -- disable timer as player has died;
        else                                       -- if previousValue is bigger than 0
            writeFile(filePath,tostring(currentValue))         -- writes current health
        end
        previousValue = currentValue; -- update it in any case;
    end
end

healthTimer = (healthTimer and healthTimer.destroy()) or createTimer(getMainForm()); --destroys the previous ones
healthTimer.Interval = 5000;                            -- 5 sec;
healthTimer.onTimer = readValue; -- this is the function above (readValue)
