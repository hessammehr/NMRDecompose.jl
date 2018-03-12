function matches(signal, chunk)
    l1 = length(signal)
    l2 = length(chunk)
    l = l1 - l2
    l < 0 && return Tuple{Int,Float64}[]
    res = zeros(l)
    for i=1:l+1
        s = @view signal[i:i+l2-1]
        res[i] = sum(ref.*s)
    end
end