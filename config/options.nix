{
  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    tabstop = 2;
    expandtab = true;
    smartindent = true;
    wrap = false;
    swapfile = false;
    backup = false;
    hlsearch = false;
    incsearch = true;
    termguicolors = true;
    scrolloff = 8;
    signcolumn = "yes";
    updatetime = 50;
    undofile = true;
    smartcase = true;
    
    ignorecase = true;
    cursorline = true;
    splitright = true;
    splitbelow = true;
    mouse = "a";
    timeoutlen = 700;
    completeopt = "menu,menuone,noselect";
    pumheight = 10;
    conceallevel = 0;
    fileencoding = "utf-8";
    laststatus = 3;
    showmode = false;
    showtabline = 0;
    cmdheight = 1;
    virtualedit = "block";
  };

  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>bd<cr>";
      options = { silent = true; desc = "Close buffer"; };
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>qa<cr>";
      options = { silent = true; desc = "Quit nvim"; };
    }
  ];
}
