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

function tmcall(::Op{:>}, args; alignat, kwargs...)
	if alignat(:>)
		return join(tm.(args; alignat=alignat, kwargs...), " &{}>{}& ")
	else
		return join(tm.(args; alignat=alignat, kwargs...), " > ")
	end
end

function tmcall(::Op{:<}, args; alignat, kwargs...)
	if alignat(:<)
		return join(tm.(args; alignat=alignat, kwargs...), " &{}<{}& ")
	else
		return join(tm.(args; alignat=alignat, kwargs...), " < ")
	end
end

function tmcall(::Op{:(>=)}, args; alignat, kwargs...)
	if alignat(:(>=))
		return join(tm.(args; alignat=alignat, kwargs...), " &{}\\geqslant{}& ")
	else
		return join(tm.(args; alignat=alignat, kwargs...), " \\geqslant ")
	end
end

function tmcall(::Op{:(<=)}, args; alignat, kwargs...)
	if alignat(:(<=))
		return join(tm.(args; alignat=alignat, kwargs...), " &{}\\leqslant{}& ")
	else
		return join(tm.(args; alignat=alignat, kwargs...), " \\leqslant ")
	end
end

function tmcall(::Op{:(==)}, args; alignat, kwargs...)
	if alignat(:(==))
		return join(tm.(args; alignat=alignat, kwargs...), " &{}={}& ")
	else
		return join(tm.(args; alignat=alignat, kwargs...), " = ")
	end
end

function tmcall(::Op{:!=}, args; alignat, kwargs...)
	if alignat(:!=)
		return join(tm.(args; alignat=alignat, kwargs...), " &{}\\ne{}& ")
	else
		return join(tm.(args; alignat=alignat, kwargs...), " \\ne ")
	end
end

function tmcall(::Op{:≈}, args; alignat, kwargs...)
	if alignat(:≈)
		return join(tm.(args; alignat=alignat, kwargs...), " &{}\\approx{}& ")
	else
		return join(tm.(args; alignat=alignat, kwargs...), " \\approx ")
	end
end

function tmcall(::Op{:≠}, args; alignat, kwargs...)
	if alignat(:≠)
		return join(tm.(args; alignat=alignat, kwargs...), " &{}\\ne{}& ")
	else
		return join(tm.(args; alignat=alignat, kwargs...), " \\ne ")
	end
end

tmcall(::Op{:∩}, args; kwargs...) = join(tm.(args; kwargs...), " \\cap ")
tmcall(::Op{:∪}, args; kwargs...) = join(tm.(args; kwargs...), " \\cup ")
tmcall(::Op{:∨}, args; kwargs...) = join(tm.(args; kwargs...), " \\vee ")
tmcall(::Op{:∧}, args; kwargs...) = join(tm.(args; kwargs...), " \\wedge ")
