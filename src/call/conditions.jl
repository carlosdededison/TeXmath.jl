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

function tmcall(::Op{:iseven}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	return "\\text{" *
	       replace(lang[:iseven],
				   "%n"=>"\$"*tm(args[1]; kwargs...)*"\$") *
		   "}"
end


function tmcall(::Op{:isodd}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	return "\\text{" *
	       replace(lang[:isodd],
				   "%n"=>"\$"*tm(args[1]; kwargs...)*"\$") *
		   "}"
end
