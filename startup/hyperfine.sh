hyperfine --warmup 3 "nvim -c qa!" || true
hyperfine --warmup 3 "nvim -u NONE -c qa" || true
hyperfine --warmup 3 "/usr/bin/vim -u NONE -c qa" || true
hyperfine --warmup 3 "/usr/bin/vim -c qa" || true

nvim  -e \
  -c 'verbose python3 import platform;print("Python3 v" + platform.python_version())' \
  -c 'qa!'
# https://stackoverflow.com/questions/12213597/how-to-see-which-plugins-are-making-vim-slow
# python <(curl -sSL https://raw.githubusercontent.com/hyiltiz/vim-plugins-profile/master/vim-plugins-profile.py) nvim
nvim  --cmd 'profile start /tmp/profile.log' \
  --cmd 'profile func *' \
  --cmd 'profile file *' \
  -c 'profdel func *' \
  -c 'profdel file *' \
  -c 'profile pause *' \
  -c 'qa!'
hyperfine --warmup 3 "nvim -u NONE -c qa!" || true
hyperfine --warmup 3 "nvim -c qa!" || true
