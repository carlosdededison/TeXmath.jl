
const name_symbols = Dict{String, String}(
	"Alpha"     => "\\Alpha",
	"Beta"      => "\\Beta",
	"Gamma"     => "\\Gamma",
	"Delta"     => "\\Delta",
	"Epsilon"   => "\\Epsilon",
	"Zeta"      => "\\Zeta",
	"Eta"       => "\\Eta",
	"Theta"     => "\\Theta",
	"Iota"      => "\\Iota",
	"Kappa"     => "\\Kappa",
	"Lambda"    => "\\Lambda",
	"upMu"      => "\\upMu",
	"upNu"      => "\\upNu",
	"Xi"        => "\\Xi",
	"upOmicron" => "\\upOmicron",
	"Pi"        => "\\Pi",
	"Rho"       => "\\Rho",
	"Sigma"     => "\\Sigma",
	"Tau"       => "\\Tau",
	"Upsilon"   => "\\Upsilon",
	"Phi"       => "\\Phi",
	"Chi"       => "\\Chi",
	"Psi"       => "\\Psi",
	"Omega"     => "\\Omega",
	"alpha"     => "\\alpha",
	"beta"      => "\\beta",
	"gamma"     => "\\gamma",
	"delta"     => "\\delta",
	"epsilon" => "\\varepsilon",
	"zeta"      => "\\zeta",
	"eta"       => "\\eta",
	"theta"     => "\\theta",
	"iota"      => "\\iota",
	"kappa"     => "\\kappa",
	"lambda"    => "\\lambda",
	"mu"        => "\\mu",
	"nu"        => "\\nu",
	"xi"        => "\\xi",
	"upomicron" => "\\upomicron",
	"pi"        => "\\pi",
	"rho"       => "\\rho",
	"varsigma"  => "\\varsigma",
	"sigma"     => "\\sigma",
	"tau"       => "\\tau",
	"upsilon"   => "\\upsilon",
	"varphi"    => "\\varphi",
	"chi"       => "\\chi",
	"psi"       => "\\psi",
	"omega"     => "\\omega",
	"upvarbeta" => "\\upvarbeta",
	"vartheta"  => "\\vartheta",
	"phi"       => "\\phi",
	"im"        => "\\mathrm{i}",
	"infty"     => "\\infty",
	"<="        => "\\,\\leqslant\\,",
	">="        => "\\,\\geqslant\\,",
)

const unicode_symbols = Dict{Char, String}(
    'Α' => "\\Alpha",
    'Β' => "\\Beta",
    'Γ' => "\\Gamma",
    'Δ' => "\\Delta",
    'Ε' => "\\Epsilon",
    'Ζ' => "\\Zeta",
    'Η' => "\\Eta",
    'Θ' => "\\Theta",
    'Ι' => "\\Iota",
    'Κ' => "\\Kappa",
    'Λ' => "\\Lambda",
    'Μ' => "\\upMu",
    'Ν' => "\\upNu",
    'Ξ' => "\\Xi",
    'Ο' => "\\upOmicron",
    'Π' => "\\Pi",
    'Ρ' => "\\Rho",
    'Σ' => "\\Sigma",
    'Τ' => "\\Tau",
    'Υ' => "\\Upsilon",
    'Φ' => "\\Phi",
    'Χ' => "\\Chi",
    'Ψ' => "\\Psi",
    'Ω' => "\\Omega",
    'α' => "\\alpha",
    'β' => "\\beta",
    'γ' => "\\gamma",
    'δ' => "\\delta",
    'ε' => "\\varepsilon",
    'ζ' => "\\zeta",
    'η' => "\\eta",
    'θ' => "\\theta",
    'ι' => "\\iota",
    'κ' => "\\kappa",
    'λ' => "\\lambda",
    'μ' => "\\mu",
    'ν' => "\\nu",
    'ξ' => "\\xi",
    'ο' => "\\upomicron",
    'π' => "\\pi",
    'ρ' => "\\rho",
    'ς' => "\\varsigma",
    'σ' => "\\sigma",
    'τ' => "\\tau",
    'υ' => "\\upsilon",
    'φ' => "\\varphi",
    'χ' => "\\chi",
    'ψ' => "\\psi",
    'ω' => "\\omega",
    'ϐ' => "\\upvarbeta",
    'ϑ' => "\\vartheta",
    'ϕ' => "\\phi",

	'\\'=> "\\backslash",
    '×' => "\\times",
    '¬' => "\\neg",
	'%' => "\\%",
    '‰' => "\\perthousand",
    '‱' => "\\pertenthousand",
	'∞' => "\\infty",
	'′' => "{}^\\prime"
)


function tm(s::Symbol; kwargs...)

	if string(s) == "_" return "" end

	split_str = map(x->
		if x in keys(name_symbols)
			return name_symbols[x]
		else
			return strip(join(map(char->
				if char in keys(unicode_symbols)
					unicode_symbols[char] * ' '
				else
					char
				end,
			collect(x))))
		end,
		split(string(s), '_')
	)

#	if length(split_str[1]) > 1 &&
#	   !("\\$(split_str[1])" in values(unicode_symbols)) &&
#	   !(split_str[1] in values(unicode_symbols) ||
#	     split_str[1] in values(name_symbols))
#		# make the first argument upright if is more than one character
#		split_str[1] = "\\mathrm{" * split_str[1] * "}"
#	end


	return join(split_str, "_\\mathrm{") * "}"^(length(split_str) - 1)
end
