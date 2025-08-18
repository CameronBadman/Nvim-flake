{
  plugins.indent-blankline = {
    enable = true;
    settings = {
      # Visual styling
      indent = {
        char = "▏";        # Thin line for regular indents
        tab_char = "▏";    # Same for tabs
        smart_indent_cap = true;
      };
      
      # Scope highlighting (current context)
      scope = {
        enabled = true;
        char = "▎";        # Slightly thicker for current scope
        show_start = true;
        show_end = true;
        show_exact_scope = true;
        injected_languages = false;
        priority = 1000;
        
        # Highlight groups for different code structures
        highlight = [
          "Function"
          "Label" 
          "Conditional"
          "Repeat"
          "Keyword"
          "Type"
          "Structure"
        ];
        
        # What code structures to track
        include.node_type."*" = [
          # Functions & classes
          "class"
          "function"
          "method"
          "function_definition"
          "function_declaration"
          
          # Control flow
          "if_statement"
          "while_statement" 
          "for_statement"
          "return_statement"
          "conditional_expression"
          
          # Data structures
          "object"
          "table"
          "dictionary"
          "array"
          "list"
          "arguments"
          "parameter_list"
          "parameters"
          
          # Blocks
          "block"
          "compound_statement"
          "element"
          "body"
          
          # Language-specific
          "impl_item"      # Rust
          "match_arm"      # Rust
          "closure"        # Various languages
        ];
      };
      
      # File types to disable indent guides
      exclude = {
        filetypes = [
          # Help & documentation
          "help"
          "man"
          "lspinfo"
          "checkhealth"
          
          # Dashboard & startup screens  
          "alpha"
          "dashboard"
          "startify"
          
          # File explorers
          "neo-tree"
          "NvimTree"
          "oil"
          "dirvish"
          
          # Plugin UIs
          "Trouble"
          "trouble" 
          "lazy"
          "mason"
          "notify"
          "packer"
          
          # Terminals & prompts
          "toggleterm"
          "lazyterm"
          "TelescopePrompt"
          "TelescopeResults"
          
          # Git & diff
          "gitcommit"
          "gitrebase"
          "fugitive"
          "diff"
          
          # Special buffers
          "qf"              # Quickfix
          "fugitiveblame"   # Git blame
          "floaterm"        # Floating terminal
        ];
        
        buftypes = [
          "terminal"
          "nofile" 
          "quickfix"
          "prompt"
          "help"
        ];
      };
      
      # Performance optimizations
      viewport_buffer = {
        min = 30;
        max = 500;
      };
      
      # Whitespace handling
      whitespace = {
        highlight = [
          "Function"
          "Label"
        ];
        remove_blankline_trail = false;
      };
    };
  };
}
