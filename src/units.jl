struct _unit_repr
	name::AbstractString
	exp::Integer
end

# TODO: unit aliases (hr => h, for example)

function tm(n::Unitful.AbstractQuantity; kwargs...)

	function split_exponents(unit)
		s = split(unit, '^')
		return length(s) == 2 ?
			_unit_repr(s[1], parse(Int, s[2])) :
			_unit_repr(s[1], 1)
	end

	reverse_exponent(unit) = _unit_repr(unit.name, -unit.exp)
	print_unit(unit::_unit_repr) = unit.exp == 2 ?
								   "$(unit.name)^{$(unit.exp)}" :
								   unit.name

	units = map(split_exponents, split(string(Unitful.unit(n))))
	units = sort(units, by=x -> -x.exp)
	num_exp_neg = count(x->x.exp<0, units)

	if num_exp_neg == 1
		unit = join(print_unit.(units[1:end-1]), "{\\cdot}") *
				"/" * print_unit(reverse_exponent(units[end]))
	else
		unit = join(print_unit.(units), "{\\cdot}")
	end

	return tm(n.val; kwargs...) * "\\,\\mathrm{$unit}"
end


function tm(n::Unitful.FreeUnits; kwargs...)

	function split_exponents(unit)
		s = split(unit, '^')
		return length(s) == 2 ?
			_unit_repr(s[1], parse(Int, s[2])) :
			_unit_repr(s[1], 1)
	end

	reverse_exponent(unit) = _unit_repr(unit.name, -unit.exp)
	print_unit(unit::_unit_repr) = unit.exp != 1 ?
								   "$(unit.name)^{$(unit.exp)}" :
								   unit.name

	units = map(split_exponents, split(string(n)))
	units = sort(units, by=x -> -x.exp)
	num_exp_neg = count(x->x.exp<0, units)

	if num_exp_neg == 1 && length(units) > 2
		unit = join(print_unit.(units[begin:end-1]), "{\\cdot}") *
				"/" * print_unit(reverse_exponent(units[end]))
	else
		unit = join(print_unit.(units), "{\\cdot}")
	end

	return "\\mathrm{$unit}"
end


function tmmacro(::Op{Symbol("@u_str")}, args; kwargs...)
	tm.(Core.eval(Main, quote @u_str $(args...) end); kwargs...)
end
