function nvims --wraps='nvim --cmd "let g:noserver=v:true"' --description 'alias nvims nvim --cmd "let g:noserver=v:true"'
  nvim --cmd "let g:noserver=v:true" $argv
        
end
