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


function tm(n::Number; kwargs...)
    return "$n"
end


function tm(i::Integer; kwargs...)
	sign, integer = match(r"(-?)(\d+)", string(i)).captures

	return sign * rthousand(integer; kwargs...)
end


function tm(r::Rational; kwargs...)
	return tmcall(Op(:/), [r.num, r.den]; kwargs...)
end


function lthousand(str::AbstractString;
                   ignore_last_thousand=true,
                   thousand_separator="\\,",
				   kwargs...)
	result = ""

	for (n, char) in str |> enumerate
		result *= char
		if n % 3 == 0 && (!ignore_last_thousand || length(str) - n > 2)
			result *= thousand_separator
		end
	end

	return result
end


function rthousand(str::AbstractString;
                   thousand_separator="\\,",
				   kwargs...)
	result = ""

	for (n, char) in str |> enumerate
		result *= char
		if (length(str) - n) % 3 == 0 && (length(str) - n != 0)
			result *= thousand_separator
		end
	end

	return result
end


function scientific_notation(f::AbstractFloat)
	exponent = floor(Int, log10(abs(f)))
	mantissa = f * 10.0^(-exponent)

	return mantissa, exponent
end


function tm(f::AbstractFloat;
                 decimal_separator="{,}",
                 digits=4,
                 kwargs...)
	if f == 0.0 return "0" end

	magnitude = floor(Int, log10(abs(f)))
	
	if magnitude > 5
		f = round(f; sigdigits=digits+1)
		result, integer, fractional, exponent =
			match(r"(-?)(\d+)\.(\d+)e?(-?\d+)?", string(f)).captures
	elseif magnitude < -2
		mantissa, exponent = scientific_notation(f)

		mantissa = round(mantissa; sigdigits=digits+1)

		result, integer, fractional =
			match(r"(-?)(\d+)\.(\d+)", string(mantissa)).captures
	else
		f = round(f; digits=digits)
		result, integer, fractional =
			match(r"(-?)(\d+)\.(\d+)", string(f)).captures
		exponent = nothing
	end


	result *= rthousand(integer; kwargs...) *
	          decimal_separator *
	          lthousand(fractional; kwargs...)

	if !(exponent isa Nothing)
		return result * "{\\footnotesize\\times10}^{$exponent}"
	else
		return result
	end
end


function tm(f::Complex; kwargs...)
	if imag == 0
		return tm(real(f); kwargs...)
	elseif real == 0
		return tmcall(Op(:*), [ imag(f) , im ]; kwargs...)
	elseif imag == 1
		return tmcall(Op(:+), [ real(f), im ]; kwargs...)
	else
		return tmcall(Op(:+), [ real(f), :($(imag(f))*im) ]; kwargs...)
	end
end
