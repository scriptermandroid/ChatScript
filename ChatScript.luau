local textbox = script.Parent.ImageLabel.TextBox
local UIS = game:GetService("UserInputService")
local intextbox = false
local TextChatService = game:GetService("TextChatService")
local textChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")


local function replace_char_table(str, index, replacement)
	local t = {}
	
	for i = 1, #str do
		t[i] = str:sub(i, i)
	end

	
	t[index] = replacement

	
	return table.concat(t)
end



--[[function processText(txt)
	local findasterisk = string.find(txt, "*", 1, true)
	local newstring = txt
	if findasterisk ~= nil then
		local finda2 = string.find(txt, "*", findasterisk+2, true)
		newstring = txt:gsub("*", "<b>", 1) 
		newstring = newstring:gsub("*", "</b>", 1)
		print(newstring)
	end
	return newstring
end]]



local message = "Hello, world!"


textbox.FocusLost:Connect(function(enter, input)
	if enter then
		print('enter pressed')
		textbox.RichText = true
--		local send = processText(textbox.Text)
		textChannel:SendAsync(textbox.Text)
		textbox.Text = ""

	end
end)


local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local TARGET_USER_ID = 792994343 

TextChatService.OnIncomingMessage = function(message: TextChatMessage)
	local properties = Instance.new("TextChatMessageProperties")
	local txt = message.Text
	properties.Text = txt
	
	-- Verify the message is sent by a player
	local findasterisk, ea = string.find(txt, "*", 1, true) --findasterisk will contain the index of the first asterisk
	local newstring = txt
	local finda2
	local lastasteriskindex -- this will contain the index of the last asterisk
	
	local newindex
	
	local italics1
	local bold1
	local italics2
	local bold2
	
	local tablenum = 1
	local txttable = {}
	local endstring = ""
	
	while findasterisk ~= nil do
		if findasterisk ~= nil then
			italics1 = true
			bold1 = false
			newindex = findasterisk + 1
			if string.sub(txt, findasterisk+1, findasterisk+1) == "*" then
				bold1 = true
				italics1 = false
				newindex = findasterisk + 2

				if string.sub(txt, findasterisk+2, findasterisk+2) == "*" then
					bold1 = true
					italics1 = true
					newindex = findasterisk + 3
				end
			end
		end
		--possible if newindex ~= nil then
		finda2 = string.find(txt, "*", newindex, true)
		
		if finda2 ~= nil then
			italics2 = true
			bold2 = false
			lastasteriskindex = finda2
			if string.sub(txt, finda2+1, finda2+1) == "*" then
				bold2 = true
				italics2 = false
				lastasteriskindex = finda2 + 1
				if string.sub(txt, finda2+2, finda2+2) == "*" then
					bold2 = true
					italics2 = true
					lastasteriskindex = finda2 + 2
				end
			end
		end
		
		if italics1 and italics2 and not (bold1 and bold2) then
			newstring = replace_char_table(txt, findasterisk, "<i>")
			newstring = replace_char_table(newstring, lastasteriskindex+2, "</i>") --+2 accounts for index increase due to replacement
			
			txttable[tablenum] = string.sub(newstring, 1, (lastasteriskindex+5))
			txt = string.sub(newstring, (lastasteriskindex+6))
		elseif bold1 and bold2 and not (italics1 and italics2) then
			newstring = replace_char_table(txt, findasterisk, "")			
			newstring = replace_char_table(newstring, findasterisk, "<b>") -- removing the first asterisk makes the second asterisk have the index of the first
			
			--** > <b> so the two below this are +1 to account for displacement
			
			newstring = replace_char_table(newstring, lastasteriskindex+1, "")
			newstring = replace_char_table(newstring, lastasteriskindex, "</b>") --removing the second asterisk at the end does not change the index of the first asterisk at the end, so you replace the first end asterisk with the bold
			
			txttable[tablenum] = string.sub(newstring, 1, (lastasteriskindex+3))
			txt = string.sub(newstring, (lastasteriskindex+4))
		elseif italics1 and bold1 and italics2 and bold2 then
			newstring = replace_char_table(txt, findasterisk, "")			
			newstring = replace_char_table(newstring, findasterisk, "")			
			newstring = replace_char_table(newstring, findasterisk, "<i><b>")	
			--displacement of 3, so +3
			newstring = replace_char_table(newstring, lastasteriskindex+3, "")
			newstring = replace_char_table(newstring, lastasteriskindex+2, "")
			newstring = replace_char_table(newstring, lastasteriskindex+1, "</b></i>")
			
			txttable[tablenum] = string.sub(newstring, 1, (lastasteriskindex+8))
			txt = string.sub(newstring, (lastasteriskindex+9))
		elseif findasterisk ~= nil then
			txttable[tablenum] = string.sub(txt, 1, (findasterisk))
			txt = string.sub(txt, (findasterisk+1))
		end
			--newstring = txt:gsub("*", "<i>", 1) 	
			--newstring = newstring:gsub("*", "</i>", 1)
			
		--if finda2 ~= nil then
		--		if finda2 ~= findasterisk+1 then
		--			newstring = txt:gsub("*", "<i>", 1) 
		--			newstring = newstring:gsub("*", "</i>", 1)
		--			print(newstring)
		--		end
		--	end
		--end
		--findasterisk = string.find(PLACEHOLDER, "*", 1, true)
		findasterisk, ea = string.find(txt, "*", 1, true)
		tablenum = tablenum +1
		task.wait(0.1)
		--print(txttable)
		--print(newstring)
		print(txt)
		
		italics1 = false
		italics2 = false
		bold1 = false
		bold2 = false
	end --after this loop finishes concat everything in the table of strings cut off back together to recreate the original message in edited form
	
	
			--local originalText = message.Text

			-- EXAMPLE 1: Automatically bolding specific words (e.g., bolds the word "IMPORTANT")
			--local formattedText = string.gsub(originalText, "IMPORTANT", "<b>IMPORTANT</b>")

			-- EXAMPLE 2: Let the player choose what to bold using custom characters (e.g., *this text* bolds)
			-- formattedText = string.gsub(formattedText, "%*(.-)%*", "<b>%1</b>")
	endstring = table.concat(txttable)
	endstring = endstring..txt
	properties.Text = endstring
	
	

	return properties
end

