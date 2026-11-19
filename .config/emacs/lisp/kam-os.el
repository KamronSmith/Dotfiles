;;; kam-os.el --- Extensions to fit Emacs to my operating system -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'kam-common)
(require 'kam-dotfiles)

(defgroup kam-os ()
  "Extensions to customize Emacs to fit my operating system.
And the way I want to use a computer.")

(defcustom kam-home-directory (expand-file-name "~/")
  "Home directory."
  :type 'string
  :group 'kam-os)

(defcustom kam-user-app-data-directory
  (cond ((eq system-type 'gnu/linux)
         (expand-file-name ".local/share" kam-home-directory)))
  "Directory where user-specific application data is stored.")

(defcustom kam-user-bin-directory
  (expand-file-name ".local/bin" kam-home-directory)
  "Directory where user applications are stored.")

(defcustom kam-documents-directory (expand-file-name "~/Documents/")
  "Directory where all of my documents are stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-books-directory (expand-file-name "Books/" kam-documents-directory)
  "Directory where all of my books stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-pictures-directory (expand-file-name "Pictures/" kam-home-directory)
  "Directory where all of my pictures are stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-music-directory (expand-file-name "Music/" kam-home-directory)
  "Directory where all of my music is stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-wallpapers-directory (expand-file-name "Wallpapers/" kam-pictures-directory)
  "Directory where all of my wallpapers are stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-screenshots-directory (expand-file-name "Screenshots/" kam-pictures-directory)
  "Directory where all of my screenshots are stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-videos-directory (expand-file-name "Videos/" kam-home-directory)
  "Directory where all of my videos are stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-projects-directory (expand-file-name "Projects/" kam-home-directory)
  "Directory where all of my projects are stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-archive-directory (expand-file-name "Archive/" kam-home-directory)
  "Directory where all of my archived projects are stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-software-directory (expand-file-name "Software/" kam-home-directory)
  "Directory where all of my downloaded software projects are stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-share-directory (expand-file-name "Share/" kam-home-directory)
  "Directory where I put all of the files meant to be shared with other machines."
  :type 'string
  :group 'kam-os)

(defcustom kam-media-directory "/run/media/kam/"
  "Directory where my external hard drive mounts to."
  :type 'string
  :group 'kam-os)

(defcustom kam-notes-directory
  (expand-file-name "Notes/" kam-documents-directory)
  "Directory where all of my notes are stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-zettelkasten-directory
  (expand-file-name "Zettelkasten/" kam-documents-directory)
  "Directory where my Zettelkasten is stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-trash-directory
  (cond ((eq system-type 'gnu/linux)
         (expand-file-name "Trash" kam-user-app-data-directory))
        ((eq system-type 'darwin)
         (expand-file-name ".Trash" kam-home-directory)))
  "Directory where the system trash can is stored."
  :type 'string
  :group 'kam-os)

(defcustom kam-du-program
  (executable-find "du")
  "String corresponding to the location of du on the system."
  :type 'string
  :group 'kam-os)

(defvar kam-os-required-programs
  `("rg"
    "fd"
    "zsh"
    ,(when (eq system-type 'darwin) "gls")
    ,(when (eq system-type 'darwin) "trash")
    )
  "Programs that this configuration of Emacs depends on.")

(defvar kam-os-required-fonts
  '("Aporetic Sans Mono"
    "Iosevka"
    "JetBrains Mono"
    "IBM Plex Mono"
    "Symbols Nerd Font Mono")
  "Fonts that this configuration of Emacs depends on.")

(defvar kam-os-package-managers
  '((arch . pacman)
    (darwin . brew)
    (parrotos . apt)
    (windows . chocolatey))
  "Alist of operating systems and their associated package managers.")

(defvar kam-os-current-system
  (cond
   ((eq system-type 'darwin)
    'darwin)
   ((and (eq system-type 'gnu/linux)
         (string-equal (shell-command-to-string "uname -s") "Arch"))
    'arch)
   ((and (eq system-type 'gnu/linux)
         (string-equal (shell-command-to-string "uname -s") "Debian"))
    'parrotos)
   (t 'unknown))
  "Determine the operating system this Emacs is currently running on.")

;;; Arch
(defun kam-os--available-packages ()
  "Return all available packages to install as a list of strings."
  (split-string (shell-command-to-string "pacman -Sl | awk '{print $2}'") "\n"))

(defun kam-os--installed-packages ()
  "Return all installed packages as a list of strings."
  (split-string (shell-command-to-string "pacman -Qq") "\n"))

(defun kam-os--installed-packages-explicitly ()
  "Return all explicitly installed packages as a list of strings.
This does not include foreign installed packages, such as the packages installed from the AUR."
  (split-string (shell-command-to-string "pacman -Qneq | awk '{print $1}'")))

(defun kam-os--installed-foreign-packages-explicitly ()
  "Return all explicitly installed foreign packages as a list of strings.
This includes packages from the AUR."
  (split-string (shell-command-to-string "pacman -Qqme | awk '{print $1}'")))

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
  "Write all explicitly installed packages to associated files.
They will be written to `kam-dotfiles-installed-system-packages-file'
and `kam-dotfiles-installed-foreign-packages-file'"
  (with-current-buffer (find-file-noselect kam-dotfiles-installed-system-packages-file t)
    (erase-buffer)
    (insert (mapconcat #'identity (kam-os--installed-packages-explicitly) "\n"))
    (save-buffer)
    (kill-buffer))
  (with-current-buffer (find-file-noselect kam-dotfiles-installed-foreign-packages-file t)
    (erase-buffer)
    (insert (mapconcat #'identity (kam-os--installed-foreign-packages-explicitly) "\n"))
    (save-buffer)
    (kill-buffer)))

;;;###autoload
(defun kam-os-package-install ()
  "Install one or multiple system packages using Pacman.
Additionally, save the updated list of installed packages in `kam-dotfiles-installed-system-packages-file'."
  (interactive)
  (let* ((chosen-package (kam-os--choose-package (kam-os--available-packages)))
         (chosen-packages (string-join chosen-package " "))
         (bufname (concat "*Pacman: Install " chosen-packages "*"))
         (shell-command-buffer-name-async bufname))
    (kam-with-directory "/sudo::"
      (async-shell-command
       (concat "pacman -S " chosen-packages))
      (kam-os--write-explicitly-installed-packages-to-file)
      (pop-to-buffer bufname))))

;;;###autoload
(defun kam-os-package-uninstall ()
  "Remove one or more system packages and all of their unused dependencies.
Additionally, save the updated list of installed packages in `kam-dotfiles-installed-system-packages-file'."
  (interactive)
  (let* ((chosen-package (kam-os--choose-package (kam-os--installed-packages)))
         (chosen-packages (string-join chosen-package " "))
         (bufname (concat "*Pacman: Uninstall " chosen-packages "*"))
         (shell-command-buffer-name-async bufname))
    (kam-with-directory "/sudo::"
      (async-shell-command
       (concat "pacman -Rs " chosen-packages))
      (kam-os--write-explicitly-installed-packages-to-file))))

;;;###autoload
(defun kam-os-uninstall-orphan-packages ()
  "Remove all orphaned packages and their configuration files."
  (interactive)
  (let ((shell-command-buffer-name-async "*Pacman: Remove Orphan Packages*"))
    (kam-with-directory "/sudo::"
      (async-shell-command "pacman -Qdtq | pacman -Rns -")
      (kam-os--write-explicitly-installed-packages-to-file))))

;;;###autoload
(defun kam-os-upgrade-system ()
  "Upgrade all of the packages on the system, and also creates a snapshot of the system before the upgrade."
  (interactive)
  (let* ((shell-command-buffer-name-async "*Pacman: Upgrade System*"))
    (kam-with-directory "/sudo::"
      (async-shell-command "pacman -Syu"))))

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

;;;###autoload
(defun kam-arch-wiki-search (topic)
  "Search the Arch wiki for a topic using EWW."
  (interactive "sTopic to search for: ")
  (eww-browse-url
   (concat
    "https://wiki.archlinux.org/title/" topic)))

;;; Power
;;;###autoload
(defun kam-os-reboot ()
  "Restarts the computer."
  (interactive)
  (async-shell-command "reboot"))

;;;###autoload
(defun kam-os-shutdown ()
  "Shuts down the computer."
  (interactive)
  (async-shell-command "systemctl poweroff"))

;;;###autoload
(defun kam-os-stop-emacs ()
  "Stop the Emacsclient server using Systemd."
  (interactive)
  (kam-os-stop-service "emacs"))

;;;###autoload
(defun kam-os-restart-emacs ()
  "Restart Emacs under a variety of operating system conditions."
  (interactive)
  (cond
   ((and (kam-when-system-type 'gnu/linux t)
         (daemonp))
    (kam-os-restart-service "emacs")
    (run-hooks 'kill-emacs-hook))
   ((kam-when-system-type 'gnu/linux t)
    (restart-emacs))
   ((kam-when-system-type 'darwin t)
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

;;;###autoload
(defun kam-os-restart-service (service)
  "Restart running service SERVICE.
SERVICE should be a string that corresponds to a service."
  (interactive (list (kam-os-service--prompt)))
  ;; Check whether the service given is a system or user service
  (if (member service (kam-os--get-services))
      (let ((default-directory "/sudo::"))
        (async-shell-command (concat "systemctl restart " service)))
    (async-shell-command (concat "systemctl --user restart " service)))
  (message "Restarted service %s " service))

;;;###autoload
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
;;;###autoload
(defun kam-os-screenshot ()
  "Take a screenshot."
  (interactive)
  (let ((default-directory kam-screenshots-directory)
        (name (read-string "Name of screenshot: ")))
    (async-shell-command (concat "grim -g \"$(slurp)\" " (shell-quote-argument name) ".jpg"))))

;;; Hard drive space
;;;###autoload
(defun kam-os-drive-space ()
  "List all available drive space."
  (interactive)
  (let* ((buf "*Drive Space*")
         (shell-command-buffer-name-async buf))
    (async-shell-command "df -h")
    (with-current-buffer buf
      (view-mode))))

(defun kam-du-size (files)
  "Get the combined size of FILES using `kam-du-program'."
  (with-temp-buffer
    (apply 'call-process kam-du-program nil t nil "-sch" files)
    (re-search-backward "\\(^[ 0-9.,]+[A-Za-z]+\\).*total$" nil t)
    (or (ignore-errors (match-string 1)) 0)))

;;;###autoload
(defun kam-os-lsblk ()
  "Run lsblk."
  (interactive)
  (let* ((buf "*Lsblk*")
         (shell-command-buffer-name-async buf))
    (async-shell-command "lsblk")
    (with-current-buffer buf
      (pop-to-buffer buf)
      (view-mode))))

;;;###autoload
(defun kam-os-list-fonts ()
  "List all of the currently installed fonts on the system."
  (interactive)
  (let* ((buf-name "*List Fonts*")
         (buf (get-buffer-create buf-name))
         (fonts (kam-os--list-fonts)))
    (with-current-buffer buf
      (kam-erase-buffer-force)
      (dolist (font fonts)
        (insert (concat font "\n")))
      (pager-mode 1)
      (pop-to-buffer buf))))

(defun kam-os--list-fonts ()
  "Return a list of all the fonts on the system."
  (if (and (fboundp 'x-list-fonts)
           (fboundp 'fontset-list))
      (nconc (butlast (fontset-list))
             (x-list-fonts "*"))))

(defun kam-font-missing-p (font)
  "Return t is font FONT cannot be found."
  (let ((fonts (kam-os--list-fonts)))
    (when (not (seq-some (lambda (x) (string-match-p font x))
                         fonts))
      t)))

(defun kam-check-missing-fonts ()
  "Check for missing fonts in `kam-os-required-fonts'."
  (dolist (font kam-os-required-fonts)
    (when (kam-font-missing-p font)
      (display-warning 'configuration (format "Font %s was not found. This configuration of Emacs depends on %s" font font)))))

(defun kam-missing-executable-p (exe)
  "Determine if executable EXE is missing from PATH.
EXE should be a string that corresponds to an executable."
  (unless (executable-find exe)
    t))

(defun kam-check-missing-executables ()
  "Check for missing executables in `kam-os-required-programs'."
  (dolist (exe kam-os-required-programs)
    (when (kam-missing-executable-p exe)
      (display-warning 'configuration (format "Executable %s was not found in your PATH. This configuation of Emacs depends on %s" exe exe)))))

;;;###autoload
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
  "Minibuffer prompt for `kam-os-change-wallpaper'."
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

;;;###autoload
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

;;; VPN
;;;###autoload
(defun kam-vpn-connect ()
  "Connect to the VPN."
  (interactive)
  (shell-command "mullvad connect"))

;;;###autoload
(defun kam-vpn-disconnect ()
  "Disconnect from the VPN."
  (interactive)
  (shell-command "mullvad disconnect"))

(provide 'kam-os)
;;; kam-os.el ends here
