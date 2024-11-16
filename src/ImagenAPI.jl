module ImagenAPI

using HTTP
using JSON
using Images
using FileIO

# 首先包含配置文件
include("config.jl")

# 導出配置相關的函數和常量
export check_api_key, DEFAULT_CONFIG, show_config

# 包含圖像生成文件
include("generate_image.jl")

# 導出主要功能函數
export generate_image, batch_generate

end 