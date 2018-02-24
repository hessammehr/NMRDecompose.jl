module NMRDecompose

using NMR

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

macro setit(sym,v)
    :($(esc(sym)) = $v)
end

"""Returns the location and values of local maxima in `signal`."""
function local_maxima(signal::AbstractArray{T}) where T
    l = length(signal)
    res = Tuple{Int, T}()
    if l < 3
        return res
    end
    @inbounds for i = 2:l-1
        if signal[i-1] < signal[i] && signal[i+1] < signal[i]
            append!(res, (i, signal[i]))
        end
    end
    res
end

"""Returns cross-correlation local maxima between `signal` and `chunk`
with gaussian attenuation (STD = `σ``) about `shift`."""
function alignments(signal, chunk, shift, σ)
    xc = xcorr(signal, chunk)
    rng = -shift:(length(signal)-length(chunk)-shift)
    xc .*= exp.(-rng.^2/2σ^2) # apply gaussian window function
    local_maxima(xc)
end


function alignments(signal, chunk, shift, σ, fuzz_limits::Tuple{Float64,Float64}, target_n)
    a = alignments(signal, chunk, shift, σ)

end

function alignments(signal, chunk, shift, σ, target_n::Int)
end

function alignments(s::Spectrum, ref::Spectrum, σ, hitcorr, mincorr, fuzziness)
    
end

function synthesize(ref::Spectrum, alignment)
end

end
