# Neovim Markdown + Image Test File

This file will help you test if your Markdown LSP and image rendering features are working correctly.

## Basic Markdown Features

### Text Formatting

*This text should be italic*
**This text should be bold**
***This text should be bold and italic***
~~This text should have strikethrough~~

### Lists

Ordered list:
1. First item
2. Second item
3. Third item with nested list:
   1. Sub-item 1
   2. Sub-item 2

Unordered list:
- Item one
- Item two
- Item three
  - Nested item
  - Another nested item

### Links

[Link to Neovim documentation](https://neovim.io/doc/)
[Relative link to another file](./test2.md)

### Code Blocks

Inline code: `print("Hello World")`

```lua
-- This is a Lua code block
local function hello()
  print("Hello from Neovim!")
  return true
end

hello()
```

```go
// This is a Go code block
package main

import "fmt"

func main() {
  fmt.Println("Hello from Go!")
}
```

### Tables

| Feature      | Status      | Notes                      |
|--------------|-------------|----------------------------|
| Marksman LSP | Testing     | Should provide completion  |
| EFM Server   | Testing     | Should format on save      |
| Images       | Testing     | Should render inline       |
| PDF Support  | Testing     | Should handle PDF files    |

## Image Rendering Test

### Local Images
Below are some sample local images to test rendering:

![Neovim Logo](/tmp/neovim-logo.png)

![Sample Image](/tmp/sample-image.jpg)

### Test with relative path:

![Relative Image](./images/test-image.png)

### URL Images
These should be downloaded and displayed if download_remote_images is enabled:

![Kitty Terminal Logo](https://sw.kovidgoyal.net/kitty/_static/kitty.svg)

![Neovim Logo](https://raw.githubusercontent.com/neovim/neovim.github.io/master/logos/neovim-logo-300x87.png)

## PDF Features Test

Link to a PDF file: [Test PDF](/tmp/test.pdf)

## LSP Features to Check

1. **Hover Information**: Hover over links or images to see if the LSP provides information
2. **Completion**: Try typing `[` to see if it suggests links to other files
3. **Diagnostics**: Intentional error [broken link](./nonexistent.md) - should be highlighted
4. **Formatting**: Save the file to check if formatting works
5. **Grammar/Spelling**: This sentance has a spellling error that should be detected.

## Advanced Markdown Features

### Definition Lists

Term 1
: Definition 1

Term 2
: Definition 2a
: Definition 2b

### Blockquotes

> This is a blockquote
>
> It can span multiple lines
>
>> And can be nested

### Task Lists

- [x] Completed task
- [ ] Incomplete task
- [ ] Another incomplete task
  - [x] Completed Subtasks

### Footnotes

Here's a sentence with a footnote.[^1]

[^1]: This is the footnote content.

## Testing Checklist

- [ ] Basic Markdown syntax highlighting works
- [ ] LSP provides diagnostics for errors
- [ ] Images render properly inline
- [ ] Code blocks ha
