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


function tmref(args::Vector; kwargs...)
    if length(args) == 2
        return "{$(tm(args[1]; kwargs...))}_{$(tm(args[2]; kwargs...))}"
	elseif all(x->x isa Symbol && length("$x") == 1, args)
        return "{$(tm(args[1]; kwargs...))}_{$(join(tm.(args[2:end]; kwargs...)))}"
    elseif any(x->x isa AbstractFloat, args)
        return "{$(tm(args[1]; kwargs...))}_{$(join(tm.(args[2:end]; kwargs...), "; "))}"
    else
        return "{$(tm(args[1]; kwargs...))}_{$(join(tm.(args[2:end]; kwargs...), ",\\ "))}"
    end
end
