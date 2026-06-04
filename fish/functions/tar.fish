function tarc
 command tar --use-compress-program="pigz -r" -cvzf $argv    
end