using DataFrames, Dates, CSV

"""
    filter_active(topixdf) -> DataFrame
    filter_active!(topixdf) -> DataFrame

最新の日付の銘柄のみを取得する。
# Example
```jldoctest
topixdf = CSV.File("topixweight_j.csv") |> DataFrame
df = filter_active(topixdf)
allequal(df.日付)

# output
true
```
"""
function filter_active(topixdf)
    maxdate = maximum(topixdf.日付::Vector{Int})
    filter(:日付 => ==(maxdate), topixdf)
end
function filter_active!(topixdf)
    maxdate = maximum(topixdf.日付::Vector{Int})
    filter!(:日付 => ==(maxdate), topixdf)
end

"""
    add_code!(topixdf, code; date=20240101, name="")

コードで銘柄をDataFrameに追加する。
# Example
```jldoctest
topixdf = CSV.File("topixweight_j.csv") |> DataFrame
add_code!(topixdf, "1000")
topixdf[end, :コード]

# output
"1000"
```
"""
add_code!(topixdf, code; date=20240101, name="") = push!(topixdf, (date, name, code, "", "", ""))