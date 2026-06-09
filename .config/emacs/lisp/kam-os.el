;;; kam-os.el --- Extensions to fit Emacs to my operating system -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'kam-common)
(require 'kam-dotfiles)
(require 'kam-timeshift)

(defgroup kam-os ()
  "Extensions to customize Emacs to fit my operating system.")

(defcustom kam-wallpapers-directory "~/Pictures/Wallpapers/"
  "A string representing the default directory for location of wallpapers."
  :type 'string
  :group 'kam-os)

(defcustom kam-dotfiles-installed-packages-file
  (concat kam-dotfiles-directory "installed_packages.txt")
  "A file listing all of the explicitly installed packages on the system."
  :type 'string
  :group 'kam-os)

;;; Arch
(defun kam-os--available-packages ()
  "Return all available packages to install as a list of strings."
  (split-string (shell-command-to-string "pacman -Sl | awk '{print $2}'") "\n"))

(defun kam-os--installed-packages ()
  "Return all installed packages as a list of strings."
  (split-string (shell-command-to-string "pacman -Qq") "\n"))

(defun kam-os--installed-packages-explicitly ()
  "Return all explicitly installed packages as a list of strings."
  (split-string (shell-command-to-string "pacman -Qe | awk '{print $1}'")))

(defun kam-os--list-package-dependencies (packages)
  "Return the dependencies of PACKAGES as a list of strings."
  (shell-command-to-string (concat "expac -S '%D'" packages)))

(defvar kam-package-history nil
  "Minibuffer history for various package related commands.")

(defun kam-os--choose-package (packages)
  "Use `completing-read-multiple' to choose packages out of PACKAGES.
PACKAGES should be a list of strings."
  (let ((default (car kam-package-history)))
    (completing-read-multiple "Choose package(s): "
                              packages
                              #'kam-crm-exclude-selected-p
                              nil nil
                              'kam-package-history
                              default)))

(defun kam-os--write-explicitly-installed-packages-to-file ()
  "Write all explicitly installed packages to `kam-dotfiles-installed-packages-file'."
  (with-current-buffer (find-file-noselect kam-dotfiles-installed-packages-file t)
    (erase-buffer)
    (insert (mapconcat #'identity (kam-os--installed-packages-explicitly) "\n"))
    (save-buffer)))

;;;###autoload
(defun kam-os-package-install ()
  "Install one or multiple system packages using Pacman.
Additionally, save the updated list of installed packages in `kam-dotfiles-installed-packages-file'."
  (interactive)
  (let* ((default-directory "/sudo::")
         (chosen-package (kam-os--choose-package (kam-os--available-packages)))
         (chosen-packages (string-join chosen-package " "))
         (bufname (concat "*Pacman: Install " chosen-packages "*"))
         (shell-command-buffer-name-async bufname))
    (async-shell-command
     (concat "pacman -S " chosen-packages))
    (kam-os--write-explicitly-installed-packages-to-file)
    (pop-to-buffer bufname)))

;;;###autoload
(defun kam-os-package-uninstall ()
  "Remove one or more system packages and all of their unused dependencies.
Additionally, save the updated list of installed packages in `kam-dotfiles-installed-packages-file'."
  (interactive)
  (let* ((default-directory "/sudo::")
         (chosen-package (kam-os--choose-package (kam-os--installed-packages)))
         (chosen-packages (string-join chosen-packages " "))
         (bufname (concat "*Pacman: Uninstall " chosen-packages "*"))
         (shell-command-buffer-name-async bufname))
    (async-shell-command
     "pacman -Rs " chosen-packages)
    (kam-os--write-explicitly-installed-packages-to-file)))

;;;###autoload
(defun kam-os-uninstall-orphan-packages ()
  "Remove all orphaned packages and their configuration files."
  (interactive)
  (let ((default-directory "/sudo::")
        (shell-command-buffer-name-async "*Pacman: Remove Orphan Packages*"))
    (async-shell-command "pacman -Qdtq | pacman -Rns -")
    (kam-os--write-explicitly-installed-packages-to-file)))

;;;###autoload
(defun kam-os-upgrade-system ()
  "Upgrade all of the packages on the system, and also creates a snapshot of the system before the upgrade."
  (interactive)
  (let* ((default-directory "/sudo::")
        (shell-command-buffer-name-async "*Pacman: Upgrade System*"))
    (async-shell-command "pacman -Syu")))

;;;###autoload
(defun kam-os-package-search (package)
  "Search for PACKAGE in the Pacman database."
  (interactive "sPackage to search for: ")
  (async-shell-command
   (concat "pacman -Ss " package)))

;;;###autoload
(defun kam-os-list-installed-packages-by-size (packages)
  (async-shell-command
   (concat "expac -S -H M '%k\t%n'"
           (string-join (kam-pacman--installed-packages) " ")
           "| sort")))

;;;###autoload
(defun kam-os-clear-package-cache ()
  "Clears the old/uninstalled packages in /var/cache/pacman/pkg/."
  (async-shell-command "paccache -r"))

;;;###autoload
(defun kam-os-view-pacman-log-file ()
  "Opens up the Pacman log file to check for errors."
  (interactive)
  (find-file "/var/log/pacman.log"))

(defun kam-arch-wiki-search (topic)
  "Search the Arch wiki for a topic using EWW."
  (interactive "sTopic to search for: ")
  (eww-browse-url
   (concat
    "https://wiki.archlinux.org/title/" topic)))

;;; Power
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
  (cond
   ((eq system-type 'gnu/linux)
    (async-shell-command "systemctl --user restart emacs"))
   ((eq system-type 'darwin)
    (restart-emacs))))

(defun kam-os--get-services ()
  "Return all of the running system services as a list of strings."
  (mapcar (lambda (str)
            (string-trim-right str ".service$"))
   (split-string (shell-command-to-string "systemctl | awk '{print $1}' | grep .service$"))))

(defun kam-os--get-user-services ()
  "Return all of the running user services as a list of strings."
  (mapcar (lambda (str)
            (string-trim-right str ".service$"))
   (split-string (shell-command-to-string "systemctl --user | awk '{print $1}' | grep .service$"))))

(defvar kam-os-service-history nil
  "Minibuffer history for various service related commands.
See `kam-os-service--prompt'.")

(defun kam-os-service--prompt ()
  "Minibuffer prompt for various service related commands.
See `kam-os-restart-service' and `kam-os-stop-service'."
  (let ((default (car kam-os-service-history)))
    (completing-read
     (format "Choose service [%s]: " default)
     (append (kam-os--get-services)
             (kam-os--get-user-services))
     nil nil nil
     'kam-os-service-history
     default)))

(defun kam-os-restart-service (service)
  "Restart running service SERVICE.
SERVICE should be a string that corresponds to a service."
  (interactive (list (kam-os-service--prompt)))
  ;; Check whether the service given is a system or user service
  (if (member service (kam-os--get-services))
      (let ((default-directory "/sudo::"))
        (shell-command (concat "systemctl restart " service)))
    (shell-command (concat "systemctl --user restart " service)))
  (message "Restarted service %s " service))

(defun kam-os-stop-service (service)
  "Stop running service SERVICE.
SERVICE should be a string that corresponds to a service."
  (interactive (list (kam-os-service--prompt)))
  (if (member service (kam-os--get-services))
      (let ((default-directory "/sudo::"))
        (shell-command
         (concat
          "systemctl stop "
          service))
        (shell-command
         (concat
          "systemctl --user stop "
          service))))
  (message "Stopped service %s " service))

;;; Utilities
(defun kam-os-screenshot ()
  "Take a screenshot."
  (interactive)
  (let ((default-directory "~/Pictures/Screenshots/")
        (name (read-string "Name of screenshot: ")))
    (async-shell-command (concat "wayshot -s \"$(slurp)\" -f " (shell-quote-argument name) ".jpg"))))

;;; Hard drive space
(defun kam-os-drive-space ()
  "List all available drive space."
  (interactive)
  (let* ((buf "*Drive Space*")
         (shell-command-buffer-name-async buf))
    (async-shell-command "df -h")
    (with-current-buffer buf
      (view-mode))))

(defun kam-os-list-fonts ()
  "List all of the currently installed fonts on the system."
  (interactive)
  (let* ((buf "*List Fonts*")
         (shell-command-buffer-name buf))
    (shell-command "fc-list")
    (with-current-buffer buf
      (view-mode))))

(defun kam-os-file-size ()
  "List all of the files in the current directory and how much space they take up.
Filter out small files."
  (interactive)
  (let* ((shell-command-buffer-name-async "*Directory Free Space*"))
    (async-shell-command
     "du -cha -d 1 . | sort -h")))

;;; Hyprland
(defvar kam-wallpapers-history nil
  "Minibuffer history for `kam-os-change-wallpaper'.")

(defun kam-os-wallpaper--prompt ()
  "Minibuffer prompt for `kam-os-change-wallpaper.'"
  (let ((default-directory kam-wallpapers-directory)
        (default (nth 1 kam-wallpapers-history)))
    (completing-read
     (format "Wallpaper to change to [%s]: " default)
     #'read-file-name-internal
     nil
     nil
     nil
     'kam-wallpapers-history
     default)))

(defun kam-os-change-wallpaper (wallpaper)
  "Change the default wallpaper to WALLPAPER.
WALLPAPER should be a fully qualified path to an image file."
  (interactive (list
                (expand-file-name (kam-os-wallpaper--prompt) kam-wallpapers-directory)))
  (let* ((file-path (expand-file-name ".config/hypr/hyprpaper.conf" kam-dotfiles-directory))
         (buf (or (get-file-buffer file-path)
                  (find-file-noselect file-path))))
    (with-current-buffer buf
      (goto-char (point-min))
      (search-forward "path = ")
      (kill-line)
      (insert wallpaper)
      (save-buffer)
      (kill-buffer buf))
    (kam-os-restart-service "hyprpaper")))

(provide 'kam-os)
;;; kam-os.el ends here
