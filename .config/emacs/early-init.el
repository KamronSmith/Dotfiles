;; -*- lexical-binding: t; -*-
(setopt gc-cons-threshold most-positive-fixnum)
(setopt gc-cons-percentage 0.5)

(setopt load-prefer-newer t)

(setopt frame-resize-pixel-wise t)
(setopt frame-inhibit-implied-resize t)
(setopt default-frame-alist '((fullscreen . maximized)
                              ;; (background-color . "#1e1e1e")
                              (ns-appearance . dark)
                              (ns-transparent-titlebar . t)))
(setopt ring-bell-function 'ignore)
(setopt use-file-dialog nil)
(setopt inhibit-splash-screen t)
(setopt inhibit-startup-screen t)
(setopt inhibit-x-resources t)
(setopt vc-handled-backends '(Git))
(setopt warning-minimum-level :error)
(setopt warning-suppress-types '((lexical-binding)))
(setopt user-lisp-directory "~/.config/emacs/lisp")
(setopt user-init-file "~/.dotfiles/.config/emacs/init.el")

(setopt use-package-enable-imenu-support t)
(setopt use-package-always-demand nil)
(setopt use-package-always-defer t)
(setopt use-package-always-ensure t)

(defun kam-control-keys-setup (frame)
  "Set up the control keys for FRAME that are normally taken by terminal Emacs."
  (with-selected-frame frame
    (when (display-graphic-p)
      (define-key input-decode-map (kbd "C-i") [kam-i])
      (define-key input-decode-map (kbd "C-m") [kam-m])
      (define-key input-decode-map (kbd "C-[") [kam-lsb])
      (define-key input-decode-map (kbd "<escape>") [kam-escape])
      (define-key input-decode-map (kbd "M-<escape>") [kam-m-escape]))))

(defun kam-emacs-startup ()
  "Startup function for Emacs."
  (setopt gc-cons-threshold (* 1000 1000 8))
  (setopt gc-cons-percentage 0.1))

(add-hook 'after-make-frame-functions 'kam-control-keys-setup)
(add-hook 'emacs-startup-hook 'kam-emacs-startup)

(when init-file-debug
  (setopt use-package-verbose t)
  (setopt use-package-expand-minimally nil)
  ;; (setopt use-package-compute-statistics t)
  (setopt debug-on-error t))

(provide 'early-init)
;;; early-init.el ends here
