function claude-with-bedrock
    set -lx CLAUDE_CODE_USE_BEDROCK 1
    set -lx AWS_PROFILE tools
    set -lx AWS_REGION eu-south-2
    set -lx ANTHROPIC_DEFAULT_OPUS_MODEL eu.anthropic.claude-opus-4-7
    set -lx ANTHROPIC_DEFAULT_SONNET_MODEL eu.anthropic.claude-sonnet-4-6
    set -lx ANTHROPIC_DEFAULT_HAIKU_MODEL eu.anthropic.claude-haiku-4-5-20251001-v1:0
    command claude $argv
end
