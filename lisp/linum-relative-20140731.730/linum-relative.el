;;; linum-relative.el --- display relative line number in emacs.

;; Copyright (c) 2013 Yen-Chin, Lee.
;;
;; Author: coldnew <coldnew.tw@gmail.com>
;; Keywords: converience
;; X-URL: http://github.com/coldnew/linum-relative
;; Version: 20140731.730
;; X-Original-Version: 0.4

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; ![Screenshot](https://github.com/coldnew/linum-relative/raw/master/screenshot/screenshot1.jpg)
;;
;; linum-relative lets you display relative line numbers for current buffer.
;;

;;; Installation:

;; If you have `melpa` and `emacs24` installed, simply type:
;;
;;     M-x package-install linum-relative
;;
;; And add the following to your .emacs
;;
;;     (require 'linum-relative)

;;; Setup & Tips:

;; The non-interactive function *linum-on* (which should already be built into recent GNU Emacs distributions), turns on side-bar line numbering:
;;
;;     (linum-on)
;;
;; and alternatively, by enabling `linum-mode`:
;;
;;     M-x linum-mode
;;
;; Relative line numbering should already be enabled by default (by installing this package), following *linum-on* or enabling *linum-mode*. One can also use the *lineum-relative-toggle* interactive function to switch between relative and non-relative line numbering:
;;
;;     M-x linum-relative-toggle
;;

;;; Code:

(eval-when-compile (require 'cl))
(require 'linum)

(defgroup linum-relative nil
  "Show relative line numbers on fringe."
  :group 'convenience)

;;;; Faces
(defface linum-relative-current-face
  '((t :inherit linum :foreground "#CAE682" :background "#444444" :weight bold))
  "Face for displaying current line."
  :group 'linum-relative)

;;;; Customize Variables

(defcustom linum-relative-current-symbol "0"
  "The symbol you want to show on the current line, by default it is 0.
   You can use any string like \"->\". If this variable is empty string,
linum-releative will show the real line number at current line."
  :type 'string
  :group 'linum-relative)

(defcustom linum-relative-plusp-offset 0
  "Offset to use for positive relative line numbers."
  :type 'integer
  :group 'linum-relative)

(defcustom linum-relative-format "%3s"
  "Format for each line. Good for adding spaces/paddings like so: \" %3s \""
  :type 'string
  :group 'linum-relative)

;;;; Internal Variables

(defvar linum-relative-last-pos 0
  "Store last position.")

;;;; Advices
(defadvice linum-update (before relative-linum-update activate)
  "This advice get the last position of linum."
  (setq linum-relative-last-pos (line-number-at-pos)))

;;;; Functions
(defun linum-relative (line-number)
  (let* ((diff1 (abs (- line-number linum-relative-last-pos)))
         (diff (if (minusp diff1)
                   diff1
                 (+ diff1 linum-relative-plusp-offset)))
         (current-p (= diff linum-relative-plusp-offset))
         (current-symbol (if (and linum-relative-current-symbol current-p)
                             (if (string= "" linum-relative-current-symbol)
                                 (number-to-string line-number)
                               linum-relative-current-symbol)
                           (number-to-string diff)))
         (face (if current-p 'linum-relative-current-face 'linum)))
    (propertize (format linum-relative-format current-symbol) 'face face)))

(defun linum-relative-toggle ()
  "Toggle between linum-relative and linum."
  (interactive)
  (if (eq linum-format 'dynamic)
      (setq linum-format 'linum-relative)
    (setq linum-format 'dynamic)))

(setq linum-format 'linum-relative)

(provide 'linum-relative)
;;; linum-relative.el ends here.
