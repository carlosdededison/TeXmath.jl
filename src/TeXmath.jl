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

module TeXmath
export texmath, texmath_align, TM_LANG_PT, TM_LANG_EN
using Requires

struct Op{T} end
Op(s::Symbol) = Op{s}()
Op(o::Op{T}) where T = T
opin(o::Symbol, ex::Expr) = any(x -> opin(o, x) , ex.args)
opin(o::Symbol, ex) = ex == o

include("lang.jl")
include("call.jl")
include("comp.jl")
include("error.jl")
include("if.jl")
include("macros.jl")
include("ref.jl")
include("symbol.jl")
include("types.jl")

function __init__()
	@require Unitful="1986cc42-f94f-5a68-af5c-568840ba703d" include("units.jl")
	@require SymPy="24249f21-da20-56a4-8eb1-6a02cf4ae2e6" include("sympy.jl")
end


function tm(ex::Expr; alignat=x->false, kwargs...)
	if ex.head == :call
		return tmcall(Op(ex.args[1]), ex.args[2:end];
			          alignat=alignat, kwargs...)
	elseif ex.head == :ref
		return tmref(ex.args; kwargs...)
	elseif ex.head == :comparison
		return tmcomp(ex.args; alignat=alignat, kwargs...)
	elseif ex.head == :block
		return tm(ex.args[2]; alignat=alignat, kwargs...)
	elseif ex.head == :(=)
		return tmcall(Op(:(==)), ex.args; alignat=alignat, kwargs...)
	elseif ex.head == :vect
		return tm(Vector{Any}(ex.args))
	elseif ex.head == :quote
		if length(ex.args) == 1
			return tm(ex.args[1]; kwargs...)
		end
	elseif ex.head in [:hcat, :vcat, :cat, :hvcat]
		return tm(getfield(Main, Symbol(ex.head))(ex.args); alignat=alignat, kwargs...)
	elseif ex.head == :if
		return tmif(ex; kwargs...)
	elseif ex.head == :toplevel
		return join(tm.(ex.args), ",~")
	elseif ex.head == :tuple
		return "\\left(" * join(tm.(ex.args), ",~") * "\\right)"
	elseif ex.head in [:$, :macrocall]
		return tmmacro(Op(ex.args[1]),
					   filter(x->!(x isa LineNumberNode), ex.args[2:end]);
					   alignat=alignat, kwargs...)
	else
		ex |> dump
		error("Unknown expression type")
	end
end


function tm(n::QuoteNode; kwargs...)
	return tm(n.value; kwargs...)
end


function tm(arr::Array; alignat=x->false, kwargs...)
	lines = String[]

	for i in 1:size(arr, 1)
		row = arr[i,:]
		push!(lines, join(tm.(row; alignat=x->false, kwargs...), " & "))
	end

	return "\\left[\\begin{array}{c}\n\t" *
	join(lines, "\\\\[1ex]\n\t") *
	"\n\\end{array}\\right]"
end


function tm(str::String; kwargs...)
	str2 = reduce(replace,
				  ["%"=>"\\%",
				   "&"=>"\\&",
				   "#"=>"\\#",
				   "^"=>"\\^",
				   "{"=>"\\{",
				   "}"=>"\\}",
				   "_"=>"\\_"],
				  init=str)
	return "\\text{" * str2 * "}"
end


function tm(t::Tuple; alignat, kwargs...)
	return "\\left(~" * join(tm.(t.args), ",~") * "~\\right)"
end


function tm(exprs::Vector{Expr};
		    alignat=x->x in [:>, :<, :(>=), :(<=), :(==),
							 :!=, :≈, :≠, :(=>)],
		    kwargs...)
	if length(exprs) == 1
		return tm(exprs[1]; alignat=alignat, kwargs...)
	end

	lines = texmath.(exprs; alignat=alignat, kwargs...)
	if all(l->count(c->c == '&', l) == 0, lines)
		return join(lines, "\\\\[1ex]")
	end

	if all(l->count(c->c == '&', l) <= 2, lines)
		removed_second_amperstand = join.(rsplit.(lines, "&", limit=2))
		return "\\begin{alignedat}{99}$(join(removed_second_amperstand, "\\\\"))\\end{alignedat}"
	end

	return "\\begin{alignedat}{99}$(join(lines, "\\\\"))\\end{alignedat}"
end

texmath = tm
end # module
