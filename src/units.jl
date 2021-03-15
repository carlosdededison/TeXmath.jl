function tm(n::Unitful.FreeUnits{N, D, A}; kwargs...) where {N, D, A}

	positive = String[]
	negative = String[]

        for unit in N
                symbol = Unitful.prefix(unit) * Unitful.abbr(unit)
                if unit.power == 1
                        push!(positive, symbol)
		elseif unit.power > 1
			if denominator(unit.power) == 1
				p = tm(numerator(unit.power))
			else
				p = tm(unit.power)
                        end
			push!(positive, symbol * "^{$p}")
		elseif unit.power == -1
			push!(negative, symbol)
		elseif unit.power < -1
			if denominator(unit.power) == 1
				p = tm(-numerator(unit.power))
			else
				p = tm(-unit.power)
                        end
			push!(negative, symbol * "^{$p}")
		else # power == 0
                        # do nothing
                end
        end

	if length(positive) == 0
                negative_units = []
                for unit in N
                        symbol = Unitful.prefix(unit) * Unitful.abbr(unit)

                        if denominator(unit.power) == 1
				p = tm(numerator(unit.power))
			else
				p = tm(unit.power)
                        end

                        push!(negative_units, symbol * "^{$p}")
                end
		return "\\mathrm{ $(join(negative_units, " \\cdot ")) }"
        end

	if length(negative) == 0
		return "\\mathrm{ $(join(positive, " \\cdot ")) }"
        elseif length(negative) == 1
		return "\\mathrm{ $(join(positive, " \\cdot ")) / $(negative[1]) }"
	else # length(negative) > 1
		return "\\mathrm{ $(join(positive, " \\cdot ")) / ($(join(negative, " \\cdot "))) }"
        end
end


function tmmacro(::Op{Symbol("@u_str")}, arg; kwargs...)
	ex = Meta.parse(arg)

	dump(ex)

    #    tm.(Core.eval(Main, quote @u_str $(args...) end); kwargs...)
end
