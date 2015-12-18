;;; lch-powerline-theme
(defun powerline-loochao-theme ()
  "Setup the default mode-line."
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (mode-line (if active 'mode-line 'mode-line-inactive))
                          (face1 (if active 'powerline-active1 'powerline-inactive1))
                          (face2 (if active 'powerline-active2 'powerline-inactive2))
                          (separator-left (intern (format "powerline-%s-%s"
                                                          powerline-default-separator
                                                          (car powerline-default-separator-dir))))
                          (separator-right (intern (format "powerline-%s-%s"
                                                           powerline-default-separator
                                                           (cdr powerline-default-separator-dir))))
                          (lhs (list (powerline-raw "%*" nil 'l)
                                     (powerline-buffer-size nil 'l)
                                     (powerline-raw mode-line-mule-info nil 'l)
                                     (powerline-buffer-id nil 'l)
                                     (when (and (boundp 'which-func-mode) which-func-mode)
                                       (powerline-raw which-func-format nil 'l))
                                     (powerline-raw " ")
                                     (funcall separator-left mode-line face1)
                                     (when (boundp 'erc-modified-channels-object)
                                       (powerline-raw erc-modified-channels-object face1 'l))
                                     (powerline-major-mode face1 'l)
                                     (powerline-process face1)
                                     (powerline-minor-modes face1 'l)
                                     (powerline-narrow face1 'l)
                                     (powerline-raw " " face1)
                                     (funcall separator-left face1 face2)
                                     (powerline-raw (powerline-evil-tag) face2 'l)
                                     ))
                          (rhs (list
                                     (powerline-vc face2 'r)
                                     (funcall separator-right face2 face1)
                                     (powerline-raw " " face1)
                                     (powerline-raw global-mode-string face1 'r)
                                     (funcall separator-right face1 mode-line)
                                     (powerline-raw "%4l" nil 'l)
                                     (powerline-raw ":" nil 'l)
                                     (powerline-raw "%3c" nil 'r)
                                     (powerline-raw " " nil)
                                     (powerline-hud face2 face1)
                                     (powerline-raw " " nil)
                                     (powerline-raw "%6p" nil 'l)
                                     )))
                     (concat (powerline-render lhs)
                             (powerline-fill face2 (powerline-width rhs))
                             (powerline-render rhs)))))))

;;; Powerline
(when (and (>= emacs-major-version 24) (>= emacs-minor-version 3))
   (require 'powerline))
;; (setq powerline-default-separator 'wave)
;; (powerline-evil-theme)

;; (custom-set-faces
;;  `(powerline-evil-normal-face ((t (:foreground "White"  :background "Darkred"))))
;;  `(powerline-evil-insert-face ((t (:foreground "White" :background "#f8b78e"))))
;;  )

;; (defun lch-evil-modeline-change (default-color)
;;   "changes the modeline color when the evil mode changes"
;;   (let ((color (cond ((evil-insert-state-p) '("Darkred" . "#000000"))
;;                      ((evil-insert-state-p) '("#252525" . "#ffffff"))
;;                      ;; ((evil-visual-state-p) '("#282828" . "#ffffff"))
;;                      ;; ((evil-visual-state-p) '("#f8b78e" . "black"))
;;                      ((evil-normal-state-p) default-color)
;;                      (t '("Darkred" . "#ffffff")))))
;;     (set-face-background 'mode-line (car color))
;;     (set-face-foreground 'mode-line (cdr color))))

;; (lexical-let ((default-color (cons (face-background 'mode-line)
;;                                    (face-foreground 'mode-line))))
;;   (add-hook 'post-command-hook (lambda () (lch-evil-modeline-change default-color))))

(powerline-loochao-theme)
(provide 'lch-powerline-theme)
