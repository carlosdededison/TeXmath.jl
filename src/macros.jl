# TeXmath: convert Julia Expr into LaTeX syntax
# Copyright (C) 2020 Carlos André Bohn Brandt
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


function tmmacro(op::Op, args; kwargs...)
	tm.(Base.eval(Main, Expr(Op(op), args...)); kwargs...)
end


VARS = Dict{Symbol, Any}()

function clearvars()
	global VARS = Dict{Symbol, Any}()
end

function tmmacro(::Op{Symbol("@show")}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	if args[1] in VARS |> keys
		return tm(:($(args[1]) == $(VARS[args[1]])))
	end

	return tm(:($(args[1]) == $(Base.eval(Main, args[1]))))
end


function tmmacro(::Op{Symbol("@let")}, args; alignat, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	if args[1] isa Expr && args[1].head == :(=)
		global VARS
		try
			var   = args[1].args[1]
			value = Base.eval(Main, args[1])

			if value isa Number ||
				value * 1 isa Number # Unitful FreeUnits
				push!(VARS, var=>value)
			end
		catch e
		end

		if alignat(:(=))
			return "% LET\n" * replace(tm(args[1]; alignat=x->false, kwargs...), '='=>"&=", count=1)
		else
			return "% LET\n" * tm(args[1]; alignat=x->false, kwargs...)
		end
	else
		error("Must use assignment operator (=)!")
	end
end


function tmmacro(::Op{Symbol("@subs")}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	if !(args[1] isa Expr || args[1] isa Symbol )
		error("@subs $(repr(args)): Must be a Expression!") end

	function recursive_subs(ex)
		if ex isa Symbol
			if args[1] in VARS |> keys return VARS[ex] end
			try
				value = Base.eval(Main, ex)
				if value isa Function return ex end
				return value
			catch e
				return ex
			end
		elseif ex isa Expr && ex.head == :call
			return Expr(:call, ex.args[1],
						map(recursive_subs, ex.args[2:end])...)
		elseif ex isa Expr && ex.head == :(=)
			return Expr(:(=), map(recursive_subs, ex.args)...)
		else
			return ex
		end
	end

	resultexpr = recursive_subs(args[1])

	try
		result = Base.eval(resultexpr)
		return tm(resultexpr; kwargs...) * " = " * tm(result;kwargs...)
	catch e end

	return tm(resultexpr; kwargs...)
end
