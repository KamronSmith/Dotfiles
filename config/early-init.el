(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

(setq load-prefer-newer t)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 1000 1000 8)
                  gc-cons-percentage 0.1)))

(setq frame-resize-pixel-wise t
      frame-inhibit-implied-resize t
      default-frame-alist '((fullscreen . maximized)
                            ;; (background-color . "#1e1e1e")
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t))
      ring-bell-function 'ignore
      use-file-dialog nil
      inhibit-splash-screen t
      inhibit-startup-screen t
      inhibit-x-resources t)

(setq use-package-enable-imenu-support t)

(add-hook 'after-make-frame-functions
	  (defun setup-control-keys (frame)
	    "Sets up the control keys that are normally taken by terminal Emacs."
	    (with-selected-frame frame
	      (when (display-graphic-p)
		(define-key input-decode-map (kbd "C-i") [kam-i])
		(define-key input-decode-map (kbd "C-m") [kam-m])
		(define-key input-decode-map (kbd "C-[") [kam-lsb])))))
