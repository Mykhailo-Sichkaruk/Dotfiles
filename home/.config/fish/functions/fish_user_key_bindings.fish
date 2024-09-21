function fish_user_key_bindings
  fish_vi_key_bindings
  bind -k nul -M insert accept-autosuggestion
  bind \cg forget_last_command
  bind --mode insert \cg forget_last_command
end
