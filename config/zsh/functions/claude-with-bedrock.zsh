#!/usr/bin/env zsh

claude-with-bedrock() {
  export CLAUDE_CODE_USE_BEDROCK="1"
  export AWS_PROFILE="tools"
  export AWS_REGION="eu-south-2"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="eu.anthropic.claude-opus-4-7"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="eu.anthropic.claude-sonnet-4-6"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="eu.anthropic.claude-haiku-4-5-20251001-v1:0"
  command claude "$@"
}



