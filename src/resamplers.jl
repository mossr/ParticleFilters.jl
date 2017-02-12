function resample{S}(r::ImportanceResampler, b::WeightedParticleBelief{S}, rng::AbstractRNG)
    #XXX this may break if StatsBase changes
    ps = Array(S, r.n)
    alias_sample!(rng, particles(b), weights(b), weight_sum(b), ps)
    return ParticleCollection(ps)
end

function resample{S}(re::LowVarianceResampler, b::AbstractParticleBelief{S}, rng::AbstractRNG)
    ps = Array(S, re.n)
    r = rand(rng)*weight_sum(b)/re.n
    c = weight(b,1)
    i = 1
    U = r
    for m in 1:re.n
        while U > c
            i += 1
            c += weight(b, i)
        end
        U += weight_sum(b)/re.n
        ps[m] = particles(b)[i]
    end
    return ParticleCollection(ps)
end

function resample(r::Union{ImportanceResampler,LowVarianceResampler}, b, rng::AbstractRNG)
    ps = Array(eltype(b), r.n)
    for i in 1:r.n
        ps[i] = rand(rng, b)
    end
    return ParticleCollection(ps)
end
