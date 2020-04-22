const TM_LANG_EN = Dict{Symbol, String}(
	:sin  => "sin",
	:cos  => "cos",
	:tan  => "tan",
	:cot  => "cot",
	:sec  => "sec",
	:csc  => "csc",
	:asin => "arcsin",
	:acos => "arccos",
	:atan => "arctan",
	:cot  => "arccot",
	:sec  => "arcsec",
	:csc  => "arccsc",
	
	:if => "if",
	:otherwise => "otherwise",
	:iseven => "%n is even",
	:isodd => "%n is odd",
)

const TM_LANG_PT = Dict{Symbol, String}(
	:sin  => "sen",
	:cos  => "cos",
	:tan  => "tg",
	:cot  => "cotg",
	:sec  => "sec",
	:csc  => "cossec",
	:asin => "arc\\,sen",
	:acos => "arc\\,cos",
	:atg  => "arc\\,tg",
	:acot => "arc\\,cotg",
	:asec => "arc\\,sec",
	:acsc => "arc\\,cossec",

	:if => "se",
	:otherwise => "caso contrário",
	:iseven => "%n for par",
	:isodd => "%n for ímpar",
)
