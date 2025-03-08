;; Disable help C-h mapping
(global-set-key (kbd "C-h") 'delete-backward-char)

;; Use *scratch* buffer as initial buffer
(setq inhibit-startup-message t)
(setq initial-scratch-message ";; Welcome to Emacs!\n\n")
(setq initial-buffer-choice t)

;; Disable toolbar and menubar
(tool-bar-mode -1)
(menu-bar-mode -1)
