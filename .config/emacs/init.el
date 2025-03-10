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
(global-auto-revert-mode +1)

;; Delete selection if you insert
(delete-selection-mode +1)

;; Highlight matching paren
(show-paren-mode +1)

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
  :init (savehist-mode)
  :custom `((savehist-file . ,(locate-user-emacs-file "savehist"))))

;; VERTical Interactive COmpletion
(use-package vertico
  :custom (
    ;; (vertico-scroll-margin 0) ;; Different scroll margin
    (vertico-count 10) ;; Show more candidates
    ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
    (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  )
  :init (vertico-mode)
  :ensure t)

;; Use standard package
;(fido-vertical-mode +1)

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; Completion style for matching regexps in any order
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  :ensure t)

;; Enrich existing commands with completion annotations
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

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
