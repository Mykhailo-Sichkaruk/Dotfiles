#!/usr/bin/env python3
import sys, json

try:
    data = json.load(sys.stdin)
except Exception:
    print("status: error reading input")
    sys.exit(0)

parts = []

# Context usage
ctx = data.get("context_window", {})
used_pct = ctx.get("used_percentage")
if used_pct is not None:
    parts.append(f"ctx: {used_pct:.0f}%")

# Total tokens this session
total_in = ctx.get("total_input_tokens")
total_out = ctx.get("total_output_tokens")
if total_in is not None and total_out is not None:
    parts.append(f"tokens: {total_in + total_out}")

# Cost
cost = data.get("cost", {})
cost_usd = cost.get("total_cost_usd")
if cost_usd is not None:
    parts.append(f"${cost_usd:.2f}")

# Model
model = data.get("model", {})
display = model.get("display_name") or model.get("id") or "?"
parts.append(f"model: {display}")

print(" | ".join(parts), end="")
