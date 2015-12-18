;;-*- coding:utf-8; mode:emacs-lisp; -*-
;;; UTIL
;;
;; Copyright (c) 2006-2013 Charles LU
;;
;; Author:  Charles LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Settings for interface
;;; CODE
(message "=> lch-util: loading...")
;;; Find-all-files
(defun find-all-files (dir)
  "Open all files and sub-directories below the given directory."
  (interactive "DBase directory: ")
  (let* ((list (directory-files dir t "^[^.]"))
         (files (remove-if 'file-directory-p list))
         (dirs (remove-if-not 'file-directory-p list)))
    (dolist (file files)
      (find-file-noselect file))
    (dolist (dir dirs)
      (find-file-noselect dir)
      (find-all-files dir))
    (message "ALL files in %s loaded in background." dir)))
;; (define-key global-map (kbd "C-c f") 'find-all-files)

;;; Strip-blank-lines
(defun strip-blank-lines()
  "Strip all blank lines in select area of buffer,
if not select any area, then strip all blank lines of buffer."
  (interactive)
  (strip-regular-expression-string "^[ \t]*\n")
  (message "Have strip blanks line. Wakaka."))

(define-key global-map (kbd "<f4> s") 'strip-blank-lines)

(defun strip-regular-expression-string (regular-expression)
  "Strip all string that match REGULAR-EXPRESSION in select area of buffer.
If not select any area, then strip current buffer"
  (interactive)
  (let ((begin (point-min))             ;initialization make select all buffer
        (end (point-max)))
    (if mark-active                     ;if have select some area of buffer, then strip this area
        (setq begin (region-beginning)
              end (region-end)))
    (save-excursion                                              ;save position
      (goto-char end)                                            ;goto end position
      (while (and (> (point) begin)                              ;when above beginning position
                  (re-search-backward regular-expression nil t)) ;and find string that match regular expression
        (replace-match "" t t)))))                               ;replace target string with null

;;; Smart-beginning-of-line
(defun lch-smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.
Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.
If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))
  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))
  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))
;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'lch-smarter-move-beginning-of-line)
;;; Enhanced-window-splitting
;; it opens the previous buffer instead of giving me two panes with the same buffer
(defun lch-vsplit-last-buffer (prefix)
  "Split the window vertically and display the previous buffer."
  (interactive "p")
  (split-window-vertically)
  (other-window 1 nil)
  (if (= prefix 1)
    (switch-to-next-buffer)))
(defun lch-hsplit-last-buffer (prefix)
  "Split the window horizontally and display the previous buffer."
  (interactive "p")
  (split-window-horizontally)
  (other-window 1 nil)
  (if (= prefix 1) (switch-to-next-buffer)))
(define-key global-map (kbd "C-x 2") 'lch-vsplit-last-buffer)
(define-key global-map (kbd "C-x 3") 'lch-hsplit-last-buffer)
;;; Persistent-scratch
;; By default, my machine drops me in to a =*scratch*= buffer. Originally designed
;; to be an lisp playground that you could dive right in to on start up, it's sort
;; of eclipsed that for me in to a general purpose buffer, where I will put things
;; like elisp I am prototyping or playtesting, small snippets of code that I want
;; to use in dayjob, etc. But when you kill emacs, or it dies, that buffer
;; disappears. This code will save the Scratch buffer every five minutes and
;; restores it on Emacs startup.
(defvar persistent-scratch-file (concat emacs-var-dir "/emacs-persistent-scratch"))
(defun save-persistent-scratch ()
  "Write the contents of *scratch* to the file name 'Persistent-scratch-file'"
  (with-current-buffer (get-buffer-create "*scratch*")
    (write-region (point-min) (point-max) persistent-scratch-file)))
(defun load-persistent-scracth ()
  (if (file-exists-p persistent-scratch-file)
      (with-current-buffer (get-buffer-create "*scratch*")
        (delete-region (point-min) (point-max))
        (insert-file-contents persistent-scratch-file))))
(push #'load-persistent-scracth after-init-hook)
(push #'save-persistent-scratch kill-emacs-hook)
(run-with-idle-timer 300 t 'save-persistent-scratch)
;;; Invoke-interactives
(define-key global-map (kbd "M-1") 'shell)
(defun lch-term ()
  "Switch to terminal. Launch if nonexistent."
  (interactive)
  (if (get-buffer "*ansi-term*")
      (switch-to-buffer "*ansi-term*")
    (ansi-term "/bin/bash"))
  (get-buffer-process "*ansi-term*"))
(defalias 'tt 'lch-term)
(define-key global-map (kbd "M-2") 'lch-term)
(defun lch-python ()
  (interactive)
  (if (get-buffer "*IPython*")
      (switch-to-buffer "*IPython*")
    (progn
      (ipython)
      (switch-to-buffer "*IPython*")
      (delete-other-windows))))
(define-key global-map (kbd "M-3") 'lch-python)
(defun lch-ruby ()
  (interactive)
  (if (get-buffer "*Ruby*")
      (switch-to-buffer "*Ruby*")
    (if (yes-or-no-p "Start Ruby?") (inf-ruby))))
(define-key global-map (kbd "M-4") 'lch-ruby)
(defun lch-matlab ()
  (interactive)
      (if (get-buffer "*MATLAB*")
          (switch-to-buffer "*MATLAB*")
        (if (yes-or-no-p "Start Matlab?") (matlab-shell))))
(define-key global-map (kbd "M-5") 'lch-matlab)
(defun lch-R ()
  (interactive)
  (if (get-buffer "*R*")
      (switch-to-buffer "*R*")
    (if (yes-or-no-p "Start R?") (R))))
(define-key global-map (kbd "M-6") 'lch-R)
(defun lch-mathematica ()
  (interactive)
      (if (get-buffer "*Mathematica*")
          (switch-to-buffer "*Mathematica*")
        (if (yes-or-no-p "Start Mathematica?")
            (mathematica))))
(define-key global-map (kbd "M-7") 'lch-mathematica)
;; Named-term
;; What I do when I need more than one terminal Then I just name one: since the
;; default one is supposed to be named *ansi-term*, if I create one named
;; e.g. *jekyll*, it will be ignored by dired-open-term. This is exactly what I
;; want, since I just create named terminals for long running processes like
;; jekyll serve. And I can switch to the named terminals with just
;; ido-switch-buffer. Here is the very simple code:
(defun lch-named-term (name)
  (interactive "sName: ")
  (ansi-term "/bin/bash" name))
;; (defun lch-create-switch-term ()
;;   (interactive)
;;   (if (not (get-buffer "*ansi-term*"))
;;       (ansi-term "/usr/texbin/bash")
;;     (switch-to-buffer "*ansi-term*")))
;; (define-key global-map (kbd "M-2") 'lch-create-switch-term)
;;; View-clipboard
(defun view-clipboard ()
  (interactive)
  (switch-to-buffer "*Clipboard*")
  (let ((inhibit-read-only t))
    (erase-buffer)
    (clipboard-yank)
    (goto-char (point-min))
    (html-mode)
    (view-mode)))
(define-key global-map (kbd "C-z v") 'view-clipboard)
;;; Punctuation-substitution
(defun lch-punctuate (pct)
  "pct:(a b); sub all the a in buffer with b"
  (save-excursion
    (goto-char (point-min))
    (while (search-forward (car pct) nil t)
      (replace-match (cadr pct) nil t)))
  )
(defvar lch-punctuate-list
  '(("。" ". ") ("，" ", ") ("；" ";") ("、" ". ")
    ("“" "\"") ("”" "\"") ("（" "(") ("）" ")")
    ("【" "[") ("】" "]") ("《" "<") ("》" ">")
    ("…" "...") ("～" "~") ("——" "--")
    ("：" ":") ("！" "!") ("？" "?") ("　" " ")
    ("〈" "<") ("〉" ">") ("「" "'") ("」" "'")
    ("１" "1") ("２" "2") ("３" "3") ("４" "4") ("５" "5")
    ("６" "6") ("７" "7") ("８" "8") ("９" "9") ("０" "0")
    ("－" "-")
    ))
(defun lch-punctuate-buffer ()
  (interactive)
  (mapc 'lch-punctuate lch-punctuate-list))
(define-key global-map (kbd "<f4> p") 'lch-punctuate-buffer)
;;; Interaction-with-macosx
(defun lch-open-ppt-icon ()
   (interactive)
   (setq apscript
         "
          tell app \"Microsoft Powerpoint\"
            open \"~/Dropbox/PPTNotes/iCon.pptx\"
            activate
          end tell
         "
         )
   (do-applescript apscript)
   )
;; Open-remotes-with-finder
(defun lch-open-libns-finder ()
  "Make iTunes either pause or play"
  ;; tell app \"Finder\" to open location \"afp://loochao@loochao.synology.me:/LIBNS/\"

  (interactive)
  (setq apscript
        "
         tell app \"Finder\" to open location \"afp://loochao@10.0.0.14:/LIBNS/\"
         activate
        "
        )
  (do-applescript apscript)
  )
(defun lch-open-libns-web-finder ()
  "Make iTunes either pause or play"
  (interactive)
  (setq apscript
        "
         tell app \"Finder\" to open location \"afp://loochao@loochao.synology.me:/web/\"
         activate
        "
        )
  (do-applescript apscript)
  )
(defun lch-open-pu-finder ()
  "Make iTunes either pause or play"
  (interactive)
  (setq apscript
        "
         tell app \"Finder\" to open location \"smb://chaol@files.princeton.edu:/chaol/Scan\"
         activate
        "
        )
  (do-applescript apscript)
  )
;; Open-with-textmate
(defun lch-open-with-mate ()
  (interactive)
  (shell-command (format "mate %s" (buffer-file-name))))
(define-key global-map (kbd "<f1> o") 'lch-open-with-mate)
;; Start-file-browser
(defun lch-start-file-browser ()
  "Open current pwd with file browser.
   Currently, just work under Mac OSX."
  (interactive)
  (let (mydir)
    (setq mydir (pwd))
    (string-match "Directory " mydir)
    (setq mydir (replace-match "" nil nil mydir 0))
    (when lch-mac-p (shell-command (format "open -a Finder %s" mydir)))
    ))
(define-key global-map (kbd "<f9> <f9>") 'lch-start-file-browser)
;; Start-terminal
(defun lch-start-terminal ()
  "Open current pwd with terminal.
   Currently, just work under Mac OSX."
  (interactive)
  (let (mydir)
    (setq mydir (pwd))
    (string-match "Directory " mydir)
    (setq mydir (replace-match "" nil nil mydir 0))
    (when lch-mac-p
      (do-applescript
       (format
        "tell application \"Terminal\"
activate
do script \"cd '%s'; bash \"
end tell" mydir)))
    ))
(define-key global-map (kbd "<f1> t") 'lch-start-terminal)
(define-key global-map (kbd "<f1> <f2>") 'lch-start-terminal)
;;; Buffer-editing
(defun lch-indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))
(defun lch-clear-empty-lines ()
  (interactive)
  (let ((line (buffer-substring (point-at-bol) (point-at-eol))))
    (when (string-match "^ +$" line)
      (delete-region (point-at-bol) (point-at-eol)))))
(defun lch-indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indented selected region."))
      (progn
        (lch-indent-buffer)
        (message "Indented buffer.")))))
(define-key global-map (kbd "C-c i") 'lch-indent-region-or-buffer)
(defun lch-indent-defun ()
  "Indent the current defun."
  (interactive)
  (save-excursion
    (mark-defun)
    (indent-region (region-beginning) (region-end))))
(defun lch-untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))
(defun lch-cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (lch-indent-buffer)
  (lch-untabify-buffer)
  (whitespace-cleanup)
  (message "Buffer is cleaned. No tab, no whitespace. With correct indentation."))
(define-key global-map (kbd "<f4> c") 'lch-cleanup-buffer)
;;; Sudo-edit
(defun lch-sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))
(define-key global-map (kbd "C-c C-f") 'lch-sudo-edit)
;;; Buffer-operation
(defun lch-copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))
(define-key global-map (kbd "<f4> 3") 'lch-copy-file-name-to-clipboard)
(defun lch-rename-file-and-buffer ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (cond ((get-buffer new-name)
               (message "A buffer named '%s' already exists!" new-name))
              (t
               (rename-file name new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)))))))
(define-key global-map (kbd "<f4> r") 'lch-rename-file-and-buffer)
(defun lch-delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when (and filename (y-or-n-p "Will DELETE current file, are you sure?"))
      (if (vc-backend filename)
          (vc-delete-file filename)
        (progn
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))
(define-key global-map (kbd "<f4> d") 'lch-delete-file-and-buffer)
;; Another definition of delete current buffer and file.
;; ----
;; (defun delete-this-file ()
;;   "Delete the current file, and kill the buffer."
;;   (interactive)
;;   (or (buffer-file-name) (error "No file is currently being edited"))
;;   (when (yes-or-no-p (format "Really delete '%s'?"
;;                              (file-name-nondirectory buffer-file-name)))
;;     (delete-file (buffer-file-name))
;;     (kill-this-buffer)))
;;; Kill-buffer
(defun kill-current-mode-buffers ()
  "Kill all buffers that major mode same with current mode."
  (interactive)
  (kill-special-mode-buffers-internal major-mode))
(defun kill-current-mode-buffers-except-current ()
  "Kill all buffers that major mode same with current mode.
And don't kill current buffer."
  (interactive)
  (kill-special-mode-buffers-internal major-mode t))
(defun kill-special-mode-buffers ()
  "Kill all buffers that major mode that user given."
  (interactive)
  (let (mode-list)
    (dolist (element (buffer-list))
      (set-buffer element)
      (unless (member (symbol-name major-mode) mode-list)
        (add-to-ordered-list 'mode-list (symbol-name major-mode))))
    (kill-special-mode-buffers-internal (intern-soft (completing-read "Mode: " mode-list)))))
(defun kill-org-mode-buffers ()
  (interactive)
  (kill-special-mode-buffers-internal 'org-mode))
(defun kill-special-mode-buffers-internal (mode &optional except-current-buffer)
  "Kill all buffers that major MODE same with special.
If option EXCEPT-CURRENT-BUFFER is `non-nil',
kill all buffers with MODE except current buffer."
  (interactive)
  (let ((current-buf (current-buffer))
        (count 0))
    (dolist (buffer (buffer-list))
      (set-buffer buffer)
      (when (and (equal major-mode mode)
                 (or (not except-current-buffer)
                     (not (eq current-buf buffer))))
        (incf count)
        (kill-buffer buffer)))
    (message "Killed %s buffer%s" count (if (> count 1) "s" ""))))
(defun kill-all-buffers-except-current ()
  "Kill all buffers except current buffer."
  (interactive)
  (let ((current-buf (current-buffer)))
    (dolist (buffer (buffer-list))
      (set-buffer buffer)
      (unless (eq current-buf buffer)
        (kill-buffer buffer)))))
(defun kill-all-buffers ()
  "kill all buffers, leaving *scratch* only"
  (interactive)
  (mapcar (lambda (x) (kill-buffer x))
          (buffer-list))
  (delete-other-windows))
(defvar one-key-menu-kill-alist nil
  "The `one-key' menu alist for KILL.")
(setq one-key-menu-kill-alist
      '(
        (("M-k" . "kill-all-buffers") . kill-all-buffers)
        (("a" . "kill-all-buffers-except-current") . kill-all-buffers-except-current)
        (("m" . "kill-current-mode-buffers") . kill-current-mode-buffers)
        (("M" . "kill-current-mode-buffers-except-current") . kill-current-mode-buffers-except-current)
        (("o" . "kill-org-mode-buffers") . kill-org-mode-buffers)
        (("s" . "kill-special-mode-buffers") . kill-special-mode-buffers)
        ))
(defun one-key-menu-kill ()
  "The `one-key' menu for KILL."
  (interactive)
  (one-key-menu "KILL" one-key-menu-kill-alist t))
(define-key global-map (kbd "M-k") 'one-key-menu-kill)
;;; Lch-emacs-tips
(defvar lch-tips
  '(
    "Press M-f1 <=>  Access Emacs help system M-<f1> (one-key-menu-help)"
    "Press M-6  <=>  to switch between erc buffers"
    "Press M-/  <=>  to do dabbrev-expand"
    "Press M--  <=>  to apply thing edit functions"
    "<f1> <f1>  <=>  to list all the fn-fn functions"
    "o in dired <=>  to open every file by default associated application"
    "<f12> i    <=>  controls information of the song shown or not, on modeline"
    "<f1> f     <=>  cowsay fortunes, nice to learn English~"
    "<f1> c     <=>  clean buffer out of space, tab, and bad indentation."
    "<fn> num   <=>  Open the mode related directories."
    "C-h u      <=>  Unbound keys"
    "! @dired   <=>  Add marked file to emms playlist."
    "C-6 combines to different functions under diff mode."
    "Visit WikEmacs at http://wikemacs.org to find out even more about Emacs."
    "Open up simple.el and check out all nice functions in there. -- ffap simple"
    "/ m in dired to get file filtering, like C-<f12> in TC."
    "<f9s>: remote-notes; <f9> m: org-notes; <f10s> dirs; <f10> m: emacs-conf"
    "Don't forget there's hexview and eperiodic!"))
(defun lch-tip-of-the-day ()
  "Display a random entry from `lch-tips'."
  (interactive)
  ;; pick a new random seed
  (random t)
  (message
   (concat "Tip: " (nth (random (length lch-tips)) lch-tips))))
(define-key global-map (kbd "<f1> /") 'lch-tip-of-the-day)
;;; Try-to-switch-buffer
(defun try-to-switch-buffer (name)
  "Just switch to buffer when found some buffer named NAME."
  (if (get-buffer name)
      (switch-to-buffer name)
    (message "Haven't found buffer named `%s`." name)))
;;; Prettyfy-string
;; used in w3m-search-advance
(defun prettyfy-string (string &optional after)
  "Strip starting and ending whitespace and pretty `STRING'.
Replace any chars after AFTER with '...'.
Argument STRING the string that need pretty."
  (let ((replace-map (list
                      (cons "^[ \t]*" "")
                      (cons "[ \t]*$" "")
                      (cons (concat "^\\(.\\{"
                                    (or (number-to-string after) "10")
                                    "\\}\\).*")
                            "\\1..."))))
    (dolist (replace replace-map)
      (when (string-match (car replace) string)
        (setq string (replace-match (cdr replace) nil nil string))))
    string))
;;; Eval-buffer
(defun lch-eval-buffer ()
  (interactive)
  (eval-buffer)
  (message "%s: EVALED" (buffer-name (current-buffer))))
(define-key global-map (kbd "C-c e") 'lch-eval-buffer)
;;; Create-switch-scratch/message
(defun lch-create-switch-scratch ()
  (interactive)
  (let ((buf (get-buffer "*scratch*")))
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (when (null buf)
      (lisp-interaction-mode))))
(define-key global-map (kbd "C-c s") 'lch-create-switch-scratch)
(defun lch-switch-to-message ()
  (interactive)
  (switch-to-buffer (get-buffer "*Messages*")))
;; "/" means system output.
(define-key global-map (kbd "C-c /") 'lch-switch-to-message)
;;; Face-at-point
(defun lch-face-at-point (pos)
  "Return the name of the face at point"
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))
(define-key global-map (kbd "<f11> F") 'lch-face-at-point)
;;; Add-exec-permission-to-script
(defun lch-chmod-x ()
  (and (save-excursion
         (save-restriction
           (widen)
           (goto-char (point-min))
           (save-match-data
             (looking-at "^#!"))))
       (not (file-executable-p buffer-file-name))
       (if (= 0 (shell-command (concat "chmod u+x " buffer-file-name)))
           (message
            (concat "Saved as script: " buffer-file-name)))))
(add-hook 'after-save-hook 'lch-chmod-x)
;;; Display-fortune
(defun lch-echo-fortune ()
  (interactive)
  (message (shell-command-to-string "fortune")))
(define-key global-map (kbd "C-z f") 'lch-echo-fortune)
;;  (run-with-timer 3 nil (message "")))
;;; PROVIDE
(provide 'lch-util)
(message "~~ lch-util: done.")
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
