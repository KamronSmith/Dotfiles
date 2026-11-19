;;; timeshift.el --- Use Emacs to interact with Timeshift -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(defgroup timeshift ()
  "Extensions to interact with Timeshift on my system."
  :group 'kam-os)

(defun timeshift--snapshot-names ()
  "Return the names of all the snapshots on the system as a list of strings."
  (let ((default-directory "/sudo::"))
    (split-string (shell-command-to-string "timeshift --list | grep \">\" | awk '{print $3}'") "\n")))

(defun timeshift--choose-snapshot ()
  "Choose a snapshot out of a list of all the snapshots on the system."
  (completing-read "Choose a snapshot: "
                   (timeshift--snapshot-names)))

;;;###autoload
(defun timeshift-snapshot-list ()
  "List all snapshots of the system, taken with Timeshift."
  (interactive)
  (let* ((default-directory "/sudo::")
         (bufname "*timeshift: list snapshots*"))
    (with-current-buffer (get-buffer-create bufname)
      (erase-buffer)
      (insert (shell-command-to-string "timeshift --list")))
    (pop-to-buffer bufname)))

;;;###autoload
(defun timeshift-snapshot-create ()
  "Create a snapshot of the system using Timeshift.
If COMMENT, leave a comment on the snapshot."
  (interactive)
  (let* ((default-directory "/sudo::")
        (bufname "*timeshift: create snapshot*")
        (shell-command-buffer-name bufname))
    (with-current-buffer (get-buffer-create bufname)
      (erase-buffer)
      (insert (shell-command-to-string "timeshift --create")))))

;;;###autoload
(defun timeshift-snapshot-delete ()
  "Delete a snapshot of the system."
  (interactive)
  (let ((default-directory "/sudo::")
        (bufname "*timeshift: delete snapshot*")
        (snapshot (timeshift--choose-snapshot)))
    (with-current-buffer (get-buffer-create bufname)
      (erase-buffer)
      (insert (shell-command-to-string
               (concat "timeshift --delete --snapshot " "'" snapshot "'"))))))

;;;###autoload
(defun timeshift-snapshot-restore ()
  "Restore system to snapshot.")

(provide 'timeshift)
;;; timeshift.el ends here
