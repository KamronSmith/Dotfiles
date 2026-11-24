;;; init.el --- Kam's personal init.el file -*- lexical-binding: t -*-

;;; Summary:

;;; Commentary:

;;; Code:
(defvar kam-emacs-cache-directory
  (concat user-emacs-directory "cache/")
  "Directory containing temporary files for Emacs.")

(when (not (file-exists-p kam-emacs-cache-directory))
  (make-directory kam-emacs-cache-directory t))

(use-package package
  :demand t
  :ensure nil
  :custom
  (package-archives
   '(("gnu-elpa"       . "https://elpa.gnu.org/packages/")
     ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
     ("nongnu"         . "https://elpa.nongnu.org/nongnu/")
     ("melpa"          . "https://melpa.org/packages/")))

  (package-vc-register-as-project nil)
  (package-install-upgrade-built-in t)
  (package-native-compile t)
  (package-vc-allow-build-commands t)
  :config
  (package-initialize))

(use-package native-compile
  :ensure nil
  :custom
  (native-comp-async-report-warnings-errors 'silent)
  (native-comp-async-on-battery-power nil)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Compile-Log\\*"
                 (display-buffer-no-window)
                 (allow-no-window . t)))

  ;; (with-eval-after-load 'consult
  ;;   (add-to-list 'consult-buffer-filter "\\*Async-native-compile-log\\*" t)
  ;;   (add-to-list 'consult-buffer-filter "\\*Native-compile-Log\\*" t)
  ;;   (add-to-list 'consult-buffer-filter "\\*Compile-Log\\*" t))
  )

(use-package exec-path-from-shell
  :demand t
  :config
  (setopt exec-path-from-shell-shell-name (executable-find "zsh"))
  (setopt exec-path-from-shell-variables '("PATH"
                                           "MANPATH"
                                           "SHELL"
                                           "SSH_AUTH_SOCK"
                                           "GNUPGHOME"
                                           "LANG"
                                           "DISPLAY"
                                           "WAYLAND_DISPLAY"
                                           "XDG_DATA_HOME"
                                           "GIT_SSH_SIGNING_PROGRAM"
                                           "XDG_CONFIG_HOME"
                                           "HYPRLAND_INSTANCE_SIGNATURE"))
  (exec-path-from-shell-initialize))

(use-package emacs
  :ensure nil
  :init
  (defvar-keymap kam-repeat-map
    :doc "General repeat map"
    :repeat t)

  (defvar-keymap kam-override-mode-map
    :doc "Keymap for `kam-override-mode'.
Enable that mode to its keybindings take over those of the major mode.")

  (define-minor-mode kam-override-mode
    "Enable the `kam-override-mode-map'."
    :init-value nil
    :global t
    :keymap kam-override-mode-map)

  :hook ((after-init . kam-emacs-setup)
         (after-save . executable-make-buffer-file-executable-if-script-p)
         (visual-line-mode . visual-wrap-prefix-mode)
         (occur-mode . kam-occur-mode-setup)
         (occur-edit-mode . kam-occur-edit-setup))
  :bind
  ([remap revert-buffer] . kam-revert-buffer)
  ("TAB" . nil)
  ("<escape>" . kam-keyboard-escape-quit-dwim)
  ("<home>" . nil)
  ("<end>" . nil)
  ("<up>" . nil)
  ("<down>" . nil)
  ("<left>" . nil)
  ("<right>" . nil)
  ("C-d" . delete-forward-char)
  ("C-g" . kam-keyboard-escape-quit-dwim)
  ("C-j" . kam-join-line-dwim)
  ([kam-m] . back-to-indentation)
  ("C-o" . kam-open-line-dwim)
  ("C-w" . kam-kill-dwim)
  ("C-t" . transpose-chars)
  ("C-v" . undo)
  ("C-y" . kam-yank)
  ("C-q" . quoted-insert)
  ("C-z" . repeat)
  ("C-SPC" . set-mark-command)
  ("C-<left>" . kam-prev-buffer)
  ("C-<right>" . kam-next-buffer)
  ("C-<backspace>" . kam-control-backspace)
  ("C-<return>" . kam-insert-new-line-below)
  ("C-_" . nil)
  ("C-:" . pp-eval-expression)
  ("C-|" . nil)
  ("C-`" . nil)
  ("C-(" . insert-parentheses)
  ("C-)" . nil)
  ("C-~" . nil)
  ("C-%" . kam-query-replace-dwim)
  ("M-c" . capitalize-dwim)
  ("M-i" . kam-indent-dwim)
  ("M-l" . downcase-dwim)
  ("M-m" . kam-mark-line)
  ("M-n" . forward-paragraph)
  ("M-p" . backward-paragraph)
  ("M-q" . fill-paragraph)
  ("M-r" . kam-duplicate-dwim)
  ("M-t" . transpose-words)
  ("M-u" . upcase-dwim)
  ("M-v" . undo-redo)
  ("M-w" . kam-kill-ring-save-dwim)
  ("M-z" . zap-up-to-char)
  ("M-!" . async-shell-command)
  ("M-;" . comment-dwim)
  ("M-:" . pp-eval-expression)
  ("M-<return>" . kam-insert-new-line-above)
  ("M-SPC" . mark-word)
  ("M-DEL" . kam-control-backspace)
  ("C-h c" . describe-char)
  ("C-x 3" . nil)
  ("C-x <left>" . kam-prev-buffer)
  ("C-x <right>" . kam-next-buffer)
  ("C-x k" . kam-kill-current-buffer)
  ("C-x n" . kam-narrow-or-widen-dwim)
  ("C-x C-c" . kam-os-restart-emacs)
  ("C-x <kam-m>" . count-words)
  ("C-x C-n" . nil)
  ("C-x C-e" . kam-eval-current-sexp)
  ("C-x C-u" . nil)
  ("C-x C-z" . nil)
  ("C-c <tab>" . indent-relative)
  ("C-c q" . insert-char)
  ("C-M-<left>" . indent-rigidly-left)
  ("C-M-<right>" . indent-rigidly-right)
  ("C-M-," . nil)
  ("C-M-SPC" . mark-sexp)
  ("C-M-(" . insert-parenthesis)
  ("C-M-=" . indent-region)
  ("C-M-b" . backward-sexp)
  ("C-M-d" . down-list)
  ("C-M-f" . forward-sexp)
  ("C-M-k" . kill-sexp)
  ("C-M-j" . raise-sexp)
  ("C-M-n" . forward-list)
  ("C-M-p" . backward-list)
  ("C-M-t" . transpose-sexps)
  ("C-M-u" . backward-up-list)
  ("C-M-y" . kam-yank-undo)
  ("C-M-z" . kam-delete-pair-dwim)
  ("C-c w" . kam-writing-mode)
  ("<kam-i>" . indent-for-tab-command)
  (:map search-map
        ("M-o" . occur))
  (:map occur-mode-map
        ("w" . occur-edit-mode))
  (:map goto-map
        ("M-c" . goto-char)
        ("M-n" . next-error)
        ("M-p" . previous-error))
  (:map ctl-x-x-map
        ("g" . kam-revert-buffer))
  (:repeat-map kam-repeat-map
               ("M-n" . next-error-no-select)
               ("M-p" . previous-error-no-select))
  :custom
  (user-full-name "Kamron Smith")
  (user-mail-address "kamrosmith@gmail.com")
  (user-lisp-directory (locate-user-emacs-file "lisp/"))
  (inhibit-splash-screen nil)
  (delete-pair-push-mark t)
  (delete-pair-blink-delay 0)
  (view-lossage-auto-refresh t)
  (create-lockfiles nil)
  (confirm-kill-emacs nil)
  (confirm-kill-processes nil)
  (initial-major-mode 'lisp-interaction-mode)
  (auto-save-file-name-transforms
   `((".*" ,(expand-file-name "auto-saves/\\1" kam-emacs-cache-directory) t)))
  (auto-save-interval 20)
  (auto-save-no-message t)
  (auto-save-timeout 3)
  (auto-save-list-file-prefix (expand-file-name "auto-saves/sessions/" kam-emacs-cache-directory))
  (backup-directory-alist `(("." . ,(expand-file-name "backups/" kam-emacs-cache-directory))))
  (make-backup-files t)
  (backup-inhibited nil)
  (backup-by-copying t)
  (backup-by-copying-when-mismatch t)
  (version-control t)
  (delete-old-versions t)
  (kill-buffer-delete-auto-save-files nil)
  (confirm-kill-emacs nil)
  (confirm-kill-processes nil)
  (confirm-non-existent-file-or-buffer nil)
  (use-short-answers t)
  (initial-scratch-message "")
  (delete-by-moving-to-trash t)
  (custom-file (make-temp-file "emacs-custom-"))
  (set-mark-command-repeat-pop t)
  (use-dialog-box nil)
  (use-file-dialog nil)
  (ad-redefinition-action 'accept)
  (list-matching-lines-default-context-lines 1)
  (tooltip-reuse-hidden-frame t)
  (tooltip-use-echo-area t)
  (undo-limit (* 13 160000))
  (undo-strong-limit (* 13 240000))
  (undo-outer-limit (* 13 24000000))
  (save-interprogram-paste-before-kill t)
  (mouse-drag-and-drop-region-cross-program t)
  (mouse-drag-and-drop-region-scroll-margin t)
  (fill-region-as-paragraph-function 'fill-region-as-paragraph-default)
  (font-log nil)
  (eval-expression-print-length nil)
  (echo-keystokes-help nil)
  (kill-do-not-save-duplicates t)
  (line-move-visual t)
  (sentence-end-double-space nil)
  (next-line-add-newlines t)
  (make-cursor-line-fully-visible t)
  (inhibit-compacting-font-caches nil)
  (blink-cursor-delay 0.85)
  (blink-cursor-interval 0.65)
  (blink-cursor-blinks 0)
  (locale-coding-system 'utf-8)
  (switch-to-prev-buffer-skip-regexp '("\\*Backtrace\\*"
                                       "\\*Warnings\\*"
                                       "\\*Compile-Log\\*"
                                       "\\*Completions\\*"
                                       "\\*Async-native-compile-log\\*"
                                       "\\*Native-compile-Log\\*"))
  (large-file-warning-threshold nil)
  (find-ls-options '("-exec ls -ldh {} +" . "-ldh"))
  (redisplay-skip-fontification-on-input t)
  (yank-transform-functions '(string-trim-left string-trim-right string-chop-newline))
  (view-read-only t)
  (duplicate-region-final-position 1)
  (duplicate-line-final-position -1)
  (exchange-point-and-mark-highlight-region nil)
  (kill-ring-max 500)
  (kill-whole-line t)
  (narrow-to-defun-include-comments t)
  (x-gtk-use-system-tooltips nil)
  (x-select-enable-clipboard t)
  (x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
  (x-underline-at-descent-line t)
  (x-stretch-cursor nil)
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  (global-so-long-mode 1)
  (global-prettify-symbols-mode 1)
  (global-font-lock-mode 1)
  (blink-cursor-mode 1)
  (editorconfig-mode 1)
  (kam-override-mode 1)

  (setq-default comment-column 0)
  (setq-default fill-column 100)
  (setq-default line-spacing nil)
  (prefer-coding-system 'utf-8)
  (set-language-environment "UTF-8")
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)

  (remq 'process-kill-buffer-query-function
        kill-buffer-query-functions)

  (setenv "GPG_AGENT_INFO" nil)

  (defun kam-font-setup ()
    "Setup for the font faces."
    (if (daemonp)
        (add-hook 'after-make-frame-functions
                  (lambda (frame)
                    (with-selected-frame frame
                      (set-face-attribute 'default nil :font "Aporetic Sans Mono" :height 150 :weight 'regular :width 'regular)
                      (set-face-attribute 'fixed-pitch nil :font "Aporetic Sans Mono" :height 1.0 :weight 'regular :width 'regular)
                      (set-face-attribute 'variable-pitch nil :family "Newsreader" :height 1.0 :weight 'regular :width 'regular))))
      (set-face-attribute 'default nil :font "Aporetic Sans Mono" :height 150 :weight 'regular :width 'regular)
      (set-face-attribute 'fixed-pitch nil :font "Aporetic Sans Mono" :height 1.0 :weight 'regular :width 'regular)
      (set-face-attribute 'variable-pitch nil :family "Newsreader" :height 1.0 :weight 'regular :width 'regular)))

  (defun kam-emacs-setup ()
    "Setup function for Emacs.
Basic OS settings and if in the terminal. To be used in to `after-init-hook'."
    (kam-when-system-type 'gnu/linux
      (setopt x-meta-keysym 'meta))
    (kam-when-system-type 'darwin
      (global-text-scale-adjust 1)
      (setopt mac-option-key-is-meta t)
      (setopt mac-command-key-is-meta t)
      (setopt mac-control-modifier 'control)
      (setopt mac-command-modifier 'meta)
      (setopt mac-option-modifier 'meta)
      (setopt trash-directory (expand-file-name ".Trash" kam-home-directory))
      (setopt insert-directory-program (executable-find "gls"))
      (menu-bar-mode)
      (add-to-list 'default-frame-alist '(ns-appearance . dark))
      (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
      (require 'kam-mac))
    (kam-font-setup))

  (put 'narrow-to-region 'disabled nil)

  (add-to-list 'find-file-not-found-functions #'kam-find-file-auto-create-missing-dirs)

  (keymap-global-set "C-M-(" 'insert-parentheses)
  (keymap-global-set "C-\"" 'kam-insert-quote)
  (keymap-global-set "M-\"" 'kam-insert-quote)

  (when (not (file-exists-p (expand-file-name "auto-saves" kam-emacs-cache-directory)))
    (make-directory (expand-file-name "auto-saves" kam-emacs-cache-directory))))

(use-package minibuffer
  :ensure nil
  :hook ((minibuffer-setup . cursor-intangible-mode)
         (minibuffer-setup . kam-minibuffer-mode-setup)
         (minibuffer-setup . minibuffer-regexp-mode)
         (minibuffer-setup . minibuffer-nonselected-mode)
         (minibuffer-exit . kam-minibuffer-exit))
  :bind
  (:map minibuffer-local-map
        ("<kam-i>" . completion-at-point))
  :custom
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  (resize-mini-windows nil)
  (resize-mini-frames nil)
  (enable-recursive-minibuffers t)
  (read-answer-short t)
  (minibuffer-visible-completions 'up-down)
  (crm-prompt (format "%s %%p" (propertize "[%d]" 'face 'shadow)))
  :config
  (defun kam-minibuffer-mode-setup ()
    "Setup function for `minibuffer-mode'."
    (setopt gc-cons-threshold most-positive-fixnum)
    (setopt-local truncate-lines t)
    ;; (setopt-local line-spacing '(1 . 1))
    (face-remap-add-relative 'default :height 1.1))

  (defun kam-minibuffer-exit ()
    "Function for settings as the minibuffer exits."
    (setopt gc-cons-threshold (* 1000 1000 8))))

(use-package completion
  :ensure nil
  :bind
  (:map minibuffer-visible-completions-up-down-map
        ("C-n" . minibuffer-next-completion)
        ("C-p" . minibuffer-previous-completion))
  :custom
  (completions-detailed t)
  (completion-cycle-threshold 1)
  (completion-eager-update t)
  (completion-eager-display t)
  (tab-always-indent 'complete)
  (completion-auto-help t)
  (completion-show-help nil)
  (completion-show-inline-help nil)
  (completions-max-height 20)
  (completions-format 'one-column)
  (completions-group t)
  (completion-auto-select t)
  (completions-sort 'historical)
  (completion-ignore-case t)
  (completions-sort 'historical)
  (read-file-name-completion-ignore-case t)
  (completion-pcm-leading-wildcard t)
  (read-buffer-completion-ignore-case t)
  (read-extended-command-predicate #'command-completion-default-include-p))

(use-package completion-preview
  :ensure nil
  :bind
  (:map completion-preview-active-mode-map
        ("M-n" . completion-preview-next-candidate)
        ("M-p" . completion-preview-prev-candidate)
        ("<kam-i>" . completion-preview-complete))
  :custom
  (completion-preview-minimum-symbol-length 2)
  (completion-preview-exact-match-only t)
  (completion-preview-commands '(self-insert-command
                                 insert-char
                                 analyze-text-conversion
                                 completion-preview-insert-word))
  (completion-preview-idle-delay 0.3)
  (completion-preview-ignore-case t)
  (completion-preview-sort-function #'identity)
  :config
  (with-eval-after-load 'org
    (push 'org-self-insert-command completion-preview-commands))

  (with-eval-after-load 'standard-themes
    (standard-themes-with-colors
      (custom-set-faces
       `(completion-preview-exact ((,c :foreground ,fg-dim))))))

  (add-hook 'completion-preview-inhibit-functions
            #'kam-org-at-table-p))

(use-package ibuffer
  :ensure nil
  :bind
  (([remap list-buffers] . ibuffer)
   (:map ibuffer-mode-map
         ("C-c C-n" . ibuffer-forward-filter-group)
         ("C-c C-p" . ibuffer-backward-filter-group)))
  :hook ((ibuffer-mode . lin-mode)
         (ibuffer-mode . (lambda ()
                           (ibuffer-switch-to-saved-filter-groups "Default"))))
  :custom
  (ibuffer-human-readable-size t)
  (ibuffer-show-empty-filter-groups nil)
  (ibuffer-use-header-line 'title)
  (ibuffer-saved-filter-groups
   '(("Default"
      ("Emacs Lisp" (mode . emacs-lisp-mode))
      ("Python" (mode . python-mode))
      ("Shell" (or (mode . shell-mode)
                   (mode . eshell-mode)))
      ("Nix" (mode . nix-mode))
      ("Org" (mode . org-mode))
      ("Dired" (mode . dired-mode))
      ("Magit" (name . "^magit.*:"))
      ("Xref" (name . "^\\*xref\\*$"))
      ("Emacs" (or
                (name . "^\\*Customize\\*$")
                (name . "^\\*scratch\\*$")
                (name . "^\\*Messages\\*$")
                (name . "^\\*Backtrace\\*$")
                (name . "^\\*Help\\*$")
                (name . "^\\*RE-Builder\\*$")
                (name . "^\\*Async-native-compile-log\\*$")
                (name . "^\\*Packages\\*$")
                (name . "^\\*Alerts\\*$")))
      ("Music" (or (mode . emms-playlist-mode)
                   (mode . emms-browser-mode)
                   (mode . emms-show-all-mode)))
      ("EWW" (mode . eww-mode)))))
  :config
  (add-to-list 'ibuffer-formats "Recency"))

(use-package window
  :ensure nil
  :bind
  ("C-l" . recenter-top-bottom)
  ("C-x 0" . kam-delete-window-dwim)
  ("C-x C-0" . kam-delete-window-dwim)
  ("C-x 1" . kam-toggle-delete-other-windows)
  ("C-x C-1" . kam-toggle-delete-other-windows)
  ("C-x 3" . kam-split-window-right)
  ("C-x C-3" . kam-split-window-right)
  ("C-<next>" . scroll-other-window)
  ("C-<prior>" . scroll-other-window-down)
  ([remap quit-window] . kam-quit-window)
  (:repeat-map kam-repeat-map
               ("<left>" . kam-prev-buffer)
               ("<right>" . kam-next-buffer))
  :bind
  (:map window-prefix-map
        ("u" . winner-undo))
  :custom
  ;; (window-sides-slots '(0 0 1 1))
  (split-window-preferred-direction 'horizontal)
  (split-window-preferred-function 'kam-split-window-conservatively)
  (split-height-threshold nil)
  (split-width-threshold 0)
  (even-window-sizes t)
  (cursor-in-non-selected-windows nil)
  (next-error-recenter '(4))
  (window-combination-resize t)
  (switch-to-buffer-in-dedicated-window 'pop)
  (switch-to-buffer-obey-display-actions t)
  (switch-to-buffer-preserve-window-point t)
  (switch-to-prev-buffer-skip nil)
  (truncate-partial-width-windows nil)
  (quit-window-kill-buffer nil)
  (kill-buffer-quit-windows nil)
  (scroll-conservatively 0)
  (scroll-margin 0)
  (scroll-preserve-screen-position t)
  (next-screen-context-lines 20)
  (display-buffer-base-action '((display-buffer-reuse-window
                                 display-buffer-pop-up-window
                                 display-buffer-same-window)))
  (display-buffer-alist
   '(("\\*Backtrace\\*"
      (display-buffer-reuse-window display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.35)
      (window-parameters . ((mode-line-format . none))))
     ("^\\*Occur\\*"
      (display-buffer-reuse-mode-window
       display-buffer-pop-up-window
       display-buffer-use-least-recent-window)
      (mode occur-mode))
     ("^\\*Pacman: "
      (display-buffer-reuse-window display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.35)
      (window-parameters . ((mode-line-format . none))))))
  :config
  (require 'kam-window)
  (winner-mode 1)

  (advice-add 'switch-to-buffer :around 'kam-display-command-same-window))

(use-package kam-comment
  :ensure nil
  :bind
  ("C-M-;" . kam-comment-todo)
  :custom
  (comment-empty-lines t)
  (comment-multi-line t)
  (comment-style 'multi-line))

(use-package kam-os
  :demand t
  :ensure nil)

(use-package kam-dotfiles
  :after (kam-os)
  :ensure nil
  :commands
  (kam-dotfiles-stow
   kam-dotfiles-restow))

(use-package lin
  :ensure t
  :custom
  (lin-face 'lin-yellow))

(use-package centered-cursor-mode
  :ensure t
  :hook ((minibuffer-setup . kam-centered-cursor-mode-disable)
         (centered-cursor-mode . kam-centered-cursor-mode-remove-hook)
         (after-init . global-centered-cursor-mode))
  :bind
  (:map ccm-map
        ("C-v" . nil)
        ("M-v" . nil)
        ("<prior>" . nil)
        ("<next>" . nil))
  :custom
  (ccm-recenter-at-end-of-file t)
  :config
  (defun kam-centered-cursor-mode-disable ()
    "Disable `centered-cursor-mode'."
    (centered-cursor-mode -1))

  (defun kam-centered-cursor-mode-remove-hook ()
    "Remove `ccm-vpos-recenter' from hooks."
    (when (seq-contains-p window-configuration-change-hook 'ccm-vpos-recenter)
      (remove-hook 'window-configuration-change-hook 'ccm-vpos-recenter t)))

  (defun kam-centered-cursor-mode-advice (orig-fn &rest args)
    "Call ORIG-FN with ARGS while temporarily disabling `centered-cursor-mode'."
    (when (bound-and-true-p centered-cursor-mode)
      (setopt-local centered-cursor-mode nil)
      (apply orig-fn args)
      (setopt-local centered-cursor-mode t)))

  (add-to-list 'ccm-ignored-commands
               'ultra-scroll)

  (add-to-list 'ccm-ignored-commands
               'kam-keyboard-escape-quit-dwim))

(use-package pixel-scroll
  :ensure nil
  :bind
  (:map pixel-scroll-precision-mode-map
        ("<prior>" . kam-scroll-up)
        ("<next>" . kam-scroll-down)))

(use-package ultra-scroll
  :ensure t
  :hook (after-init . ultra-scroll-mode))

(use-package dired
  :ensure nil
  :hook ((dired-mode . hl-line-mode)
         (dired-mode . dired-hide-details-mode)
         (dired-after-readin . kam-dired-directory-add-to-history))
  :bind
  (:map dired-mode-map
        ("<mouse-2>" . dired-mouse-find-file)
        ("b" . dired-up-directory)
        ("o" . dired-do-open)
        ("R" . dired-do-rename)
        ("\\" . dired-create-empty-file)
        ("C-w" . dired-do-delete)
        ("M-w" . dired-copy-filename-as-kill)
        ([kam-i] . kam-split-window-right))
  :custom
  (dired-listing-switches "-AGFhlv --group-directories-first --time-style=long-iso")
  (dired-clean-confirm-killing-deleted-buffers nil)
  (dired-confirm-shell-command nil)
  (dired-no-confirm t)
  (dired-deletion-confirmer '(lambda (x) t))
  (dired-recursive-deletes 'always)
  (dired-recursive-copies 'always)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-dwim-target t)
  (dired-movement-style 'bounded-files)
  (dired-auto-revert-buffer nil)
  (dired-make-directory-clickable t)
  (dired-create-empty-file-in-current-directory t)
  (dired-free-space 'separate)
  (dired-mouse-drag-files t)
  (image-dired-dir (expand-file-name "image-dired/" kam-emacs-cache-directory))
  (dired-guess-shell-alist-user
   '(("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "xdg-open")
     ("\\.\\(png\\|jpe?g\\|tiff\\)" "xdg-open")
     (".*" "xdg-open")))
  :config
  (put 'dired-find-alternate-file 'disabled nil)
  (add-to-list 'display-buffer-alist
               '((major-mode . dired-mode)
                 display-buffer-pop-up-window
                 display-buffer-same-window)))

(use-package dired-x
  :ensure nil
  :after (dired)
  :custom
  (dired-clean-up-buffers-too t)
  (dired-clean-confirm-killing-deleted-buffers nil))

(use-package dired-aux
  :ensure nil
  :after (dired)
  :custom
  (dired-isearch-filenames 'dwim)
  (dired-create-destination-dirs 'always)
  (dired-do-revert-buffer (lambda (dir) (not (file-remote-p dir))))
  (dired-create-destination-dirs-on-trailing-dirsep t)
  (dired-compress-file-default-suffix ".zip")
  (dired-compress-directory-default-suffix ".zip"))

(use-package dired-open
  :ensure t)

(use-package dired-rainbow
  :ensure t)

(use-package wdired
  :ensure nil
  :hook (wdired-mode . kam-wdired-mode-setup)
  :bind
  (:map dired-mode-map
        ("w" . wdired-change-to-wdired-mode))
  :custom
  (wdired-allow-to-change-permissions t)
  (wdired-create-parent-directories t)
  (wdired-use-dired-vertical-movement 'sometimes)
  :config
  (defun kam-wdired-mode-setup ()
    "Setup function for `wdired-mode'."
    (if hide-cursor-mode
        (hide-cursor-mode -1)
      (hide-cursor-mode 1))
    (if hl-line-mode
        (hl-line-mode -1)
      (hl-line-mode 1)))

  (defun kam-wdired-run-hooks (&rest _)
    "Run `wdired-mode-hook'."
    (run-mode-hooks 'wdired-mode-hook))

  (advice-add 'wdired-change-to-dired-mode :after 'kam-wdired-run-hooks))

(use-package dired-subtree
  :after (dired)
  :ensure t
  :bind
  (:map dired-mode-map
        ("<tab>" . dired-subtree-toggle)
        ("TAB" . dired-subtree-toggle)
        ;; ("C-<tab>" . kam-dired-subtree-up-toggle)
        )
  :config
  (defun kam-dired-subtree-up-toggle ()
    "Goes to the parent subtree and toggles the visibility of it."
    (interactive)
    (dired-subtree-up)
    (dired-subtree-toggle)))

(use-package image-dired
  :ensure nil
  :commands (image-dired)
  :bind
  (:map image-dired-thumbnail-mode-map
        ("<return>" . image-dired-thumbnail-display-external))
  :custom
  (image-dired-thumbnail-storage 'standard)
  (image-dired-thumbnail-external-viewer "xdg-open")
  (image-dired-thumb-size 80)
  (image-dired-thumb-margin 2)
  (image-dired-thumb-relief 0)
  (image-dired-thumbs-per-row 4))

(use-package kam-dired
  :after (dired)
  :ensure nil
  :hook (dired-mode . kam-dired-imenu-setup)
  :bind
  (:map dired-mode-map
        ("R" . kam-dired-do-rename)
        ("i" . kam-dired-insert-subdir)
        ("X" . kam-dired-do-destroy)
        ("C-c C-n" . kam-dired-subdirectory-next)
        ("C-c C-p" . kam-dired-subdirectory-previous)))

(use-package trashed
  :ensure t
  :commands (trashed)
  :hook ((trashed-mode . hide-cursor-mode)
         (trashed-mode . lin-mode))
  :bind
  ("C-c t" . kam-trashed)
  :custom
  (trashed-action-confirmer 'y-or-n-p)
  (trashed-use-header-line t)
  (trashed-sort-key '("Date deleted" . t))
  :config
  (setq trashed-buffer-name "*Trash*")
  (setq trashed-trash-dir kam-trash-directory)
  (setq trashed-files-dir (or (kam-when-system-type 'gnu/linux
                                (expand-file-name "files" kam-trash-directory))
                              (kam-when-system-type 'darwin
                                kam-trash-directory)))
  (setq trashed-info-dir (or (kam-when-system-type 'gnu/linux
                               (expand-file-name "files" kam-trash-directory))
                             (kam-when-system-type 'darwin
                               kam-trash-directory)))

  (defun kam-trashed ()
    "Either run `trashed' or open the system trash can."
    (interactive)
    (if (kam-when-system-type 'darwin t)
        (dired kam-trash-directory "-AGFhlt --time-style=long-iso")
      (call-interactively #'trashed)
      (setq this-command 'trashed))))

(use-package emureader
  :ensure t
  :bind
  (:map emureader-mode-map
        ("SPC" . emureader-next-page)
        ("<backspace>" . emureader-previous-page)
        ("C-SPC" . kam-emureader-goto-saved-page)
        ("M-g M-i" . kam-emureader-imenu))
  :config
  (defvar kam-emureader-saved-page nil
    "Saved page for `emureader-mode'")

  (defun kam-emureader-save-page (n)
    (interactive (list
                  (emureader-current-doc-pagenumber)))
    (setopt kam-emureader-saved-page n))

  (defun kam-emureader-goto-saved-page ()
    (interactive)
    (let* ((prev-pg-number (emureader-current-doc-pagenumber)))
      (emureader-goto-page kam-emureader-saved-page)
      (kam-emureader-save-page prev-pg-number)))

  (defun kam-emureader-imenu ()
    "Call `imenu', but save the current page number in `kam-emureader-saved-page'."
    (interactive)
    (kam-emureader-save-page (emureader-current-doc-pagenumber))
    (consult-imenu)))

(use-package repeat
  :ensure nil
  :custom
  (repeat-on-final-keystroke t)
  (repeat-exit-timeout 1.0)
  (repeat-exit-key "C-g")
  (repeat-keep-prefix t)
  (repeat-check-key t)
  (repeat-echo-function 'ignore)
  :config
  (repeat-mode))

(use-package bookmark
  :ensure nil
  :commands (bookmark-set bookmark-jump bookmark-bmenu-list)
  :hook (bookmark-bmenu-mode . hl-line-mode)
  :custom
  (bookmark-use-annotations nil)
  (bookmark-automatically-show-annotations nil)
  (bookmark-fringe-mark nil)
  (bookmark-save-flag 1)
  (bookmark-file (expand-file-name "bookmarks" kam-emacs-cache-directory)))

(use-package register
  :ensure nil
  :custom
  (register-use-preview t)
  :config
  (with-eval-after-load 'savehist
    (add-to-list 'savehist-additional-variables 'register-alist)))

(use-package kmacro
  :ensure nil
  :bind
  (:map kmacro-keymap
        ("I" . kmacro-insert-macro))
  :config
  (with-eval-after-load 'savehist
    (add-to-list 'savehist-additional-variables 'kmacro-ring))

  (defalias 'kmacro-insert-macro 'insert-keyboard-macro)

  (add-to-list 'display-buffer-alist
               '("\\*Edit Macro\\*"    ;; Edit keyboard macro interface
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-same-window)
                 (mode . edmacro-mode))))

(use-package imenu
  :ensure nil
  :custom
  (imenu-auto-rescan t)
  (org-imenu-depth 4))

(use-package font-lock
  :ensure nil
  :custom
  (font-lock-maximum-decoration 2))

(use-package jit-lock
  :ensure nil
  :custom
  (jit-lock-defer-time 0.05)
  (jit-lock-stealth-time 1.0)
  (jit-lock-stealth-nice 0.2)
  (jit-lock-stealth-chunk 512)
  (jit-lock-context-time 0.5))

(use-package help
  :ensure nil
  :hook (help-mode . lin-mode)
  :bind
  (:map help-mode-map
        ("q" . kam-quit-window)
        ("p" . backward-paragraph)
        ("n" . forward-paragraph)
        ("j" . forward-button)
        ("k" . backward-button)
        ("SPC" . kam-scroll-down)
        ("<backspace>" . kam-scroll-up)
        ("<mouse-9>" . help-go-back)
        ("<next>" . scroll-down-line)
        ("<prior>" . scroll-up-line))
  (:map help-map
        ("p" . describe-package)
        ("y" . describe-keymap)
        ("C-k" . find-function-on-key))
  :custom
  (help-window-select t)
  (help-window-keep-selected t)
  :config
  (defvar-keymap kam-help-apropos-map
    :doc "Keymap for apropos subcommands."
    "a"   #'apropos
    "l"   #'apropos-library
    "f"   #'apropos-function
    "x"   #'apropos-command
    "v"   #'apropos-variable
    "V"   #'apropos-local-variable
    "u"   #'apropos-user-option
    "d"   #'apropos-documentation
    "C-f" #'customize-apropos-faces
    "g"   #'customize-apropos-groups
    "o"   #'customize-apropos-options
    "c"   #'customize-apropos
    "i"   #'info-apropos)

  (keymap-set help-map "a" kam-help-apropos-map)

  (add-to-list 'display-buffer-alist
               '((major-mode . help-mode)
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-use-least-recent-window)
                 (mode help-mode)))

  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*Error\\*"
  ;;                (display-buffer-reuse-window display-buffer-in-side-window)
  ;;                (side . bottom)
  ;;                (window-width . 0.35)
  ;;                (mode help-mode)
  ;;                (window-parameters . ((mode-line-format . none)
  ;;                                      (no-delete-other-windows . t)))))

  (with-eval-after-load 'consult
    ;; (add-to-list 'consult-buffer-filter
    ;;              "^\\*Help\\*" t)
    (add-to-list 'consult-buffer-filter
                 "^\\*Error\\*" t)
    ;; (add-to-list 'consult-buffer-filter
    ;;              "\\*Messages\\*" t)
    )

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*Shell Command\\*" t)
  ;; (add-to-list 'switch-to-prev-buffer-skip-regexp
  ;;              "\\*Messages\\*" t)
  ;; (add-to-list 'switch-to-prev-buffer-skip-regexp
  ;;              "\\*Help\\*" t)
  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*Error\\*" t))

(use-package apropos
  :after (consult)
  :ensure nil
  :hook (apropos-mode . lin-mode)
  :bind
  ("C-h F" . apropos-function)
  ("C-h V" . apropos-variable)
  :custom
  (apropos-compact-layout nil)
  (apropos-do-all nil)
  :config

  (add-to-list 'display-buffer-alist
               '("\\*Apropos\\*"
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-use-least-recent-window)
                 (mode apropos-mode)))
  ;; (add-to-list 'consult-buffer-filter
  ;;              "\\*Apropos\\*")
  )

(use-package info
  :ensure nil
  :hook (Info-mode . lin-mode)
  :bind
  ("C-h r" . info-display-manual)
  ("C-h R" . info-emacs-manual)
  (:map Info-mode-map
        ("M-[" . Info-history-back)
        ("<mouse-9>" . Info-history-back)
        ("M-]" . Info-history-forward)
        ("P" . Info-prev)
        ("N" . Info-next)
        ("n" . forward-paragraph)
        ("p" . backward-paragraph)
        ("M-n" . forward-paragraph)
        ("M-p" . backward-paragraph)
        ("j" . Info-next-reference)
        ("k" . Info-prev-reference)
        ("<next>" . scroll-down-line)
        ("<prior>" . scroll-up-line))
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Info\\*"
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-use-least-recent-window)
                 (mode Info-mode)))

  ;; (add-to-list 'switch-to-prev-buffer-skip-regexp
  ;;              "^\\*Info\\*" t)

  ;; (with-eval-after-load 'consult
  ;;  (add-to-list 'consult-buffer-filter
  ;;               "^\\*Info\\*" t)
  )

(use-package man
  :ensure nil
  :hook (Man-mode . lin-mode)
  :bind
  ("M-s M-m" . man)
  :custom
  (Man-notify-method 'aggressive)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Man "
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-use-least-recent-window)
                 (mode . Man-mode)))

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "^\\*Man " t)

  ;; (with-eval-after-load 'consult
  ;;   (add-to-list 'consult-buffer-filter
  ;;                "^\\*Man " t))
  )

(use-package re-builder
  :ensure nil
  :bind
  (:map reb-mode-map
        ("RET" . newline)
        ("C-c RET" . kam-re-builder-replace-regexp)
        ("C-c <tab>" . reb-change-syntax)
        ("C-g" . reb-quit)
        :map reb-lisp-mode-map
        ("RET" . newline)
        ("C-c RET" . kam-re-builder-replace-regexp)
        ("C-c <tab>" . reb-change-syntax)
        ("C-g" . reb-quit))
  :custom
  (reb-re-syntax 'rx)
  :config
  (defvar kam-re-builder-positions nil
    "Store point and region bounds before calling `re-builder'.")

  (defun kam-re-builder-save-state (&rest _)
    "Save point and region into `kam-rebuilder-positions'.
This function is meant to be run :before `re-builder'."
    (setopt kam-re-builder-positions
            (cons (point)
                  (when (region-active-p)
                    (list (region-beginning)
                          (region-end))))))

  (advice-add 're-builder :before 'kam-re-builder-save-state)

  (defun kam-re-builder-replace-regexp (&optional delimited)
    "Run `query-replace-regexp' with the contents of `re-builder'.
With non-nil optional argument DELIMITED, only replace matches
surrounded by actual boundaries."
    (interactive "P")
    (reb-update-regexp)
    (let* ((re (reb-target-value 'reb-regexp))
           (replacement (query-replace-read-to
                         re
                         (concat "Query replace"
                                 (if current-prefix-arg
                                     (if (eq current-prefix-arg '-) " backward" " word")
                                   "")
                                 " regexp"
                                 (if (with-selected-window reb-target-window
                                       (region-active-p))
                                     " in region" ""))
                         t))
           (pnt (car kam-re-builder-positions))
           (beg (cadr kam-re-builder-positions))
           (end (caddr kam-re-builder-positions)))
      (with-selected-window reb-target-window
        (goto-char pnt)
        (setopt kam-re-builder-positions nil)
        (reb-quit)
        (query-replace-regexp re replacement delimited beg end)))))

(use-package tramp
  :ensure nil
  :custom
  (tramp-encoding-shell (executable-find "sh"))
  (sh-shell-file (executable-find "sh"))
  (tramp-default-remote-shell (executable-find "sh"))
  (tramp-persistency-file-name (expand-file-name "tramp/tramp-persistence" kam-emacs-cache-directory))
  (tramp-auto-save-directory (expand-file-name "tramp/" kam-emacs-cache-directory))
  (tramp-copy-size-limit (* 2 1024 1024)) ;; 2MB
  (tramp-use-scp-direct-remote-copying t)
  (tramp-verbose 1)                     ; just warnings
  (remote-file-name-inhibit-delete-by-moving-to-trash t)
  (remote-file-name-inhibit-auto-save t)
  (remote-file-name-inhibit-locks t)
  (remote-file-name-inhibit-auto-save-visited t)
  :config
  (add-to-list 'tramp-connection-properties
               (list (regexp-quote "/sudo::")
                     "login-program" (executable-find "env")))

  (add-to-list 'tramp-connection-properties
               (list (regexp-quote "/sudo::")
                     "remote-shell" (executable-find "env")))

  (connection-local-set-profile-variables
   'remote-direct-async-process
   '((tramp-direct-async-process . t)))

  (connection-local-set-profiles
   '(:application tramp :protocol "scp")
   'remote-direct-async-process))

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :custom
  (recentf-autosave-interval 300)
  (recentf-max-saved-items 5000)
  (recentf-max-menu-items 5000)
  ;; (recentf-auto-cleanup (if (daemonp) 300 'never))
  (recentf-exclude '("^/\\(?:ssh\\|su\\|sudo\\)?:"))
  (recentf-save-file (expand-file-name "recentf" kam-emacs-cache-directory))
  (recentf-show-messages nil)
  (recentf-suppress-open-file-help nil)
  (recentf-filename-handlers nil)
  (recentf-exclude
   (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
         "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
         "\\.7z$" "\\.rar$"
         "COMMIT_EDITMSG\\'"
         "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
         "-autoloads\\.el$" "autoload\\.el$"
         "\\/sudoedit:root"
         "~\\'"))
  :config
  ;; (add-hook 'kill-emacs-hook #'recentf-cleanup -90)
  )

(use-package ispell
  :ensure nil
  :custom
  (text-mode-ispell-word-completion nil)
  (ispell-program-name (executable-find "aspell")))

(use-package autorevert
  :ensure nil
  :hook (after-init . global-auto-revert-mode)
  :custom
  (auto-revert-verbose nil)
  (auto-revert-remote-files nil)        ; t makes tramp slow
  (auto-revert-avoid-polling t)
  (global-auto-revert-non-file-buffers t)
  (auto-revert-interval 2))

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :custom
  (history-length 1000)
  (history-delete-duplicates t)
  (savehist-save-minibuffer-history t)
  (savehist-file (expand-file-name "savehist" kam-emacs-cache-directory))
  (savehist-additional-variables '(kill-ring
                                   mark-ring global-mark-ring
                                   search-ring regexp-search-ring)))

(use-package warnings
  :ensure nil
  :custom
  (warning-minimum-level :error))

(use-package proced
  :ensure nil
  ;;   :commands (proced)
  :hook (proced-mode . kam-proced-mode-setup)
  :bind
  ("C-c p" . proced)
  :custom
  (proced-auto-update-flag 'visible)
  (proced-enable-color-flag t)
  (proced-auto-update-interval 1)
  (proced-descend t)
  (proced-filter 'user)
  :config
  (defun kam-proced-mode-setup ()
    "Setup function for `proced-mode'."
    (proced-toggle-auto-update 1)))

(use-package rectangular-region-mode
  :ensure nil
  :custom
  (rectangle-indicate-zero-width-rectangle nil))

(use-package time-date
  :ensure nil
  :custom
  (display-time-24hr-format t)
  (display-time-day-and-date nil)
  (display-time-default-load-average 0)
  :config
  ;; TODO: Figure out why this doesnt work
  (display-time-mode))

(use-package server
  :ensure nil)

(use-package ligature
  :ensure t
  :config
  ;; default configuration for Iosevka font
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++"))
  (global-ligature-mode t))

(use-package unicode-fonts
  :ensure t
  :config
  (unicode-fonts-setup))

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode)
  :bind
  (:map vertico-map
        ("<kam-i>" . vertico-insert)
        ("<escape>" . kam-keyboard-escape-quit-dwim)
        ("<next>" . vertico-scroll-up)
        ("<prior>" . vertico-scroll-down)
        ("M-<return>" . vertico-exit-input)
        ("C-c C-n" . vertico-next-group)
        ("C-c C-p" . vertico-previous-group)
        ("M-w" . vertico-save)
        ("M-<" . vertico-first)
        ("M->" . vertico-last)
        ("<up>" . nil)
        ("<down>" . nil)
        ("C-<return>" . minibuffer-force-complete-and-exit)
        ("C-g" . kam-keyboard-escape-quit-dwim))
  (:repeat-map kam-repeat-map
               ("C-n" . vertico-next-group)
               ("C-p" . vertio-previous-group))
  :custom
  (vertico-resize nil)
  (vertico-cycle t)
  (vertico-scroll-margin (/ vertico-count 2))
  (vertico-preselect 'prompt)
  (vertico-count 15))

(use-package vertico-quick
  :after (vertico)
  :ensure nil
  :bind
  (:map vertico-map
        ("M-j" . vertico-quick-exit))
  :custom
  (vertico-quick1 "dnreta")
  (vertico-quick2 "columq"))

(use-package vertico-directory
  :after (vertico)
  :ensure nil
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :bind
  (:map vertico-map
        ("<backspace>" . vertico-directory-delete-char)
        ("C-<backspace>" . vertico-directory-delete-word)))

(use-package vertico-multiform
  :after (vertico)
  :ensure nil
  :hook (after-init . vertico-multiform-mode)
  :config
  (defvar kam-vertico-multiform-maximal
    '((vertico-count . 15)
      (vertico-resize . nil))
    "List of configurations for maximal Vertico multiform.")

  (defvar kam-vertico-multiform-minimal
    '(flat
      (vertico-count . 10)
      (vertico-cycle . nil))
    "List of configurations for minimal Vertico multiform.")

  (setopt vertico-multiform-categories
          `((embark-keybinding grid)
            (file (vertico-sort-override-function . vertico-sort-history-alpha)
                  (:keymap . vertico-directory-map))))

  (setopt vertico-multiform-commands
          '((jinx-correct grid (vertico-grid-annotate . 20))
            (consult-buffer (vertico-sort-override-function . nil)
                            (vertico-sort-function . nil))
            (link-menu-open (vertico-sort-function . nil))))

  (vertico-multiform-mode 1))

(use-package vertico-sort
  :after (vertico)
  :ensure nil)

(use-package consult
  :ensure t
  :bind
  ([remap Info-search] . consult-info)
  ([repeat-complex-command] . consult-complex-command)
  ([remap goto-line] . consult-goto-line)
  ([remap yank-pop] . consult-yank-pop)
  ([remap bookmark-jump] . consult-bookmark)
  ([remap switch-to-buffer] . consult-buffer)
  ([remap imenu] . kam-consult-project-imenu)
  ([remap load-theme] . consult-theme)
  ("C-M-x" . consult-mode-command)
  ("C-x C-b" . consult-buffer)
  ("C-x r s" . consult-register-store)
  ("C-x r l" . consult-register-load)
  (:map search-map
        ("M-f" . consult-fd)
        ("M-g" . consult-ripgrep)
        ("M-k" . consult-keep-lines)
        ("M-u" . consult-focus-lines)
        ;; ("M-l" . consult-line)
        ("M-d" . consult-line))
  (:map goto-map
        ("M-e" . consult-compile-error)
        ("M-i" . imenu)
        ("M-m" . consult-mark)
        ("M-k" . consult-global-mark))
  (:map isearch-mode-map
        ("M-r" . consult-isearch-history))
  (:map minibuffer-local-map
        ("M-s" . consult-history)
        ("M-r" . consult-history))
  (:map project-prefix-map
        ("l" . consult-line-multi)
        ("i" . consult-imenu-multi)
        ("b" . consult-project-buffer))
  :custom
  (register-preview-delay 0)
  (register-preview-function #'consult-register-format)
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)
  (consult-narrow-key ">")
  (consult-async-min-input 3)
  (consult-buffer-list-function #'buffer-list)
  (consult-preview-key 'any)
  (consult-ripgrep-args
   "rg --null --follow --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --search-zip --hidden --glob=!.git ")
  (consult-fd-args "fd --follow --hidden --full-path --color=never ")
  :config
  (advice-add #'register-preview :override #'consult-register-window)
  ;; (add-to-list 'consult-preview-allowed-hooks 'global-org-modern-mode)
  (add-to-list 'consult-preview-allowed-hooks 'visual-line-mode)
  (add-to-list 'consult-preview-allowed-hooks 'decolorify-mode)
  (add-to-list 'consult-preview-allowed-hooks 'display-line-numbers-mode)

  (advice-add 'consult--jump :around 'kam-centered-cursor-mode-advice)
  (advice-add 'consult--jump :around 'kam-display-command-same-window)
  (advice-add 'consult-buffer :after (lambda (&rest _) (recenter)))

  (dolist (cmd '(consult-buffer consult-ripgrep consult-fd))
    (advice-add cmd :before (lambda (&rest _) (push-mark (point) t nil))))

  (add-to-list 'consult-buffer-filter
               "-shell\\*$")
  (add-to-list 'consult-buffer-filter
               "\\*Customize ")
  (add-to-list 'consult-buffer-filter
               "-eshell\\*$"))

(use-package kam-consult
  :after (consult)
  :ensure nil
  :bind
  (:map search-map
        ("M-p" . kam-consult-line-symbol-at-point)
        ("M-r" . kam-consult-ripgrep-symbol-at-point))
  (:map goto-map
        ("M-o" . kam-consult-outline))
  (:map isearch-mode-map
        ("M-s M-l" . kam-consult-isearch))
  (:map help-map
        ("s" . kam-consult-search-emacs-info-pages))
  :custom
  (consult-preview-excluded-buffers 'kam-consult-preview-excluded-buffer-p)
  (read-file-name-function #'kam-consult-find-file-with-preview)
  (project-read-file-name-function #'kam-consult-project-find-file-with-preview)
  :config
  (add-hook 'minibuffer-setup-hook #'kam-consult--no-prompt-preview 90)

  (setopt consult-buffer-sources
          '(kam-consult-source-buffer
            ;; consult-source-project-buffer
            kam-consult-source-project-files
            kam-consult-source-project
            kam-consult-source-neighbor-file
            kam-consult-source-bookmark
            kam-consult-source-recent-file
            ;; kam-consult-source-dired-history
            consult-source-hidden-buffer)))

(use-package consult-dir
  :ensure t
  :bind
  (("C-x C-d" . consult-dir)
   :map minibuffer-local-map
   ("C-x C-d" . consult-dir)
   ("C-x C-j" . consult-dir-jump-file))
  :custom
  (consult-dir-shadow-filenames nil)
  (consult-dir-jump-file-command 'consult-fd)
  (consult-dir-default-command 'consult-dir-dired)
  :config
  (defvar kam-consult-dir--directories
    '("~/Documents"
      "~/Projects/"
      "~/Documents/Areas/"
      "~/Documents/Resources/"))

  (defun kam-consult-dir-jumps--get-dirs ()
    "Returns a flat list of directories based on `kam-consult-dir--directories'."
    (seq-filter
     #'file-directory-p
     (cl-mapcan
      #'identity
      (mapcar (lambda (dir)
                (directory-files dir t directory-files-no-dot-files-regexp))
              kam-consult-dir--directories))))

  (defvar kam-consult-dir--source-jumps
    `(:name "My directories"
            :narrow ?f
            :category file
            :face consult-file
            :history file-name-history
            :items kam-consult-dir-jumps--get-dirs))

  (setopt consult-dir-sources
          '(consult-dir--source-bookmark
            ;; kam-consult-source-dired-history
            consult-dir--source-default
            consult-dir--source-project
            consult-dir--source-recentf
            consult-dir--source-tramp-local
            ;; kam-consult-dir--source-jumps
            )))

;; (use-package consult-flycheck
;;   :after (consult flycheck)
;;   :ensure t
;;   :bind
;;   (:map goto-map
;;         ("M-l" . consult-flycheck)))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode)
  :custom
  (marginalia-field-width 100)
  (marginalia-align 'left)
  (marginalia-align-offset 20))

(use-package embark
  :after (vertico)  ;; load after vertico to avoid vertico-map is void error
  :ensure t
  :bind
  ([remap describe-bindings] . embark-bindings)
  ("C-." . embark-act)
  ("C-;" . embark-dwim)
  (:map minibuffer-local-map
        ("C-." . embark-act)
        ("C-c C-c" . embark-export)
        ("C-c C-b" . embark-become)
        ("C-c C-e" . embark-export))
  (:map embark-general-map
        ("SPC" . embark-cycle)
        ("." . embark-cycle))
  (:map embark-expression-map
        (";" . kam-comment-dwim))
  (:map embark-region-map
        ("a" . align-regexp))
  (:map embark-file-map
        ("s" . kam-sudo-find-file)
        ("S" . make-symbolic-link))
  (:map embark-become-file+buffer-map
        ("b" . consult-buffer)
        ("d" . consult-dir)
        ("l" . consult-locate)
        ("p" . project-find-file)
        ("r" . consult-recent-file)
        ("i" . kam-consult-project-imenu)
        ("C-b" . consult-buffer)
        ("<kam-i>" . kam-consult-project-imenu)
        ("C-f" . find-file)
        ("C-d" . consult-dir)
        ("C-p" . project-find-file)
        ("C-r" . consult-recent-file)
        ("C-l" . consult-locate))
  (:map embark-become-help-map
        ("u" . apropos-user-option)
        ("y" . describe-keymap)
        ("F" . apropos-function)
        ("C-f" . describe-function)
        ("C-p" . describe-package)
        ("C-s" . describe-symbol)
        ("C-v" . describe-variable)
        ("C-y" . describe-keymap))
  (:map embark-become-match-map
        ("r" . consult-ripgrep)
        ("f" . consult-fd)
        ("o" . occur)
        ("d" . consult-line)
        ("i" . kam-consult-project-imenu)
        ("k" . consult-keep-lines)
        ("C-r" . consult-ripgrep)
        ("C-f" . consult-fd)
        ("C-d" . consult-line)
        ("C-o" . occur)
        ("C-k" . consult-keep-lines)
        ("<kam-i>" . kam-consult-project-imenu))
  :custom
  (embark-quit-after-action nil)
  (prefix-help-command #'embark-prefix-help-command)
  (embark-prompter #'embark-keymap-prompter)
  (embark-indicators '(embark-highlight-indicator
                       embark-isearch-highlight-indicator)))

(use-package embark-consult
  :after (embark consult)
  :ensure t
  :bind
  (:map embark-consult-async-search-map
        ("r" . consult-ripgrep)
        ("f" . consult-fd)
        ("o" . occur)
        ("d" . consult-line)
        ("i" . kam-consult-project-imenu)
        ("k" . consult-keep-lines)
        ("C-r" . consult-ripgrep)
        ("C-f" . consult-fd)
        ("C-d" . consult-line)
        ("C-o" . occur)
        ("C-k" . consult-keep-lines)
        ("<kam-i>" . kam-consult-project-imenu)))

(use-package orderless
  :demand t
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))
                                   (command (styles kam-orderless-with-initialism))
                                   (variable (styles kam-orderless-with-initialism))
                                   (symbol (styles kam-orderless-with-initialism))))
  (orderless-component-separator #'orderless-escapable-split)
  (orderless-style-dispatchers (list #'kam-orderless-consult-dispatch
                                     #'orderless-kwd-dispatch
                                     #'orderless-affix-dispatch))
  :config
  (orderless-define-completion-style kam-orderless-with-initialism
    (orderless-matching-styles '(orderless-initialism orderless-literal orderless-regexp)))

  (defun kam-orderless--consult-suffix ()
    "Regexp which matches the end of string with Consult tofu support."
    (if (and (boundp 'consult--tofu-char)
             (boundp 'consult--tofu-range))
        (format "[%c-%c]*$"
                consult--tofu-char
                (+ consult--tofu-char consult--tofu-range -1))
      "$"))

  (defun kam-orderless-consult-dispatch (word _index _total)
    "Make regular expressions work with `orderless' in Consult sessions."
    (cond
     ((string-suffix-p "$" word)
      `(orderless-regexp . ,(concat (substring word 0 -1) (kam-orderless--consult-suffix))))
     ((and (or minibuffer-completing-file-name
               (derived-mode-p 'eshell-mode))
           (string-match-p "\\`\\.." word))
      `(orderless-regexp . ,(concat "\\." (substring word 1) (kam-orderless--consult-suffix)))))))

(use-package corfu
  :ensure t
  :hook (after-init . global-corfu-mode)
  :bind
  (:map corfu-map
        ("<return>" . corfu-insert)
        ("<kam-i>" . corfu-insert)
        ("C-<return>" . corfu-insert)
        ("M-SPC" . corfu-insert-separator)
        ("<next>" . corfu-scroll-up)
        ("<prior>" . corfu-scroll-down)
        ("C-g" . corfu-quit))
  :custom
  ;; (corfu-separator ?\s)
  ;; (corfu-min-width corfu-max-width)
  (corfu-auto nil)
  (corfu-auto-delay 0.2)
  (corfu-preselect 'first)
  (corfu-exact-match 'insert)
  (corfu-preview-current nil)
  (corfu-cycle t)
  (corfu-sort-override-function 'kam-corfu-combined-sort)
  :config
  (defun kam-corfu-combined-sort (candidates)
    "Sort CANDIDATES using both `display-sort-function' and `corfu-sort-function'."
    (let ((candidates
           (let ((display-sort-func (corfu--metadata-get 'display-sort-function)))
             (if display-sort-func
                 (funcall display-sort-func candidates)
               candidates))))
      (if corfu-sort-function
          (funcall corfu-sort-function candidates)
        candidates)))

  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

(use-package corfu-quick
  :ensure nil
  :after (corfu)
  :bind
  (:map corfu-map
        ("M-j" . corfu-quick-insert))
  :custom
  (corfu-quick1 "dnreta")
  (corfu-quick2 "dnreta"))

(use-package corfu-history
  :ensure nil
  :after (corfu)
  :hook (corfu-mode . corfu-history-mode)
  :config
  (with-eval-after-load 'save-hist
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package corfu-popupinfo
  :ensure nil
  :after (corfu)
  :hook (corfu-mode . corfu-popupinfo-mode))

(use-package cape
  :ensure t
  :bind
  ("C-c h h" . cape-history)
  ("C-c h f" . cape-file)
  :hook ((prog-mode . kam-cape-prog-mode-setup)
         (text-mode . kam-cape-text-mode-setup))
  :custom
  (completion-at-point-functions '(cape-dabbrev cape-file))   ; global values
  :config
  (defun kam-cape-text-mode-setup ()
    "Setup `cape' for text."
    (setopt-local completion-at-point-functions
                  '(cape-dict
                    cape-dabbrev
                    cape-emoji)))

  (defun kam-cape-prog-mode-setup ()
    "Setup `cape' for programming."
    (setopt-local completion-at-point-functions
                  '(cape-file
                    cape-keyword
                    ;; cape-line
                    cape-dabbrev
                    t))))

(use-package avy
  :ensure t
  :bind
  ("M-j" . avy-goto-char-timer)
  (:map isearch-mode-map
        ("M-j" . avy-isearch))
  :custom
  (avy-keys '(?d ?n ?r ?e ?t ?a ?s ?i))
  (avy-style 'at-full)
  (avy-timeout-seconds 1.0)
  :config
  (defun kam-avy-action-embark (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

  (defun kam-avy-action-xref-definition (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (xref-find-definitions (thing-at-point 'symbol t)))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

  (defun kam-avy-action-consult-line-at-point (pt)
    (goto-char pt)
    (kam-consult-line-symbol-at-point))

  (defun kam-avy-action-kam-kill-dwim (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (kam-kill-dwim))
      (select-window
       (cdr
        (ring-ref avy-ring 0))))
    t)

  (defun kam-avy-action-kam-kill-ring-save-dwim (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (kam-kill-ring-save-dwim))
      (select-window
       (cdr
        (ring-ref avy-ring 0))))
    t)

  (defun kam-avy-action-mark-to-char (pt)
    (activate-mark)
    (goto-char pt))

  (defun kam-avy-action-org-store-link (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (org-store-link nil t))
      (select-window
       (cdr
        (ring-ref avy-ring 0))))
    t)

  (defun kam-avy-action-org-refile (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (kam-org-refile-to-current-file))
      (select-window
       (cdr
        (ring-ref avy-ring 0))))
    t)

  (defun kam-avy-action-kill-inner-sexp (pt)
    (unwind-protect
        (progn
          (goto-char pt)
          (kam-kill-inner-sexp))
      (select-window
       (cdr
        (ring-ref avy-ring 0))))
    t)

  (setf (alist-get ?. avy-dispatch-alist) 'kam-avy-action-embark)
  (setf (alist-get ?w avy-dispatch-alist) 'kam-avy-action-kam-kill-dwim)
  (setf (alist-get ?h avy-dispatch-alist) 'kam-avy-action-kam-kill-ring-save-dwim)
  (setf (alist-get ?o avy-dispatch-alist) 'kam-avy-action-org-refile)
  (setf (alist-get ?\  avy-dispatch-alist) 'kam-avy-action-mark-to-char)
  (setf (alist-get ?l avy-dispatch-alist) 'kam-avy-action-org-store-link)
  (setf (alist-get ?p avy-dispatch-alist) 'kam-avy-action-consult-line-at-point)
  (setf (alist-get ?q avy-dispatch-alist) 'kam-avy-action-kill-inner-sexp))

(use-package ace-window
  :ensure t
  :commands (kam-ace-window ace-window)
  :config
  (setq aw-dispatch-always t)
  (setq aw-keys '(?d ?n ?r ?e ?t ?a))
  (setq aw-dispatch-alist
        '((?s aw-swap-window "Swap Windows")
          (?m aw-move-window "Move Window")
          (?c aw-copy-window "Copy Window")
          (?v aw-split-window-vert "Split Vert Window")
          (?h aw-split-window-horz "Split Horz Window")
          (?b kam-aw-consult-buffer "Select Buffer")
          (?f kam-aw-find-file "Find File")
          (?o kam-aw-one-command "Run command")
          (?x kam-aw-execute-extended-command "Run an interactive command")
          (?1 delete-other-windows "Delete Other Windows")
          (?0 kam-aw-delete-window-dwim "Delete Window")
          (?q kam-aw-delete-window-dwim "Delete Window")
          (?? aw-show-dispatch-help)))
  :bind
  (:map kam-override-mode-map
        ("M-o" . kam-ace-window)))

(use-package goto-chg
  :ensure t
  :bind
  ("C-M-<" . goto-last-change)
  ("C-M->" . goto-last-change-reverse))

;; (defun kam-tab-new-tab-one-command ()
;;   "Create a new tab and and run a command in the newly created tab."
;;   (interactive)
;;   (tab-new)
;;   (let* ((command (key-binding
;;                 (read-key-sequence
;;                  (format "Run in %s..." (tab-bar-tab-name-current)))))
;;       (this-command command))
;;     (call-interactively command)))

;; (use-package tab-bar
;;   :ensure nil
;;   :defer t
;;   :bind (:map tab-bar-mode-map
;;               ("C-x t n" . tab-next)
;;               ("C-x t p" . tab-previous)
;;               ("C-x t +" . tab-close)
;;               ("C-\\" . kam-consult-tab)
;;               ("C-<tab>" . nil)
;;               ("C-S-<tab>" . nil))
;;   :init
;;   (defun tab-bar-tab-group-format-default (tab _i &optional current-p)
;;     (propertize
;;      (concat (funcall tab-bar-tab-group-function tab))
;;      'face (if current-p 'tab-bar-tab-group-current 'tab-bar-tab-group-inactive)))
;;
;;   (tab-bar-mode 1)
;;   :custom
;;   (tab-bar-show nil)
;;   (tab-bar-close-button-show nil)
;;   (tab-bar-new-button nil)
;;   (tab-bar-tab-hints t)
;;   (tab-bar-auto-width nil)
;;   (tab-bar-separator " ")
;;   (tab-bar-format '(tab-bar-format-tabs-groups
;;                     tab-bar-format-tabs
;;                     tab-bar-separator))
;;   (tab-bar-format '(tab-bar-format-history tab-bar-format-tabs tab-bar-separator))
;;   :config
;;   (keymap-set ctl-x-map "t" nil)
;;   (defun kam-tab-bar-group-from-project ()
;;     "Call `tab-group' with the current project name as the group."
;;     (interactive)
;;     (when-let* ((proj (project-current))
;;                 (name (file-name-nondirectory
;;                        (directory-file-name (project-root proj)))))
;;       (tab-group (format "%s" name))))
;;
;;   (defun kam-tab-bar-show ()
;;     "Toggle the visibility of the tab bar."
;;     (interactive)
;;     (if tab-bar-show
;;         (setopt tab-bar-show nil)
;;       (setopt tab-bar-show t))))

;;; Isearch
(use-package isearch
  :ensure nil
  ;; :after (kam-search)
  :bind
  (:map isearch-mode-map
        ("C-." . kam-isearch-yank-symbol))
  :custom
  (isearch-lazy-count t)
  (isearch-lazy-count-prefix-format "(%s/%s)")
  (isearch-lazy-count-suffix-format nil)
  (isearch-repeat-on-direction-change t)
  (isearch-whitespace-regexp ".*?")
  (isearch-regexp-lax-whitespace t)
  (isearch-allow-scroll 'unlimited)
  (search-ring-max 1000)
  (regexp-search-ring-max 1000))

(use-package drag-stuff
  :ensure t
  :bind
  (("M-<up>" . drag-stuff-up)
   ("M-<down>" . drag-stuff-down)))

(use-package grep
  :ensure nil
  :hook ((grep-mode . kam-grep-mode-setup)
         (grep-edit-mode . kam-grep-edit-mode-setup))
  :bind
  (:map grep-mode-map
        ("C-c C-p" . compilation-previous-file)
        ("C-c C-n" . compilation-next-file)
        ("w" . grep-change-to-grep-edit-mode)
        ;; ("n" . compilation-next-error)
        ;; ("p" . compilation-previous-error)
        ("n" . kam-next-error-no-select)
        ("p" . kam-previous-error-no-select)
        ("<return>" . kam-compile-goto-error)
        ("}" . compilation-next-file)
        ("{" . compilation-previous-file))
  (:map grep-edit-mode-map
        ("C-c C-c" . grep-edit-save-changes))
  :custom
  (grep-program "ripgrep")
  ;; (grep-command "rg -nS --follow --context=3 --no-heading --color=always ")
  (grep-command "rg --follow -C 0 --color=always -M 1000 -S --no-heading -z -. -g=!.git ")
  (grep-use-null-device nil)
  (grep-find-ignored-directories
   '("SCCS"
     "RCS"
     "CVS"
     "MCVS"
     ".src"
     ".svn"
     ".jj"
     ".git"
     ".hg"
     ".bzr"
     "_MTN"
     "_darcs"
     "{arch}"
     "node_modules"
     "build"
     "dist"))
  (grep-save-buffers t)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*grep\\*"
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-same-window)
                 (body-function . select-window))))

(use-package kam-search
  :ensure nil
  :hook (isearch-update-post . kam-isearch-goto-match-beginning)
  :bind
  (:map isearch-mode-map
        ("C-g" . kam-isearch-quit)))

(use-package link-hint
  :ensure t
  :bind
  ("C-c j" . link-hint-open-link))

(use-package link-menu
  :ensure nil
  :after (link-hint)
  :bind
  (:map help-mode-map
        ("m" . link-menu-open))
  (:map Info-mode-map
        ("m" . link-menu-open))
  (:map Man-mode-map
        ("m" . link-menu-open)))

(use-package smartparens
  :ensure t
  :bind
  (:map smartparens-mode-map
        ("C-M-DEL" . sp-backward-kill-sexp)))

(use-package paredit
  :ensure t)

(use-package paren
  :ensure nil
  :custom
  (show-paren-context-when-offscreen t)
  (show-paren-delay 0)
  (show-paren-style 'parenthesis))

(use-package delsel
  :ensure nil
  :config
  (delete-selection-mode 1))

(use-package saveplace
  :ensure nil
  :custom
  (save-place-file (expand-file-name "saveplace" kam-emacs-cache-directory))
  (save-place-forget-unreadable-files t)
  (save-place-limit 10000)
  (save-place-autosave-interval 50)
  :config
  (save-place-mode)

  (advice-add 'save-place-find-file-hook :after
              (lambda (&rest _)
                (when buffer-file-name
                  (ignore-errors (recenter))))))

(use-package subword
  :ensure nil
  :init
  (global-subword-mode))

(use-package dumb-jump
  :ensure t
  :custom
  (dumb-jump-aggressive nil)
  (dumb-jump-max-find-time 3)
  (dumb-jump-selector 'completing-read)
  :config
  (with-eval-after-load 'xref
    (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 80))

  (when (executable-find "rg")
    (setopt dumb-jump-force-searcher 'rg)
    (setopt dumb-jump-prefer-searcher 'rg)))

(use-package electric
  :ensure nil
  :hook (;; (org-mode . electric-indent-local-mode)
         (prog-mode . electric-indent-local-mode))
  :custom
  (electric-indent-actions '(yank))
  :config
  (electric-pair-mode 1)

  ;; (add-to-list 'electric-pair-pairs
  ;;              '("/*" . "*/"))

  ;; (add-to-list 'electric-pair-text-pairs
  ;;              '("/*" "*/") t)
  )

(use-package aggressive-indent
  :ensure t
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package vundo
  :ensure t
  :bind
  (:map vundo-mode-map
        ("<escape>" . vundo-quit)))

(use-package abbrev
  :ensure nil
  :custom
  (abbrev-file-name (expand-file-name "abbrev_defs.el" kam-emacs-cache-directory))
  (save-abbrevs 'silently)
  :config
  (setq-default abbrev-mode t))

(use-package ffap
  :ensure nil
  :custom
  (ffap-machine-p-known 'reject)
  :bind
  ("M-g M-." . ffap))

(use-package multiple-cursors
  :ensure t
  :bind
  (("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this))
  :custom
  (mc/always-run-for-all t)
  (mc/always-repeat-command t)
  (mc/list-file (expand-file-name "mc-lists.el" kam-emacs-cache-directory)))

(use-package expreg
  :ensure t
  :bind
  ("C-&" . expreg-expand)
  (:repeat-map expreg-repeat-map
               ("&" . expreg-expand)))

(use-package kam-expreg
  :after (expreg)
  :ensure nil
  :hook (text-mode . kam-expreg-text-mode-setup)
  :commands
  (kam-forward-out-sexp
   kam-mark-inner-sexp
   kam-kill-inner-sexp
   kam-expreg-end-of-sexp
   kam-expreg-beginning-of-sexp)
  :bind
  ("C-M-q" . kam-kill-inner-sexp)
  ("C-M-m" . kam-mark-inner-sexp)
  ("C-M-o" . kam-forward-out-sexp)
  (:map prog-mode-map
        ("C-M-q" . kam-kill-inner-sexp)))

(use-package org
  :ensure nil
  :hook (org-mode . kam-org-mode-setup)
  :bind
  (("C-c o" . kam-org-map)
   :map org-mode-map
   ("<prior>" . kam-scroll-down)
   ("<next>" . kam-scroll-up)
   ("C-<return>" . org-metaup)
   ("C-<up>" . org-previous-visible-heading)
   ("C-<down>" . org-next-visible-heading)
   ("C-<left>" . kam-prev-buffer)
   ("C-<right>" . kam-next-buffer)
   ("M-<up>" . kam-org-metaup)
   ("M-<down>" . kam-org-metadown)
   ("M-<return>" . org-meta-return)
   ("C-<backspace>" . kam-control-backspace)
   ;; ("C-<tab>" . kam-org-up-and-fold-heading)
   ;; ("C-M-<return>" . org-insert-subheading)
   ("<return>" . org-return)
   ("C-j" . kam-join-line-dwim)
   ("C-'" . org-edit-src-code)
   ("M-m" . kam-mark-line)
   ("M-i" . kam-indent-dwim)
   ("M-h" . mark-paragraph)
   ("C-M-<up>" . kam-org-control-metaup)
   ("C-M-<down>" . kam-org-control-metadown)
   ("C-M-<left>" . org-do-promote)
   ("C-M-<right>" . org-do-demote)
   ("C-M-<return>" . org-meta-return)
   ("C-M-h" . org-mark-subtree)
   ("C-M-m" . kam-mark-point-to-end-of-line)
   ("C-x C-v" . org-mark-element)
   ("C-x k" . kam-kill-current-buffer)
   ("C-x n" . kam-narrow-or-widen-dwim)
   ("C-c C-x C-b" . org-tree-to-indirect-buffer)
   ("C-c <kam-i>" . org-toggle-item)
   :map org-src-mode-map
   ("C-'" . org-edit-src-exit)
   ("C-<backspace>" . kam-control-backspace)
   :map kam-org-map
   ("l" . kam-consult-org-heading-link)
   ("i" . org-toggle-item)
   ("p" . org-set-property)
   ("n" . kam-org-insert-notes-drawer)
   :repeat-map kam-org-repeat-map
   ("C-p" . org-previous-visible-heading)
   ("C-n" . org-next-visible-heading))
  :custom
  (org-auto-align-tags nil)
  (org-M-RET-may-split-line nil)
  (org-directory "~/Documents/")
  (org-tags-column 0)
  (org-fold-catch-invisible-edits 'show-and-error)
  (org-startup-indented t)
  (org-insert-heading-respect-content t)
  (org-special-ctrl-a/e t)
  (org-indirect-buffer-display 'other-window)
  (org-use-fast-todo-selection t)
  (org-enforce-todo-dependencies t)
  (org-return-follows-link t)
  (org-cycle-separator-lines 2)
  (org-use-speed-commands t)
  (org-hide-macro-markers t)
  (org-blank-before-new-entry '((heading . nil)
                                (plain-list-item . auto)))
  (org-ellipsis " ⌄")
  (org-hide-emphasis-markers t)
  (org-fold-catch-invisible-edits 'show)
  (org-fontify-todo-headline t)
  (org-bookmark-names-plist nil)
  (org-pretty-entities t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-use-sub-superscripts '{})
  :config
  (require 'kam-org)

  (defvar-keymap kam-org-map
    :doc "Keymap for Org-related commands."
    :prefix t)

  (defun kam-org-mode-setup ()
    "Setup function for `org-mode'."
    (visual-line-mode 1)
    (visual-wrap-prefix-mode -1)
    (modify-syntax-entry ?< "." org-mode-syntax-table)
    (modify-syntax-entry ?> "." org-mode-syntax-table))

  (with-eval-after-load 'pulsar
    (dolist (hook '(org-agenda-after-show-hook org-follow-link-hook))
      (add-hook hook #'pulsar-recenter-center)
      (add-hook hook #'pulsar-reveal-entry)))

  (declare-function org-map-entries "org"))

(use-package org-capture
  :ensure nil
  :after (org)
  :bind
  ("C-c c" . org-capture)
  :custom
  (org-capture-templates
   '(("t" "Todo" entry (file+headline kam-todo-file "Inbox")
      "* TODO %?\n")
     ("p" "Project" entry (file+headline kam-todo-file "Projects")
      "* %?\n")
     ("w" "Writing" entry (file+headline kam-todo-file "Notes")
      "* TODO %?\n")))
  :config
  (add-to-list 'display-buffer-alist
               '("\\(\\*Capture\\*\\|CAPTURE-.*\\)"
                 (display-buffer-in-direction)
                 (direction . below)
                 (window . root)
                 (window-height . 0.3)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'display-buffer-alist
               '("\\*Org Select\\*" ;; `org-capture' key selection
                 (display-buffer-in-direction)
                 (direction . below)
                 (window . root)
                 (window-height . 0.5)
                 (window-parameters . ((mode-line-format . none))))))

(use-package org-agenda
  :ensure nil
  :after (kam-tasks org)
  :hook ((org-agenda . lin-mode)
         (org-agenda-after-show . visual-line-mode))
  :bind
  ("C-c a" . org-agenda)
  :custom
  (org-agenda-files `(,kam-todo-file))
  (org-agenda-hide-tags-regexp ".")
  (org-agenda-custom-commands
   '(("d" "Daily Agenda"
      ((agenda "" ((org-agenda-span 'day)
                   (org-deadline-warning-days 7)))
       (tags-todo "+PRIORITY=\"A\""
                  ((org-agenda-overriding-header "High Priority Tasks")))))
     ("i" "Inbox" alltodo ""
      ((org-agenda-overriding-header "Unfiled items in the inbox:")
       (org-agenda-skip-function '(kam-org-agenda-skip-entry-if-not-headline "Inbox"))))
     ("r" "Weekly Review"
      ((agenda ""
               ((org-agenda-overriding-header "Completed Tasks")
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo 'done))
                (org-agenda-span 'week)))
       (agenda ""
               ((org-agenda-overriding-header "Unfinished Scheduled Tasks")
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                (org-agenda-span 'week)))))
     ("w" "Writing Inbox" alltodo ""
      ((org-agenda-overriding-header "Things to write about:")
       (org-agenda-skip-function '(kam-org-agenda-skip-entry-if-not-headline "Notes"))))))
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Org Agenda\\*"
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-use-least-recent-window)
                 (mode . org-agenda-mode)))

  (add-to-list 'display-buffer-alist
               '("\\*Agenda Commands\\*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none))))))

(use-package org-refile
  :ensure nil
  :after (org)
  :bind
  ("C-c o o" . kam-org-refile-region)
  ("C-c o w" . kam-org-refile-to-current-file)
  :custom
  (org-refile-use-outline-path t)
  (org-outline-path-complete-in-steps nil)
  (org-refile-targets '((org-agenda-files :maxlevel . 9))))

(use-package ol   ;; org-links
  :ensure nil
  :after (org)
  :bind
  ("C-c l" . org-store-link)
  :custom
  (org-link-context-for-files t)
  (org-link-keep-stored-after-insertion nil)
  (org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
  (org-link-frame-setup '((vm . vm-visit-folder-other-frame)
                          (vm-imap . vm-visit-imap-folder-other-frame)
                          (gnus . org-gnus-no-new-news)
                          (file . find-file)
                          (wl . wl-other-frame)))
  :config
  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*Org Links\\*" ;; Org Links
  ;;                (display-buffer-no-window
  ;;                 (allow-no-window . t))))
  )

(use-package ob ;; org babel
  :ensure nil
  :after (org)
  :custom
  (org-confirm-babel-evaluate nil)
  (org-src-window-setup 'current-window)
  (org-edit-src-persistent-message nil)
  (org-src-fontify-natively t)
  (org-src-preserve-indentation t)
  (org-src-tab-acts-natively t)
  (org-edit-src-content-indentation 0)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
     (emacs-lisp . t))))

(use-package org-tempo
  :ensure nil
  :after (org)
  :config
  (setq org-structure-template-alist
        '(("c" . "comment")
          ("C" . "src C :main no")
          ("e" . "src emacs-lisp")
          ("E" . "src emacs-lisp :results value code lexical:t")
          ("et" . "src emacs-lisp :tangle")
          ("s" . "src")
          ("sc" . "src c")
          ("sh" . "sh")
          ("t" . "tip")
          ("T" . "src emacs-lisp :tangle FILENAME :mkdirp yes")
          ("w" . "warning")
          ("q" . "quote"))))

(use-package ox ;; org export
  :ensure nil
  :after (org)
  :custom
  (org-export-with-toc nil)
  (org-export-with-date nil)
  (org-export-with-tags nil)
  (org-export-with-title nil)
  (org-export-with-author nil)
  (org-export-with-drawers '(or (not "LOGBOOK")
                                (not "NOTES"))))

(use-package org-id
  :ensure nil
  :after (org))

(use-package org-cycle
  :ensure nil
  :after (org))

(use-package ox-latex
  :ensure nil
  :after (org))

(use-package ox-gfm
  :ensure t
  :after (org))

(use-package org-contrib
  :after (org)
  :ensure t
  :config
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines)))

(use-package org-modern
  :after (org)
  :ensure t
  :hook (org-mode . org-modern-mode)
  :custom
  (org-modern-star 'replace)
  :custom-face
  (org-modern-label ((t (:height 1.0))))
  (org-modern-symbol ((t (:family "SF Mono")))))

(use-package org-anki
  :after (org)
  :ensure t
  :bind
  ;; ("C-c n s" . org-anki-sync-entry)
  :custom
  (org-anki-inherit-tags nil)
  :config
  (setq org-anki-api-key nil
        org-anki-default-deck "get that main main"))

(use-package auctex
  :ensure t
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  )

(use-package project
  :ensure nil
  :bind
  (:map project-prefix-map
        ("c" . project-compile)
        ("p" . nil)
        ("f" . nil)
        ("r" . project-recompile))
  :custom
  (project-switch-use-entire-map nil)
  (project-prune-zombie-projects '((list-first-read . project-prune-zombies-default)))
  (project-list-file (expand-file-name "projects" kam-emacs-cache-directory))
  (project-vc-extra-root-markers '(".project" "Cargo.toml" "package.json" "go.mod" "build.zig" "tasks"))
  (project-vc-ignores '("nix/store/"
                        "node_modules/"
                        "go/pkg/"
                        ".direnv"))

  :config
  (add-to-list 'project-switch-commands '(project-shell "Shell" "s"))
  (add-to-list 'project-switch-commands '(project-find-file "Find file" "f"))
  (add-to-list 'project-switch-commands '(project-dired "Dired" "d"))
  (add-to-list 'project-switch-commands '(project-dired "Grep" "g"))
  (add-to-list 'project-switch-commands '(magit-project-status "Git" "v"))
  (add-to-list 'project-switch-commands '(kam-keyboard-escape-quit-dwim "Quit" "C-g") t))

(use-package kam-project
  :demand t
  :after (project)
  :ensure nil
  :commands
  (kam-project-new)
  :bind
  ("C-@" . kam-project-compile-maybe)
  (:map project-prefix-map
        ("d" . kam-project-dired)
        ("g" . kam-project-grep)
        ("n" . kam-project-new))
  :config
  (setq project-switch-commands
	(seq-remove (lambda (x)
                      (member x kam-project-switch-commands-to-remove))
                    project-switch-commands))

  (advice-add 'kam-project-new :after #'kam-project-remember-advice))


(use-package comint
  :ensure nil
  :hook (comint-output-filter-functions . comint-osc-process-output)
  :custom
  (comint-completion-auto-list t)
  (comint-prompt-read-only t)
  (comint-buffer-maximum-size 9999)
  (comint-input-ignoredups t)
  (ansi-color-for-comint-mode t))

(use-package kam-comint
  :after (comint)
  :ensure nil
  :bind
  (:map comint-mode-map
        ("M-r" . consult-history)
        ("M-." . kam-comint-insert-arguments-from-command)))

(use-package shell
  :ensure nil
  :hook (shell-mode . kam-shell-mode-setup)
  :bind
  ("C-x s" . shell)
  ;; ([remap shell-command] . kam-shell-command)
  ("C-!" . shell-command)
  (:map shell-mode-map
        ("C-c C-k" . comint-clear-buffer)
        ("C-c C-w" . comint-write-buffer)
        ("C-g" . comint-interrupt-subjob)
        ("C-w" . unix-word-rubout)
        ("M-r" . consult-history))
  :custom
  (shell-file-name (executable-find "zsh"))
  (shell-command-prompt-show-cwd t)
  (explicit-shell-file-name (executable-find "zsh"))
  (explicit-zsh-args '("--interactive" "--login"))
  (tramp-default-remote-shell "/bin/bash")
  (shell-command-prompt-show-cwd t)
  (shell-command-buffer-name "*Shell Command*")
  (shell-input-autoexpand nil)
  (shell-highlight-undef-enable t)
  (shell-get-old-input-include-continuation-lines t)
  (shell-kill-buffer-on-exit t)
  (shell-font-lock-keywords
   '(("[ \t]\\([+-][^ \t\n]+\\)" 1 font-lock-builtin-face)
     ("^[^ \t\n]+:.*" . font-lock-string-face)
     ("^\\[[1-9][0-9]*\\]" . font-lock-constant-face)))
  :config
  (add-to-list 'display-buffer-alist
               '("\\*shell[\\*\\:]"
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-same-window)
                 (mode shell-mode)
                 (body-function . select-window)))

  (add-to-list 'display-buffer-alist
               `(,shell-command-buffer-name
                 (display-buffer-pop-up-window
                  display-buffer-use-least-recent-window)
                 (body-function . view-mode))))

(use-package kam-shell
  :after (shell)
  :ensure nil
  :hook (shell-mode . kam-shell-mode-setup)
  :bind
  (:map shell-mode-map
        ("C-^" . kam-shell-up-directory)
        ("C-x C-d" . kam-shell-cd)))

(use-package readline-completion
  :after (shell)
  :ensure t
  :config
  (add-hook 'shell-dynamic-complete-functions #'readline-completion-at-point))

(use-package eshell
  :ensure nil
  :hook ((eshell-mode . completion-preview-mode))
  ;; TODO 2026-07-15: figure out how to enable these binds
  ;; emacs says that there eshell-mode-map is void

  ;; :bind
  ;; (:map eshell-mode-map
  ;;       ("<tab>" . completion-at-point)
  ;;       ("C-g" . eshell-interrupt-process)
  ;;       ("C-M-f" . eshell-forward-argument)
  ;;       ("C-M-b" . eshell-backward-argument)
  ;;       ("C-c C-p" . kam-eshell-previous-prompt)
  ;;       ("C-c C-n" . kam-eshell-next-prompt)
  ;;       ("C-x C-d" . eshell/z))
  ;; (:map eshell-hist-mode-map
  ;;       ("M-r" . consult-history)
  ;;       ("C-c C-l" . eshell-clear))
  :custom
  (eshell-history-file-name (expand-file-name "eshell/history" kam-emacs-cache-directory))
  (eshell-last-dir-ring-file-name (expand-file-name "eshell/lastdir" kam-emacs-cache-directory))
  (eshell-banner-message "")
  (eshell-list-files-after-cd t)
  (eshell-ls-initial-args '("-AGFhlv" "--color=always"))
  (eshell-scroll-to-bottom-on-input 'all)
  (eshell-error-if-no-glob t)
  (eshell-hist-ignoredups t)
  (eshell-history-size 10000)
  (eshell-save-history-on-exit t)
  (eshell-prefer-lisp-functions nil)
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-highlight-prompt nil)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*eshell[\\*\\:]" ; matches title for reg eshell and `kam-eshell-here'
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-use-least-recent-window)
                 (mode . eshell-mode))))

(use-package em-smart
  :ensure nil
  :config
  (setq eshell-where-to-jump 'after
        eshell-review-quick-commands nil
        eshell-smart-space-goes-to-end t))

(use-package eshell-syntax-highlighting
  :after (eshell)
  :ensure t
  :hook (eshell-mode . eshell-syntax-highlighting-mode))

(use-package kam-eshell
  :after (eshell)
  :ensure nil
  :hook (eshell-mode . kam-eshell-mode-setup)
  :custom
  (eshell-prompt-function kam-eshell-prompt-function)
  (eshell-input-filter #'kam-eshell-input-filter))

(use-package standard-themes
  :after (kam-theme)
  :ensure t
  :hook (standard-themes-after-load-theme . kam-theme-update-custom-faces)
  :init
  (standard-themes-take-over-modus-themes-mode 1)
  :config
  (require 'kam-theme)
  (setopt standard-themes-common-palette-overrides
          '((bg-completion bg-dim)
            (fg-heading-1 rainbow-2)
            (fg-heading-2 rainbow-1)
            (docstring string)))

  (setopt standard-dark-palette-overrides
          '((fg-prompt cyan)
            ;; (bg-main "#181818") ;;   tsoding
            ;; (bg-prose-block-delimiter "#312f34")
            ;; (bg-prose-block-contents "#29272c")
            (cursor "#f9d82b")))

  (setopt standard-light-palette-overrides
          '((cursor fg-main)))

  (setopt standard-themes-to-toggle '(standard-dark
                                      standard-light))
  (setopt standard-themes-disable-other-themes t)
  (setopt standard-themes-variable-pitch-ui nil)
  (setopt standard-themes-italic-constructs t)
  (setopt standard-themes-bold-constructs t)
  (setopt standard-themes-mixed-fonts nil)
  (setopt standard-themes-headings '((section-minibuffer . (bold 1))
                                     (section-other . (bold 1))
                                     (commit-summary . (bold 1))
                                     (t . (bold 1))))

  (standard-themes-load-theme 'standard-light))

(use-package kam-theme
  :after (standard-themes spacious-padding)
  :ensure nil
  :commands
  (kam-standard-themes-reload-theme
   kam-load-theme
   kam-load-font
   kam-text-scale-adjust
   kam-old-mode
   kam-documentation-mode))

(use-package decolorify
  :after (standard-themes)
  :hook (prog-mode . decolorify-mode)
  :ensure nil)

(use-package hide-cursor
  :ensure nil
  :hook (dired-mode . hide-cursor-mode))

(use-package ef-themes
  :ensure t)

(use-package olivetti
  :ensure t
  :hook (olivetti-mode . kam-olivetti-custom-faces-setup)
  :custom
  (olivetti-style 'fancy)
  (olivetti-margin-width 5)
  ;; (olivetti-body-width .3)
  (olivetti-minimum-body-width 80)
  (olivetti-recall-visual-line-mode-state t))

(use-package spacious-padding
  :after (standard-themes)
  :ensure t
  :custom
  (spacious-padding-subtle-mode-line nil)
  (spacious-padding-widths
   '( :internal-border-width 15
      :header-line-width 10
      :mode-line-width 10
      :tab-width 6
      :right-divider-width 20
      :scroll-bar-width 8
      :fringe-width 10))
  :config
  (setq spacious-padding-subtle-frame-lines
        '( :mode-line-active spacious-padding-line-active
           :mode-line-inactive spacious-padding-line-inactive
           :header-line-active spacious-padding-line-active
           :header-line-inactive spacious-padding-line-inactive))

  (setq spacious-padding-subtle-frame-lines nil)

  (spacious-padding-mode))

(use-package logos
  :ensure t
  :config
  (setq-default logos-hide-mode-line t
                logos-hide-header-line t
                logos-hide-buffer-boundaries t
                logos-hide-fringe nil
                logos-olivetti t))

(use-package scroll-bar
  :ensure nil
  :config
  (set-window-scroll-bars (minibuffer-window) nil nil nil nil 1)
  (set-scroll-bar-mode 'right)
  (scroll-bar-mode -1))

(use-package hl-line
  :ensure nil
  :hook (hl-line-mode . kam-hl-line-custom-faces-setup)
  :custom
  (hl-line-sticky-flag nil)
  (global-hl-line-sticky-flag 'window))

(use-package lin
  :ensure t
  :custom
  (lin-face 'lin-yellow))

(use-package rainbow-mode
  :ensure t)

(use-package pulsar
  :ensure t
  :hook ((next-error . pulsar-pulse-line)
         (consult-after-jump . pulsar-reveal-entry)
         (imenu-after-jump . pulsar-recenter-center)
         (imenu-after-jump . pulsar-reveal-entry))
  :custom
  (pulsar-delay 0.05)
  (pulsar-iterations 5)
  (pulsar-face 'cursor)
  (pulsar-region-face 'pulsar-yellow)
  (pulsar-highlight-face 'pulsar-yellow)
  (pulsar-pulse-on-window-change nil)
  (pulsar-pulse-region-functions '(kam-kill-line kill-ring-save))
  :config
  (pulsar-global-mode))

(use-package nerd-icons
  :ensure t
  :config
  (set-fontset-font "fontset-default" nil "Symbols Nerd Font Mono" nil 'append)
  (add-to-list 'nerd-icons-mode-icon-alist
               '(ghostel-mode nerd-icons-devicon "nf-dev-terminal"))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(Man-mode nerd-icons-faicon "nf-fa-info" :face nerd-icons-purple))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(reb-mode nerd-icons-mdicon "nf-md-regex" :face nerd-icons-purple))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(reb-lisp-mode nerd-icons-mdicon "nf-md-regex" :face nerd-icons-purple))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(emacs-news-view-mode nerd-icons-faicon "nf-fa-newspaper" :face nerd-icons-blue))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(embark-collect-mode nerd-icons-codicon "nf-cod-collection" :face nerd-icons-blue))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(git-rebase-mode nerd-icons-mdicon "nf-md-git" :face nerd-icons-green))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(occur-mode nerd-icons-faicon "nf-fa-search" :face nerd-icons-blue))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(grep-mode nerd-icons-faicon "nf-fa-search" :face nerd-icons-blue))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(debugger-mode nerd-icons-octicon "nf-oct-bug" :face nerd-icons-blue))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(trashed-mode nerd-icons-faicon "nf-fa-trash_can" :face nerd-icons-red))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(grep-edit-mode nerd-icons-faicon "nf-fa-pen" :face nerd-icons-blue))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(wdired-mode nerd-icons-faicon "nf-fa-pen" :face nerd-icons-blue))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(occur-edit-mode nerd-icons-faicon "nf-fa-pen" :face nerd-icons-blue)))

(use-package nerd-icons-dired
  :if (package-installed-p 'nerd-icons)
  :after (nerd-icons)
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-corfu
  :if (package-installed-p 'nerd-icons)
  :after (corfu nerd-icons)
  :ensure t
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-completion
  :after (nerd-icons marginalia)
  :ensure t
  :hook ((after-init . nerd-icons-completion-mode)
         (marginalia-mode . nerd-icons-completion-marginalia-setup)))

(use-package nerd-icons-ibuffer
  :if (package-installed-p 'nerd-icons)
  :ensure t
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package nerd-icons-xref
  :if (package-installed-p 'nerd-icons)
  :ensure t
  :hook (after-init . nerd-icons-xref-mode))

(use-package nerd-icons-grep
  :if (package-installed-p 'nerd-icons)
  :ensure t
  :hook (grep-mode . nerd-icons-grep-mode)
  :custom
  (grep-use-headings t))

(use-package visual-fill-column
  :ensure t
  :hook ((visual-line-mode . visual-fill-column-for-vline)
         (image-mode . kam-visual-fill-column-disable)
         (transient-setup-buffer . kam-visual-fill-column-disable)
         (prog-mode . kam-visual-fill-column-disable)
         (emacs-news-mode . kam-visual-fill-column-disable))
  :config
  (defun kam-visual-fill-column-disable ()
    "Turn off `visual-fill-column-mode'."
    (visual-fill-column-mode -1))

  (advice-add 'text-scale-adjust :after #'visual-fill-column-adjust))

(use-package kam-mode-line
  :demand t
  :ensure nil
  :custom
  (mode-line-compact nil)
  (mode-line-right-align-edge 'right-fringe)
  :config
  (dolist (construct '(kam-mode-line-kbd-macro
                       kam-mode-line-mark-active
                       kam-mode-line-rectangle-mark
                       kam-mode-line-narrow
                       kam-mode-line-recursive-edit
                       kam-mode-line-buffer-modified
                       kam-mode-line-buffer-status
                       kam-mode-line-buffer-identification
                       kam-mode-line-major-mode
                       kam-mode-line-text-scale
                       kam-mode-line-buffer-stats-var
                       kam-mode-line-process
                       kam-mode-line-nix
                       kam-mode-line-logo
                       kam-mode-line-compile
                       kam-mode-line-vc-branch
                       kam-mode-line-eglot
                       kam-mode-line-decolorify
                       kam-mode-line-display-time))
    (put construct 'risky-local-variable t))

  (setq-default mode-line-format
                '("%e"
                  kam-mode-line-logo
                  kam-mode-line-kbd-macro
                  kam-mode-line-narrow
                  kam-mode-line-rectangle-mark
                  kam-mode-line-mark-active
                  kam-mode-line-recursive-edit
                  " "
                  kam-mode-line-buffer-modified
                  kam-mode-line-buffer-remote-file
                  "  "
                  kam-mode-line-buffer-identification
                  " "
                  kam-mode-line-major-mode
                  kam-mode-line-compile
                  kam-mode-line-text-scale
                  "   "
                  kam-mode-line-buffer-stats-var
                  "  "
                  kam-mode-line-process
                  kam-mode-line-eglot
                  kam-mode-line-decolorify
                  " "
                  mode-line-format-right-align
                  ;; kam-mode-line-vc-branch
                  "   "
                  kam-mode-line-display-time)))

(use-package text-mode
  :ensure nil
  :hook ((text-mode . kam-text-mode-setup)
         (text-mode . visual-line-mode))
  :config
  (defun kam-text-mode-setup ()
    "Setup function for `text-mode'."
    (auto-fill-mode -1)
    (indent-tabs-mode -1)
    (setopt-local fill-paragraph-function #'fill-region-as-paragraph-semlf)))

(use-package prog-mode
  :ensure nil
  :hook ((prog-mode . kam-prog-mode-setup)
	 (prog-mode . auto-fill-mode))
  ;; :bind
  ;; (:map prog-mode-map
  ;;       ("RET" . newline))
  :config
  (defun kam-prog-mode-setup ()
    "Setup function for `prog-mode'."
    (setopt-local truncate-lines t)
    (setopt-local comment-auto-fill-only-comments t)
    (indent-tabs-mode -1)))

(use-package conf-mode
  :ensure nil
  :hook ((conf-mode . kam-conf-mode-setup)
         (conf-mode . outline-minor-mode))
  :mode ("\\.env\\..*\\'" "\\.env\\'")
  :config
  (defun kam-conf-mode-setup ()
    "Set up `conf-mode'."
    (indent-tabs-mode -1))

  (add-to-list 'auto-mode-alist
               '("\\pkgs_arch.txt\\'" . conf-mode)))

(use-package elisp-mode
  :ensure nil
  :hook ((lisp-interaction-mode . outline-minor-mode)
         (emacs-lisp-mode . outline-minor-mode)
         (emacs-lisp-mode . kam-elisp-mode-setup))
  :bind
  (:map lisp-interaction-mode-map
        ("C-j" . kam-join-line-dwim))
  (:map emacs-lisp-mode-map
        ("C-M-q" . kam-kill-inner-sexp))
  :custom
  (elisp-fontify-semantically nil)
  :config
  (set-default-toplevel-value 'lexical-binding t)

  ;; (with-eval-after-load 'consult
  ;;   (add-to-list 'consult-buffer-filter
  ;;                "\\*Pp Eval Output\\*"))

  (add-to-list 'display-buffer-alist
               '("\\*Pp Eval Output\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (body-function . view-mode)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'display-buffer-alist
               '("\\*Pp Macroexpand Output\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (body-function . view-mode)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none)))))

  (defun kam-elisp-mode-setup ()
    "Setup function for `emacs-lisp-mode'."
    (setq-local completion-at-point-functions
                '(cape-file
                  cape-elisp-block
                  cape-elisp-symbol
                  elisp-completion-at-point
                  cape-dabbrev
                  t))))

(use-package kam-elisp
  :after (elisp-mode)
  :ensure nil)

;; (use-package sh-mode
;;   :ensure nil
;;   :config
;;   (add-to-list 'auto-mode-alist
;;                '("\\.zsh\\'" . sh-mode))
;;   (add-to-list 'auto-mode-alist
;;                '("\\.bashrc\\'" . sh-mode))
;;   (add-to-list 'auto-mode-alist
;;                '("\\.bash_profile\\'" . sh-mode))
;;   (add-to-list 'auto-mode-alist
;;                '("zlogin\\'" . sh-mode))
;;   (add-to-list 'auto-mode-alist
;;                '("zshenv\\'" . sh-mode))
;;   (add-to-list 'auto-mode-alist
;;                '("zshrc\\'" . sh-mode)))

(use-package magit
  :ensure t
  :init
  (setq magit-define-global-key-bindings nil)
  :hook (magit-ediff-quit . kam-ediff-cleanup)
  :bind
  ("C-x g" . magit-status)
  (:map vc-prefix-map
        ("b" . magit-branch)
        ("d" . magit-dispatch)
        ("f" . magit-fetch-branch)
        ("l" . magit-log-current)
        ("P" . magit-push-current)
        ("F" . magit-pull-branch))
  :custom
  (magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
  (magit-bury-buffer-function 'magit-restore-window-configuration)
  (magit-commit-show-diff t)
  (magit-format-file-function #'magit-format-file-nerd-icons)
  (magit-save-repository-buffers 'dontask)
  :config
  (magit-auto-revert-mode)
  (magit-wip-mode)

  (kam-when-system-type 'darwin
    (setq magit-git-executable "/opt/homebrew/bin/git"))

  (add-to-list 'consult-buffer-filter
               "magit-")

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "magit-")

  (add-to-list 'same-window-regexps "^magit: .*$")
  (add-to-list 'same-window-regexps "^magit-status: .*$")

  (defun kam-git-clone ()
    "Run git clone using `magit' in `kam-projects-directory'."
    (interactive)
    (kam-with-directory kam-projects-directory
      (call-interactively 'magit-clone))
    (kam-project-update-list)))

(use-package forge
  :after (magit)
  :ensure t)

(use-package vc
  :ensure nil
  :custom
  (vc-follow-symlinks t)
  :config)

(use-package kam-vc
  :after (vc)
  :ensure nil
  :bind
  (:map vc-prefix-map
        ("e" . kam-vc-ediff)))

(use-package git-commit
  :ensure nil
  :hook (git-commit-setup . kam-git-commit-mode-setup)
  :custom
  (git-commit-summary-max-length 50)
  :config
  (defun kam-git-commit-mode-setup ()
    "Setup function for `git-commit-mode'."
    (setopt-local fill-column 72)
    (indent-tabs-mode -1)
    (visual-line-mode -1)))

(use-package flycheck
  :ensure t
  :hook ((after-init . global-flycheck-mode)
         (after-init . global-flycheck-annotate-mode))
  :custom
  (flycheck-emacs-lisp-load-path 'inherit)
  (flycheck-emacs-lisp-package-user-dir package-user-dir)
  :config
  (global-flycheck-eglot-mode 1))

(use-package consult-flycheck
  :after (consult flycheck)
  :ensure t
  :bind
  (:map goto-map
        ("M-l" . consult-flycheck)))

(use-package eglot
  :ensure nil
  :hook (eglot-managed-mode . kam-eglot-mode-setup)
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect nil)
  (eglot-events-buffer-size 0)
  (eglot-events-buffer-config '(:size 0 :format full))
  (eglot-code-action-indications nil)
  (eglot-documentation-renderer #'markdown-ts-view-mode)
  (eglot-extend-to-xref t)
  :config
  (defun kam-eglot-mode-setup ()
    "Setup function for `eglot-mode'."
    (add-to-list 'eglot-ignored-server-capabilities :inlayHintProvider)
    (add-to-list 'eglot-ignored-server-capabilities :documentHighlightProvider)
    (add-to-list 'eglot-ignored-server-capabilities :documentOnTypeFormattingProvider)
    (add-to-list 'eglot-ignored-server-capabilities :semanticTokensProvider)
    (eglot-semantic-tokens-mode -1)
    (eglot-inlay-hints-mode -1)
    ;; (remove-hook 'eldoc-documentation-functions #'flymake-eldoc-function t)
    )

  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)

  (defvar-keymap kam-lsp-map
    :doc "Keymap for LSP related functions"
    "c" 'eglot-code-actions
    "r" 'eglot-rename
    "f" 'eglot-format
    "s" 'eglot-shutdown
    "n" 'eglot-reconnect)

  (keymap-set global-map "C-c v" kam-lsp-map)

  (add-to-list 'consult-buffer-filter
               "^\\*EGLOT " t)
  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "^\\*EGLOT " t))

(use-package gdb-mi
  :ensure nil
  :custom
  (gdb-show-main t)
  (gdb-many-windows t)
  (gdb-restore-window-configuration-after-quit t)
  (gdb-debuginfod-enable-setting t)
  :config
  (defun kam-gdb-quit ()
    "Quit out of GDB instance."
    (interactive)
    (unless (and (eq (current-buffer) gud-comint-buffer)
                 (eq gud-minor-mode 'gdbmi))
      (error "Not in a GDB-MI buffer"))
    (let ((proc (get-buffer-process gud-comint-buffer)))
      (if (and (eobp)
               (process-live-p proc)
               (not gud-running)
               (= (point) (marker-position (process-mark proc))))
          ;; Exit a recursive reading loop or quit.
          (if (> gdb-control-level 0)
              (process-send-eof proc)
            ;; Sending an EOF does not work with GDB-MI; submit an
            ;; explicit quit command.
            (insert "quit")
            (comint-send-input t t))))))

(use-package xref
  :ensure nil
  :bind
  (("M-." . xref-find-definitions)
   :map xref--xref-buffer-mode-map
   ("w" . xref-change-to-xref-edit-mode))
  :custom
  (xref-search-program 'ripgrep)
  :config
  (add-to-list 'xref-prompt-for-identifier 'xref-find-references t)
  (add-to-list 'display-buffer-alist '((category . xref-jump)
                                       (display-buffer-same-window display-buffer-reuse-window))))

(use-package diff-mode
  :ensure nil
  :defer t
  :custom
  (diff-default-read-only t)
  (diff-advance-after-apply-hunk t)
  (diff-update-on-the-fly t)
  (diff-font-lock-syntax 'hunk-also)
  (diff-font-lock-prettify t))

(use-package display-line-numbers
  :ensure nil
  :hook ((prog-mode . display-line-numbers-mode)
         (conf-mode . display-line-numbers-mode))
  :custom
  (display-line-numbers-type 'relative)
  (display-line-numbers-widen t)
  (display-line-numbers-width 4))

(use-package ediff
  :ensure nil
  :custom
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-keep-variants t)
  (ediff-show-ancestor nil)
  (ediff-make-buffers-readonly-at-startup nil)
  (ediff-show-clashes-only t)
  (ediff-diff-options "-w")
  (ediff-custom-diff-options "--suppress-common-lines")
  (ediff-ignore-similar-regions t))

(use-package kam-ediff
  :after (ediff)
  :ensure nil
  :hook ((ediff-before-setup . kam-ediff-store-layout)
         (ediff-startup . kam-ediff-mode-setup)
         (ediff-quit . kam-ediff-restore-layout)
         (ediff-quit . kam-ediff-cleanup)))

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
  (eldoc-idle-delay 0)
  (eldoc-echo-area-use-multiline-p t)
  (eldoc-help-at-pt t)
  (eldoc-echo-area-prefer-doc-buffer 'maybe)
  :config
  (add-to-list 'display-buffer-alist
               '("^\\*eldoc for"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (window-height . 4)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*eldoc\\*" t)
  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*eldoc for " t)

  (add-to-list 'consult-buffer-filter
               "\\*eldoc\\*" t)
  (add-to-list 'consult-buffer-filter
               "\\*eldoc for " t)

  (global-eldoc-mode))

(use-package treesit
  :ensure nil
  :custom
  (treesit-font-lock-level 2)
  (treesit-enabled-modes t)
  (treesit-auto-install-grammar t))

(use-package direnv
  :ensure t
  :custom
  (direnv-always-show-summary nil)
  :demand t
  :config
  (direnv-mode)

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*direnv\\*")
  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*envrc\\*")

  (add-to-list 'consult-buffer-filter
               "^\\*direnv\\*" t)
  (add-to-list 'consult-buffer-filter
               "^\\*envrc\\*" t))

(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

(use-package compile
  :ensure nil
  :hook (compilation-filter . ansi-color-compilation-filter)
  :bind
  ("M-@" . recompile)
  (:map compilation-mode-map
        ("n" . compilation-next-error)
        ("p" . compilation-previous-error)
        ("C-c C-p" . compilation-previous-file)
        ("C-c C-n" . compilation-next-file)
        ("<return>" . kam-compile-goto-error)
        ("SPC" . kam-scroll-down)
        ("<backspace>" . kam-scroll-up)
        ("}" . compilation-next-file)
        ("{" . compilation-previous-file)
        ("<prior>" . kam-scroll-up)
        ("<next>" . kam-scroll-down)
        ("M-@" . recompile)
        ("C-g" . quit-window))
  :custom
  (compilation-always-kill t)
  (compilation-ask-about-save nil)
  (compilation-scroll-output 'first-error)
  (compilation-max-output-line-length nil)
  (compile-command "")
  (compilation-skip-threshold 1)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*compilation\\*"
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-use-least-recent-window)
                 (mode compilation-mode)
                 (body-function . select-window)))

  (add-to-list
   'switch-to-prev-buffer-skip-regexp
   "\\*compilation\\*"))

(use-package whitespace
  :ensure nil
  :hook ((prog-mode . whitespace-mode)
         (text-mode . whitespace-mode)
         (whitespace-mode . kam-whitespace-mode-setup))
  :custom
  (whitespace-display-mappings '((tab-mark ?\t [187 ?\t] [62 ?\t])))
  (whitespace-style '(face tabs indentation tab-mark))
  :config
  (defun kam-whitespace-mode-setup ()
    "Setup function for `whitespace-mode'."
    (add-to-list 'write-file-functions 'delete-trailing-whitespace)
    ;; (kill-ring-deindent-mode)
    ))

(use-package epa
  :ensure nil
  :custom
  (epa-gpg-program (executable-find "gpg2"))
  (epa-keys-select-method 'minibuffer)
  (epa-pinentry-mode 'loopback)
  :config
  (setenv "GPG_AGENT_INFO" nil))

(use-package epg
  :ensure nil
  :custom
  (epg-pinentry-mode 'loopback))

(use-package auth-source
  :ensure nil
  :custom
  (auth-sources '("~/.authinfo.gpg")))

(use-package c-ts-mode
  :ensure nil
  :hook ((c-ts-mode . kam-c-ts-mode-setup)
         (c-ts-mode . eglot-ensure)
         (c-ts-mode . hs-minor-mode)
         (c-ts-mode . treesit-fold-mode))
  :custom
  (c-ts-mode-indent-style 'k&r)
  (c-ts-mode-indent-offset 4)
  :config
  (defun kam-c-ts-mode-setup ()
    "Setup function for `c-ts-mode'."
    (c-ts-mode-toggle-comment-style -1)))

(use-package python
  :defer t
  :ensure nil
  :hook (python-mode . eglot-ensure)
  :custom
  (python-indent-guess-indent-offset-verbose nil))

(use-package asm-mode
  :hook (asm-mode . kam-asm-mode-setup)
  :config
  (defun kam-asm-mode-setup ()
    "Setup function for `asm-mode'."
    (electric-indent-local-mode -1)
    (setq tab-stop-list (number-sequence 4 80 4))))

(use-package rust-ts-mode
  :mode "\\.rs\\'"
  :defer t
  :hook ((rust-ts-mode . treesit-fold-mode)
         (rust-ts-mode . eglot-ensure))
  :custom
  (rust-mode-treesitter-derive t)
  (rust-indent-level 2)
  :config
  (add-to-list 'eglot-server-programs
               '((rust-ts-mode rust-mode) .
                 ("rust-analyzer" :initializationOptions (:check (:command "clippy"))))))

(use-package zig-mode
  :hook (zig-mode . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '(zig-mode . ("zls")) t)
  (add-to-list 'consult-buffer-filter
               "\\*zig-format errors\\*"))

(use-package lua-ts-mode
  :ensure nil
  :hook (lua-ts-mode . eglot-ensure))

(use-package java-ts-mode
  :ensure nil
  :hook ((java-ts-mode . treesit-fold-mode)
         (java-ts-mode . eglot-ensure))
  :bind
  (:map java-mode-map
        ("<TAB>" . indent-for-tab-command)
        ("<kam-i>" . indent-for-tab-command))
  :defer t
  :custom
  (java-ts-mode-enable-doxygen t)
  :config
  (add-to-list 'eglot-server-programs
               '((java-mode java-ts-mode) .
                 ("jdtls"
                  :initializationOptions
                  (:bundles ["/usr/share/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin.jar"])))))

(use-package json-ts-mode
  :ensure nil
  :defer t
  :mode "\\.json\\'"
  :hook ((json-ts-mode . treesit-fold-mode)
         (json-ts-mode . (lambda ()
                           (setq indent-tabs-mode nil)))))

(use-package toml-ts-mode
  :ensure nil
  :defer t
  :mode "\\.toml\\'"
  :hook (toml-ts-mode . treesit-fold-mode)
  :config
  (add-to-list 'treesit-language-source-alist '(toml "https://github.com/ikatyang/tree-sitter-toml" "master" "src")))

(use-package markdown-ts-mode
  :ensure nil
  :hook (markdown-ts-mode . kam-markdown-ts-mode-setup)
  :custom
  (markdown-ts-hide-markup nil)
  :config
  (require 'markdown-ts-mode-x)
  (defun kam-markdown-ts-mode-setup ()
    "Setup function for `markdown-ts-mode'."
    (setq-local treesit-font-lock-level 4)))

(use-package yaml-ts-mode
  :ensure nil
  :defer t
  :mode "\\.ya?ml\\'"
  :hook (yaml-ts-mode . treesit-fold-mode)
  :config
  (add-to-list 'treesit-language-source-alist '(yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml" "master" "src")))

(use-package sgml-mode
  :ensure nil
  :hook ((html-mode mthml-mode mhtml-ts-mode) . sgml-electric-tag-pair-mode))

(use-package transient
  :ensure nil
  :custom
  (transient-history-file (expand-file-name "transient/history.el" kam-emacs-cache-directory))
  (transient-levels-file (expand-file-name "transient/levels.el" kam-emacs-cache-directory))
  (transient-values-file (expand-file-name "transient/values.el" kam-emacs-cache-directory)))

(use-package diff-hl
  :ensure t
  :hook ((magit-post-refresh . diff-hl-magit-post-refresh)
         (prog-mode . diff-hl-mode))
  :bind
  (:map diff-hl-command-map
        ("n" . diff-hl-next-hunk)
        ("p" . diff-hl-previous-hunk))
  :custom
  (diff-hl-flydiff-delay 0.4)
  (diff-hl-show-staged-changes nil)
  (diff-hl-draw-borders nil)
  (diff-hl-update-async t))

(use-package url
  :ensure nil
  :custom
  (url-configuration-directory (expand-file-name "url" kam-emacs-cache-directory)))

(use-package jinx
  :ensure t
  :bind
  ("C-$" . jinx-correct)
  :custom
  (jinx-languages "en")
  (jinx--select-keys "dnretasipbghloj")
  :config
  (global-jinx-mode))

(use-package shr
  :ensure nil
  :config
  (setq shr-use-colors nil
        shr-use-fonts nil
        shr-fill-text nil))

(use-package ghostel
  :ensure t
  :hook ((compilation-mode . ghostel-compile-global-mode)
         (shell-command-mode . ghostel-shell-command-global-mode)
         (comint-mode . ghostel-comint-global-mode)
         (ghostel-mode . kam-ghostel-mode-setup))
  :bind
  ("C-x t" . ghostel)
  (:map ghostel-semi-char-mode-map
        ("M-o" . kam-ace-window))
  (:map project-prefix-map
        ("t" . ghostel-project))
  :custom
  ;; (ghostel-compile-finished-major-mode 'compilation-mode)
  ;; (ghostel-compile-finished-major-mode 'ghostel-compile-view-mode)
  (ghostel-buffer-name "*terminal*")
  (ghostel-module-auto-install 'download)
  :config
  ;; (ghostel-compile-global-mode)

  (defun kam-ghostel-mode-setup ()
    "Setup function for `ghostel-mode'."
    (visual-line-mode -1))

  (add-to-list 'project-switch-commands '(ghostel-project "Terminal" "t"))

  (keymap-set global-map "C-x t" 'ghostel)

  (add-to-list 'display-buffer-alist
               `(,ghostel-buffer-name
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window
                  display-buffer-same-window)
                 (mode ghostel-mode))))

(use-package ghostel-compile
  :after (ghostel)
  :ensure nil
  :hook (after-init . ghostel-compile-global-mode)
  :custom
  (ghostel-compile-buffer-name "*compilation*"))

(use-package ghostel-shell-command
  :after (ghostel)
  :ensure nil
  :hook (after-init . ghostel-shell-command-global-mode)
  ;; :bind
  ;; ("C-!" . ghostel-shell-command)
  :custom
  (ghostel-shell-command-buffer-name "*Shell Command*"))

(use-package ghostel-comint
  :after (ghostel)
  :ensure nil
  :hook (after-init . ghostel-comint-global-mode))

(use-package pcre2el
  :after (ghostel)
  :config
  (defmacro prx (&rest expressions)
    "Convert native `rx' EXPRESSIONS to PCRE style syntax."
    `(rxt-elisp-to-pcre (rx ,@expressions))))

(use-package kirigami
  :ensure t
  :commands (kirigami-open-fold
             kirigami-open-fold-rec
             kirigami-close-fold
             kirigami-toggle-fold
             kirigami-open-folds
             kirigami-close-folds-except-current
             kirigami-close-folds)
  :bind
  ;; Vanilla Emacs keybindings
  (("C-c z o" . kirigami-open-fold)          ; Open fold at point
   ("C-c z O" . kirigami-open-fold-rec)      ; Open fold recursively
   ("C-c z r" . kirigami-open-folds)         ; Open all folds
   ("C-c z c" . kirigami-close-fold)         ; Close fold at point
   ("C-c z m" . kirigami-close-folds)        ; Close all folds
   ("C-<tab>" . kirigami-toggle-fold)))      ; Toggle fold at point

(use-package outline-indent
  :ensure t
  :commands outline-indent-minor-mode
  :hook ((yaml-ts-mode . outline-indent-minor-mode)
         (python-ts-mode . outline-indent-minor-mode))
  :custom
  (outline-indent-ellipsis " ⌄"))

(use-package outline
  :ensure nil
  :hook ((outline-minor-mode . kam-outline-mode-setup)
         (emacs-lisp-mode . outline-minor-mode)
         (conf-mode . outline-minor-mode)
         (markdown-mode . outline-minor-mode)
         (diff-mode . outline-minor-mode))
  :config
  (defun kam-outline-mode-setup ()
    "Setup function for `outline-mode'."
    (let* ((display-table (or buffer-display-table (make-display-table)))
           (face-offset (* (face-id 'shadow) (ash 1 22)))
           (value (vconcat (mapcar (lambda (c) (+ face-offset c)) " ⌄"))))
      (set-display-table-slot display-table 'selective-display value)
      (setq buffer-display-table display-table))))

(use-package treesit-fold
  :ensure t
  :commands (treesit-fold-close
             treesit-fold-close-all
             treesit-fold-open
             treesit-fold-toggle
             treesit-fold-open-all
             treesit-fold-mode
             global-treesit-fold-mode
             treesit-fold-open-recursively
             treesit-fold-line-comment-mode)
  :bind
  (:map treesit-fold-mode-map
        ("C-<tab>" . treesit-fold-toggle))
  :custom
  (treesit-fold-line-count-show t)
  (treesit-fold-line-count-format " ⌄")

  :config
  (set-face-attribute 'treesit-fold-replacement-face nil
                      :foreground "#808080"
                      :box nil
                      :weight 'bold))

(use-package visible-mark
  :after (kam-theme standard-themes)
  :ensure t
  :init
  (defface kam-visible-mark-face
    `((t nil))
    "Visible mark")
  :custom
  (visible-mark-max 1)
  (visible-mark-faces `(kam-visible-mark-face))
  :custom-face
  (visible-mark-active
   ((t (:foreground ,(modus-themes-get-color-value 'fg-main)
                    :background ,(modus-themes-get-color-value 'bg-search-static)))))
  (kam-visible-mark-face
   ((t (:foreground ,(modus-themes-get-color-value 'fg-main)
                    :background ,(modus-themes-get-color-value 'bg-search-static)))))
  :config
  (global-visible-mark-mode))

(kam-when-system-type 'gnu/linux
  (use-package elfeed
    :ensure t
    ;; :hook (elfeed-show-mode . kam-writing-mode)
    :hook ((elfeed-search-mode . hide-cursor-mode)
           (elfeed-search-mode . lin-mode)
           (elfeed-show-mode . visual-line-mode)
           (elfeed-show-mode . kam-writing-mode))
    :bind
    ("C-c r" . elfeed)
    (:map elfeed-show-mode-map
          ("SPC" . kam-scroll-down)
          ("<backspace>" . kam-scroll-up))
    (:map elfeed-search-mode-map
          ;; ([remap scroll-down-command] . kam-scroll-up)
          ;; ([remap scroll-up-command] . kam-scroll-down)
          ("g" . elfeed-update)
          ("u" . elfeed-search-unmark)
          ("R" . elfeed-search-tag-unread))
    :custom
    (elfeed-db-directory (expand-file-name "elfeed" kam-emacs-cache-directory))
    (elfeed-enclosure-default-dir (expand-file-name "elfeed" kam-emacs-cache-directory))
    (elfeed-search-title-max-width 125)
    (elfeed-search-title-min-width 30)
    (elfeed-search-clipboard-type 'CLIPBOARD)
    (elfeed-search-filter "@2-weeks-ago +unread")
    (elfeed-show-truncate-long-urls t)
    (elfeed-search-date-format '("%F %R" 20 :left))
    (elfeed-show-entry-switch #'pop-to-buffer)
    (elfeed-show-unique-buffers nil)
    (elfeed-use-libxml t)
    :config
    (require 'kam-elfeed)
    (setq elfeed-feeds
          '(("https://www.artofmanliness.com/feed/" :title "The Art Of Manliness" culture manhood)
            ("https://xkcd.com/rss.xml" science comics)
            ("https://www.brainpickings.org/feed/" :title "The Marginalian" culture art)
            ("https://donaldrobertson.name/feed/" philosophy)
            ("https://startingstrength.com/rss.rss" :title "Starting Strength" health strengthtraining)
            ("https://www.youtube.com/feeds/videos.xml?channel_id=UCUMwY9iS8oMyWDYIe6_RmoA" :title "NoBoilerplate" programming technology youtube)
            ("https://www.youtube.com/feeds/videos.xml?channel_id=UCVls1GmFKf6WlTraIb_IaJg" :title "DistroTube" linux youtube)
            ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCmdlnVFzmf7Zhqm_QE-UlJw") Alex Leonidas
            ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC68TLK0mAEzUyHx5x5k-S1Q") Jeff Nippard
            ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCIh_TPYPqjJuS_-nOfAIlfg") The Bioneer
            ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCsvn_Po0SmunchJYOWpOxMg") VideoGameDunkey
            ("https://www.youtube.com/feeds/videos.xml?channel_id=UCPdaxSov0mgwh77JvjQO2jQ" :title "Man Carrying Thing" books culture youtube) ; Man carrying thing
            ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCussGOBf--SiEXrqCh-3rfA") Expatriarch
            ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2_krAagEXVPftDXZCDiVZA" :title "Kaname Naito" japanese youtube) ; Kaname Naito
            ("https://www.youtube.com/feeds/videos.xml?channel_id=UCQjBsscIa_mgEnSvWpm_9vw" :title "Odysseas" books philosophy youtube)
            ("https://www.youtube.com/feeds/videos.xml?channel_id=UCPIyEJzvW7SsbiIrooixjNA" :title "Doug's Dharma" buddhism youtube)
            ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC6biysICWOJ-C3P4Tyeggzg")
            ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2ME6cK8jWnRSWyUdV0yWJw")
            ;; ("https://www.theatlantic.com/feed/all/")
            ("https://www.theatlantic.com/politics/" :title "The Atlantic" politics news)
            ("https://www.theatlantic.com/science/" :title "The Atlantic" science)
            ("https://www.theatlantic.com/technology/" :title "The Atlantic" technology culture)
            ("https://www.newyorker.com/feed/news" :title "The New Yorker" news)
            ("https://www.newyorker.com/feed/culture" :title "The New Yorker" culture)
            ("https://dynomight.net/feed.xml" :title "DynoMight")
            ("https://feeds.npr.org/1020/rss.xml" :title "NPR" news)
            ("http://rss.sciam.com/sciam/mindmatters" :title "Scientific American" science)
            ("http://rss.sciam.com/sciam/feature-articles" :title "Scientific American" science)
            ("https://joshblais.com/index.xml" emacs philosophy)
            ("https://protesilaos.com/codelog.xml" :title "Protesilaos" emacs linux)
            ("https://protesilaos.com/interpretations.xml" :title "Protesilaos" art philosophy)))

    (defun kam-elfeed-show-mode-setup ()
      "Setup function for `elfeed-show-mode'."
      (setopt-local browse-url-browser-function browse-url-eww)))

  (use-package elfeed-tube
    :after (elfeed)
    :ensure t
    :bind
    (:map elfeed-show-mode-map
          ("F" . elfeed-tube-fetch)
          ([remap save-buffer] . elfeed-tube-save)
          :map elfeed-search-mode-map
          ("F" . elfeed-tube-fetch)
          ([remap save-buffer] . elfeed-tube-save))
    :config
    (elfeed-tube-setup))

  (use-package elfeed-tube-mpv
    :after (elfeed)
    :ensure t
    :bind
    (:map elfeed-show-mode-map
          ("C-c C-f" . elfeed-tube-mpv-follow-mode)
          ("C-c C-w" . elfeed-tube-mpv-where)))

  (use-package kam-elfeed
    :after (elfeed)
    :ensure nil
    :bind
    (:map elfeed-show-map
          ("n" . kam-elfeed-show-next)
          ("p" . kam-elfeed-show-prev)))

  (use-package emms
    :ensure t
    :bind
    ("C-c m m" . emms-browser)
    ("C-c m n" . emms-next-no-error)
    ("C-c m p" . emms-previous)
    ("C-c m e" . emms)
    :custom
    (emms-info-functions '(emms-info-native
                           emms-info-metaflac
                           emms-info-ogginfo))
    (emms-player-list '(emms-player-mpv))
    (emms-player-mpv-player (executable-find "mpv"))
    (emms-source-file-default-directory kam-music-directory)
    (emms-cache-file (expand-file-name "emms/cache" kam-emacs-cache-directory))
    (emms-history-file (expand-file-name "emms/history" kam-emacs-cache-directory))
    (emms-score-file (expand-file-name "emms/scores" kam-emacs-cache-directory))
    :config
    (require 'emms-setup)
    (require 'emms-mpris)
    (emms-all)
    (emms-mpris-enable)

    (with-eval-after-load 'consult
      (add-to-list 'consult-buffer-filter "^Browsing by: " t)))

  (use-package emms-browser
    :ensure nil
    :after (emms)
    :bind
    (:map emms-browser-mode-map
          ("SPC" . kam-scroll-down)
          ("<backspace>" . kam-scroll-up))
    :hook ((emms-browser-mode . hide-cursor-mode)
           (emms-browser-mode . lin-mode))
    :custom
    (emms-browser-buffer-name "*Music*")
    :config
    (emms-browser-make-filter "All" 'ignore)
    (emms-browser-make-filter "Library" (emms-browser-filter-only-dir kam-music-directory)))
  ;; (emms-browser-set-filter (assoc "Library" 'emms-browser-filters)))

  (use-package emms-playlist-mode
    :ensure nil
    :after (emms)
    :hook (emms-playlist-mode . hide-cursor-mode)
    :bind
    :custom
    (emms-playlist-buffer-name "*Playlist*")
    (emms-playlist-mode-open-playlists t))

  (use-package kam-emms
    :after (emms)
    :ensure nil
    :bind
    ("C-c m s" . kam-emms-play-pause)
    (:map emms-playlist-mode-map
          ("p" . kam-emms-previous)
          ("n" . kam-emms-next))))

(use-package eww
  :ensure nil
  :bind
  (:map eww-mode-map
        ("SPC" . kam-scroll-down)
        ("<backspace>" . kam-scroll-up))
  :custom
  (browse-url-browser-function 'browse-url-default-browser)
  (browse-url-secondary-browser-function 'eww-browse-url)
  (eww-auto-rename-buffer 'title)
  (eww-header-line-format nil)
  (eww-bookmarks-directory (expand-file-name "eww/" kam-emacs-cache-directory))
  (eww-history-limit 150)
  (eww-use-external-browser-for-content-type
   "\\`\\(video/\\|audio\\)")
  :config
  (dolist (command '( eww-list-bookmarks eww-add-bookmark eww-bookmark-mode
                      eww-list-buffers eww-toggle-fonts eww-toggle-colors
                      eww-switch-to-buffer))
    (put command 'disabled t))

  (defun kam-browse-url-at-point (&optional arg)
    "Browse url at point.
With optional ARG, open browser in EWW."
    (interactive "P")
    (let ((browse-url-browser-function
           (if arg
               browse-url-secondary-browser-function
             browse-url-browser-function)))
      (browse-url-at-point))))

(use-package calibredb
  :ensure t
  ;; :commands (calibredb)
  :hook ((calibredb-search-mode . hide-cursor-mode)
         (calibredb-search-mode . lin-mode))
  :bind
  ("C-c b" . calibredb)
  (:map calibredb-search-mode-map
        ("n" . next-line)
        ("p" . previous-line)
        ("N" . calibredb-search-next-page)
        ("P" . calibredb-search-previous-page)
        ("g" . calibredb-search-refresh)
        ("r" . calibredb-filter-dispatch)
        ("s" . calibredb-search-live-filter))
  :custom
  (calibredb-format-nerd-icons t)
  (calibredb-library-alist `((,kam-books-directory)))
  (calibredb-sort-by 'title)
  (calibredb-order 'asc)
  (calibredb-id-width 6)
  (calibredb-title-width 75)
  (calibredb-format-width 7)
  :config
  (setq calibredb-root-dir kam-books-directory
        calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))

  (defun kam-calibredb-open-file-with-emacs (&optional candidate)
    "Open file with Emacs. Optional argument CANDIDATE is the selected item."
    (interactive "P")
    (unless candidate
      (setq candidate (car (calibredb-find-candidate-at-point))))
    (find-file (calibredb-get-file-path candidate t)))

  (defun kam-calibredb-search-books ()
    (interactive)
    (let ((consult-ripgrep-command "rg --null --ignore-case --type txt --line-number . --color always --max-columns 500 --no-heading -e ARG OPTS"))
      (consult-ripgrep calibredb-root-dir))))

;;; LLM Client
(use-package gptel
  :ensure t
  :config
  (setq gptel-default-mode 'org-mode)
  (setq gptel-model (gptel-make-anthropic "Claude"
		      :stream t
		      :key gptel-api-key))
  (setq gptel-highlight-methods '(face))

  (gptel-highlight-mode))

(use-package kam-gptel
  :after (gptel)
  :ensure nil
  :commands
  (claude
   chatgpt))

(use-package denote
  :after (kam-os savehist)
  :ensure t
  :hook ((dired-mode . denote-dired-mode)
         (after-init . denote-rename-buffer-mode))
  :bind
  ("C-c n h" . kam-notes-visit-home-note)
  ("C-c n w" . kam-notes-visit-workbench-note)
  ("C-c n d" . denote-open-or-create)
  ("C-c n b" . denote-backlinks)
  ("C-c n c" . denote-link-or-create)
  ("C-c n p" . kam-notes-set-processed-property)
  ("C-c n r" . denote-rename-file)
  (:map dired-mode-map
        ("r" . denote-dired-rename-files))
  :custom
  (denote-directory kam-zettelkasten-directory)
  (denote-buffer-name-prefix "")
  (denote-sort-keywords t)
  (denote-prompts '(title keywords))
  (denote-rename-confirmations nil)
  (denote-date-prompt-use-org-read-date t)
  :config
  (add-to-list 'savehist-additional-variables 'denote-known-keywords))

(use-package denote-sequence
  :ensure t
  :bind
  ("C-c n s s" . denote-sequence)
  ("C-c n s f" . denote-sequence-find)
  ("C-c n l"   . denote-sequence-link)
  ("C-c n s d" . denote-sequence-dired)
  ("C-c n s r" . denote-sequence-reparent)
  ("C-c n s c" . denote-sequence-convert))

(use-package kam-denote
  :demand t
  :after (denote denote-sequence)
  :ensure nil
  :commands
  (kam-denote-sequence-dired-with-clone)
  :hook ((denote-after-rename-file . kam-denote-add-known-keyword)
         (denote-after-new-note . kam-denote-add-known-keyword))
  :config
  (setopt denote-known-keywords (kam-denote-keywords)))

(use-package consult-denote
  :after (consult denote)
  :ensure t
  :custom
  (consult-denote-find-command #'consult-fd)
  (consult-denote-grep-command #'consult-ripgrep)
  :bind
  ("C-c n g" . consult-denote-grep)
  ("C-c n f" . consult-denote-find)
  :config
  (consult-denote-mode))

(use-package sly
  :ensure t
  :commands (sly)
  :custom
  (inferior-lisp-program (executable-find "sbcl")))

(use-package super-save
  :ensure t
  :hook (after-init . super-save-mode)
  :custom
  (super-save-silent t)
  (auto-save-default nil))

(use-package timeshift
  :if (kam-when-system-type 'gnu/linux t)
  :ensure nil
  :commands
  (timeshift-snapshot-list
   timeshift-snapshot-create
   timeshift-snapshot-delete))

(use-package yt-dlp
  :ensure nil
  :commands
  (kam-ytdlp-download-video
   kam-ytdlp-download-music))

(kam-when-system-type 'darwin
  (use-package osx-trash
    :ensure t
    :custom
    (osx-trash-command "trash -F")
    :config
    (osx-trash-setup)))

(use-package async
  :ensure t
  :hook
  (dired-mode . dired-async-mode)
  :custom
  (async-quiet-switch "-q")
  (async-bytecomp-allowed-packages '(all))
  :config
  (async-bytecomp-package-mode))

(require 'kam-writing)
(require 'kam-tasks)
;;; init.el ends here
