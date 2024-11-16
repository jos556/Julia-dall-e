using HTTP
using JSON
using Base64
using Images
using Downloads

# 引入 check_api_key
import ..ImagenAPI: check_api_key, DEFAULT_CONFIG

"""
    generate_image(prompt::String; config::Dict = DEFAULT_CONFIG)

使用 DALL-E 生成圖像。
"""
function generate_image(prompt::String; output_path::Union{String,Nothing}=nothing, config::Dict = DEFAULT_CONFIG)
    api_key = check_api_key()
    show_config()
    
    @info "正在生成圖像，提示詞: $prompt"
    
    headers = [
        "Content-Type" => "application/json",
        "Authorization" => "Bearer $api_key"
    ]
    
    body = Dict(
        "prompt" => prompt,
        "model" => config["model"],
        "size" => config["size"],
        "quality" => config["quality"],
        "n" => config["n"]
    )
    
    try
        response = HTTP.post(
            "$API_BASE_URL/images/generations",
            headers,
            JSON.json(body)
        )
        
        result = JSON.parse(String(response.body))
        image_url = result["data"][1]["url"]
        @info "圖像生成成功: $image_url"

        if !isnothing(output_path)
            # 創建輸出目錄
            mkpath(dirname(output_path))
            
            # 下載並保存圖片
            Downloads.download(image_url, output_path)
            @info "圖片已保存到: $output_path"
            return output_path
        end
        
        return image_url
        
    catch e
        @error "API 請求失敗" exception=(e, catch_backtrace())
        rethrow(e)
    end
end

"""
    batch_generate(prompts::Vector{String}; output_dir::String="output", config::Dict = DEFAULT_CONFIG)

批量生成多個圖像。
"""
function batch_generate(prompts::Vector{String}; output_dir::String="output", config::Dict = DEFAULT_CONFIG)
    results = String[]
    for (i, prompt) in enumerate(prompts)
        output_path = joinpath(output_dir, "image_$i.png")
        try
            result = generate_image(prompt, output_path=output_path, config=config)
            push!(results, result)
        catch e
            @error "生成第 $i 張圖片時失敗" exception=(e, catch_backtrace())
        end
    end
    return results
end 