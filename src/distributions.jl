const gaussfact = 1/sqrt(2pi)

# type MatchDistribution
#     region :: Int
#     shift :: Int
#     quality :: Float64
    
# end

function region_pdf(amplitudes, matches::AbstractArray{T} where T<:Match)
    σs = amplitudes.*[1/m[2]^2 for m in matches]
    sσ = sum(1.0./σs)
    amp -> begin
        acc = 0.0
        for (a,σ) in zip(amplitudes,σs)
            acc += gaussfact/σ*exp(-(amp-a)^2/2σ^2)
        end
        acc / sσ
    end
end

function region_pdf(signal, chunk, matches)
    l = length(chunk)
    amplitudes = [ projection(@view signal[m[1]:m[1]+l], chunk) for m in matches]
    region_pdf(amplitudes, matches)
end

function projection(signal, ref)
    dot(signal,ref) / norm(ref)^2
end