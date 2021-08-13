# nvim-expand-expr

Expand and repeat expression to multiple lines for neovim.

![demo.gif!](https://github.com/AllenDang/nvim-expand-expr/blob/main/demo.gif)

# Requirements

`Neovim >= 0.5`

# Installation

[packer.nvim](https://github.com/wbthomason/packer.nvim)

`use 'AllenDang/nvim-expand-expr'`

# Usage

```lua
require("expand_expr").expand()
```

It will parse cursor line and expand it base on below syntax.

`range|expr`

## range

`range` has two forms.

1. Single number
   `10|print({%d})` will expand as

```
print(1)
print(2)
print(3)
print(4)
print(5)
print(6)
print(7)
print(8)
print(9)
print(10)
```

2. Range format
   `3,7|print({%d})` will expand as

```
print(3)
print(4)
print(5)
print(6)
print(7)
```

## expr

_expr_ is a string contains multiple `{%d}` parts, the content inside {} will be eval as lua expression.

`3|{%d} + {%d+1} + {%d+2}` will expand as

```
1 + 2 + 3
2 + 3 + 4
3 + 4 + 5
```

`3|{%d .. ' hello world ' .. %d*3}`

```
1 hello world 3
2 hello world 6
3 hello world 9
```
