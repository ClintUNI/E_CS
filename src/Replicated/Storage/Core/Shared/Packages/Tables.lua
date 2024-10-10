local Tables = {}

function Tables.CopyTable(Table: {})
	local Array = {}
	
	for Idx, Value in Table do
		Array[Idx] = typeof(Value) == "table" and Tables.CopyTable(Value) or Value
	end
	
	return Array
end

function Tables.Reconcile(Table: {}, Template: {}, Silent: boolean?)
	Table = Silent and Tables.CopyTable(Table) or Table
	
	for Idx, Value in Template do
		if Table[Idx] then
			continue
		end
		
		Table[Idx] = typeof(Value) == "table" and Tables.CopyTable(Value) or Value
	end
	
	return Table
end


function Tables.CacheDirectory(Directory: Instance | Model | Folder, WrapperMethod)
	local Cache = {}
	
	for _, Obj in Directory:GetChildren() do
		local Module
		if Obj:IsA("ModuleScript") then
			Module = WrapperMethod and WrapperMethod(Obj) or require(Obj)
		end
		
		Cache[Obj.Name] = Module and Module or (Obj:IsA("Instance") or Obj:IsA("Model") or Obj:IsA("Folder")) and Tables.CacheDirectory(Obj, WrapperMethod) or nil
	end
	
	return Cache
end

function Tables.DeepCopy(original)
    local orig_type = type(original)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, original, nil do
            copy[Tables.DeepCopy(orig_key)] = Tables.DeepCopy(orig_value)
        end
        setmetatable(copy, Tables.DeepCopy(getmetatable(original)))
    else -- number, string, boolean, etc
        copy = original
    end
    return copy
end

function Tables.DeepCopyRecursive(original, copies)
    copies = copies or {}
    local original_type = type(original)
    local copy
    if original_type == 'table' then
        if copies[original] then
            copy = copies[original]
        else
            copy = {}
            copies[original] = copy
            for orig_key, orig_value in next, original, nil do
                copy[Tables.DeepCopyRecursive(orig_key, copies)] = Tables.DeepCopyRecursive(orig_value, copies)
            end
            setmetatable(copy, Tables.DeepCopyRecursive(getmetatable(original), copies))
        end
    else -- number, string, boolean, etc
        copy = original
    end
    return copy
end

return Tables