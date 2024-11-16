using Dates
using DotEnv

# 載入 .env 文件並顯示當前工作目錄
@info "當前工作目錄: $(pwd())"
DotEnv.config()

# 顯示所有環境變量
@info "環境變量:" ENV

# API 配置
const API_BASE_URL = "https://api.openai.com/v1"

# 默認生成配置
const DEFAULT_CONFIG = Dict(
    "model" => "dall-e-3",
    "size" => "1024x1024",
    "quality" => "standard",
    "n" => 1
)

"""
    check_api_key()

檢查並返回 API 密鑰。
"""
function check_api_key()
    api_key = get(ENV, "API_KEY", "")
    if isempty(api_key)
        throw(ErrorException("請設置 API_KEY 環境變量"))
    end
    @info "使用 API 密鑰: sk-...$(api_key[end-4:end])"
    return api_key
end

"""
    show_config()

顯示當前配置。
"""
function show_config()
    @info "當前配置:" DEFAULT_CONFIG
end 