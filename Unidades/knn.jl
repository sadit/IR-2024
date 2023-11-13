function knn(index, labels, q, k)
    res = KnnResult(k)
    search(index, q, res)
    mode(labels[idview(res)])
end

function mymode(c, labels, f)
    n = length(c)
    empty!(f)
    for id in c
        id == 0 && break  # searchbatch stores zeros at the end of the result when the result set is smaller than the required one
        l = labels[id]
        f[l] = get(f, l, 0) + 1
    end
    
    if length(f) == 0
        rand(labels)
    else
        argmax(last, f) |> first
    end
end

function knn(I, labels)
    f = Dict{eltype(labels), Int}()
    [mymode(c, labels, f) for c in eachcol(I)]
end

function scores(gold, pred)
    s = classification_scores(gold, pred)
    (macrof1=s.macrof1, macrorecall=s.macrorecall, accuracy=s.accuracy)
end