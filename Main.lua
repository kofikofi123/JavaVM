

function JVM(bytecode)
	local bitwise = require("Bitwise") -- For of
	local java = require("Java")
	local stack = require("Stack")
	local frame = require("Frame")
	
	local function code_wrap(block)
	  
		local m = {
			Stack = stack(true, 0), --jvm method/interface stack, not operand stack
			Run = function(self, ...)
				local arguments = {...}
				
			end,
			Debugger = {
				Block = block,
				GetMethods = function(self)
					local b = self.Block 
					
					local cp = b.constant_pool 
					local methods = b.methods
					local results = {}
					
					table.foreach(methods, function(a, b)
						local temp = {}
						temp[1] = java.JParser.UTF8(cp[b[2]])
						temp[2] = java.JParser.UTF8(cp[b[3]])
							
						results[#results + 1] = temp
					end)
					
					return results
				end,
				GetMethod = function(self, method_name)
					local block = self.Block
					local cpool = block.constant_pool
					local methods  = block.methods 

					return java.Parser.GetMethod(cpool, methods, method_name)
				end,
				GetAttribute = function(self, attribute_info, attribute_name)
					local block = self.Block
					local cpool = block.constant_pool

					return java.Parser.GetAttribute(cpool, attribute_info, attribute_name)
				end
			}
		}
		
		return m
	end
	
	
	return code_wrap(java.Blockify(bytecode))
	
end

--commentmeant


return JVM