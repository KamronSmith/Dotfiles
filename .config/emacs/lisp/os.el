;; -*- lexical-binding: t; -*-

(defvar kam-dotfiles-directory "~/.dotfiles/")

(defvar kam-dotfiles-installed-packages-file
  (concat kam-dotfiles-directory "installed_packages.txt")
  "A list of all the explicitly installed packages on the system.")

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

(defun kam-os--choose-package (packages)
  "Use `completing-read-multiple' to choose packages out of PACKAGES.
PACKAGES should be a list of strings."
  (completing-read-multiple "Choose package(s): "
                            packages
                            #'kam-crm-exclude-selected-p))

(defun kam-os-package-install ()
  "Install one or multiple system packages using Pacman, enhanced with `completing-read-multiple'."
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

(defun kam-os-package-uninstall ()
  "Remove one or more system packages and all of their unused dependencies, enhanced with `completing-read-multiple'."
  (interactive)
  (let* ((default-directory "/sudo::")
         (chosen-package (kam-os--choose-package (kam-os--installed-packages)))
         (chosen-packages (string-join chosen-packages " "))
         (bufname (concat "*Pacman: Uninstall " chosen-packages "*"))
         (shell-command-buffer-name-async bufname))
    (async-shell-command
     "pacman -Rs " chosen-packages)
    (kam-os--write-explicitly-installed-packages-to-file)))

(defun kam-os-uninstall-orphan-packages ()
  "Removes all orphaned packages and their configuration files."
  (interactive)
  (let ((default-directory "/sudo::")
        (shell-command-buffer-name-async "*Pacman: Remove Orphan Packages*"))
    (async-shell-command "pacman -Qdtq | pacman -Rns -")
    (kam-os--write-explicitly-installed-packages-to-file)))

(defun kam-os-upgrade-system ()
  "Upgrade all of the packages on the system, and also creates a snapshot of the system before the upgrade."
  (interactive)
  (let* ((default-directory "/sudo::")
        (shell-command-buffer-name-async "*Pacman: Upgrade System*"))
    (async-shell-command "pacman -Syu")))

(defun kam-os-package-search (package)
  "Search for a package in the Pacman database."
  (interactive "sPackage to search for: ")
  (async-shell-command
   (concat "pacman -Ss " package)))

(defun kam-os-list-installed-packages-by-size (packages)
  (async-shell-command
   (concat "expac -S -H M '%k\t%n'"
           (string-join (kam-pacman--installed-packages) " ")
           "| sort")))

(defun kam-os-clear-package-cache ()
  "Clears the old/uninstalled packages in /var/cache/pacman/pkg/."
  (async-shell-command "paccache -r"))

(defun kam-os-view-pacman-log-file ()
  "Opens up the Pacman log file to check for errors."
  (interactive)
  (find-file "/var/log/pacman.log"))

(defun kam-os--write-explicitly-installed-packages-to-file ()
  "Write all explicitly installed packages to `kam-dotfiles-installed-packages-file'."
  (with-current-buffer (find-file-noselect kam-dotfiles-installed-packages-file t t)
    (erase-buffer)
    (insert (mapconcat #'identity (kam-os--installed-packages-explicitly) "\n"))
    (save-buffer)))

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

;;; Utilities
(defun kam-os-screenshot ()
  "Take a screenshot."
  (interactive)
  (let ((default-directory "~/Pictures/Screenshots/")
        (name (read-string "Name of screenshot: ")))
    (async-shell-command (concat "wayshot -s \"$(slurp)\" -f " (shell-quote-argument name) ".jpg"))))
