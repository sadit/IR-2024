using CodecZlib, JSON
using Downloads: download

function create_dataset(corpusfile, textkey, labelkey)
    text, labels = String[], String[]
    open(corpusfile) do f
        for line in eachline(GzipDecompressorStream(f))
            r = JSON.parse(line)
            push!(labels, r[labelkey])
            push!(text, r[textkey])
        end
    end
    
    (; text, labels)
end


function get_dataset(dbname)
    mkpath("data")
    dbfile = "data/$dbname"
    baseurl = "https://github.com/sadit/TextClassificationTutorial/raw/main/data"
    !isfile(dbfile) && download("$baseurl/$dbname", dbfile)
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
