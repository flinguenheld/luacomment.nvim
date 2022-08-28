# luacomment.nvim

![badge](https://img.shields.io/static/v1?label=Neovim&message=0.7&color=brightgreen&style=for-the-badge)


Comment plugin for Neovim created to learn lua and to discover the nvim api.  
Great rabbit hole, give my time back [TJ DevVries](https://github.com/tjdevries) !


#### Installation

With [packer](https://github.com/wbthomason/packer.nvim)

    use 'FLinguenheld/luacomment.nvim'


#### Mapping

|  Line comment             |                                                             |     |
|---------------------------|-------------------------------------------------------------|-----|
|`[n] <leader> ca`          | Add comment characters on the line beginning                | n/v |
|`[n] <leader> cd`          | Delete comment characters                                   | n/v |
|`[n] <leader> ci`          | Inverse comment characters                                  | n/v |
|`<leader> cA [motion]`     | Add comment characters                                      | n   |
|`<leader> cD [motion]`     | Inverse comment characters                                  | n   |
|`<leader> cI [motion]`     | Inverse comment characters                                  | n   |


|  Multiline comment        |                                                                                        |     |
|---------------------------|----------------------------------------------------------------------------------------|:---:|
|`[n] <leader> Ca`          | Add multiline comment characters on the current line and on the current line + count   | n/v |
|`<leader> Cd`              | Delete multiline comment characters (the cursor has to be in the comment area)         | n   |
|`<leader> CA [motion]`     | Add multiline comment (per line or per word)                                           | n   |



|  Extra                    |                                                                                        |     |
|---------------------------|----------------------------------------------------------------------------------------|:---:|
|`<leader> cO`              | Add a line above the current line and start a line comment                             | n   |
|`<leader> CO`              | Same with a multiline comment                                                          | n   |
|`<leader> co`              | Add a line under the current line and start a line comment                             | n   |
|`<leader> Co`              | Same with a multiline comment                                                          | n   |
|`<leader> cea`             | Start a comment on the right                                                           | n   |
|`<leader> cer`             | Replace a line comment                                                                 | n   |
|`<leader> Cer`             | Replace a multiline comment                                                            | n   |
|`[n] <leader> ced`         | Delete entirely a line comment (delete also the line if empty after it)                | n/v |
|`<leader> ceD [motion]`    | Same with a motion after                                                               | n   |


#### Todo
- [ ] Delete a multiline comment ?
- [ ] Complete language list
- [ ] Repeat
- [ ] Embedded languages -_-'
