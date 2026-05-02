;; -*- lexical-binding: t; -*-

(defun kam-timeshift--snapshot-names ()
  "Return the names of all the snapshots on the system as a list of strings."
  (let ((default-directory "/sudo::"))
    (split-string (shell-command-to-string "timeshift --list | grep \">\" | awk '{print $3}'") "\n")))

(defun kam-timeshift--choose-snapshot ()
  "Choose a snapshot out of a list of all the snapshots on the system."
  (completing-read "Choose a snapshot: "
                   (kam-timeshift--snapshot-names)))

(defun kam-timeshift-snapshot-list ()
  "List all snapshots of the system, taken with Timeshift."
  (interactive)
  (let* ((default-directory "/sudo::")
         (bufname "*timeshift: list snapshots*"))
    (with-current-buffer (get-buffer-create bufname)
      (erase-buffer)
      (insert (shell-command-to-string "timeshift --list")))
    (pop-to-buffer bufname)))

(defun kam-timeshift-snapshot-create ()
  "Create a snapshot of the system using Timeshift.
If COMMENT, leave a comment on the snapshot."
  (interactive)
  (let* ((default-directory "/sudo::")
        (bufname "*timeshift: create snapshot*")
        (shell-command-buffer-name bufname))
    (with-current-buffer (get-buffer-create bufname)
      (erase-buffer)
      (insert (shell-command-to-string "timeshift --create")))))

(defun kam-timeshift-snapshot-delete ()
  "Delete a snapshot of the system."
  (interactive)
  (let ((default-directory "/sudo::")
        (bufname "*timeshift: delete snapshot*")
        (snapshot (kam-timeshift--choose-snapshot)))
    (with-current-buffer (get-buffer-create bufname)
      (erase-buffer)
      (insert (shell-command-to-string
               (concat "timeshift --delete --snapshot " "'" snapshot "'"))))))

(defun kam-timeshift-snapshot-restore ()
  "Restore system to snapshot.")
