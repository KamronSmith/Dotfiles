;; -*- lexical-binding: t -*-
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
  (native-comp-prune-cache t)
  :config
  (add-to-list 'switch-to-prev-buffer-skip-regexp "\\*Async-native-compile-log\\*" t)

  (with-eval-after-load 'consult
    (add-to-list 'consult-buffer-filter "\\*Async-native-compile-log\\*" t)
    (add-to-list 'consult-buffer-filter "\\*Native-compile-Log\\*" t)))

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-shell-name (executable-find "zsh")
        exec-path-from-shell-variables '("PATH"
                                         "SHELL"
                                         "SSH_AUTH_SOCK"
                                         "LANG"
                                         "WAYLAND_DISPLAY"
                                         "XDG_DATA_HOME"
                                         "XDG_CONFIG_HOME"))
  (exec-path-from-shell-initialize)
  (setenv "GIT_EDITOR" (format "emacs --init-dir=%s" (shell-quote-argument user-emacs-directory)))
  (setenv "EDITOR" (format "emacs --init-dir=%s" (shell-quote-argument user-emacs-directory)))
  (setenv "PAGER" "cat"))

(use-package emacs
  :ensure nil
  :hook ((after-init . kam-initial-setup)
         (after-init . blink-cursor-mode)
         (after-init . kam-whitespace-handling))
  :bind
  ("<escape>" . kam-keyboard-quit-dwim)
  ("<home>" . nil)
  ("<end>" . nil)
  ("<up>" . nil)
  ("<down>" . nil)
  ("<left>" . nil)
  ("<right>" . nil)
  ([remap keyboard-quit] . kam-keyboard-quit-dwim)
  ([remap yank] . kam-yank-dwim)
  ("C-d" . delete-forward-char)
  ("C-j" . kam-join-line-dwim)
  ([kam-m] . back-to-indentation)
  ("C-o" . kam-open-line-dwim)
  ("C-w" . kam-cut-dwim)
  ("C-t" . kam-transpose-char)
  ("C-q" . quoted-insert)
  ("C-z" . zap-up-to-char)
  ("C-SPC" . set-mark-command)
  ("C-<return>" . kam-insert-new-line-below)
  ("C-<backspace>" . kam-control-backspace)
  ("C-&" . kam-push-mark-no-activate)
  ("C-@" . nil)
  ("C-_" . nil)
  ("C-:" . pp-eval-expression)
  ("C-;" . kam-comment-dwim)
  ("C-!" . shell-command)
  ("C-|" . nil)
  ("C-`" . nil)
  ("C-(" . insert-parentheses)
  ("C-)" . nil)
  ("C-~" . nil)
  ("C-<" . nil)
  ("C->" . nil)
  ("M-c" . capitalize-dwim)
  ("M-l" . downcase-dwim)
  ("M-m" . kam-mark-line)
  ("M-n" . kam-forward-paragraph)
  ("M-p" . kam-backward-paragraph)
  ("M-q" . fill-paragraph)
  ("M-t" . kam-transpose-words)
  ("M-u" . upcase-dwim)
  ("M-w" . kam-kill-ring-save-dwim)
  ("M-z" . kill-paragraph)
  ("M-!" . async-shell-command)
  ("M-;" . comment-dwim)
  ("M-:" . pp-eval-expression)
  ("M-@" . mark-word)
  ("M-&" . kam-jump-to-mark)
  ("M-<return>" . kam-insert-new-line-above)
  ("M-SPC" . mark-word)
  ("M-DEL" . kam-control-backspace)
  ("C-h c" . describe-char)
  ("C-h s" . kam-consult-search-emacs-info-pages)
  ("C-x k" . kam-kill-current-buffer)
  ("C-x n" . kam-narrow-or-widen-dwim)
  ("C-x o" . kam-ace-window-prefix)
  ("C-x u" . nil)
  ("C-x C-c" . kam-os-restart-emacs)
  ("C-x C-n" . nil)
  ("C-x C-e" . kam-eval-current-sexp)
  ("C-x C-v" . mark-paragraph)
  ("C-x C-u" . nil)
  ("C-x C-z" . nil)
  ("C-M-<left>" . indent-rigidly-left)
  ("C-M-<right>" . indent-rigidly-right)
  ("C-M-," . nil)
  ("C-M-SPC" . kam-mark-sexp)
  ("C-M-(" . insert-parenthesis)
  ("C-M-=" . indent-region)
  ("C-M-a" . sp-beginning-of-sexp)
  ("C-M-b" . sp-backward-sexp)
  ("C-M-d" . sp-down-sexp)
  ("C-M-e" . sp-end-of-sexp)
  ("C-M-f" . sp-forward-sexp)
  ("C-M-k" . sp-kill-sexp)
  ("C-M-n" . sp-next-sexp)
  ("C-M-o" . sp-up-sexp)
  ("C-M-p" . sp-previous-sexp)
  ("C-M-u" . sp-backward-up-sexp)
  ("C-M-q". kam-kill-inner-sexp)
  ("C-M-y" . kam-duplicate-line-or-region)
  ("C-M-z" . kam-delete-pair-dwim)
  ("C-M-DEL" . sp-backward-kill-sexp)
  ("C-c w" . kam-writing-mode)
  (:map search-map
        ("M-c" . goto-char))
  (:map prog-mode-map
        ("C-M-q" . kam-kill-inner-sexp))
  (:map emacs-lisp-mode-map
        ("C-M-q" . kam-kill-inner-sexp))
  (:map occur-mode-map
        ("w" . occur-edit-mode))
  :custom
  (user-full-name "Kamron Smith")
  (user-mail-address "kamrosmith@gmail.com")
  (user-lisp-directory (locate-user-emacs-file "lisp/"))
  (line-spacing '(0 . 0))
  (inhibit-splash-screen nil)
  (create-lockfiles nil)
  (confirm-kill-emacs nil)
  (confirm-kill-processes nil)
  (initial-major-mode 'emacs-lisp-mode)
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
  (list-matching-lines-default-context-lines 2)
  (tooltip-reuse-hidden-frame t)
  (tooltip-use-echo-area t)
  (undo-limit (* 13 160000))
  (undo-strong-limit (* 13 240000))
  (undo-outer-limit (* 13 24000000))
  (save-interprogram-paste-before-kill t)
  (mouse-drag-and-drop-region-cross-program t)
  (mouse-drag-and-drop-region-scroll-margin t)
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
                                       "\\*Completions\\*"))
  (large-file-warning-threshold nil)
  (find-ls-options '("-exec ls -ldh {} +" . "-ldh"))
  (redisplay-skip-fontification-on-input t)
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
      (setq x-super-keysym 'meta
            x-meta-keysym 'alt))
     ((eq system-type 'darwin)
      (setq mac-option-key-is-meta nil
            mac-command-key-is-meta t
            mac-control-modifier 'control
            mac-command-modifier 'meta
            mac-option-modifier 'hyper
            insert-directory-program (executable-find "gls"))
      (menu-bar-mode)
      (add-to-list 'default-frame-alist '(ns-appearance . dark))
      (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

      (defun kam-mac-copy-config-to-config-folder ()
        "Copy .dotfiles config folder to .config/emacs folder."
        (interactive)
        (copy-file
         "/Users/kamronsmith/.dotfiles/config/init.el"
         "/Users/kamronsmith/.config/emacs/init.el"
         t)
        (message "Copied config to emacs directory")))))

  (put 'narrow-to-region 'disabled nil)

  (keymap-global-set "C-M-(" 'insert-parentheses)
  (keymap-global-set "C-\"" 'kam-insert-quote)
  (keymap-global-set "M-\"" 'kam-insert-quote)
  (keymap-global-set "C-M-m" 'kam-mark-point-to-end-of-line)

  (when (not (file-exists-p (expand-file-name "auto-saves" kam-emacs-cache-directory)))
    (make-directory (expand-file-name "auto-saves" kam-emacs-cache-directory)))

  (setq-default comment-column 0)

  (defun kam-whitespace-handling ()
    (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

(use-package minibuffer
  :ensure nil
  :hook ((minibuffer-setup . cursor-intangible-mode)
         (minibuffer-setup . kam-minibuffer-setup-hook)
         (minibuffer-exit . kam-minibuffer-exit-hook))
  :custom
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  (resize-mini-windows t)
  (resize-mini-frames t)
  (enable-recursive-minibuffers t)
  (read-answer-short t)
  (crm-prompt (format "%s %%p" (propertize "[%d]" 'face 'shadow)))
  :config
  (defun kam-minibuffer-setup-hook ()
    "Function for settings as the minibuffer starts."
    (setq gc-cons-threshold most-positive-fixnum
          truncate-lines t)
    (setq-local line-spacing '(1 . 1))
    (pulsar-pulse-line))

  (defun kam-minibuffer-exit-hook ()
    "Function for settings as the minibuffer exits."
    (setq gc-cons-threshold (* 1000 1000 8))))

(use-package completion
  :ensure nil
  :custom
  (completion-cycle-threshold 1)
  (completion-eager-update t)
  (completion-eager-display t)
  (tab-always-indent 'complete)
  (completion-auto-help 'lazy)
  (completions-max-height 20)
  (completions-format 'one-column)
  (completions-group t)
  (completion-auto-select 'second-tab)
  (completion-ignore-case t)
  (completions-sort 'historical)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (read-extended-command-predicate #'command-completion-default-include-p))

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
                   (mode . emms-show-all-mode))))))
  :config
  (add-to-list 'ibuffer-formats "Recency"))

(use-package window
  :ensure nil
  :bind
  ([kam-i] . kam-split-window-right)
  ("C-l" . recenter)
  ("C-v" . kam-scroll-down)
  ("C-^" . kam-alternate-buffer)
  ("C-+" . delete-window)
  ("M-v" . scroll-down)
  ("M-+" . delete-other-windows)
  :custom
  (window-sides-slots '(0 0 1 1))
  (split-window-preferred-direction 'vertical)
  (even-window-sizes nil)
  (cursor-in-non-selected-windows nil)
  (next-error-recenter '(4))
  (window-combination-resize t)
  (switch-to-buffer-in-dedicated-window 'pop)
  (switch-to-buffer-obey-display-actions t)
  (switch-to-buffer-preserve-window-point t)
  (truncate-partial-width-windows nil)
  (quit-window-kill-buffer nil)
  (kill-buffer-quit-windows t)
  (split-width-threshold 170)
  (split-height-threshold nil)
  (display-buffer-base-action '((display-buffer-reuse-window display-buffer-same-window)
                                (reusable-frames . t)))
  (display-buffer-alist
   `(("\\*Async Shell Command\\*"
      (display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.45)
      (window-parameters . ((mode-line-format . none))))
     ("Output\\*$"
      (display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.45)
      (window-parameters . ((mode-line-format . none))))
     ("\\*Backtrace\\*"
      (display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.35)
      (window-parameters . ((mode-line-format . none))))
     ("^\\*Warnings\\*$"
      (display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.35)
      (window-parameters . ((mode-line-format . none))))
     ("^\\*Messages\\*$"
      (display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.35)
      (window-parameters . ((mode-line-format . none))))
     ("^\\*Occur\\*"
      (display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.45)
      (window-parameters . ((mode-line-format . none))))
     ("\\*Pp Eval Output\\*"
      (display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.35)
      (window-parameters . ((mode-line-format . none))))
     ("^\\*Pacman: "
      (display-buffer-in-side-window)
      (side . bottom)
      (window . root)
      (window-height . 0.45)
      (window-parameters . ((mode-line-format . none))))))
  :config
  (defun kam-quit-window ()
    "Quit the window and kill it."
    (interactive)
    (quit-window t))

  (defun kam-window-bounds ()
    "Return the start and end points of the current window as a cons cell."
    (cons (window-start) (window-end)))

  (defun kam-three-or-more-windows-p (&optional frame)
    "Return non-nil if three or more windows occupy FRAME.
If FRAME is non-nil, inspect the current frame."
    (>= (length (window-list frame :no-minibuffer)) 3))

  (defun kam-two-windows-p (&optional frame)
    "Return non-nil if two windows occupy FRAME.
If FRAME is non-nil, inspect the current frame."
    (= (length (window-list frame :no-minibuffer)) 2))

  (defun kam-window-narrow-p ()
    "Return non-nil if the window is narrow.
Check if the `window-width' is less than `split-width-threshold'."
    (and (numberp split-width-threshold)
         (< (window-total-width) split-width-threshold)))

  (defun kam-window-small-p ()
    "Return non-nil if the window is small.
Check if the `window-width' or the `window-height' is less than `split-width-threshold' or `split-height-threshold', respectively."
    (or (and (numberp split-width-threshold)
             (< (window-total-width) split-width-threshold))
        (and (numberp split-height-threshold)
             (> (window-total-height) split-height-threshold))))

  (defun kam-split-window-right ()
    "Like the normal `split-window-right' but selects the newly formed window."
    (interactive)
    (split-window-right)
    (windmove-right))

  (defun kam-split-window-below ()
    "Like the normal `split-window-below', but splits the window at the root if there are two windows. Additionally selects the newly formed window."
    (interactive)
    (if (kam-two-windows-p)
        (split-root-window-below)
      (split-window-below)))

  (defun kam-alternate-buffer (&optional window)
    "Switch back and forth between current and last buffer in the current window."
    (interactive)
    (let ((current-buffer (window-buffer window)))
      (switch-to-buffer
       (cl-find-if (lambda (buffer)
                     (not (eq buffer current-buffer)))
                   (mapcar #'car (window-prev-buffers window)))
       nil t)))

  (defun kam-window-delete-popup-frame (&rest _)
    "Kill selected frame if it has the parameter `kam-window-popup-frame'.
Use this function via a hook."
    (when (frame-parameter nil 'kam-window-popup-frame)
      (delete-frame)))

  (defmacro kam-window-define-with-popup-frame (command)
    "Define interactive function which calls COMMAND in a new fraeme.
Make the new frame have the `kam-window-popup-frame-paramter."
    `(defun ,(intern (format "kam-window-popup-%s" command)) ()
       ,(format "Run `%s' in a popup frame with `kam-window-popup-frame' parameter.
Also see `kam-window-delete-popup-frame'." command)
       (interactive)
       (let ((frame (make-frame '((kam-window-popup-frame . t)))))
         (select-frame frame)
         (switch-to-buffer " kam-window-hidden-buffer-for-popup-frame")
         (condition-case nil
             (call-interactively ',command)
           ((quit error user-error)
            (delete-frame frame)))))))

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
         (dired-mode . kam-dired-setup-imenu)
         (dired-mode . lin-mode))
  :bind
  (:map dired-mode-map
        ("<mouse-2>" . dired-mouse-find-file)
        ("b" . dired-up-directory)
        ("o" . dired-do-open)
        ("i" . kam-dired-insert-subdir)
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
  (dired-auto-revert-buffer #'dired-directory-changed-p)
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

  (defun kam-dired-setup-imenu ()
    "Configure `Imenu' for the current Dired buffer.
Add this to `dired-mode-hook'."
    (set (make-local-variable 'imenu-prev-index-position-function)
         'kam-dired--imenu-prev-index-position)
    (set (make-local-variable 'imenu-extract-index-name-function)
         'kam-dired--imenu-extract-index-name))

  (defun kam-dired-shell-command-on-file-at-point ()
    "Runs a shell command on the file at point."
    (interactive)
    (concat
     (read-shell-command "Shell command: ")
     " "
     (dired-file-name-at-point)))

  (defun kam-dired-home-dir ()
    "Opens the home directory."
    (interactive)
    (dired (getenv "HOME"))))

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
  :bind
  (:map dired-mode-map
        ("w" . wdired-change-to-wdired-mode))
  :custom
  (wdired-allow-to-change-permissions t)
  (wdired-create-parent-directories t))

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

(use-package fd-dired
  :bind
  (:map dired-mode-map
        ("f" . fd-name-dired)))

(use-package trashed
  :commands (trashed)
  :bind
  ("C-c t" . trashed)
  :custom
  (trashed-action-confirmer 'y-or-n-p)
  (trashed-use-header-line t)
  (trashed-sort-key '("Date deleted" . t)))

(use-package reader
  :vc (:url "https://codeberg.org/MonadicSheep/emacs-reader"
            :make "all"))

(use-package repeat
  :ensure nil
  :hook (after-init . repeat-mode)
  :custom
  (repeat-on-final-keystroke t)
  (repeat-exit-timeout 5)
  (repeat-exit-key "<escape>")
  (repeat-keep-prefix nil)
  (repeat-check-key t)
  (repeat-echo-function 'ignore)
  (set-mark-command-repeat-pop t)

  (defun kam-make-repeat-map (keymap)
    "Add `repeat-mode' support to KEYMAP."
    (map-keymap
     (lambda (_key cmd)
       (when (symbolp cmd)
         (put cmd 'repeat-map keymap)))
     (symbol-value keymap))))

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
  :bind
  ([remap imenu] . consult-imenu)
  :custom
  (org-imenu-depth 4))

(use-package help
  :ensure nil
  :hook ((help-mode . lin-mode)
         (help-mode . variable-pitch-mode))
  :bind (:map help-mode-map
              ("q" . kam-quit-window)
              ("p" . kam-docview-backward-paragraph)
              ("n" . kam-docview-forward-paragraph)
              ("j" . forward-button)
              ("k" . backward-button)
              ("<mouse-9>" . help-go-back)
              ("<next>" . scroll-down-line)
              ("<prior>" . scroll-up-line))
  :custom
  (help-window-select t)
  (help-window-keep-selected t)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Help\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.5)
                 (mode help-mode)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'display-buffer-alist
               '("\\*Error\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window-width . 0.35)
                 (mode help-mode)
                 (window-parameters . ((mode-line-format . none)))))

  (with-eval-after-load 'consult
    (add-to-list 'consult-buffer-filter
                 "^\\*Help\\*" t)
    (add-to-list 'consult-buffer-filter
                 "^\\*Error\\*" t))

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*Help\\*")
  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "\\*Error\\*"))

(use-package apropos
  :ensure nil
  :hook ((apropos-mode . lin-mode)
         (apropos-mode . variable-pitch-mode))
  :bind
  ("C-h F" . apropos-function)
  ("C-h V" . apropos-variable)
  :custom
  (apropos-compact-layout t)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Apropos\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.5)
                 (mode apropos-mode)
                 (window-parameters . ((mode-line-format . none))))))

(use-package info
  :ensure nil
  :hook ((Info-mode . lin-mode)
         (Info-mode . variable-pitch-mode))
  :bind
  ("C-h r" . info-display-manual)
  ("C-h R" . info-emacs-manual)
  (:map Info-mode-map
              ("M-[" . Info-history-back)
              ("<mouse-9>" . Info-history-back)
              ("M-]" . Info-history-forward)
              ("p" . kam-docview-backward-paragraph)
              ("P" . Info-prev)
              ("n" . kam-docview-forward-paragraph)
              ("N" . Info-next)
              ("j" . Info-next-reference)
              ("k" . Info-prev-reference)
              ("<next>" . scroll-down-line)
              ("<prior>" . scroll-up-line))
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Info\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.5)
                 (mode Info-mode)
                 (window-parameters . ((mode-line-format . none)))))

  (with-eval-after-load 'consult
    (add-to-list 'consult-buffer-filter
                 "^\\*Info\\*" t))

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "^\\*Info\\*"))

(use-package man
  :ensure nil
  :hook ((Man-mode . lin-mode)
         )
  :bind (:map Man-mode-map
              ("p" . kam-docview-backward-paragraph)
              ("n" . kam-docview-forward-paragraph))
  :custom
  (Man-notify-method 'pushy)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Man "
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.5)
                 (mode . Man-mode)
                 (window-parameters . ((mode-line-format . none)))))

  (with-eval-after-load 'consult
    (add-to-list 'consult-buffer-filter
                 "^\\*Man " t))

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "^\\*Man "))

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
        ("RET" . kam-re-builder-replace-regexp)
        ("<escape>" . reb-quit)
        :map reb-lisp-mode-map
        ("RET" . kam-re-builder-replace-regexp)
        ("<esc>" . reb-quit))
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
  (recentf-auto-cleanup 60)
  (recentf-exclude '("^/\\(?:ssh\\|su\\|sudo\\)?:"))
  (recentf-save-file (expand-file-name "recentf" kam-emacs-cache-directory))
  (recentf-show-messages nil)
  (recentf-suppress-open-file-help nil)
  (recentf-filename-handlers nil)
  :config
  (add-to-list 'recentf-exclude "\\/sudoedit:root")
  (add-to-list 'recentf-exclude "~\\'")
  (add-to-list 'recentf-exclude "\\.el\\.gz\\'")

  (advice-add #'recentf-cleanup :around #'kam-call-function-quietly)
  (advice-add #'recentf-save-list :around #'kam-call-function-quietly))

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
  (defun kam-set-font-faces ()
    (set-face-attribute 'default nil :font "SauceCodePro Nerd Font" :height 140 :weight 'regular :width 'regular)
    (set-face-attribute 'fixed-pitch nil :font "Aporetic Sans Mono" :height 1.0 :weight 'regular :width 'regular)
    (set-face-attribute 'variable-pitch nil :family "Aporetic Sans Mono" :height 1.0 :weight 'regular :width 'regular)
    (set-face-attribute 'mode-line nil :font "SauceCodePro Nerd Font Mono" :height 1.0 :weight 'regular)
    (set-face-attribute 'mode-line-active nil :font "SauceCodePro Nerd Font Mono" :height 1.0  :weight 'regular)
    (set-face-attribute 'mode-line-inactive nil :family "SauceCodePro Nerd Font Mono" :height 1.0 :weight 'regular))

  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (with-selected-frame frame
                    (kam-set-font-faces)
                    (run-hooks 'modus-themes-after-load-theme-hook))))
    (kam-set-font-faces)
    (load-theme 'standard-dark :no-confirm)
    (run-hooks 'modus-themes-after-load-theme-hook)))

(use-package vertico
  :hook (after-init . vertico-mode)
  :bind
  (:map vertico-map
        ("C-." . embark-act)
        ("<escape>" . kam-keyboard-quit-dwim)
        ("C-v" . vertico-scroll-up)
        ("M-v" . vertico-scroll-down)
        ("M-<return>" . vertico-exit-input)
        ("<up>" . nil)
        ("<down>" . nil)
        ("C-<return>" . minibuffer-force-complete-and-exit)
        ("C-g" . nil))
  :custom
  (vertico-resize t)
  (vertico-cycle t)
  (vertico-scroll-margin 0)
  (vertico-preselect 'prompt))

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
    '((vertico-count . 10)
      (vertico-resize . t))
    "List of configurations for maximal Vertico multiform.")

  (defvar kam-vertico-multiform-minimal
    '(unobtrusive
      (vertico-flat-format . ( :multiple ""
                               :single ""
                               :prompt ""
                               :separator ""
                               :ellipsis ""
                               :no-match ""))
      (vertico-preselect . prompt)))

  (setq vertico-multiform-categories
        `((embark-keybinding grid)
          (consult-location ,@kam-vertico-multiform-maximal)
          (imenu ,@kam-vertico-multiform-maximal)
          (unicode-name ,@kam-vertico-multiform-maximal)
          (multi-category ,@kam-vertico-multiform-maximal)
          (file ,@kam-vertico-multiform-maximal
                (vertico-sort-function . vertico-sort-directories-first))))

  (setq vertico-multiform-commands
        `(
          ;; ("consult-\\(.*\\)?\\(find\\|grep\\|ripgrep\\|fd\\)" buffer)
          (execute-extended-command ,@kam-vertico-multiform-maximal)
          (describe-variable ,@kam-vertico-multiform-maximal)
          (describe-function ,@kam-vertico-multiform-maximal)
          (find-file ,@kam-vertico-multiform-maximal)
          (consult-dir ,@kam-vertico-multiform-maximal)
          (project-switch-project ,@kam-vertico-multiform-maximal)
          (kam-menu ,@kam-vertico-multiform-maximal)
          (dired-do-rename ,@kam-vertico-multiform-maximal)
          (dired-do-copy ,@kam-vertico-multiform-maximal)
          (dired-create-directory ,@kam-vertico-multiform-maximal)
          (find-name-dired ,@kam-vertico-multiform-maximal)
          (jinx-correct grid (vertico-grid-annotate . 20))))
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
         ("C-M-x" . consult-mode-command)
         ("C-x r s" . consult-register-store)
         ("C-x r l" . consult-register-load)
         :map search-map
         ("M-f" . consult-fd)
         ("M-g" . consult-ripgrep)
         ("M-l" . consult-line)
         ("M-p" . kam-consult-line-symbol-at-point)
         :map goto-map
         ("M-e" . consult-compile-error)
         ("M-o" . kam-menu)
         ("M-i" . consult-imenu)
         ("M-m" . consult-mark)
         :map isearch-mode-map
         ("M-r" . consult-isearch-history)
         ("M-s M-l" . kam-consult-isearch)
         :map minibuffer-local-map
         ("M-r" . consult-history)))
  :custom
  (register-preview-delay 0)
  (register-preview-function #'consult-register-format)
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)
  (consult-narrow-key ">")
  (consult-async-min-input 2)
  :config
  (advice-add #'register-preview :override #'consult-register-window)
  (add-to-list 'consult-preview-allowed-hooks 'global-org-modern-mode)
  (add-to-list 'consult-preview-allowed-hooks 'olivetti-mode)
  (add-to-list 'consult-preview-allowed-hooks 'variable-pitch-mode)
  (add-to-list 'consult-preview-allowed-hooks 'buffer-face-mode)

  (add-to-list 'consult-buffer-filter
               "-shell\\*$")
  (add-to-list 'consult-buffer-filter
               "-eshell\\*$")
  (add-to-list 'consult-buffer-filter
               "^\\*Backtrace\\*$" t)

  (defun kam-consult-directory-files-recursively (dir)
    "Find file recursively"
    (interactive)
    (find-file
     (consult--read
      (directory-files-recursively dir "" nil (lambda (x) (not (string-match-p "/\\." x))))
      :state (consult--file-preview)
      :prompt "Find File: "
      :require-match t
      :category 'file)))

  (defvar kam-consult-source-neighbor-file
    `(:name     "File in current directory"
                :narrow   ?.
                :category file
                :face     consult-file
                :history  file-name-history
                :state    ,#'consult--file-state
                :new      ,#'consult--file-action
                :items
                ,(lambda ()
                   (let ((ht (consult--buffer-file-hash)) items)
                     (dolist (file (completion-pcm--filename-try-filter
                                    (directory-files "." 'full "\\`[^.]" nil 100))
                                   (nreverse items))
                       (unless (or (gethash file ht) (not (file-regular-p file)))
                         (push (file-name-nondirectory file) items))))))
    "Neighboring file source for `consult-buffer'.")

  (add-to-list 'consult-buffer-sources 'kam-consult-source-neighbor-file 'append)

  (with-eval-after-load 'popper
    (add-to-list 'popper-reference-buffers
                 (list "consult-\\(.*\\)?\\(find\\|grep\\|ripgrep\\|fd\\)"))))
;; (dolist (src consult-buffer-sources)
;;   (unless (eq src 'consult--source-buffer)
;;     (set src (plist-put (symbol-value src) :hidden tr))))

(use-package consult-dir
  :bind
  (("C-x C-d" . consult-dir)
   :map minibuffer-local-completion-map
   ("C-x C-d" . consult-dir)
   ("C-x C-j" . consult-dir-jump-file))
  :custom
  (consult-dir-shadow-filenames nil)
  (consult-dir-jump-file-command 'consult-fd)
  (consult-dir-default-command 'consult-dir-dired)
  :config
  (defvar kam-consult-dir--directories
    '("~/Documents"
      "~/Documents/Projects/"
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

  (add-to-list 'consult-dir-sources 'kam-consult-dir--source-jumps t))

(use-package consult-flycheck
  :bind
  (:map goto-map
        ("M-l" . consult-flycheck)))

(use-package marginalia
  :config
  ;; (setq marginalia-align 'left
  ;; marginalia-align-offset 0)
  (marginalia-mode))

(use-package embark
  :after (vertico)  ;; load after vertico to avoid vertico-map is void error
  :bind
  ([remap describe-bindings] . embark-bindings)
  ("C-." . embark-act)
  :custom
  (prefix-help-command #'embark-prefix-help-command)
  (embark-prompter #'embark-keymap-prompter)
  (embark-indicators '(embark-highlight-indicator
                       embark-isearch-highlight-indicator))
  :config
  (keymap-set embark-expression-map ";" #'kam-comment-dwim)
  (keymap-set embark-general-map "SPC" 'embark-cycle)
  (keymap-set embark-general-map "." 'embark-cycle)

  (add-to-list 'display-buffer-alist
               '("^\\*Embark Export:"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.5)
                 (mode apropos-mode)
                 (window-parameters . ((mode-line-format . none))))))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

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
        orderless-component-separator #'orderless-escapable-split-on-space
        orderless-style-dispatchers (list #'kam-orderless-consult-dispatch
                                          #'orderless-affix-dispatch)))

(use-package corfu
  :bind
  (:map corfu-map
        ("<return>" . corfu-insert)
        ("M-SPC" . corfu-insert-separator)
        ("C-v" . corfu-scroll-up)
        ("M-v" . corfu-scroll-down)
        ("C-g" . corfu-quit))
  :init
  (global-corfu-mode)
  :custom
  ;; (corfu-separator ?\s)
  ;; (corfu-min-width corfu-max-width)
  (corfu-preview-current t)
  (corfu-cycle t)
  (corfu-preselect 'valid)
  :config
  (defun kam-corfu-combined-sort (candidates)
    "Sort CANDIDATES using both display-sort-function and corfu-sort-function."
    (let ((candidates
           (let ((display-sort-func (corfu--metadata-get 'display-sort-function)))
             (if display-sort-func
                 (funcall display-sort-func candidates)
               candidates))))
      (if corfu-sort-function
          (funcall corfu-sort-function candidates)
        candidates))))

(use-package corfu-quick
  :ensure nil
  :after (corfu)
  :bind
  (:map corfu-map
        ("M-j" . corfu-quick-complete))
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
  :hook (text-mode . kam-cape-dictionary-setup)
  :config
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-line)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)

  (defun kam-cape-dictionary-setup ()
    (add-hook 'completion-at-point-functions 'cape-dict)))

(use-package avy
  :bind
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

  (setf (alist-get ? avy-dispatch-alist) 'kam-avy-action-embark)
  (setf (alist-get ?w avy-dispatch-alist) 'kam-avy-action-kam-cut)
  (setf (alist-get ?o avy-dispatch-alist) 'kam-avy-action-org-refile)
  (setf (alist-get ?v avy-dispatch-alist) 'kam-avy-action-mark-to-char)
  (setf (alist-get ?l avy-dispatch-alist) 'kam-avy-action-org-store-link)
  (setf (alist-get ?p avy-dispatch-alist) 'kam-avy-action-consult-line-at-point)
  (setf (alist-get ?q avy-dispatch-alist) 'kam-avy-action-kill-inner-sexp))

(use-package flash
  :commands (flash-jump flash-treesitter)
  :bind ("M-j" . flash-jump)
  :custom
  (flash-labels "strdneaiy.mvlcpbfouqzkjgh")
  (flash-autojump t))

(use-package ace-window
  :bind
  ("M-o" . ace-window)
  ;; ("M-o" . kam-ace-window-dispatch)
  :custom
  (aw-dispatch-always nil)
  (aw-keys '(?d ?n ?r ?e ?t ?a))
  (aw-dispatch-alist
   '((?x aw-delete-window "Delete Window")
     (?m aw-swap-window "Swap Windows")
     (?M aw-move-window "Move Window")
     (?c aw-copy-window "Copy Window")
     (?j aw-switch-buffer-in-window "Select Buffer")
     (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
     (?c aw-split-window-fair "Split Fair Window")
     (?v aw-split-window-vert "Split Vert Window")
     (?b aw-split-window-horz "Split Horz Window")
     (?o delete-other-windows "Delete Other Windows")
     (?? aw-show-dispatch-help)))

  (defun kam-ace-window-dispatch (&optional arg)
    "Small wrapper for `ace-window' that uses the dispatcher."
    (interactive)
    (let ((aw-dispatch-always t))
      (ace-window arg)))

  (defun kam-ace-window-prefix ()
    "Use `ace-window' to display the buffer of the next command.
The next buffer is the buffer displayed by the next command invoked immediately after this command (ignoring reading from the minibuffer a new window before displaying the buffer.
When `switch-to-buffer-obey-display-actions' is non-nil, `switch-to-buffer' commands are also supported."
    (interactive)
    (if (one-window-p) (split-window-right))
    (display-buffer-override-next-command
     (lambda (buffer _)
       (let (window type)
         (setq
          window (aw-select (propertize " ACE" 'face 'mode-line-highlight))
          type 'reuse)
         (cons window type)))
     nil "[ace-window]")
    (message "Use `ace-window' to display next command buffer"))

  (defun kam-ace-window-one-command ()
    "Select a window with `ace-window' and run any command in that window."
    (interactive)
    (if (one-window-p) (split-window-right))
    (let ((win (aw-select " ACE")))
      (when (windowp win)
        (with-selected-window win
          (let* ((command (key-binding
                           (read-key-sequence
                            (format "Run in %s..." (buffer-name)))))
                 (this-command command))
            (call-interactively command)))))))

(use-package popper
  :bind (("C-," . popper-toggle)
         ("C-M-," . popper-cycle)
         ("C-M-#" . popper-toggle-type))
  :custom
  (popper-reference-buffers
   '(("\\*Messages\\*")
     ("Output\\*$")
     ("\\*Apropos\\*")
     ("\\*Async Shell Command\\*")
     ("\\Org Agenda\\*")
     ("\\*Grep\\*")
     ("\\*Backtrace\\*")
     ("\\*Warnings\\*")
     ("\\*shell\\*")
     ("\\*eshell[\:\*]")
     ("-eshell\\*$")
     ("-shell\\*$")
     ("\\*eat\\*")
     ("\\*Compile-Log\\*")
     ("\\*Playlist\\*")
     ("^\\*Pacman:")
     ("^\\*Timeshift:")
     emms-browser-mode
     Man-mode
     help-mode
     Info-mode
     Grep-mode
     shell-command-mode
     comint-mode))
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

  (with-eval-after-load 'consult
    (add-to-list 'consult-preview-excluded-buffers 'kam-popper-buffer-p))

  (with-eval-after-load 'org
    (keymap-set org-mode-map "C-#" #'popper-toggle)
    (keymap-set org-mode-map "M-#" #'popper-cycle)
    (keymap-set org-mode-map "C-M-#" #'popper-toggle-cycle)))

;; (defun kam-tab-new-tab-one-command ()
;;   "Create a rnew tab and and run a command in the newly created tab."
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
  :bind (:map tab-bar-mode-map
              ("C-<tab>" . tab-next)
              ("C-S-<tab>" . tab-previous))
  ;; ("C-x t n" . tab-next)
  ;; ("C-x t p" . tab-previous)
  ("C-x t +" . tab-close)
  ("C-x t t" . kam-consult-tab)
  :init
  (defun tab-bar-tab-group-format-default (tab _i &optional current-p)
    (propertize
     (concat (funcall tab-bar-tab-group-function tab))
     'face (if current-p 'tab-bar-tab-group-current 'tab-bar-tab-group-inactive)))

  (tab-bar-mode 1)
  :custom
  (tab-bar-show t)
  (tab-bar-close-button-show nil)
  (tab-bar-new-button nil)
  (tab-bar-tab-hints t)
  (tab-bar-auto-width nil)
  (tab-bar-separator " ")
  (tab-bar-format '(tab-bar-format-tabs-groups
                    ;; tab-bar-format-tabs
                    tab-bar-separator))

  :config
  (defun kam-tab-bar-group-from-project ()
    "Call `tab-group' with the current project name as the group."
    (interactive)
    (when-let* ((proj (project-current))
                (name (file-name-nondirectory
                       (directory-file-name (project-root proj)))))
      (tab-group (format "[P] %s" name))))

  (defvar-keymap kam-tab-repeat-map
    :repeat t
    :doc "Repeat map for tabs"
    "p" 'tab-previous
    "n" 'tab-next))

(use-package otpp

  :after (project)
  :init
  (otpp-mode 1)
  (otpp-override-mode 1))

(defun kam-next-buffer (&optional arg)
  "Swith to the next ARGth buffer.
With a universal prefix arg, run in the next window."
  (interactive "P")
  (if-let* (((equal arg '(4)))
            (win (other-window-for-scrolling)))
      (with-selected-window win
        (next-buffer)
        (setq prefix-arg current-prefix-arg))
    (next-buffer arg)))

(defun kam-prev-buffer (&optional arg)
  "Switch to the previous ARGth buffer.
With a universal prefix arg, run in the next window."
  (interactive "P")
  (if-let* (((equal arg '(4)))
            (win (other-window-for-scrolling)))
      (with-selected-window win
        (previous-buffer)
        (setq prefix-arg current-prefix-arg))
    (previous-buffer arg)))

(defun kam-get-alternate-buffer (&optional window)
  "Return the last buffer WINDOW has displayed other than the current one."
  (let* ((prev-buffers (window-prev-buffers))
         (head (car prev-buffers)))
    (if (eq (car head) (window-buffer window))
        (cadr prev-buffers)
      head)))

(defun kam-switch-to-alternate-buffer ()
  "Switch to the last window used."
  (interactive)
  (let* (alt-buffer (kam-get-alternate-buffer))
    (switch-to-buffer alt-buffer)))

(defun kam-clone-buffer-and-narrow ()
  (interactive)
  (clone-indirect-buffer-other-window nil 'pop-to-buffer)
  (cond ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode) (org-narrow-to-subtree))
        (t (narrow-to-defun))))

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
  "Around advice for `keyboard-escape-quit', calls FUN.
Preserve window configuration when pressing \\[keyboard-escape-quit]."
  (let ((buffer-quit-function (or buffer-quit-function #'ignore)))
    (funcall fun)))

(advice-add #'keyboard-escape-quit :around #'kam-keyboard-escape-quit-advice)

(defun kam-kill-current-buffer (&optional arg)
  "Kill the current buffer, no prompts.
With optional prefix ARG (\\[universal-argument]), delete the buffer's window as well."
  (interactive "P")
  (let ((kill-buffer-query-functions nil))
    (if (or (null (window-prev-buffers))
            (and (not (one-window-p))))
        (kill-buffer-and-window)
      (kill-buffer))))

;;; Isearch
(use-package isearch
  :ensure nil
  :bind
  (:map isearch-mode-map
        ("C-g" . kam-isearch-quit)
        ("<backspace>" . kam-isearch-removed-failed-or-last-char))
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
    (if (eq isearch-string "")
        (isearch-update)
      (if isearch-success
          (isearch-delete-char)
        (while (isearch-fail-pos) (isearch-pop-state)))
      (isearch-update)))

  (defun kam-isearch-quit ()
    "Cancel the current Isearch."
    (interactive)
    (setq isearch-success nil)
    (isearch-cancel)))

(use-package harpoon
  :custom
  (harpoon-project-package 'project)
  (harpoon-cache-file (expand-file-name "harpoon/" kam-emacs-cache-directory))
  :bind
  ("C-c h f" . harpoon-toggle-file)
  ("C-c h SPC" . harpoon-add-file)
  ("C-c h c" . harpoon-clear)
  ("A-n" . harpoon-go-to-1)
  ("A-e" . harpoon-go-to-2)
  ("A-a" . harpoon-go-to-3)
  ("A-i" . harpoon-go-to-4)
  :config
  (add-to-list 'display-buffer-alist
               '((derived-mode . harpoon-mode)
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (mode . harpoon-mode)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none))))))

(use-package drag-stuff
  :bind
  (("M-<up>" . drag-stuff-up)
   ("M-<down>" . drag-stuff-down)))

(use-package grep
  :ensure nil
  :bind
  (("M-s g" . grep)
   :map grep-mode-map
   ("w" . grep-change-to-grep-edit-mode)
   :map grep-edit-mode-map
   ("C-c C-c" . grep-edit-save-changes))
  :custom
  (grep-program "ripgrep")
  (grep-command "rg -nS --no-heading --color=always ")
  (grep-use-null-device nil)
  (grep-find-ignored-directories
   '("SCCS" "RCS" "CVS" "MCVS" ".src" ".svn" ".jj" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules" "build" "dist"))
  :config
  (add-to-list 'display-buffer-alist
               '("\\*[Gg]rep\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none))))))

(use-package link-hint
  :bind
  ("C-M-j" . link-hint-open-link))

(use-package smartparens)

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

(use-package electric
  :ensure nil
  :hook ((org-mode . electric-indent-local-mode)
         (prog-mode . electric-indent-local-mode)
         (text-mode . electric-quote-local-mode))
  :custom
  (electric-indent-actions '(yank))
  :config
  (electric-pair-mode)

  ;; (add-to-list 'electric-pair-pairs
  ;;              '("/*" . "*/"))

  ;; (add-to-list 'electric-pair-text-pairs
  ;;              '("/*" "*/") t)
  )

(use-package aggressive-indent)

(use-package visible-mark
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
  (("C-=" . expreg-expand)
   ("C--" . expreg-contract))
  :config
  (defun kam-expreg-text-mode-setup ()
    "Set up text mode for expreg."
    (add-to-list 'expreg-functions #'expreg--sentence)))

(defun kam--mark (bounds)
  "Mark between BOUNDS as a cons cell of beginning and end positions."
  (push-mark (car bounds))
  (goto-char (cdr bounds))
  (activate-mark))

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

(defun kam-jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))

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

(defun kam-cut-dwim ()
  "Kill based on the position of the point in the buffer.

If the region is active, kills the region. If the point is on an Org heading, kills the subtree. If the point is at an item in an Org list, kills that item. If none of the previous conditions are true, kills the current line."
  (interactive)
  (cond ((region-active-p)
         (kill-region nil nil t)
         (setq this-command 'kill-region))
        ((and (derived-mode-p 'org-mode) (org-at-heading-p))
         (org-cut-subtree)
         (setq this-command 'org-cut-subtree))
        ((and (derived-mode-p 'org-mode) (org-in-item-p))
         (kam-org-kill-item)
         (setq this-command 'kill-region))
        (t
         (kam-kill-whole-line 1)
         (setq this-command 'kill-region))))

(defun kam-kill-ring-save-dwim ()
  "If the region is active, copy the region. If the region is inactive, copy the line. If point is at an Org heading, copy the subtree. If the point is at an Org item, copy the item. Else, copy the line."
  (interactive)
  (cond ((region-active-p)
         (copy-region-as-kill nil nil t)
         (setq this-command 'copy-region-as-kill))
        ((and (derived-mode-p 'org-mode) (org-at-heading-p))
         (org-copy-subtree)
         (setq this-command 'org-copy-subtree))
        ((and (derived-mode-p 'org-mode) (org-in-item-p)) ;; Org-in-item-p doesnt work if out of org mode
         (copy-region-as-kill (car (kam-org-item-bounds)) (cdr (kam-org-item-bounds)))
         (setq this-command 'copy-region-as-kill))
        (t
         (kam-mark-line-with-newline)
         (kill-ring-save nil nil t)
         (setq this-command 'kill-ring-save))))

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
  "Complicated yank function that tries to determine how you want to yank based on a few factors."
  (interactive)
  (cond
   ((kam-line-regexp-p 'empty)
    (let ((yank-transform-functions #'kam-yank--string-remove-newline-prefix))
      (yank)))
   ((string-match-p "\n" (current-kill 0))
      (let ((yank-transform-functions #'kam-yank--string-add-newline-prefix))
        (move-end-of-line 1)
        (yank)))
    (t (yank))))

(defun kam-yank--string-remove-newline-prefix (string)
  "Remove the newline character at the beginning of STRING.
Intended to be used in `kam-yank-dwim'."
  (let ((new-string (string-remove-prefix "\n" string)))
    new-string))

(defun kam-yank--string-add-newline-prefix (string)
  "Add a newline character to the beginning of STRING. Remove the newline character at the end of STRING.
Intended to be used in `kam-yank-dwim'."
  (let* ((newline-string (string-remove-suffix "\n" string))
         (beginning-whitespace-string (concat "\n" newline-string)))
    beginning-whitespace-string))

(defun kam-delete-pair-dwim ()
  "Delete pair before or preceding point."
  (interactive)
  (if (eq (point) (bounds-of-thing-at-point 'sexp))
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

(defun kam-join-line-dwim ()
  "Join lines based on the position of the point on the current line.
If the point is at the end of the line, join the next line to the current line. If the point is anywhere but the end of the line, joins the current line to the previous line."
  (interactive)
  (if (eolp)
      (progn
        (forward-line)
        (join-line)
        (indent-according-to-mode))
    (join-line)
    (indent-according-to-mode)))

(defun kam-open-line-dwim ()
  "Open the line and indent it to the proper place."
  (interactive)
  (save-excursion
      (open-line 1)
      (forward-line)
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

(defun kam-kill-whole-line (n)
  "Kill the whole line, regardless of the cursor position within the line.
If called interactively without a prefix numeric argument, N is 1."
  (dotimes (_ n)
    (kam-mark-line-with-newline)
    (kill-region (region-beginning) (region-end))))

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

(defun kam-comment-dwim (n)
  "Comment N lines, defaulting to the current line.
When the region is active, comment its lines instead."
  (interactive "p")
  (if (region-active-p)
      (comment-or-uncomment-region
       (region-beginning) (region-end))
    (comment-line n)))

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
Unlike `eval-last-sexp', the point doesn't need to be at the end of the expression, but can be at the beginning (on the parenthesis) or somewhere inside."
  (interactive)
  (eval-expression (kam-current-elisp-sexp)))

(defun kam-kill-inner-sexp ()
  "Intended to kill everything inside the closest pair of paired delimiters."
  (interactive)
  (sp-kill-sexp 0))

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

;; (defun kam-yank ()
;;   (interactive)
;;   (let ((yank-transform-functions
;;          '(kam-yank--string-transform)))
;;     (cond
;;      ((derived-mode-p 'org-mode)
;;       (org-yank))
;;      (t
;;       (yank)))))

(defun kam-yank-undo (arg)
  "Undo the yank you just did. Reverses the direction you are going in the kill ring."
  (interactive "p")
  (yank-pop (- arg)))

(defun kam-scroll-down (&optional arg)
  "Recenter the point and scroll down."
  (interactive)
  (scroll-up-command)
  (recenter))

(defun kam-scroll-up (&optional arg)
  "Recenter the point and scroll up."
  (interactive)
  (scroll-down-command)
  (unless (= (window-start) (point-min))
    (recenter))
  (when (= (window-start) (point-min))
    (let ((midpoint (/ (window-height) 2)))
      (goto-char (window-start))
      (forward-line midpoint)
      (recenter midpoint))))

(defun kam-filter-lines-in-string (input-string regexp &optional keep-matching)
  "Filter lines in INPUT-STRING that match REGEXP.
If KEEP-MATCHING is non-nil, keep lines that match; otherwise, remove them.
Returns the filtered string."
  (let* ((lines (split-string input-string "\\n" nil ""))
         (filtered-lines (if keep-matching
                             (cl-remove-if-not (lambda (line) (string-match-p regexp line)) lines)
                           (cl-remove-if (lambda (line) (string-match-p regexp line)) lines))))
    (mapconcat 'identity filtered-lines "\\n")))

(use-package org
  :ensure nil
  :hook ((org-mode . variable-pitch-mode)
         (org-mode . visual-line-mode)
         (org-mode . kam-org-syntax-table-modify))
  :bind
  (("C-c o l" . kam-consult-org-heading-link)
   ("C-c o p" . org-set-property)
   ("C-c o n" . kam-org-insert-notes-drawer)
   :map org-mode-map
   ("C-v" . kam-scroll-down)
   ("M-v" . kam-scroll-up)
   ("C-{" . org-previous-visible-heading)
   ("M-{" . kam-org-metaup)
   ("C-}" . org-next-visible-heading)
   ("M-}" . kam-org-metadown)
   ("C-<return>" . kam-insert-new-line-below)
   ("C-<backspace>" . kam-control-backspace)
   ;; ("C-<tab>" . kam-org-up-and-fold-heading)
   ("C-M-<return>" . org-insert-subheading)
   ("<return>" . org-return)
   ("C-j" . kam-join-line-dwim)
   ("C-'" . org-edit-src-code)
   ("M-m" . kam-mark-line)
   ("M-h" . mark-paragraph)
   ("C-y" . kam-yank-dwim)
   ("M-<up>" . kam-org-metaup)
   ("M-<down>" . kam-org-metadown)
   ("C-M-<up>" . kam-org-control-metaup)
   ("C-M-<down>" . kam-org-control-metadown)
   ("C-M-<left>" . kam-org-promote-subtrees)
   ("C-M-<right>" . kam-org-demote-subtrees)
   ("C-M-<return>" . org-meta-return)
   ("C-M-h" . org-mark-element)
   ("C-M-m" . kam-mark-point-to-end-of-line)
   ("C-M-q" . kam-kill-inner-sexp)
   ("C-M-v" . sp-mark-sexp)
   ("C-x C-v" . org-mark-element)
   ("C-x k" . kam-kill-current-buffer)
   ("C-x n" . kam-narrow-or-widen-dwim)
   :map org-src-mode-map
   ("C-'" . org-edit-src-exit)
   ("C-<backspace>" . kam-control-backspace))
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
  (defvar kam-todo-file "/home/kam/Documents/Inbox/todo.org"
    "File where all todo's are kept.")

  (defun kam-org-syntax-table-modify ()
    "Modify `org-mode-syntax-table' for the current Org buffer.
This stops the mismatch parenthesis bug in Org source blocks."
    (modify-syntax-entry ?< "." org-mode-syntax-table)
    (modify-syntax-entry ?> "." org-mode-syntax-table))

  (defun kam-org-cape-setup ()
    "Setup hook that defines completion at point functions."
    (setq-local completion-at-point-functions
                '(cape-dict
                  cape-dabbrev
                  cape-abbrev
                  cape-file
                  t)))

  (defun kam-org-metaup ()
    "Go to the previous heading or item, or to a higher level heading.
If not on a heading or item, finds the previous heading backwards. If already on a heading, goes up higher in the tree."
    (interactive)
    (cond
     ((org-at-block-p) (org-up-element))
     ((org-in-src-block-p) (org-babel-goto-src-block-head))
     ((kam-org--level-one-heading-p) (org-backward-heading-same-level 1))
     (t (org-up-element))))

  (defun kam-org-metadown ()
    "Go to the next heading or item, or to a higher level heading.
If not on a heading or item, finds the next heading forwards. If already on a heading, goes up a level."
    (interactive)
    (cond
     ((org-at-block-p) (org-down-element))
     ((org-in-src-block-p) (kam-org-babel-goto-src-block-foot))
     ((kam-org--level-one-heading-p) (org-forward-heading-same-level 1))
     (t (org-next-visible-heading 1))))

  (defun kam-org-control-metaup (&optional arg)
    (interactive "p")
    (if (org-at-heading-p)
        (org-metaup arg)
      (backward-up-list arg)))

  (defun kam-org-control-metadown (&optional arg)
    (interactive "p")
    (if (org-at-heading-p)
        (org-metadown arg)
      (down-list arg)))

  (defun kam-org-item-bounds ()
    "Return a cons cell of the bounds of the item at point."
    (if (org-in-item-p)
        (cons (save-excursion
                (org-beginning-of-item)
                (point))
              (save-excursion
                (org-end-of-item)
                (point)))
      (user-error "%s" "Point is not in an Org item")))

  (defun kam-org-insert-super-heading (arg)
    (interactive "P")
    (org-insert-heading arg)
    (cond
     ((org-at-heading-p) (org-promote))
     ((org-at-item-p) (org-indent-item))))

  (defun kam-org-kill-item ()
    "Kills the Org item at point."
    (interactive)
    (let ((bounds (kam-org-item-bounds)))
      (kill-region (car bounds) (cdr bounds))))

  (defun kam-org--level-one-heading-p ()
    "Return non-nil if the point is on a level one Org heading."
    (if (eq (nth 1 (org-heading-components)) 1)
        t
      nil))

  (defun kam-org-promote-subtrees ()
    "Promote the subtree and all subtrees under it at point."
    (interactive)
    (org-map-entries
     (org-promote-subtree)
     nil
     'tree))

  (defun kam-org-demote-subtrees ()
    "Demote the subtree and all subtrees at point."
    (interactive)
    (org-map-entries
     (org-demote-subtree)
     nil
     'tree))

  (defun kam-org-up-heading (&optional arg)
    (interactive "p")
    (cond
     ((org-in-src-block-p) (org-babel-goto-src-block-head))
     ((kam-org--level-one-heading-p) (org-backward-heading-same-level arg))
     (t (org-up-element))))

  (defun kam-org-insert-notes-drawer ()
    "Generate or open a NOTES drawer under the current heading.
If a drawer exists for this section, a new line is created at the end of the
current note."
    (interactive)
    (push-mark)
    (org-previous-visible-heading 1)
    (forward-line)
    (if (looking-at-p "^[ \t]*:NOTES:")
        (progn
          (org-fold-hide-drawer-toggle 'off)
          (re-search-forward "^[ \t]*:END:" nil t)
          (forward-line -1)
          (org-end-of-line)
          (org-return))
      (org-insert-drawer nil "NOTES")))

  (defun kam-org-insert-date-range ()
    (interactive)
    (org-time-stamp nil)
    (insert "--")
    (org-time-stamp nil))

  (with-eval-after-load 'pulsar
    (dolist (hook '(org-agenda-after-show-hook org-follow-link-hook))
      (add-hook hook #'pulsar-recenter-center)
      (add-hook hook #'pulsar-reveal-entry)))

  (with-eval-after-load 'standard-theme
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
   '(("t" "TODO" entry (file+headline kam-todo-file "Inbox")
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
  (org-agenda-files `(,kam-todo-file))
  (org-agenda-custom-commands
   '(("i" "Inbox"
      todo)))
  :config
  (defun kam-org-agenda-skip-entry-if-property (prop val)
    "Skip the entry if it marked with PROP property with the value VAL. PROP and VAL should be a string."
    (let ((end (org-entry-end-position))
          (prop-regexp (org-re-property prop nil nil val)))
      (if (re-search-forward prop-regxep end t)
          nil
        end)))

  (defun kam-org-archive-done-tasks ()
    (interactive)
    (org-map-entries
     (lambda ()
       (org-archive-subtree)
       (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
     "/DONE" 'file))

  ;; TODO: Add support for different level headings
  ;; (defun kam-org-agenda-skip-entry-if-not-headline (headline)
  ;;   "Skip the entry if it is not under the headline HEADLINE. HEADLINE should be a string."
  ;;   (let* ((parent-heading (save-excursion
  ;;                         (org-up-heading 1)
  ;;                         (org-heading-components)))
  ;;       (headline (nth 4 parent-heading))
  ;;       (leveler (nth 0 parent-heading))))
  ;;   (message "%s %s" headline leveler))

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
  :config
  (defun kam-org-refile-to-current-file ()
    "Refile the heading under the point to a heading in the current file only."
    (interactive)
    (let ((org-refile-targets '((nil . (:maxlevel . 10)))))
      (org-refile)))

  (defvar kam-org-refile-region-format "\n\n%s")

  (defvar kam-org-refile-region-position 'bottom
    "Where to refile a region. Use 'top to refile the region at the beginning of the subtree.")

  (defun kam-consult-org-refile-region (beg end copy)
    "Refile the active region with minibuffer completion.
If no region is active, refile the current paragraph.
With prefix arg C-u, copy region instead of killing it."
    (interactive "r\nP")
    (unless (use-region-p)
      (setq beg (save-excursion
                  (backward-paragraph)
                  (skip-chars-forward "\n\t ")
                  (point))
            end (save-excursion
                  (forward-paragraph)
                  (skip-chars-forward "\n\t ")
                  (point))))
    (deactivate-mark)
    (let* ((text (buffer-substring-no-properties beg end))
           (target (save-excursion (consult-org-heading)))
           (buffer (marker-buffer target))
           (pos (marker-position target)))
      (unless copy (kill-region beg end))
      (deactivate-mark)
      (with-current-buffer buffer
        (save-excursion
          (goto-char pos)
          (if (eq kam-org-refile-region-position 'bottom)
              (org-end-of-subtree)
            (org-end-of-meta-data-and-drawers))
          (insert (format kam-org-refile-region-format text)))))))

(use-package ol   ;; org links
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
  (defun kam-org-insert-last-stored-link-with-prompt ()
    "Inserts the last stored link in `org-stored-links' while prompting for the description of the link."
    (interactive)
    (let ((links (copy-sequence org-stored-links)))
      (if (null org-stored-links)
          (user-error "No links to insert")
        (setq l (pop links))
        (org-insert-link nil (car l) (read-from-minibuffer "Link Text: ")))))

  (add-to-list 'display-buffer-alist
               '("\\*Org Links\\*" ;; Org Links
                 (display-buffer-no-window)
                 (allow-no-window . t))))

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

  (defvar kam-org-end-block-regexp "#\\+end_\\w+"
    "Regexp that matches the end of an Org Babel block.")

  (defun kam-org-babel-goto-src-block-foot ()
    "Go to the end of an Org Babel block."
    (interactive)
    (goto-char (re-search-forward kam-org-end-block-regexp))))

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
  ("C-c n s" . org-anki-sync-entry)
  :custom
  (org-anki-inherit-tags nil)
  :config
  (setq org-anki-api-key nil
        org-anki-default-deck "get that main main"))

(use-package nix-mode
  :mode "\\.nix\\'")


(use-package denote
  :hook ((dired-mode . denote-dired-mode)
         (after-init . denote-rename-buffer-mode))
  :bind
  ("C-c n h" . kam-ite-visit-home)
  ("C-c n w" . kam-ite-visit-workbench)
  ("C-c n d" . denote-open-or-create)
  ("C-c n b" . denote-backlinks)
  ("C-c n c" . denote-link-or-create)
  (:map dired-mode-map
        ("r" . denote-dired-rename-files))
  :config
  (setq denote-directory (expand-file-name "~/Documents/Resources/Notes/")
        ;; denote-infer-keywords t
        denote-sort-keywords t
        denote-prompts '(title keywords)
        denote-rename-confirmations '(rewrite-front-matter modify-file-name)
        denote-date-prompt-use-org-read-date t)

  (defvar kam-ite-home-note
    (concat denote-directory "20230928T043448--home__index.org")
    "The home note for my ITE.")

  (defvar kam-ite-workbench-note
    (concat denote-directory "20250807T185237--workbench__index.org")
    "The workbench note for my ITE.")

  (defun kam-ite-visit-home ()
    "Visits the `kam-ite-home-note'."
    (interactive)
    (find-file kam-ite-home-note)))

(use-package consult-denote
  :custom
  (consult-denote-find-command #'consult-fd)
  (consult-denote-grep-command #'consult-ripgrep)
  :bind
  ("C-c n g" . consult-denote-grep)
  ("C-c n f" . consult-denote-find)
  :config
  (consult-denote-mode 1))

(use-package denote-org
  :config
  (setq denote-org-store-link-to-heading 'id))

(use-package denote-explore)

(use-package project
  :ensure nil
  :bind
  ("<f3>" . project-recompile)
  ("<f4>" . project-compile)
  (:map project-prefix-map
              ("b" . consult-project-buffer)
              ("d" . kam-project-dired)
              ("g" . consult-ripgrep)
              ("n" . kam-project-new))
  :custom
  (project-switch-use-entire-map nil)
  (project-list-file (expand-file-name "projects" kam-emacs-cache-directory))
  (project-vc-extra-root-markers '("Cargo.toml" "package.json" "go.mod"))
  ;; (project-prompter 'kam-project--read-project-by-name)
  :config
  (setq project-vc-ignores '("nix/store/"
                             "node_modules/"
                             "go/pkg/"
                             ".direnv/")
        project-vc-extra-root-markers '(".project"))

  (add-to-list 'project-switch-commands '(consult-ripgrep "Grep" "g"))
  (add-to-list 'project-switch-commands '(magit-project-status "Magit" "m"))

  (remove '(project-vc-dir "VC-Dir") project-switch-commands)

  (defvar kam-project-name-history nil)

  (defvar kam-projects-directory "~/Documents/Projects/"
    "The default directory where projects are stored.")

  ;; (setq project-prompter #'kam-project--read-project-by-name)

  (defun kam-project--return-formatted-project-name ()
    (when-let* ((proj (project-current))
                (name (file-name-nondirectory
                       (directory-file-name (project-root proj)))))
      (format "[%s]" name)))

  (defun kam-project--read-project-by-name ()
    "Read a project name and return its root directory.

if no known project matches the selected name, prompt for a
sub-directory of `kam-projects-directory' using the selected name
as the initial input for completion, and return that directory."
    (let* ((name-dir-alist
            (mapcar (lambda (dir)
                      (cons (project-name (project-current nil dir))
                            dir))
                    (project-known-project-roots)))
           (current (project-current))
           (default (and current (project-name current)))
           (name (consult--read name-dir-alist
                                :prompt "Project: "
                                :history 'kam-project-name-history
                                :annotate #'marginalia-annotate-file
                                :state (consult--file-state)
                                :category 'file)))
      (or (alist-get name name-dir-alist nil nil #'string=)
          (let* ((dir (read-directory-name "Project root directory: "
                                           kam-projects-directory
                                           nil t name))
                 (project (project-current nil dir)))
            (when project (project-remember-project project))
            dir))))

  (defun kam-project-new ()
    "Create a project in the `kam-projects-directory'."
    (interactive)
    (let* ((default-directory kam-projects-directory)
           (project-name (read-directory-name "Project: "))
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

  (defun kam-project-switch-project (dir)
    "Switch to another project."
    (interactive (list (funcall project-prompter)))
    (project--remember-dir dir)
    (unwind-protect
        (progn
          (setq-local project-current-directory-override dir)
          (call-interactively #'project-find-file))))

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
    (project-remember-projects-under "~/Documents/Projects/")))

(use-package calibredb
  :commands (calibredb)
  :bind
  ("C-c b" . calibredb)
  :config
  (setq calibredb-format-all-the-icons t
        calibredb-root-dir "~/Documents/Resources/Books"
        calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir)
        calibredb-library-alist '(("~/Documents/Resources/Books"))
        calibredb-sort-by 'title)

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

(use-package comint
  :ensure nil
  :custom
  (comint-completion-auto-list t)
  (comint-prompt-read-only t)
  (comint-buffer-maximum-size 9999)
  (comint-input-ignoredups t)
  (ansi-color-for-comint-mode t)
  :config
  (defun kam-comint--beginning-of-prompt-p ()
    "Return non-nil if the point is at the beginning of a shell prompt."
    (if comint-use-prompt-regexp
        (looking-back comint-prompt-regexp
                      (line-beginning-position))
      (eq (point) (comint-line-beginning-position))))

  (defun kam-comint--insert-and-send (&rest args)
    "Insert and execute ARGS in the last Comint prompt.
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
  (:map shell-mode-map
        ("C-^" . kam-shell-up-directory)
        ("C-x C-d" . kam-shell-cd)
        ("C-c C-k" . comint-clear-buffer)
        ("C-c C-w" . comint-write-buffer)
        ("C-g" . comint-interrupt-subjob)
        ("C-w" . unix-word-rubout))
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
                completion-at-point-functions '(cape-file comint-completion-at-point)
                corfu-auto nil
                corfu-quit-no-match t)
    (hl-line-mode -1)
    (comint-read-input-ring t))

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

  (shell-dirtrack-mode 1)

  (add-to-list 'display-buffer-alist
               '("-shell\\*$" ;; matches title for `project-shell'
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'display-buffer-alist
               '("\\*shell[\\*\\:]"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (inhibit-same-window . t)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'display-buffer-alist
               '((major-mode . shell-command-mode)
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (inhibit-same-window . t)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none))))))

(use-package eshell
  :ensure nil
  :hook ((eshell-mode . completion-preview-mode)
         (eshell-mode . kam-eshell-mode-setup))
  ;; :bind
  ;; (:map eshell-mode-map
  ;;       ("<tab>" . completion-at-point)
  ;;       ("M-r" . consult-history)
  ;;       ("C-g" . eshell-interrupt-process)
  ;;       ("C-M-f" . eshell-forward-argument)
  ;;       ("C-M-b" . eshell-backward-argument))
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
  (defvar kam-eshell-prompt-regexp "\\[[[:punct:][:alnum:]]+ — [[:punct:][:alnum:]]+ \\$ "
    "Regular expression that matches the prompt used for Eshell buffers.
Used for setting Eshell's `outline-regexp'.")

  (defun kam-eshell-mode-setup ()
    (setenv "TERM" "xterm-256-color")
    (setq-local completion-styles '(basic partial-completion)
                completion-at-point-functions '(pcomplete-completions-at-point cape-file cape-history)
                eshell-prompt-regexp kam-eshell-prompt-regexp)
    (eshell-prompt-mode))

  (defun kam-eshell-input-filter (input)
    "Do not save the following:
- Empty lines
- Commands that start with a space, `cd', `ls', etc."
    (and
     (eshell-input-filter-default input)
     (eshell-input-filter-initial-space input)
     (not (string-prefix-p "cd " input))
     (not (string-prefix-p "cd" input))
     (not (string-prefix-p "ls " input))
     (not (string-prefix-p "ls" input))))

  (defun kam-eshell-redirect-to-buffer (buffer)
    "Auto create command for redirecting to buffer."
    (interactive (list (read-buffer "Redirect to buffer: ")))
    (insert (format " >>> #<%s>" buffer)))

  (defun kam-eshell--pwd-replace-home (pwd)
    "Replace $HOME in PWD with a tilde (~) character."
    (let* ((home (expand-file-name (getenv "HOME")))
           (home-len (length home)))
      (if (and
           (>= (length pwd) home-len)
           (equal home (substring pwd 0 home-len)))
          (concat "~" (substring pwd home-len))
        pwd)))

  (defun kam-eshell--pwd-shorten-dirs (pwd)
    "Shorten all directory names in PWD except the last two."
    (let ((p-lst (split-string pwd "/")))
      (if (> (length p-lst) 2)
          (concat
           (mapconcat
            (lambda (elm)
              (if (zerop (length elm)) ""
                (substring elm 0 1)))
            (butlast p-lst 2)
            "/")
           (mapconcat (lambda (elm) elm)
                      (last p-lst 2)
                      "/"))
        pwd)))

  (defun kam-eshell--split-directory-prompt (directory)
    (if (string-match-p ".*/.*" directory)
        (list (file-name-directory directory) (file-name-base directory))
      (list "" directory)))

  (setq eshell-prompt-function
        (lambda ()
          (let* ((pwd (eshell/pwd))
                 (directory (kam-eshell--split-directory-prompt
                             (kam-eshell--pwd-shorten-dirs
                              (kam-eshell--pwd-replace-home pwd))))
                 (parent (car directory))
                 (dir (cadr directory)))
            (standard-themes-with-colors
              (concat
               (propertize "[" 'face `(:foreground ,fg-main :background ,bg-main))
               (propertize (user-login-name) 'face `(:foreground ,fg-main :background ,bg-main))
               (propertize "@" 'face `(:foreground ,fg-main :background ,bg-main))
               (propertize (system-name) 'face `(:foreground ,pink :background ,bg-main))
               (propertize "]" 'face `(:foreground ,fg-main :background ,bg-main))
               (propertize " — " 'face `(:foreground ,fg-main :background ,bg-main))
               ;; (propertize parent 'face `(:foreground ,pink :weight bold))
               ;; (propertize dir 'face `(:foreground ,pink :weight bold))
               (propertize " $ " 'face `(:weight bold :background ,bg-main main)))))))

  (defun kam-eshell-next-prompt (n)
    "Move to the end of the Nth next prompt in the buffer. See `eshell-prompt-regexp'."
    (interactive "p")
    (re-search-forward eshell-prompt-regexp nil t n)
    (when eshell-highlight-prompt
      (while (not (get-text-property (line-beginning-position) 'read-only))
        (re-search-forward eshell-prompt-regexp nil t n)))
    (eshell-skip-prompt))

  (defun kam-shell-previous-prompt (n)
    "Move to the end of the Nth previous prompt in the buffer. See `eshell-prompt-regexp'."
    (interactive "p")
    (re-search-backward eshell-prompt-regexp))

  (add-to-list 'display-buffer-alist
               '("\\*eshell[\\*\\:]" ; matches title for reg eshell and `kam-eshell-here'
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (inhibit-same-window . t)
                 (window-height . 0.35)
                 (mode . eshell-mode)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list 'display-buffer-alist
               '("-eshell\\*$" ;; matches title for `project-eshell'
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none))))))

(use-package em-smart
  :ensure nil
  :config
  (setq eshell-where-to-jump 'after
        eshell-review-quick-commands nil
        eshell-smart-space-goes-to-end t))

(use-package eshell-syntax-highlighting
  :after (eshell)
  :hook (eshell-mode . eshell-syntax-highlighting-mode))

(defun kam-eshell--history-to-list ()
  "Returns the current Eshell buffer's history as a list of strings."
  (when (and (ring-p eshell-history-ring)
             (not (ring-empty-p eshell-history-ring)))
    (let (history)
      (dotimes (index (ring-length eshell-history-ring))
        (push (ring-ref eshell-history-ring index) history))
      (delete-dups history)
      (setq history (nreverse history))
      history)))

(defun kam-eshell--input-history-prompt ()
  "Prompt for completion against `kam-eshell-history-to-list'."
  (let* ((history (kam-eshell--history-to-list))
         (default (car history)))
    (completing-read
     (format-prompt "Insert input from history: " default)
     history
     nil
     nil
     nil
     nil
     default)))

(defun eshell/clear ()
  "Clear the Eshell buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)))

(defun eshell/z (&optional regexp)
  "Navigate to a previously visited directory in Eshell, or to any directory offered by `consult-dir'.
Optionally, use REGEXP to search for previous directories."
  (interactive)
  (let ((eshell-dirs (delete-dups
                      (mapcar 'abbreviate-file-name
                              (ring-elements eshell-last-dir-ring)))))
    (cond
     ((and (not regexp) (featurep 'consult-dir)
           (let* ((consult-dir--source-eshell `(:name "Eshell"
                                                      :narrow ?e
                                                      :category file
                                                      :face consult-file
                                                      :items ,eshell-dirs))
                  (consult-dir-sources (cons consult-dir--source-eshell
                                             consult-dir-sources)))
             (eshell/cd (substring-no-properties
                         (consult-dir--pick "Switch directory: ")))))
      (t (eshell/cd (if regexp (eshell-find-previous-directory regexp)
                      (completing-read "cd: " eshell-dirs))))))))

(defun kam-eshell-here ()
  "Opens up a new shell in the directory associated with the current buffers file.
The Eshell buffer is renamed to match that directory in order to make multiple Eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (name (car (last (split-string parent "/" t)))))
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))
    (insert (concat "ls"))
    (eshell-send-input)))

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

(defun kam-read-feature ()
  "Read a feature from the minibuffer."
  (interactive)
  (read-feature "Feature: "))

(defun kam-empty-buffer-p ()
  "Test whether the buffer is empty."
  (or (= (point-min) (point-max))
      (save-excursion
        (goto-char (point-min))
        (while (and (looking-at "^\\([a-zA-Z]+: ?\\)?$")
                    (zerop (forward-line 1))))
        (eobp))))

(defun kam-page-p ()
  "Return non-nil if there is a `page-delimiter' in the buffer."
  (or (save-excursion (re-search-forward page-delimiter nil t))
      (save-excursion (re-search-backward page-delimiter nil t))))

(defun kam-read-data (file)
  "Read Elisp data from FILE."
  (with-temp-buffer
    (insert-file-contents file)
    (read (current-buffer))))

(defun kam-shell-command-with-exit-code-and-output (command &rest args)
  "Runs COMMAND with ARGS.
Return the exit code and output in a list."
  (with-temp-buffer
    (list (apply 'call-process command nil (current-buffer) nil args)
          (buffer-string))))

(defun kam-async-shell-command-with-exit-code-and-output (command output-buffer error-buffer &rest args)
  "Runs COMMAND with ARGS asynchronously with standard output going to OUTPUT-BUFFER, and standard error going to ERROR-BUFFER.
Return the exit code and output in a list."
  (with-temp-buffer
    (list (async-shell-command (concat command " " args) output-buffer error-buffer)
          (buffer-string))))

(defun kam-sudo-shell-command (command &rest args)
  "Runs COMMAND with ARGS as root."
  (async-shell-command (concat "echo " (read-passwd "Password: ") " | sudo -S " command)))

(advice-add 'kam-sudo-shell-command :after 'kam-clear-echo-area)

(defun kam-execute-command-on-file-buffer (cmd)
  (interactive "sCommand to excute: ")
  (let* ((file-name (buffer-file-name))
         (full-cmd (concat cmd " " file-name)))
    (async-shell-command full-cmd)))

(defun kam-sudo ()
  "Find the current file or directory using SUDO."
  (interactive)
  (let ((destination (or buffer-file-name default-directory)))
    (if (string= (file-remote-p destination 'method) "sudo")
        (user-error "Already using `sudo'")
      (find-file (format "/sudo::/%s" destination)))))

(defun kam--duplicate-buffer-substring (boundaries)
  "Duplicate buffer substring between BOUNDARIES.
BOUNDARIES is a cons cell representing buffer positions."
  (unless (consp boundaries)
    (error "`%s' is not a cons cell" boundaries))
  (let ((beg (car boundaries))
        (end
         (cdr boundaries)))
    (goto-char end)
    (newline)
    (insert (buffer-substring-no-properties beg end))))

(defvar kam--line-regexp-alist
  '((empty . "[\s\t]*$")
    (indent . "^[[:blank:]]+")
    (non-empty . "^.+$")
    (list . "^\\([\s\t#*+]+\\|[0-9]+[^\s]?[).]+\\)")
    (heading . "^[=-\\*]+\\|[*]+"))
  "Alist of regexp types used by `kam-line-regexp-p'.")

(defun kam-line-regexp-p (type &optional n)
  "Test for TYPE on line.
TYPE is the car of a cons cell in `kam--line-regexp-alist'. It matches a regular expression.

With optional N, search in the Nth line from point."
  (save-excursion
    (goto-char (line-beginning-position))
    (and (not (bobp))
         (or (beginning-of-line n) t)
         (save-match-data
           (looking-at
            (alist-get type kam--line-regexp-alist))))))

(defun kam-line-empty-before-point-p ()
  "Return non-nil if there are only spaces or tabs before the point on the current line."
  (if (looking-back (alist-get 'indent kam--line-regexp-alist))
      t
    nil))

(defun kam-line-only-spaces-or-symbols-p ()
  "Return non-nil if there are only spaces or symbols before the point on the current line."
  (if (looking-back "^\([[:blank:]]\\|[[:punct:]])*")
      t
    nil))

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

(defun kam-parse-file-as-list (file)
  "Return the contents of FILE as a list of strings.
Strings are split at the newline characters then trimmed for negative space."
  (split-string
   (with-temp-buffer
     (insert-file-contents file)
     (buffer-substring-no-properties (point-min) (point-max)))
   "\n" :omit-nulls "[\s\f\t\n\r\v]+"))

(defun kam-ignore (&rest _)
  "Use this as a wrapper on a function to make it do nothing."
  nil)

(defun kam-call-function-quietly (orig-fun &rest _)
  "Don't print log messages while calling ORIG-FUN."
  (let ((inhibit-message t))
    (funcall orig-fun)))

(defun kam-crm-exclude-selected-p (input)
  "Filter out INPUT from `completing-read-multiple'.
Hide non-destructively the selected entries from completion table, avoiding the risk of entering the same match twice.

Use as the PREDICATE of `completing-read-multiple'."
  (if-let* ((pos (string-match-p crm-separator input))
            (rev-input (reverse input))
            (element (reverse
                      (substring rev-input 0
                                 (string-match-p crm-separator rev-input))))
            (flag t))
      (progn
        (while pos
          (if (string= (substring input 0 pos) element)
              (setq pos nil)
            (setq input (substring input (1+ pos))
                  pos (string-match-p crm-separator input)
                  flag (when pos t))))
        (not flag))
    t))

(defun kam-active-minor-modes ()
  "Return a list of active minor modes for the current buffer."
  (let ((active-modes))
    (mapc (lambda (m)
            (when (and (boundp m) (symbol-value m))
              (push m active-modes)))
          minor-mode-list)
    active-modes))

(defun kam-clear-echo-area (&rest _nil)
  "Clear the echo area.
Use this as advice :after a noisy function."
  (message ""))

(defun kam-first-char (str)
  "Return the first character from STR."
  (substring str 0 1))

(use-package standard-themes
  :hook (standard-themes-after-load-theme . kam-set-custom-faces)
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
  (setq standard-themes-headings '((1 . (variable-pitch 1.3))
                                  (2 . (variable-pitch 1.2))
                                  (3 . (variable-pitch 1.1))
                                  (t . (variable-pitch 1))))
  (setq standard-themes-common-palette-overrides '((fg-prompt cyan)
                                                   (bg-prompt unspecified)
                                                   (bg-prose-block-delimiter "#312f34")
                                                   (bg-prose-block-contents "#29272c")
                                                   (cursor "#f9d82b")
                                                   ;; (fg-completion-match-0 fg-main)
                                                   ;; (fg-completion-match-1 fg-main)
                                                   ;; (builtin fg-dim)
                                                   ;; (constant fg-main)
                                                   ;; (type fg-dim)
                                                   ;; (fnname fg-main)
                                                   ;; (fnname-call fg-main)
                                                   ;; (preprocessor fg-main)
                                                   ;; (variable fg-main)
                                                   ;; (variable-use fg-main)
                                                   (docstring string)))
  (defun kam-set-custom-faces ()
    "Function which sets faces across the configuration using the `standard-themes-with-colors' macro.
 Uses the colors set in `standard-themes-common-palette-overrides'."
    (standard-themes-with-colors
      (custom-set-faces
       ;; `(mode-line ((,c :background "#003c53" :foreground ,fg-main)))
       `(region ((,c :extend nil)))
       `(fringe ((,c :background ,bg-main))))))

  (defun kam-standard-themes-reload-theme ()
    "Reload the current Standard theme."
    (interactive)
    (standard-themes-load-theme (modus-themes-get-current-theme)))

  (standard-themes-load-theme 'standard-dark))

(use-package olivetti
  :hook (olivetti-mode . kam-olivetti-update-fringe-color)
  :custom
  (olivetti-style 'fancy)
  (olivetti-margin-width 5)
  ;; (olivetti-body-width .3)
  (olivetti-minimum-body-width 80)
  (olivetti-recall-visual-line-mode-entry-state t)
  :config
  (defun kam-olivetti-update-fringe-color ()
    "Update Olivetti mode's fringe color to the main background color."
    (standard-themes-with-colors
        (custom-set-faces
         `(olivetti-fringe ((,c :background ,bg-main)))))))

(use-package spacious-padding
  :after (standard-themes)
  :custom
  (spacious-padding-widths
   '(:internal-border-width 5
                            :header-line-width 10
                            :mode-line-width 10
                            :tab-width 6
                            :right-divider-width 20
                            :scroll-bar-width 8
                            :fringe-width 16))

  (spacious-padding-subtle-mode-line t)
  :config
  (setq spacious-padding-subtle-frame-lines
        '(:mode-line-active spacious-padding-line-active
                            :mode-line-inactive spacious-padding-line-inactive
                            :header-line-active spacious-padding-line-active
                            :header-line-inactive spacious-padding-line-inactive))

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
  :hook (text-mode . hl-line-mode)
  :custom
  (hl-line-sticky-flag nil)
  (global-hl-line-sticky-flag 'window)
  :config
  (with-eval-after-load 'standard-themes
    (standard-themes-with-colors
      (custom-set-faces
       `(hl-line ((,c :background ,bg-dim)))
       `(hl-line-nonselected ((,c :background ,bg-main)))))))

(use-package lin
  :custom
  (lin-face 'lin-yellow))

(use-package pulsar
  :hook ((next-error . pulsar-pulse-line)
         (consult-after-jump . pulsar-recenter-center)
         (consult-after-jump . pulsar-reveal-entry)
         (imenu-after-jump . pulsar-recenter-center)
         (imenu-after-jmup . pulsar-reveal-entry))
  :custom
  (pulsar-delay 0.055)
  (pulsar-iterations 10)
  (pulsar-face 'cursor)
  (pulsar-region-face 'pulsar-yellow)
  (pulsar-highlight-face 'pulsar-yellow)
  (pulsar-pulse-on-window-change nil)
  :config
  (advice-add 'flash-jump :after 'pulsar-recenter-center)
  (add-to-list 'pulsar-pulse-functions 'recenter)
  (advice-add 'isearch-forward :after 'pulsar-recenter-center)
  (advice-add 'isearch-backward :after 'pulsar-recenter-center)
  (pulsar-global-mode))

(use-package nerd-icons
  :custom
  (nerd-icons-font-family "SauceCodePro Nerd Font"))

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
                "  "
                kam-mode-line-major-mode
                kam-mode-line-compile
                "   "
                ;; kam-mode-line-buffer-stats-var
                "  "
                kam-mode-line-process
                " "
                mode-line-format-right-align
                kam-mode-line-vc-branch))

(dolist (construct '(kam-mode-line-kbd-macro
                     kam-mode-line-rectangle-mark
                     kam-mode-line-narrow
                     kam-mode-line-recursive-edit
                     kam-mode-line-buffer-modified
                     kam-mode-line-buffer-status
                     kam-mode-line-buffer-identification
                     kam-mode-line-major-mode
                     ;; kam-mode-line-buffer-stats-var
                     kam-mode-line-process
                     kam-mode-line-nix
                     kam-mode-line-logo
                     kam-mode-line-compile
                     kam-mode-line-vc-branch))
  (put construct 'risky-local-variable t))

(defun kam-consult-imenu--select (prompt)
  "Returns a selection from `consult-imenu'. using PROMPT."
  (let ((items (consult-imenu--items)))
    (consult-imenu--deduplicate items)
    (consult--read
     (or items (user-error "Imenu is empty"))
     :state
     (let* ((preview (consult--jump-preview)))
       `(lambda (action cand)
          (funcall ',preview action (and (markerp (cdr cand)) (cdr cand)))))
     :narrow
     (when-let* (narrow (consult-imenu--narrow))
       (list :predicate
             (lambda (cand)
               (eq (get-text-property 0 'consult-type (car cand))
                   consult--narrow))
             :keys narrow))
     :group (consult-imenu--group)
     :prompt prompt
     :require-match t
     :category 'imenu
     :history 'consult-imenu--history
     :add-history 'consult-imenu--history
     :lookup #'consult--lookup-cons
     :sort nil)))

(defmacro kam-consult-imenu--action (prompt &rest body)
  "Execute forms in BODY at the location of an `consult-imenu' selection."
  `(let ((item (kam-consult-imenu--select ',prompt)))
     (pcase item
       (`(,name ,pos ,fn . ,args)
        (push-mark nil t)
        (apply fn name pos args))
       (`(,_ . ,pos)
        (save-excursion
          (consult--jump pos)
          ,@body))
       (_ (error "Unknown Imenu item: %S" item)))))

(defmacro kam-consult-org-heading--action (&rest body)
  "Execute forms in BODY at the location of an `consult-org-heading' selection."
  `(let* ((headings (consult-org-heading)))
     ,@body))

(defun kam-consult-org-heading-link ()
  "Insert a link at point to the location of an Org heading using minibuffer completion."
  (interactive)
  (save-excursion
    (kam-consult-org-heading--action (org-store-link nil t)))
  (kam-org-insert-last-stored-link-with-prompt))

(defvar kam-consult--previous-point nil
  "Location of point before entering minibuffer.
Used to preselect nearest headings and Imenu items.")

(defun kam-consult--set-previous-point ()
  "Save location of point. Used before entering the minibuffer."
  (setq kam-consult--previous-point (point)))

(advice-add #'consult-org-heading :before #'kam-consult--set-previous-point)
(advice-add #'consult-outline :before #'kam-consult--set-previous-point)

;; (advice-add #'vertico--update :after #'kam-consult-vertico--update-choose)

(defun kam-consult-vertico--update-choose (&rest _)
  "Pick the nearest candidate rather than the first after updating candidates."
  (when (and kam-consult--previous-point
             (memq current-minibuffer-command
                   '(consult-org-heading consult-outline)))
    (setq vertico--index
          (max 0
               (1- (or (seq-position
                        vertico--candidates
                        kam-consult--previous-point
                        (lambda (cand point-pos)
                          (> (cl-case current-minibuffer-command
                               (consult-outline
                                (car (consult--get-location cand)))
                               (consult-org-heading
                                (get-text-property 0 'consult--candidate cand)))
                             point-pos)))
                       (length vertico--candidates))))))
  (setq kam-consult--previous-point nil))

(defcustom kam-consult-ripgrep-or-line-limit 300000
  "Buffer size threshold for `kam-consult-ripgrep-or-line'.
When the number of characters in a buffer exceeds this threshold,
`consult-ripgrep' will be used instead of `consult-line'."
  :type 'integer)

(defun kam-consult-ripgrep-or-line ()
  "Call `consult-line' for small buffers and `consult-ripgrep' for large files."
  (interactive)
  (if (or (not buffer-file-name)
          (buffer-narrowed-p)
          (ignore-errors
            (file-remote-p buffer-file-name))
          (jka-compr-get-compression-info buffer-file-name)
          (>= (buffer-size)
              (/ kam-consult-ripgrep-or-line-limit
                 (if (eq major-mode 'org-mode) 4 1))))
      (progn
        (let ((consult)))
        (consult-line)
        (setq this-command 'consult-line))
    (when (file-writable-p buffer-file-name)
      (save-buffer))
    (let ((consult-ripgrep-args
           (concat consult-ripgrep-args
                   " -g "
                   (shell-quote-argument (file-name-nondirectory buffer-file-name))
                   " ")))
      (consult-ripgrep))))

(defun kam-consult-line-symbol-at-point ()
  "Start a `consult-line' search with the symbol at point."
  (interactive)
  (consult-line (thing-at-point 'symbol)))

(defun kam-consult-isearch ()
  "Start a `consult-line' search within an Isearch session."
  (interactive)
  (consult-line isearch-string))

(defun kam-consult-ripgrep-symbol-at-point ()
  "Start a `consult-ripgrep' search with the symbol at point."
  (interactive)
  (let ((consult-ripgrep-command "rg --null --ignore-case --type txt --line-number . --color always --max-columns 500 --no-heading -e ARG OPTS"))
    (consult-ripgrep nil (thing-at-point 'symbol))))

(defun kam-consult-search-emacs-info-pages ()
  "Search through the Emacs info pages."
  (interactive)
  (consult-info "emacs" "efaq"))

(defun kam-consult-search-elisp-info-pages ()
  "Search through the Emacs Lisp pages."
  (interactive)
  (consult-info "elisp" "eintr"))

(defun kam-consult-search-org-info-pages ()
  "Search through the Org info pages."
  (interactive)
  (consult-info "org"))

(defun kam-consult-search-manual (manual)
  "Search through MANUAL, which is prompted for by `completing-read'."
  (interactive
   (list
    (progn
      (info-initialize)
      (completing-read "Manual name: "
                       (info--filter-manual-names
                        (info--manual-names current-prefix-arg))
                       nil t))))
  (consult-info manual))

;; (defun kam-consult-find-file-with-preview (prompt &optional dir default mustmatch initial pred)
;;   (interactive)
;;   (let ((default-directory (or dir default-directory))
;;         (minibuffer-completing-file-name t))
;;     (consult--read #'read-file-name-internal
;;                    :state (consult--file-preview)
;;                    :prompt prompt
;;                    :initial initial
;;                    :require-match mustmatch
;;                    :predicate pred)))

;; (setq read-file-name-function #'kam-consult-find-file-with-preview)

;; (setq project-read-file-name-function #'kam-consult-project-find-file-with-preview)

;; (defun kam-consult-project-find-file-with-preview (prompt all-files &optional pred hist _mb)
;;   (let ((prompt (if (and all-files
;;                          (file-name-absolute-p (car all-files)))
;;                     prompt
;;                   (concat prompt
;;                           (format " in %s"
;;                                   (consult--fast-abbreviate-file-name default-directory)))))
;;         (minibuffer-completing-file-name t))
;;     (consult--read (mapcar
;;                     (lambda (file)
;;                       (file-relative-name file))
;;                     all-files)
;;                    :state (consult--file-preview)
;;                    :prompt (concat prompt ": ")
;;                    :require-match t
;;                    :history hist
;;                    :category 'file
;;                    :predicate pred)))

(defun kam-menu ()
  "If the current buffer's major mode is Org mode, opens `consult-org-heading'. Otherwise opens `consult-imenu'."
  (interactive)
  (cond
   ((derived-mode-p 'org-mode)
    (progn
      (consult-org-heading)
      (setq this-command 'consult-org-heading)))
   ((derived-mode-p 'prog-mode)
    (progn
      (consult-imenu)
      (setq this-command 'consult-imenu)))
   ((derived-mode-p 'text-mode)
    (progn
      (consult-outline)
      (setq this-command 'consult-outline)))
   (t
    (progn
      (consult-imenu)
      (setq this-command 'consult-imenu)))))

(use-package text-mode
  :ensure nil
  :hook ((text-mode . visual-fill-column-mode)
         (text-mode . variable-pitch-mode)))

(use-package prog-mode
  :ensure nil
  :hook (prog-mode . kam-prog-mode-setup)
  :bind
  (:map prog-mode-map
        ("M-q" . upcase-dwim)
        ("RET" . newline))
  :config
  (defun kam-prog-mode-setup ()
    "Set up `prog-mode'."
    (setq-local buffer-face-mode-face 'fixed-pitch)
    (buffer-face-mode)
    (display-line-numbers-mode)
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
    (indent-tabs-mode -1))

  (defun kam-conf-mode-set-font ()
    "Intended to set the font in `conf-mode'."
    (setq buffer-face-mode-face 'fixed-pitch)
    (buffer-face-mode))

  (add-to-list 'auto-mode-alist
               '("\\pkgs_arch.txt\\'" . conf-mode)))

(use-package elisp-mode
  :ensure nil
  :custom
  (elisp-fontify-semantically t))

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
  ("C-c g" . magit-status)
  :custom
  (magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
  (magit-bury-buffer-function 'magit-restore-window-configuration)
  (magit-commit-show-diff t)
  (magit-format-file-function #'magit-format-file-nerd-icons)
  :config
  (magit-auto-revert-mode)

  (when (eq system-type 'darwin)
    (setq magit-git-executable "/opt/homebrew/bin/git"))

  (add-to-list 'consult-buffer-filter
               "magit-")

  (add-to-list 'switch-to-prev-buffer-skip-regexp
               "magit-")

  (add-to-list 'same-window-regexps "^magit: .*$")
  (add-to-list 'same-window-regexps "^magit-status: .*$"))

(use-package forge
  :after (magit))

(use-package dape
  :custom
  (dape-buffer-window-arrangement 'right)
  :config
  (dape-breakpoint-global-mode 1)

  (add-to-list 'dape-configs
               '(debug-c
                 modes (cc-mode c-ts-mode)
                 command-cwd dape-command-cwd
                 command "gdb"
                 command-args '("--interpreter=dap")
                 defer-launch-attach t
                 :request "launch"
                 :program "main.c"
                 :args []
                 :stopAtBeginningOfMainSubprogram nil)))

(use-package flycheck
  :hook (after-init . global-flycheck-mode)
  :config
  (with-eval-after-load 'consult
    (add-to-list 'consult-buffer-filter "\\*Flycheck error messages\\*" t)))

(use-package flycheck-eglot
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(use-package flyover
  :after (flycheck)
  :hook (flycheck-mode . flyover-mode)
  :custom
  (flyover-line-position-offset 0)
  (flyover-show-virtual-line nil)
  (flyover-display-mode 'hide-on-same-line))

;; (use-package flymake
;;   :ensure nil
;;   :hook (after-init . flymake-mode)
;;   :bind (:map prog-mode-map
;;               ("M-g M-p" . flymake-goto-prev-error)
;;               ("M-g M-n" . flymake-goto-next-error))
;;   :custom
;;   (flymake-show-diagnostics-at-end-of-line nil)
;;   (flymake-margin-indicators-string
;;    '((error "!»" compilation-error)
;;      (warning "»" compilation-warning)
;;      (note "»" compilation-info))))

(use-package eglot
  :bind (:map prog-mode-map
              ("M-g M-c" . eglot-code-actions)
              ("M-g M-r" . eglot-rename)
              ("M-g M-f" . eglot-format))
  :hook
  ((c-ts-mode . eglot-ensure)
   (python-ts-mode . eglot-ensure)
   (rust-ts-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  (eglot-events-buffer-config '(:size 0 :format full))
  (eglot-code-action-indications nil)
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (eglot-inlay-hints-mode -1)

  (add-to-list 'consult-buffer-filter
               "^\\*EGLOT " t))

(use-package xref
  :bind
  (("M-." . xref-find-definitions)
   :map xref--xref-buffer-mode-map
   ("w" . kam-xref-to-grep-compilation))
  :custom
  (xref-search-program 'ripgrep)
  :config
  (add-to-list 'xref-prompt-for-identifier 'xref-find-references t)
  (add-to-list 'display-buffer-alist '((category . xref-jump)
                                       (display-buffer-reuse-window
                                        display-buffer-use-some-window)
                                       (some-window . mru)))
  (defun kam-xref-to-grep-compilation ()
    "Export the current Xref results to a `grep-mode'-like buffer."
    (unless (derived-mode-p 'xref--xref-buffer-mode)
      (user-error "Not in an Xref buffer"))
    (let* ((items (and (boundp 'xref--fetcher)
                       (funcall xref--fetcher)))
           (buf-name "*xref: export to grep*")
           (grep-buf (get-buffer-create buf-name)))
      (unless items
        (user-error "No xref items found"))
      (with-current-buffer grep-buf
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format "-*- mode: grep; default-directory: %S -*-\n\n"
                          default-directory))
          (dolist (item items)
            (let* ((loc (xref-item-location item))
                   (file (xref-file-location-file loc))
                   (line (xref-file-location-line loc))
                   (summary (xref-item-summary item)))
              (insert (format "%s:%d:%s\n" file line summary)))))
        (grep-mode))
      (pop-to-buffer grep-buf))))

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
  :custom
  (display-line-numbers-type 'relative)
  (display-line-numbers-widen t)
  (display-line-numbers-width 4))

(use-package ediff
  :ensure nil
  :hook ((ediff-before-setup . kam-ediff-save-window-config)
         (ediff-quit . kam-ediff-restore-window-config))
  :init
  (setopt ediff-split-window-function 'split-window-horizontally
          ediff-window-setup-function 'ediff-setup-windows-plain)
  :custom
  (ediff-keep-variants nil)
  (ediff-make-buffers-readonly-at-startup nil)
  (ediff-show-clashes-only t)
  :config
  (defun kam-ediff-save-window-config ()
    "Save current window configuration to `ediff-previous-window-config'."
    (setq ediff-previous-window-config (current-window-configuration)))

  (defun kam-ediff-restore-window-config ()
    "Restore the saved window configuration in `ediff-previous-window-config'."
    (set-window-configuration ediff-previous-window-config)
    (when (get-buffer ediff-temp-buffer-a)
      (kill-buffer ediff-temp-buffer-a))
    (when (get-buffer ediff-temp-buffer-b)
      (kill-buffer ediff-temp-buffer-b))))

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
  (eldoc-idle-delay 0)
  (eldoc-echo-area-use-multiline-p nil)
  :config
  (add-to-list 'display-buffer-alist
               '("^\\*eldoc for"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none)))))

  (global-eldoc-mode))

(use-package treesit
  :ensure nil
  :custom
  (treesit-font-lock-level 4)
  (treesit-enabled-modes t)
  (treesit-auto-install-grammar t))

(use-package direnv
  :custom
  (direnv-always-show-summary nil)
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
  :bind (:map compilation-mode-map
              ("<f4>" . #'recompile)
              ("<escape>" . #'quit-window))
  :custom
  (compilation-always-kill t)
  (compilation-ask-about-save nil)
  (compilation-scroll-output t)
  (compilation-max-output-line-length nil)
  (compile-command "")
  :config
  (defadvice compile (before ad-compile-smart activate)
    "Advises `compile' so it sets the argument COMINT to t."
    (ad-set-arg 1 t))

  (add-to-list 'display-buffer-alist
               '("\\*compilation\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none)))))

  (add-to-list
   'switch-to-prev-buffer-skip-regexp
   "\\*compilation\\*"))
;; (advice-add #'compile :before (ad-set-argument 1 t))

(use-package whitespace
  :ensure nil
  :custom
  (whitespace-style
   '(face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark page-delimiters)))

(use-package x
  :ensure nil
  :custom
  (x-gtk-use-system-tooltips nil)
  (x-select-enable-clipboard t)
  (x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
  (x-underline-at-descent-line nil)
  (x-stretch-cursor t))

(use-package epa
  :ensure nil
  :custom
  (epa-gpg-program (executable-find "gpg2"))
  (epa-keys-select-method 'minibuffer)
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

(use-package elisp-mode
  :ensure nil
  :config
  (set-default-toplevel-value 'lexical-binding t))

(use-package c-ts-mode
  :ensure nil
  :hook (c-ts-mode . kam-c-ts-mode-setup)
  :config
  (defun kam-c-ts-mode-setup ()
    "Setup function for `c-ts-mode'."
    (c-toggle-comment-style -1)
    (setq c-ts-mode-indent-offset 4
          c-default-style '((java-mode . "java")
                            (awk-mode . "awk")
                            (other . "linux")))
    (text-scale-set 1))) ; Make the text a little bigger

(use-package python
  :defer t
  :custom
  (python-indent-guess-indent-offset-verbose nil))

(use-package rust-ts-mode
  :mode "\\.rs\\'"
  :defer t
  :custom
  (rust-mode-treesitter-derive t)
  (rust-indent-level 2)
  :config
  (add-to-list 'eglot-server-programs
               '((rust-ts-mode rust-mode) .
                 ("rust-analyzer" :initializationOptions (:check (:command "clippy"))))))

(use-package java-ts-mode
  :ensure nil
  :hook (java-ts-mode . eglot-ensure)
  :defer t
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
  :hook (json-ts-mode . (lambda ()
                          (setq indent-tabs-mode nil))))

(use-package toml-ts-mode
  :ensure nil
  :defer t
  :mode "\\.toml\\'"
  :config
  (add-to-list 'treesit-language-source-alist '(toml "https://github.com/ikatyang/tree-sitter-toml" "master" "src")))

(use-package markdown-ts-mode
  :ensure nil
  :defer t
  :mode "\\.md\\'"
  :custom
  (markdown-fontify-code-blocks-natively t)
  (markdown-fontify-whole-heading-line t)
  :config
  (add-to-list 'treesit-language-source-alist '(markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src"))
  (add-to-list 'treesit-language-source-alist '(markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src")))

(use-package yaml-ts-mode
  :ensure nil
  :defer t
  :mode "\\.ya?ml\\'"
  :config
  (add-to-list 'treesit-language-source-alist '(yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml" "master" "src")))

(use-package transient
  :ensure nil
  :custom
  (transient-history-file (expand-file-name "transient/history.el" kam-emacs-cache-directory))
  (transient-levels-file (expand-file-name "transient/levels.el" kam-emacs-cache-directory))
  (transient-values-file (expand-file-name "transient/values.el" kam-emacs-cache-directory)))

(use-package diff-hl
  :hook (magit-post-refresh . diff-hl-magit-post-refresh)
  :config
  (global-diff-hl-mode))

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

(use-package emms
  :bind
  ("C-c m m" . emms-browser)
  ("C-c m s" . kam-emms-play-pause)
  ("C-c m n" . emms-next-no-error)
  ("C-c m p" . emms-previous)
  ("C-c m e" . emms)
  :custom
  (emms-source-file-default-directory "~/Music/")
  (emms-playlist-buffer-name "*Playlist*")
  :config
  (emms-all)
  (defvar kam-music-library-directory "~/Music/"
    "Default location where music is stored.")

  (setq emms-cache-file (expand-file-name "emms/cache" kam-emacs-cache-directory))
  (setq emms-history-file (expand-file-name "emms/history" kam-emacs-cache-directory))
  (setq emms-score-file (expand-file-name "emms/scores" kam-emacs-cache-directory))

  (setq emms-player-vlc-player (executable-find "vlc")
        emms-info-functions '(emms-info-native))
  (add-to-list 'emms-player-list 'emms-player-vlc)

  (defun kam-emms-add-track-to-playlist (buffer)
    (interactive
     (list (let* ((buf-list (mapcar #'(lambda (buf)
                                        (list (buffer-name buf)))
                                    (emms-playlist-buffer-list)))
                  (sorted-buf-list (sort buf-list
                                         #'(lambda (lbuf rbuf)
                                             (< (length (car lbuf))
                                                (length (car rbuf)))))))
             (emms-completing-read "Playlist buffer to add track: "
                                   sorted-buf-list nil t))))
    (let ((previous-buffer emms-playlist-buffer)
          (previous-selection (overlay-start emms-playlist-mode-selected-overlay)))
      (emms-playlist-ensure-playlist-buffer)
      (emms-playlist-set-playlist-buffer buffer)
      (emms-playlist-mode-add-contents)
      (emms-playlist-set-playlist-buffer previous-buffer)
      (emms-playlist-select previous-selection)))

  (defun kam-emms-insert-track-to-playlist ()
    "Add the current track at point to the playlist set in `kam-emms-insert-track-to-playlist-destination'.
When a prefix is used, ask where to insert the track and place it there."
    (interactive)
    (let* ((name (emms-track-get (emms-playlist-track-at) 'name))
           (prev-playlist emms-playlist-buffer)
           (dest-playlist (if (not current-prefix-arg)
                              kam-emms-insert-track-to-playlist-destination
                            (completing-read
                             "Insert track in: "
                             (mapcar #'buffer-name emms-playlist-buffers) nil t))))
      (unless (eq kam-emms-insert-track-to-playlist-destination dest-playlist)
        (setq kam-emms-insert-track-to-playlist-destination dest-playlist))
      (emms-playlist-set-playlist-buffer dest-playlist)
      (emms-insert-file name)
      (emms-playlist-set-playlist-buffer prev-playlist)
      (message "Added to: %s" dest-playlist)))

  (defun kam-emms-play-pause ()
    "If music from EMMS is playing, pause it.
Otherwise, play."
    (interactive)
    (if emms-player-playing-p
        (emms-pause)
      (emms-start)))

  (defvar-keymap kam-music-map
    :repeat t
    :doc "Repeat map for music"
    "p" 'emms-previous
    "n" 'emms-next))

(use-package emms-browser
  :ensure nil
  :after (emms)
  :hook ((emms-browser-mode . hide-cursor-mode)
         (emms-browser-mode . lin-mode))
  :custom
  (emms-browser-buffer-name "*Music*")
  :config
  (emms-browser-make-filter "All" 'ignore)
  (emms-browser-make-filter "Library" (emms-browser-filter-only-dir kam-music-library-directory))
  ;; (emms-browser-set-filter (assoc "Library" 'emms-browser-filters))

  (add-to-list 'display-buffer-alist
               `((derived-mode . emms-browser-mode)
                 (display-buffer-in-side-window)
                 (mode emms-browser-mode)
                 (side . right)
                 (window-width . 0.3)
                 (window-parameters . ((mode-line-format . none))))))

(use-package emms-playlist-mode
  :ensure nil
  :after (emms)
  :hook ((emms-playlist-mode . hide-cursor-mode)
         (emms-playlist-mode . lin-mode))
  :custom
  (emms-playlist-mode-open-playlists t)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Playlist\\*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none))))))

(defvar kam-custom-lisp-files
  `(,(concat (getenv "HOME") "/.config/emacs/lisp/mode-line.el")
    ,(concat (getenv "HOME") "/.config/emacs/lisp/ytdlp.el")
    ,(concat (getenv "HOME") "/.config/emacs/lisp/writing-mode.el")
    ,(concat (getenv "HOME") "/.config/emacs/lisp/hide-cursor-mode.el")
    ,(concat (getenv "HOME") "/.config/emacs/lisp/os.el"))
  "List of strings detailing custom Lisp to be loaded.
Each string should be a full path to a Lisp file.")

(mapc (lambda (file)
        (when (file-exists-p file)
          (load-file file)))
      kam-custom-lisp-files)
