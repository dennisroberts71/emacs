(put 'dired-find-alternate-file 'disabled nil)

;; Load any machine-specific customizations first.
(add-to-list 'load-path "~/.emacs.d")
(load "local" 'missing-ok)

;; Add the marmalade repo to the list of repositories.
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(ac-nrepl
    auto-complete
    cider
    clojure-mode
    clojure-project-mode
    clojure-test-mode
    clojurescript-mode
    find-file-in-project
    idle-highlight-mode
    ido-ubiquitous
    inf-ruby
    levenshtein
    magit
    markdown-mode
    melpa
    paredit
    project-mode
    rainbow-delimiters
    smex
    starter-kit
    starter-kit-bindings
    starter-kit-eshell
    starter-kit-js
    starter-kit-lisp
    starter-kit-ruby))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(add-to-list 'load-path "/usr/local/share/git-core/contrib/emacs")

;; Use cperl mode instead of the default perl mode.
(defalias 'perl-mode 'cperl-mode)

;; Turn autoindenting on.
(global-set-key "\r" 'newline-and-indent)

;; Use 4 space indents via cperl mode.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cperl-close-paren-offset -4)
 '(cperl-continued-statement-offset 4)
 '(cperl-indent-level 4)
 '(cperl-indent-parens-as-block t)
 '(cperl-tab-always-indent t)
 '(safe-local-variable-values (quote ((eval define-clojure-indent (trap (quote defun))) (whitespace-line-column . 80) (lexical-binding . t))))
 '(yaml-indent-offset 2))

;; Insert spaces instead of tabs.
(setq-default indent-tabs-mode nil)

;; Enable column number mode by default.
(column-number-mode)

;; Use % to match various kinds of brackets.
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (let ((prev-char (char-to-string (preceding-char)))
        (next-char (char-to-string (following-char))))
    (cond ((string-match "[[{(<]" next-char) (forward-sexp 1))
          ((string-match "[\]})>]" prev-char) (backward-sexp 1))
          (t (self-insert-command (or arg 1))))))

;; Highlight matching parentheses.
(show-paren-mode 1)

;; Enable paredit for clojure mode.
(defun enable-paredit () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'enable-paredit)

;; Enable rainbow delimiters for clojure mode.
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

;; Restore the original keybinding for paredit-wrap-round.
(add-hook 'paredit-mode-hook
          '(lambda ()
             (define-key paredit-mode-map "\M-(" 'paredit-wrap-round)))

;; Some more useful keybindings for clojure mode.
(add-hook 'clojure-mode-hook
          '(lambda ()
             (define-key clojure-mode-map "\M-[" 'paredit-wrap-square)))
(add-hook 'clojure-mode-hook
          '(lambda ()
             (define-key clojure-mode-map "\M-{" 'paredit-wrap-curly)))

;; Enable eldoc in Clojure buffers.
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

;; Hide special buffers.
(setq nrepl-hide-special-buffers t)

;; Make C-c C-z switch to the Cider REPL buffer in the current window.
(setq cider-repl-display-in-current-window t)

;; Add some helpful submodes to Cider.
(add-hook 'cider-repl-mode-hook 'subword-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

;; Enable auto-complete for Cider.
(require 'ac-nrepl)
(add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
(add-hook 'cider-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'cider-repl-mode))

;; Use the tab key for auto-complete.
(defun set-auto-complete-as-completion-at-point-function ()
  (setq 'completion-at-point-functions '(auto-complete)))
(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-repl-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)

;; Automatically use markdown mode for files with a .md or .markdown extension.
(setq auto-mode-alist (cons '("\\.markdown$" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.md$" . markdown-mode) auto-mode-alist))

;; Set the fill column and enable auto-fill mode for markdown mode.
(add-hook 'markdown-mode-hook 'auto-fill-mode)
(add-hook 'markdown-mode-hook
          (lambda ()
            (set-fill-column 80)))

;; Git support.
(require 'git)
(require 'git-blame)

;; Always delete trailing whitespace before saving a file.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Provide a keybinding for setting the frame name.
(global-set-key (kbd "s-I") 'set-frame-name)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
