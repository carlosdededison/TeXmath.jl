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

function parneeded(ex)
	if ex isa Expr
		args = ex.args
		if ex.head != :call
			return true
		elseif args[1] in [ :/, ://, :./, :(.//),
						    :par, :abs, :ceil, :floor ]
			return false
		elseif args[1] == :* &&
			   (args[2] isa Number &&
				all(x-> ( x isa Symbol && length(string(x)) == 1 ) ||
						( x isa Expr && x.args[1] == :^ &&
						  length(string(x.args[2])) == 1 ),
				args[3:end])) ||
				all(x-> ( x isa Symbol && length(string(x)) == 1 ) ||
						( x isa Expr && x.args[1] == :^ &&
						  length(string(x.args[2])) == 1 ),
				args[2:end])
			return false
		elseif ex.args[1] == :^ &&
			   length(string(args[2])) == 1
			return false
		else
			return true
		end
	elseif ex isa Number || ex isa Symbol
		return false
	end
end


function tmcall(::Op{:par}, args; alignat, kwargs...)
	# defaults:
	op = Dict(:left => "\\mathopen{}\\left(",
			   :right => "\\right)\\mathclose{}",
			   :sub => "",
			   :sup => "")

	normal_args = filter(x ->!(x isa Expr && x.head == :kw), args)

	parameters  = filter(x -> x isa Expr && x.head == :kw, args)
	for p in parameters
		op[p.args[1]] = tm(p.args[2]; alignat=x->false, kwargs...)
	end

	return op[:left] *
		join(tm.(normal_args; alignat=x->false, kwargs...), ", ") *
		op[:right] *
		(isempty(op[:sub]) ? "" : "_{$(op[:sub])}") *
		(isempty(op[:sup]) ? "" : "^{$(op[:sup])}")
end


function tmcall(::Op{:ceil}, args; kwargs...)
	return "~\\mathopen{}\\left\\lceil\\," *
		join(texmath.(args;kwargs...), ", ") *
		"\\,\\right\\rceil\\mathclose{}~"
end


function tmcall(::Op{:floor}, args; kwargs...)
	return "~\\mathopen{}\\left\\lfloor\\," *
		join(texmath.(args;kwargs...), ", ") *
		"\\,\\right\\rfloor\\mathclose{}~"
end


function tmcall(::Op{:abs}, args; kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end

	if opin(:abs, args[1])
		return "~\\mathopen{}\\left\\lvert\\left(\\," *
			texmath(args[1];kwargs...) *
			"\\,\\right)\\right\\rvert\\mathclose{}~"
	else
		return "\\mathopen{}\\left\\lvert\\," *
			texmath(args[1];kwargs...) *
			"\\,\\right\\rvert\\mathclose{}"
	end
end
