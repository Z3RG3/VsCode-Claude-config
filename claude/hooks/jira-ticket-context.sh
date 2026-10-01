#!/bin/bash
# SessionStart: surface the DT ticket key from the current git branch so Claude fetches it from Jira.
input=$(cat)
dir=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
dir=${dir:-${CLAUDE_PROJECT_DIR:-$PWD}}
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
key=$(printf '%s' "$branch" | grep -oE 'DT-[0-9]+' | head -1)
if [ -n "$key" ]; then
  msg="Current branch: $branch. Jira ticket: $key. Before starting a task, fetch it with the Atlassian MCP getJiraIssue (cloudId <domain>.atlassian.net, view evidence) unless it is already in context."
else
  msg="Current branch: $branch has no DT ticket key. Ask for the ticket before starting feature or bugfix work."
fi
jq -n --arg m "$msg" '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $m}}'
