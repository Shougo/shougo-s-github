;; Disable toolbar and menubar
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Use *scratch* buffer as initial buffer
(setopt inhibit-startup-message t)
(setopt inhibit-startup-screen t)
(setopt initial-scratch-message ";; Welcome to Emacs!\n\n")
(setopt initial-buffer-choice t)

;; Change theme
(load-theme 'tango-dark t)

;; Change font size
(set-face-attribute 'default nil :height 140)

