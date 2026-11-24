;;; kam-mac.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(defgroup kam-mac ()
  "Extensions for use on MacOS."
  :group 'convenience)

;;;###autoload
(defun kam-mac-copy-config-to-config-folder ()
  "Copy the init.el from the .dotfiles folder to the .config/emacs folder."
  (interactive)
  (copy-file
   (expand-file-name ".config/emacs/init.el" kam-dotfiles-directory)
   "/Users/kamronsmith/.config/emacs/init.el"
   t)
  (message "Copied config to emacs directory"))

(provide 'kam-mac)
;;; kam-mac.el ends here
