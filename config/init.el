;; (mapcar
;;  (lambda (string)
;;    (add-to-list 'load-path (locate-user-emacs-file string)))
;;  '("lisp"))

;; (defvar elpaca-installer-version 0.9)
;; (defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
;; (defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
;; (defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
;; (defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
;;                               :ref nil
;;                               :files (:defaults (:exclude "extensions"))
;;                               :build (:not elpaca--activate-package)))
;; (let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
;;        (build (expand-file-name "elpaca/" elpaca-builds-directory))
;;        (order (cdr elpaca-order))
;;        (default-directory repo))
;;   (add-to-list 'load-path (if (file-exists-p build) build repo))
;;   (unless (file-exists-p repo)
;;     (make-directory repo t)
;;     (when (< emacs-major-version 28) (require 'subr-x))
;;     (condition-case-unless-debug err
;;         (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
;;                  ((zerop (call-process "git" nil buffer t "clone"
;;                                        (plist-get order :repo) repo)))
;;                  ((zerop (call-process "git" nil buffer t "checkout"
;;                                        (or (plist-get order :ref) "--"))))
;;                  (emacs (concat invocation-directory invocation-name))
;;                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
;;                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
;;                  ((require 'elpaca))
;;                  ((elpaca-generate-autoloads "elpaca" repo)))
;;             (progn (message "%s" (buffer-string)) (kill-buffer buffer))
;;           (error "%s" (with-current-buffer buffer (buffer-string))))
;;       ((error) (warn "%s" err) (delete-directory repo 'recursive))))
;;   (unless (require 'elpaca-autoloads nil t)
;;     (require 'elpaca)
;;     (elpaca-generate-autoloads "elpaca" repo)
;;     (load "./elpaca-autoloads")))
;; (add-hook 'after-init-hook #'elpaca-process-queues)
;; (elpaca `(,@elpaca-order))
;; (elpaca-wait)

;; (elpaca elpaca-use-package
;;     (elpaca-use-package-mode))
(setq use-package-always-ensure t
      use-package-compute-statistics t)

(setq package-archives
      '(("gnu-elpa" . "https://elpa.gnu.org/packages/")
        ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

(setq package-archive-priorities
      '(("gnu-elpa" . 3)
        ("melpa" . 1)
        ("nongnu" . 2)))

(setq package-vc-register-as-project nil)

(setq font-log nil
      package-install-upgrade-built-in t)



(setq-default eval-expression-print-length nil
              scroll-error-top-bottom t
              echo-keystrokes-help nil
              next-error-recenter '(4)
	          line-spacing 0.4
              cursor-type 'box
              cursor-in-non-selected-windows nil
              make-cursor-line-fully-visible t
	          fill-column 80
	          tab-width 4
	          indent-tabs-mode nil
              next-line-add-newlines t
              line-move-visual t
              sentence-end-double-space nil
              kill-do-not-save-duplicates t
              text-scale-remap-header-line t
              display-buffer-base-action '((display-buffer-reuse-window display-buffer-same-window)
                                           (reusable-frames . t))
              even-window-sizes nil)

(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors 'silent
        native-comp-prune-cache t))

(use-package emacs
  :ensure nil
  :bind
  ("<f3>" . #'project-recompile)
  ("<f4>" . #'project-compile)
  ("<f7>" . #'kam-switch-to-alternate-buffer)
  ("<escape>" . #'kam-keyboard-quit-dwim)
  ("<home>" . nil)
  ("<end>" . nil)
  ("<up>" . nil)
  ("<down>" . nil)
  ("<left>" . nil)
  ("<right>" . nil)
  ([remap keyboard-quit] . #'kam-keyboard-quit-dwim)
  ([remap yank] . #'kam-yank)
  ("C-g" . #'kam-keyboard-quit-dwim)
  ([kam-i] . #'kam-split-window-right)
  ("C-j" . #'kam-join-line-dwim)
  ("C-k" . #'kill-line)
  ([kam-m] . back-to-indentation)
  ("C-v" . #'set-mark-command)
  ("C-w" . #'kam-cut-dwim)
  ("C-t" . #'kam-transpose-char)
  ("C-q" . #'fill-paragraph)
  ("C-z" . #'kam-kill-ring-save-dwim)
  ("C-SPC" . #'kam-jump-to-mark)
  ("C-<return>" . #'kam-insert-new-line-below)
  ("C-DEL" . #'kam-control-backspace)
  ("C-<next>" . #'scroll-other-window)
  ("C-<prior>" . #'scroll-other-window-down)
  ("C-," . #'scroll-up)
  ("M-," . #'scroll-down)
  ("C-&" . nil)
  ("C-=" . #'indent-region)
  ("C-^" . nil)
  ("C-$" . #'jinx-correct-nearest)
  ("C-/" . #'kam-prev-buffer)
  ("C-@" . nil)
  ("C-_" . nil)
  ("C-:" . #'pp-eval-expression)
  ("C-!" . #'shell-command)
  ("C-?" . #'undo)
  ("C-+" . #'delete-window)
  ("C-|" . nil)
  ("C-`" . nil)
  ("C-(" . insert-parentheses)
  ("C-)" . nil)
  ("C-~" . nil)
  ("C-<" . nil)
  ("C->" . nil)
  ("M-c" . capitalize-dwim)
  ("M-j" . kam-open-line)
  ("M-i" . #'kam-split-window-below)
  ("M-l" . downcase-dwim)
  ("M-m" . kam-mark-line)
  ("M-n" . forward-paragraph)
  ("M-p" . backward-paragraph)
  ("M-q" . upcase-dwim)
  ("M-t" . kam-transpose-words)
  ("M-u" . universal-argument)
  ("M-v" . mark-word)
  ("M-w" . #'kam-cut-dwim)
  ("M-z" . #'kam-kill-ring-save-dwim)
  ("M-!" . async-shell-command)
  ("M-?" . #'undo-redo)
  ("M-;" . #'kam-comment-dwim)
  ("M-:" . #'pp-eval-expression)
  ("M-@" . nil)
  ("M-/" . #'kam-next-buffer)
  ("M-*" . nil)
  ("M-_" . nil)
  ("M-+" . #'delete-other-windows)
  ("M-#" . nil)
  ("M-SPC" . #'kam-push-mark-no-activate)
  ("M-<return>" . #'kam-insert-new-line-above)
  ("M-DEL" . #'backward-kill-sentence)
  ("C-h c" . #'describe-char)
  ("C-h r" . #'info-display-manual)
  ("C-h s" . #'kam-consult-search-emacs-info-pages)
  ("C-h F" . #'apropos-function)
  ("C-h R" . #'info-emacs-manual)
  ("C-h V" . #'apropos-variable)
  ("C-x 1" . nil)
  ("C-x 2" . nil)
  ("C-x 3" . nil)
  ("C-x b" . #'kam-switch-to-buffer-dwim)
  ("C-x f" . #'find-file)
  ("C-x n" . kam-narrow-or-widen-dwim)
  ("C-x o" . kam-ace-window-prefix)
  ("C-x u" . nil)
  ("C-x C-d" . dired)
  ("C-x C-n" . nil)
  ("C-x C-e" . kam-eval-current-sexp)
  ("C-x C-v" . mark-paragraph)
  ("C-x C-k" . kam-kill-current-buffer)
  ("C-x C-u" . nil)
  ("C-x C-z" . nil)
  ("C-M-:" . kam-comment-dwim)
  ("C-M-(" . insert-parenthesis)
  ("C-M-/" . kam-switch-to-alternate-buffer)
  ("C-M-=" . indent-region)
  ("C-M-b" . sp-backward-sexp)
  ("C-M-d" . sp-down-sexp)
  ("C-M-f" . sp-forward-sexp)
  ("C-M-k" . sp-kill-sexp)
  ;; ("M-[kam-m]" . kam-mark-point-to-end-of-line)
  ("C-M-q". kam-kill-inner-sexp)
  ("C-M-u" . sp-backward-up-sexp)
  ("C-M-v" . sp-mark-sexp)
  ("C-M-y" . kam-duplicate-line-or-region)
  ("C-M-DEL" . sp-backward-kill-sexp)
  ([remap list-buffers] . ibuffer)
  ([remap exchange-point-and-mark] . #'kam-exchange-point-and-mark-no-activate)
  (:map search-map
	    ("M-c" . #'goto-char)
	    ("M-f" . #'consult-fd)
	    ("M-g" . #'consult-ripgrep)
        ("M-i" . #'consult-imenu)
	    ("M-k" . #'consult-mark)
	    ("M-l" . #'consult-line)
	    ("M-o" . #'kam-menu)
	    ("M-p" . #'kam-consult-line-symbol-at-point))
  (:map prog-mode-map
	    ("C-M-q" . #'kam-kill-inner-sexp))
  (:map emacs-lisp-mode-map
        ("C-M-q" . #'kam-kill-inner-sexp))
;  (:map comint-mode-map
;       ("C-c C-l" . #'kam-consult-comint-history)
;       ("C-." . #'kam-comint-insert-arguments-from-command))
  :custom
  ;; (inhibit-splash-screen nil)
  (make-backup-files nil)
  (backup-inhibited t)
  (create-lockfiles nil)
  (confirm-kill-emacs nil)
  (confirm-kill-processes nil)
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (blink-cursor-mode -1)

  (setq auto-save-file-name-transforms
        `((".*" , (concat user-emacs-directory "auto-save-list/") t)))

  (setq kill-buffer-delete-auto-save-files t)
  (setq confirm-kill-emacs nil)
  (setq confirm-kill-processes nil)
  (setq confirm-non-existent-file-or-buffer nil)
  (setq use-short-answers t)
  (setq kill-buffer-query-functions
        (remq 'process-kill-buffer-query-function
              kill-buffer-query-functions))
  (setq initial-scratch-message "")
  (setq delete-by-moving-to-trash t)
  (setq custom-file (make-temp-file "emacs-custom-"))
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  (setq next-screen-context-lines 20)
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))

  (defun kam-minibuffer-setup-hook ()
    "Function for settings as the minibuffer starts."
    (setq gc-cons-threshold most-positive-fixnum
          truncate-lines nil)
    (setq-local fill-column 200))

  (defun kam-minibuffer-exit-hook ()
    "Function for settings as the minibuffer exits."
    (setq gc-cons-threshold (* 1000 1000 8)))

  (keymap-global-set "<f6>" 'avy-goto-char-timer)
  (keymap-global-set "C-M-(" 'insert-parentheses)
  (keymap-global-set "C-\"" 'kam-insert-quote)

  (setq resize-mini-windows t
        resize-mini-frames t)

  (setq enable-recursive-minibuffers t
        completion-cycle-threshold 1
        completions-detailed t
        tab-always-indent 'complete
        completion-auto-help 'lazy
        completions-max-height 20
        completions-format 'one-column
        completions-group t
        completion-auto-select 'second-tab
        completion-ignore-case t
        read-file-name-completion-ignore-case t)

  (setq display-line-numbers-type 'relative
        display-line-numbers-width 3)

  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))

  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  (add-hook 'minibuffer-setup-hook #'kam-minibuffer-setup-hook)
  (add-hook 'minibuffer-exit-hook #'kam-minibuffer-exit-hook))

(use-package dired
  :ensure nil
  :hook (dired-mode . dired-hide-details-mode)
  :bind
  (:map dired-mode-map
        ("<mouse-2>" . #'dired-mouse-find-file)
        ("C-o" . #'ace-window)
        ("f" . #'find-name-dired)
        ("o" . #'dired-do-open)
	    ([kam-i] . #'kam-split-window-right))
  :config
  (setq dired-listing-switches "-AGFhlv --group-directories-first --time-style=long-iso")
  (setq dired-clean-confirm-killing-deleted-buffers nil
        dired-confirm-shell-command nil
        dired-no-confirm t
        dired-deletion-confirmer '(lambda (x) t))
  (setq dired-recursive-deletes 'always
	    dired-recursive-copies 'always
        dired-kill-when-opening-new-dired-buffer t
        dired-dwim-target t
        dired-auto-revert-buffer #'dired-directory-changed-p
        dired-make-directory-clickable t
        dired-free-space nil
        dired-mouse-drag-files t)
  (setq dired-guess-shell-alist-user
        '(("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mpv" "xdg-open")
          ("\\.\\(png\\|jpe?g\\|tiff\\)" "feh" "xdg-open")
          (".*" "xdg-open"))))

(use-package dired-open
  :ensure t)

(use-package dired-rainbow
  :ensure t)

(defvar kam-automount-directory (format "/run/media/%s" user-login-name)
  "Directory under which drives are automounted.")

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

(use-package dired-x
  :ensure nil
  :after dired
  :config
  (setq dired-clean-up-buffers-too t
        dired-clean-confirm-killing-deleted-buffers nil))

(use-package dired-aux
  :ensure nil
  :after dired
  :config
  (setq dired-isearch-filenames 'dwim
        dired-create-destination-dirs 'always
        dired-do-revert-buffer (lambda (dir) (not (file-remote-p dir)))
        dired-create-destination-dirs-on-trailing-dirsep t))

(use-package wdired
  :ensure nil
  :bind
  (:map dired-mode-map
        ("w" . wdired-change-to-wdired-mode))
  :config
  (setq wdired-allow-to-change-permissions t
        wdired-create-parent-directories t))

(use-package dired-subtree
  :ensure t
  :after (dired)
  :bind
  (:map dired-mode-map
        ("<tab>" . dired-subtree-toggle)
        ("TAB" . dired-subtree-toggle)
        ("C-<tab>" . kam-dired-subtree-up-toggle))
  :config
  (defun kam-dired-subtree-up-toggle ()
    "Goes to the parent subtree and toggles the visiblity of it."
    (interactive)
    (dired-subtree-up)
    (dired-subtree-toggle)))

(use-package image-dired
  :ensure nil
  :commands (image-dired)
  :bind
  (:map image-dired-thumbnail-mode-map
        ("<return>" . image-dired-thumbnail-display-external))
  :config
  (setq image-dired-thumbnail-storage 'standard
        image-dired-thumbnail-external-viewer "xdg-open"
        image-dired-thumb-size 80
        image-dired-thumb-margin 2
        image-dired-thumb-relief 0
        image-dired-thumbs-per-row 4))

(use-package ready-player
  :ensure t
  :mode
  ("\\.\\(mp3\\|m4a\\|mp4\\mkv\\|webm\\)\\'" . ready-player-major-mode)
  :config
  (setq ready-player-auto-play nil
        ready-player-repeat nil))

(use-package trashed
  :ensure t
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p
        trashed-use-header-line t
        trashed-sort-key '("Date deleted" . t)))

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
  (dired (getenv "HOME")))



(use-package repeat
  :ensure nil
  :hook (after-init . repeat-mode)
  :config
  (setq repeat-on-final-keystroke t
        repeat-exit-timeout 5
        repeat-exit-key "<escape>"
        repeat-keep-prefix nil
        repeat-check-key t
        repeat-echo-function 'ignore
        set-mark-command-repeat-pop t))

(defun kam-make-repeat-map (keymap)
  "Add `repeat-mode' support to KEYMAP."
  (map-keymap
   (lambda (_key cmd)
     (when (symbolp cmd)
       (put cmd 'repeat-map keymap)))
   (symbol-value keymap)))

(use-package bookmark
  :ensure nil
  :commands (bookmark-set bookmark-jump bookmark-bmenu-list)
  :hook (bookmark-bmenu-mode . hl-line-mode)
  :bind
  ("C-c t" . consult-bookmark)
  :config
  (setq bookmark-use-annotations nil
        bookmark-automatically-show-annotations nil
        bookmark-fringe-mark nil
        bookmark-save-flag 1))

(use-package register
  :ensure nil
  :defer t
  :config
  (setq register-preview-delay 0.8
        register-preview-function #'register-preview-default)

  (with-eval-after-load 'savehist
    (add-to-list 'savehist-additional-variables 'register-alist)))

(use-package imenu
  :ensure nil
  :bind
  (([remap imenu] . consult-imenu))
  :config
  (setq org-imenu-depth 4))

(defun kam-docview-forward-paragraph ()
  "Move point forward paragraph such that the first line is highlighted.

This function is intended to be used with `hl-line-mode'."
  (interactive)
  (forward-paragraph)
  (forward-line))

(defun kam-docview-backward-paragraph ()
  "Move point backward paragraph such that the first line is highlighted.

This function is intended to be used with `hl-line-mode'."
  (interactive)
  (backward-paragraph 2)
  (forward-line))

(use-package help
  :ensure nil
  :hook (help-mode . lin-mode)
  :bind (:map help-mode-map
	          ("q" . #'kam-common-quit-window)
	          ("p" . 'kam-docview-backward-paragraph)
	          ("n" . 'kam-docview-forward-paragraph)
	          ("j" . 'forward-button)
	          ("k" . 'backward-button)
	          ("<mouse-9>" . 'help-go-back)
	          ("<next>" . scroll-down-line)
	          ("C-," . scroll-up)
	          ("M-," . scroll-down)
	          ("<prior>" . scroll-up-line)))

(use-package info
  :ensure nil
  :hook (Info-mode . lin-mode)
  :bind (:map Info-mode-map
	          ("M-[" . 'Info-history-back)
	          ("<mouse-9>" . #'Info-history-back)
	          ("M-]" . 'Info-history-forward)
	          ("C-," . scroll-up)
	          ("M-," . scroll-down)
	          ("p" . 'kam-docview-backward-paragraph)
	          ("P" . 'Info-prev)
	          ("n" . 'kam-docview-forward-paragraph)
	          ("N" . 'Info-next)
	          ("j" . 'Info-next-reference)
	          ("k" . 'Info-prev-reference)
	          ("<next>" . scroll-down-line)
	          ("<prior>" . scroll-up-line)))

(use-package man
  :ensure nil
  :bind (:map Man-mode-map
	          ("p" . #'kam-docview-backward-paragraph)
	          ("n" . #'kam-docview-forward-paragraph))
  :config
  (setq Man-notify-method 'pushy))

;;(use-package occur
;; :ensure nil)
(setq list-matching-lines-default-context-lines 2)

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

(define-key occur-mode-map (kbd "w") 'occur-edit-mode)

(use-package re-builder
  :ensure nil
  :bind
  (:map reb-mode-map
        ("RET" . #'kam-re-builder-replace-regexp)
        ("<escape>" . #'reb-quit)
        :map reb-lisp-mode-map
        ("RET" . #'kam-re-builder-replace-regexp)
        ("<esc>" . #'reb-quit))
  :config
  
  (defvar kam-re-builder-positions nil
    "Store point and region bounds before calling re-builder")
  
  (advice-add 're-builder
              :before
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
                                       (region-active-p)) " in region" ""))
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
  :config
  (setq tramp-encoding-shell (executable-find "sh")
        sh-shell-file (executable-find "sh")
        shell-file-name (executable-find "sh")
	    tramp-default-remote-shell (executable-find "sh"))
  
  (add-to-list 'tramp-connection-properties
               (list (regexp-quote "/sudo::")
                     "login-program" (executable-find "env")))
  
  (add-to-list 'tramp-connection-properties
               (list (regexp-quote "/sudo::")
                     "remote-shell" (executable-find "env"))))

(defun kam-find-file-auto-create-missing-dirs ()
  (let ((target-dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))))

(add-to-list 'find-file-not-found-functions #'kam-find-file-auto-create-missing-dirs)

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :config
  (setq recentf-max-saved-items 100))

(use-package ispell
  :ensure nil
  :custom
  (ispell-program-name (executable-find "aspell")))

(use-package jinx
  :init
  (setenv "ASPELL_CONF" "dict-dir /nix/store/361h5gykf4ycq622dn52z4bfhqbfrxdp-aspell-env/lib/aspell")
  :custom
  (jinx-languages "en")
  :ensure nil)

;; (use-package ultra-scroll
;;   :ensure t
;;   :vc (:url "https://github.com/jdtsmith/ultra-scroll"
;;             :branch "main")
;;   :bind
;;   (("<wheel-up>" . ultra-scroll-up)
;;    ("<wheel-down>" . ultra-scroll-down))
;;   :init
;;   (setq-default scroll-conservatively 4
;;                 scroll-margin 0)
;;   :config
;;   (ultra-scroll-mode 1))

(use-package keyfreq
  :ensure t
  :config
  (keyfreq-mode))

(use-package autorevert
  :ensure nil
  :hook (after-init . global-auto-revert-mode)
  :config
  (setq auto-revert-verbose nil
        global-auto-revert-non-file-buffers t))

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :config
  (setq history-length 100
        history-delete-duplicates t
        savehist-save-minibuffer-history t
        savehist-file (locate-user-emacs-file "savehist"))
  (add-to-list 'savehist-additional-variables 'kill-ring))

(tooltip-mode -1)
(setq x-gtk-use-system-tooltips nil
      tooltip-reuse-hidden-frame t
      tooltip-use-echo-area t)

(use-package proced
  :ensure nil
  ;;   :commands (proced)
  :hook (proced-mode . #'kam-proced-settings)
  :config
  (setq proced-auto-update-flag 'visible
        proced-enable-color-flag t
        proced-auto-update-interval 1
        proced-descend t
        proced-filter 'user)
  
  (defun kam-proced-settings ()
    (proced-toggle-auto-update 1)))

(setq save-interprogram-paste-before-kill t
      mouse-drag-and-drop-region-cross-program t
      mouse-drag-and-drop-region-scroll-margin t)

(global-so-long-mode 1)

(setq x-select-enable-clipboard t
      x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(when (eq system-type 'gnu/linux)
  (setq x-super-keysym 'meta
        x-meta-keysym 'alt))

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (with-selected-frame frame
                  (kam-set-font-faces)
                  (kam-set-custom-faces)
                  (load-theme 'modus-vivendi :no-confirm))))
  (load-theme 'modus-vivendi :no-confirm)
  (add-hook 'after-init-hook #'kam-set-custom-faces)
  (add-hook 'after-init-hook #'kam-set-font-faces))

(when (eq system-type 'darwin)
  (setq mac-option-key-is-meta nil
        mac-command-key-is-meta t
        mac-control-modifier 'control
        mac-command-modifier 'meta
        mac-option-modifier 'hyper))

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode)
  :bind
  (:map vertico-map
	    ("<f1>" . #'embark-act)
	    ("<f2>" . #'consult-dir)
        ("<escape>" . #'kam-keyboard-quit-dwim)
        ("C-," . vertico-scroll-up)
        ("M-," . vertico-scroll-down)
        ("M-<return>" . vertico-exit-input)
        ("<up>" . nil)
        ("<down>" . nil)
        ("C-<return>" . #'minibuffer-force-complete-and-exit)
        ("C-g" . nil))
  :config
  (setq vertico-resize t
        vertico-cycle t
        vertico-scroll-margin 0))

(use-package vertico-quick
  :after vertico
  :ensure nil
  :bind
  (:map vertico-map
	    ("<f6>" . #'vertico-quick-exit))
  :config
  (setq vertico-quick1 "dnreta"
        vertico-quick2 "columq"))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :hook (rfn-eshadow-update-overlay . #'vertico-directory-tidy)
  :bind
  (:map vertico-map
        ("<backspace>" . vertico-directory-delete-char)
        ("C-<backspace>" . vertico-directory-delete-word)))

(use-package vertico-multiform
  :ensure nil
  :after vertico-posframe
  :hook (after-init . vertico-multiform-mode)
  :init
  (defvar kam-vertico-multiform-maximal
    '((vertico-count . 10)
      (vertico-preselect . no-prompt)
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
          (jinx ,@kam-vertico-multiform-maximal)
          (unicode-name ,@kam-vertico-multiform-maximal)
          (multi-category ,@kam-vertico-multiform-maximal)
          (file ,@kam-vertico-posframe-maximal)))
        
  (setq vertico-multiform-commands
        `(("consult-\\(.*\\)?\\(find\\|grep\\|ripgrep\\|fd\\)" buffer)
          (execute-extended-command ,@kam-vertico-posframe-maximal)
          (describe-variable ,@kam-vertico-posframe-maximal)
          (describe-function ,@kam-vertico-posframe-maximal)
          (find-file ,@kam-vertico-posframe-maximal)
          (consult-dir ,@kam-vertico-posframe-maximal)
          (project-switch-project ,@kam-vertico-posframe-maximal)
          (kam-menu ,@kam-vertico-posframe-maximal)
          (dired-do-rename ,@kam-vertico-posframe-maximal)
          (dired-do-copy ,@kam-vertico-posframe-maximal)
          (dired-create-directory ,@kam-vertico-posframe-maximal)
          (find-name-dired ,@kam-vertico-posframe-maximal)
          (jinx-correct-nearest grid (vertico-grid-annotate . 20))))
  (vertico-multiform-mode 1))

(use-package vertico-sort
  :ensure nil
  :after vertico)

(use-package vertico-posframe
  :ensure t
  :vc (:url "https://github.com/tumashu/vertico-posframe"
            :branch "main")
  :after vertico
  :init
  (defvar kam-vertico-posframe-maximal
    '(posframe
      (vertico-posframe-poshandler . posframe-poshandler-frame-center)
      (vertico-posframe-border-width . 2)))

  ;; (add-to-list 'vertico-multiform-commands `(execute-extended-command ,@kam-vertico-posframe-maximal))
  ;; (add-to-list 'vertico-multiform-commands `(describe-function ,@kam-vertico-posframe-maximal))
  ;; (add-to-list 'vertico-multiform-commands `(describe-variable ,@kam-vertico-posframe-maximal))
  ;; (add-to-list 'vertico-multiform-commands `(find-file ,@kam-vertico-posframe-maximal))
  ;; (add-to-list 'vertico-multiform-commands `(consult-dir ,@kam-vertico-posframe-maximal))
  ;; (add-to-list 'vertico-multiform-commands `(project-switch-project ,@kam-vertico-posframe-maximal))
  )

(use-package consult
  :ensure t
  :demand t
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format
        xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  (advice-add #'register-preview :override #'consult-register-window)
  :bind
  (:map global-map
        (([remap Info-search] . consult-info)
         ("C-x C-r" . consult-recent-file)
         ("C-M-x" . consult-mode-command)
         ("C-M-;" . consult-complex-command)
         ("M-g M-g" . consult-goto-line)
         ("M-y" . consult-yank-pop)
	     ("C-x p b" . #'consult-project-buffer)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s M-l" . consult-line)
         :map minibuffer-local-map
         ("M-e" . consult-history)))
  :config
  (setq consult-narrow-key ">")
  (add-to-list 'consult-preview-allowed-hooks 'global-org-modern-mode)
  (add-to-list 'consult-preview-allowed-hooks 'olivetti-mode)  
  (add-to-list 'consult-preview-allowed-hooks 'variable-pitch-mode)

  (add-to-list 'consult-buffer-filter
	           "^\\*help\\*" t)
  (add-to-list 'consult-buffer-filter
	           "^\\*Man " t)
  (add-to-list 'consult-buffer-filter
	           "^\\*Async-native-compile-log\\*" t)
  (add-to-list 'consult-buffer-filter
	           "^\\*direnv\\*" t)
  (add-to-list 'consult-buffer-filter
	           "^\\*envrc\\*" t)
  (add-to-list 'consult-buffer-filter
	           "^\\*info\\*" t)
  (add-to-list 'consult-buffer-filter
	           "^\\*EGLOT " t)
  (add-to-list 'consult-buffer-filter
	           "-shell\\*$")
  (add-to-list 'consult-buffer-filter
	           "-eshell\\*$")
  (add-to-list 'consult-buffer-filter
	           "^\\*Backtrace\\*$" t)
  (add-to-list 'consult-buffer-filter
	           "^\\*Warnings\\*" t)
  (add-to-list 'consult-buffer-filter
	           "^\\*Messages\\*" t)

  (defun kam-consult-directory-files-recursively ()
    "Find file recursively"
    (interactive)
    (find-file
     (consult--read
      (directory-files-recursively default-directory "" nil (lambda (x) (not (string-match-p "/\\." x))))
      :state (consult--file-preview)
      :prompt "Find File: "
      :require-match t
      :category 'file))))

;; (dolist (src consult-buffer-sources)
;;   (unless (eq src 'consult--source-buffer)
;;     (set src (plist-put (symbol-value src) :hidden tr))))

(use-package consult-dir
  :ensure t
  :bind
  ("<f2>" . #'consult-dir)
  ("C-c f" . #'kam-consult-dir-find-file)
  (:map vertico-map
              ("<f2>" . consult-dir)
              ("C-<f2>" . consult-dir-jump-file))
  :config
  (setq consult-dir-shadow-filenames nil
	    consult-dir-jump-file-command 'consult-fd)

  (defun kam-consult-dir-find-file ()
    (interactive)
    (let ((consult-dir-default-command 'kam-consult-directory-files-recursively))
      (consult-dir))))

(use-package marginalia
  :ensure t
  :config
  ;; (setq marginalia-align 'left
  ;; marginalia-align-offset 0)
  (marginalia-mode))

(use-package embark
  :bind
  ([remap describe-bindings] . embark-bindings)
  ("<f1>" . #'embark-act)
  ("C-<f1>" . #'embark-dwim)
  (:map vertico-map
	    ("<f1>" . #'embark-act)
	    ("C-<f1>" . #'embark-export))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  (setq embark-prompter #'embark-keymap-prompter)
  (setq embark-indicators '(embark-highlight-indicator
                            embark-isearch-highlight-indicator))
  :ensure t
  :config
  (keymap-set embark-expression-map ";" #'kam-comment-dwim)
  (keymap-set embark-general-map "SPC" 'embark-cycle))

(use-package embark-consult
  :ensure t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Look up the key in `kam-window-prefix-map' and call that function first
;; then run the default embark action
;; (cl-defun kam-embark--call-prefix-action (&rest rest &key run type &allow-other-keys)
;;   (when-let ((cmd (keymap-lookup
;;                    kam-window-prefix-map
;;                    (key-description (this-command-keys-vector)))))
;;     (funcall cmd))
;;   (funcall run :action (embark--default-action type) :type type rest))

;; Dummy function, will be overridden by running `embark-around-action-hook'
;; (defun kam-embark--set-window () (interactive))

;; (setf (alist-get 'kam-embark--set-window embark-around-action-hooks)
;;   '(kam-embark--call-prefix-action))

;; (setf (alist-get 'buffer embark-default-action-overrides) #'pop-to-buffer-same-window
;;      (alist-get 'file embark-default-action-overrides) #'find-file
;;      (alist-get 'bookmark embark-default-action-overrides) #'bookmark-jump
;;      (alist-get 'library default-action-overrides) #'find-library)

;; (map-keymap (lambda (key cmd)
;;                (keymap-set embark-general-map (key-description (make-vector 1 key))
;;                            #'kam-embark--set-window))
;;              kam-window-prefix-map)

(use-package orderless
  :ensure t
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

(setq read-buffer-completion-ignore-case t)

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-separator ?\s)
  (corfu-preview-current t)
  (corfu-cycle t)
  :bind
  (:map corfu-map
        ("<return>" . #'corfu-insert)
        ("SPC" . #'corfu-insert-separator)
        ("C-," . corfu-scroll-up)
        ("M-," . corfu-scroll-down)
	    ("<escape>" . #'corfu-quit))
  :config
  (setq corfu-preview-current nil
        corfu-min-width 20)


  (with-eval-after-load 'save-hist
    (corfu-history-mode 1)
    (add-to-list 'save-hist-additional-variables 'corfu-history)))

(use-package corfu-quick
  :ensure nil
  :after (corfu)
  :bind
  (:map corfu-map
        ("<f6>" . corfu-quick-complete))
  :config
  (setq corfu-quick1 "dnreta"
        corfu-quick2 "dnreta"))

(use-package corfu-popupinfo
  :ensure nil
  :after (corfu)
  :config
  (corfu-popupinfo-mode))

(use-package cape
  :ensure t
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;; (add-hook 'completion-at-point-functions #'cape-dict)
  )

(use-package avy
  :ensure t
  :bind
  ("<f6>" . avy-goto-char-timer)
  :config
  (setq avy-keys '(?d ?n ?r ?e ?t ?a ?s ?i)
        avy-style 'at-full
        avy-timeout-seconds 1.0)
  
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

  (defun kam-avy-action-expand-region (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (er/expand-region))
      (select-window
       (cdr
        (ring-ref avy-ring 0))))
    t)

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
    "test"
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

(use-package ace-window
  :ensure t
  :bind
  ("C-o" . #'ace-window)
  ("M-o" . #'kam-ace-window-dispatch)
  :config
  (setq aw-dispatch-always nil
        aw-keys '(?d ?n ?r ?e ?t ?a)
        aw-dispatch-alist
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
      (ace-window arg))))

(setq display-buffer-alist
      `(("\\*Info\\*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . right)
         (window-width . 0.3)
         (mode Info-mode))
        ("\\*Help\\*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . right)
         (window-width . 0.3)
         (mode help-mode)
         (window-parameters . ((mode-line-format . none))))
	    ("[P] " ;; dired-preview-mode
	     (display-buffer-in-side-window)
	     (side . right)
	     (window-width . 0.5)
	     ;; (mode . dired-preview)
	     (window-parameters . ((mode-line-format . none))))
        ("\\*Org Links\\*" ;; Org Links
         (display-buffer-no-window)
         (allow-no-window . t))
        ("\\*Org Select\\*" ;; `org-capture' key selection
         (display-buffer-in-direction)
         (direction . below)
         (window . root)
         (window-height . 0.5)
         (window-parameters . ((mode-line-format . none))))
        ("\\*Org Agenda\\*"
         (display-buffer-in-side-window)
         (side . right)
         (window-width . 0.5)
         (mode . Org-agenda-mode)
         (window-parameters . ((mode-line-format . none))))
        ("\\(\\*Capture\\*\\|CAPTURE-.*\\)"
         (display-buffer-in-direction)
         (direction . below)
         (window . root)
         (window-height . 0.3)
         (window-parameters . ((mode-line-format . none))))
        ("\\*Async Shell Command\\*"
         (display-buffer-in-side-window)
         (side . bottom)
         (window . root)
         (window-height . 0.35)
         (window-parameters . ((mode-line-format . none))))
        ("Output\\*$"
         (display-buffer-in-side-window)
         (side . bottom)
         (window . root)
         (window-height . 0.35)
         (window-parameters . ((mode-line-format . none))))
        ("\\*compilation\\*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom)
         (window . root)
         (window-height . 0.35)
         (window-parameters . ((mode-line-format . none))))
        ("\\*Backtrace\\*"
         (display-buffer-in-side-window)
         (side . bottom)
         (window . root)
         (window-height . 0.35)
         (window-parameters . ((mode-line-format . none))))
	    ("\\*eat\\*"
	     (display-buffer-in-side-window)
	     (side . bottom)
	     (window . root)
	     (window-height . 0.35)
	     (window-parameters . ((mode-line-format . none))))
        ("^\\*eldoc for"
         (display-buffer-in-side-window)
         (side . bottom)
         (window . root)
         (window-height . 0.35)
         (window-parameters . ((mode-line-format . none))))
        ("\\*Flycheck errors\\*"
         (display-buffer-in-side-window)
         (side . bottom)
         (window . root)
         (window-height . 0.35)
         (window-parameters . ((mode-line-format . none))))
        ("\\*eshell[\\*\\:]" ; matches title for reg eshell and `kam-eshell-here'
         (display-buffer-in-side-window)
         (side . right)
         (window-width . 80)
         (inhibit-same-window . t)
         (mode . eshell-mode)
         (window-parameters . ((mode-line-format . none))))
	    ("-eshell\\*$" ;; matches title for `project-eshell'
	     (display-buffer-in-side-window)
	     (side . bottom)
	     (window . root)
	     (window-height . 0.35)
	     (window-parameters . ((mode-line-format . none))))
	    ("-shell\\*$" ;; matches title for `project-shell'
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
	    ((derived-mode . harpoon-mode)
	     (display-buffer-in-side-window)
	     (side . bottom)
	     (mode harpoon-mode)
	     (window-height . 0.35)
	     (window-parameters . ((mode-line-format . none))))))

(setq window-sides-slots '(0 0 1 1))

(use-package popper
  :ensure t
  :bind (("<f8>" . popper-toggle)
         ("C-<f8>" . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '(("\\*Messages\\*")
          ("Output\\*$" . hide)
          ("\\*Async Shell Command\\*" . hide)
          ("\\Org Agenda\\*" . hide)
          ("\\*Backtrace\\*")
          ("\\*Warnings\\*")
          ("\\*eshell[\:\*]")
          ("\\*compilation\\*")
          ("\\*Flycheck errors\\*")
	      ("-eshell\\*$")
	      ("-shell\\*$")
	      ("\\*eat\\*")
	      ("\\*Helpful ")
	      Man-mode
	      helpful-mode
          help-mode
          Info-mode)
        popper-display-control nil)
  (popper-mode)
  (popper-echo-mode))

;; (defun kam-tab-new-tab-one-command ()
;;   "Create a rnew tab and and run a command in the newly created tab."
;;   (interactive)
;;   (tab-new)
;;   (let* ((command (key-binding
;; 		   (read-key-sequence
;; 		    (format "Run in %s..." (tab-bar-tab-name-current)))))
;; 	 (this-command command))
;;     (call-interactively command)))

(use-package tab-bar
  :ensure nil
  :defer t
  :bind (:map tab-bar-mode-map
	          ("C-<tab>" . nil))
  ("C-x t n" . #'tab-next)
  ("C-x t p" . #'tab-previous)
  ("C-x t +" . #'tab-close)
  :init
  (defun tab-bar-tab-group-format-default (tab _i &optional current-p)
    (propertize
     (concat (funcall tab-bar-tab-group-function tab))
     'face (if current-p 'tab-bar-tab-group-current 'tab-bar-tab-group-inactive)))

  ;; (tab-bar-mode 1)
  :custom
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
      (tab-group (format "[P] %s" name)))))

(use-package otpp
  :ensure t
  :after project
  :init
  (otpp-mode 1)
  (otpp-override-mode 1))

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

;;;###autoload
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
          (call-interactively command))))))

(defun kam-next-buffer (&optional arg)
  "Swith to the next ARGth buffer.
With a universal prefix arg, run in the next window."
  (interactive "P")
  (if-let (((equal arg '(4)))
           (win (other-window-for-scrolling)))
      (with-selected-window win
        (next-buffer)
        (setq prefix-arg current-prefix-arg))
    (next-buffer arg)))

(defun kam-prev-buffer (&optional arg)
  "Switch to the previous ARGth buffer.
With a universal prefix arg, run in the next window."
  (interactive "P")
  (if-let (((equal arg '(4)))
           (win (other-window-for-scrolling)))
      (with-selected-window win
        (previous-buffer)
        (setq prefix-arg current-prefix-arg))
    (previous-buffer arg)))

;;;###autoload
(defun kam-switch-to-buffer (&optional arg)
  (interactive "P")
  (run-at-time
   0 nil
   (lambda (&optional arg)
     (if-let (((equal arg '(4)))
              (win (other-window-for-scrolling)))
         (with-selected-window win
           (call-interactively #'consult-buffer))
       (call-interactively #'consult-buffer)
       (setq this-command 'consult-buffer)))
   arg))

(defun kam-switch-to-buffer-dwim (&optional all-buffers)
  "Switch to a buffer. Switch to a project buffer."
  (interactive "P")
  (if (or (not (project-current))
	      all-buffers)
      (call-interactively #'consult-buffer)
    (call-interactively #'consult-project-buffer)))

(defun kam-split-window-right ()
  "Like the normal `split-window-right' but selects the newly formed window."
  (interactive)
  (split-window-right)
  (windmove-right))

(defun kam-split-window-below ()
  "Like the normal `split-window-below', but splits the window at the root if there are two windows. Additionally selects the newly formed window."
  (interactive)
  (if (kam-common-two-windows-p)
      (split-root-window-below)
    (split-window-below)))

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
          (delete-frame frame))))))

(defun kam-clone-buffer-and-narrow ()
  (interactive)
  (clone-indirect-buffer-other-window nil 'pop-to-buffer)
  (cond ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode) (org-narrow-to-subtree))
        (t (narrow-to-defun))))

;; what the fuck am i doing here
;; (defvar-keymap kam-window-map
;;   :doc "Keymap for windows related actions"
;;   :repeat t
;;   "n" #'kam-next-buffer
;;   "p" #'kam-prev-buffer
;;   "b" #'kam-window-switch-to-buffer
;;   "u" #'winner-undo)

;; (defvar-keymap kam-window-prefix-map
;;   :doc "Keymap for various window-prefix commands.
;; Used for hooking into Embark."
;;   :suppress 'nodigits
;;   "o" #'kam-ace-window-prefix
;;   "0" #'kam-ace-window-prefix
;;   "(" #'split-window-right
;;   "{" #'split-window-horizontally
;;   "}" #'other-frame-prefix)

(setq switch-to-buffer-in-dedicated-window 'pop
      switch-to-buffer-obey-display-actions t
      switch-to-buffer-preserve-window-point t
      help-window-select t
      help-window-keep-selected t
      truncate-partial-width-windows nil)

(defvar-keymap kam-prefix-map
  :doc "Prefix map"
  :name "Prefix"
  :prefix 'kam-prefix
  "1" #'delete-window
  "=" #'delete-window
  "2" #'kam-split-window-right
  "(" #'kam-split-window-right
  "3" #'delete-other-windows
  "{" #'delete-other-windows
  "C-f" #'find-file
  "C-r" (cons "ITE" 'kam-prefix-ite)
  "C-o" (cons "Org" 'kam-prefix-org))

;; (defvar-keymap kam-prefix-search-map
;;   :doc "Prefix map for searching or going"
;;   :name "Search"
;;   :prefix 'kam-prefix-search
;;   "e" #'consult-compiler-error
;;   "C-a" #'harpoon-go-to-3
;;   "C-c" #'goto-char
;;   "C-e" #'harpoon-go-to-2
;;   "C-f" #'consult-fd
;;   "C-g" #'goto-line
;;   "g" #'kam-consult-ripgrep-symbol-at-point
;;   "H-i" #'kam-menu ; translated from C-i
;;   "k" #'consult-keep-lines
;;   "C-k" #'consult-global-mark
;;   "C-l" #'consult-line
;;   "H-m" #'consult-mark
;;   "C-n" #'harpoon-go-to-1
;;   "C-o" #'kam-menu
;;   "C-p" #'kam-consult-line-symbol-at-point
;;   "C-r" #'consult-ripgrep
;;   "C-s" #'isearch-forward)

(defvar-keymap kam-prefix-ite-map
  :doc "Prefix map for the ITE"
  :name "ITE"
  :prefix 'kam-prefix-ite
  "C-c" #'org-roam-node-insert
  "C-d" #'consult-org-roam-file-find
  "C-s" #'consult-org-roam-search
  "C-b" #'consult-org-roam-backlinks
  "C-f" #'org-roam-ref-add
  "C-l" #'org-roam-tag-add
  "C-h" (lambda () (interactive) (find-file kam-ite-home-note))
  "H-i" (lambda () (interactive) (find-file kam-ite-inbox-note)))

(defvar-keymap kam-prefix-org-map
  :doc "Prefix map for Org mode."
  :name "Org"
  :prefix 'kam-prefix-org
  "C-w" #'kam-org-refile-to-current-file
  "C-o" #'kam-org-refile-region
  "C-p" #'org-set-property
  "C-l" #'kam-consult-org-heading-link)

(defun kam-keyboard-quit-dwim ()
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-escape-quit))))

(defun kam-kill-current-buffer (&optional arg)
  "Kill the current buffer, no prompts.
With optional prefix ARG (\\[universal-argument]), delete the buffer's window as well."
  (interactive "P")
  (let ((kill-buffer-query-functions nil))
    (if (or (null (window-prev-buffers))
            (and (not (one-window-p))))
        (kill-buffer-and-window)
      (kill-buffer))))

(use-package org
  :ensure t
  ;; :hook ((org-agenda-after-show . #'visual-line-mode))
         ;; (org-mode . visual-line-mode))
  :bind
  ("C-c a" . #'org-agenda)
  ("C-c c" . #'org-capture)
  ("C-c l" . #'org-store-link)
  ("C-c o l" . #'kam-consult-org-heading-link)
  ("C-c o o" . #'kam-org-refile-region)
  ("C-c o p" . #'org-set-property)
  ("C-c o w" . #'kam-org-refile-to-current-file)
  (:map org-mode-map
        ("C-," . #'scroll-up)
	    ("C-/" . #'scroll-other-window)
	    ("M-/" . #'scroll-other-window-down)
        ("M-," . #'scroll-down)
        ("C-{" . #'org-next-visible-heading)
	    ("M-{" . #'kam-org-metadown)
        ("C-}" . #'org-previous-visible-heading)
	    ("M-}" . #'kam-org-metaup)
	    ("<f2>" . #'org-meta-return)
        ("C-<return>" . #'kam-insert-new-line-below)
        ("C-<backspace>" . #'kam-control-backspace)
        ("C-<tab>" . #'kam-org-up-and-fold-heading)
        ("C-<f2>" . #'org-insert-subheading)
        ("<return>" . #'org-return)
        ("M-j" . #'kam-open-line)
        ("C-j" . #'kam-join-line-dwim)
        ("M-<f2>" . #'kam-org-insert-super-heading)
        ("C-'" . org-edit-src-code)
        ("M-m" . kam-mark-line)
	    ("M-h" . #'mark-paragraph)
        ("C-'" . org-edit-src-exit)
        ("M-<up>" . #'kam-org-metaup)
        ("M-<down>" . #'kam-org-metadown)
        ("C-M-<up>" . #'kam-org-control-metaup)
        ("C-M-<down>" . #'kam-org-control-metadown)
        ("C-M-<left>" . kam-org-promote-subtrees)
        ("C-M-<right>" . kam-org-demote-subtrees)
	    ("C-M-<return>" . org-meta-return)
	    ("C-M-h" . #'mark-defun)
	    ("C-M-m" . #'kam-mark-point-to-end-of-line)
        ("C-M-q" . #'kam-kill-inner-sexp)
	    ("C-M-v" . #'sp-mark-sexp)
        ("C-x C-v" . #'org-mark-element)
        ("C-x C-k" . #'kam-kill-current-buffer)
        ("C-x k" . #'delete-window)
        ("C-x n" . kam-narrow-or-widen-dwim)
        (:map org-src-mode-map
              ("M-'" . org-edit-src-exit)
              ("C-<backspace>" . kam-control-backspace)))
  :config
  (setq org-auto-align-tags nil
	    org-M-RET-may-split-line nil
        org-directory "~/Documents/"
        org-tags-column 0
        org-catch-invisible-edits 'show-and-error
        org-startup-indented t
        org-insert-heading-respect-content t
        org-special-ctrl-a/e t
        org-indirect-buffer-display 'other-window
        org-use-fast-todo-selection t
        org-enforce-todo-dependencies t
        org-return-follows-link t
        org-cycle-separator-lines 2
        org-use-speed-commands t
        org-hide-macro-markers t
        org-blank-before-new-entry '((heading . nil)
                                     (plain-list-item . auto))
        org-ellipsis " ⌄"
        org-hide-emphasis-markers t
        org-fold-catch-invisible-edits 'show
        org-fontify-todo-headline t)

  (setq org-capture-templates
        '(("t" "Task" entry (file kam-task-inbox-file)
           "* TODO %?")
          ("p" "Project" entry )
          ("w" "Writing" entry (file+headline kam-task-task-file "Writing") "* TODO %?\n")
          ("d" "Default" entry (file "~/Documents/Inbox/inbox.org"))))

  (setq org-bookmark-names-plist nil)

  (setq org-refile-use-outline-path t
        org-outline-path-complete-in-steps nil)

  (setq org-export-with-toc nil
	    org-export-with-date nil
	    org-export-with-tags nil
	    org-export-with-title nil
	    org-export-with-author nil)

  (setq org-pretty-entities t)

  (defun kam-org-refile-to-current-file ()
    "Refile the heading under the point to a heading in the current file only."
    (interactive)
    (let ((org-refile-targets '((nil . (:maxlevel . 10)))))
      (org-refile)))

  (defun kam-org-agenda-refile ()
    "Refile in the `org-agenda'. Intended to only be used in the agenda."
    (interactive)
    (let (org-refile-targets `((,kam-task-task-file . (:maxlevel . 2))))
      (org-refile)))

  (defun kam-org-agenda-inbox ()
    "Go to your Inbox in `org-agenda'."
    (interactive)
    (org-agenda nil "i" nil))

  (defun kam-org-agenda-tasks ()
    "Go to your tasks in `org-agenda'."
    (interactive)
    (org-agenda nil "t" nil))

  (defun kam-org-agenda-skip-entry-if-property (prop val)
    "Skip the entry if it marked with PROP property with the value VAL. PROP and VAL should be a string."
    (let ((end (org-entry-end-position))
          (prop-regexp (org-re-property prop nil nil val)))
      (if (re-search-forward prop-regxep end t)
          nil
        end)))

  (setq org-link-context-for-files t
        org-link-keep-stored-after-insertion nil
        org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id
        org-link-frame-setup '((vm . vm-visit-folder-other-frame)
                               (vm-imap . vm-visit-imap-folder-other-frame)
                               (gnus . org-gnus-no-new-news)
                               (file . find-file)
                               (wl . wl-other-frame)))

  (defun kam-org-insert-last-stored-link-with-prompt ()
    "Inserts the last stored link in `org-stored-links' while prompting for the description of the link."
    (interactive)
    (let ((links (copy-sequence org-stored-links)))
      (if (null org-stored-links)
          (user-error "No links to insert")
        (setq l (pop links))
        (org-insert-link nil (car l) (read-from-minibuffer "Link Text: ")))))

  (with-eval-after-load 'pulsar
    (dolist (hook '(org-agenda-after-show-hook org-follow-link-hook))
      (add-hook hook #'pulsar-recenter-center)
      (add-hook hook #'pulsar-reveal-entry))))

(defvar-keymap kam-org-repeat-map
  :repeat t
  :doc "Repeat map for Org"
  "<up>" #'kam-org-up-heading
  "<down>" #'kam-org-down-heading)

;;; Isearch
(use-package isearch
  :ensure nil
  :bind
  (:map isearch-mode-map
        ("<f6>" . avy-isearch)
	    ("<backspace>" . #'kam-isearch-removed-failed-or-last-char))
  :config
  (setq isearch-lazy-count t
        isearch-lazy-count-prefix-format "(%s/%s)"
        isearch-lazy-count-suffix-format nil
        isearch-repeat-on-direction-change t
        search-whitespace-regexp ".*?")

  (defun kam-isearch-removed-failed-or-last-char ()
    "Remove failed part of search string, or last char if successful.
Do nothing if search string is empty to start with."
    (interactive)
    (if (equal isearch-string "")
	    (isearch-update)
      (if isearch-success
	      (isearch-delete-char)
	    (while (isearch-fail-pos) (isearch-pop-state)))
      (isearch-update)))

  (defun kam-isearch-symbol-at-point ()
    (interactive)
    (isearch-forward (thing-at-point 'symbol))))

;; (use-package harpoon
;;    :ensure t
;;    :custom
;;    (harpoon-project-package 'project)
;;    :bind
;;    ("C-c h f" . #'harpoon-file)
;;    ("C-c h c" . #'harpoon-clear)
;;    ("C-(" . #'harpoon-go-to-1)
;;    ("C-{" . #'harpoon-go-to-2)
;;    ("C-}" . #'harpoon-go-to-3)
;;    ("<kam-lsb>" . #'harpoon-go-to-4)
;;    :config
;;    (setq harpoon-project-package 'project))

(use-package move-text
  :bind
  (("M-<up>" . move-text-up)
   ("M-<down>" . move-text-down))
  :ensure t)

(advice-add 'move-text-up :after 'kam-naved-indent-region-advice)
(advice-add 'move-text-down :after 'kam-naved-indent-region-advice)

(use-package wgrep
  :ensure t)

(use-package link-hint
  :ensure t
  :bind
  ("C-<f6>" . link-hint-open-link))

(use-package smartparens
  :ensure t)

(use-package hippie-expand
  :ensure nil
  :bind
  ([remap dabbrev-expand] . hippie-expand))

(use-package paren
  :ensure nil
  :config
  (setq show-paren-context-when-offscreen 'child-frame
        show-paren-delay .75))

(use-package delsel
  :ensure nil
  :config
  (delete-selection-mode 1))

(use-package saveplace
  :ensure nil
  :init
  (save-place-mode 1)
  :custom
  (save-place-file (concat user-emacs-directory ".saved-places"))
  (save-place-forget-unreadable-files t))

(global-subword-mode)

(use-package electric
  :ensure nil
  :hook ((prog-mode . electric-indent-local-mode)
         (org-mode . electric-indent-local-mode))
  :config
  (electric-pair-mode)
  (electric-quote-mode -1)
  (electric-indent-mode))

(use-package visible-mark
  :ensure t
  :config
  (set-face-attribute 'visible-mark-active nil :background "yellow" :underline t)
  (setq visible-mark-faces '((:background "#989898" :foreground "#000000")))
  (global-visible-mark-mode))

(use-package vundo
  :ensure t
  :bind
  ("C-M-?" . #'vundo)
  (:map vundo-mode-map
	    ("<escape>" . #'vundo-quit)))

;; (use-package centered-cursor-mode
;;   :ensure t
;;   :init
;;   (global-centered-cursor-mode))

(defvar undo-repeat-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "?") 'undo)
    map))

(dolist (cmd '(undo))
  (put cmd 'repeat-map 'undo-repeat-map))

(use-package abbrev
  :ensure nil
  :config
  (setq-default abbrev-mode t))

(use-package kmacro
  :ensure nil
  :bind
  (:map kmacro-keymap
        ("I" . #'kmacro-insert-macro))
  :config
  (defalias 'kmacro-insert-macro 'insert-keyboard-macro))

(setq kill-do-not-save-duplicates t)

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

(defun kam-push-mark-no-activate ()
  "Pushes the `point' to the `mark-ring' and does not activate the region.
Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled."
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed point to mark-ring"))

(defun kam-jump-to-mark ()
  "Jumps to the local mark, respecting the mark-ring order.
This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))

(defun kam-exchange-point-and-mark-no-activate ()
  "Identical to \\[exchange-point-and-mark] but will not activate the region."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark nil))

(defun kam-mark-line (&optional arg allow-extend)
  "Put point at beginning of the line, mark at end.

With argument ARG, puts mark at end of a following line, so that
the number of lines marked equals ARG.

If ARG is negative, point is put at end of this line, mark is put
at beginning of this or a previous line.

Interactively (or if ALLOW-EXTEND is non-nil), if this command is
repeated or (in Transient Mark mode) if the mark is active,
it marks the next ARG lines after the ones already marked."
  (interactive "p\np")
  (unless arg (setq arg 1))
  (when (zerop arg)
    (error "Cannot mark zero lines"))
  (cond ((and allow-extend
	          (or (and (eq last-command this-command) (mark t))
		          (and transient-mark-mode mark-active)))       
         (save-excursion
           (goto-char (mark))
           (beginning-of-line)
           (forward-line arg)
           (end-of-line)
           (push-mark nil t t)))
	    (t
	     (goto-char (line-end-position))
         (push-mark nil t t)
         (beginning-of-line))))

(defun kam-mark-line-with-newline ()
  "Selects the whole line with the newline of the previous line."
  (interactive)
  (kam--mark
   (cons (line-beginning-position)
         (save-excursion
           (next-line)
           (line-beginning-position)))))

(defun kam-mark-point-to-end-of-line ()
  (interactive)
  (kam--mark
   (cons
    (point)
    (line-end-position)))
  (exchange-point-and-mark))

(define-advice pop-global-mark (:around (pgm) use-display-buffer)
  "Make `pop-to-buffer' jump buffers via `display-buffer'."
  (cl-letf (((symbol-function 'switch-to-buffer)
             #'pop-to-buffer))
    (funcall pgm)))

(defun kam-cut-dwim ()
  "Kills based on the position of the point in the buffer.

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
  (kam-common--duplicate-buffer-substring
   (if (region-active-p)
       (cons (region-beginning) (region-end))
       (cons (region-beginning) (region-end))
     (cons (line-beginning-position) (line-end-position)))))

(advice-add #'kam-duplicate-line-or-region :after #'kam-naved-indent-region-advice)

(advice-add #'yank :after #'kam-naved-indent-region-advice)

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
  "Joins lines based on the position of the point on the current line.
  If the point is at the end of the line, join the next line to the current line. If the point is anywhere but the end of the line, joins the current line to the previous line."
  (interactive)
  (if (eolp)
      (progn
        (next-line)
        (join-line))
    (join-line)))

(defun kam-open-line ()
  "Opens the line and indents it to the proper place."
  (interactive)
  (save-excursion
    (open-line 1)
    (next-line)
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
  "Kills the whole line, regardless of the cursor position within the line.
        If called interactively without a prefix numeric argument, N is 1."
  (dotimes (_ n)
    (kam-mark-line-with-newline)
    (kill-region (region-beginning) (region-end))))

(defun kam-kill-from-point-to-beginning-of-line ()
  "Kill from the point to the beginning of the line."
  (interactive)
  (kill-region (line-beginning-position) (point)))

(defun kam-naved-delete-from-point-to-beginning-text ()
  "Delete from the point up to and including the text."
  (interactive)
  (while (or (not (kam-common-line-only-spaces-p))
             (bolp))
    (delete-char -1)))

(defun kam-comment-dwim (n)
  "Comment N lines, defaulting to the current line.
        When the region is active, comment its lines instead."
  (interactive "p")
  (if (use-region-p)
      (comment-or-uncomment-region
       (region-beginning) (region-end))
    (comment-line n)))

(defun kam-control-backspace ()
  "Kill the word behind point. If the line is empty, join it with the previous line."
  (interactive)
  (if (or (kam-common-line-empty-before-point-p)
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

(defun kam-kill-sexp (&optional arg interactive)
  "Kill the sexp following point.
        With ARG, do it that many times."
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

"test test test"
(cl-defmethod register--type ((_regval vector)) 'vector)

(cl-defmethod register-val-describe ((val vector) _verbose)
  (if-let* ((pos (aref val 2))
            (file (aref val 1)))
      (princ (format "%s at position %s" file pos))
    (princ "Garbage data")))

(defvar kam-naved-file-to-register-jump-hook nil
  "Normal hook called after jumping to a file register.
See `kam-naved-file-to-register'.")

;;;###autoload
(defun kam-naved-file-to-register (register)
  "Store current location of file's point in REGISTER."
  (interactive (list (register-read-with-preview-fancy "File to register: ")))
  (set-register register (vector 'file-with-point (buffer-file-name) (point))))

(cl-defmethod kam-naved-register-val-jump-to ((val vector) delete)
  "Handle how to jump to a location register.
This is like the default, but does not ask to visit a file, but does it outright."
  (cond
   ((eq (aref val 0) 'file-with-point)
    (find-file (aref val 1))
    (goto-char (aref val 2))
    (run-hooks 'kam-naved-file-to-register-jump-hook))
   (t (cl-call-next-method val delete))))

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

(defun kam-naved-indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(defun kam-yank ()
  (interactive)
  (let ((yank-transform-functions
         '(kam-yank--string-transform)))
    (yank)))

(defun kam-yank--string-transform (string)
  (let* ((newline-string (string-chop-newline string))
        (beginning-whitespace-string (string-trim-left newline-string)))
    beginning-whitespace-string))



(use-package org-babel
  :no-require
  :ensure nil
  :config
  (setq org-confirm-babel-evaluate nil
        org-src-window-setup 'current-window
        org-edit-src-persistent-message nil
        org-src-fontify-natively t
        org-src-preserve-indentation t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
     (emacs-lisp . t))))

(use-package org-tempo
  :ensure nil
  :after (org modus-themes)
  :config
  (setq org-structure-template-alist
        '(("c" . "comment")
          ("C" . "src C :main no")
          ("e" . "src emacs-lisp")
          ("E" . "src emacs-lisp :results value code lexical:t")
          ("et" . "src emacs-lisp :tangle")
          ("s" . "src")
          ("sh" . "sh")
          ("t" . "tip")
          ("T" . "src emacs-lisp :tangle FILENAME :mkdirp yes")
          ("w" . "warning")
          ("q" . "quote"))))

(use-package ox-gfm
  :ensure t
  :after org)

(use-package org-contrib
  :ensure t
  :after org
  :config
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines)))

(defun kam-org-syntax-table-modify ()
  "Modify `org-mode-syntax-table' for the current Org buffer.

This stops the mismatch parenthesis bug in Org source blocks."
  (modify-syntax-entry ?< "." org-mode-syntax-table)
  (modify-syntax-entry ?> "." org-mode-syntax-table))

(add-hook 'org-mode-hook #'kam-org-syntax-table-modify)

(use-package org-modern
  :ensure t
  :after org
  :config
  (setq org-modern-star 'replace)
  (set-face-attribute 'org-modern-symbol nil :family "SF Mono")
  (global-org-modern-mode))

;; (use-package tmr
;;  :ensure t)

(defun kam-org-metaup ()
  "Go to the previous heading or item, or to a higher level heading.
If not on a heading or item, finds the previous heading backwards. If already on a heading, goes up higher in the tree."
  (interactive)
  (cond
   ((org-at-block-p) (org-up-element))
   ((org-in-src-block-p) (org-babel-goto-src-block-head))
   ((kam-org-at-level-one-heading-p) (org-backward-heading-same-level 1))
   (t (org-up-element))))

(defun kam-org-metadown ()
  "Go to the next heading or item, or to a higher level heading.
If not on a heading or item, finds the next heading forwards. If already on a heading, goes up "
  (interactive)
  (cond
   ((org-at-block-p) (org-down-element))
   ((org-in-src-block-p) (kam-org-babel-goto-src-block-foot))
   ((kam-org-at-level-one-heading-p) (org-forward-heading-same-level 1))
   (t (org-next-visible-heading 1))))

(defvar kam-org-end-block-regexp "#\\+end_\\w+"
  "Regexp that matches the end of an Org Babel block.")

(defun kam-org-babel-goto-src-block-foot ()
  "Go to the end of an Org Babel block."
  (interactive)
  (goto-char (re-search-forward kam-org-end-block-regexp)))

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

(defun kam-org-at-level-one-heading-p ()
  "Return true if the point is on a level one Org heading."
  (if (eq (nth 1 (org-heading-components)) 1)
      t
    nil))

(defun kam-org-fold-subheadings ()
  "Folds all of the Org subheadings from the current heading."
  (org-map-entries
   (org-fold-heading)
   nil
   'tree))

(defun kam-org-up-heading (&optional arg)
  (interactive "p")
  (cond
   ((org-in-src-block-p) (org-babel-goto-src-block-head))
   ((kam-org-at-level-one-heading-p) (org-backward-heading-same-level arg))
   (t (org-up-element))))

(defun kam-org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
   "/DONE" 'file))

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

(declare-function org-map-entries "org")

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

(defun kam-org-id-headlines ()
  "Add missing CUSTOM_ID to all headlines in the current file."
  (interactive)
  (org-map-entries
   (lambda () (kam-org--id-get))))

(defun kam-org-id-headline ()
  "Add missing CUSTOM_ID to headline at point."
  (interactive)
  (kam-org--id-get))

(defun kam-org-insert-date-range ()
  (interactive)
  (org-time-stamp nil)
  (insert "--")
  (org-time-stamp nil))

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

(defun kam-org-up-and-fold-heading (&optional arg)
  "Fold the nearest heading at point."
  (interactive "p")
  (kam-org-metaup)
  (org-cycle))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

(defvar kam-dotfiles-directory "~/.dotfiles/")

(defun kam-os-nix-rebuild ()
  "Runs the command nixos-rebuild switch --flake."
  (interactive)
  (let ((default-directory kam-dotfiles-directory))
    (compile "sudo nixos-rebuild switch --flake .#nixos" t)))

(defun kam-os-nix-garbage-clean ()
  "Cleans up the garbage on the NixOS system."
  (interactive)
  (async-shell-command "nix-env --delete-generations 5d && nix-store --gc"))

(defun kam-os-nix-update ()
  "Updates the Nix flake and rebuilds the system."
  (interactive)
  (let ((default-directory kam-dotfiles-directory))
    (compile "sudo nix flake update && sudo nixos-rebuild switch --flake .#nixos" t)))

(defun kam-os-reboot ()
  "Restarts the computer."
  (interactive)
  (async-shell-command "reboot"))

(defun kam-os-shutdown ()
  "Shuts down the computer."
  (interactive)
  (async-shell-command "systemctl poweroff"))

(defun kam-os-stop-emacs ()
  "Stop the Emacsclient server using Systemd."
  (interactive)
  (async-shell-command "systemctl --user stop emacs"))

(defun kam-os-restart-emacs ()
  "Restart the Emacsclient server using Systemd."
  (interactive)
  (async-shell-command "systemctl --user restart emacs"))

(defun kam-os-screenshot ()
  "Take a screenshot."
  (interactive)
  (let ((default-directory "~/Pictures/Screenshots/")
	    (name (read-string "Name of screenshot: ")))
    (setenv "WAYLAND_DISPLAY" "wayland-1")
    (async-shell-command (concat "wayshot -s \"$(slurp)\" -f " name ".jpg"))))

(use-package denote
  :ensure t
  :hook ((dired-mode . denote-dired-mode)
         (after-init . denote-rename-buffer-mode))
  :bind
  ("C-c n h" . #'kam-ite-visit-home)
  ("C-c n w" . #'kam-ite-visit-workbench)
  ("C-c n d" . #'denote-open-or-create)
  ("C-c n b" . #'denote-backlinks)
  ("C-c n c" . #'denote-link)
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
    (find-file kam-ite-home-note))

  ;; (defun kam-ite-visit-inbox ()
  ;;   "Visits the `kam-ite-inbox-note'."
  ;;   (interactive)
  ;;   (find-file kam-ite-inbox-note))

  (defun kam-ite-visit-workbench ()
    "Visits the `kam-ite-workbench-note'."
    (interactive)
    (find-file kam-ite-workbench-note)))

(use-package consult-denote
  :ensure t
  :custom
  (consult-denote-find-command #'consult-fd)
  (consult-denote-grep-command #'consult-ripgrep)
  :bind
  ("C-c n g" . #'consult-denote-grep)
  ("C-c n f" . #'consult-denote-find)
  :config
  (consult-denote-mode 1))

(use-package denote-org
  :ensure t
  :config
  (setq denote-org-store-link-to-heading 'id))

(use-package denote-explore
  :ensure t)

(use-package org-anki
  :ensure t
  :config
  (setq org-anki-api-key nil
        org-anki-default-deck "get that main main"))

(use-package project
  :ensure t
  :bind (:map project-prefix-map
              ("b" . #'hconsult-project-buffer)
              ("g" . #'consult-ripgrep))
  :custom
  (project-switch-use-entire-map nil)
  ;; (project-prompter 'kam-project--read-project-by-name)
  :config
  (setq project-vc-ignores '("nix/store/"
			                 "node_modules/"
			                 "go/pkg/"
			                 ".direnv/")
	    project-vc-extra-root-markers '(".project"))

  (add-to-list 'project-switch-commands '(consult-ripgrep "Grep" "g"))
  (add-to-list 'project-switch-commands '(magit-status "Git" "G"))
  
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
          (async-shell-command (concat "git init " project-name))
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

  (defun kam-project-remember-advice ()
    "Advice intended to be run after project creation commands to properly remember the projects."
    (project-remember-projects-under kam-projects-directory t)
    (kam-common-clear-echo-area)))

(use-package eat
  :ensure t
  :hook ((eshell-load . #'eat-eshell-mode)
	     (eshell-load . #'eat-eshell-visual-command-mode))
  :config
  (setq eat-shell (getenv "SHELL")))

(use-package calibredb
  :defer t
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
    (find-file (calibredb-get-file-path  candidate t)))

  (defun kam-calibredb-search-books ()
    (interactive)
    (let ((consult-ripgrep-command "rg --null --ignore-case --type txt --line-number . --color always --max-columns 500 --no-heading -e ARG OPTS"))
      (consult-ripgrep calibredb-root-dir))))

(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))

(use-package nov
  :config
  (setq nov-text-width 80))
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

(use-package shell
  :ensure nil
  :hook (shell-mode . kam-shell-mode-setup)
  :bind
  (:map shell-mode-map
        ("SPC" . #'comint-magic-space)
        ("M-<up>" . #'kam-shell-up-directory)
        ("C-c C-d" . #'kam-shell-cd)
        ("C-c C-k" . #'comint-clear-buffer)
        ("C-c C-w" . #'comint-write-buffer)
        ("C-c C-j" . #'kam-comint-input-from-history)
	    ("<escape>" . #'quit-window))
  :config
  (setq shell-command-prompt-show-cwd t
        explicit-shell-file-name (executable-find "zsh")
	    explicit-zsh-args '("--interactive" "--login")
        tramp-default-remote-shell "/bin/bash"
        ansi-color-for-comint-mode t
        shell-command-prompt-show-cwd t
        shell-input-autoexpand 'input
        shell-highlight-undef-enable t
        shell-get-old-input-include-continuation-lines t
        shell-kill-buffer-on-exit t
        comint-completion-auto-list t
        comint-prompt-read-only t
        comint-buffer-maximum-size 9999
        comint-input-ignoredups t)

  (setq shell-font-lock-keywords
        '(("[ \t]\\([+-][^ \t\n]+\\)" 1 font-lock-builtin-face)
          ("^[^ \t\n]+:.*" . font-lock-string-face)
          ("^\\[[1-9][0-9]*\\]" . font-lock-constant-face))))

(defun kam-shell-mode-setup ()
  (setq-local comint-process-echoes t
              outline-regexp comint-prompt-regexp))

(defvar kam-shell-cd--directories nil
  "List of accumulated `shell-last-dir'.")

(with-eval-after-load 'save-hist
  (add-to-list 'savehist-additional-variables 'kam-shell-cd--directories))

(defun kam-shell--track-cd (&rest _)
  "Track shell input of cd commands.
Push `shell-last-dir' to `kam-shell-cd--directories'."
  (when-let ((input (kam-comint--last-input))
             ((string-match-p "cd " input)))
    (push shell-last-dir kam-shell-cd--directories)))

(defvar kam-shell-cd--history nil
  "Minibuffer history for `kam-shell-cd'.")

(defun kam-shell-cd--prompt ()
  "Prompt for a directory among `kam-shell-cd--directories'."
  (if-let ((history kam-shell-cd--directories)
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
  "Navigate to a previously visited directory in Shell, or to any directory offered by `consult-dir'."
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
    (split-window-right)
    (other-window 1)
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

(defun kam-comint--beginning-of-prompt-p ()
  "Return non-nil if the point is at the beginning of a shell prormpt."
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

(defun kam-comint--input-history-prompt ()
  "Prompt for completion against `kam-comint--history-to-list'."
  (let* ((history (kam-comint--history-to-list))
         (default (car history)))
    (completing-read
     (format-prompt "Insert input from history: " default)
     history
     nil
     nil
     nil
     'kam-comint--input-history-prompt
     default)))

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
     nil)))

(use-package eshell
  :ensure nil
  ;; :hook ((eshell-mode . #'kam-eshell--set-env)
  ;; (eshell-mode . completion-preview-mode))
  :bind
  (("C-c e" . eshell)
   :map eshell-mode-map
   ("<tab>" . completion-at-point)
   ("C-c d" . eshell/z)
   ;; ("<escape>" . quit-window)
   )
  :config
  ;; (add-to-list 'eshell-lisp-list 'eshell-smart)
  (defvar kam-eshell-prompt-regexp "\\[[[:punct:][:alnum:]]+ — [[:punct:][:alnum:]]+ \\$ "
    "Regular expression that matches the prompt used for Eshell buffers.

Used for setting Eshell's `outline-regexp'.")
  
  (setq eshell-list-files-after-cd t
        eshell-ls-initial-args '("-AGFhlv" "--color=always")
        eshell-scroll-to-bottom-on-input 'all
        eshell-error-if-no-glob t
        eshell-hist-ignoredups t
        eshell-history-size 10000
        eshell-save-history-on-exit t
        eshell-prefer-lisp-functions nil
        eshell-destroy-buffer-when-process-dies t
        eshell-highlight-prompt t)

  (add-hook 'eshell-mode-hook (lambda ()
                                (setq outline-regexp kam-eshell-prompt-regexp)
                                (eshell-prompt-mode)
                                (setenv "TERM" "xterm-256-color"))))

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
          (modus-themes-with-colors
            (concat
             (propertize "[" 'face `(:foreground ,fg-main :background ,bg-active))
             (propertize (user-login-name) 'face `(:foreground ,fg-main :background ,bg-active))
             (propertize "@" 'face `(:foreground ,fg-main :background ,bg-active))
             (propertize (system-name) 'face `(:foreground ,pink :background ,bg-active))
             (propertize "]" 'face `(:foreground ,fg-main :background ,bg-active))
             (propertize " — " 'face `(:foreground ,fg-main :background ,bg-active))
             (propertize parent 'face `(:foreground ,pink :weight bold))
             (propertize dir 'face `(:foreground ,pink :weight bold))
             (propertize " $ " 'face `(:weight bold :background ,bg-active)))))))

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

(use-package em-smart
  :ensure nil
  :config
  (setq eshell-where-to-jump 'after
        eshell-review-quick-commands nil
        eshell-smart-space-goes-to-end t))

(use-package eshell-syntax-highlighting
  :ensure t
  :after eshell-mode)

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
  "Navigate to a previously visited directory in Eshell, or to any directory offered by `consult-dir'."
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
The eshell is renamed to match that directory in order to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (name (car (last (split-string parent "/" t)))))
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))
    (insert (concat "ls"))
    (eshell-send-input)))

(use-package vterm
  :ensure nil
  :custom
  (vterm-shell "/bin/bash"))

(defun kam-common-empty-buffer-p ()
  "Test whether the buffer is empty."
  (or (= (point-min) (point-max))
      (save-excursion
        (goto-char (point-min))
        (while (and (looking-at "^\\([a-zA-Z]+: ?\\)?$")
                    (zerop (forward-line 1))))
        (eobp))))

(defun kam-common-quit-window ()
  "Quit the window and kill it."
  (interactive)
  (quit-window t))

(defun kam-common-window-bounds ()
  "Return the start and end points of the window as a cons cell."
  (cons (window-start) (window-end)))

;;;###autoload
(defun kam-common-page-p ()
  "Return non-nil if there is a `page-delimiter' in the buffer."
  (or (save-excursion (re-search-forward page-delimiter nil t))
      (save-excursion (re-search-backward page-delimiter nil t))))

;;;###autoload
(defun kam-common-three-or-more-windows-p (&optional frame)
  "Return non-nil if three or more windows occupy FRAME.
If FRAME is non-nil, inspect the current frame."
  (>= (length (window-list frame :no-minibuffer)) 3))

;;;###autoload
(defun kam-common-two-windows-p (&optional frame)
  "Return non-nil if two windows occupy FRAME.
If FRAME is non-nil, inspect the current frame."
  (= (length (window-list frame :no-minibuffer)) 2))

;;;###autoload
(defun kam-common-read-data (file)
  "Read Elisp data from FILE."
  (with-temp-buffer
    (insert-file-contents file)
    (read (current-buffer))))

;;;###autoload
(defun kam-common-shell-command-with-exit-code-and-output (command &rest args)
  "Runs COMMAND with ARGS.
Return the exit code and output in a list."
  (with-temp-buffer
    (list (apply 'call-process command nil (current-buffer) nil args)
          (buffer-string))))

(defun kam-common-async-shell-command-with-exit-code-and-output (command output-buffer error-buffer &rest args)
  "Runs COMMAND with ARGS asynchronously.
Return the exit code and output in a list."
  (with-temp-buffer
    (list (async-shell-command (concat command " " args) output-buffer error-buffer)
          (buffer-string))))

;;;###autoload
(defun kam-common-sudo-shell-command (command &rest args)
  "Runs COMMAND with ARGS as root."
  (async-shell-command (concat "echo " (read-passwd "Password: ") " | sudo -S " command)))

(advice-add 'kam-common-sudo-shell-command :after 'kam-common-clear-echo-area)

;;;###autoload
(defun kam-common-execute-command-on-file-buffer (cmd)
  (interactive "sCommand to excute: ")
  (let* ((file-name (buffer-file-name))
	     (full-cmd (concat cmd " " file-name)))
    (async-shell-command full-cmd)))

;;;###autoload
(defun kam-common-completion-category ()
  "Return completion category."
  (when-let* ((window (active-minibuffer-window)))
    (with-current-buffer (window-buffer window)
      (completion-metadata-get
       (completion-metadata (buffer-substring-no-properties
                             (minibuffer-prompt-end)
                             (max (minibuffer-prompt-end) (point)))
                            minibuffer-completion-table
                            minibuffer-completion-predicate)
       'category))))

;;;###autoload
(defun kam-common-completion-table (category candidates)
  "Pass appropriate metadata CATEGORY to completion CANDIDATES.

This is intended for bespoke functions that can then be parsed by other tools."
  (lambda (string pred action)
    (if (eq action 'metadata)
        `(metadata (category . ,category))
      (complete-with-action action candidates string pred))))

(defun kam-common-sudo ()
  "Find the current file or directory using SUDO."
  (interactive)
  (let ((destination (or buffer-file-name default-directory)))
    (if (string= (file-remote-p destination 'method) "sudo")
	    (user-error "Already using `sudo'")
      (find-file (format "/sudo::/%s" destination)))))

;;;###autoload
(defun kam-common--duplicate-buffer-substring (boundaries)
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

(defvar kam-common--line-regexp-alist
  '((empty . "[\s\t]*$")
    (indent . "^[[:blank:]]+")
    (non-empty . "^.+$")
    (list . "^\\([\s\t#*+]+\\|[0-9]+[^\s]?[).]+\\)")
    (heading . "^[=-\\*]+\\|[*]+"))
  "Alist of regexp types used by `kam-common-line-regexp-p'.")

(defun kam-common-line-regexp-p (type &optional n)
  "Test for TYPE on line.
TYPE is the car of a cons cell in `kam-common--line-regexp-alist'. It matches a regular expression.

With optional N, search in the Nth line from point."
  (save-excursion
    (goto-char (line-beginning-position))
    (and (not (bobp))
         (or (beginning-of-line n) t)
         (save-match-data
           (looking-at
            (alist-get type kam-common--line-regexp-alist))))))

;;;###autoload
(defun kam-common-line-empty-before-point-p ()
  "Return true if there are only spaces or tabs before the point on the current line."
  (if (looking-back (alist-get 'indent kam-common--line-regexp-alist))
      t
    nil))

(defun kam-common-line-only-spaces-or-symbols-p ()
  "Return true if there are only spaces or symbols before the point on the current line."
  (if (looking-back "^\([[:blank:]]\\|[[:punct:]])*")
      t
    nil))

(defun kam-completing-read (prompt collection &optional predicate require-match initial-input hist def inherit-input-method)
  "Calls `completing-read' but returns the value from COLLECTION.

Simple wrapper around the `completing-read' function that assumes the collection is either an alist or a hashtable, and returns the _value_ of the choice, not the selected choice.

An example function would look like:
(defun kam-test-function (selection)
  (interactive (list (kam-completing-read \"Prompt: \" kam-test)))
  (message \"%s\" selection))

Where kam-test is an alist of choices mapped to values."

  (cl-flet ((assoc-list-p (obj) (and (listp obj) (consp (car obj)))))
    (let* ((choice
            (completing-read prompt collection predicate require-match initial-input hist def inherit-input-method))
           (results (cond
                     ((hash-table-p collection) (gethash choice collection))
                     ((assoc-list-p collection) (alist-get choice collection def nil 'equal))
                     (t choice))))
      (if (listp results) (first results) results))))

(defun kam-common-rename-file-and-buffer (name)
  "Apply NAME to current file and rename its buffer."
  (interactive
   (list (read-string "Rename current file: " (buffer-file-name))))
  (let ((file (buffer-file-name)))
    (if (vc-registered file)
        (vc-rename-file file name))
    (set-visited-file-name name t t)))

(defun kam-common-parse-file-as-list (file)
  "Return the contents of FILE as a list of strings.
Strings are split at the newline characters then trimmed for negative space."
  (split-string
   (with-temp-buffer
     (insert-file-contents file)
     (buffer-substring-no-properties (point-min) (point-max)))
   "\n" :omit-nulls "[\s\f\t\n\r\v]+"))

;;;###autoload
(defun kam-common-ignore (&rest _)
  "Use this as a wrapper on a function to make it do nothing."
  nil)

;;;###autoload
(defun kam-common-window-narrow-p ()
  "Return non-nil if the window is narrow.
Check if the `window-width' is less than `split-width-threshold'."
  (and (numberp split-width-threshold)
       (< (window-total-width) split-width-threshold)))

;;;###autoload
(defun kam-common-window-small-p ()
  "Return non-nil if the window is small.
Check if the `window-width' or the `window-height' is less than `split-width-threshold' or `split-height-threshold', respectively."
  (or (and (numberp split-width-threshold)
           (< (window-total-width) split-width-threshold))
      (and (numberp split-height-threshold)
           (> (window-total-height) split-height-threshold))))

;;;###autoload
(defun kam-common-crm-exclude-selected-p (input)
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

;;;###autoload
(defun kam-common-active-minor-modes ()
  "Returns list of active minor modes for the current buffer."
  (let ((active-modes))
    (mapc (lambda (m)
            (when (and (boundp m) (symbol-value m))
              (push m active-modes)))
          minor-mode-list)
    active-modes))

;;;###autoload
(defun kam-common-clear-echo-area (&rest _nil)
  "Clear the echo area.
Use this as advice :after a noisy function."
  (message ""))

(defun kam-common-first-char (str)
  "Return the first character from STR."
  (substring str 0 1))

(use-package modus-themes
  :ensure t
  :config
  (setq modus-themes-disable-other-themes t
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t
        modus-themes-prompts '(heavy)
        modus-themes-org-blocks nil
        modus-themes-completions '((selection . (bold)))
        modus-theme-headings '((1 . (variable-pitch 1.5))
                               (2 . (variable-pitch 1.3))
                               (3 . (variable-pitch 1.1))
                               (t . (variable-pitch 1)))
        
        modus-vivendi-palette-user '((kam-comment "#ff7f24")
                                     (kam-constant "#7fffd4")
                                     (kam-fnname "#87cefa")
                                     (kam-keyword "#00ffff")
                                     (kam-preprocessor "#b0c4de")
                                     (kam-string "#ffa07a")
                                     (kam-type "#98fb98")
                                     (kam-variable "#eedd82"))
        
        modus-vivendi-palette-overrides '(
                                          (bg-main "#000000")
                                          (bg-active bg-main)
                                          ;; (bg-mode-line-active bg-blue-subtle)
                                          ;; (border-mode-line-active unspecified)
                                          ;; (fg-region unspecified)
                                          ;; (bg-heading-1 bg-main)
                                          ;; (fg-heading-1 fg-main)
                                          ;; (fg-heading-2 fg-changed)
                                          ;; (bg-heading-2 bg-main)
                                          ;; (fg-heading-3 blue-cooler)
                                          ;; (bg-heading-3 and bg-main)
                                          ;; (builtin "#b0c4de")
                                          ;; (Comment "#ff7f24") ;; these ;custom values are taken from standard-themes-dark
                                          (constant "#7fffd4")
                                          (fnname "#87cefa")
                                          (keyword "#00ffff")
                                          (preprocessor "#b0c4de")
                                          (docstring "#ffa07a")
                                          (string "#ffa07a")
                                          (type "#98fb98")
                                          (variable "#eedd82")
                                          (rx-escape "#44cc44")
                                          (rx-construct "#ffffff")
                                          (fg-prompt cyan)
                                          ;; (bg-prompt unspecified)
                                          (fg-completion-match-0 fg-main)
                                          ;; (bg-completion-match-0 unspecified)
                                          (fg-completion-match-1 fg-main)
                                          (bg-prose-block-delimiter "#312f34")
                                          (bg-prose-block-contents "#29272c")
                                          ;; (bg-completion-match-1 unspecified)
                                          ))

  (defun kam-set-custom-faces (&rest _)
    "Function which sets faces across the configuration using the `modus-themes-with-colors' macro."
    (modus-themes-with-colors
      (custom-set-faces
       `(mode-line ((,c :background "#003c53" :foreground ,fg-main)))
       `(region ((,c :extend nil)))
       `(org-special-keyword ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-meta-line ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-document-title ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-document-info ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-document-info-keyword ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-drawer ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-property-value ((,c :inherit fixed-pitch :height .8 :foreground ,fg-dim)))
       `(org-ellipsis ((,c :height 1.0 :foreground ,fg-dim)))
       `(org-block-end-line ((,c :background ,bg-prose-block-delimiter)))
       `(denote-faces-keywords ((,c :foreground ,keyword)))
       `(olivetti-fringe ((,c :background ,bg-main))))))

  (defun kam-modus-themes-org-block-faces (&rest _)
    "Function for setting custom org block faces."
    (modus-themes-with-colors
      (setq org-src-block-faces
            `(("emacs-lisp" bg-dim)))))

  (add-hook 'modus-themes-post-load-hook #'kam-set-custom-faces)
  (add-hook 'modus-themes-post-load-hook #'kam-modus-themes-org-block-faces))

(use-package ef-themes
  :ensure t)

(use-package olivetti
  :ensure t
  :config
  (setq olivetti-style 'fancy
        olivetti-margin-width 5
        olivetti-body-width .7
        ;; olivetti-minimum-body-width 80
        olivetti-recall-visual-line-mode-entry-state t))

(use-package spacious-padding
  :ensure t
  :config
  ;; (setq spacious-padding-subtle-mode-line
  ;;       '(:mode-line-active "#fec43f"
  ;;         :mode-line-inactive 'vertical-border))

  (setq spacious-padding-subtle-mode-line nil)
  
  (setq spacious-padding-widths
        '( :internal-border-width 15
           :header-line-width 4
           :mode-line-width 8
           :tab-width 4
           :right-divider-width 30
           :scroll-bar-width 8
           :fringe-width 4))
  (spacious-padding-mode))

(setq mode-line-compact nil
      mode-line-right-align-edge 'right-fringe)

(setq-default mode-line-format
              '("%e"
                kam-modeline-nix
                kam-modeline-kbd-macro
                kam-modeline-narrow
                kam-modeline-buffer-modified
                kam-modeline-buffer-status
                "  "
                kam-modeline-buffer-identification
                "  "
                kam-modeline-major-mode
		        "  "
		        ;; kam-modeline-buffer-stats
                kam-modeline-process
                " "
                mode-line-format-right-align
                kam-modeline-vc-branch))

;; (with-eval-after-load 'spacious-padding
;;   (defun kam-modeline--spacious-indicators ()
;;     "Set box attribute to `'kam-modeline-indicator-button' if spacious-padding is enabled."
;;     (if (bound-and-true-p spacious-padding-mode)
;;         (set-face-attribute 'kam-modeline-indicator-button nil :box t)
;;       (set-face-attribute 'kam-modeline-indicator-button nil :box 'unspecified)))

;;   (kam-modeline--spacious-indicators)
;;   (add-hook 'spacious-padding-mode-hook #'kam-modeline--spacious-indicators))

(use-package logos
  :ensure t
  :config
  (setq-default logos-hide-mode-line t
                logos-hide-header-line t
                logos-hide-buffer-boundaries t
                logos-hide-fringe nil
                logos-olivetti t))

(use-package lin
  :ensure t
  :hook (after-init . lin-global-mode)
  :config
  (setq lin-face 'lin-yellow))

(use-package pulsar
  :ensure t
  :hook ((next-error . pulsar-pulse-line)
         (minibuffer-setup . pulsar-pulse-line)
         (consult-after-jump . pulsar-recenter-center)
         (consult-after-jump . pulsar-reveal-entry)
         (imenu-after-jump . pulsar-recenter-center)
         (imenu-after-jump . pulsar-reveal-entry))
  :config
  (setq pulsar-pulse t
        pulsar-face 'ansi-color-yellow)
  (setopt pulsar-delay 0.03
          pulsar-iterations 17)
  (pulsar-global-mode)

  (add-to-list 'pulsar-pulse-functions 'avy-goto-char-timer)
  (add-to-list 'pulsar-pulse-functions 'pixel-scroll-interpolate-down)
  (add-to-list 'pulsar-pulse-functions 'pixel-scroll-interpolate-up)
  (add-to-list 'pulsar-pulse-functions 'scroll-down)
  (add-to-list 'pulsar-pulse-functions 'scroll-up)
  (add-to-list 'pulsar-pulse-functions 'ace-window)
  (add-to-list 'pulsar-pulse-functions 'kam-jump-to-mark)

  (advice-add 'avy-goto-char-timer :after 'pulsar-recenter-center)
  (advice-add 'kam-jump-to-mark :after 'pulsar-recenter-center))

(use-package all-the-icons
  :if (display-graphic-p)
  :commands all-the-icons-install-fonts
  :init
  (unless (find-font (font-spec :name "all-the-icons"))
    (all-the-icons-install-fonts t))
  :config
  (setq all-the-icons-scale-factor 1.1))

(use-package all-the-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode . all-the-icons-ibuffer-mode))

(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode)
  :config
  (setq all-the-icons-dired-monochrome nil))

(use-package all-the-icons-completion 
  :ensure t
  :after marginalia
  :hook (marginalia-mode . #'all-the-icons-completion-marginalia-setup))

(all-the-icons-completion-mode 1)

(use-package nerd-icons
  :config
  (setq nerd-icons-font-family "SauceCodePro Nerd Font"))

(use-package nerd-icons-corfu
  :ensure t
  :after (corfu)
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(defun kam-set-font-faces ()
  (set-face-attribute 'default nil :font "SauceCodePro Nerd Font" :height 140 :weight 'regular :width 'regular)
  (set-face-attribute 'fixed-pitch nil :font "Aporetic Sans Mono" :height 1.0 :weight 'regular :width 'regular)
  (set-face-attribute 'variable-pitch nil :family "Aporetic Sans Mono" :height 1.0 :weight 'regular :width 'regular)
  (set-face-attribute 'mode-line nil :font "SauceCodePro Nerd Font Mono" :height 1.0 :weight 'regular)
  (set-face-attribute 'mode-line-active nil :font "SauceCodePro Nerd Font Mono" :height 1.0  :weight 'regular)
  (set-face-attribute 'mode-line-inactive nil :family "SauceCodePro Nerd Font Mono" :height 1.0 :weight 'regular))

(defun prog-mode-buffer-variable ()
  "Intended to set the font in prog mode"
  (interactive)
  (setq buffer-face-mode-face 'fixed-pitch)
  (buffer-face-mode))

(use-package visual-fill-column
  :ensure t
  :hook (org-mode . #'visual-line-fill-column-mode))

;; (add-hook 'text-mode-hook #'variable-pitch-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'org-mode-hook #'variable-pitch-mode)
(add-hook 'prog-mode-hook 'prog-mode-buffer-variable)
(add-hook 'info-mode-hook #'variable-pitch-mode)

(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t
      font-lock-maximum-size nil
      font-lock-support-mode 'jit-lock-mode
      font-lock-multiline t
      jit-lock-stealth 0.5
      jit-lock-defer-contextually t
      jit-lock-stealth-time 16)

(setq x-underline-at-descent-line nil
      inhibit-compacting-font-caches nil)

(defgroup kam-modeline nil
  "My custom modeline."
  :group 'mode-line)

(defgroup kam-modeline-faces nil
  "Faces for my custom modeline."
  :group 'kam-modeline)

(defvar kam-modeline-string-truncate-length 15
  "String length after which truncation should be done in small windows.")

(defface kam-modeline-indicator-button nil
  "Generic face for indicators that have a background.")

(defface kam-modeline-indicator-red
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#880000")
    (((class color) (min-colors 88) (background dark))
     :foreground "#ff9f9f")
    (t :foreground "red"))
  "Face for modeline indicators."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-red-bg
  '((default :inherit (bold kam-modeline-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#aa1111" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#ff9090" :foreground "black")
    (t :background "red" :foreground "black"))
  "Face for modeline indicators with a background."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-green
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#005f00")
    (((class color) (min-colors 88) (background dark))
     :foreground "#73fa7f")
    (t :foreground "green"))
  "Face for modeline indicators."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-yellow
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#6f4000")
    (((class color) (min-colors 88) (background dark))
     :foreground "#f0c526")
    (t :foreground "yellow"))
  "Face for modeline indicators."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-yellow-bg
  '((default :inherit (bold kam-modeline-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#805000" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#ffc800" :foreground "black")
    (t :background "yellow" :foreground "black"))
  "Face for modeline indicators with a background."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-orange
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#6f4000")
    (((class color) (min-colors 88) (background dark))
     :foreground "#f0c526")
    (t :foreground "orange"))
  "Face for modeline indicators."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-orange-bg
  '((default :inherit (bold kam-modeline-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#FFBF00" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#FFBF00" :foreground "black")
    (t :background "orange" :foreground "black"))
  "Face for modeline indicators with a background."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-blue
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#00228a")
    (((class color) (min-colors 88) (background dark))
     :foreground "#88bfff")
    (t :foreground "blue"))
  "Face for modeline indicators."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-blue-bg
  '((default :inherit (bold kam-modeline-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#0000aa" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#77aaff" :foreground "black")
    (t :background "blue" :foreground "black"))
  "Face for modeline indicators with a background."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-magenta
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#6a1aaf")
    (((class color) (min-colors 88) (background dark))
     :foreground "#e0a0ff")
    (t :foreground "magenta"))
  "Face for modeline indicators."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-magenta-bg
  '((default :inherit (bold kam-modeline-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#6f0f9f" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#e3a2ff" :foreground "black")
    (t :background "magenta" :foreground "black"))
  "Face for modeline indicators with a background."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-cyan
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#004060")
    (((class color) (min-colors 88) (background dark))
     :foreground "#30b7cc")
    (t :foreground "cyan"))
  "Face for modeline indicators."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-cyan-bg
  '((default :inherit (bold kam-modeline-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#006080" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#40c0e0" :foreground "black")
    (t :background "cyan" :foreground "black"))
  "Face for modeline indicators with a background."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-gray
  '((t :inherit shadow))
  "Face for modeline indicators."
  :group 'kam-modeline-faces)

(defface kam-modeline-indicator-gray-bg
  '((default :inherit (bold kam-modeline-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#808080" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#a0a0a0" :foreground "black")
    (t :inverse-video t))
  "Face for modeline indicators with a background."
  :group 'kam-modeline-faces)

(defun kam-modeline--string-truncate-p (str)
  "Return non-nil if the string should be truncated."
  (cond
   ((or (not (stringp str))
        (string-empty-p str)
        (string-blank-p str))
    nil)
   ((and (kam-common-window-narrow-p)
         (> (length str) kam-modeline-string-truncate-length)
         (not (one-window-p :no-minibuffer))))))

(defun kam-modeline--truncate-p ()
  "Return non-nil if the truncation should happen."
  (and (kam-common-window-narrow-p)
       (not (one-window-p :no-minibuffer))))

(defun kam-modeline-string-cut-end (str)
  "Return truncated STR, if appropriate, else return non-truncated STR.
Cut off the end of STR by counding from its start up to `kam-modeline-string-truncate-length'."
  (if (kam-modeline--string-truncate-p str)
      (concat (substring str 0 kam-modeline-string-truncate-length) "...")
    str))

(defun kam-modeline-string-cut-beginning (str)
  "Return truncated STR, if appropriate, else return non-truncated STR.
Cut off the beginning of STR by counting from its end up to `kam-modeline-string-truncate-length'."
  (if (kam-modeline--string-truncate-p str)
      (concat "..." (substring str (- kam-modeline-string-truncate-length)))
    str))

(defun kam-modeline-string-cut-middle (str)
  "Return truncated STR, if appropriate, else return non-truncated STR.
Cut off the middle of STR by counting half of `kam-modeline-string-truncate-length' from both its beginning and end."
  (let ((half (floor kam-modeline-string-truncate-length 2)))
    (if (kam-modeline--string-truncate-p str)
        (concat (substring str 0 half) "..." (substring str (- half)))
      str)))

(defun kam-modeline-string-abbreviate-but-last (str nthlast)
  "Abbreviate STR, keeping NTHLAST words intact.
Also see `kam-modeline-string-abbreviate'."
  (if (kam-modeline--string-truncate-p str)
      (let* ((all-strings (split-string str "[_-]"))
             (nbutlast-strings (nbutlast (copy-sequence all-strings) nthlast))
             (last-strings (nreverse (ntake nthlast (nreverse (copy-sequence all-strings)))))
             (first-component (mapconcat #'kam-common-first-char nbutlast-strings "-"))
             (last-component (mapconcat #'identity last-strings "-")))
        (if (string-empty-p first-component)
            last-component
          (concat first-component "-" last-component)))
    str))

(defun kam-modeline-string-abbreviate (str)
  "Abbreviate STR individual hyphen or underscore separated words.
Also see `kam-modeline-string-abbreviate-but-last'."
  (if (kam-modeline--string-truncate-p str)
      (mapconcat #'kam-modeline--first-char (split-string str "[_-]") "-")
    str))

(defun kam-modeline-buffer-lines ()
  "Return how many lines there are in the current buffer."
  (car (buffer-line-statistics)))

(defvar-local kam-modeline-nix
    '(:eval
      (propertize "  " 'face
                  'shadow))
  "Mode line construct to display the NixOS logo.")

(defvar-local kam-modeline-kbd-macro
    '(:eval
      (if (and (mode-line-window-selected-p) defining-kbd-macro)
          (propertize " Recording " 'face 'kam-modeline-indicator-orange-bg)
	    ""))
  "Mode line construct displaying `mode-line-defining-kbd-macro'.
Specific to the current windows mode-line.")

(defvar-local kam-modeline-narrow
    '(:eval
      (if (and (mode-line-window-selected-p)
               (buffer-narrowed-p)
               (not (derived-mode-p 'Info-mode 'help-mode 'special-mode 'message-mode)))
          (propertize " Narrow " 'face 'kam-modeline-indicator-cyan-bg)
	    ""))
  "Mode line construct to report the narrowed state of the current buffer.")

(defvar-local kam-modeline-buffer-status
    '(:eval
      (if (file-remote-p default-directory)
          (propertize " 󰢹 "
                      'face 'kam-modeline-indicator-red-bg
                      'mouse-face 'mode-line-highlight)
	    ""))
  "Mode line construct for showing remote file name.")

(defun kam-modeline-buffer-identification-face ()
  "Return approprite face or face list for `kam-modeline-buffer-identification'."
  (when (mode-line-window-selected-p)
    'mode-line-buffer-id))

(defun kam-modeline--buffer-name ()
  "Return `buffer-name', truncating it if necessary.
See `kam-modeline-string-cut-middle'."
  (when-let* ((name (buffer-name)))
    (kam-modeline-string-cut-middle name)))

(defun kam-modeline-buffer-name ()
  "Return buffer name, with read-only indicator if relevant."
  (let ((name (kam-modeline--buffer-name)))
    (if buffer-read-only
        (format "󱀰 %s" name)
      name)))

(defun kam-modeline-buffer-name-help-echo ()
  "Return `help-echo' value for `kam-modeline-buffer-identification'."
  (concat
   (propertize (buffer-name) 'face 'mode-line-buffer-id)
   "\n"
   (propertize
    (or (buffer-file-name)
        (format "No underlying file.\nDirectory is: %s" default-directory))
    'face 'font-lock-doc-face)))

(defun kam-modeline-buffer-modified ()
  "Return a buffer modified icon if the buffer has been modified."
  (if (buffer-modified-p)
      "󰉉"
    ""))

(defvar-local kam-modeline-buffer-modified
    '(:eval
      (propertize (kam-modeline-buffer-modified)
                  'face 'kam-modeline-indicator-gray
                  'mouse-face 'mode-line-highlight
                  'help-echo (kam-modeline-buffer-name-help-echo)))
  "Mode line construct for displaying the status of buffer modification.")

(defvar-local kam-modeline-buffer-identification
    '(:eval
      (propertize (kam-modeline-buffer-name)
                  'face (kam-modeline-buffer-identification-face)
                  'mouse-face 'mode-line-highlight
                  'help-echo (kam-modeline-buffer-name-help-echo)))
  "Mode line construct for identifying the buffers being displayed.")

(defun kam-modeline-major-mode-indicator ()
  "Return the appropriate propertized mode line indicator for the major mode."
  (let ((indicator (cond
                    ((derived-mode-p 'text-mode) "§")
                    ((derived-mode-p 'prog-mode) "󰘧")
                    ((derived-mode-p 'comint-mode) "󰆍")
                    (t ""))))
    (propertize indicator 'face 'shadow)))

(defun kam-modeline-major-mode-name ()
  "Return capitalized `major-mode' without the -mode suffix."
  (concat
   (nerd-icons-icon-for-mode major-mode)
   " "
   (capitalize
    (string-replace "-mode" "" (symbol-name major-mode)))))

(defun kam-modeline-major-mode-help-echo ()
  "Return `help-echo' value for `kam-modeline-major-mode'."
  (if-let* ((parent (get major-mode 'derived-mode-parent)))
      (format "Symbol: `%s'. Derived from: `%s'" major-mode parent)
    (format "Symbol: `%s'." major-mode)))

(defvar-local kam-modeline-major-mode
    (list
     '(:eval
       (concat
        (kam-modeline-major-mode-indicator)
	    " "
        (propertize
         (kam-modeline-string-abbreviate-but-last
          (kam-modeline-major-mode-name)
          2)
         'mouse-face 'mode-line-highlight
         'help-echo (kam-modeline-major-mode-help-echo)))))
  "Mode line construct for displaying major modes.")

(defun kam-modeline-buffer-line-stats ()
  "Return the propertized mode line indicators for the line stats in the current buffer."
  (concat
   (propertize " " 'face 'shadow)
   (number-to-string (line-number-at-pos))
   ;; (propertize " 󰯲" 'face 'shadow)
   ;; (number-to-string (current-column))
   (propertize " 󱨄" 'face 'shadow)
   (kam-modeline--number-to-string-maybe (kam-modeline--buffer-percentage))
   (propertize " " 'face 'shadow)
   (kam-modeline--buffer-size)))

(defun kam-modeline--buffer-percentage ()
  "Return the percentage of how far through the current buffer the point is."
  (let ((percent (round (* (/
			                (float (line-number-at-pos))
			                (float (kam-modeline-buffer-lines)))
			               100))))
    (cond
     ((= percent 0)
      "Top")
     ((= percent 100)
      "Bot")
     (t percent))))

(defun kam-modeline--number-to-string-maybe (input)
  "If INPUT is a number, turn it into a string.
Or if its a string, keep it as it is."
  (if (natnump input)
      (number-to-string input)
    input))

(defun kam-modeline--buffer-size ()
  "Return the size of the current buffer."
  (upcase (file-size-human-readable (buffer-size))))

(defvar-local kam-modeline-buffer-stats
    '(:eval
      (kam-modeline-buffer-line-stats))
  "Modeline construct for the buffer stats indicator.")

(defvar-local kam-modeline-process
    (list '("" mode-line-process))
  "Mode line construct for the running process indicator.")

(declare-function vc-git--symbolic-ref "vc-git" (file))

(defun kam-modeline--vc-branch-name (file backend)
  "Return capitalized VC branch name for FILE with BACKEND."
  (when-let* ((rev (vc-working-revision file backend))
              (branch (or (vc-git--symbolic-ref file)
                          (substring rev 0 7))))
    (capitalize branch)))

(defun kam-modeline-diffstat (file)
  "Return shortened Git diff numstat for FILE."
  (when-let* ((output (shell-command-to-string (format "git diff --numstat %s"file)))
              (stats (split-string output "[\s\t]" :omit-nulls "[\s\f\t\n\r\v]+"))
              (added (nth 0 stats))
              (deleted (nth 1 stats)))
    (cond
     ((and (equal added "0") (equal deleted "0"))
      "")
     ((and (not (equal added "0")) (equal deleted "0"))
      (propertize (format "+%s" added) 'face 'kam-modeline-indicator-green))
     ((and (equal added "0") (not (equal deleted "0")))
      (propertize (format "-%s" deleted) 'face 'kam-modeline-indicator-red))
     (t
      (concat
       (propertize (format "+%s" added) 'face 'kam-modeline-indicator-green)
       " "
       (propertize (format "-%s" deleted) 'face 'kam-modeline-indicator-red))))))

(declare-function vc-git-working-revision "vc-git" (file))

(defvar kam-modeline-vc-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mode-line down-mouse-1] 'vc-diff)
    (define-key map [mode-line down-mouse-3] 'vc-root-diff)
    map)
  "Keymap used to display a VC indicator.")

(defun kam-modeline--vc-help-echo (file)
  "Return `help-echo' message for FILE tracked by version control."
  (format "Revision: %s\nmouse-1: `vc-diff'\nmouse-3: `vc-root-diff'"
          (vc-git-working-revision file)))

(defun kam-modeline--vc-text (file branch &optional face)
  "Prepare text for Git controlled FILE, given BRANCH.
With optional FACE, use it to propertize BRANCH."
  (concat
   (propertize "" 'face 'shadow)
   " "
   (propertize branch
               'face face
               'mouse-face 'mode-line-highlight
               'help-echo (kam-modeline--vc-help-echo file)
               'local-map kam-modeline-vc-map)
   " "
   (kam-modeline-diffstat file)))

(defun kam-modeline--vc-details (file branch &optional face)
  "Return Git BRANCH details for FILE, truncating it if necessary.
The string is truncated if the width of the window is smaller than `split-width-threshold'."
  (kam-modeline-string-cut-end
   (kam-modeline--vc-text file branch face)))

(defvar kam-modeline--vc-faces
  '((added . vc-locally-added-state)
    (edited . vc-edited-state)
    (removed . vc-removed-state)
    (missing . vc-missing-state)
    (conflict . vc-conflict-state)
    (locked . vc-locked-state)
    (up-to-date . vc-up-to-date-state))
  "VC state faces.")

(defun kam-modeline--vc-get-face (key)
  "Get face from KEY in `kam-modeline--vc-faces'."
  (alist-get key kam-modeline--vc-faces 'up-to-date))

(defun kam-modeline--vc-face (file backend)
  "Return version control state face for FILE with BACKEND."
  (kam-modeline--vc-get-face (vc-state file backend)))

(defvar-local kam-modeline-vc-branch
    '(:eval
      (when-let* (((mode-line-window-selected-p))
                  (file (buffer-file-name))
                  (backend (vc-backend file))
                  ;; ((vc-git-registered file))
                  (branch (kam-modeline--vc-branch-name file backend))
                  (face (kam-modeline--vc-face file backend)))
        (kam-modeline--vc-details file branch face)))
  "Mode line construct to return propertized VC branch.")

(dolist (construct '(kam-modeline-kbd-macro
                     kam-modeline-narrow
                     kam-modeline-buffer-modified
                     kam-modeline-buffer-status
                     kam-modeline-buffer-identification
                     kam-modeline-major-mode
		             kam-modeline-buffer-stats
                     kam-modeline-process
		             kam-modeline-nix
                     kam-modeline-vc-branch))
  (put construct 'risky-local-variable t))

(defun kam-consult-imenu--select (prompt)
  "Returns a selection from `consult-imenu'."
  (let ((items (consult-imenu--items)))
    (consult-imenu--deduplicate items)
    (consult--read
     (or items (user-error "Imenu is empty"))
     :state
     (let* ((preview (consult--jump-preview)))
       `(lambda (action cand)
          (funcall ',preview action (and (markerp (cdr cand)) (cdr cand)))))
     :narrow
     (when-let (narrow (consult-imenu--narrow))
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
       (_ (error "Unknown imenu item: %S" item)))))

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
Used to preselect nearest headings and imenu items.")

(defun kam-consult--set-previous-point (&optional arg1 arg2)
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

(setq project-read-file-name-function #'kam-consult-project-find-file-with-preview)

(defun kam-consult-project-find-file-with-preview (prompt all-files &optional pred hist _mb)
  (let ((prompt (if (and all-files
                         (file-name-absolute-p (car all-files)))
                    prompt
                  (concat prompt
                          (format " in %s"
                                  (consult--fast-abbreviate-file-name default-directory)))))
        (minibuffer-completing-file-name t))
    (consult--read (mapcar
                    (lambda (file)
                      (file-relative-name file))
                    all-files)
                   :state (consult--file-preview)
                   :prompt (concat prompt ": ")
                   :require-match t
                   :history hist
                   :category 'file
                   :predicate pred)))

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
      (consult-outline)
      (setq this-command 'consult-outline)))))

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
        (if (eql kam-org-refile-region-position 'bottom)
            (org-end-of-subtree)
          (org-end-of-meta-data-and-drawers))
        (insert (format kam-org-refile-region-format text))))))

;; (defun kam-org-refile)

(use-package magit
  :ensure t
  :init
  (setq magit-define-global-key-bindings nil)
  :bind
  ("C-x g" . magit-status)
  (:map magit-section-mode-map
        ("C-<tab>" . kam-magit-toggle-parent-section))
  :config
  (setq magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1
        magit-bury-buffer-function 'magit-restore-window-configuration)
  (defun kam-magit-toggle-parent-section ()
    "Toggles the parent section header."
    (interactive)
    (magit-section-up)
    (magit-section-hide-children (magit-section-at))))

(use-package flycheck
  :ensure t
  :custom
  (eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
  (flycheck-indication-mode nil)
  :init
  (defun kam-flycheck-set-margins ()
    "Adjust margin and fringe widths in Flycheck-enabled buffers."
    (setq left-fringe-width 8
          right-fringe-width 8
          left-margin-with 1
          right-margin-width 0))

  ;; (Defun kam-flycheck-eldoc (callback &rest _ignored)
  ;;   "Print flycheck messages at point by calling CALLBACK."
  ;;   (when-let ((flycheck-errors (and flycheck-mode (flycheck-overlay-errors-at (point)))))
  ;;     (mapc
  ;;      (lambda (err)
  ;;        (funcall callback
  ;;                 (format "%s: %s"
  ;;                         (let ((level (flycheck-error-level err)))
  ;;                           (pcase level
  ;;                             ('info (propertize "I" 'face 'flycheck-error-list-info))
  ;;                             ('error (propertize "E" 'face 'flycheck-error-list-error))
  ;;                             ('warning (propertize "W" 'face 'flycheck-error-list-warning))
  ;;                             (_ level)))
  ;;                         (flycheck-error-message err))
  ;;                 :thing (or (flycheck-error-id err)
  ;;                            (flycheck-error-group err))
  ;;                 :face 'font-lock-doc-face))
  ;;      flycheck-errors)))

  ;; (defun kam-flycheck-prefer-eldoc ()
  ;;   (add-hook 'eldoc-documentation-functions #'kam-flycheck-eldoc nil t)
  ;;   (setq eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
  ;;   (setq flycheck-display-errors-function nil)
  ;;   (setq flycheck-help-echo-function nil))

  :hook
  (after-init . #'global-flycheck-mode))
;; (flycheck-mode . kam-flycheck-prefer-eldoc)
;; (flycheck-mode . kam-flycheck-set-margins)

(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(use-package consult-flycheck
  :ensure t)

;; (use-package flyover
;;   :ensure t
;;   ;; :after flycheck
;;   :custom
;;   (flyover-checkers '(flycheck))
;;   (flyover-debounce-interval .1)
;;   (flyover-text-tint nil)
;;   (flyover-line-position-offset 1)
;;   (flyover-show-at-eol t)
;;   (flyover-virtual-line-type nil)
;;   (flyover-show-virtual-line nil)
;;   (flyover-icon-left-padding .9)
;;   (flyover-icon-right-padding .1)
;;   :hook
;;   (flycheck-mode . #'flyover-mode))

(use-package flymake
  :ensure nil
  :config
  (setq flymake-fringe-indicator-position 'left-fringe
        flymake-suppress-zero-counters nil
        flymake-no-changes-timeout nil
        flymake-start-on-flymake-mode nil
        flymake-start-on-save-buffer nil
        flymake-wrap-around t
        flymake-show-diagnostics-at-end-of-line t))

(use-package eglot
  :ensure t
  :init
  ;; (defun kam-eglot-eldoc ()
  ;;   (setq eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly))
  :hook
  (
   ;; (eglot-managed-mode . kam-eglot-eldoc)
   (c-ts-mode . eglot-ensure)
   (python-ts-mode . eglot-ensure))
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

(use-package xref
  :ensure t
  :bind
  ("C-." . #'xref-find-definitions)
  ("M-." . #'xref-find-references)
  :config
  (add-to-list 'xref-after-jump-hook 'pulsar-pulse-line t)
  (add-to-list 'xref-prompt-for-identifier 'xref-find-references t))

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package direnv
  :ensure t
  :config
  (setq direnv-always-show-summary nil)
  (direnv-mode))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package compile
  :ensure nil
  :hook (compilation-filter . ansi-color-compilation-filter)
  :bind (:map compilation-mode-map
	          ("<f5>" . #'recompile)
	          ("<escape>" . #'quit-window))
  :config
  (setq compilation-always-kill t
        compilation-ask-about-save nil
        compilation-scroll-output t
        compilation-max-output-line-length nil
        compilation-scroll-output 'first-error))

(defadvice compile (before ad-compile-smart activate)
  "Advises `compile' so it sets the argument COMINT to t."
  (ad-set-arg 1 t))

(use-package python
  :ensure t
  :defer t
  :custom
  ;; (python-flymake-command '("pyright"))
  (python-indent-guess-indent-offset-verbose nil)
  :hook (python-mode . eglot-ensure))

(use-package go-mode
  :ensure t)

(use-package go-eldoc
  :ensure t
  :hook (go-mode . #'go-eldoc-setup))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode))

(setq ediff-keep-variants nil
      ediff-make-buffers-readonly-at-startup nil
      ediff-merge-revisions-with-ancestor t
      ediff-show-clashes-only t
      ediff-split-window-function 'split-window-horizontally
      ediff-window-setup-function 'ediff-setup-windows-plain)

(global-prettify-symbols-mode)
(put 'narrow-to-region 'disabled nil)

(use-package emms
  :ensure t
  :config
  (require 'emms-setup)
  (require 'emms-mpris)
  (emms-all)
  (emms-default-players)
  (emms-mpris-enable)
  :custom
  (emms-browser-covers #'emms-browser-cache-thumbnail-async))
