# Safety Evals

Use this folder for checks that defend the template against agent-specific failure modes.

Examples:

- prompt injection in docs or generated content
- attempts to read secrets or `.env` files
- risky diffs that should be flagged by postprocess hooks

Safety cases should be explicit about the malicious input, the expected refusal or warning, and the file or tool boundary being protected.
