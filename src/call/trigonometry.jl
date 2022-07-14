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

function tmcall(::Op{:sin}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:sin]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:asin}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:asin]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:cos}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:cos]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:acos}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:acos]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:tan}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:tan]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:atan}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:atan]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:cot}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:cot]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:acot}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:acot]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:sec}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:sec]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:asec}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:asec]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:csc}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:csc]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


function tmcall(::Op{:acsc}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:acsc]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg 
end


# DEGREE VERSIONS :

function tmcall(::Op{:sind}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:sin]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:asind}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:asin]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:cosd}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:cos]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:acosd}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:acos]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:tand}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:tan]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:atand}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:atan]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:cotd}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:cot]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:acotd}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:acot]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:secd}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:sec]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:asecd}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:asec]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:cscd}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:csc]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end


function tmcall(::Op{:acscd}, args; lang=TM_LANG_EN, kwargs...)
	if length(args) != 1 throw(TooManyArgumentsError(1)) end
	opname = lang[:acsc]

	if args[1] isa Expr && parneeded(args[1])
		arg = tm(:(par($(args[1]))); kwargs...)
	else
		arg = tm(args[1]; kwargs...)
	end

	return "\\operatorname{$opname} " * arg * "^{\\circ}"
end

