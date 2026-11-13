;;; kam-dotfiles.el --- Extensions to manage my dotfiles -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(defgroup kam-dotfiles ()
  "Extensions for Emacs to manage my dotfiles."
  :group 'kam-os)

(defcustom kam-dotfiles-directory
  (expand-file-name ".dotfiles/" (getenv "HOME"))
  "A string representing where the dotfiles are to be stored."
  :type 'string
  :group 'kam-dotfiles)

(defcustom kam-dotfiles-installed-system-packages-file
  (expand-file-name "packages/arch_system_packages.txt" kam-dotfiles-directory)
  "A file listing all of the explicitly installed packages on the system."
  :type 'string
  :group 'kam-os)

(defcustom kam-dotfiles-installed-foreign-packages-file
  (expand-file-name "packages/arch_foreign_packages.txt" kam-dotfiles-directory)
  "A file listing all of the explicitly installed foreign packages on the system."
  :type 'string
  :group 'kam-os)

;;;###autoload
(defun kam-dotfiles-restow (&optional arg)
  "Run stow -R in `kam-dotfiles-directory'.
With optional ARG, force update Emacs byte-compiled files."
  (interactive "p")
  (let ((default-directory kam-dotfiles-directory))
    (shell-command "stow -R ."))
  (when arg
    (prepare-user-lisp nil nil t)))

;;;###autoload
(defun kam-dotfiles-stow (&optional arg)
  "Run stow in `kam-dotfiles-directory'.
With optional ARG, force update Emacs byte-compiled files."
  (interactive "p")
  (let ((default-directory kam-dotfiles-directory))
    (shell-command "stow ."))
  (when arg
    (prepare-user-lisp nil nil t)))

(provide 'kam-dotfiles)
;;; kam-dotfiles.el ends here
