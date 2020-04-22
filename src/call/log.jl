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

function tmcall(::Op{:log}, args; kwargs...)
	if length(args) == 1
		opname = "\\operatorname{ln} "
	elseif length(args) == 2
		opname = "\\operatorname{log_{$(tm(args[1]; kwargs...))}} "
	else
		throw(TooManyArgumentsError(2))
	end

	if args[end] isa Expr && isoneterm(args)
		arg = tm(args[end]; kwargs...)
	else
		arg = tm(:(par($(args[end]))); kwargs...)
	end

	return opname * arg 
end


function tmcall(::Op{:log2}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{log_2} " * arg 
end


function tmcall(::Op{:log10}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{log_{10}} " * arg 
end


function tmcall(::Op{:exp}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	if args[1] == 1
		return "\\mathrm{e}"
	else
		return "\\mathrm{e}^{$(tm(args[1];kwargs...))}"
	end
end
