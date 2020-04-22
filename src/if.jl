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

function tmif(ex::Expr; lang=TM_LANG_EN, kwargs...)
	function recurse_elif(expr::Expr)
		if expr.head == :block # is `else`.
			return tm(expr; lang=lang, kwargs...) *
			       "&\\text{$(lang[:otherwise])}"
		end

		condition = tm(expr.args[1]; lang=lang, kwargs...)
		value = tm(expr.args[2]; lang=lang, kwargs...) 
		next = if length(expr.args) == 3 &&
		          expr.args[3] isa Expr
			recurse_elif(expr.args[3])
		else "" end

		return value * "&\\text{$(lang[:if])~~}" *
		       condition * "\\\\\n" * next
	end

	result = "\\left\\{\\begin{array}{rl}\n"
	
	#	result *= tm(args[2]; lang=lang, kwargs...) *
	#          " & \\text{$(lang[:if])~~} " *
	#          tm(args[1]; lang=lang, kwargs...)
	

	result *= recurse_elif(ex)
	
	result *= "\n\\end{array}\\right."

	return result
end
