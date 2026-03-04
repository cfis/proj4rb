# ruby-bindgen and FFI Bindings

proj4rb uses [ruby-bindgen](https://github.com/cfis/ruby-bindgen) to generate low-level FFI bindings from `ffi-bindings.yaml`.

## Source of Truth

- `ffi-bindings.yaml` is the source of truth for generated FFI signatures.
- Generated files are under `lib/api/`.

Do not hand-edit generated files. They include a header comment indicating they are generated.

## Regenerating Bindings

Assuming you already installed the `ruby-bindgen` gem:

```console
ruby-bindgen ffi-bindings.yaml
```

This regenerates FFI files in `lib/api/` based on the configured symbols, version guards, and overrides in `ffi-bindings.yaml`.

## When to Regenerate

Regenerate after:

- Adding new symbols in `ffi-bindings.yaml`
- Updating function signatures or overrides
- Updating version guard blocks (for new PROJ versions)

## Manual Wrapper Layer

`lib/proj/` contains hand-written, object-oriented wrappers and should be updated separately as needed when new APIs are exposed.
