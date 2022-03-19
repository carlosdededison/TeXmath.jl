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

function tmcall(::Op{:lim}, args; alignat, kwargs...)
	if length(args) == 1
		opname = "\\lim "
	elseif length(args) == 2
		opname = "\\lim_{" *
			tm(args[2]; alignat=x->false, kwargs...) *
			"}"
	else
		throw(TooManyArgumentsError(2))
	end

	if args[1] isa Expr && parneeded(args[1])
		return opname * tm(:(par($(args[1]))); alignat=alignat, kwargs...)
	else
		return opname * tm(args[1]; alignat=alignat, kwargs...)
	end
end


function tmcall(::Op{:d}, args; kwargs...)
	if length(args) != 1
		throw(TooManyArgumentsError(1))
	end

	if args[1] isa Expr && parneeded(args[1])
		result = tm(:(par($(args[1]))); kwargs...)
	else
		result = tm(args[1]; kwargs...)
	end

	return "\\mathrm{d} $result"
end


function tmcall(::Op{:dot}, args; kwargs...)
	if length(args) != 1
		# dot product
		return join(tm.(args;kwargs...), " \\cdot ")
	end

	if args[1] isa Expr && parneeded(args[1])
		result = tm(:(par($(args[1]))); kwargs...)
	else
		result = tm(args[1]; kwargs...)
	end

	return "{\\dot{$result}}"
end


function tmcall(::Op{:diff}, args; kwargs...)
	if length(args) > 2
		throw(TooManyArgumentsError(2))
	elseif length(args) == 1
		if args[1] isa Expr && parneeded(args[1])
			result = tm(:(par($(args[1]))); kwargs...)
		else
			result = tm(args[1]; kwargs...)
		end
		return result * "^\\prime"
	end

	num = tm(:(d($(args[1]))); kwargs...)
	den = tm(:(d($(args[2]))); kwargs...)

	return "\\frac{$num}{$den}"
end

function tmcall(::Op{:int}, args; alignat, kwargs...)
	if length(args) == 1
		opname = "\\!\\int\\! "
		diferential = ""
	elseif length(args) == 2
		opname = "\\!\\int\\! "
	elseif length(args) == 4
		opname = "\\!\\int_{" *
			tm(args[3]; alignat=x->false, kwargs...) *
			"}^{" *
			tm(args[4]; alignat=x->false, kwargs...) *
			"}"
	else
		throw(TooManyArgumentsError(4))
	end

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(
				 :(par($(args[1]), left=L"\left[", right=L"\right]"));
				 alignat=alignat, kwargs...
				)
	else
		arg = tm(args[1]; alignat=alignat, kwargs...)
	end

	if length(args) != 1
		if args[2] isa Expr && args[2].head == :vect
			diferential = "\\,\\mathrm d " *
			join([tm(a; alignat=x->false, kwargs...) for a in args[2].args], "\\,\\mathrm d ")
		else
			try
				diferential = "\\,\\mathrm d " * tm(args[2]; alignat=x->false, kwargs...)
			catch
				throw(WrongArgumentTypeError())
			end
		end
	end

	return opname * arg * diferential
end


function tmcall(::Op{:∘}, args; kwargs...)
	return join(tm.(args;kwargs...), " \\circ ")
end


function tmcall(::Op{:sum}, args; kwargs...)
	# defaults:
	op = Dict(:sub => "",
			  :sup => "")

	println("AAAA")
	dump(args)
	println("AAAA")

	parameters  = filter(x -> x isa Expr && x.head == :kw, args)
	for p in parameters
		op[p.args[1]] = tm(p.args[2]; alignat=x->false, kwargs...)
	end

	args = filter(x ->!(x isa Expr && x.head == :kw), args)

	if length(args) > 3
		throw(TooManyArgumentsError(3))
	end

	return "\\operatorname*{\\sum}" *
		((length(args) < 2) ? "" : "_{$(tm(args[2]; alignat=x->false, kwargs...))}") *
		((length(args) < 3) ? "" : "^{$(tm(args[3]; alignat=x->false, kwargs...))}") *
		tm(args[1]; alignat=x->false, kwargs...) *
		(isempty(op[:sub]) ? "" : "_{$(op[:sub])}") *
		(isempty(op[:sup]) ? "" : "^{$(op[:sup])}")
end
