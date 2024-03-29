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

# fallback, mhchem, exact, ...

function tmcall(op::Op, args; kwargs...)
	opname = tm(Op(op)) 

	length(opname) > 1 &&
		!(opname[2:end] in values(unicode_symbols)) &&
		@info("Function `$(Op(op))()` was used, but is unknown")

	if length(opname) == 1 || opname[2:end] in values(unicode_symbols)
		return opname * "\\mathopen{}\\left(" *
			join(tm.(args; kwargs...), ", ") * "\\right)\\mathclose{}"
	else
		return "\\operatorname{" *
			opname * "}\\mathopen{}\\left(" *
			join(tm.(args; kwargs...), ", ") * "\\right)\\mathclose{}"
	end
end


function tmcall(::Op{:(=>)}, args; alignat, kwargs...)
	if alignat(:(=>))
		return join(tm.(args; alignat=alignat, kwargs...), " &{}\\rightarrow{}& ")
	else
		return join(tm.(args; alignat=alignat, kwargs...), " \\rightarrow ")
	end
end


function tmcall(::Op{:(∝)}, args; alignat, kwargs...)
	if alignat(:(∝))
		return join(tm.(args; alignat=alignat, kwargs...), " &{}\\propto{}& ")
	else
		return join(tm.(args; alignat=alignat, kwargs...), " \\propto ")
	end
end


function tmcall(::Op{:c}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	return "\\ce{" *
		filter(c->!isspace(c)&&c != '_', string(args[1])) *
		"}"
end


function tmcall(::Op{:ang}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	return "\\hat{$(tm(args[1]; kwargs...))}"
end


function tmcall(::Op{:vec}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	return "\\vec{$(tm(args[1]; kwargs...))}"
end


function tmcall(::Op{:bar}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	return "\\bar{$(tm(args[1]; kwargs...))}"
end


function tmcall(::Op{:under}, args; kwargs...)
	if length(args) != 2 throw(TooManyArgumentsError(2)) end
	return "\\underbrace{$(tm(args[1]; kwargs...))}_{$(tm(args[2]; kwargs...))}"
end


function tmcall(::Op{:&}, args; kwargs...)
	return join(tm.(args; kwargs...), "\\,")
end


function tmcall(::Op{:dots}, args; kwargs...)
	if length(args) != 0 throw(TooManyArgumentsError(0)) end
	return "\\dots "
end


function tmcall(::Op{:|}, args; alignat, kwargs...)
	return join(tm.(args; alignat=alignat, kwargs...), "&&")
end


function tmcall(::Op{:|>}, args; kwargs...)
	return join(tm.(args; kwargs...), " \\,\\triangleright ")
end

function tmcall(::Op{:bb}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	return "\\mathbb{" * tm(args[1]; kwargs...) * "}"
end


function tmcall(::Op{:det}, args; kwargs...)
	function array_render(arr::Array)
		lines = String[]

		for i in 1:size(arr, 1)
			row = arr[i,:]
			push!(lines, join(tm.(row; alignat=x->false, kwargs...), " & "))
		end

		return "\\left[\\begin{array}{c}\n\t" *
		join(lines, "\\\\[1ex]\n\t") *
		"\n\\end{array}\\right]"
	end

	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	if args[1] isa Symbol
		return "\\operatorname{det}(" * tm(args[1]; kwargs...) * ")"
	elseif args[1] isa Expr && args[1].head == :vcat
		array = getfield(Main, Symbol(args[1].head))(args[1].args)
		return "\\left\\lvert" * array_render(array) * "\\right\\rvert"
	else
		error("Wrong type on det() operator")
	end
end
