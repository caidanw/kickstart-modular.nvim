-- Astro filetype plugin
--
-- This file overrides the default nvim-treesitter injection query for Astro files.
--
-- Problem:
--   The nvim-treesitter astro injections query includes `; inherits: html_tags`
--   which pulls in injection rules that conflict with the typescript parser.
--   This causes syntax highlighting to break in <script> tags - everything turns
--   green (string color) except actual template literal strings, which get the
--   correct highlighting (essentially inverted).
--
-- Solution:
--   Use `vim.treesitter.query.set()` to completely replace the injections query
--   with one that doesn't inherit from html_tags.
--
-- References:
--   - https://github.com/virchau13/tree-sitter-astro/issues/18
--   - https://github.com/virchau13/tree-sitter-astro/issues/31

vim.treesitter.query.set(
  'astro',
  'injections',
  [[
(frontmatter
  (frontmatter_js_block) @injection.content
  (#set! injection.language "typescript"))

(attribute_interpolation
  (attribute_js_expr) @injection.content
  (#set! injection.language "typescript"))

(attribute
  (attribute_backtick_string) @injection.content
  (#set! injection.language "typescript"))

(html_interpolation
  (permissible_text) @injection.content
  (#set! injection.language "typescript"))

(script_element
  (raw_text) @injection.content
  (#set! injection.language "typescript"))

(style_element
  (start_tag
    (attribute
      (attribute_name) @_lang_attr
      (quoted_attribute_value
        (attribute_value) @_lang_value)))
  (raw_text) @injection.content
  (#eq? @_lang_attr "lang")
  (#eq? @_lang_value "scss")
  (#set! injection.language "scss"))
]]
)
