;; -*- lexical-binding: t; -*-

(defvar kam-dotfiles-directory
  (concat (getenv "HOME")
          "/.dotfiles/"))

(defun kam-dotfiles-stow ()
  "Run stow in the dotfiles directory."
  (interactive)
  (let ((default-directory kam-dotfiles-directory))
    (shell-command "stow .")))

(provide 'dotfiles-mode)
;;; dotfiles-mode.el ends here
