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

# + - * / // \ ±

function tmcall(::Op{:+}, args; alignat=x->false, kwargs...)
	if alignat(:+)
		return join(tm.(args; alignat=alignat, kwargs...), " &{}+{}& ")
	else
		return join(tm.(args; kwargs...), " + ")
	end
end


function tmcall(::Op{:-}, args; alignat=x->false, kwargs...)
	if length(args) == 1 # negative number
		return " -" * tm(args[1])
	else # subtraction
		if alignat(:-)
			return join(tm.(args; alignat=alignat, kwargs...), " &{}-{}& ")
		else
			return join(tm.(args; kwargs...), " - ")
		end
	end
end


function tmcall(::Op{:±}, args; alignat=x->false, kwargs...)
	if alignat(:±)
		return join(tm.(args; alignat=alignat, kwargs...), " &{}\\pm{}& ")
	else
		return join(tm.(args; kwargs...), " \\pm ")
	end
end


function tmcall(::Op{:*}, args; kwargs...)
	function term(x)
		if x isa Symbol &&
			( length(string(x)) == 1 ||
			  string(x) in keys(name_symbols) )
			return true
		elseif x isa Expr &&
			x.args[1] == :^ &&
			( length(string(x.args[2])) == 1 ||
			  string(x.args[2]) in keys(name_symbols) ) ||
			x isa Expr && startswith(string(x), "u\"") # unit declaration
			return true
		else return false end
	end

	if args[1] isa Real &&
		all(term, args[2:end]) ||
		all(term, args) ||
		(length(args) == 2 &&
			args[1] isa Real &&
			args[end] isa Expr &&
			args[end].head == :macrocall)
		return join(tm.(args; kwargs...), "\\,")
	end

	tmp_args = Vector()
	for a in args # check if parenthesis are needed
		if ( a isa Expr && a.head == :call &&
			 a.args[1] in [ :+, :+, :-, :- ]
		   ) || a isa Real && a < 0

			push!(tmp_args, :(par($a)))
		else
			push!(tmp_args, a)
		end
	end

	return join(tm.(tmp_args; kwargs...), " \\cdot ")
end

function tmcall(::Op{:times}, args; kwargs...)
	tmp_args = Vector()
	for a in args # check if parenthesis are needed
		if ( a isa Expr && a.head == :call &&
			 a.args[1] in [ :+, :+, :-, :- ]
		   ) || a isa Real && a < 0

			push!(tmp_args, :(par($a)))
		else
			push!(tmp_args, a)
		end
	end

	return join(tm.(tmp_args; kwargs...), " \\times ")
end

function tmcall(::Op{:/}, args; kwargs...)
	if length(args) != 2 throw(TooManyArgumentsError(2)) end
	return "\\frac{" *
		tm(args[1]; kwargs...) * "}{" *
		tm(args[2]; kwargs...) * "}"
end
tmcall(::Op{://}, args; kwargs...) = tmcall(Op(:/), args; kwargs...)
tmcall(::Op{:\}, args; kwargs...) = tmcall(Op(:/), reverse(args); kwargs...)


function tmcall(::Op{:^}, args; kwargs...)
	if length(args) != 2 throw(TooManyArgumentsError(2)) end
	
	if args[1] isa Expr && args[1].head != :ref
		args[1] = :(par($(args[1])))
	end

	return "{" *
		tm(args[1]; kwargs...) * "}^{" *
		tm(args[2]; kwargs...) * "}"
end


function tmcall(::Op{:sqrt}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	
	return "\\sqrt{$(tm(args[1]; kwargs...))}"
end


function tmcall(::Op{:cbrt}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	
	return "\\sqrt[3]{$(tm(args[1]; kwargs...))}"
end


function tmcall(::Op{:nthroot}, args; kwargs...)
	if length(args) != 2 throw(TooManyArgumentsError(2)) end

	return "\\sqrt[" * tm(args[1]; kwargs...) *
		"]{" * tm(args[2]; kwargs...) * "}"
end
