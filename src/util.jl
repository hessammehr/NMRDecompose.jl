"""Tunes `param` until `expr` evaluates to zero within δ. 
`expr` must be monotonically increasing in terms of `param`."""
macro binary_opt(expr, param, min, max, δ)
    :(m = $min;M = $max;z=zero($δ);
    while(true)
        $(esc(param)) = (m+M)/2
        println("$((m+M)/2)")
        e = $(esc(expr))
        if norm(e) < $δ
            break
        elseif e < z
            m = $(esc(param))
        else
            M = $(esc(param))
        end
    end)
end

"""Returns the location and values of local maxima in `sig`."""
function local_maxima(sig)
    l = length(sig)
    res = Tuple{Int, T}[]
    if l < 3
        return res
    end
    @inbounds for i = 2:l-1
        if sig[i-1] < sig[i] && sig[i+1] < sig[i]
            append!(res, (i, sig[i]))
        end
    end
    res
end