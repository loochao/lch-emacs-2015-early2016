;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; DIRED
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Charles LU
;;
;; Author:  Charles LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Settings for dired

;;; CODE
(message "=> lch-dired: loading...")

(require 'dired)
(require 'lch-key-util)
(require 'dired-extension-wux)
(require 'dired-extension)                             ;; Lazycat version
(require 'dired-tar)
(require 'dired+)
(require 'dired-details)

(setq dired-recursive-copies t)
(setq dired-recursive-copies 'always)                  ;; No ask when copying recursively.
(setq dired-recursive-deletes t)
(setq dired-recursive-deletes 'always)                 ;; No ask when delete recursively.

(setq dired-use-ls-dired nil)
(toggle-dired-find-file-reuse-dir 1)                   ;; From dired+
(setq dired-details-hidden-string "[ ... ] ")
(setq dired-listing-switches "-aluh")                  ;; Parameters passed to ls
(setq directory-free-space-args "-Pkh")                ;; Options for space
(setq dired-omit-size-limit nil)                       ;; Number of file omitted

;;; Dired-lisps
;; Dired-x
;; dired-x is part of GNU Emacs
;; enable some really cool extensions like C-x C-j(dired-jump)
(require 'dired-x)
(define-key global-map (kbd "C-6") 'dired-jump)

;; Dired-single
(require 'dired-single)
(define-key global-map (kbd "C-<f9>") 'dired-single-magic-buffer)

;; Wdired
;; wdired is Part of GNU Emacs.
(require 'wdired)
(define-key dired-mode-map "w" 'wdired-change-to-wdired-mode)

;; Dired view
;; Jump to a file by typing that filename's first character.
(require 'dired-view)

;; Dired sort
(require 'dired-sort)
;; Directory ahead of files
(add-hook 'dired-after-readin-hook
          '(lambda ()
             (progn
               (require 'dired-extension)
               (dired-sort-method))))

(setq one-key-menu-dired-sort-alist
      '(
        (("a" . "All/Hidden") . dired-omit-mode)
        (("s" . "Size") . dired-sort-size)
        ;; (("x" . "Extension") . dired-sort-extension)        ;; Does not work with mac
        (("n" . "Name") . dired-sort-name)
        (("t" . "Modified Time") . dired-sort-time)
        (("u" . "Access Time") . dired-sort-utime)
        (("c" . "Create Time") . dired-sort-ctime)))

(defun one-key-menu-dired-sort ()
  "The `one-key' menu for DIRED-SORT."
  (interactive)
  (require 'one-key)
  (require 'dired-sort)
  (one-key-menu "DIRED-SORT" one-key-menu-dired-sort-alist nil))

;; Omit
(setq my-dired-omit-status t)                          ;; 设置默认忽略文件
(setq my-dired-omit-regexp "^\\.?#\\|^\\..*")          ;; 设置忽略文件的匹配正则表达式
(setq my-dired-omit-extensions '(".cache"))            ;; 设置忽略文件的扩展名列表

(add-hook 'dired-mode-hook '(lambda ()
                              (progn
                                (require 'dired-extension)
                                (dired-omit-method))))
;; Terminal
(define-key dired-mode-map (kbd "`") 'dired-open-term)
(defun dired-open-term ()
  "Open an `ansi-term' that corresponds to current directory."
  (interactive)
  (let ((current-dir (dired-current-directory)))
    (term-send-string
     (terminal)
     (if (file-remote-p current-dir)
         (let ((v (tramp-dissect-file-name current-dir t)))
           (format "ssh %s@%s\n"
                   (aref v 1) (aref v 2)))
       (format "cd '%s'\n" current-dir)))))

;;; Utils
(defun dired-open-mac ()
  (interactive)
  (let ((file-name (dired-get-file-for-visit)))
    (if (file-exists-p file-name)
        (call-process "/usr/bin/open" nil 0 nil file-name))))
(when lch-mac-p
  (define-key dired-mode-map "o" 'dired-open-mac))

(defun dired-up-directory-single ()
  "Return up directory in single window.
When others visible window haven't current buffer, kill old buffer after `dired-up-directory'.
Otherwise, just `dired-up-directory'."
  (interactive)
  (let ((old-buffer (current-buffer))
        (current-window (selected-window)))
    (dired-up-directory)
    (catch 'found
      (walk-windows
       (lambda (w)
         (with-selected-window w
           (when (and (not (eq current-window (selected-window)))
                      (equal old-buffer (current-buffer)))
             (throw 'found "Found current dired buffer in others visible window.")))))
      (kill-buffer old-buffer))))
(define-key dired-mode-map "'" 'dired-up-directory-single)
(define-key dired-mode-map (kbd "C-6") 'dired-up-directory-single)

;;; Color-by-ext
(let ((cmd "dircolors")
      (s "'no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.flv=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:';"
         ))
  (when (and (executable-find cmd)
             (zerop (shell-command (concat "TERM=xterm-color " cmd))))
    (setq s (shell-command-to-string cmd)))

  (setq xwl-dircolors-string
        (replace-regexp-in-string ":$" "" (cadr (split-string s "'")))))

;; colored by file extensions
(setq xwl-dircolors-extensions
      (split-string
       (replace-regexp-in-string
        "=[0-9;]+\\|\\*\\." ""
        (replace-regexp-in-string "^[^*]*" "" xwl-dircolors-string))
       ":"))

(defun xwl-dircolors-get-escape-seq (regexp)
  "Get escape-seq by matching REGEXP against `xwl-dircolors-string'.
e.g., (xwl-dircolors-get-escape-seq \"*.gz\") => \"01;31\""
  (string-match (concat regexp "=\\([^:]+\\);\\([^:]+\\):") xwl-dircolors-string)
  (concat (match-string 2 xwl-dircolors-string) ";" (match-string 1 xwl-dircolors-string)))

(setq dired-font-lock-keywords
      `(
        ;;
        ;; Directory headers.
        ,(list dired-subdir-regexp '(1 dired-header-face))
        ;;
        ;; Dired marks.
        ,(list dired-re-mark '(0 dired-mark-face))
        ;;
        ;; We make heavy use of MATCH-ANCHORED, since the regexps don't identify the
        ;; file name itself.  We search for Dired defined regexps, and then use the
        ;; Dired defined function `dired-move-to-filename' before searching for the
        ;; simple regexp ".+".  It is that regexp which matches the file name.
        ;;
        ;; Marked files.
        ,(list (concat "^[" (char-to-string dired-marker-char) "]")
               '(".+" (dired-move-to-filename) nil (0 dired-marked-face)))
        ;;
        ;; Flagged files.
        ,(list (concat "^[" (char-to-string dired-del-marker) "]")
               '(".+" (dired-move-to-filename) nil (0 dired-flagged-face)))
        ;; People who are paranoid about security would consider this more
        ;; important than other things such as whether it is a directory.
        ;; But we don't want to encourage paranoia, so our default
        ;; should be what's most useful for non-paranoids. -- rms.
  ;; ;;
  ;; ;; Files that are group or world writable.
  ;; (list (concat dired-re-maybe-mark dired-re-inode-size
  ;;             "\\([-d]\\(....w....\\|.......w.\\)\\)")
  ;;        '(1 dired-warning-face)
  ;;        '(".+" (dired-move-to-filename) nil (0 dired-warning-face)))
        ;; However, we don't need to highlight the file name, only the
        ;; permissions, to win generally.  -- fx.
        ;; Fixme: we could also put text properties on the permission
        ;; fields with keymaps to frob the permissions, somewhat a la XEmacs.
        ,(list (concat dired-re-maybe-mark dired-re-inode-size
                       "[-d]....\\(w\\)....") ; group writable
               '(1 dired-warning-face))
        ,(list (concat dired-re-maybe-mark dired-re-inode-size
                       "[-d].......\\(w\\).") ; world writable
               '(1 dired-warning-face))
        ;;
        ;; Subdirectories.
        ,(list dired-re-dir
               '(".+" (dired-move-to-filename) nil (0 dired-directory-face)))
        ;;
        ;; Symbolic links.
        ,(list dired-re-sym
               '(".+" (dired-move-to-filename) nil (0 dired-symlink-face)))

        ;; executables
        ,(list dired-re-exe
               `(".+"
                 (dired-move-to-filename)
                 nil
                 (0 (ansi-color--find-face
                           (ansi-color-parse-sequence ,(xwl-dircolors-get-escape-seq "ex"))))))

        ;; colorful by extensions
        ,@(mapcar (lambda (ext)
                    `(,(format ".*\\.%s$" ext)
                      (".+"
                       (dired-move-to-filename)
                       nil
                       (0 (ansi-color--find-face
                           (ansi-color-parse-sequence ,(xwl-dircolors-get-escape-seq ext)))))))
                  xwl-dircolors-extensions)

        ;;
        ;; Files suffixed with `completion-ignored-extensions'.
        (eval .
              ;; It is quicker to first find just an extension, then go back to the
              ;; start of that file name.  So we do this complex MATCH-ANCHORED form.
              (list (concat "\\(" (regexp-opt completion-ignored-extensions) "\\|#\\)$")
                    '(".+" (dired-move-to-filename) nil (0 dired-ignored-face))))
        ;;
        ;; Files suffixed with `completion-ignored-extensions'
        ;; plus a character put in by -F.
        (eval .
              (list (concat "\\(" (regexp-opt completion-ignored-extensions)
                            "\\|#\\)[*=|]$")
                    '(".+" (progn
                             (end-of-line)
                             ;; If the last character is not part of the filename,
                             ;; move back to the start of the filename
                             ;; so it can be fontified.
                             ;; Otherwise, leave point at the end of the line;
                             ;; that way, nothing is fontified.
                             (unless (get-text-property (1- (point)) 'mouse-face)
                               (dired-move-to-filename)))
                      nil (0 dired-ignored-face))))))

;;; Keymap
(lch-set-key
 '((";"              . dired-view-minor-mode-toggle)
   ("?"              . dired-get-size)
   ("f"              . dired-single-buffer)
   ("<return>"       . dired-single-buffer)
   ("<RET>"          . dired-single-buffer)
   ("<down-mouse-1>" . dired-single-buffer)

   ("E"              . emms-add-dired)

   ("/*"             . dired-mark-files-regexp)
   ("/m"             . dired-filter-regexp)
   ("/."             . dired-filter-extension)
   ("C-<f12>"        . dired-filter-extension)

   ("s"              . one-key-menu-dired-sort)
   ("v"              . dired-x-find-file)
   ("V"              . dired-view-file)
   ("j"              . dired-next-line)
   ("J"              . dired-goto-file)
   ("k"              . dired-previous-line)
   ("K"              . dired-do-kill-lines)

   ("r"              . wdired-change-to-wdired-mode)
   ("T"              . dired-tar-pack-unpack)
   )
 dired-mode-map)
;;; PROVIDE
(provide 'lch-dired)
(message "~~ lch-dired: done.")


;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
