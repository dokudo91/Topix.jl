using StringEncodings, CSV, DataFrames

const TOPIXCSV_URL = "https://www.jpx.co.jp/automation/markets/indices/topix/files/topixweight_j.csv"

"""
    update_topix(outputfile) -> String
    update_topix() -> String

JPXのサイトからTOPIXのCSVをダウンロードする。
構成銘柄に変化がある場合は、以前の銘柄を残す。
# Example
```jldoctest
julia> update_topix()
"topixweight_j.csv"
```
"""
function update_topix(outputfile)
    mkpath(splitdir(outputfile)[1])
    csvpath = download(TOPIXCSV_URL)::String
    df::DataFrame = CSV.File(open(csvpath, enc"shift-jis")) |> DataFrame
    dropmissing!(df)
    transform!(df, :日付 => ByRow(x -> parse(Int, x)); renamecols=false)
    if isfile(outputfile)
        olddf = CSV.File(outputfile) |> DataFrame
        df = vcat(df, olddf)
        unique!(df, :コード)
    end
    CSV.write(outputfile, df)
    outputfile
end
update_topix() = update_topix(splitdir(TOPIXCSV_URL)[2])