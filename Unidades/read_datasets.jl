using CodecZlib, JSON
using Downloads: download

function create_dataset(corpusfile, text, label)
    corpus, labels = String[], String[]
    open(corpusfile) do f
        for line in eachline(GzipDecompressorStream(f))
            r = JSON.parse(line)
            push!(labels, r[label])
            push!(corpus, r[text])
        end
    end
    
    (; corpus, labels)
end


function get_dataset(dbname)
    dbfile = "../data/$dbname"
    baseurl = "https://github.com/sadit/TextClassificationTutorial/blob/main/data"
    !isfile(dbfile) && download("$baseurl/$dbname?raw=true", dbfile)
    dbfile
end

function read_news()
    train = "spanish-twitter-news-and-opinions-top25-68.train.json.gz"
    test = "spanish-twitter-news-and-opinions-top25-68.test.json.gz"
    create_dataset(get_dataset(train), "text", "screen_name"), create_dataset(get_dataset(test), "text", "screen_name")
end

function read_emojispace()
    train = "emojispace.train.json.gz"
    test = "emojispace.test.json.gz"
    create_dataset(get_dataset(train), "text", "klass"), create_dataset(get_dataset(test), "text", "klass")
end

function get_julia_packages()
    get_dataset("julia-packages-info-2022-07-18.zip")
end
