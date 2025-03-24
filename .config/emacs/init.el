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
  :ensure t
  :init (vertico-mode)
  :custom (
    ;; (vertico-scroll-margin 0) ;; Different scroll margin
    (vertico-count 10) ;; Show more candidates
    ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
    (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  ))

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
  :ensure t

  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; Enrich existing commands with completion annotations
(use-package marginalia
  :ensure t

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

;; Enable icons in marginalia
;; M-x all-the-icons-install-fonts
;(use-package all-the-icons
;  :if (display-graphic-p))
;(use-package all-the-icons-completion
;  :after (marginalia all-the-icons)
;  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
;  :init
;  (all-the-icons-completion-mode))

;; Enrich existing commands with completion annotations
(use-package consult
  :ensure t
  :hook (completion-list-mode-hook . consult-preview-at-point-mode))

;; Asynchronous Fuzzy Finder for Emacs
(use-package affe
  :ensure t
  :custom ((affe-highlight-function . 'orderless-highlight-matches)
           (affe-regexp-function . 'orderless-pattern-compiler)))

;; Embark actions
(use-package embark
  :ensure t

  ;; When inside the minibuffer, `embark' can collect/export the
  ;; contents to a fully fledged Emacs buffer.  The `embark-collect'
  ;; command retains the original behaviour of the minibuffer, meaning
  ;; that if you navigate over the candidate at hit RET, it will do what
  ;; the minibuffer would have done.  In contrast, the `embark-export'
  ;; command reads the metadata to figure out what category this is and
  ;; places them in a buffer whose major mode is specialised for that
  ;; type of content.  For example, when we are completing against
  ;; files, the export will take us to a `dired-mode' buffer; when we
  ;; preview the results of a grep, the export will put us in a
  ;; `grep-mode' buffer.
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         :map minibuffer-local-map
         ("C-c C-b" . embark-become)
         ("C-c C-c" . embark-collect)
         ("C-c C-e" . embark-export))

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult integration for Embark
(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; COmpletion in Region FUnction
(use-package corfu
  :ensure t
  :custom ((corfu-auto nil)
           (corfu-auto-delay 0.2)
           (corfu-auto-prefix 2)
           (corfu-cycle t)
           (corfu-on-exact-match t)
           (corfu-quit-no-match 'separator)
           (tab-always-indent 'complete))
  :bind (nil
         :map corfu-map
         ("TAB" . corfu-insert)
         ("<tab>" . corfu-insert)
         ("RET" . nil)
         ("<return>" . nil))
  :init
  (global-corfu-mode +1)

  :config
  (defun my/corfu-remap-tab-command ()
    (global-set-key [remap c-indent-line-or-region] #'indent-for-tab-command))
  (add-hook 'java-mode-hook #'my/corfu-remap-tab-command)

  ;; https://github.com/minad/corfu#completing-in-the-minibuffer
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
                (bound-and-true-p vertico--input))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)

  (add-hook 'eshell-mode-hook (lambda ()
                                (setq-local corfu-auto nil)
                                (corfu-mode)))

  ;; Use corfu on lsp-mode
  (with-eval-after-load 'lsp-mode
    (setq lsp-completion-provider :none)))

;; Enable corfu on terminal
;; NOTE: Only required below Emacs 31
(straight-use-package
 '(corfu-terminal
   :type git
   :repo "https://codeberg.org/akib/emacs-corfu-terminal.git"))
(unless (display-graphic-p)
  (corfu-terminal-mode +1))

(use-package corfu-candidate-overlay
   :straight (:type git
              :repo "https://code.bsdgeek.org/adam/corfu-candidate-overlay"
              :files (:defaults "*.el"))
   :after corfu
   :config
   ;; enable corfu-candidate-overlay mode globally
   ;; this relies on having corfu-auto set to nil
   (corfu-candidate-overlay-mode +1)
   ;; bind Ctrl + TAB to trigger the completion popup of corfu
   (global-set-key (kbd "C-<tab>") 'completion-at-point)
   ;; bind Ctrl + Shift + Tab to trigger completion of the first candidate
   ;; (keybing <iso-lefttab> may not work for your keyboard model)
   (global-set-key (kbd "C-<iso-lefttab>") 'corfu-candidate-overlay-complete-at-point))

;; Completion At Point Extensions
(use-package cape
  :ensure t
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  ;; Alternatively bind Cape commands individually.
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  ;; ...
)
