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


function tmcomp(args::Vector{Any}; alignat, kwargs...)
	symbols = Dict{Symbol, String}(
		:>    => ">",
		:<    => "<",
		:(>=) => "\\geqslant",
		:(<=) => "\\leqslant",
		:(==) => "=",
		:!=   => "\\ne",
		:≈    => "\\approx",
		:≠    => "\\ne",
	)

	iter = Iterators.Stateful(args)
	result::String = tm(popfirst!(iter); kwargs...)

	while !isempty(iter)
		op = popfirst!(iter)
		if alignat(op)
			result *= " &{}" * symbols[op] * " "
		else
			result *= " " * symbols[op] * " "
		end

		result *= tm(popfirst!(iter); kwargs...)
	end

	return result
end
