;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; UI
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
(message "=> lch-ui: loading...")
(require 'lch-key-util)
;;; Fullscreen
(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
       (set-frame-parameter nil 'fullscreen
                            (if (equal 'fullboth current-value)
                                (if (boundp 'old-fullscreen) old-fullscreen nil)
                                (progn (setq old-fullscreen current-value)
                                       'fullboth)))))
(define-key global-map (kbd "<f11> <f11>") 'toggle-fullscreen)

;;; Fill-column-indicator
(require 'fill-column-indicator)
(setq fci-rule-width 1)
(setq fci-rule-color "pink")

(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
;; (global-fci-mode 1)

(define-key global-map (kbd "<f11> f") 'fci-mode)

;;; Rainbow-delimiter
(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)
;;; Maxframe
;; FIXME: Not working under some monitor.
(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)
(autoload 'mf-max-display-pixel-width "maxframe" "" nil)
(autoload 'mf-max-display-pixel-height "maxframe" "" nil)
(autoload 'maximize-frame "maxframe" "" t)
(autoload 'restore-frame "maxframe" "" t)

(when lch-mac-p
  (eval-after-load 'maxframe
    '(progn
       (fset 'maximize-frame 'x-maximize-frame)
       (fset 'restore-frame 'x-restore-frame))))

(when lch-mac-p
  (setq mf-display-padding-width 4
        mf-offset-x 0
        mf-offset-y 0
        mf-display-padding-height (if (when (boundp 'ns-auto-hide-menu-bar)
                                        ns-auto-hide-menu-bar)
                                      23
                                    (+ 27 23))))

(add-hook 'after-make-frame-functions 'maximize-frame)
(add-hook 'after-init-hook 'maximize-frame)

;;; Color-theme
(defvar emacs-theme-dir (concat emacs-lib-dir "/themes"))
(lch-add-subdirs-to-load-path emacs-theme-dir)

(require 'color-theme)
(require 'color-theme-loochao)
(require 'color-theme-lazycat)
(color-theme-lazycat)
(color-theme-loochao)

(define-key global-map (kbd "<f11> <f2>")
  (lambda () (interactive) "" (color-theme-loochao) (message "Color-theme-loochao loaded.")))

(autoload 'color-theme-lazycat "color-theme-lazycat" "" t)
(define-key global-map (kbd "<f11> <f3>")
  (lambda () (interactive) (color-theme-lazycat) (message "Color-theme-lazycat loaded.")))

;;; Fonts
(if lch-linux-p (set-face-attribute 'default nil :height 160))
(when lch-win32-p
  ;; (set-face-attribute 'default nil :height 160)
  (set-default-font "Courier New:pixelsize=24"))
;; (if lch-mac-p (set-default-font "Monaco New:pixelsize=18"))
;;; Tabbar
(require 'tabbar)
(tabbar-mode 1)

(defadvice tabbar-forward (around tabbar-forward-w3m activate)
  ""
  (if (derived-mode-p 'w3m-mode)
      (w3m-next-buffer 1)
    ad-do-it))

(defadvice tabbar-backward (around tabbar-backward-w3m activate)
  ""
  (if (derived-mode-p 'w3m-mode)
      (w3m-previous-buffer 1)
    ad-do-it))

(lch-set-key
 '(("s-h"  . tabbar-backward)
   ("s-l"    . tabbar-forward)
   ("s-7"  . tabbar-backward)
   ("s-8"    . tabbar-forward)
   ("s-9"  . tabbar-backward-group)
   ("s-0"    . tabbar-forward-group))
 tabbar-mode-map)

;;; Linum
;; Have you enabled linum-mode for example? That's famous for slowing everything
;; to a crawl, nlinum-mode is better.

;; (dolist (hook (list
;;                'c-mode-hook
;;                'emacs-lisp-mode-hook
;;                'lisp-interaction-mode-hook
;;                'lisp-mode-hook
;;                'emms-playlist-mode-hook
;;                'java-mode-hook
;;                'asm-mode-hook
;;                'haskell-mode-hook
;;                'rcirc-mode-hook
;;                'emms-lyrics-mode-hook
;;                'erc-mode-hook
;;                'sh-mode-hook
;;                'makefile-gmake-mode-hook
;;                'python-mode-hook
;;                'js2-mode-hook
;;                'js-mode-hook
;;                'html-mode-hook
;;                'css-mode-hook
;;                'apt-utils-mode-hook
;;                'tuareg-mode-hook
;;                'go-mode-hook
;;                'coffee-mode-hook
;;                'qml-mode-hook
;;                'markdown-mode-hook
;;                'slime-repl-mode-hook
;;                'package-menu-mode-hook
;;                'cmake-mode-hook
;;                'php-mode-hook
;;                'web-mode-hook
;;                'coffee-mode-hook
;;                'sws-mode-hook
;;                'jade-mode-hook
;;                'enh-ruby-mode-hook
;;                ))
;;   (add-hook hook (lambda () (linum-mode 1))))

;; Senu
;; line number
;; NOT as good as linum-mode
;; (require 'setnu)
;;; Linum-relative
(autoload 'linum-relative "linum-relative" t)
(define-key global-map (kbd "<f11> L") 'linum-relative-toggle)
;;; Cycle-color
(defun lch-cycle-fg-color (num)
  ""
  (interactive "p")
  (let (colorList colorToUse currentState nextState)
    (setq colorList (list
                     "Black" "MistyRose3"  "Wheat3" "Cornsilk"))
    ;; "Wheat2" "OliveDrab" "YellowGreen"
    (setq currentState (if (get 'lch-cycle-fg-color 'state) (get 'lch-cycle-fg-color 'state) 0))
    (setq nextState (% (+ currentState (length colorList) num) (length colorList)))
    (setq colorToUse (nth nextState colorList))
    (set-frame-parameter nil 'foreground-color colorToUse)
    (redraw-frame (selected-frame))
    (message "Current foreColor is %s" colorToUse)
    (put 'lch-cycle-fg-color 'state nextState)))

(defun lch-cycle-fg-color-forward ()
  "Switch to the next color, in the current frame.
See `cycle-color'."
  (interactive)
  (lch-cycle-fg-color 1))
(define-key global-map (kbd "<f11> 1") 'lch-cycle-fg-color-forward)

;; (defun lch-cycle-fg-color-backward ()
;;   "Switch to the next color, in the current frame.
;; See `cycle-color'."
;;   (interactive)
;;   (lch-cycle-fg-color -1))
;; (define-key global-map (kbd "<f11> 2") 'lch-cycle-fg-color-backward)

(defun lch-cycle-bg-color (num)
  ""
  (interactive "p")
  (let (colorList colorToUse currentState nextState)
    (setq colorList (list
                     "Black" "#fdf6e3" "DarkSeaGreen" "#dca3ac"))
    ;; "DarkSlateGray"
    (setq currentState (if (get 'lch-cycle-bg-color 'state) (get 'lch-cycle-bg-color 'state) 0))
    (setq nextState (% (+ currentState (length colorList) num) (length colorList)))
    (setq colorToUse (nth nextState colorList))
    (set-frame-parameter nil 'background-color colorToUse)
    (redraw-frame (selected-frame))
    (message "Current backColor is %s" colorToUse)
    (put 'lch-cycle-bg-color 'state nextState)))

(defun lch-cycle-bg-color-forward ()
  "Switch to the next color, in the current frame.
See `cycle-color'."
  (interactive)
  (lch-cycle-bg-color 1))
(define-key global-map (kbd "<f11> 2") 'lch-cycle-bg-color-forward)

;; (defun lch-cycle-bg-color-backward ()
;;   "Switch to the next color, in the current frame.
;; See `cycle-color'."
;;   (interactive)
;;   (lch-cycle-bg-color -1))
;; (define-key global-map (kbd "<f11> 4") 'lch-cycle-bg-color-backward)

(defun lch-frame-black ()
  (interactive)
  (set-frame-parameter nil 'foreground-color "MistyRose")
  (set-frame-parameter nil 'background-color "Black")
  (redraw-frame (selected-frame)))
(define-key global-map (kbd "<f11> 3") 'lch-frame-black)

(defun lch-frame-pink ()
  (interactive)
  (set-frame-parameter nil 'foreground-color "black")
  (set-frame-parameter nil 'background-color "#dca3ac")
  (redraw-frame (selected-frame)))
(define-key global-map (kbd "<f11> 4") 'lch-frame-pink)

;;; Winner
(autoload 'winner-mode "winner" t)
(winner-mode 1)
(define-key global-map (kbd "<f11> <left>") 'winner-undo)
(define-key global-map (kbd "<f11> <right>") 'winner-redo)
;;;
(defun lch-adjust-opacity (frame incr)
  (let* ((oldalpha (or (frame-parameter frame 'alpha) 100))
         (newalpha (+ incr oldalpha)))
    (when (and (<= frame-alpha-lower-limit newalpha) (>= 100 newalpha))
      (modify-frame-parameters frame (list (cons 'alpha newalpha))))))

(defun lch-decrease-opacity ()
  (interactive)
  (lch-adjust-opacity nil -2)
  )

(defun lch-increase-opacity ()
  (interactive)
  (lch-adjust-opacity nil 2)
  )

(defun lch-reset-opacity ()
  (interactive)
  (modify-frame-parameters nil `((alpha . 100)))
  )

(global-set-key (kbd "M-C-8") 'lch-decrease-opacity)
(global-set-key (kbd "M-C-9") 'lch-increase-opacity)
(global-set-key (kbd "M-C-0") 'lch-reset-opacity)

;;; Modeline
;; (defun get-lines-4-mode-line ()
;;   "get line numbers of current buffer"
;;   (let ((lines (count-lines
;;                 (point-min) (point-max))))
;;     (format " %dL" lines)))

;; (defun get-size-indication-format ()
;;   (if (and transient-mark-mode mark-active)
;;       (format " (%dLs,%dCs)"
;;               (count-lines (region-beginning) (region-end))
;;               (abs (- (mark t) (point))))
;;     ""))

;; (defun set-mode-line-format ()
;;   "set mode-line-format"
;;   (setq-default mode-line-format
;;                 '((:eval
;;                    (if (eql buffer-read-only t)
;;                        (propertize " --RO--" 'face
;;                                    '(:foreground "Deepskyblue" :family "BN Elements"))
;;                      (propertize " --W/R--" 'face
;;                                  '(:foreground "Deepskyblue" :family "BN Elements"))))
;;                   (:eval
;;                    (propertize " %b"
;;                                'face (if (buffer-modified-p)
;;                                          '(:foreground "SpringGreen" :slant italic)
;;                                        '(:foreground "SpringGreen"))))
;;                   (:eval
;;                    (propertize (get-lines-4-mode-line)
;;                                'face '(:foreground "grey90")))
;;                   (:eval
;;                    (propertize (get-size-indication-format)
;;                                'face '(:foreground "yellow")))
;;                   (:eval
;;                    (propertize " (%l,%c)"
;;                                'face '(:foreground "#00eedd")))
;;                   (:eval
;;                    (propertize " ("
;;                                'face '(:foreground "White")))
;;                   (:eval
;;                    (propertize "%m"
;;                                'face '(:foreground "LightSkyBlue")))
;;                   minor-mode-alist
;;                   (:eval
;;                    (propertize ") "
;;                                'face '(:foreground "White")))
;;                   which-func-format
;;                   (:eval
;;                    (propertize (format-time-string " %H:%M ")
;;                                'face '(:foreground "White")
;;                                'help-echo
;;                                (concat (format-time-string "%c; ")
;;                                        (emacs-uptime "Uptime:%hh")))))))

;; (defun mode-line-setting ()
;;   "setings for modeline"
;;   (set-mode-line-format)
;;   (column-number-mode 1)
;;   ;; display log and buffer name on frame title
;;   (setq frame-title-format
;;         '((:eval
;;            (let ((login-name (getenv-internal "LOGNAME")))
;;              (if login-name (concat login-name "@") "")))
;;           (:eval (system-name))
;;           ":"
;;           (:eval (or (buffer-file-name) (buffer-name))))))

;; (mode-line-setting)

;;; Golden-ratio
;; (require 'golden-ratio)
;; (golden-ratio-mode 1)
;; (lch-diminish golden-ratio-mode " ⊞" " G")

;; (setq golden-ratio-exclude-modes '("one-key-mode"))
;; (setq golden-ratio-exclude-buffer-names '("*Backtrace*" "*One-Key*" "*guide-key*"))
;;; PROVIDE
(provide 'lch-ui)

(message "~~ lch-ui: done.")
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
