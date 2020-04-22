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

function tmcall(::Op{:∘}, args; kwargs...)
	return join(tm.(args;kwargs...), " \\circ ")
end
