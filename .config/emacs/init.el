;; Disable help C-h mapping
(global-set-key (kbd "C-h") 'delete-backward-char)

;; Use *scratch* buffer as initial buffer
(setq inhibit-startup-message t)
(setq initial-scratch-message ";; Welcome to Emacs!\n\n")
(setq initial-buffer-choice t)

;; Change theme
(load-theme 'tango-dark t)

;; Change font size
(set-face-attribute 'default nil :height 140)

;; Disable toolbar and menubar
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Revert buffers when files on disk change
(global-auto-revert-mode 1)

;; Delete selection if you insert
(delete-selection-mode 1)

;; Highlight matching paren
(show-paren-mode 1)

;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;;

;; Fallback to straight.el
(setq straight-use-package-by-default t)

;; init-loader
(use-package init-loader)

;; Set custom file
(setq custom-file (locate-user-emacs-file "custom.el"))

;; Emacs libvterm integration
(use-package vterm
  :ensure t)

;; MisTTY, a shell/comint alternative with a fully functional terminal
(use-package mistty
  :ensure t)
;; Save minibuffer history
(use-package savehist
  :custom `((savehist-file . ,(locate-user-emacs-file "savehist"))))

;; Display available keybindings in popup
(use-package which-key
  :ensure t)

;; VERTical Interactive COmpletion
(use-package vertico
  :ensure t)

;; Enrich existing commands with completion annotations
(use-package marginalia
  :ensure t)

;; Enrich existing commands with completion annotations
(use-package consult
  ;; "Consulting completing-read"
  :ensure t
  :hook (completion-list-mode-hook . consult-preview-at-point-mode))

;; Asynchronous Fuzzy Finder for Emacs
(use-package affe
  :ensure t
  :custom ((affe-highlight-function . 'orderless-highlight-matches)
           (affe-regexp-function . 'orderless-pattern-compiler)))

;; Completion style for matching regexps in any order
(use-package orderless
  :ensure t)

;; Consult integration for Embark
(use-package embark-consult
  :ensure t)

;; COmpletion in Region FUnction
(use-package corfu
  :ensure t)

;; Completion At Point Extensions
(use-package cape
  :ensure t
  :config
  (add-to-list 'completion-at-point-functions #'cape-file))

