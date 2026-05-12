# LLM Tag Filter Plugin

The `llm_tag` filter plugin uses a Large Language Model (LLM) to **classify log records** and **route them by rewriting their tag** based on natural-language conditions. Instead of writing complex regex rules or static matchers, you describe what you're looking for in plain English, and the LLM decides which records match.

It extracts the log payload (looking for `log` or `message` keys) and queries the configured OpenAI-compatible API using natural language prompts. For remote endpoints, HTTPS is recommended; if `model_api_key` is configured, it is used for authenticated requests. If the LLM determines that a record matches a specific prompt classification, the plugin emits a copy of the record with a newly assigned tag.

This is highly useful for semantic log routing, such as identifying security anomalies, analyzing sentiment, or catching obscure errors without writing complex regular expressions.

This plugin is OpenAI API-compatible and works with OpenAI, Azure OpenAI, vLLM, Ollama (with the OpenAI-compatible endpoint), LM Studio, and any other server that exposes an OpenAI-compatible `/chat/completions` endpoint.

## How It Works

1. For each incoming record, the filter extracts the `log` or `message` field.
2. It builds a **batch prompt** that includes every configured rule's prompt, and sends a single request to the configured LLM.
3. The LLM responds with one `yes`/`no` decision per rule (e.g. `1: yes\n2: no\n3: yes`).
4. For each rule that matched, the record is re-emitted with the rule's target tag through a shared internal emitter input.
5. Depending on `keep_record` and `tags_match_mode`, the original record is either dropped, kept, or evaluation stops at the first match.

> **Note:** Because the plugin re-emits records through an internal `emitter` input, downstream outputs can match the new tags directly with the `match` directive.

## Configuration Parameters

| Key | Description | Default |
|---|---|---|
| `model_endpoint` | **Required.** The LLM HTTP endpoint URL, e.g. `https://api.openai.com/v1/chat/completions`. | _(none)_ |
| `model_id` | **Required.** The LLM model identifier sent in the request body (e.g. `gpt-4o-mini`, `llama3.1:8b`). | _(none)_ |
| `model_api_key` | API key for authentication. If relying on a local/unauthenticated model, this can be omitted. | _(none)_ |
| `model_timeout` | HTTP request timeout in milliseconds for the LLM API call. | `1000` |
| `tags` | **Required.** The classification rules array. Each item must be an object containing `tag` (the new tag to apply) and `prompt` (the natural language condition). | _(none)_ |
| `tags_match_mode` | `first` to stop at the first matching rule, or `all` to evaluate every rule and emit one record per match. | `first` |
| `keep_record` | When `true`, also keep the original record (with the original tag) after re-emission. When `false`, the original is dropped if any rule matched. | `false` |

### Rule structure

Each entry in the `tags` array is an object with two string fields:

| Field | Description |
|---|---|
| `tag` | The new tag to assign when this rule matches. |
| `prompt` | A natural-language condition. The LLM will answer **yes** or **no** for this rule for every log line. |

## Examples

### Example 1: Route errors and security events with OpenAI

This pipeline reads from a JSON file, asks the LLM to flag error and security-related lines, and routes them to different outputs.

```yaml
service:
  log_level: info

pipeline:
  inputs:
    - name: tail
      path: /var/log/app.log
      tag: app.raw
      parser: json

  filters:
    - name: llm_tag
      match: app.raw
      model_endpoint: https://api.openai.com/v1/chat/completions
      model_id: gpt-4o-mini
      model_api_key: ${OPENAI_API_KEY}
      model_timeout: 5000
      tags_match_mode: all
      keep_record: false
      tags:
        - tag: app.errors
          prompt: "Does this log indicate an application error, exception, or stack trace?"
        - tag: app.security
          prompt: "Does this log describe a security event such as failed login, unauthorized access, or suspicious activity?"
        - tag: app.slow
          prompt: "Does this log indicate slow performance, high latency, or a timeout?"

  outputs:
    - name: stdout
      match: app.errors
    - name: http
      match: app.security
      host: siem.internal
      port: 8080
    - name: stdout
      match: app.slow
```

### Example 2: Local Ollama

```yaml
filters:
  - name: llm_tag
    match: logs
    tags_match_mode: all
    model_endpoint: http://127.0.0.1:11434
    model_id: phi3:mini
    model_timeout: 10000
    model_api_key: ""
    keep_record: true
    tags:
      - tag: security
        prompt: "This log indicates a security incident or authentication failure"
      - tag: phishing
        prompt: "This log contains phishing attempt or credential request"
```

In this example `keep_record true` means the original record under `sys.raw` is also preserved, so you'll see each matched record twice: once with its new tag and once with the original.

## Match modes compared

Given two rules and a log that matches both:

| `tags_match_mode` | `keep_record` | Result |
|---|---|---|
| `first` | `false` | 1 record emitted with the **first** matching tag; original dropped. |
| `first` | `true` | 1 record emitted with the first matching tag; original kept. |
| `all` | `false` | 1 record emitted **per matching rule**; original dropped. |
| `all` | `true` | 1 record emitted **per matching rule**; original kept. |

If **no** rule matches, the original record is always passed through unchanged regardless of these settings.

## Observability

The plugin tracks four internal counters, logged at shutdown:

- `requests_total` — total LLM requests issued
- `requests_failed` — failed LLM requests (timeouts, errors, etc.)
- `records_emitted` — records re-emitted with a new tag
- `records_dropped` — original records dropped after a successful match

Each LLM call also logs its latency at `info` level, e.g.:

```
[ info] [filter:llm_tag:llm_tag.0] LLM API request completed in 412.55 ms
```

Enable `log_level: debug` on the service to see the raw and parsed LLM responses, which is useful when tuning prompts.

## Tips and Caveats

- **Latency.** Every record incurs an LLM round-trip. For high-volume streams, place `llm_tag` after a sampling or rate-limiting filter, or use a small, fast local model.
- **Cost.** With a hosted API, every record is a billable request. Batch mode keeps it to **1 request per record**, regardless of how many rules you define.
- **Prompt design.** Phrase prompts as **yes/no questions**. Ambiguous prompts produce inconsistent classifications. Include short, unambiguous criteria.
- **Field names.** The plugin looks for the log content in either a `log` or `message` field. Records without either field are passed through unmodified.
- **Failure mode.** If the LLM call fails or returns an unparseable response, the original record is preserved — you will not silently lose data.
- **Output matching.** Ensure to add outputs that match the new tags you define under `tags[].tag`, otherwise re-emitted records have nowhere to go.
- **Recursion.** The plugin skips records from its own emitter to avoid infinite loops.

## Security considerations

Logs are sent to the configured LLM endpoint. Do not send sensitive data to third-party services unless permitted by your security policy.

* Use environment variables or secrets management for `model_api_key`.
* Consider redacting secrets before this filter if logs may contain credentials, tokens, personal data, or regulated information.
* For sensitive environments, use a local OpenAI-compatible model endpoint.
