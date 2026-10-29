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
  :ensure nil
  :custom
  (use-package-always-ensure t)
  (use-package-compute-statistics t)
  (package-archives
   '(("gnu-elpa"       . "https://elpa.gnu.org/packages/")
     ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
     ("nongnu"         . "https://elpa.nongnu.org/nongnu/")
     ("melpa"          . "https://melpa.org/packages/")))

  (package-vc-register-as-project nil)
  (package-install-upgrade-built-in t)
  (package-native-compile t)
  (package-vc-allow-build-commands t))

(use-package native-compile
  :ensure nil
  :custom
  (native-comp-async-report-warnings-errors 'silent)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Compile-Log\\*"
                 (display-buffer-no-window
                  (allow-no-window . t))))

  (with-eval-after-load 'consult
    (add-to-list 'consult-buffer-filter "\\*Async-native-compile-log\\*" t)
    (add-to-list 'consult-buffer-filter "\\*Native-compile-Log\\*" t)
    (add-to-list 'consult-buffer-filter "\\*Compile-Log\\*" t)))

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-shell-name (executable-find "zsh")
        exec-path-from-shell-variables '("PATH"
                                         "MANPATH"
                                         "SHELL"
                                         "SSH_AUTH_SOCK"
                                         "GNUPGHOME"
                                         "LANG"
                                         "DISPLAY"
                                         "WAYLAND_DISPLAY"
                                         "XDG_DATA_HOME"
                                         "XDG_CONFIG_HOME"
                                         "HYPRLAND_INSTANCE_SIGNATURE"))
  (exec-path-from-shell-initialize))

(use-package emacs
  :ensure nil
  :hook ((after-init . kam-initial-setup)
         (after-init . blink-cursor-mode))
  :bind
  ([remap revert-buffer] . kam-revert-buffer)
  ("TAB" . nil)
  ("<escape>" . kam-keyboard-quit-dwim)
  ("<home>" . nil)
  ("<end>" . nil)
  ("<up>" . nil)
  ("<down>" . nil)
  ("<left>" . nil)
  ("<right>" . nil)
  ("C-d" . delete-forward-char)
  ("C-g" . kam-keyboard-quit-dwim)
  ("C-j" . kam-join-line-dwim)
  ([kam-m] . back-to-indentation)
  ("C-o" . kam-open-line-dwim)
  ("C-w" . kam-cut-dwim)
  ("C-t" . kam-transpose-char)
  ("C-v" . undo)
  ("C-q" . quoted-insert)
  ("C-z" . repeat)
  ("C-SPC" . set-mark-command)
  ("C-<left>" . kam-prev-buffer)
  ("C-<right>" . kam-next-buffer)
  ("C-<return>" . kam-insert-new-line-below)
  ("C-<backspace>" . kam-control-backspace)
  ("C-_" . nil)
  ("C-:" . pp-eval-expression)
  ("C-;" . kam-comment-dwim)
  ("C-|" . nil)
  ("C-`" . nil)
  ("C-(" . insert-parentheses)
  ("C-)" . nil)
  ("C-~" . nil)
  ("C-%" . kam-query-replace-dwim)
  ("M-c" . capitalize-dwim)
  ("M-i" . kam-insert-new-line-below)
  ("M-l" . downcase-dwim)
  ("M-m" . kam-mark-line)
  ("M-g M-n" . next-error)
  ("M-g M-p" . previous-error)
  ("M-n" . kam-forward-paragraph)
  ("M-p" . kam-backward-paragraph)
  ("M-q" . fill-paragraph)
  ("M-t" . kam-transpose-words)
  ("M-u" . upcase-dwim)
  ("M-v" . undo-redo)
  ("M-w" . kam-kill-ring-save-dwim)
  ("M-z" . zap-up-to-char)
  ("M-!" . async-shell-command)
  ("M-;" . comment-dwim)
  ("M-:" . pp-eval-expression)
  ("M-&" . kam-jump-to-mark)
  ("M-<return>" . kam-insert-new-line-above)
  ("M-SPC" . mark-word)
  ("M-DEL" . kam-control-backspace)
  ("C-h c" . describe-char)
  ;; ("C-x 0" . nil)
  ;; ("C-x 1" . nil)
  ("C-x 3" . nil)
  ("C-x <left>" . kam-prev-buffer)
  ("C-x <right>" . kam-next-buffer)
  ("C-x k" . kam-kill-current-buffer)
  ("C-x n" . kam-narrow-or-widen-dwim)
  ;; ("C-x u" . undo)
  ;; ("C-x z" . undo-redo)
  ("C-x C-c" . kam-os-restart-emacs)
  ("C-x <kam-m>" . count-words)
  ("C-x C-n" . nil)
  ("C-x C-e" . kam-eval-current-sexp)
  ("C-x C-v" . mark-paragraph)
  ("C-x C-u" . nil)
  ("C-x C-z" . nil)
  ("C-c <tab>" . indent-relative)
  ("C-c q" . insert-char)
  ("C-M-<left>" . indent-rigidly-left)
  ("C-M-<right>" . indent-rigidly-right)
  ("C-M-," . nil)
  ("C-M-;" . kam-comment-todo)
  ("C-M-SPC" . kam-mark-sexp)
  ("C-M-(" . insert-parenthesis)
  ("C-M-=" . indent-region)
  ("C-M-a" . kam-beginning-of-sexp)
  ;; ("C-M-a" . sp-beginning-of-sexp)
  ("C-M-b" . backward-sexp)
  ("C-M-d" . down-list)
  ;; ("C-M-e" . sp-end-of-sexp)
  ("C-M-e" . kam-end-of-sexp)
  ("C-M-f" . forward-sexp)
  ("C-M-i" . kam-insert-new-line-above)
  ("C-M-k" . kill-sexp)
  ("C-M-n" . forward-list)
  ("C-M-p" . backward-list)
  ("C-M-u" . backward-up-list)
  ("C-M-y" . kam-duplicate-line-or-region)
  ("C-M-z" . kam-delete-pair-dwim)
  ("C-c w" . kam-writing-mode)
  ("<kam-i>" . indent-for-tab-command)
  (:map search-map
        ("M-g" . grep))
  (:map emacs-lisp-mode-map
        ("C-M-q" . kam-kill-inner-sexp))
  (:map occur-mode-map
        ("w" . occur-edit-mode))
  (:map goto-map
        ("M-c" . goto-char))
  :custom
  (user-full-name "Kamron Smith")
  (user-mail-address "kamrosmith@gmail.com")
  (user-lisp-directory (locate-user-emacs-file "lisp/"))
  (line-spacing 1)
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
  (fill-region-as-paragraph-function 'fill-region-as-paragraph-semlf)
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
  (yank-transform-functions '(string-chop-newline))
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  (global-so-long-mode 1)
  (global-prettify-symbols-mode)
  (global-font-lock-mode)

  (prefer-coding-system 'utf-8)
  (set-language-environment "UTF-8")
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)

  (remq 'process-kill-buffer-query-function
        kill-buffer-query-functions)

  (setenv "GPG_AGENT_INFO" nil)

  (defun kam-initial-setup ()
    "Sets up basic OS settings and if in the terminal.
To be used attached to `after-init-hook'."
    (cond
     ((eq system-type 'gnu/linux)
      (setq x-meta-keysym 'meta))
     ((eq system-type 'darwin)
      (setq mac-option-key-is-meta t
            mac-command-key-is-meta t
            mac-control-modifier 'control
            mac-command-modifier 'meta
            mac-option-modifier 'meta
            insert-directory-program (executable-find "gls"))
      (menu-bar-mode)
      (add-to-list 'default-frame-alist '(ns-appearance . dark))
      (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

      (defun kam-mac-copy-config-to-config-folder ()
        "Copy the init.el from the .dotfiles folder to the .config/emacs folder."
        (interactive)
        (copy-file
         (expand-file-name ".config/emacs/init.el" kam-dotfiles-directory)
         "/Users/kamronsmith/.config/emacs/init.el"
         t)
        (message "Copied config to emacs directory")))))

  (put 'narrow-to-region 'disabled nil)

  (keymap-global-set "C-M-(" 'insert-parentheses)
  (keymap-global-set "C-\"" 'kam-insert-quote)
  (keymap-global-set "M-\"" 'kam-insert-quote)

  (defvar-keymap kam-repeat-map
    :doc "General repeat map"
    :repeat t
    "n" 'kam-next-error-no-select
    "p" 'kam-previous-error-no-select
    "M-n" 'kam-next-error-no-select
    "M-p" 'kam-previous-error-no-select)

  (when (not (file-exists-p (expand-file-name "auto-saves" kam-emacs-cache-directory)))
    (make-directory (expand-file-name "auto-saves" kam-emacs-cache-directory)))

  (setq-default comment-column 0
                fill-column 100)

  (when (not kam-parrotos)
    (setq-default line-spacing '(1 . 1))))

(use-package minibuffer
  :ensure nil
  :hook ((minibuffer-setup . cursor-intangible-mode)
         (minibuffer-setup . kam-minibuffer-setup)
         (minibuffer-setup . minibuffer-nonselected-mode)
         (minibuffer-exit . kam-minibuffer-exit))
  :bind
  (:map minibuffer-local-map
        ("<kam-i>" . completion-at-point))
  :custom
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  (resize-mini-windows nil)
  (resize-mini-frames t)
  (enable-recursive-minibuffers t)
  (read-answer-short t)
  (minibuffer-visible-completions 'up-down)
  (crm-prompt (format "%s %%p" (propertize "[%d]" 'face 'shadow)))
  :config
  (defun kam-minibuffer-setup ()
    "Function for settings as the minibuffer starts."
    (setq gc-cons-threshold most-positive-fixnum
          truncate-lines t)
    ;; (setq-local line-spacing '(1 . 1))
    (face-remap-add-relative 'default :height 1.1)
    (pulsar-pulse-line)
    (buffer-face-mode)
    (centered-cursor-mode -1))

  (defun kam-minibuffer-exit ()
    "Function for settings as the minibuffer exits."
    (setq gc-cons-threshold (* 1000 1000 8))))

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

  (defun kam-detect-org-table ()
    "Return true if point in Org table."
    (and (derived-mode-p 'org-mode) (org-at-table-p)))
  (add-hook 'completion-preview-inhibit-functions
            #'kam-detect-org-table))

(use-package ibuffer
  :ensure nil
  :bind
  ([remap list-buffers] . ibuffer)
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
  ("C-l" . recenter)
  ("C-x 0" . kam-delete-window-dwim)
  ("C-x C-0" . kam-delete-window-dwim)
  ("C-x 1" . delete-other-windows)
  ("C-x C-1" . delete-other-windows)
  ("C-x 3" . kam-split-window-right)
  ("C-x C-3" . kam-split-window-right)
  ("C-<next>" . scroll-other-window)
  ("C-<prior>" . scroll-other-window-down)
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
  ;; (display-buffer-base-action '((display-buffer-same-window)
  ;;                               (reusable-frames . t)))
  (display-buffer-alist
   `(("\\*Async Shell Command\\*"
      (display-buffer-reuse-window display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.45)
      (window-parameters . ((mode-line-format . none))))
     ("Output\\*$"
      (display-buffer-reuse-window display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.45)
      (window-parameters . ((mode-line-format . none))))
     ("\\*Backtrace\\*"
      (display-buffer-reuse-window display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.35)
      (window-parameters . ((mode-line-format . none))))
     ("^\\*Warnings\\*$"
      (display-buffer-reuse-window display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.35)
      (window-parameters . ((mode-line-format . none))))
     ;; ("^\\*Messages\\*$"
     ;;  (display-buffer-reuse-window display-buffer-in-side-window)
     ;;  (side . bottom)
     ;;  (window . root)
     ;;  (window-height . 0.35)
     ;;  (window-parameters . ((mode-line-format . none))))
     ("^\\*Occur\\*"
      (display-buffer-reuse-window display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.45)
      (window-parameters . ((mode-line-format . none))))
     ("\\*Pp Eval Output\\*"
      (display-buffer-reuse-window display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.35))
     ("^\\*Pacman: "
      (display-buffer-reuse-window display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.45)
      (window-parameters . ((mode-line-format . none))))))
  :config
  (defvar-keymap kam-buffer-repeat-map
    :doc "Buffer repeat map"
    :repeat t
    "<left>" 'kam-prev-buffer
    "<right>" 'kam-next-buffer)

  (defun kam-split-window-conservatively (&optional window)
    "Split WINDOW only if absolutely necessary.
Only split if there is no split, and only split into left and right windows."
    (interactive)
    (let ((window (or window (selected-window))))
      (if (and
           (window-splittable-p window t)
           (= (length (window-list)) 1))
          (with-selected-window window
            (split-window-right))
        nil))))

(use-package lin
  :custom
  (lin-face 'lin-yellow))

(use-package centered-cursor-mode
  :bind
  (:map ccm-map
        ("C-v" . nil)
        ("M-v" . nil)
        ("<prior>" . nil)
        ("<next>" . nil))
  :custom
  (ccm-recenter-at-end-of-file t)
  :config
  (global-centered-cursor-mode)
  (add-to-list 'ccm-ignored-commands
               'ultra-scroll)

  (add-to-list 'ccm-ignored-commands
               'kam-keyboard-quit-dwim)
  (add-to-list 'ccm-ignored-commands
               'vertico-exit)
  (add-to-list 'ccm-ignored-commands
               'kam-quit-window)
  (add-to-list 'ccm-ignored-commands
               'quit-window)

  (defun kam-ccm-ignored-modes-p ()
    "Check if mode is listed under `kam-ccm-ignored-modes'."
    (and (eq major-mode (or 'minibuffer-mode
                            'minibuffer-inactive-mode))
         (seq-contains-p (kam-active-minor-modes) (or 'vertico-mode
                                                      'completion-list-mode))))

  (add-to-list 'ccm-inhibit-centering-when 'kam-ccm-ignored-modes-p)

  (defvar kam-ccm-ignored-modes '(minibuffer-mode
                                  minibuffer-inactive-mode
                                  vertico-mode
                                  completion-list-mode)))

(use-package pixel-scroll
  :ensure nil
  :bind
  (:map pixel-scroll-precision-mode-map
        ("<prior>" . kam-scroll-up)
        ("<next>" . kam-scroll-down)))

(use-package ultra-scroll
  :custom
  (scroll-margin 0)
  (scroll-conservatively 3)
  (scroll-preserve-screen-position t)
  (scroll-error-top-bottom t)
  (next-screen-context-lines 20)
  :config
  (ultra-scroll-mode 1))

(use-package dired
  :ensure nil
  :hook ((dired-mode . dired-hide-details-mode)
         (dired-mode . kam-dired-setup)
         (dired-after-readin . kam-dired-directory-add-to-history)
         ;; (dired-mode . kam-wdired-mode-setup)
         )
  :bind
  (:map dired-mode-map
        ("<mouse-2>" . dired-mouse-find-file)
        ("b" . dired-up-directory)
        ("o" . dired-do-open)
        ("i" . kam-dired-insert-subdir)
        ("R" . dired-do-rename)
        ("\\" . dired-create-empty-file)
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
  (defvar kam-automount-directory (format "/run/media/%s" user-login-name)
    "Directory under which drives are mounted.")

  (defun kam-dired-automount-open-in-dired ()
    "Open the automounted drive in `Dired'.
If there is more than one, let the user choose."
    (interactive)
    (let ((dirs (directory-files kam-automount-directory nil "^[^.]")))
      (dired (file-name-concat
              kam-automount-directory
              (cond ((null dirs)
                     (error "No drives mounted"))
                    ((= (length dirs) 1)
                     (car dirs))
                    (t
                     (completing-read "Open in Dired: " dirs nil t)))))))

  (defvar kam-dired-regexp-history nil
    "Minibuffer history of `kam-dired-regexp-prompt'.")

  (defun kam-dired-regexp-prompt ()
    (let ((default (car kam-dired-regexp-history)))
      (read-regexp
       (format-prompt "Files matching REGEXP" default)
       default 'kam-dired-regexp-history)))

  (defun kam-dired--get-files (regexp)
    "Return files matching REGEXP, recursively from `default-directory'."
    (directory-files-recursively default-directory regexp nil))

  (defun kam-dired-search-flat-list (regexp)
    "Return a Dired buffer for files matching REGEXP.
Perform the search recursively from the current directory."
    (interactive (list (kam-dired-regexp-prompt)))
    (if-let* ((files (kam-dired--get-files regexp))
              (relative-paths (mapcar #'file-relative-name files)))
        (dired (cons (format "kam-flat-dired for `%s'" regexp) relative-paths))
      (error "No files matching `%s'" regexp)))

  (defvar kam-dired--directory-header-regexp "^ +\\(.+\\):\n"
    "Pattern to match Dired directory headings.")

  (defun kam-dired-subdirectory-next (&optional arg)
    "Move to the next or optional ARGth Dired subdirectory header.
For more information, read `dired-maybe-insert-subdir'."
    (interactive "p")
    (let ((pos (point))
          (subdir kam-dired--directory-header-regexp))
      (goto-char (line-end-position))
      (if (re-search-forward subdir nil t (or arg nil))
          (progn
            (goto-char (match-beginning 1))
            (goto-char (line-beginning-position)))
        (goto-char pos))))

  (defun kam-dired-subdirectory-previous (&optional arg)
    "Move to the previous or optional ARGth Dired subdirectory heading.
For more information, read `dired-maybe-insert-subdir'."
    (interactive "p")
    (let ((pos (point))
          (subdir kam-dired--directory-header-regexp))
      (goto-char (line-beginning-position))
      (if (re-search-backward subdir nil t (or arg nil))
          (goto-char (line-beginning-position))
        (goto-char pos))))

  (defun kam-dired--dir-list (list)
    "Filter out non-directory file paths in LIST."
    (cl-remove-if-not
     (lambda (dir)
       (file-directory-p dir))
     list))

  (defun kam-dired-remove-inserted-subdirs ()
    "Remove all inserted Dired subdirectories."
    (interactive)
    (goto-char (point-max))
    (while (and (kam-dired-subdirectory-previous)
                (not (equal (dired-current-directory)
                            (expand-file-name default-directory))))
      (dired-kill-subdir)))

  (defun kam-dired--insert-dir (dir &optional flags)
    "Insert DIR using optional FLAGS."
    (dired-maybe-insert-subdir (expand-file-name dir) (or flags nil)))

  (defun kam-dired-insert-subdir (&optional arg)
    "Generic command to insert subdirectories in Dired buffers.

When items are marked, insert those which are subdirectories of the current directory. Ignore regular files.
If no files are active and point is on a subdirectory line, insert it directly.
If no files are active and point is not on a subdirectory line, prompt for a subdirectory using completion.
When optional ARG as a single prefix (`\\[universal-argument]') argument, prompt for command line flags to pass to the underlying ls program.
With optional ARG as a double prefix argument, remove all inserted subdirectories."
    (interactive "p")
    (let* ((name (dired-get-marked-files))
           (flags (when (eq arg 4)
                    (read-string "Flags for `ls' listing: "
                                 (or dired-subdir-switches dired-actual-switches)))))
      (cond
       ((eq arg 16)
        (kam-dired-remove-inserted-subdirs))
       ((and (length> name 1) (kam-dired--dir-list name))
        (mapc (lambda (file)
                (when (file-directory-p file)
                  (kam-dired--insert-dir file flags)))
              name))
       ((and (length= name 1) (file-directory-p (car name)))
        (kam-dired--insert-dir (car name) flags))
       (t
        (let ((selection (read-directory-name "Insert directory: ")))
          (kam-dired--insert-dir selection flags))))))

  (defun kam-dired--imenu-prev-index-position ()
    "Find the previous file in the buffer."
    (let ((subdir kam-dired-directory-header-regexp))
      (re-search-backward subdir nil t)))

  (defun kam-dired--imenu-extract-index-name ()
    "Return the name of the file at point."
    (file-relative-name
     (buffer-substring-no-properties (+ (line-beginning-position) 2)
                                     (1- (line-end-position)))))

  (defun kam-dired-setup ()
    (if hide-cursor-mode
        (hide-cursor-mode -1)
      (hide-cursor-mode 1))
    (if hl-line-mode
        (hl-line-mode -1)
      (hl-line-mode 1))
    ;; (hide-cursor-mode)
    ;; (hl-line-mode)
    (kam-dired-setup-imenu))

  (defun kam-dired-setup-imenu ()
    "Configure `Imenu' for the current Dired buffer."
    (set (make-local-variable 'imenu-prev-index-position-function)
         'kam-dired--imenu-prev-index-position)
    (set (make-local-variable 'imenu-extract-index-name-function)
         'kam-dired--imenu-extract-index-name))

  (defun kam-dired-mark-files-not-regexp (regexp)
    "Mark every file in a Dired buffer that does not match REGEXP."
    (interactive (list (read-regexp "Mark all files that are not (regexp): ")))
    (dired-mark-files-regexp regexp)
    (dired-toggle-marks))

  (defun kam-dired-kill-lines-not-regexp (regexp)
    "Kill all lines in a Dired buffer not matching a regexp."
    (interactive (list (read-regexp "Kill all lines that are not (regexp): ")))
    (kam-dired-mark-files-not-regexp regexp)
    (dired-do-kill-lines))

  (defun kam-dired-directory-kill-ring-save ()
    "Save the current `dired-directory' to the `kill-ring'."
    (interactive)
    (when (derived-mode-p 'dired-mode)
      (with-temp-buffer
        (insert dired-directory)
        (kill-ring-save (point-min) (point-max)))))

  (defvar kam-dired-directory-history nil
    "History of visited Dired directories.")

  (defun kam-dired-directory-add-to-history ()
    "Add the currently visited `dired-directory' to `kam-dired-directory-history'.
Duplicates are not saved."
    (when dired-directory
      (push dired-directory kam-dired-directory-history)
      (setq kam-dired-directory-history (delete-dups kam-dired-directory-history))))

  (define-minor-mode kam-dired-disable-revert-buffer-mode
    "Disable reverting the buffer in `dired-mode' when a file changes."
    :global nil
    (if kam-dired-disable-revert-buffer-mode
        (setq-local dired-do-revert-buffer nil
                    dired-auto-revert-buffer nil)
      (setq-local dired-do-revert-buffer (lambda (dir) (not (file-remote-p dir)))
                  dired-auto-revert-buffer t))))

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

(use-package dired-open)

(use-package dired-rainbow)

(use-package wdired
  :ensure nil
  :hook (wdired-mode . kam-wdired-mode-setup)
  :bind
  (:map dired-mode-map
        ("w" . wdired-change-to-wdired-mode))
  :custom
  (wdired-allow-to-change-permissions t)
  (wdired-create-parent-directories t)
  :config

  (defun kam-wdired-mode-setup ()
    (if hide-cursor-mode
        (hide-cursor-mode -1)
      (hide-cursor-mode 1))
    (if hl-line-mode
        (hl-line-mode -1)
      (hl-line-mode 1)))
  )

(use-package dired-subtree
  :after (dired)
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

(use-package trashed
  :commands (trashed)
  :hook ((trashed-mode . hide-cursor-mode)
         (trashed-mode . lin-mode))
  :bind
  ("C-c t" . trashed)
  :custom
  (trashed-action-confirmer 'y-or-n-p)
  (trashed-use-header-line t)
  (trashed-sort-key '("Date deleted" . t)))

(use-package reader
  :unless kam-parrotos
  :vc (:url "https://codeberg.org/MonadicSheep/emacs-reader"
            :make "all")
  :bind
  (:map reader-mode-map
        ("SPC" . reader-next-page)
        ("<backspace>" . reader-previous-page)
        ("C-SPC" . kam-reader-goto-saved-page)
        ("M-g M-i" . kam-reader-imenu))
  ;; TODO 2026-07-15: figure out why reader-outline-mode-map is void when trying to set keybindings
  ;; (:map reader-outline-mode-map
  ;;       ("SPC" . kam-scroll-down)
  ;;       ("<backspace>" . kam-scroll-up))
  :config
  (defvar kam-reader-saved-page nil
    "Saved page for `reader-mode'")

  (defun kam-reader-save-page (N)
    (interactive (list
                  (reader-current-pagenumber)))
    (setq kam-reader-saved-page N))

  (defun kam-reader-goto-saved-page ()
    (interactive)
    (let* ((prev-pg-number (reader-current-pagenumber)))
      (reader-goto-page kam-reader-saved-page)
      (kam-reader-save-page prev-pg-number)))

  (defun kam-reader-imenu ()
    "Call `imenu', but save the current page number in `kam-reader-saved-page'."
    (interactive)
    (kam-reader-save-page (reader-current-pagenumber))
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
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (mode . edmacro-mode)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none))))))

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

  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*Help\\*"
  ;;                (display-buffer-reuse-window display-buffer-in-side-window)
  ;;                (side . right)
  ;;                (window . root)
  ;;                (mode help-mode)))

  (add-to-list 'display-buffer-alist
               '("\\*Error\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window-width . 0.35)
                 (mode help-mode)
                 (window-parameters . ((mode-line-format . none)
                                       (no-delete-other-windows . t)))))

  (with-eval-after-load 'consult
    ;; (add-to-list 'consult-buffer-filter
    ;;              "^\\*Help\\*" t)
    (add-to-list 'consult-buffer-filter
                 "^\\*Error\\*" t)
    (add-to-list 'consult-buffer-filter
                 "\\*Shell Command Output\\*" t)
    ;; (add-to-list 'consult-buffer-filter
    ;;              "\\*Messages\\*" t)
    )

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*Shell Command Output\\*" t)
  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*Messages\\*" t)
  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*Help\\*" t)
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
  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*Apropos\\*"
  ;;                (display-buffer-reuse-window display-buffer-in-side-window)
  ;;                (side . right)
  ;;                (window-width . 0.5)
  ;;                (mode apropos-mode)
  ;;                (window-parameters . ((mode-line-format . none)
  ;;                                      (no-delete-other-windows . t)))))
  (add-to-list 'consult-buffer-filter
               "\\*Apropos\\*"))

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
        ("j" . Info-next-reference)
        ("k" . Info-prev-reference)
        ("<next>" . scroll-down-line)
        ("<prior>" . scroll-up-line))
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Info\\*"
                 (display-buffer-reuse-window
                  display-buffer-use-least-recent-window
                  display-buffer-in-direction)
                 (direction . right)
                 (inhibit-same-window . t)
                 (mode . Info-mode)))

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "^\\*Info\\*" t)

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
  (Man-notify-method 'pushy)
  :config
  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*Man "
  ;;                (display-buffer-reuse-window display-buffer-in-side-window)
  ;;                (side . right)
  ;;                (window-width . 0.5)
  ;;                (mode . Man-mode)
  ;;                (window-parameters . ((mode-line-format . none)
  ;;                                      (no-delete-other-windows . t)))))

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "^\\*Man " t)

  ;; (with-eval-after-load 'consult
  ;;   (add-to-list 'consult-buffer-filter
  ;;                "^\\*Man " t))
  )

(use-package emacs-news-mode
  :ensure nil
  :hook (emacs-news-mode . (lambda () (when visual-fill-column-mode
                                   (visual-fill-column-mode -1)))))

(defun kam-get-buffers-matching-mode (mode)
  "Returns a list of the buffers where their major-mode is equal to MODE."
  (let ((buffer-mode-matches '()))
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (eq mode major-mode)
          (push buf buffer-mode-matches))))
    buffer-mode-matches))

(defun kam-multi-occur-in-this-mode ()
  "Show all lines matching REGEXP in buffers with the current buffer's major-mode."
  (interactive)
  (multi-occur
   (kam-get-buffers-matching-mode major-mode)
   (car (occur-read-primary-args))))

(use-package re-builder
  :ensure nil
  :bind
  (:map reb-mode-map
        ("RET" . newline)
        ("C-c RET" . kam-re-builder-replace-regexp)
        ("C-g" . reb-quit)
        :map reb-lisp-mode-map
        ("RET" . newline)
        ("C-c RET" . kam-re-builder-replace-regexp)
        ("C-g" . reb-quit))
  :custom
  (reb-re-syntax 'string)
  :config
  (defvar kam-re-builder-positions nil
    "Store point and region bounds before calling re-builder")

  (advice-add 're-builder :before
              (defun kam-re-builder-save-state (&rest _)
                "Save into `kam-rebuilder-positions' the point and the region before calling `re-builder'."
                (setq kam-re-builder-positions
                      (cons (point)
                            (when (region-active-p)
                              (list (region-beginning)
                                    (region-end)))))))

  (defun kam-re-builder-replace-regexp (&optional delimited)
    "Run `query-replace-regexp' with the contents of 're-builder'.
With non-nil optional argument DELIMITED, only replace matches surrounded by actual boundaries."
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
        (setq kam-re-builder-positions nil)
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

(defun kam-find-file-auto-create-missing-dirs ()
  (let ((target-dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))))

(add-to-list 'find-file-not-found-functions #'kam-find-file-auto-create-missing-dirs)

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :custom
  (recentf-autosave-interval 300)
  (recentf-max-saved-items 5000)
  (recentf-max-menu-items 5000)
  (recentf-auto-cleanup (if (daemonp) 300 'never))
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
  (advice-add #'recentf-cleanup :around #'kam-call-function-quietly)
  (advice-add #'recentf-save-list :around #'kam-call-function-quietly)
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

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
  :hook (proced-mode . kam-proced-settings)
  :bind
  ("C-c p" . proced)
  :custom
  (proced-auto-update-flag 'visible)
  (proced-enable-color-flag t)
  (proced-auto-update-interval 1)
  (proced-descend t)
  (proced-filter 'user)
  :config
  (defun kam-proced-settings ()
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
  :ensure nil
  :config
  (defun kam-font-faces-setup ()
    (set-face-attribute 'default nil :font "Aporetic Sans Mono" :height 140 :weight 'regular :width 'regular)
    (set-face-attribute 'fixed-pitch nil :font "Aporetic Sans Mono" :height 1.0 :weight 'regular :width 'regular)
    (set-face-attribute 'variable-pitch nil :family "Aporetic Sans Mono" :height 1.0 :weight 'regular :width 'regular))

  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (with-selected-frame frame
                    (kam-font-faces-setup)
                    (run-hooks 'standard-themes-after-load-theme-hook))))
    (kam-font-faces-setup)
    (load-theme 'standard-dark :no-confirm)
    (run-hooks 'standard-themes-after-load-theme-hook)))

(use-package ligature
  :config
  ;; default configuration for Iosevka font
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++"))
  (global-ligature-mode t))

(use-package unicode-fonts
  :config
  (unicode-fonts-setup))

(use-package vertico
  :hook (after-init . vertico-mode)
  :bind
  (:map vertico-map
        ("C-." . embark-act)
        ("<kam-i>" . vertico-insert)
        ("<escape>" . kam-keyboard-quit-dwim)
        ("<next>" . vertico-scroll-up)
        ("<prior>" . vertico-scroll-down)
        ("M-<return>" . vertico-exit-input)
        ("M-w" . vertico-save)
        ("M-<" . vertico-first)
        ("M->" . vertico-last)
        ("<up>" . nil)
        ("<down>" . nil)
        ("C-<return>" . minibuffer-force-complete-and-exit)
        ("C-g" . kam-keyboard-quit-dwim))
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
  :ensure nil
  :after (vertico)
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :bind
  (:map vertico-map
        ("<backspace>" . vertico-directory-delete-char)
        ("C-<backspace>" . vertico-directory-delete-word)))

(use-package vertico-multiform
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

  (setq vertico-multiform-categories
        `((embark-keybinding grid)
          ;; (consult-location ,@kam-vertico-multiform-maximal)
          ;; (imenu ,@kam-vertico-multiform-maximal)
          ;; (unicode-name ,@kam-vertico-multiform-maximal)
          ;; (multi-category ,@kam-vertico-multiform-maximal)
          ;; (file ,@kam-vertico-multiform-minimal
          ;;       (vertico-sort-function . vertico-sort-directories-first)
          ;;       (:keymap . vertico-directory-map))
          ))

  (setq vertico-multiform-commands
        `((jinx-correct grid (vertico-grid-annotate . 20))
          ;; (execute-extended-command ,@kam-vertico-multiform-minimal)
          ;; (kam-consult-buffer ,@kam-vertico-multiform-minimal
          ;;                     (vertico-sort-function . nil))
          (consult-ripgrep buffer)
          (consult-buffer (vertico-sort-function . nil))
          ;; (project-find-file ,@kam-vertico-multiform-minimal)
          ))

  (vertico-multiform-mode 1))

(use-package vertico-sort
  :ensure nil
  :after (vertico))

(use-package consult
  :bind
  (:map global-map
        (([remap Info-search] . consult-info)
         ([repeat-complex-command] . consult-complex-command)
         ([remap goto-line] . consult-goto-line)
         ([remap yank-pop] . consult-yank-pop)
         ([remap bookmark-jump] . consult-bookmark)
         ([remap switch-to-buffer] . consult-buffer)
         ([remap imenu] . consult-imenu)
         ("C-M-x" . consult-mode-command)
         ("C-x b" . consult-buffer)
         ("C-x C-b" . consult-buffer)
         ("C-x r s" . consult-register-store)
         ("C-x r l" . consult-register-load)
         :map search-map
         ("M-f" . consult-fd)
         ("M-k" . consult-keep-lines)
         ("M-u" . consult-focus-lines)
         ;; ("M-l" . consult-line)
         ("M-p" . kam-consult-line-symbol-at-point)
         ("M-d" . consult-line)
         :map goto-map
         ("M-l" . consult-flymake)
         ("M-e" . consult-compile-error)
         ("M-o" . consult-org-heading)
         ("M-i" . consult-imenu)
         ("M-m" . consult-mark)
         ("M-k" . consult-global-mark)
         :map isearch-mode-map
         ("M-r" . consult-isearch-history)
         ("M-s M-l" . kam-consult-isearch)
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history)
         :map project-prefix-map
         ("l" . consult-line-multi)
         ("i" . consult-imenu-multi)
         ("b" . consult-project-buffer)
         :map help-map
         ("s" . kam-consult-search-emacs-info-pages)))
  :custom
  (register-preview-delay 0)
  (register-preview-function #'consult-register-format)
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)
  (consult-narrow-key ">")
  (consult-async-min-input 3)
  (consult-buffer-list-function #'buffer-list)
  (consult-preview-key nil)
  (consult-ripgrep-args
   "rg --null --follow --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --search-zip --hidden --glob=!.git ")
  (consult-fd-args "fd --follow --hidden --full-path --color=never ")
  :config
  (advice-add #'register-preview :override #'consult-register-window)
  (add-to-list 'consult-preview-allowed-hooks 'global-org-modern-mode)
  (add-to-list 'consult-preview-allowed-hooks 'olivetti-mode)
  (add-to-list 'consult-preview-allowed-hooks 'variable-pitch-mode)
  (add-to-list 'consult-preview-allowed-hooks 'buffer-face-mode)

  (defvar kam-consult-search-ignored-dirs
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
      "dist")
    "A list of directories to ignore when performing searches using Consult.")

  (add-to-list 'consult-buffer-filter
               "-shell\\*$")
  (add-to-list 'consult-buffer-filter
               "\\*Customize ")
  (add-to-list 'consult-buffer-filter
               "-eshell\\*$")
  (add-to-list 'consult-buffer-filter
               "^\\*Backtrace\\*$" t)

  ;; (advice-add 'consult-yank-pop :after 'kam-indent-region-advice)

  (setq consult-buffer-sources
        '(
          ;; kam-consult-source-tab
          consult-source-buffer
          ;; consult-source-project-buffer
          kam-consult-source-project-files
          kam-consult-source-project
          kam-consult-source-neighbor-file
          kam-consult-source-bookmark
          kam-consult-source-recent-file
          ;; kam-consult-source-dired-history
          consult-source-hidden-buffer
          ))

  (defvar kam-consult-source-bookmark
    `( :name     "Bookmark"
       :hidden   t
       :narrow   ?m
       :category bookmark
       :face     consult-bookmark
       :history  bookmark-history
       :items    ,#'bookmark-all-names
       :state    ,#'consult--bookmark-state)
    "Bookmark source for `consult-buffer'.
Hidden by default.")

  (defvar kam-consult-source-recent-file
    `( :name     "Recent Files"
       ;; :hidden   t
       :narrow   ?r
       :category file
       :face     consult-file
       :history  file-name-history
       :state    ,#'consult--file-state
       :new      ,#'consult--file-action
       :enabled  ,(lambda () recentf-mode)
       :items
       ,(lambda ()
          (let ((ht (consult--buffer-file-hash))
                items)
            (dolist (file (bound-and-true-p recentf-list) (seq-take (nreverse items) 25))
              (unless (eq (aref file 0) ?/)
                (let (file-name-handler-alist) ;; No Tramp slowdown please.
                  (setq file (expand-file-name file))))
              (unless (gethash file ht)
                (push (consult--fast-abbreviate-file-name file) items))))))
    "Recent file source for `consult-buffer'.
Copied from the Consult code but adjusted to only take the top 25 candidates.")

  (defvar kam-consult-source-project-files
    `(:name "Project Files"
            :narrow ?f
            :hidden t
            :category file
            :face consult-file
            :history kam-consult-source-project-files-history
            ;; :state ,#'consult--file-state     creates new files before the action is completed
            :new ,#'consult--file-action
            :enabled ,(lambda () (kam-buffer-has-project-p (current-buffer)))
            :action ,(lambda (file)
                       (find-file (expand-file-name file (project-root (project-current nil)))))
            :items ,#'kam-project-files)
    "Project file source for `consult-buffer'.
This source is only enabled when the current buffer belongs to a project.")

  (defvar kam-consult-source-project-files-history nil
    "Minibuffer history for `kam-consult-source-project-files'.")

  (defvar kam-consult-source-dired-history
    `(:name "Dired History"
            :narrow ?d
            :category file
            :face consult-file
            :history kam-dired-directory-history
            :state ,#'consult--file-state
            :items (lambda () (mapcar #'identity kam-dired-directory-history))))

  (consult-customize consult-buffer :preview-key nil)
  (consult-customize consult-imenu :preview-key nil))

(use-package consult-dir
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

  (setq consult-dir-sources
        '(consult-dir--source-bookmark
          ;; kam-consult-source-dired-history
          consult-dir--source-default
          consult-dir--source-project
          consult-dir--source-recentf
          consult-dir--source-tramp-local
          ;; kam-consult-dir--source-jumps
          )))

;; (use-package consult-flycheck
;;   :bind
;;   (:map goto-map
;;         ("M-l" . consult-flycheck)))

(use-package marginalia
  :custom
  (marginalia-field-width 100)
  :config
  (setq marginalia-align 'left
        marginalia-align-offset 20)
  (marginalia-mode))

(use-package embark
  :after (vertico)  ;; load after vertico to avoid vertico-map is void error
  :bind
  ([remap describe-bindings] . embark-bindings)
  ("C-." . embark-act)
  (:map minibuffer-local-map
        ("C-c C-c" . embark-collect)
        ("C-c C-e" . embark-export))
  (:map embark-general-map
        ("SPC" . embark-cycle)
        ("." . embark-cycle))
  (:map embark-expression-map
        (";" . kam-comment-dwim))
  (:map embark-region-map
        ("a" . align-regexp))
  :custom
  (prefix-help-command #'embark-prefix-help-command)
  (embark-prompter #'embark-keymap-prompter)
  (embark-indicators '(embark-highlight-indicator
                       embark-isearch-highlight-indicator))
  :config
  (add-to-list 'display-buffer-alist
               '("^\\*Embark Export:"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.5)
                 (mode apropos-mode)
                 (window-parameters . ((mode-line-format . none))))))

(use-package embark-consult)

(use-package orderless
  :config
  (defun kam-orderless--consult-suffix ()
    "Regexp which matches the end of string with Consult tofu support."
    (if (and (boundp 'consult--tofu-char) (boundp 'consult--tofu-range))
        (format "[%c-%c]*$"
                consult--tofu-char
                (+ consult--tofu-char consult--tofu-range -1))
      "$"))

  (defun kam-orderless-consult-dispatch (word _index _total)
    (cond
     ((string-suffix-p "$" word)
      `(orderless-regexp . ,(concat (substring word 0 -1) (kam-orderless--consult-suffix))))
     ((and (or minibuffer-completing-file-name
               (derived-mode-p 'eshell-mode))
           (string-match-p "\\`\\.." word))
      `(orderless-regexp . ,(concat "\\." (substring word 1) (kam-orderless--consult-suffix))))))

  (orderless-define-completion-style kam-orderless-with-initialism
    (orderless-matching-styles '(orderless-initialism orderless-literal orderless-regexp)))

  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion))
                                        (command (styles kam-orderless-with-initialism))
                                        (variable (styles kam-orderless-with-initialism))
                                        (symbol (styles kam-orderless-with-initialism)))
        orderless-component-separator #'orderless-escapable-split
        orderless-style-dispatchers (list #'kam-orderless-consult-dispatch
                                          #'orderless-affix-dispatch)))

(use-package corfu
  :bind
  (:map corfu-map
        ("<return>" . corfu-insert)
        ("<kam-i>" . corfu-insert)
        ("M-SPC" . corfu-insert-separator)
        ("<next>" . corfu-scroll-up)
        ("<prior>" . corfu-scroll-down)
        ("C-g" . corfu-quit))
  :init
  (global-corfu-mode)
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
  :init
  (corfu-history-mode)
  :config
  (with-eval-after-load 'save-hist
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package corfu-popupinfo
  :ensure nil
  :after (corfu)
  :config
  (corfu-popupinfo-mode))

(use-package cape
  :bind
  ("C-c h h" . cape-history)
  ("C-c h f" . cape-file)
  :hook ((prog-mode . kam-cape-prog-mode-setup)
         (text-mode . kam-cape-text-mode-setup))
  :custom
  (completion-at-point-functions '(cape-dabbrev cape-file))   ; global values
  :config
  (defun kam-cape-text-mode-setup ()
    "Set up `cape' for text."
    (setq-local completion-at-point-functions
                '(cape-dict
                  cape-dabbrev
                  cape-emoji)))

  (defun kam-cape-prog-mode-setup ()
    "Set up `cape' for programming."
    (setq-local completion-at-point-functions
                '(cape-file
                  cape-keyword
                  ;; cape-line
                  cape-dabbrev
                  t))))

(use-package avy
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

  (defun kam-avy-action-kam-cut (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (kam-cut-dwim))
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

  (defun kam-avy-zap-to-char ()
    (interactive)
    (avy-with avy-goto-char-timer
      (avy-action-zap-to-char pt)))

  (setf (alist-get ?. avy-dispatch-alist) 'kam-avy-action-embark)
  (setf (alist-get ?w avy-dispatch-alist) 'kam-avy-action-kam-cut)
  (setf (alist-get ?o avy-dispatch-alist) 'kam-avy-action-org-refile)
  (setf (alist-get ?v avy-dispatch-alist) 'kam-avy-action-mark-to-char)
  (setf (alist-get ?l avy-dispatch-alist) 'kam-avy-action-org-store-link)
  (setf (alist-get ?p avy-dispatch-alist) 'kam-avy-action-consult-line-at-point)
  (setf (alist-get ?q avy-dispatch-alist) 'kam-avy-action-kill-inner-sexp))

(use-package ace-window
  :after (diff)
  :bind
  ("M-o" . kam-ace-window)
  ;; ("C-x o" . kam-ace-window-prefix)
  (:map diff-mode-map
        ("M-o" . ace-window))
  :config
  (setq aw-dispatch-always t)
  (setq aw-keys '(?d ?n ?r ?e ?t ?a))
  (setq aw-dispatch-alist
        '((?m aw-swap-window "Swap Windows")
          (?M aw-move-window "Move Window")
          (?c aw-copy-window "Copy Window")
          (?v aw-split-window-vert "Split Vert Window")
          (?h aw-split-window-horz "Split Horz Window")
          (?b kam-aw-consult-buffer "Select Buffer")
          (?o kam-aw-one-command "Run command")
          (?1 delete-other-windows "Delete Other Windows")
          (?0 kam-aw-delete-window "Delete Window")
          (?? aw-show-dispatch-help))))

(use-package popper
  :after (org consult)
  :hook (popper-open-popup . kam-popper-select-popup)
  :bind
  (("C-," . popper-toggle)
   ("C-M-," . popper-cycle)
   ("C-M-#" . popper-toggle-type))
  (:map org-mode-map
        ("C-," . popper-toggle))
  :custom
  (popper-reference-buffers
   '(
     ;; ("\\*Messages\\*")
     ;; ("\\*compilation\\*")
     ("Output\\*$")
     ;; ("\\*Apropos\\*")
     ("\\*Async Shell Command\\*")
     ("\\Org Agenda\\*")
     ;; ("\\*Grep\\*")
     ("\\*Backtrace\\*")
     ;; ("\\*Warnings\\*")
     ;; ("\\*shell\\*")
     ("\\*eshell[\:\*]")
     ("-eshell\\*$")
     ("-shell\\*$")
     ("\\*eat\\*")
     ("\\*Compile-Log\\*")
     ("\\*Playlist\\*")
     ("^\\*Pacman:")
     ("^\\*Timeshift:")
     ("\\*ChatGPT\\*")
     ("\\*eldoc\\*")
     emms-playlist-mode
     ;; Man-mode
     ;; help-mode
     ;; Info-mode
     ;; Grep-mode
     ;; shell-command-mode
     ;; comint-mode
     ))
  (popper-display-control nil)
  :config
  (popper-mode)
  (popper-echo-mode)

  (defun kam-popper-buffer-p (buf)
    "Return non-nil if BUF is a Popper-controlled buffer."
    (let ((name (buffer-name buf)))
      (or (cl-some (lambda (re)
                     (string-match-p re name))
                   popper--reference-names)
          (with-current-buffer buf
            (derived-mode-p popper--reference-modes)))))

  (defun kam-popper-select-popup ()
    "Select the popup when it is opened.
Used in `popper-open-popup-hook'."
    (select-window (get-buffer-window (current-buffer))))

  (defun kam-popper-popup-open-p ()
    "Return t if a Popper popup is currently displayed."
    (when popper-open-popup-alist
      t))

  (setq consult-preview-excluded-buffers
        (lambda (buf)
          (kam-popper-buffer-p buf)))

  (add-to-list 'popper-reference-buffers
               (list "consult-\\(.*\\)?\\(find\\|grep\\|ripgrep\\|fd\\)")))

;; (defun kam-tab-new-tab-one-command ()
;;   "Create a new tab and and run a command in the newly created tab."
;;   (interactive)
;;   (tab-new)
;;   (let* ((command (key-binding
;;                 (read-key-sequence
;;                  (format "Run in %s..." (tab-bar-tab-name-current)))))
;;       (this-command command))
;;     (call-interactively command)))

(use-package tab-bar
  :ensure nil
  :defer t
  ;; :bind (:map tab-bar-mode-map
  ;;             ("C-x t n" . tab-next)
  ;;             ("C-x t p" . tab-previous)
  ;;             ("C-x t +" . tab-close)
  ;;             ("C-\\" . kam-consult-tab)
  ;;             ("C-<tab>" . nil)
  ;;             ("C-S-<tab>" . nil))
  :init
  (defun tab-bar-tab-group-format-default (tab _i &optional current-p)
    (propertize
     (concat (funcall tab-bar-tab-group-function tab))
     'face (if current-p 'tab-bar-tab-group-current 'tab-bar-tab-group-inactive)))

  ;; (tab-bar-mode 1)
  :custom
  (tab-bar-show nil)
  (tab-bar-close-button-show nil)
  (tab-bar-new-button nil)
  (tab-bar-tab-hints t)
  (tab-bar-auto-width nil)
  (tab-bar-separator " ")
  ;; (tab-bar-format '(tab-bar-format-tabs-groups
  ;; tab-bar-format-tabs
  ;; tab-bar-separator)
  (tab-bar-format '(tab-bar-format-history tab-bar-format-tabs tab-bar-separator))

  :config
  (keymap-set ctl-x-map "t" nil)
  (defun kam-tab-bar-group-from-project ()
    "Call `tab-group' with the current project name as the group."
    (interactive)
    (when-let* ((proj (project-current))
                (name (file-name-nondirectory
                       (directory-file-name (project-root proj)))))
      (tab-group (format "%s" name))))

  (defun kam-tab-bar-show ()
    "Toggle the visibility of the tab bar."
    (interactive)
    (if tab-bar-show
        (setopt tab-bar-show nil)
      (setopt tab-bar-show t)))

  (defvar-keymap kam-tab-bar-repeat-map
    :repeat t
    :doc "Repeat map for tabs"
    "p" 'tab-previous
    "n" 'tab-next))

(defun kam-keyboard-quit-dwim ()
  "A better keyboard quit."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   ((identity defining-kbd-macro)
    (kmacro-keyboard-quit))
   (t
    (keyboard-escape-quit))))

(defun kam-keyboard-escape-quit-advice (fun)
  "Around advice for `keyboard-escape-quit', call FUN.
Preserve window configuration when pressing \\[keyboard-escape-quit]."
  (let ((buffer-quit-function (or buffer-quit-function #'ignore)))
    (funcall fun)))

(advice-add #'keyboard-escape-quit :around #'kam-keyboard-escape-quit-advice)

(defun kam-kill-current-buffer (&optional arg)
  "Kill the current buffer, without prompting the user.
With optional prefix ARG (\\[universal-argument]), delete the buffer's window as well.

This command works similarly to `kam-delete-window-dwim', just in reverse."
  (interactive "P")
  (let ((kill-buffer-query-functions nil))
    (if arg
        (kill-buffer-and-window)
      (kill-buffer))))

;;; Isearch
(use-package isearch
  :ensure nil
  :hook (isearch-update-post . kam-isearch-goto-match-beginning)
  :bind
  (:map isearch-mode-map
        ("C-g" . kam-isearch-quit)
        ;; ("<backspace>" . kam-isearch-removed-failed-or-last-char)
        ("C-." . kam-isearch-yank-symbol))
  :custom
  (isearch-lazy-count t)
  (isearch-lazy-count-prefix-format "(%s/%s)")
  (isearch-lazy-count-suffix-format nil)
  (isearch-repeat-on-direction-change t)
  (isearch-whitespace-regexp ".*?")
  (isearch-allow-scroll 'unlimited)
  :config
  (defun kam-isearch-removed-failed-or-last-char ()
    "Remove failed part of search string, or last char if successful.
Do nothing if search string is empty to start with."
    (interactive)
    (if (string-equal isearch-string "")
        (isearch-update)
      (if isearch-success
          (isearch-delete-char)
        (while (isearch-fail-pos) (isearch-pop-state)))
      (isearch-update)))

  (defun kam-isearch-quit ()
    "Cancel the current Isearch."
    (interactive)
    (setq isearch-success nil)
    (isearch-cancel))

  (defun kam-isearch-goto-match-beginning ()
    "Go to the start of current Isearch match.
Used in `isearch-mode-end-hook'."
    (when (and (not (eq this-command 'isearch-exit))
               isearch-forward
               (number-or-marker-p isearch-other-end)
               (not mark-active)
               (not isearch-mode-end-hook-quit))
      (goto-char isearch-other-end)))

  (defun kam-isearch-yank-symbol ()
    (interactive)
    (isearch-yank-string (thing-at-point 'symbol t))))

(use-package drag-stuff
  :bind
  (("M-<up>" . drag-stuff-up)
   ("M-<down>" . drag-stuff-down)))

(use-package grep
  :ensure nil
  :hook ((grep-mode . kam-grep-setup)
         (grep-edit-mode . kam-grep-edit-setup))
  :bind
  (("M-s g" . grep)
   :map grep-mode-map
   ("C-c C-p" . compilation-previous-file)
   ("C-c C-n" . compilation-next-file)
   ("w" . grep-change-to-grep-edit-mode)
   ("n" . compilation-next-error)
   ("p" . compilation-previous-error)
   ("M-g M-n" . next-error-no-select)
   ("M-g M-p" . previous-error-no-select)
   ("<return>" . kam-compile-goto-error)
   ("}" . compilation-next-file)
   ("{" . compilation-previous-file)
   :map grep-edit-mode-map
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
                 (display-buffer-reuse-window 
                  display-buffer-use-least-recent-window
                  display-buffer-in-direction)
                 (direction . right)
                 ;; (inhibit-same-window . t)
                 (body-function . select-window)))

  (defun kam-grep-setup ()
    "Setup function for `grep-mode'."
    (hide-cursor-mode)
    (hl-line-mode))

  (defun kam-grep-symbol-at-point ()
    "Start a `grep' search for the symbol at point.
If the current buffer belongs to a project, run the grep command in the project directory."
    (interactive)
    (let* ((sym (thing-at-point 'symbol t))
           (command (concat grep-command sym))
           (default-directory (or (when (kam-buffer-has-project-p (current-buffer))
                                    (project-root (project-current)))
                                  default-directory)))
      (grep command)))

  (defun kam-grep-edit-setup ()
    "Setup function for `grep-edit-mode'."
    (hide-cursor-mode -1))

  ;; (with-eval-after-load 'consult
  ;;   (add-to-list 'consult-buffer-filter
  ;;                "\\*grep\\*" t))
  )

(use-package link-hint
  :bind
  ("C-M-j" . link-hint-open-link))

(use-package smartparens
  :bind
  ("C-M-o" . sp-up-sexp)
  ("C-M-DEL" . sp-backward-kill-sexp))

(use-package paren
  :ensure nil
  :custom
  (show-paren-context-when-offscreen 'child-frame)
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
  (save-place-mode))

(use-package subword
  :ensure nil
  :init
  (global-subword-mode))

(use-package dumb-jump
  :init
  (with-eval-after-load 'xref
    (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 80))
  (setq dumb-jump-aggressive nil)
  (setq dumb-jump-max-find-time 3)
  (setq dumb-jump-selector 'completing-read)
  :config
  (when (executable-find "rg")
    (setq dumb-jump-force-searcher 'rg
          dumb-jump-prefer-searcher 'rg)))

(use-package electric
  :ensure nil
  :hook ((org-mode . electric-indent-local-mode)
         ;; (prog-mode . electric-indent-mode)
         (text-mode . electric-quote-mode))
  :custom
  (electric-indent-actions '(yank))
  :config
  (electric-pair-mode)

  ;; (add-to-list 'electric-pair-pairs
  ;;              '("/*" . "*/"))

  ;; (add-to-list 'electric-pair-text-pairs
  ;;              '("/*" "*/") t)
  )

(use-package aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package visible-mark
  :custom
  (visible-mark-max 1)
  (visible-mark-forward-max 2)
  :config
  (global-visible-mark-mode))

(use-package vundo
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
  :bind
  ("M-g M-." . ffap))

(use-package multiple-cursors
  :bind
  (("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this))
  :custom
  (mc/list-file (expand-file-name "mc-lists.el" kam-emacs-cache-directory)))

(use-package expreg
  :hook
  (text-mode . kam-expreg-text-mode-setup)
  :bind
  ("C-&" . expreg-expand)
  ("C-M-m" . kam-mark-inner-sexp)
  ("C-M-q" . kam-kill-inner-sexp)
  (:map prog-mode-map
        ("C-M-q" . kam-kill-inner-sexp))
  (:repeat-map expreg-repeat-map
               ("&" . expreg-expand))
  :config
  (defun kam-expreg-text-mode-setup ()
    "Set up text mode for expreg."
    (add-to-list 'expreg-functions #'expreg--sentence)
    (when (eq major-mode 'org-mode)
      (add-to-list 'expreg-functions #'kam-expreg--org-heading t)
      (add-to-list 'expreg-functions #'kam-expreg--org-element t))))

(defun kam-mark-sexp ()
  "Mark symbolic expression at or near point.
Repeat to extend the region forward to the next symbolic expression."
  (interactive)
  (if (and (region-active-p)
           (eq last-command this-command))
      (ignore-errors (forward-sexp 1))
    (when-let* ((thing (cond
                        ((thing-at-point 'url) 'url)
                        ((thing-at-point 'sexp) 'sexp)
                        ((thing-at-point 'string) 'string)
                        ((thing-at-point 'word) 'word))))
      (kam--mark (bounds-of-thing-at-point thing)))))

(defun kam-mark-line (&optional arg allow-extend)
  "Put mark at beginning of the line, point at end.

With argument ARG, puts mark at end of a following line, so that
the number of lines marked equals ARG.

If ARG is negative, point is put at end of this line, mark is put
at beginning of this or a previous line.

Interactively (or if ALLOW-EXTEND is non-nil), if this command is
repeated or (in Transient Mark mode) if the mark is active,
it marks the next ARG lines after the ones already marked."
  (interactive "P\np")
  (cond ((and allow-extend
              (or (and (eq last-command this-command) (mark t))
                  (region-active-p)))
         (setq arg (if arg (prefix-numeric-value arg)
                     (if (> (mark) (point)) -1 1)))

         ;; (goto-char (mark))
         (forward-line arg)
         (end-of-line))
        (t
         (progn
           (end-of-line)
           (set-mark
            (line-beginning-position))))))

(defun kam-mark-line-with-newline ()
  "Select the whole line with the newline of the previous line."
  (interactive)
  (if (eq visual-line-mode t)
      (kam--mark
       (cons (line-beginning-position)
             (save-excursion
               (forward-line 1)
               (line-beginning-position))))
    (kam--mark
     (cons (line-beginning-position)
           (save-excursion
             (forward-line 1)
             (save-excursion
               (line-beginning-position)))))))

(defun kam-mark-point-to-end-of-line ()
  "Set the mark at the end of the line, regardless of where the cursor is on the line."
  (interactive)
  (if (eq visual-line-mode t)
      (kam--mark
       (cons
        (point)
        (point (end-of-visual-line))))
    (kam--mark
     (cons
      (point)
      (line-end-position)))))

(defun kam-mark-point-to-end-of-buffer ()
  "Mark from the point to the end of the buffer."
  (interactive)
  (set-mark
   (save-excursion
     (goto-char (point-max))
     (point))))

(define-advice pop-global-mark (:around (pgm) use-display-buffer)
  "Make `pop-to-buffer' jump buffers via `display-buffer'."
  (cl-letf (((symbol-function 'switch-to-buffer)
             #'pop-to-buffer))
    (funcall pgm)))

(defun kam-kill-ring-trim ()
  "Trim the first element on the kill ring of whitespace."
  (setcar kill-ring (string-trim (car kill-ring) t t)))

(defun kam-copy-line ()
  "Copy N lines to the `kill-ring'."
  (save-excursion
    (kill-ring-save
     (progn
       (back-to-indentation)
       (point))
     (progn
       (forward-line 1)
       (line-beginning-position))))
  (pulsar-pulse-line))

(defun kam-cut-dwim (&optional n)
  "Kill based on the context of the point in the buffer.

If the region is active, kill the region.
If the point is on an Org heading, kill the sub-tree.
If the point is at an item in an Org list, kill that item.
If none of the previous conditions are true, kill the current line.

When called interactively without a prefix numeric argument, N is 1,
which controls how many lines will be cut."
  (interactive "p")
  (when (> n 1)
    (setq n (+ n 1)))
  (dotimes (_ n)
    (cond ((region-active-p)
           (kill-region nil nil t)
           (setq this-command 'kill-region))
          ((and (derived-mode-p 'org-mode)
                (org-at-heading-p))
           (when (eq last-command 'org-cut-subtree)
             (append-next-kill))
           (org-cut-subtree)
           (setq this-command 'org-cut-subtree))
          ((and (derived-mode-p 'org-mode)
                (org-in-item-p))
           (when (eq last-command 'kill-region)
             (append-next-kill))
           (kam-org-kill-item)
           (setq this-command 'kill-region))
          (t
           (when (eq last-command 'kam-kill-whole-line)
             (append-next-kill))
           (kam-kill-whole-line)
           (setq this-command 'kam-kill-whole-line)))))

(defun kam-kill-ring-save-dwim (&optional n)
  "A DWIM command for copying.

 If point is at an Org heading, copy the subtree. If the
point is at an Org item, copy the item. Else, copy the line.
When called interactively without a prefix numeric argument, N is 1."
  (interactive "p")
  (cond ((region-active-p)
         (copy-region-as-kill (region-beginning) (region-end))
         (setq this-command 'copy-region-as-kill))
        ((and (derived-mode-p 'org-mode) (org-at-heading-p))
         (org-copy-subtree)
         (setq this-command 'org-copy-subtree))
        ((and (derived-mode-p 'org-mode) (org-in-item-p)) ;; Org-in-item-p doesnt work if out of org mode
         (copy-region-as-kill (car (kam-org-item-bounds)) (cdr (kam-org-item-bounds)))
         (setq this-command 'copy-region-as-kill))
        (t
         (kam-copy-line)
         (setq this-command 'copy-region-as-kill))))

(defun kam-duplicate-line-or-region ()
  "Duplicate the current line or active region."
  (interactive)
  (unless mark-ring
    (push-mark (point) t nil))
  (kam--duplicate-buffer-substring
   (if (region-active-p)
       (cons (region-beginning) (region-end))
     (cons (line-beginning-position) (line-end-position)))))

(advice-add #'kam-duplicate-line-or-region :after #'kam-indent-region-advice)

(defun kam-yank-dwim ()
  "Indent after you yank."
  (interactive)
  (let* ((yank-transform-functions '(string-chop-newline string-trim)))
    (yank)))

(defun kam-delete-pair-dwim ()
  "Delete pair following or preceding point."
  (interactive)
  (if (eq (point) (cdr (bounds-of-thing-at-point 'sexp)))
      (delete-pair -1)
    (delete-pair 1)))

(defun kam-insert-new-line-below (n)
  "Create N empty lines below the current one.
When called interactively without a prefix numeric argument, N is 1."
  (interactive "p")
  (goto-char (line-end-position))
  (dotimes (_ n) (newline-and-indent)))

(defun kam-insert-new-line-above (n)
  "Create N empty lines above the current one.
When called interactively without a prefix numeric argument, N is 1."
  (interactive "p")
  (let ((point-min (point-min)))
    (if (or (bobp)
            (eq (point) point-min)
            (eq (line-number-at-pos point-min) 1))
        (progn
          (goto-char (line-beginning-position))
          (forward-line (- n))
          (dotimes (_ n) (kam-insert-new-line-below n)))
      (forward-line (- n))
      (kam-insert-new-line-below n))))

(defun kam-join-line-dwim (n)
  "Join lines.
When called interactively without a prefix numeric argument, N is 1."
  (interactive "P")
  (let ((numeric-arg (prefix-numeric-value n)))
    (save-excursion
      (set-mark (point))
      (forward-line numeric-arg)
      (join-line nil (region-beginning) (region-end)))
    (indent-according-to-mode)))

;; old `kam-join-line-dwim'
;; (if (eolp)
;;     (save-excursion
;;       (set-mark (point))
;;       (forward-line numeric-arg)
;;       (join-line nil (region-beginning) (region-end))
;;       (indent-according-to-mode))
;;   (save-excursion
;;     (set-mark (point))
;;     (forward-line numeric-arg)
;;     (join-line t (region-beginning) (region-end))
;;     (indent-according-to-mode)))

(defun kam-open-line-dwim (n)
  "Open the line and indent it to the proper place.
When called interactively without a prefix numeric argument, N is 1."
  (interactive "P")
  (let ((arg (prefix-numeric-value n)))
    (save-excursion
      (open-line arg)
      (forward-line arg)
      (indent-according-to-mode))
    (indent-according-to-mode)))

(defun kam-yank-replace-line-or-region ()
  "Replace line or region with the latest kill.
This command can be followed by the standard `yank-pop' (default is bound to \\[yank-pop])."
  (interactive)
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (line-beginning-position) (line-end-position)))
  (yank)
  (setq this-command 'yank))

(defun kam-kill-whole-line ()
  "Kill the whole line, regardless of the cursor position within the line.
If called interactively without a prefix numeric argument, N is 1."
  (kill-region (progn
                 (back-to-indentation)
                 (point))
               (progn
                 (forward-line 1)
                 (back-to-indentation)
                 (point))))

(defun kam-kill-from-point-to-beginning-of-line ()
  "Kill from the point to the beginning of the line."
  (interactive)
  (kill-region (line-beginning-position) (point)))

(defun kam-delete-from-point-to-beginning-text ()
  "Delete from the point up to and including the text."
  (interactive)
  (while (or (not (kam-line-only-spaces-or-symbols-p))
             (bolp))
    (delete-char -1)))

(defun kam-control-backspace ()
  "Kill the word behind point. If the line is empty, join it with the previous line."
  (interactive)
  (if (or (kam-line-empty-before-point-p)
          (bolp))
      (join-line)
    (backward-kill-word 1)))

(defun kam-transpose-char (&optional arg)
  "Interchange the characters behind the point."
  (interactive "p")
  (cond
   ((eolp) (transpose-chars 1))
   (t (transpose-chars -1) (forward-char 1))))

(defun kam-transpose-words ()
  "Interchange the words behind the point."
  (interactive)
  (forward-word -1)
  (transpose-words 1))

(defun kam-kill-sexp (&optional arg interactive)
  "Kill the sexp following point. With ARG, do it that many times."
  (interactive "p\nd")
  (if interactive
      (condition-case _
          (kam-kill-sexp arg nil)
        (scan-error (user-error (if (> arg 0)
                                    "No next sexp"
                                  "No previous sexp"))))
    (let ((old-point (point)))
      (kam-forward-sexp (or arg 1))
      (kill-region old-point (point)))))

(defun kam-end-of-string ()
  (interactive)
  (while (in-string-p)
    (forward-char 1))
  (point))

(defun kam-beginning-of-string ()
  (interactive)
  (while (in-string-p)
    (forward-char -1))
  (point))

(defun kam-forward-sexp (&optional arg interactive)
  "Move forward across a sexp.
With ARG, do it that many times. Negative ARG -N means move backwards across N sexps.
This command assumes a string or a comment is a sexp."
  (interactive "p\nd")
  (if interactive
      (condition-case _
          (kam-forward-sexp arg nil)
        (scan-error (user-error (if (> arg 0)
                                    "No next sexp"
                                  "No previous sexp"))))
    (if (in-string-p)
        (progn
          (kam-end-of-string)
          (forward-char -1))
      (forward-sexp arg))))

(defun kam-backward-sexp (&optional arg interactive)
  "Move backwards across a sexp.
With ARG, do it that many times. Negative ARG -N means move forward across N sexps.
This command consides a string or a comment a sexp.
Uses `kam-forward-sexp' to do the work."
  (interactive "p\nd")
  (or arg (setq arg 1))
  (if (in-string-p)
      (progn
        (kam-beginning-of-string)
        (forward-char 1))
    (kam-forward-sexp (- arg) interactive)))

(defun kam-narrow-or-widen-dwim (p)
  "If the buffer is narrowed, it widens. Otherwise, it narrows intelligently.
Intelligently means: region, subtree, or defun, whichever applies first."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode) (org-narrow-to-subtree))
        (t (narrow-to-defun))))

(defun kam-current-sexp ()
  "Returns the current expression based on the position of the point within or on the edges of an s-expression."
  ;; doesnt work good right now
  (cond
   ((thing-at-point 'url) 'url)
   ((thing-at-point 'word) 'word)
   ((thing-at-point 'string) 'string)
   ((thing-at-point 'sexp) 'sexp)))

(defun kam-current-elisp-sexp ()
  "Returns the current Elisp expression based on the position of the point within or on the edges of an s-expression."
  (cond
   ((looking-at "(") (sexp-at-point))
   ((looking-back ")" 1) (elisp--preceding-sexp))
   (t (save-excursion
        (search-backward "(")
        (sexp-at-point)))))

(defun kam-eval-current-sexp ()
  "Evaluates the current sexp at point.
Additionally, if the region is active, evaluate the region.

Unlike `eval-last-sexp', the point doesn't need to be at the end of the expression, but can be at the beginning (on the parenthesis) or somewhere inside."
  (interactive)
  (if (region-active-p)
      (eval-region (region-beginning) (region-end))
    (eval-expression (kam-current-elisp-sexp))))

(defun kam-kill-around-sexp ()
  "Kills the everything inside the list at point including the delimiters."
  (interactive)
  (backward-up-list)
  (kam-kill-sexp))

(defun kam-insert-quote (&optional arg)
  "Enclose following ARG sexps in quotes."
  (interactive "P")
  (insert-pair arg ?\" ?\"))

(defun kam-forward-paragraph (&optional arg)
  "Move forward ARG paragraphs while keeping the point in the center of the screen."
  (interactive "p")
  (forward-paragraph arg)
  (recenter))

(defun kam-backward-paragraph (&optional arg)
  "Move backward ARG paragraphs while keeping the point in the center of the screen."
  (interactive)
  (backward-paragraph arg)
  (recenter))

(defun kam-unfill-paragraph ()
  "Replace newline characters in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column most-positive-fixnum))
    (fill-paragraph nil)))

(defun kam-multi-line-below ()
  "Move a half screen below."
  (interactive)
  (forward-line (floor (window-height) 2))
  (setq this-command 'scroll-down-command))

(defun kam-multi-line-above ()
  "Move a half screen above."
  (interactive)
  (forward-line (- (floor (window-height) 2)))
  (setq this-command 'scroll-down-command))

(defun kam-indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(defun kam-yank-undo (&optional arg)
  "Undo the yank you just did.
Reverses the direction you are going in the kill ring.
With optional ARG, repeat the undos that many times."
  (interactive "p")
  (yank-pop (- arg)))

(defun kam-query-replace-dwim ()
  "Query replace, DWIM.
If the region is active, query replace the thing in the region.
Else, use the symbol at point."
  (interactive)
  (let* ((sym (or (when (region-active-p) 
                    (buffer-substring-no-properties (region-beginning) (region-end)))
                  (thing-at-point 'symbol)))
         (to-string (read-string (format "query replace %s with: " sym))))
    (deactivate-mark)
    (query-replace sym to-string)))

(use-package org
  :ensure nil
  :hook ((org-mode . variable-pitch-mode)
         (org-mode . visual-line-mode)
         (org-mode . kam-org-syntax-table-modify)
         (org-mode . kam-org-set-custom-faces))
  :bind
  (("C-c o l" . kam-consult-org-heading-link)
   ("C-c o p" . org-set-property)
   ("C-c o n" . kam-org-insert-notes-drawer)
   :map org-mode-map
   ("<prior>" . kam-scroll-down)
   ("<next>" . kam-scroll-up)
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
   ("M-i" . kam-org-insert-new-line-below)
   ("M-h" . mark-paragraph)
   ("C-M-<up>" . kam-org-control-metaup)
   ("C-M-<down>" . kam-org-control-metadown)
   ("C-M-<left>" . org-do-promote)
   ("C-M-<right>" . org-do-demote)
   ("C-M-<return>" . org-meta-return)
   ("C-M-h" . org-mark-element)
   ("C-M-i" . kam-org-insert-new-line-above)
   ("C-M-m" . kam-mark-point-to-end-of-line)
   ("C-M-v" . sp-mark-sexp)
   ("C-x C-v" . org-mark-element)
   ("C-x k" . kam-kill-current-buffer)
   ("C-x n" . kam-narrow-or-widen-dwim)
   ("C-c C-x C-b" . org-tree-to-indirect-buffer)
   :map org-src-mode-map
   ("C-'" . org-edit-src-exit)
   ("C-<backspace>" . kam-control-backspace)
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
  :config
  (defun kam-org-syntax-table-modify ()
    "Modify `org-mode-syntax-table' for the current Org buffer.
This stops the mismatch parenthesis bug in Org source blocks."
    (modify-syntax-entry ?< "." org-mode-syntax-table)
    (modify-syntax-entry ?> "." org-mode-syntax-table))

  (with-eval-after-load 'pulsar
    (dolist (hook '(org-agenda-after-show-hook org-follow-link-hook))
      (add-hook hook #'pulsar-recenter-center)
      (add-hook hook #'pulsar-reveal-entry)))

  (defun kam-org-set-custom-faces ()
    "Set Org colors using `standard-themes'."
    (standard-themes-with-colors
      (custom-set-faces
       `(org-special-keyword ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-meta-line ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-document-title ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-document-info ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-document-info-keyword ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-drawer ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-property-value ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-ellipsis ((,c :height 1.0 :foreground ,fg-dim)))
       `(org-block-end-line ((,c :background ,bg-prose-block-delimiter))))))

  (declare-function org-map-entries "org"))

(use-package org-capture
  :ensure nil
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
  :hook ((org-agenda . lin-mode)
         (org-agenda-after-show . visual-line-mode))
  :bind
  ("C-c a" . org-agenda)
  :custom
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
                 (display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.5)
                 (mode . Org-agenda-mode)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'display-buffer-alist
               '("\\*Agenda Commands\\*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-width . 0.35)
                 (window-parameters . ((mode-line-format . none))))))

(use-package org-refile
  :ensure nil
  :bind
  ("C-c o o" . kam-org-refile-region)
  ("C-c o w" . kam-org-refile-to-current-file)
  :custom
  (org-refile-use-outline-path t)
  (org-outline-path-complete-in-steps nil)
  (org-refile-targets '((org-agenda-files :maxlevel . 9))))

(use-package ol   ;; org-links
  :ensure nil
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
     (emacs-lisp . t)))

  )

(use-package org-tempo
  :ensure nil
  :after (org standard-themes)
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
  :config
  (defun kam-org--id-get ()
    "Get the CUSTOM_ID of the current entry.
If the entry has a CUSTOM_ID, return it as is, else create a new one."
    (let* ((pos (point))
           (id (org-entry-get pos "CUSTOM_ID")))
      (if (and id (stringp id) (string-match-p "\\S-" id))
          id
        (setq id (org-id-new "h"))
        (org-entry-put pos "CUSTOM_ID" id)
        id)))

  (defun kam-org-id-headlines ()
    "Add missing CUSTOM_ID to all headlines in the current file."
    (interactive)
    (org-map-entries
     (lambda () (kam-org--id-get))))

  (defun kam-org-id-headline ()
    "Add missing CUSTOM_ID to headline at point."
    (interactive)
    (kam-org--id-get)))

(use-package org-cycle
  :ensure nil
  :config
  (defun kam-org-cycle-subheadings ()
    "Folds all of the Org subheadings from the current heading."
    (org-map-entries
     (org-fold-heading)
     nil
     'tree))

  (defun kam-org-up-and-cycle-heading (&optional arg)
    "Cycles the nearest heading at point."
    (interactive "p")
    (kam-org-metaup)
    (org-cycle)))

(use-package ox-gfm
  :after (org))

(use-package org-contrib
  :after (org)
  :config
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines)))

(use-package org-modern
  :after (org)
  :config
  (setq org-modern-star 'replace)
  (set-face-attribute 'org-modern-symbol nil :family "SF Mono")
  (global-org-modern-mode))

(use-package org-anki
  :bind
  ;; ("C-c n s" . org-anki-sync-entry)
  :custom
  (org-anki-inherit-tags nil)
  :config
  (setq org-anki-api-key nil
        org-anki-default-deck "get that main main"))

(use-package auctex
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  )

(use-package project
  :ensure nil
  :bind
  (:map project-prefix-map
        ("c" . project-compile)
        ("d" . kam-project-dired)
        ("g" . kam-project-grep)
        ("p" . nil)
        ("n" . kam-project-new)
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

  ;; (project-prompter 'kam-project--read-project-by-name)
  :config
  (defvar kam-project-switch-commands-to-remove
    '((project-find-dir "Dired" "d")
      (project-find-regexp "Find regexp")
      (project-vc-dir "VC-Dir")
      (project-eshell "Eshell"))
    "List of commands to remove from `project-switch-commands'")
  
  (setq project-switch-commands
        (seq-remove (lambda (x)
                      (member x kam-project-switch-commands-to-remove))
                    project-switch-commands))

  (add-to-list 'project-switch-commands '(project-shell "Shell" "s"))
  (add-to-list 'project-switch-commands '(project-dired "Dired" "d"))
  (add-to-list 'project-switch-commands '(project-dired "Grep" "g"))

  (defun kam-project-switch-project (dir)
    "\"Switch\" to another project by running an Emacs command.
The available commands are presented as a dispatch menu
made from `project-switch-commands'.

When called in a program, it will use the project corresponding
to directory DIR."
    (interactive (list (funcall project-prompter)))
    (let ((command (if (symbolp project-switch-commands)
                       project-switch-commands
                     (project--switch-project-command dir)))
          (buffer (current-buffer)))
      (unwind-protect
          (progn
            (setq-local project-current-directory-override dir)
            (call-interactively command))
        (with-current-buffer buffer
          (kill-local-variable 'project-current-directory-override)))))

  (add-to-list 'project-switch-commands '(project-find-dir "Dired" "d"))

  (defvar kam-project-name-history nil)

  (defun kam-project-new ()
    "Create a project in the `kam-projects-directory'."
    (interactive)
    (let* ((default-directory kam-projects-directory)
           (project-name (read-directory-name "Project to create: "))
           (response (y-or-n-p "Do you want to initialize the project with a Git repository?")))
      (make-directory project-name)
      (if response
          (progn
            (async-shell-command (concat "git init " project-name))
            (make-empty-file (concat project-name "/project.txt")))
        (make-empty-file (concat project-name "/.project")))))

  (advice-add 'kam-project-new :after #'kam-project-remember-advice)

  (defun kam-project-delete (proj)
    "Delete a project."
    (interactive (list (project-prompt-project-name)))
    (let* ((default-directory kam-projects-directory))
      (project-forget-project proj)
      (delete-directory proj t t)))

  (defun kam-project-root-command (command)
    "Run COMMAND in the project's root directory."
    (when (kam-buffer-has-project-p (current-buffer))
      (let* ((default-directory (or (project-root (project-current))
                                    default-directory)))
        (call-interactively command))))

  (defun kam-project-compile ()
    "Run `compile' in the project root directory if the buffer belongs to a project."
    (interactive)
    (if (kam-buffer-has-project-p (current-buffer))
        (kam-project-root-command 'compile)
      (call-interactively 'compile)))

  (defun kam-project-grep ()
    "Run `grep' in the project's root directory."
    (interactive)
    (kam-project-root-command 'grep))

  (defun kam-buffer-has-project-p (buf)
    "Return t if BUF belongs to a project, nil otherwise."
    (not (null (project-current nil (buffer-local-value 'default-directory buf)))))

  (defun kam-project-dired ()
    "Dired in the project root directory."
    (interactive)
    (dired (project-root (project-current))))

  (defun kam-project-remember-advice ()
    "Advice intended to be run after project creation commands to properly remember the projects."
    (project-remember-projects-under kam-projects-directory t)
    (kam-clear-echo-area))

  (defun kam-project-update-list ()
    "Update the project list when deleting/adding projects."
    (interactive)
    (project-forget-zombie-projects)
    (project-remember-projects-under kam-projects-directory)
    (project-remember-projects-under kam-software-directory))

  (defun kam-project-files ()
    "Return a list of all the project files in the current project."
    (when-let* ((project (project-current nil))
                (find-program "fd --follow --hidden --color=never --type file")
                (project-files-relative-names t))
      (project-files project))))

(use-package comint
  :ensure nil
  :hook (comint-output-filter-functions . comint-osc-process-output)
  :custom
  (comint-completion-auto-list t)
  (comint-prompt-read-only t)
  (comint-buffer-maximum-size 9999)
  (comint-input-ignoredups t)
  (ansi-color-for-comint-mode t)
  :config
  (defun kam-comint--beginning-of-prompt-p ()
    "Return non-nil if the point is at the beginning of a Comint prompt."
    (if comint-use-prompt-regexp
        (looking-back comint-prompt-regexp
                      (line-beginning-position))
      (eq (point) (comint-line-beginning-position))))

  (defun kam-comint--insert-and-send (&rest args)
    "Insert and execute ARGs in the last Comint prompt.
ARGS is a list of strings."
    (if (kam-comint--beginning-of-prompt-p)
        (progn
          (insert (mapconcat #'identity args " "))
          (comint-send-input))
      (user-error "Not at the beginning of prompt; won't insert: %s" args)))

  (defun kam-comint--insert (&rest args)
    "Insert ARGS in the last Comint prompt.
ARGS is a list of strings."
    (if (kam-comint--beginning-of-prompt-p)
        (insert (mapconcat #'identity args " "))
      (user-error "Not at the beginning of prompt; won't insert: %s" args)))

  (defun kam-comint--last-input ()
    "Return the last input as a string."
    (buffer-substring-no-properties
     comint-last-input-start
     comint-last-input-end))

  (defun kam-comint--history-to-list ()
    "Returns the current Comint buffer's history as a list."
    (when (and (ring-p comint-input-ring)
               (not (ring-empty-p comint-input-ring)))
      (let (history)
        (dotimes (index (ring-length comint-input-ring))
          (push (ring-ref comint-input-ring index) history))
        (delete-dups history)
        (setq history (nreverse history))
        history)))

  (defvar kam-comint--input-history-prompt nil
    "Minibuffer history of `kam-comint--input-history-prompt'.
Not to be confused with the shell input history, which is stored in the `comint-input-ring' (see `kam-comint--history-to-list').")

  (defun kam-comint--presorted-completion-table (completions)
    "Completion table for `kam-comint--input-history-prompt' that doesn't mess up the sorting."
    (lambda (string pred action)
      (if (eq action 'metadata)
          `(metadata (display-sort-function . ,#'identity))
        (complete-with-action action completions string pred))))

  (defun kam-comint--input-history-prompt ()
    "Prompt for completion against `kam-comint--history-to-list'."
    (let* ((history (kam-comint--history-to-list))
           (default (car history)))
      (completing-read
       (format-prompt "Insert command from history: " default)
       (kam-comint--presorted-completion-table history))))

  (defun kam-comint-input-from-history ()
    "Insert command from the Comint input history."
    (declare (interactive-only t))
    (interactive)
    (kam-comint--insert-and-send
     (kam-comint--input-history-prompt)))

  (defun kam-comint--get-args (command)
    "Gets the arguments from a given COMMAND, where COMMAND is a string."
    (let ((args (comint-arguments command 1 nil)))
      (split-string args)))

  (defun kam-comint-insert-arguments-from-command (&optional arg)
    "Insert any number of arguments from a previously run command using minibuffer completion.
If there is a numerical argument, the arguments are selected from the ARGth run command."
    (interactive "p")
    (kam-comint--insert
     (kam-comint--get-args-prompt arg)))

  (defun kam-comint--get-args-prompt (&optional arg)
    "Select an argument from a previously run command using minibuffer completion.
Numerical argument ARG determines the command being selected from to choose arguments."
    (interactive "p")
    (let* ((command-index (or (- 1 arg) 1))
           (command (nth command-index (kam-comint--history-to-list)))
           (args (kam-comint--get-args command))
           (default (car args)))
      (completing-read
       (format-prompt "Select Arg: " default)
       args
       nil
       t
       nil
       nil
       default
       nil))))

(use-package shell
  :ensure nil
  :hook (shell-mode . kam-shell-mode-setup)
  :bind
  ("C-x s" . shell)
  ("C-!" . shell-command)
  (:map shell-mode-map
        ("C-^" . kam-shell-up-directory)
        ("C-x C-d" . kam-shell-cd)
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
  (shell-input-autoexpand nil)
  (shell-highlight-undef-enable t)
  (shell-get-old-input-include-continuation-lines t)
  (shell-kill-buffer-on-exit t)
  (shell-font-lock-keywords
   '(("[ \t]\\([+-][^ \t\n]+\\)" 1 font-lock-builtin-face)
     ("^[^ \t\n]+:.*" . font-lock-string-face)
     ("^\\[[1-9][0-9]*\\]" . font-lock-constant-face)))
  :config
  (defvar kam-shell-history-file "~/.config/zsh/zhistory"
    "Where the history file for Z-shell is stored.")

  (defun kam-shell-mode-setup ()
    (setq-local comint-process-echoes t
                comint-input-ring-file-name kam-shell-history-file
                comint-input-ring-size 100000
                comint-input-ring-seperator "\n: \\([0-9]+\\):\\([0-9]+\\);" ; Because of ZSH extended_history option
                outline-regexp comint-prompt-regexp
                completion-styles '(partial-completion basic)
                completion-at-point-functions '(cape-file comint-completion-at-point t)
                corfu-auto nil
                corfu-quit-no-match t)
    (hl-line-mode -1)
    (comint-read-input-ring t)
    (shell-dirtrack-mode 1))

  (defun kam-shell-command--prompt ()
    (read-shell-command
     (format-prompt "Shell command in '%s'" nil (abbreviate-file-name default-directory))
     nil
     nil
     (let ((filename
            (cond
             (buffer-file-name)
             ((eq major-mode 'dired-mode)
              (dired-get-filename nil t)))))
       (and filename (file-relative-name filename)))))

  (defun kam-shell-command (cmd)
    (interactive (list (kam-shell-command--prompt)))
    (let* ((buf (get-buffer-create shell-command-buffer-name)))
      (shell-command cmd buf buf)
      (with-current-buffer buf
        (view-mode)
        (display-buffer buf))))

  (defvar kam-shell-cd--directories nil
    "List of accumulated `shell-last-dir'.")

  (with-eval-after-load 'savehist
    (add-to-list 'savehist-additional-variables 'kam-shell-cd--directories))

  (defun kam-shell--track-cd (&rest _)
    "Track shell input of cd commands.
Push `shell-last-dir' to `kam-shell-cd--directories'."
    (when-let* ((input (kam-comint--last-input))
                ((string-match-p "cd " input)))
      (push shell-last-dir kam-shell-cd--directories)))

  (defvar kam-shell-cd--history nil
    "Minibuffer history for `kam-shell-cd'.")

  (defun kam-shell-cd--prompt ()
    "Prompt for a directory among `kam-shell-cd--directories'."
    (if-let* ((history kam-shell-cd--directories)
              (dirs (cons default-directory history))
              (def (if (listp dirs) (car dirs) shell-last-dir)))
        (completing-read
         (format-prompt "Select directory: " def)
         dirs
         nil
         nil
         nil
         'kam-shell--cd-history)
      (user-error "No directories have been tracked")))

  (defun kam-shell-cd ()
    "Navigate to a previously visited directory in `shell-mode', or to any directory offered by `consult-dir'."
    (declare (interactive-only t))
    (interactive)
    (let ((shell-dirs (delete-dups
                       (mapcar 'abbreviate-file-name
                               (remove nil
                                       kam-shell-cd--directories)))))
      (cond
       ((featurep 'consult-dir)
        (let* ((consult-dir--source-shell `(:name "Shell"
                                                  :narrow ?s
                                                  :category file
                                                  :face consult-file
                                                  :items ,shell-dirs))
               (consult-dir-sources (cons consult-dir--source-shell
                                          consult-dir-sources)))
          (kam-comint--insert-and-send "cd"
                                       (substring-no-properties
                                        (consult-dir--pick "Switch directory: "))))))))

  (defun kam-shell-here ()
    "Opens a new shell in the directory associated with the current buffer's file.
The shell is renamed to match that directory to make multiple shell windows easier."
    (interactive)
    (let* ((parent (if (buffer-file-name)
                       (file-name-directory (buffer-file-name))
                     default-directory))
           (name (car (last (split-string parent "/" t)))))
      (shell)
      (rename-buffer (concat "*shell: " name "*"))))

  (defun kam-shell-up-directory ()
    "Navigates a directory higher in the directory tree."
    (interactive)
    (kam-comint--insert-and-send "cd .."))

  (defun kam-shell-home-directory ()
    "Open a shell in the home directory.
The shell is renamed to make opening multiple shells easier."
    (interactive)
    (let ((default-directory (getenv "HOME")))
      (shell)))

  ;; (add-to-list 'display-buffer-alist
  ;;              '("-shell\\*$" ;; matches title for `project-shell'
  ;;                (display-buffer-reuse-window display-buffer-in-side-window)
  ;;                (side . bottom)
  ;;                (window . root)
  ;;                (window-height . 0.35)
  ;;                (mode shell-mode)
  ;;                (window-parameters . ((mode-line-format . none)))))

  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*shell[\\*\\:]"
  ;;                (display-buffer-reuse-window display-buffer-in-side-window)
  ;;                (side . bottom)
  ;;                (window . root)
  ;;                ;; (inhibit-same-window . t)
  ;;                (window-height . 0.35)
  ;;                (mode shell-mode)
  ;;                (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'display-buffer-alist
               '((major-mode . shell-command-mode)
                 (display-buffer-reuse-window display-buffer-in-direction)
                 (direction . right)
                 (window . root)
                 (inhibit-same-window . t))))

(use-package eshell
  :ensure nil
  :hook ((eshell-mode . completion-preview-mode)
         (eshell-mode . kam-eshell-mode-setup))
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
  (eshell-input-filter #'kam-eshell-input-filter)
  :config
  (defun kam-eshell-mode-setup ()
    (setenv "TERM" "xterm-256-color")
    (setq-local completion-styles '(basic partial-completion)
                completion-at-point-functions '(pcomplete-completions-at-point cape-file cape-history)
                eshell-prompt-regexp kam-eshell-prompt-regexp)
    (eshell-prompt-mode))

  (setq eshell-prompt-function
        (lambda ()
          (standard-themes-with-colors
            (concat
             (propertize "[" 'face `(:foreground ,fg-main :background ,bg-main))
             (propertize (user-login-name) 'face `(:foreground ,fg-main :background ,bg-main))
             (propertize "@" 'face `(:foreground ,fg-main :background ,bg-main))
             (propertize (system-name) 'face `(:foreground ,pink :background ,bg-main))
             (propertize "]" 'face `(:foreground ,fg-main :background ,bg-main))
             (propertize " — " 'face `(:foreground ,fg-main :background ,bg-main))
             (propertize (car (kam-eshell--directory-prompt)) 'face `(:foreground ,pink :weight bold))
             ;; (propertize (cadr (kam-eshell--directory-prompt)) 'face `(:foreground ,pink :weight bold))
             (propertize " $ " 'face `(:weight bold :background ,bg-main main))))))

  (add-to-list 'display-buffer-alist
               '("\\*eshell[\\*\\:]" ; matches title for reg eshell and `kam-eshell-here'
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (inhibit-same-window . t)
                 (window-width . 0.5)
                 (mode . eshell-mode)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'display-buffer-alist
               '("-eshell\\*$" ;; matches title for `project-eshell'
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.50)
                 (window-parameters . ((mode-line-format . none))))))

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

;; (use-package vterm
;;   :ensure nil
;;   :if (eq system-type 'gnu/linux)
;;   :custom
;;   (vterm-shell (executable-find "zsh"))
;;   :config
;;   (defun kam-project-vterm ()
;;     "Create a Vterm terminal in the project root."
;;     (interactive)
;;     (let ((default-directory (project-root (project-current t))))
;;       (vterm))))



(advice-add 'kam-sudo-shell-command :after 'kam-clear-echo-area)

(defun kam-completing-read (prompt collection &optional predicate require-match initial-input hist def inherit-input-method)
  "Call `completing-read' but return the value from COLLECTION with PROMPT.

simple wrapper around the `completing-read' function that assumes the
collection is either an alist or a hashtable, and returns the _value_ of
the choice, not the selected choice.

An example function would look like: \(defun
kam-test-function (selection) \(interactive (list (kam-completing-read
\"Prompt: \" kam-test))) \(message \"%s\" selection))

Where kam-test is an alist of choices mapped to values."
  (cl-flet ((assoc-list-p (obj) (and (listp obj) (consp (car obj)))))
    (let* ((choice
            (completing-read prompt collection predicate require-match initial-input hist def inherit-input-method))
           (results (cond
                     ((hash-table-p collection) (gethash choice collection))
                     ((assoc-list-p collection) (alist-get choice collection def nil 'equal))
                     (t choice))))
      (if (listp results) (first results) results))))

(defun kam-rename-file (name)
  "Apply NAME to the current file and rename its buffer."
  (interactive
   (list (read-string "Rename current file: " (file-relative-name (buffer-file-name)))))
  (let ((file (buffer-file-name)))
    (if (vc-registered file)
        (vc-rename-file file name))
    (set-visited-file-name name t t)))

(defun kam-revert-buffer ()
  "Revert the current buffer from its file without asking for confirmation."
  (interactive)
  (revert-buffer t t t))


(use-package standard-themes
  :hook (standard-themes-after-load-theme . kam-theme-update-custom-faces)
  :init
  (standard-themes-take-over-modus-themes-mode 1)
  :config
  (setq standard-themes-to-toggle '(standard-dark
                                    standard-light))
  (setq standard-themes-disable-other-themes t)
  (setq standard-themes-italic-constructs t)
  (setq standard-themes-bold-constructs t)
  (setq standard-themes-mixed-fonts t)
  (setq standard-themes-prompts '(heavy))
  (setq standard-themes-completions '((selection . (bold))))
  (setq standard-themes-headings '((1 . (bold variable-pitch 1))
                                   (2 . (bold variable-pitch 1))
                                   (3 . (bold variable-pitch 1))
                                   (t . (bold variable-pitch 1))))

  (defvar kam-standard-themes-palette-light-overrides
    '((cursor "#000000"))
    "Custom overrides for Standard-Themes Light.")

  (defvar kam-standard-themes-palette-dark-overrides
    '((fg-prompt cyan)
      ;; (bg-main "#181818")   tsoding
      (bg-prompt unspecified)
      (bg-prose-block-delimiter "#312f34")
      (bg-prose-block-contents "#29272c")
      (cursor "#f9d82b")
      (fg-heading-1 rainbow-2)
      (fg-heading-2 rainbow-1)
      (docstring string))
    "Custom overrides for Standard-Themes Dark.")

  (defun kam-set-custom-faces ()
    "Function which sets faces across the configuration using the `standard-themes-with-colors' macro.
 Uses the colors set in either
 `kam-standard-themes-palette-dark-overrides' or
 `kam-standard-themes-palette-light-overrides'."
    (if (eq (modus-themes-get-current-theme) 'standard-dark)
        (setq standard-themes-common-palette-overrides kam-standard-themes-palette-dark-overrides)
      (setq standard-themes-common-palette-overrides kam-standard-themes-palette-light-overrides))
    (standard-themes-with-colors
      (custom-set-faces
       ;; `(mode-line ((,c :background "#003c53" :foreground ,fg-main)))
       `(region ((,c :extend nil)))
       `(fringe ((,c :background ,bg-main)))
       `(cursor ((,c :foreground ,fg-main :background ,cursor)))
       `(font-lock-function-call-face ((,c :foreground ,fnname :weight regular)))
       `(font-lock-function-name-face ((,c :foreground ,fnname :weight regular)))
       `(font-lock-variable-use-face ((,c :foreground ,variable :weight regular)))
       `(font-lock-variable-name-face ((,c :foreground ,variable :weight regular)))
       `(tool-bar ((,c :foreground "#000000" :background "#c0c4c8")))
       `(menu ((,c :foreground "#000000" :background "#c0c4c8"))))))

  (standard-themes-load-theme 'standard-light)
  (kam-set-custom-faces))

(use-package ef-themes)

(use-package olivetti
  :hook (olivetti-mode . kam-olivetti-update-fringe-color)
  :custom
  (olivetti-style 'fancy)
  (olivetti-margin-width 5)
  ;; (olivetti-body-width .3)
  (olivetti-minimum-body-width 80)
  (olivetti-recall-visual-line-mode-state t)
  :config
  (defun kam-olivetti-update-fringe-color ()
    "Update Olivetti mode's fringe color to the main background color."
    (standard-themes-with-colors
      (custom-set-faces
       `(olivetti-fringe ((,c :background ,bg-main)))))))


(use-package spacious-padding
  :after (standard-themes)
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
  ;; :hook (text-mode . hl-line-mode)
  :custom
  (hl-line-sticky-flag nil)
  (global-hl-line-sticky-flag 'window)
  :config
  (defun kam-hl-line-set-custom-faces ()
    "Update `hl-line-mode' color depending on the currently loaded theme."
    (with-eval-after-load 'standard-themes
      (standard-themes-with-colors
        (custom-set-faces
         `(hl-line ((,c :background ,bg-dim)))
         `(hl-line-nonselected ((,c :background ,bg-main))))))))

(use-package lin
  :custom
  (lin-face 'lin-yellow))

(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

(use-package pulsar
  :hook ((next-error . pulsar-pulse-line)
         ;; (consult-after-jump . pulsar-recenter-center)
         ;; (consult-after-jump . pulsar-reveal-entry)
         ;; (imenu-after-jump . pulsar-recenter-center)
         (imenu-after-jmup . pulsar-reveal-entry))
  :custom
  (pulsar-delay 0.05)
  (pulsar-iterations 5)
  (pulsar-face 'cursor)
  (pulsar-region-face 'pulsar-yellow)
  (pulsar-highlight-face 'pulsar-yellow)
  (pulsar-pulse-on-window-change nil)
  (pulsar-pulse-region-functions nil)
  :config
  ;; (add-to-list 'pulsar-pulse-functions 'recenter)
  ;; (advice-add 'isearch-forward :after 'pulsar-recenter-center)
  ;; (advice-add 'isearch-backward :after 'pulsar-recenter-center)
  (pulsar-global-mode))

(use-package nerd-icons
  :config
  (set-fontset-font "fontset-default" nil "Symbols Nerd Font Mono" nil 'append)
  (add-to-list 'nerd-icons-mode-icon-alist
               '(ghostel-mode nerd-icons-devicon "nf-dev-terminal" :face nerd-icons-purple))
  (add-to-list 'nerd-icons-mode-icon-alist
               '(Man-mode nerd-icons-faicon "nf-fa-info" :face nerd-icons-purple)))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-corfu
  :after (corfu)
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-completion
  :config
  (nerd-icons-completion-mode))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package nerd-icons-xref
  :init
  (nerd-icons-xref-mode))

(use-package nerd-icons-grep
  :init
  (nerd-icons-grep-mode)
  :custom
  (grep-use-headings t))

(use-package visual-fill-column
  :hook (
         ;; (minibuffer-setup . (lambda ()
         ;; (when (minibufferp) (kam-visual-fill-column-disable))))
         (image-mode . kam-visual-fill-column-disable)
         (transient-setup-buffer . kam-visual-fill-column-disable)
         (prog-mode . kam-visual-fill-column-disable))
  :config
  (defun kam-visual-fill-column-disable ()
    "Turn off `visual-fill-column-mode'."
    (visual-fill-column-mode -1))

  (advice-add 'text-scale-adjust :after #'visual-fill-column-adjust))


(setq mode-line-compact nil
      mode-line-right-align-edge 'right-fringe)

(setq-default mode-line-format
              '("%e"
                kam-mode-line-logo
                kam-mode-line-kbd-macro
                kam-mode-line-narrow
                kam-mode-line-rectangle-mark
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
                kam-mode-line-display-time
                ;; kam-mode-line-vc-branch      ;; disabled because causing excessive tramp load times
                ))                              ;; not sure why


(dolist (construct '(kam-mode-line-kbd-macro
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

(use-package text-mode
  :ensure nil
  :hook (text-mode . visual-fill-column-mode))

(use-package prog-mode
  :ensure nil
  :hook ((prog-mode . kam-prog-mode-setup)
         ;; (prog-mode . buffer-face-mode)
         (prog-mode . electric-indent-local-mode)
         (prog-mode . kam-decolorify-mode))
  :bind
  (:map prog-mode-map
        ;; ("M-q" . upcase-dwim)
        ("RET" . newline))
  :config
  (defun kam-prog-mode-setup ()
    "Set up `prog-mode'."
    (setq-local buffer-face-mode-face 'fixed-pitch)
    (blink-cursor-mode 1)
    ;; (hl-line-mode)
    ;; (kam-text-scale-adjust 1)
    ;; (completion-preview-mode)
    (indent-tabs-mode -1)))

(use-package conf-mode
  :ensure nil
  :hook (conf-mode . kam-conf-mode-setup)
  :mode ("\\.env\\..*\\'" "\\.env\\'")
  :config
  (defun kam-conf-mode-setup ()
    "Set up `conf-mode'."
    (display-line-numbers-mode)
    (kam-conf-mode-set-font)
    (indent-tabs-mode -1)
    (outline-minor-mode))

  (defun kam-conf-mode-set-font ()
    "Intended to set the font in `conf-mode'."
    (setq-local buffer-face-mode-face 'fixed-pitch)
    (buffer-face-mode))

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
  :custom
  (elisp-fontify-semantically nil)
  :config
  (set-default-toplevel-value 'lexical-binding t)

  (with-eval-after-load 'consult
    (add-to-list 'consult-buffer-filter
                 "\\*Pp Eval Output\\*"))

  (defun kam-elisp-mode-setup ()
    "Setup `emacs-lisp-mode'."
    (setq-local completion-at-point-functions
                '(cape-file
                  cape-elisp-block
                  cape-elisp-symbol
                  elisp-completion-at-point
                  cape-dabbrev
                  t))))

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
  :init
  (setq magit-define-global-key-bindings nil)
  :bind
  ("C-x g" . magit-status)
  :custom
  (magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
  (magit-bury-buffer-function 'magit-restore-window-configuration)
  (magit-commit-show-diff t)
  (magit-format-file-function #'magit-format-file-nerd-icons)
  :config
  (magit-auto-revert-mode)
  (magit-wip-mode)

  (when (eq system-type 'darwin)
    (setq magit-git-executable "/opt/homebrew/bin/git"))

  (add-to-list 'consult-buffer-filter
               "magit-")

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "magit-")

  (add-to-list 'same-window-regexps "^magit: .*$")
  (add-to-list 'same-window-regexps "^magit-status: .*$")

  (add-to-list 'project-switch-commands '(magit-project-status "Git" "v"))

  (defun kam-git-clone ()
    "Run git clone using `magit' in `kam-projects-directory'."
    (interactive)
    (let ((default-directory kam-projects-directory))
      (call-interactively 'magit-clone))
    (kam-project-update-list)))

(use-package forge
  :after (magit))

(use-package vc
  :ensure nil
  :custom
  (vc-follow-symlinks t))

;; (use-package flycheck
;;   :hook (after-init . global-flycheck-mode)
;;   ;;  TODO 2026-07-15: enabling this option sets the load path correctly, but flycheck errors out
;;   ;;  figure out why
;;   :custom
;;   (flycheck-emacs-lisp-load-path 'inherit)
;;   :config
;;   (add-to-list 'switch-to-prev-buffer-skip-regexp
;;                "\\*Flycheck error messages\\*" t)

;;   (with-eval-after-load 'consult
;;     (add-to-list 'consult-buffer-filter "\\*Flycheck error messages\\*" t)))

;; (use-package flycheck-eglot
;;   :after (flycheck eglot)
;;   :config
;;   (global-flycheck-eglot-mode 1))

;; ;; (use-package flyover
;; ;;   :after (flycheck)
;; ;;   ;; :hook (flycheck-mode . flyover-mode)
;; ;;   :custom
;; ;;   (flyover-line-position-offset 0)
;; ;;   (flyover-show-virtual-line nil)
;; ;;   (flyover-show-at-eol t)
;; ;;   (flyover-display-mode 'hide-on-same-line))

(use-package flymake
  :after (consult)
  :ensure nil
  :hook (after-init . flymake-mode)
  :bind
  (:map prog-mode-map
        ("M-g M-b" . flymake-goto-prev-error)
        ("M-g M-f" . flymake-goto-next-error))
  :custom
  (flymake-inline-diagnostics nil)
  (flymake-margin-indicators-string
   '((error "!»" compilation-error)
     (warning "»" compilation-warning)
     (note "»" compilation-info)))
  :config
  (add-to-list 'consult-buffer-filter
               "\\*Flymake diagnostics for ")
  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*Flymake diagnostics for "))

(use-package eglot
  :ensure nil
  :hook (eglot-managed-mode . kam-eglot-setup)
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect nil)
  (eglot-events-buffer-size 0)
  (eglot-events-buffer-config '(:size 0 :format full))
  (eglot-code-action-indications nil)
  (eglot-documentation-renderer #'markdown-ts-view-mode)
  (eglot-extend-to-xref t)
  :config
  (defun kam-eglot-setup ()
    "Function for loading Eglot settings."
    (add-to-list 'eglot-ignored-server-capabilities :inlayHintProvider)
    (add-to-list 'eglot-ignored-server-capabilities :documentHighlightProvider)
    (add-to-list 'eglot-ignored-server-capabilities :documentOnTypeFormattingProvider)
    (add-to-list 'eglot-ignored-server-capabilities :semanticTokensProvider)
    (eglot-semantic-tokens-mode -1)
    (eglot-inlay-hints-mode -1)
    (remove-hook 'eldoc-documentation-functions #'flymake-eldoc-function t))

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

(use-package etags
  :ensure nil
  :config
  (etags-regen-mode))

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
  :hook (prog-mode . display-line-numbers-mode)
  :custom
  (display-line-numbers-type 'visual)
  (display-line-numbers-widen t)
  (display-line-numbers-width 4))

(use-package ediff
  :ensure nil
  :hook ((ediff-before-setup . kam-ediff-store-layout)
         (ediff-quit . kam-ediff-restore-layout))
  :init
  (setopt ediff-split-window-function 'split-window-horizontally
          ediff-window-setup-function 'ediff-setup-windows-plain)
  :custom
  (setq ediff-keep-variants nil)
  (setq ediff-make-buffers-readonly-at-startup nil)
  (setq ediff-show-clashes-only t)
  (setq ediff-diff-options "-w")
  :config  
  (defun kam-ediff-store-layout ()
    "Store current frame window configuration as a frame parameter.
Add this function to the `ediff-before-setup-hook'."
    (let ((frame (selected-frame)))
      (set-frame-parameter
       frame
       'kam-ediff-last-layout
       (current-window-configuration frame))))

  (defun kam-ediff-restore-layout ()
    "Restore the frame's window configuration.
Add this function to the `ediff-quit-hook'."
    (if-let* ((layout (frame-parameter (selected-frame) 'kam-ediff-last-layout)))
        (set-window-configuration layout)
      (message "No Ediff window configuration for the current frame"))))

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
  (eldoc-idle-delay 0)
  (eldoc-echo-area-use-multiline-p t)
  (eldoc-help-at-pt nil)
  (eldoc-echo-area-prefer-doc-buffer 'maybe)
  :config
  (add-to-list 'display-buffer-alist
               '("^\\*eldoc for"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (window-height . 4)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'display-buffer-alist
               '("\\*eldoc\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.5)
                 (window-parameters . ((mode-line-format . none)))))

  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*eldoc\\*"
  ;;                (display-buffer-no-window)
  ;;                (allow-no-window . t)))

  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*eldoc for "
  ;;                (display-buffer-no-window)
  ;;                (allow-no-window . t)))

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
  :hook (after-init . envrc-global-mode))

(use-package compile
  :ensure nil
  :hook (compilation-filter . ansi-color-compilation-filter)
  :bind
  ("C-@" . kam-project-compile)
  ("M-@" . recompile)
  (:map compilation-mode-map
        ("n" . compilation-next-error)
        ("p" . compilation-previous-error)
        ("C-c C-p" . compilation-previous-file)
        ("C-c C-n" . compilation-next-file)
        ;; ("n" . kam-next-error-no-select)
        ;; ("p" . kam-previous-error-no-select)
        ("<return>" . kam-compile-goto-error)
        ("SPC" . kam-scroll-down)
        ("<backspace>" . kam-scroll-up)
        ("}" . compilation-next-file)
        ("{" . compilation-previous-file)
        ("<prior>" . kam-scroll-up)
        ("<next>" . kam-scroll-down)
        ("M-@" . recompile)
        ("C-g" . quit-window))
  (:repeat-map next-error-repeat-map
               ("M-n" . next-error-no-select)
               ("M-p" . previous-error-no-select)
               ("C-p" . compilation-previous-file)
               ("C-n" . compilation-next-file))
  :custom
  (compilation-always-kill t)
  (compilation-ask-about-save nil)
  (compilation-scroll-output 'first-error)
  (compilation-max-output-line-length nil)
  (compile-command "")
  (compilation-skip-threshold 2)
  :config
  (defun kam-compile-make-interactive ()
    "Advise `compile' so that it becomes interactive."
    (defadvice compile (before ad-compile-smart activate)
      "Advises `compile' so it sets the argument COMINT to t."
      (ad-set-arg 1 t)))

  (add-to-list 'display-buffer-alist
               '("\\*compilation\\*"
                 (display-buffer-reuse-window
                  ;; kam-display-buffer-in-mru-window
                  display-buffer-use-least-recent-window
                  display-buffer-in-direction
                  )
                 (direction . right)
                 ;; (window-width . 0.50)
                 ;; (inhibit-same-window . t)
                 ;; (window-height . 0.35)
                 (body-function . select-window)
                 ;; (window-parameters . ((mode-line-format . none)
                 ;;                       (no-delete-other-windows . t)))
                 ))

  (add-to-list
   'switch-to-prev-buffer-skip-regexp
   "\\*compilation\\*")

  ;; (with-eval-after-load 'consult
  ;;   (add-to-list 'consult-buffer-filter
  ;;                "\\*compilation\\*" t))
  )
;; (advice-add #'compile :before (ad-set-argument 1 t))

(use-package whitespace
  :ensure nil
  :hook ((after-init . whitespace-mode)
         (whitespace-mode . kam-whitespace-setup))
  :custom
  (whitespace-style
   '(face tabs tab-mark))
  (whitespace-display-mappings '((space-mark 32 [183])
                                 (tab-mark ?\t [187 ?\t] [62 ?\t])))
  :config
  (defun kam-whitespace-setup ()
    ;; (add-to-list 'write-file-functions 'delete-trailing-whitespace)
    (kill-ring-deindent-mode)))

;; (use-package x
;;   :ensure nil
;;   :custom
;;   (x-gtk-use-system-tooltips nil)
;;   (x-select-enable-clipboard t)
;;   (x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
;;   (x-underline-at-descent-line nil)
;;   (x-stretch-cursor nil))

(use-package epa
  :ensure nil
  :custom
  (epa-gpg-program (executable-find "gpg2"))
  (epa-keys-select-method 'minibuffer)
  (epa-pinentry-mode 'loopback)
  :config
  (setenv "GPG_AGENT_INFO" nil)
  (setenv "GNUGPGHOME" "~/.gnupg"))

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
         (c-ts-mode . eglot-ensure))
  :custom
  (c-ts-mode-indent-style 'k&r)
  (c-ts-mode-indent-offset 4)
  :config
  (defun kam-c-ts-mode-setup ()
    "Setup function for `c-ts-mode'."
    (hs-minor-mode)
    (treesit-fold-mode)
    (c-ts-mode-toggle-comment-style -1)))

(use-package python
  :defer t
  :hook (python-mode . eglot-ensure)
  :custom
  (python-indent-guess-indent-offset-verbose nil)
  :config
  (add-to-list 'display-buffer-alist
               '((major-mode . inferior-python-mode)
                 (display-buffer-in-tab)
                 (dedicated . t)
                 (tab-name . " python"))
               t))

(use-package asm-mode
  :hook (asm-mode . kam-asm-mode-setup)
  :config
  (defun kam-asm-mode-setup ()
    "Setup for `asm-mode'."
    (electric-indent-mode -1)
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
  :hook (markdown-ts-mode . kam-markdown-ts-setup)
  :custom
  (markdown-ts-hide-markup t)
  :config
  (require 'markdown-ts-mode-x)
  (defun kam-markdown-ts-setup ()
    "Setup for `markdown-ts-mode'."
    (setq-local treesit-font-lock-level 4)))

(use-package yaml-ts-mode
  :ensure nil
  :defer t
  :mode "\\.ya?ml\\'"
  :hook (yaml-ts-mode . treesit-fold-mode)
  :config
  (add-to-list 'treesit-language-source-alist '(yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml" "master" "src")))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package sgml-mode
  :ensure nil
  :hook ((html-mode mthml-mode mhtml-ts-mode) . sgml-electric-tag-pair-mode)
  :bind
  (:map mhtml-ts-mode-map
        ("M-o" . kam-ace-window)))

(use-package transient
  :ensure nil
  :custom
  (transient-history-file (expand-file-name "transient/history.el" kam-emacs-cache-directory))
  (transient-levels-file (expand-file-name "transient/levels.el" kam-emacs-cache-directory))
  (transient-values-file (expand-file-name "transient/values.el" kam-emacs-cache-directory)))

(use-package diff-hl
  :hook ((magit-post-refresh . diff-hl-magit-post-refresh)
         (prog-mode . diff-hl-mode))
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

(use-package gptel
  :custom
  (gptel-default-mode 'org-mode)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*ChatGPT\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.5)
                 (window-parameters . ((mode-line-format . none))))))

(use-package ghostel
  :hook ((after-init . ghostel-compile-global-mode)
         (after-init . ghostel-shell-command-global-mode)
         (after-init . ghostel-comint-global-mode)
         (ghostel-mode . kam-ghostel-setup))
  :bind
  ("C-x t" . ghostel)
  (:map ghostel-semi-char-mode-map
        ("M-o" . ace-window))
  (:map project-prefix-map
        ("t" . ghostel-project))
  :custom
  ;; (ghostel-compile-finished-major-mode 'compilation-mode)
  ;; (ghostel-compile-finished-major-mode 'ghostel-compile-view-mode)
  (ghostel-buffer-name "*terminal*")
  (ghostel-module-auto-install 'download)
  :config
  ;; (ghostel-compile-global-mode)

  (defun kam-ghostel-setup ()
    "Setup for `ghostel-mode'."
    (visual-fill-column-mode -1)
    (centered-cursor-mode -1))

  (add-to-list 'project-switch-commands '(ghostel-project "Terminal" "t"))

  (keymap-set global-map "C-x t" 'ghostel)

  ;; (add-to-list 'display-buffer-alist
  ;;              '("-Ghostel\\*$"         ; Matches `ghostel-project' buffer regex
  ;;                (display-buffer-reuse-window display-buffer-in-side-window)
  ;;                (side . bottom)
  ;;                (window . root)
  ;;                ;; (inhibit-same-window . t)
  ;;                (window-height . 0.35)
  ;;                (mode ghostel-mode)
  ;;                (window-parameters . ((mode-line-format . none)))))
  )

(use-package ghostel-compile
  :ensure nil
  :hook (after-init . ghostel-compile-global-mode)
  :custom
  (ghostel-compile-buffer-name "*compilation*"))

(use-package ghostel-shell-command
  :ensure nil
  :hook (after-init . ghostel-shell-command-global-mode)
  :custom
  (ghostel-shell-command-buffer-name "*Shell Command*"))

(use-package ghostel-comint
  :ensure nil
  :hook (after-init . ghostel-comint-global-mode))

(use-package pcre2el
  :config
  (defmacro prx (&rest expressions)
    "Convert native `rx' EXPRESSIONS to PCRE style syntax."
    `(rxt-elisp-to-pcre (rx ,@expressions))))

(use-package kirigami
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
  :commands outline-indent-minor-mode
  :hook ((yaml-ts-mode . outline-indent-minor-mode)
         (python-ts-mode . outline-indent-minor-mode))
  :custom
  (outline-indent-ellipsis " ⌄"))

(use-package outline
:ensure nil
:hook ((outline-minor-mode . kam-outline-setup)
       (emacs-lisp-mode . outline-minor-mode)
       (conf-mode . outline-minor-mode)
       (markdown-mode . outline-minor-mode)
       (diff-mode . outline-minor-mode)))
:config
(defun kam-outline-setup ()
(let* ((display-table (or buffer-display-table (make-display-table)))
       (face-offset (* (face-id 'shadow) (ash 1 22)))
       (value (vconcat (mapcar (lambda (c) (+ face-offset c)) " ⌄"))))
  (set-display-table-slot display-table 'selective-display value)
  (setq buffer-display-table display-table)))

(use-package treesit-fold
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

(defvar kam-custom-lisp-files
  `(,(concat (getenv "HOME") "/.config/emacs/lisp/yt-dlp.el")
    ,(concat (getenv "HOME") "/.config/emacs/lisp/hide-cursor-mode.el"))
  "List of strings detailing custom Lisp to be loaded.
Each string should be a full path to a Lisp file.")

(mapc (lambda (file)
        (when (file-exists-p file)
          (load-file file)))
      kam-custom-lisp-files)

;; (add-to-list 'load-path (locate-user-emacs-file "lisp/"))

(require 'kam-common)
(require 'kam-os)
(require 'kam-mode-line)
(require 'kam-applications)
(require 'kam-dotfiles)
(require 'kam-notes)
(require 'kam-theme)
(require 'kam-search)
(require 'kam-comment)
(require 'kam-window)
(require 'kam-consult)
(require 'kam-consult-tab)
(require 'kam-org)
(require 'kam-writing)
(require 'kam-tasks)
(require 'kam-eshell)
(require 'kam-expreg)
;;; init.el ends here
