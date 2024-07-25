using ArgParse, CSV

include("download.jl")
include("dataframe.jl")

function create_settings()
    s = ArgParseSettings()
    @add_arg_table! s begin
        "update"
        action = :command
        help = "topixweight_j.csvをダウンロードする"
        "list"
        action = :command
        help = "銘柄コード一覧を出力する"
    end
    @add_arg_table! s["update"] begin
        "--csv", "-c"
        default = "topixweight_j.csv"
        help = "出力CSVファイルを指定する"
    end
    @add_arg_table! s["list"] begin
        "--csv", "-c"
        default = "topixweight_j.csv"
        help = "入力CSVファイルを指定する"
        "--all", "-a"
        action = :store_true
        help = "上場廃止した過去の銘柄コードを含める"
        "--tse", "-t"
        action = :store_true
        help = "東京証券取引所を示すTを銘柄コードにつける"
        "--write", "-w"
        default = "stocks.txt"
        help = "出力ファイルを指定する"
    end
    s
end

function run()
    s = create_settings()
    args = parse_args(s; as_symbols=true)
    command = args[:_COMMAND_]
    cargs = args[command]
    if command == :update
        update_topix(cargs[:csv])
    elseif command == :list
        run_list(cargs[:csv], cargs[:all], cargs[:tse], cargs[:write])
    end
end

"""
    run_list(csvpath, isall, istse, writefile)

# Example
```
s = create_settings()
args = parse_args(["list", "-t"], s; as_symbols=true)
command = args[:_COMMAND_]
cargs = args[command]
csvpath, isall, istse, writefile = cargs[:csv], cargs[:all], cargs[:tse], cargs[:write]
run_list(csvpath, isall, istse, writefile)
readline("stocks.txt")

# output
"1301.T"
```
"""
function run_list(csvpath, isall, istse, writefile)
    df = CSV.File(csvpath) |> DataFrame
    isall || filter_active!(df)
    codes = @. df.コード::Vector{String7} * ifelse(istse, ".T", "")
    open(writefile, "w") do io
        join(io, codes, '\n')
    end
end

isinteractive() || run()