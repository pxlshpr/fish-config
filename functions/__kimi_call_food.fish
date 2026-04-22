function __kimi_call_food --description "Internal: invoke the NutriKit Kimi food-scan helper. Args: version front_or_dash nutrition_or_dash model api_key"
    python3 ~/.config/fish/helpers/kimi_food.py $argv[1] $argv[2] $argv[3] $argv[4] $argv[5]
end
