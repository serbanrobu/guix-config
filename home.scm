;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu home services)
  (gnu home services shells)
  (gnu packages admin)
  (gnu packages gnuzilla)
  (gnu packages image-viewers)
  (gnu packages rust-apps)
  (gnu packages shells)
  (gnu packages suckless)
  (gnu packages terminals)
  (gnu packages version-control)
  (gnu packages vim)
  (gnu packages xdisorg)
  (gnu packages xorg)
  (gnu services)
  (guix gexp))

(home-environment
  (packages (list alacritty
                  bat
                  dmenu
                  exa
                  feh
                  fish
                  git
                  htop
                  icecat
                  pfetch
                  neovim
                  ripgrep
                  sxhkd
                  xrandr
                  zoxide))
  (services
    (list (service
            home-bash-service-type
            (home-bash-configuration
              (aliases
                '(("grep" . "grep --color=auto")
                  ("ll" . "ls -l")
                  ("ls" . "ls -p --color=auto")))

              (bashrc
                (list (local-file ".bashrc" "bashrc")))

              (bash-profile
                (list (local-file ".bash_profile" "bash_profile")))))

          (service
            home-fish-service-type
            (home-fish-configuration
              (aliases
                `(("ls" . ,(file-append exa "/bin/exa"))
                  ("ll" . "ls -l")
                  ("la" . "ls -a")
                  ("lla" . "ls -la")
                  ("vim" . ,(file-append neovim "/bin/nvim"))))

              (config
                (list (local-file ".config/fish/config.fish")))))

          (simple-service 'config
                          home-xdg-configuration-files-service-type
                          (list `("bspwm/bspwmrc" 
                                  ,(local-file ".config/bspwm/bspwmrc" 
                                               #:recursive? #t))

                                `("sxhkd/sxhkdrc"
                                  ,(local-file ".config/sxhkd/sxhkdrc"))

                                `("nvim/init.vim"
                                  ,(plain-file "init.vim"
                                    (string-append "set expandtab\n"
                                                   "set relativenumber\n"
                                                   "set shiftwidth=2\n"
                                                   "set smartindent\n"
                                                   "set tabstop=2\n")))

                                `("alacritty/alacritty.yml"
                                  ,(mixed-text-file "alacritty"
                                     "shell:\n"
                                     "  program: " fish "/bin/fish\n")))))))
