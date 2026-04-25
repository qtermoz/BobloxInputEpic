local InputService = game:GetService("UserInputService")

type input = Enum.KeyCode | Enum.UserInputType

local InputManager = {}
local InputConnections : {[input] : {began : {RBXScriptConnection}, ended : {RBXScriptConnection}}} = {}


function InputManager.ConnectToKeyCodeBegan(
	input : Enum.KeyCode,
	func : (any) -> (),
	ignoreGPE : boolean?,
	...
)

	local args = {...}

	if type(InputConnections[input]) ~= "table" then
		InputConnections[input] = {}
	end

	if type(InputConnections[input]["began"]) ~= "table" then
		InputConnections[input]["began"] = {}
	end

	local connection = InputService.InputBegan:Connect(function(_input, gpe)

		if _input.KeyCode ~= input then
			return
		end

		if ignoreGPE and gpe or ignoreGPE == nil and gpe then
			return
		end

		func(unpack(args))

	end)

	table.insert(InputConnections[input]["began"], connection)
	return connection

end

function InputManager.ConnectToKeyCodeEnded(
	input : Enum.KeyCode,
	func : (any) -> (),
	ignoreGPE : boolean?,
	...
)

	local args = {...}

	if type(InputConnections[input]) ~= "table" then
		InputConnections[input] = {}
	end

	if type(InputConnections[input]["ended"]) ~= "table" then
		InputConnections[input]["ended"] = {}
	end

	local connection = InputService.InputEnded:Connect(function(_input, gpe)

		if _input.KeyCode ~= input then
			return
		end

		if ignoreGPE and gpe or ignoreGPE == nil and gpe then
			return
		end

		func(unpack(args))

	end)

	table.insert(InputConnections[input]["ended"], connection)
	return connection

end

function InputManager.ConnectToInputTypeEnded(
	input : Enum.UserInputType,
	func : (any) -> (),
	ignoreGPE : boolean?,
	...
)

	local args = {...}
	
	if type(InputConnections[input]) ~= "table" then
		InputConnections[input] = {}
	end

	if type(InputConnections[input]["ended"]) ~= "table" then
		InputConnections[input]["ended"] = {}
	end

	local connection = InputService.InputEnded:Connect(function(_input, gpe)

		if _input.UserInputType ~= input then
			return
		end

		if ignoreGPE and gpe or ignoreGPE == nil and gpe then
			return
		end

		func(unpack(args))

	end)

	table.insert(InputConnections[input]["ended"], connection)
	return connection
	
end

function InputManager.ConnectToInputTypeBegan(
	input : Enum.UserInputType,
	func : (any) -> (),
	ignoreGPE : boolean?,
	...
)

	local args = {...}

	if type(InputConnections[input]) ~= "table" then
		InputConnections[input] = {}
	end

	if type(InputConnections[input]["began"]) ~= "table" then
		InputConnections[input]["began"] = {}
	end

	local connection = InputService.InputBegan:Connect(function(_input, gpe)

		if _input.UserInputType ~= input then
			return
		end

		if ignoreGPE and gpe or ignoreGPE == nil and gpe then
			return
		end

		func(unpack(args))

	end)

	table.insert(InputConnections[input]["began"], connection)
	return connection

end

function InputManager.Disconnect(toDisconnect : RBXScriptConnection)

	for inputObj, connList in InputConnections do

		for _, connections in connList do

			for idx, connection in connections do

				if connection == toDisconnect then
						
					connection:Disconnect()
					table.remove(connections, idx)
					return
					
				end

			end

		end
	
	end

end

function InputManager.DisconnectAllForInput(input : input)

	if InputConnections[input] ~= nil then
		
		for state, connections in InputConnections[input] do
			for idx, connection in connections :: {RBXScriptConnection} do
				connection:Disconnect()
			end
		end
		
		table.clear(InputConnections[input])
	end

end

function InputManager.ReturnInputConnections()
	return InputConnections
end


return InputManager 

------------------------------- /// A LIL GUIDE \\\ -------------------------------

--[[

    METHODS:
    	
    	WARNING : GPE is slang for GameProcessedEvent
    	(you might not understand it beacause you're not a 10x engineer like me)
    
        .ConnectToKeyCodeBegan(
            input - an Enum.KeyCode value
            func - function to run when this key begins
            ignoreGPE - true or nil ignores game processed events
                      - false allows game processed events
            ... - extra values passed to func

            returns the RBXScriptConnection
        )

        .ConnectToKeyCodeEnded(
            input - an Enum.KeyCode value
            func - function to run when this key ends
            ignoreGPE - true or nil ignores game processed events
                      - false allows game processed events
            ... - extra values passed to func

            returns the RBXScriptConnection
        )

        .ConnectToInputTypeBegan(
            input - an Enum.UserInputType value
            func - function to run when this input type begins
            ignoreGPE - true or nil ignores game processed events
                      - false allows game processed events
            ... - extra values passed to func

            returns the RBXScriptConnection
        )

        .ConnectToInputTypeEnded(
            input - an Enum.UserInputType value
            func - function to run when this input type ends
            ignoreGPE - true or nil ignores game processed events
                      - false allows game processed events
            ... - extra values passed to func

            returns the RBXScriptConnection
        )

        .Disconnect(
            conn - RBXScriptConnection returned by one of the connect methods
        )

        .DisconnectAllForInput(
            input - Enum.KeyCode or Enum.UserInputType value to disconnect all began and ended connections for
        )

        .ReturnInputConnections() - returns the input connections table
]]

