;; -*- lexical-binding: t; -*-

(defun kam-arch--available-packages ()
  "Returns all available packages to install as a list of strings."
  (split-string (shell-command-to-string "pacman -Sl | awk '{print $2}'") "\n"))

(defun kam-arch--installed-packages ()
  "Returns all installed packages as a list of strings."
  (split-string (shell-command-to-string "pacman -Qq") "\n"))

(defun kam-arch--installed-packages-explicitly ()
  "Returns all explicitly installed packages as a list of strings."
  (split-string (shell-command-to-string "pacman -Qe | awk '{print $1}'")))

(defun kam-arch--list-package-dependencies (packages)
  "Return the dependencies of PACKAGES as a list of strings."
  (shell-command-to-string (concat "expac -S '%D'" packages)))

(defun kam-arch--choose-package (packages)
  "Use `completing-read-multiple' to choose packages out of PACKAGES.
PACKAGES should be a list of strings."
  (completing-read-multiple "Choose package(s): "
                            packages
                            #'kam-crm-exclude-selected-p))

(defun kam-arch-package-install ()
  "Install one or multiple system packages using Pacman, enhanced with `completing-read-multiple'."
  (interactive)
  (let* ((default-directory "/sudo::")
         (chosen-package (kam-arch--choose-package (kam-arch--available-packages)))
         (chosen-packages (string-join chosen-package " "))
         (bufname (concat "*Pacman: Install " chosen-packages "*"))
         (shell-command-buffer-name-async bufname))
    (async-shell-command
     (concat "pacman -S " chosen-packages))
    (pop-to-buffer bufname)))

(defun kam-arch-package-uninstall ()
  "Remove one or more system packages and all of their unused dependencies, enhanced with `completing-read-multiple'."
  (interactive)
  (let* ((default-directory "/sudo::")
         (chosen-package (kam-arch--choose-package (kam-arch--installed-packages)))
         (chosen-packages (string-join chosen-packages " "))
         (bufname (concat "*Pacman: Uninstall " chosen-packages "*"))
         (shell-command-buffer-name-async bufname))
    (async-shell-command
     "pacman -Rs " chosen-packages)))

(defun kam-arch-uninstall-orphan-packages ()
  "Removes all orphaned packages and their configuration files."
  (interactive)
  (let ((default-directory "/sudo::")
        (shell-command-buffer-name-async "*Pacman: Remove Orphan Packages*"))
    (async-shell-command "pacman -Qdtq | pacman -Rns -")))

(defun kam-arch-upgrade-system ()
  "Upgrade all of the packages on the system, and also creates a snapshot of the system before the upgrade."
  (interactive)
  (let ((default-directory "/sudo::")
        ((shell-command-buffer-name-async "*Pacman: Upgrade System*")))
    (async-shell-command "pacman -Syu")))

(defun kam-arch-package-search (package)
  "Search for a package in the Pacman database."
  (interactive "sPackage to search for: ")
  (async-shell-command
   (concat "pacman -Ss " package)))

(defun kam-arch-list-installed-packages-by-size (packages)
  (async-shell-command
   (concat "expac -S -H M '%k\t%n'"
           (string-join (kam-pacman--installed-packages) " ")
           "| sort")))

(defun kam-arch-clear-package-cache ()
  "Clears the old/uninstalled packages in /var/cache/pacman/pkg/."
  (async-shell-command "paccache -r"))

(defun kam-arch-view-pacman-log-file ()
  "Opens up the Pacman log file to check for errors."
  (interactive)
  (find-file "/var/log/pacman.log"))

(defun kam-arch-wiki-search (topic)
  "Search the Arch wiki for a topic using EWW."
  (interactive "sTopic to search for: ")
  (eww-browse-url
   (concat
    "https://wiki.archlinux.org/title/" topic)))
