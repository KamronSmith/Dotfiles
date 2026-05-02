;;; kam-dotfiles.el --- Extensions to manage my dotfiles -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:

(defgroup kam-dotfiles ()
  "Extensions for Emacs to manage my dotfiles."
  :group 'kam-os)

(defcustom kam-dotfiles-directory
  (concat (getenv "HOME")
          "/.dotfiles/")
  "A string representing where the dotfiles are to be stored."
  :type 'string
  :group 'kam-dotfiles)

(defun kam-dotfiles-stow ()
  "Run stow in the dotfiles directory."
  (interactive)
  (let ((default-directory kam-dotfiles-directory))
    (shell-command "stow .")))

(provide 'kam-dotfiles)
;;; kam-dotfiles.el ends here
