module(..., package.seeall)



local TEXT_TMPL = [[<input type="text" name="${name}" value="${value}" class="${class}" ${id} /> ]]
text = function (args)
	local name = args.name or 'text'
	local class = args.class or name
	local value = args.value or ''
	local id = args.id
	
	local htmls = (TEXT_TMPL % { 
		name = name, 
		value = value, 
		class = class,
		id = id and format('id="%s"', id) or '' 
	})

	return htmls
end




local CHECKBOX_TMPL = [[<input type="checkbox" name="${name}" value="${value}" ${checked} class="${class}" ${id} />${caption} ]]
checkbox = function (args)
	local htmls = {}
	local name = args.name or 'checkbox'
	local class = args.class or name
	local value = args.value or {}
	local value_field = args.value_field
	local caption_field = args.caption_field
	local id = args.id

	local checked = args.checked or {}
	local checked_set, flag = false
	if type(checked) == 'table' then
		checked_set = Set(checked)
	end
	
	if value_field and caption_field then
		-- here, value is datasource
		for _, item in ipairs(value) do
			if type(checked) == 'string' then
				flag = checked == item[value_field]
			else
			 	flag = checked_set:has(item[value_field])
			end
		
			table.insert(htmls, (CHECKBOX_TMPL % { 
				id = id and format('id="%s"', id) or '',
				class = class,
				name = name,
				value = item[value_field], 
				caption = item[caption_field] or '',
				checked = flag and 'checked="checked"' or ''
			}))
		end
	else
		for _, item in ipairs(value) do
			
			if type(checked) == 'string' then
				flag = checked == item[1]
			else
			 	flag = checked_set:has(item[1])
			end
			table.insert(htmls, (CHECKBOX_TMPL % { 
				id = id and format('id="%s"', id) or '',
				name = name, 
				value = item[1], 
				class = class, 
				caption = item[2] or item[1] or '',
				checked = flag and 'checked="checked"' or ''
			}))
		end
	end

	return table.concat(htmls)
end

local RADIO_TMPL = [[<input type="radio" name="${name}" value="${value}" ${checked} class="${class}" ${id}/>${caption} ${layout}]]
radio = function (args)
	local htmls = {}
	local name = args.name or 'radio'
	local class = args.class or name
	local value = args.value or {}
	local checked = args.checked or ''
	local value_field = args.value_field
	local caption_field = args.caption_field
	local layout = args.layout or ''
	if layout == 'vertical' then
		layout="<br/>"
	end
		
	if value_field and caption_field then
		for _, item in ipairs(value) do
			table.insert(htmls, (RADIO_TMPL % { 
				id = id and format('id="%s"', id) or '',
				class = class,
				name = name,
				value = item[value_field], 
				caption = item[caption_field] or '',
				checked = (checked == item[value_field]) and 'checked="checked"' or '',
				layout = layout,
			}))
		end
	else
		for _, item in ipairs(value) do
			table.insert(htmls, (RADIO_TMPL % { 
				id = id and format('id="%s"', id) or '',
				name = name, 
				value = item[1], 
				class = class, 
				caption = item[2] or item[1] or'',
				checked = (checked == item[1]) and 'checked="checked"' or '',
				layout = layout,
			}))
		end
	end

	return table.concat(htmls)
end



local SELECT_TMPL0 = [[<select class="${class}" name="${name}" ${id}>]]
local SELECT_TMPL1 = [[<option value="${value}" ${selected}>${caption}</option>]]
local SELECT_TMPL2 = [[</select>]]
select = function (args)
	local htmls = {}
	local name = args.name or 'select'
	local class = args.class or name
	local value = args.value or {}
	local selected = args.selected or {}
	
	local value_field = args.value_field
	local caption_field = args.caption_field
	
	local selected_set
	local flag = false
	if type(selected) == 'table' then
		selected_set = Set(selected)
	end
	
	table.insert(htmls, SELECT_TMPL0 % {class=class, name=name, id=id and format('id="%s"', id) or ''})	
	local inval, incap

	-- if specify value field and caption field
	if value_field and caption_field then
		-- here, value is datasource
		for _, item in ipairs(value) do
			if type(selected) == 'string' then
				flag = selected == item[value_field]
			else
			 	flag = selected_set:has(item[value_field])
			end
		
			table.insert(htmls, (SELECT_TMPL1 % { 
				value = item[value_field], 
				caption = item[caption_field] or '',
				selected = flag and 'selected="selected"' or ''
			}))
		end
	else
		-- if not specify value field and caption field		
		for _, item in ipairs(value) do
		    if type(item) == 'string' then
			inval = item
			incap = item
		    else
			inval = item[1]
			incap = item[2] or inval
		    end
			
		    if type(selected) == 'string' then
			flag = selected == inval
		    else
			flag = selected_set:has(inval)
		    end
		    table.insert(htmls, (SELECT_TMPL1 % { 
		    	value = inval, 
			caption = incap,
			selected = flag and 'selected="selected"' or ''
		    }))
		end
	end
	table.insert(htmls, SELECT_TMPL2)

	return table.concat(htmls)
end



bamboo.WIDGETS['text'] = text
bamboo.WIDGETS['checkbox'] = checkbox
bamboo.WIDGETS['radio'] = radio
bamboo.WIDGETS['select'] = select
