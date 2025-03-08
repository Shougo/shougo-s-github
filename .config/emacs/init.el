;; Disable help C-h mapping
(global-set-key (kbd "C-h") 'delete-backward-char)

;; Use *scratch* buffer as initial buffer
(setq inhibit-startup-message t)
(setq initial-scratch-message ";; Welcome to Emacs!\n\n")
(setq initial-buffer-choice t)

;; Disable toolbar and menubar
(tool-bar-mode -1)
(menu-bar-mode -1)

;; straight.el
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

;(leaf leaf-convert
;  :doc "Convert many format to leaf format"
;  :ensure t)
;
;(leaf autorevert
;  :doc "revert buffers when files on disk change"
;  :global-minor-mode global-auto-revert-mode)
;
;(leaf delsel
;  :doc "delete selection if you insert"
;  :global-minor-mode delete-selection-mode)
;
;(leaf paren
;  :doc "highlight matching paren"
;  :global-minor-mode show-paren-mode)
;
;(leaf simple
;  :doc "basic editing commands for Emacs"
;  :custom ((kill-read-only-ok . t)
;           (kill-whole-line . t)
;           (eval-expression-print-length . nil)
;           (eval-expression-print-level . nil)))
;
;(leaf files
;  :doc "file input and output commands for Emacs"
;  :global-minor-mode auto-save-visited-mode
;  :custom `((auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
;            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
;                                        (,tramp-file-name-regexp . nil)))
;            (version-control . t)
;            (delete-old-versions . t)
;            (auto-save-visited-interval . 1)))
;
;(leaf savehist
;  :doc "Save minibuffer history"
;  :custom `((savehist-file . ,(locate-user-emacs-file "savehist")))
;  :global-minor-mode t)
;
;(leaf flymake
;  :doc "A universal on-the-fly syntax checker"
;  :bind ((prog-mode-map
;          ("M-n" . flymake-goto-next-error)
;          ("M-p" . flymake-goto-prev-error))))
;
;(leaf which-key
;  :doc "Display available keybindings in popup"
;  :ensure t
;  :global-minor-mode t)
;
;(leaf exec-path-from-shell
;  :doc "Get environment variables such as $PATH from the shell"
;  :ensure t
;  :defun (exec-path-from-shell-initialize)
;  :custom ((exec-path-from-shell-check-startup-files)
;           (exec-path-from-shell-variables . '("PATH" "GOPATH" "JAVA_HOME")))
;  :config
;  (exec-path-from-shell-initialize))
;
;(leaf vertico
;  :doc "VERTical Interactive COmpletion"
;  :ensure t
;  :global-minor-mode t)
;
;(leaf marginalia
;  :doc "Enrich existing commands with completion annotations"
;  :ensure t
;  :global-minor-mode t)
;
;(leaf consult
;  :doc "Consulting completing-read"
;  :ensure t
;  :hook (completion-list-mode-hook . consult-preview-at-point-mode)
;  :defun consult-line
;  :preface
;  (defun c/consult-line (&optional at-point)
;    "Consult-line uses things-at-point if set C-u prefix."
;    (interactive "P")
;    (if at-point
;        (consult-line (thing-at-point 'symbol))
;      (consult-line)))
;  :custom ((xref-show-xrefs-function . #'consult-xref)
;           (xref-show-definitions-function . #'consult-xref)
;           (consult-line-start-from-top . t))
;  :bind (;; C-c bindings (mode-specific-map)
;         ([remap switch-to-buffer] . consult-buffer) ; C-x b
;         ([remap project-switch-to-buffer] . consult-project-buffer) ; C-x p b
;
;         ;; M-g bindings (goto-map)
;         ([remap goto-line] . consult-goto-line)    ; M-g g
;         ([remap imenu] . consult-imenu)            ; M-g i
;         ("M-g f" . consult-flymake)
;
;         ;; C-M-s bindings
;         ("C-s" . c/consult-line)       ; isearch-forward
;         ("C-M-s" . nil)                ; isearch-forward-regexp
;         ("C-M-s s" . isearch-forward)
;         ("C-M-s C-s" . isearch-forward-regexp)
;         ("C-M-s r" . consult-ripgrep)
;
;         (minibuffer-local-map
;          :package emacs
;          ("C-r" . consult-history))))
;
;(leaf affe
;  :doc "Asynchronous Fuzzy Finder for Emacs"
;  :ensure t
;  :custom ((affe-highlight-function . 'orderless-highlight-matches)
;           (affe-regexp-function . 'orderless-pattern-compiler))
;  :bind (("C-M-s r" . affe-grep)
;         ("C-M-s f" . affe-find)))
;
;(leaf orderless
;  :doc "Completion style for matching regexps in any order"
;  :ensure t
;  :custom ((completion-styles . '(orderless))
;           (completion-category-defaults . nil)
;           (completion-category-overrides . '((file (styles partial-completion))))))
;
;(leaf embark-consult
;  :doc "Consult integration for Embark"
;  :ensure t
;  :bind ((minibuffer-mode-map
;          :package emacs
;          ("M-." . embark-dwim)
;          ("C-." . embark-act))))
;
;(leaf corfu
;  :doc "COmpletion in Region FUnction"
;  :ensure t
;  :global-minor-mode global-corfu-mode corfu-popupinfo-mode
;  :custom ((corfu-auto . t)
;           (corfu-auto-delay . 0)
;           (corfu-auto-prefix . 1)
;           (corfu-popupinfo-delay . nil)) ; manual
;  :bind ((corfu-map
;          ("C-s" . corfu-insert-separator))))
;
;(leaf cape
;  :doc "Completion At Point Extensions"
;  :ensure t
;  :config
;  (add-to-list 'completion-at-point-functions #'cape-file))
;
;(leaf eglot
;  :doc "The Emacs Client for LSP servers"
;  :hook ((clojure-mode-hook . eglot-ensure))
;  :custom ((eldoc-echo-area-use-multiline-p . nil)
;           (eglot-connect-timeout . 600)))
;
;(leaf eglot-booster
;  :when (executable-find "emacs-lsp-booster")
;  :vc ( :url "https://github.com/jdtsmith/eglot-booster")
;  :global-minor-mode t)
;

;; Eat: Emulate A Terminal
(use-package eat
  :ensure t)

;; Emacs libvterm integration
(use-package vterm
  :ensure t)

;; MisTTY, a shell/comint alternative with a fully functional terminal
(use-package mistty
  :ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(leaf)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
