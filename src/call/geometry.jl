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


function tmcall(::Op{:perp}, args; kwargs...)
	return join(tm.(args;kwargs...), " \\perp ")
end

function tmcall(::Op{:parallel}, args; kwargs...)
	return join(tm.(args;kwargs...), " \\parallel ")
end

function tmcall(::Op{:proj}, args; kwargs...)
	if length(args) == 2
		opname = "\\operatorname{proj_{$(tm(args[1]; kwargs...))}} "
	else
		throw(TooManyArgumentsError(2))
	end

	if args[end] isa Expr && parneeded(args[end])
		arg = tm(:(par($(args[end]))); kwargs...)
	else
		arg = tm(args[end]; kwargs...)
	end

	return opname * arg 
end
