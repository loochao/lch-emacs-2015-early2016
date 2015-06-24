;; -*- coding:utf-8; -*-
;;; INIT.EL
;;
;; Copyright (c)  Chao LU 2005 2006-2011
;;
;; Author:  Chao Lu <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; License: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Initialization settings

;;; CODE
(message "=> lch-init: loading...")

;; (setq initial-scratch-message "ಠ_ಠ")
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Show lots of *message*.
(setq message-log-max 16384)

;; Parentheses
;; Paren color set in color-theme-lch.el
(when (fboundp 'show-paren-mode)
  (show-paren-mode 1)
  (setq show-paren-delay 0)
  ;; (setq show-paren-style 'expression)
  (setq show-paren-style 'parentheses))

;; Allow pasting selection outside of Emacs
(setq x-select-enable-clipboard t)

;; Smart pairing for all
;; -- automatically insert the other paren.
;; Only works under Emacs24
;; So switch to paredit.el instead.
;; (electric-pair-mode t)

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Frame title
;; that show either a file or a buffer name
(setq frame-title-format
      '("" invocation-name " LooChao - " (:eval (if (buffer-file-name)
                                                    (abbreviate-file-name (buffer-file-name))
                                                  "%b"))))

;; 'y' for 'yes', 'n' for 'no'
(fset 'yes-or-no-p 'y-or-n-p)

;; Don't beep at me
(setq visible-bell t)

;; Don't blink cursor
(when (fboundp 'blink-cursor-mode)
  (blink-cursor-mode (- (*) (*) (*))))

;; Display column & line number
(when (fboundp 'line-number-mode)
  (line-number-mode 1))
(when (fboundp 'column-number-mode)
  (column-number-mode 1))

;; Sever-start
;; Start the emacs server only if another instance of the server is not running.
(require 'server)
(if (eq (server-running-p server-name) nil)
                (server-start))
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

;; enable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;; no split horizontally for wide screen
;; nil: means infinity, so always vertically.
(setq split-width-threshold nil)
;; (setq split-height-threshold nil)

;; enabled change region case commands
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Backup policy
(setq backup-directory-alist '(("" . "~/.emacs.var/backup")))

(setq make-backup-files t
      version-control t
      kept-old-versions 2
      kept-new-versions 5
      delete-old-versions t
      backup-by-copying t
      backup-by-copying-when-linked t
      backup-by-copying-when-mismatch t)

;; If we don't want backup files
;; (setq make-backup-files nil backup-inhibited t)

;; File local variables specifications
;; are obeyed, without query -- RISKY!
(setq enable-local-variables t)

;; obey `eval' variables -- RISKY!
(setq enable-local-eval t)

;; More info:
;; (info "(emacs)Variables")
;; (info "(emacs)Directory Variables")

;; Auto fill
;; Turn on auto-fill mode for all major modes
;; (setq-default auto-fill-function 'do-auto-fill)
;; Lines should be 80 characters wide, not 72

;; There are a lot of opinions on this subject, many people think that this is a
;; vestige of our past, that it's no longer a relevant limitation to impose on
;; ourselves in a world where we regularly have 40" 4K displays to render our
;; text on to. My eyes disagree, though, narrow columns of text are almost
;; always more legible, and certainly working within that constraint makes it
;; much more obvious when you are fucking up asyncronous JavaScript and building
;; callback pyramids. Restructure your code to be longer, not wider, and you're
;; going to make your future self and the future selves of your coworkers much
;; more happy.
(setq-default fill-column 80
              whitespace-line-column 80)

;; Automatically turn on auto-fill-mode when editing text files
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'tex-mode-hook 'turn-on-auto-fill)

;; User info
(setq user-full-name "LooChao<LooChao@gmail.com>")
(setq user-mail-address "LooChao@gmail.com")

;; Death to the tabs!  However, tabs historically indent to the next
;; 8-character offset; specifying anything else will cause *mass*
;; confusion, as it will change the appearance of every existing file.
;; In some cases (python), even worse -- it will change the semantics
;; (meaning) of the program.
;;
;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
;;
;; The settings below can be tested by enable whitespace mode
;; And see what <tab> does. Under the settings below, tab will insert
;; 8 whitespaces instead of a tab, which is nice.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Time setting
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-interval 10)
;; (setq display-time-format "<%V-%u> %m/%d/%H:%M")
(setq display-time-format "%a(%V) %m-%d/%H:%M")
(display-time)

;; Grammar highlight
;; Significant functionality depends on font-locking being active.
;; For all buffers
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; Delete the selection with a keypress
;; Remove text in active region if inserting text
(delete-selection-mode 1)

;; Truncate lines
;; t means aaaaa->
(set-default 'truncate-lines nil)

;; Display picture
(auto-image-file-mode)

;; Auto save
;; Put autosave files (i.e. #foo#) in one place, *NOT*
;; scattered all over the file system!

;; auto-save every 100 input events
(setq auto-save-interval 100)

;; auto-save after 15 seconds idle time
(setq auto-save-timeout 15)

(defvar autosave-dir
  (concat "~/.emacs.var/auto-save-list/" (user-login-name) "/"))
(make-directory autosave-dir t)

(defmacro lch-diminish (mode unicode &optional ascii)
  "Diminish MODE name in mode line to UNICODE or ASCII depending on the value
`dotspacemacs-mode-line-unicode-symbols'.

If ASCII si not provided then UNICODE is used instead."
  (let ((dim (if t
                 unicode
               (if ascii ascii unicode))))
    `(eval-after-load 'diminish '(diminish ',mode ,dim))))

;; I copy something outside of emacs to the clipboard, I switch to emacs, remove
;; the text that I was going to replace with the contents of the clipboard, and
;; then paste the same text that I just removed because removing the text replaced
;; the original clipboard contents.
;; ----
;; However, this seem to create issues like 'Quit, unsupported clipboard-yank'.
;; So disable.
(setq save-interprogram-paste-before-kill nil)
;;; PROVIDE
(provide 'lch-init)
(message "~~ lch-init: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
