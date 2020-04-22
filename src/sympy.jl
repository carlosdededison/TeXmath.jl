

function tm(n::SymPy.Sym; var=[], kwargs...)
	result = n |> SymPy.latex

	if any(x->occursin(x, result), string.(var))
		return "\\left\\{~ " * result * " ~\\right\\}"
	else
		return result
	end
end

function tmcall(::Op{:solve}, args; kwargs...)
	so     = SymPy.solve(args...)
	result = tm(so; var=args[2])
	return result
end

function tmcall(::Op{:solveset}, args; kwargs...)
	so     = SymPy.solveset(args...)
	result = tm(so; var=args[2])
	return result
end
