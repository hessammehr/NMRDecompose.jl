const Match{A,B} = Tuple{A,B}

function fuzziness(matches)
    corrs = [m[2] for m in matches]
    maxcorr = maximum(corrs)
    corrs ./ maxcorr
end

"""Returns cross-correlation local maxima between `signal` and `chunk`
with gaussian attenuation (STD = `σ``) about `shift`."""
function alignments(signal, chunk, σ=0.0, shift=0)
    l = length(signal) # assuming length(signal) = length(chunk)
    xc = xcorr(signal, chunk)
    rng = -shift:(length(signal)-length(chunk)-shift)
    rng = -(l-shift-1):(l-shift-1)
    if σ != 0.0
        xc .*= exp.(-rng.^2/2σ^2) # apply gaussian window function
    end
    filter(x->x[2] > mincorr, local_maxima(xc))
end

function mincheck(matches::AbstractArray{T} where T<:Match, min_threshold)
    filter(m->m[2]>min_threshold, matches)
end

mincheck(matches, min_threshold) = mincheck.(matches, min_threshold)

function hitcheck(matches::AbstractArray{T} where T<:Match, hit_threshold)
    maximum(m[2] for m in region_matches) > hit_threshold
end

function hitcheck(matches, hit_threshold)
    h = hitcheck.(matches, hit_threshold)
    if any(isempty, h)
        Array{Int}[]
    else
        h
    end
end

function fuzzcheck(matches::AbstractArray{T} where T<:Match, max_fuzz)
    fuzz = fuzziness(matches)
    [matches[i] for i in eachindex(matches) if fuzz[i] < maxfuzz]
end
function alignments(s::Spectrum, ref::Spectrum, hitcorr, mincorr, σ=0.0)
    signal = s[:]
    matches = [alignments(s, c, σ, mincorr) for c in intrng_data(ref)]
    if any(isempty(matches))
        Array{Int}[]
    else
        matches
    end
end

function alignments(s::Spectrum, ref::Spectrum, hitcorr, mincorr, max_fuzz, σ=0.0)
    matches = alignments(s, ref, hitcorr, mincorr, σ)
end

function alignments(signal, chunk, σ, hitcorr, mincorr, target_n)
    a = alignments(signal, chunk, shift, σ)

end

function synthesize(ref::Spectrum, alignment)
end