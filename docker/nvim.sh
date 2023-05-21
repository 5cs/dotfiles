#!/bin/bash

cd /root/.local/share/nvim/site/plugged/coc.nvim/
yarnpkg install

cd /root/.local/share/nvim/site/plugged/nvim-treesitter-textobjects
git apply << EOF
diff --git a/lua/nvim-treesitter/textobjects/select.lua b/lua/nvim-treesitter/textobjects/select.lua
index c8a60b4..a5f85b3 100644
--- a/lua/nvim-treesitter/textobjects/select.lua
+++ b/lua/nvim-treesitter/textobjects/select.lua
@@ -52,7 +52,9 @@ function M.attach(bufnr, lang)
   lang = lang or parsers.get_buf_lang(buf)
 
   for mapping, query in pairs(config.keymaps) do
-    if not queries.get_query(lang, "textobjects") then
+    if type(query) == "table" then
+      query = query[lang]
+    elseif not queries.get_query(lang, "textobjects") then
       query = nil
     end
     if query then
EOF
