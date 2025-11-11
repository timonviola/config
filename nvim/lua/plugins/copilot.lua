return {
    -- all config options: https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/main/lua/CopilotChat/config.lua
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {
            -- See Configuration section for options
            prompts = {
                MyCustomPrompt = {
                    prompt = 'Explain how it works.',
                    system_prompt = 'You are very good at explaining stuff',
                    mapping = '<leader>zmc',
                    description = 'My custom prompt description',
                },
                Yarrr = {
                    system_prompt = 'You are fascinated by pirates, so please respond in pirate speak.',
                },
                NiceInstructions = {
                    system_prompt = 'You are a nice coding tutor, so please respond in a friendly and helpful manner.',
                }
            },
            window = {
                layout = 'vertical',
                border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
                title = '🤖 AI Assistant',
            },

            headers = {
                user = '👤 You',
                assistant = '🤖 Copilot',
                tool = '🔧 Tool',
            },

            separator = '━━',
            auto_fold = true, -- Automatically folds non-assistant messages
        },
    },
}
