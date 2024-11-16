using Pkg
Pkg.activate(".")

include("src/ImagenAPI.jl")
using .ImagenAPI

# 生成單張圖片
prompt = "一隻可愛的兔子在廚房裡烘焙蛋糕，溫馨的場景，細節豐富"
try
    result = generate_image(
        prompt,
        output_path="output/bunny_baking.png",
        config=DEFAULT_CONFIG
    )
    println("圖片生成完成！")
catch e
    println("生成失敗: ", e)
    @error "錯誤詳情" exception=(e, catch_backtrace())
end 