#!/usr/bin/env bash
# ============================================================================
# BTV — READ-ONLY verification of the btv-github MCP connection.
#   bash verify-github-mcp-readonly.sh
#
# Performs: initialize -> tools/list -> read the repository -> read issue #3
# -> list issues -> list pull requests -> read a file. Nothing is modified.
# The token is read from ${GITHUB_PAT} and never printed.
# ============================================================================
set -uo pipefail

URL="https://api.githubcopilot.com/mcp/"
OWNER="KINGACEX"
REPO="beyond-the-veil-last-watch-"
HF="$(mktemp)"

rpc() {
  curl -sS -X POST "$URL" \
    -H "Authorization: Bearer ${GITHUB_PAT}" \
    -H "X-MCP-Toolsets: repos,issues,pull_requests" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json, text/event-stream" \
    -D "$HF" ${2:+-H "Mcp-Session-Id: $2"} --data-binary "$1"
}

# Extract just the JSON payload from the SSE frame.
payload() { sed -n 's/^data: //p' | tail -1; }

call_tool() { # $1 = tool name, $2 = arguments json
  local body
  body="$(node -e '
    process.stdout.write(JSON.stringify({jsonrpc:"2.0",id:Date.now()%100000,method:"tools/call",
      params:{name:process.argv[1],arguments:JSON.parse(process.argv[2])}}));' "$1" "$2")"
  rpc "$body" "$SESSION" | payload
}

text_of() { node -e '
  let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{
    try{
      const j=JSON.parse(d);
      if(j.error){console.log("MCP_ERROR "+JSON.stringify(j.error).slice(0,300));return;}
      const t=(j.result?.content||[]).map(c=>c.text||"").join("\n");
      console.log(t);
    }catch(e){console.log("PARSE_ERROR "+d.slice(0,200));}
  });'; }

echo "=== A. initialize ==="
INIT="$(rpc '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"minimax-code","version":"1.0"}}}')"
SESSION="$(grep -i '^mcp-session-id:' "$HF" | tr -d '\r' | awk '{print $2}')"
echo "$INIT" | payload | node -e 'let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{const j=JSON.parse(d);console.log("  server:",j.result?.serverInfo?.name||"(not reported)","version:",j.result?.serverInfo?.version||"-");console.log("  capabilities:",Object.keys(j.result?.capabilities||{}).join(", "))})'
echo "  session id: ${SESSION:0:8}…"
rpc '{"jsonrpc":"2.0","method":"notifications/initialized"}' "$SESSION" >/dev/null 2>&1

echo; echo "=== B. tools/list — count and names ==="
TOOLS="$(rpc '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' "$SESSION" | payload)"
echo "$TOOLS" | node -e '
let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{
  const j=JSON.parse(d);
  const t=j.result.tools;
  console.log("  total tools:",t.length);
  const cats={};
  for(const x of t){
    let cat="other";
    const n=x.name;
    if(/^(list|get|search)_/.test(n)) cat="read:list/get/search";
    else if(/^(issue|pull_request)_read$/.test(n)) cat="read:scoped";
    else if(/write|create|update|delete|merge|comment|review|fork|push/.test(n)) cat="write";
    (cats[cat]=cats[cat]||[]).push(n);
  }
  for(const [c,ns] of Object.entries(cats)){
    console.log("  ["+c+"] "+ns.length);
    console.log("     "+ns.join(", "));
  }
});'

echo; echo "=== C. repository access ==="
call_tool get_file_contents "{\"owner\":\"$OWNER\",\"repo\":\"$REPO\",\"path\":\"README.md\"}" | text_of | head -6

echo; echo "=== D. list_branches ==="
call_tool list_branches "{\"owner\":\"$OWNER\",\"repo\":\"$REPO\",\"perPage\":100}" | text_of | node -e '
let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{
 try{const a=JSON.parse(d);console.log("  branches:",a.length);a.forEach(b=>console.log("   ",b.name));}catch(e){console.log("  raw:",d.slice(0,300));}
});'

echo; echo "=== E. ISSUE #3 (BTV Agent Coordination Hub) ==="
call_tool issue_read "{\"owner\":\"$OWNER\",\"repo\":\"$REPO\",\"issue_number\":3,\"method\":\"get\"}" | text_of | node -e '
let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{
 try{
   const j=JSON.parse(d);
   console.log("  number:   ",j.number);
   console.log("  title:    ",j.title);
   console.log("  state:    ",j.state);
   console.log("  labels:   ",(j.labels||[]).map(l=>l.name).join(", ")||"(none)");
   console.log("  author:   ",j.user?.login||"-");
   console.log("  created:  ",j.created_at);
   console.log("  updated:  ",j.updated_at);
   console.log("  comments: ",j.comments);
   console.log("  assignees:",(j.assignees||[]).map(a=>a.login).join(", ")||"(none)");
   console.log("  milestone:",j.milestone?.title||"(none)");
   const body=(j.body||"").replace(/\r/g,"");
   console.log("  --- body ("+body.length+" chars) ---");
   console.log(body.split("\n").slice(0,28).map(l=>"  "+l).join("\n"));
 }catch(e){console.log("  raw:",d.slice(0,500));}
});'

echo; echo "=== F. issues + pull requests ==="
call_tool list_issues "{\"owner\":\"$OWNER\",\"repo\":\"$REPO\",\"perPage\":50}" | text_of | node -e '
let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{
 try{const a=JSON.parse(d);console.log("  issues:",a.length);a.forEach(i=>console.log("   #"+i.number,"["+i.state+"]",i.title))}catch(e){console.log("  raw:",d.slice(0,300));}
});'
call_tool list_pull_requests "{\"owner\":\"$OWNER\",\"repo\":\"$REPO\",\"state\":\"all\",\"perPage\":50}" | text_of | node -e '
let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{
 try{const a=JSON.parse(d);console.log("  pull requests:",a.length);a.forEach(p=>console.log("   #"+p.number,"["+(p.draft?"draft":"ready")+"]",p.title,"->",p.base?.ref))}catch(e){console.log("  raw:",d.slice(0,300));}
});'

rm -f "$HF"
